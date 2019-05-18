Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABC4223A7
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 May 2019 16:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfEROZq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 May 2019 10:25:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40568 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727594AbfEROZp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 18 May 2019 10:25:45 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4IEGZLK016309
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:44 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sjbns4hb7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 18 May 2019 10:25:44 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 18 May 2019 15:25:43 +0100
Received: from b03cxnp08028.gho.boulder.ibm.com (9.17.130.20)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 18 May 2019 15:25:40 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4IEPc4824052186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 May 2019 14:25:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DE1978063;
        Sat, 18 May 2019 14:25:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C457F7805C;
        Sat, 18 May 2019 14:25:35 +0000 (GMT)
Received: from rino.ibm.com (unknown [9.85.168.40])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 18 May 2019 14:25:35 +0000 (GMT)
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc:     Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [RFC PATCH v2 03/10] powerpc: Introduce FW_FEATURE_ULTRAVISOR
Date:   Sat, 18 May 2019 11:25:17 -0300
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518142524.28528-1-cclaudio@linux.ibm.com>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051814-8235-0000-0000-00000E9900AE
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011118; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01205121; UDB=6.00632701; IPR=6.00986061;
 MB=3.00026948; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-18 14:25:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051814-8236-0000-0000-0000459E04F5
Message-Id: <20190518142524.28528-4-cclaudio@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180103
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This feature tells if the ultravisor firmware is available to handle
ucalls.

Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
[Device node name to "ibm,ultravisor"]
Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
---
 arch/powerpc/include/asm/firmware.h   |  5 +++--
 arch/powerpc/include/asm/ultravisor.h | 15 +++++++++++++++
 arch/powerpc/kernel/Makefile          |  1 +
 arch/powerpc/kernel/prom.c            |  6 ++++++
 arch/powerpc/kernel/ultravisor.c      | 26 ++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/include/asm/ultravisor.h
 create mode 100644 arch/powerpc/kernel/ultravisor.c

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 00bc42d95679..43b48c4d3ca9 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -54,6 +54,7 @@
 #define FW_FEATURE_DRC_INFO	ASM_CONST(0x0000000800000000)
 #define FW_FEATURE_BLOCK_REMOVE ASM_CONST(0x0000001000000000)
 #define FW_FEATURE_PAPR_SCM 	ASM_CONST(0x0000002000000000)
+#define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -72,9 +73,9 @@ enum {
 		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
 		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
 		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
-		FW_FEATURE_PAPR_SCM,
+		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR,
 	FW_FEATURE_PSERIES_ALWAYS = 0,
-	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL,
+	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | FW_FEATURE_ULTRAVISOR,
 	FW_FEATURE_POWERNV_ALWAYS = 0,
 	FW_FEATURE_PS3_POSSIBLE = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
 	FW_FEATURE_PS3_ALWAYS = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
new file mode 100644
index 000000000000..e5009b0d84ea
--- /dev/null
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Ultravisor definitions
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+#ifndef _ASM_POWERPC_ULTRAVISOR_H
+#define _ASM_POWERPC_ULTRAVISOR_H
+
+/* Internal functions */
+extern int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
+					 int depth, void *data);
+
+#endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 0ea6c4aa3a20..c8ca219e54bf 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -154,6 +154,7 @@ endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
+obj-$(CONFIG_PPC_UV)		+= ultravisor.o
 
 # Disable GCOV, KCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4221527b082f..8a9a8a319959 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -59,6 +59,7 @@
 #include <asm/firmware.h>
 #include <asm/dt_cpu_ftrs.h>
 #include <asm/drmem.h>
+#include <asm/ultravisor.h>
 
 #include <mm/mmu_decl.h>
 
@@ -713,6 +714,11 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_fw_dump, NULL);
 #endif
 
+#if defined(CONFIG_PPC_UV)
+	/* Scan tree for ultravisor feature */
+	of_scan_flat_dt(early_init_dt_scan_ultravisor, NULL);
+#endif
+
 	/* Retrieve various informations from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
diff --git a/arch/powerpc/kernel/ultravisor.c b/arch/powerpc/kernel/ultravisor.c
new file mode 100644
index 000000000000..ac23835bdf5a
--- /dev/null
+++ b/arch/powerpc/kernel/ultravisor.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Ultravisor high level interfaces
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+#include <linux/init.h>
+#include <linux/printk.h>
+#include <linux/string.h>
+
+#include <asm/ultravisor.h>
+#include <asm/firmware.h>
+
+int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
+					 int depth, void *data)
+{
+	if (depth != 1 || strcmp(uname, "ibm,ultravisor") != 0)
+		return 0;
+
+	/* TODO: check the compatible devtree property once it is created */
+
+	powerpc_firmware_features |= FW_FEATURE_ULTRAVISOR;
+	pr_debug("Ultravisor detected!\n");
+	return 1;
+}
-- 
2.20.1

