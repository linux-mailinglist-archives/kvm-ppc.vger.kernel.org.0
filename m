Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D539221E7C
	for <lists+kvm-ppc@lfdr.de>; Thu, 16 Jul 2020 10:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGPIdB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 16 Jul 2020 04:33:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727095AbgGPIdA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 16 Jul 2020 04:33:00 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G8WLoA119505;
        Thu, 16 Jul 2020 04:32:46 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32792x0rq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:32:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06G8Uhus016837;
        Thu, 16 Jul 2020 08:32:32 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 327527wcsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 08:32:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06G8WTVn65339696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 08:32:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66526A4053;
        Thu, 16 Jul 2020 08:32:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7867AA4051;
        Thu, 16 Jul 2020 08:32:26 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jul 2020 08:32:26 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com, aik@ozlabs.ru
Subject: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO access, in sprg0 register
Date:   Thu, 16 Jul 2020 01:32:13 -0700
Message-Id: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_04:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007160063
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

An instruction accessing a mmio address, generates a HDSI fault.  This fault is
appropriately handled by the Hypervisor.  However in the case of secureVMs, the
fault is delivered to the ultravisor.

Unfortunately the Ultravisor has no correct-way to fetch the faulting
instruction. The PEF architecture does not allow Ultravisor to enable MMU
translation. Walking the two level page table to read the instruction can race
with other vcpus modifying the SVM's process scoped page table.

This problem can be correctly solved with some help from the kernel.

Capture the faulting instruction in SPRG0 register, before executing the
faulting instruction. This enables the ultravisor to easily procure the
faulting instruction and emulate it.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 arch/powerpc/include/asm/io.h | 85 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 635969b..7ef663d 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -35,6 +35,7 @@
 #include <asm/mmu.h>
 #include <asm/ppc_asm.h>
 #include <asm/pgtable.h>
+#include <asm/svm.h>
 
 #define SIO_CONFIG_RA	0x398
 #define SIO_CONFIG_RD	0x399
@@ -105,34 +106,98 @@
 static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
 	u##size ret;							\
-	__asm__ __volatile__("sync;"#insn" %0,%y1;twi 0,%0,0;isync"	\
-		: "=r" (ret) : "Z" (*addr) : "memory");			\
+	if (is_secure_guest()) {					\
+		__asm__ __volatile__("mfsprg0 %3;"			\
+				"lnia %2;"				\
+				"ld %2,12(%2);"				\
+				"mtsprg0 %2;"				\
+				"sync;"					\
+				#insn" %0,%y1;"				\
+				"twi 0,%0,0;"				\
+				"isync;"				\
+				"mtsprg0 %3"				\
+			: "=r" (ret)					\
+			: "Z" (*addr), "r" (0), "r" (0)			\
+			: "memory");					\
+	} else {							\
+		__asm__ __volatile__("sync;"				\
+				#insn" %0,%y1;"				\
+				"twi 0,%0,0;"				\
+				"isync"					\
+			: "=r" (ret) : "Z" (*addr) : "memory");		\
+	}								\
 	return ret;							\
 }
 
 #define DEF_MMIO_OUT_X(name, size, insn)				\
 static inline void name(volatile u##size __iomem *addr, u##size val)	\
 {									\
-	__asm__ __volatile__("sync;"#insn" %1,%y0"			\
-		: "=Z" (*addr) : "r" (val) : "memory");			\
-	mmiowb_set_pending();						\
+	if (is_secure_guest()) {					\
+		__asm__ __volatile__("mfsprg0 %3;"			\
+				"lnia %2;"				\
+				"ld %2,12(%2);"				\
+				"mtsprg0 %2;"				\
+				"sync;"					\
+				#insn" %1,%y0;"				\
+				"mtsprg0 %3"				\
+			: "=Z" (*addr)					\
+			: "r" (val), "r" (0), "r" (0)			\
+			: "memory");					\
+	} else {							\
+		__asm__ __volatile__("sync;"				\
+				#insn" %1,%y0"				\
+			: "=Z" (*addr) : "r" (val) : "memory");         \
+		mmiowb_set_pending();					\
+	}								\
 }
 
 #define DEF_MMIO_IN_D(name, size, insn)				\
 static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
 	u##size ret;							\
-	__asm__ __volatile__("sync;"#insn"%U1%X1 %0,%1;twi 0,%0,0;isync"\
-		: "=r" (ret) : "m" (*addr) : "memory");			\
+	if (is_secure_guest()) {					\
+		__asm__ __volatile__("mfsprg0 %3;"			\
+				"lnia %2;"				\
+				"ld %2,12(%2);"				\
+				"mtsprg0 %2;"				\
+				"sync;"					\
+				#insn"%U1%X1 %0,%1;"			\
+				"twi 0,%0,0;"				\
+				"isync;"				\
+				"mtsprg0 %3"				\
+			: "=r" (ret)					\
+			: "m" (*addr), "r" (0), "r" (0)			\
+			: "memory");					\
+	} else {							\
+		__asm__ __volatile__("sync;"				\
+				#insn"%U1%X1 %0,%1;"			\
+				"twi 0,%0,0;"				\
+				"isync"					\
+			: "=r" (ret) : "m" (*addr) : "memory");         \
+	}								\
 	return ret;							\
 }
 
 #define DEF_MMIO_OUT_D(name, size, insn)				\
 static inline void name(volatile u##size __iomem *addr, u##size val)	\
 {									\
-	__asm__ __volatile__("sync;"#insn"%U0%X0 %1,%0"			\
-		: "=m" (*addr) : "r" (val) : "memory");			\
-	mmiowb_set_pending();						\
+	if (is_secure_guest()) {					\
+		__asm__ __volatile__("mfsprg0 %3;"			\
+				"lnia %2;"				\
+				"ld %2,12(%2);"				\
+				"mtsprg0 %2;"				\
+				"sync;"					\
+				#insn"%U0%X0 %1,%0;"			\
+				"mtsprg0 %3"				\
+			: "=m" (*addr)					\
+			: "r" (val), "r" (0), "r" (0)			\
+			: "memory");					\
+	} else {							\
+		__asm__ __volatile__("sync;"				\
+				#insn"%U0%X0 %1,%0"			\
+			: "=m" (*addr) : "r" (val) : "memory");		\
+		mmiowb_set_pending();					\
+	}								\
 }
 
 DEF_MMIO_IN_D(in_8,     8, lbz);
-- 
1.8.3.1

