Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9F989F8
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Aug 2019 05:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfHVDtA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Aug 2019 23:49:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728348AbfHVDtA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Aug 2019 23:49:00 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7M3kc0A148533;
        Wed, 21 Aug 2019 23:48:56 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uhj6qj5t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 23:48:55 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7M3iQ73011780;
        Thu, 22 Aug 2019 03:48:55 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 2ue976kgf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 03:48:55 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7M3mruK40174040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 03:48:53 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 115B0C6055;
        Thu, 22 Aug 2019 03:48:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86D45C6057;
        Thu, 22 Aug 2019 03:48:49 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.80.203.17])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 03:48:49 +0000 (GMT)
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
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: [PATCH v6 2/7] powerpc/kernel: Add ucall_norets() ultravisor call handler
Date:   Thu, 22 Aug 2019 00:48:33 -0300
Message-Id: <20190822034838.27876-3-cclaudio@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822034838.27876-1-cclaudio@linux.ibm.com>
References: <20190822034838.27876-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220037
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The ultracalls (ucalls for short) allow the Secure Virtual Machines
(SVM)s and hypervisor to request services from the ultravisor such as
accessing a register or memory region that can only be accessed when
running in ultravisor-privileged mode.

This patch adds the ucall_norets() ultravisor call handler.

The specific service needed from an ucall is specified in register
R3 (the first parameter to the ucall). Other parameters to the
ucall, if any, are specified in registers R4 through R12.

Return value of all ucalls is in register R3. Other output values
from the ucall, if any, are returned in registers R4 through R12.

Each ucall returns specific error codes, applicable in the context
of the ucall. However, like with the PowerPC Architecture Platform
Reference (PAPR), if no specific error code is defined for a particular
situation, then the ucall will fallback to an erroneous
parameter-position based code. i.e U_PARAMETER, U_P2, U_P3 etc depending
on the ucall parameter that may have caused the error.

Every host kernel (powernv) needs to be able to do ucalls in case it
ends up being run in a machine with ultravisor enabled. Otherwise, the
kernel may crash early in boot trying to access ultravisor resources,
for instance, trying to set the partition table entry 0. Secure guests
also need to be able to do ucalls and its kernel may not have
CONFIG_PPC_POWERNV=y. For that reason, the ucall.S file is placed under
arch/powerpc/kernel.

If ultravisor is not enabled, the ucalls will be redirected to the
hypervisor which must handle/fail the call.

Thanks to inputs from Ram Pai and Michael Anderson.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

---
Ultravisor call support for secure guests is being proposed as part of
the patchset "Secure Virtual Machine Enablement" posted by Thiago
Bauermann.
---
 arch/powerpc/include/asm/asm-prototypes.h | 11 +++++++++++
 arch/powerpc/include/asm/ultravisor-api.h | 23 +++++++++++++++++++++++
 arch/powerpc/kernel/Makefile              |  1 +
 arch/powerpc/kernel/ucall.S               | 14 ++++++++++++++
 4 files changed, 49 insertions(+)
 create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
 create mode 100644 arch/powerpc/kernel/ucall.S

diff --git a/arch/powerpc/include/asm/asm-prototypes.h b/arch/powerpc/include/asm/asm-prototypes.h
index ec1c97a8e8cb..e698f48cbc6d 100644
--- a/arch/powerpc/include/asm/asm-prototypes.h
+++ b/arch/powerpc/include/asm/asm-prototypes.h
@@ -15,6 +15,7 @@
 #include <asm/epapr_hcalls.h>
 #include <asm/dcr.h>
 #include <asm/mmu_context.h>
+#include <asm/ultravisor-api.h>
 
 #include <uapi/asm/ucontext.h>
 
@@ -34,6 +35,16 @@ extern struct static_key hcall_tracepoint_key;
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args);
 void __trace_hcall_exit(long opcode, long retval, unsigned long *retbuf);
 
+/* Ultravisor */
+#ifdef CONFIG_PPC_POWERNV
+long ucall_norets(unsigned long opcode, ...);
+#else
+static inline long ucall_norets(unsigned long opcode, ...)
+{
+	return U_NOT_AVAILABLE;
+}
+#endif
+
 /* OPAL */
 int64_t __opal_call(int64_t a0, int64_t a1, int64_t a2, int64_t a3,
 		    int64_t a4, int64_t a5, int64_t a6, int64_t a7,
diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
new file mode 100644
index 000000000000..88ffa78f9d61
--- /dev/null
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -0,0 +1,23 @@
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
+#define U_FUNCTION		H_FUNCTION
+#define U_NOT_AVAILABLE		H_NOT_AVAILABLE
+#define U_P2			H_P2
+#define U_P3			H_P3
+#define U_P4			H_P4
+#define U_P5			H_P5
+#define U_PARAMETER		H_PARAMETER
+#define U_SUCCESS		H_SUCCESS
+
+#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ea0c69236789..c6c4ea240b2a 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -156,6 +156,7 @@ endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
+obj-$(CONFIG_PPC_POWERNV)	+= ucall.o
 
 # Disable GCOV, KCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
diff --git a/arch/powerpc/kernel/ucall.S b/arch/powerpc/kernel/ucall.S
new file mode 100644
index 000000000000..07296bc39166
--- /dev/null
+++ b/arch/powerpc/kernel/ucall.S
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Generic code to perform an ultravisor call.
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+#include <asm/ppc_asm.h>
+#include <asm/export.h>
+
+_GLOBAL(ucall_norets)
+EXPORT_SYMBOL_GPL(ucall_norets)
+	sc	2	/* Invoke the ultravisor */
+	blr		/* Return r3 = status */
-- 
2.20.1

