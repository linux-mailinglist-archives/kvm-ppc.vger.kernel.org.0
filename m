Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272E35A5A6
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 Jun 2019 22:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfF1UIr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 Jun 2019 16:08:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727059AbfF1UIr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 Jun 2019 16:08:47 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SK6pgh088817;
        Fri, 28 Jun 2019 16:08:42 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tdqe84tak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jun 2019 16:08:41 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5SK6sgI016452;
        Fri, 28 Jun 2019 20:08:40 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 2t9by7qqkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jun 2019 20:08:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5SK8c7P62914982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 20:08:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE9947805F;
        Fri, 28 Jun 2019 20:08:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 164CE7805C;
        Fri, 28 Jun 2019 20:08:36 +0000 (GMT)
Received: from rino.br.ibm.com (unknown [9.18.235.108])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jun 2019 20:08:35 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: [PATCH v4 3/8] KVM: PPC: Ultravisor: Add generic ultravisor call handler
Date:   Fri, 28 Jun 2019 17:08:20 -0300
Message-Id: <20190628200825.31049-4-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628200825.31049-1-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280230
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

Add the ucall() function, which can be used to make ultravisor calls
with varied number of in and out arguments. Ultravisor calls can be made
from the host or guests.

This copies the implementation of plpar_hcall().

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[ Change ucall.S to not save CR, rename and move headers, build ucall.S
  if CONFIG_PPC_POWERNV set, use R3 for the ucall number and add some
  comments in the code ]
Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
---
 arch/powerpc/include/asm/ultravisor-api.h | 20 +++++++++++++++
 arch/powerpc/include/asm/ultravisor.h     | 20 +++++++++++++++
 arch/powerpc/kernel/Makefile              |  2 +-
 arch/powerpc/kernel/ucall.S               | 30 +++++++++++++++++++++++
 arch/powerpc/kernel/ultravisor.c          |  4 +++
 5 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
 create mode 100644 arch/powerpc/kernel/ucall.S

diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
new file mode 100644
index 000000000000..49e766adabc7
--- /dev/null
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Ultravisor API.
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+#ifndef _ASM_POWERPC_ULTRAVISOR_API_H
+#define _ASM_POWERPC_ULTRAVISOR_API_H
+
+#include <asm/hvcall.h>
+
+/* Return codes */
+#define U_NOT_AVAILABLE		H_NOT_AVAILABLE
+#define U_SUCCESS		H_SUCCESS
+#define U_FUNCTION		H_FUNCTION
+#define U_PARAMETER		H_PARAMETER
+
+#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
+
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index e5009b0d84ea..a78a2dacfd0b 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -8,8 +8,28 @@
 #ifndef _ASM_POWERPC_ULTRAVISOR_H
 #define _ASM_POWERPC_ULTRAVISOR_H
 
+#include <asm/ultravisor-api.h>
+
+#if !defined(__ASSEMBLY__)
+
 /* Internal functions */
 extern int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 					 int depth, void *data);
 
+/* API functions */
+#define UCALL_BUFSIZE 4
+/**
+ * ucall: Make a powerpc ultravisor call.
+ * @opcode: The ultravisor call to make.
+ * @retbuf: Buffer to store up to 4 return arguments in.
+ *
+ * This call supports up to 6 arguments and 4 return arguments. Use
+ * UCALL_BUFSIZE to size the return argument buffer.
+ */
+#if defined(CONFIG_PPC_POWERNV)
+long ucall(unsigned long opcode, unsigned long *retbuf, ...);
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
 #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f0caa302c8c0..f28baccc0a79 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -154,7 +154,7 @@ endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
-obj-$(CONFIG_PPC_POWERNV)	+= ultravisor.o
+obj-$(CONFIG_PPC_POWERNV)	+= ultravisor.o ucall.o
 
 # Disable GCOV, KCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
diff --git a/arch/powerpc/kernel/ucall.S b/arch/powerpc/kernel/ucall.S
new file mode 100644
index 000000000000..1678f6eb7230
--- /dev/null
+++ b/arch/powerpc/kernel/ucall.S
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Generic code to perform an ultravisor call.
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+#include <asm/ppc_asm.h>
+
+/*
+ * This function is based on the plpar_hcall()
+ */
+_GLOBAL_TOC(ucall)
+	std	r4,STK_PARAM(R4)(r1)	/* Save ret buffer */
+	mr	r4,r5
+	mr	r5,r6
+	mr	r6,r7
+	mr	r7,r8
+	mr	r8,r9
+	mr	r9,r10
+
+	sc 2				/* Invoke the ultravisor */
+
+	ld	r12,STK_PARAM(R4)(r1)
+	std	r4,  0(r12)
+	std	r5,  8(r12)
+	std	r6, 16(r12)
+	std	r7, 24(r12)
+
+	blr				/* Return r3 = status */
diff --git a/arch/powerpc/kernel/ultravisor.c b/arch/powerpc/kernel/ultravisor.c
index dc6021f63c97..02ddf79a9522 100644
--- a/arch/powerpc/kernel/ultravisor.c
+++ b/arch/powerpc/kernel/ultravisor.c
@@ -8,10 +8,14 @@
 #include <linux/init.h>
 #include <linux/printk.h>
 #include <linux/string.h>
+#include <linux/export.h>
 
 #include <asm/ultravisor.h>
 #include <asm/firmware.h>
 
+/* in ucall.S */
+EXPORT_SYMBOL_GPL(ucall);
+
 int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
 					 int depth, void *data)
 {
-- 
2.20.1

