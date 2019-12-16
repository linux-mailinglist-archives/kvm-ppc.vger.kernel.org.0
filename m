Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7622911FD8B
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 05:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLPETe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 23:19:34 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:34766 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfLPETe (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 15 Dec 2019 23:19:34 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id A1CC8AE80804;
        Sun, 15 Dec 2019 23:18:25 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 3/4] powerpc/pseries/iommu: Separate FW_FEATURE_MULTITCE to put/stuff features
Date:   Mon, 16 Dec 2019 15:19:23 +1100
Message-Id: <20191216041924.42318-4-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216041924.42318-1-aik@ozlabs.ru>
References: <20191216041924.42318-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

H_PUT_TCE_INDIRECT allows packing up to 512 TCE updates into a single
hypercall; H_STUFF_TCE can clear lots in a single hypercall too.

However, unlike H_STUFF_TCE (which writes the same TCE to all entries),
H_PUT_TCE_INDIRECT uses a 4K page with new TCEs. In a secure VM
environment this means sharing a secure VM page with a hypervisor which
we would rather avoid.

This splits the FW_FEATURE_MULTITCE feature into FW_FEATURE_PUT_TCE_IND
and FW_FEATURE_STUFF_TCE. "hcall-multi-tce" in
the "/rtas/ibm,hypertas-functions" device tree property sets both;
the "multitce=off" kernel command line parameter disables both.

This should not cause behavioural change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2
* instead of checking for secure VM here and there, this adds a new
FW feature
* moved SVM enablement to a separate patch
---
 arch/powerpc/include/asm/firmware.h       |  6 ++++--
 arch/powerpc/platforms/pseries/firmware.c |  3 ++-
 arch/powerpc/platforms/pseries/iommu.c    | 12 +++++++-----
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index b3e214a97f3a..ca33f4ef6cb4 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -33,7 +33,7 @@
 #define FW_FEATURE_LLAN		ASM_CONST(0x0000000000010000)
 #define FW_FEATURE_BULK_REMOVE	ASM_CONST(0x0000000000020000)
 #define FW_FEATURE_XDABR	ASM_CONST(0x0000000000040000)
-#define FW_FEATURE_MULTITCE	ASM_CONST(0x0000000000080000)
+#define FW_FEATURE_PUT_TCE_IND	ASM_CONST(0x0000000000080000)
 #define FW_FEATURE_SPLPAR	ASM_CONST(0x0000000000100000)
 #define FW_FEATURE_LPAR		ASM_CONST(0x0000000000400000)
 #define FW_FEATURE_PS3_LV1	ASM_CONST(0x0000000000800000)
@@ -51,6 +51,7 @@
 #define FW_FEATURE_BLOCK_REMOVE ASM_CONST(0x0000001000000000)
 #define FW_FEATURE_PAPR_SCM 	ASM_CONST(0x0000002000000000)
 #define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
+#define FW_FEATURE_STUFF_TCE	ASM_CONST(0x0000008000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -63,7 +64,8 @@ enum {
 		FW_FEATURE_MIGRATE | FW_FEATURE_PERFMON | FW_FEATURE_CRQ |
 		FW_FEATURE_VIO | FW_FEATURE_RDMA | FW_FEATURE_LLAN |
 		FW_FEATURE_BULK_REMOVE | FW_FEATURE_XDABR |
-		FW_FEATURE_MULTITCE | FW_FEATURE_SPLPAR | FW_FEATURE_LPAR |
+		FW_FEATURE_PUT_TCE_IND | FW_FEATURE_STUFF_TCE |
+		FW_FEATURE_SPLPAR | FW_FEATURE_LPAR |
 		FW_FEATURE_CMO | FW_FEATURE_VPHN | FW_FEATURE_XCMO |
 		FW_FEATURE_SET_MODE | FW_FEATURE_BEST_ENERGY |
 		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index d4a8f1702417..d3acff23f2e3 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -55,7 +55,8 @@ hypertas_fw_features_table[] = {
 	{FW_FEATURE_LLAN,		"hcall-lLAN"},
 	{FW_FEATURE_BULK_REMOVE,	"hcall-bulk"},
 	{FW_FEATURE_XDABR,		"hcall-xdabr"},
-	{FW_FEATURE_MULTITCE,		"hcall-multi-tce"},
+	{FW_FEATURE_PUT_TCE_IND | FW_FEATURE_STUFF_TCE,
+					"hcall-multi-tce"},
 	{FW_FEATURE_SPLPAR,		"hcall-splpar"},
 	{FW_FEATURE_VPHN,		"hcall-vphn"},
 	{FW_FEATURE_SET_MODE,		"hcall-set-mode"},
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index f6e9b87c82fc..07b91938c3cc 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -192,7 +192,7 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	int ret = 0;
 	unsigned long flags;
 
-	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
+	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_PUT_TCE_IND)) {
 		return tce_build_pSeriesLP(tbl->it_index, tcenum,
 					   tbl->it_page_shift, npages, uaddr,
 		                           direction, attrs);
@@ -286,7 +286,7 @@ static void tce_freemulti_pSeriesLP(struct iommu_table *tbl, long tcenum, long n
 {
 	u64 rc;
 
-	if (!firmware_has_feature(FW_FEATURE_MULTITCE))
+	if (!firmware_has_feature(FW_FEATURE_STUFF_TCE))
 		return tce_free_pSeriesLP(tbl->it_index, tcenum, npages);
 
 	rc = plpar_tce_stuff((u64)tbl->it_index, (u64)tcenum << 12, 0, npages);
@@ -402,7 +402,7 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
 	u64 rc = 0;
 	long l, limit;
 
-	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
+	if (!firmware_has_feature(FW_FEATURE_PUT_TCE_IND)) {
 		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
 		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
 				be64_to_cpu(maprange->dma_base);
@@ -1342,9 +1342,11 @@ static int __init disable_multitce(char *str)
 {
 	if (strcmp(str, "off") == 0 &&
 	    firmware_has_feature(FW_FEATURE_LPAR) &&
-	    firmware_has_feature(FW_FEATURE_MULTITCE)) {
+	    (firmware_has_feature(FW_FEATURE_PUT_TCE_IND) ||
+	     firmware_has_feature(FW_FEATURE_STUFF_TCE))) {
 		printk(KERN_INFO "Disabling MULTITCE firmware feature\n");
-		powerpc_firmware_features &= ~FW_FEATURE_MULTITCE;
+		powerpc_firmware_features &=
+			~(FW_FEATURE_PUT_TCE_IND | FW_FEATURE_STUFF_TCE);
 	}
 	return 1;
 }
-- 
2.17.1

