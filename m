Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5BCF11FD8A
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 05:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLPETe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 23:19:34 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:34754 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfLPETe (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 15 Dec 2019 23:19:34 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 5D097AE8056B;
        Sun, 15 Dec 2019 23:18:23 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 2/4] powerpc/pseries: Allow not having ibm,hypertas-functions::hcall-multi-tce for DDW
Date:   Mon, 16 Dec 2019 15:19:22 +1100
Message-Id: <20191216041924.42318-3-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216041924.42318-1-aik@ozlabs.ru>
References: <20191216041924.42318-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

By default a pseries guest supports a H_PUT_TCE hypercall which maps
a single IOMMU page in a DMA window. Additionally the hypervisor may
support H_PUT_TCE_INDIRECT/H_STUFF_TCE which update multiple TCEs at once;
this is advertised via the device tree /rtas/ibm,hypertas-functions
property which Linux converts to FW_FEATURE_MULTITCE.

FW_FEATURE_MULTITCE is checked when dma_iommu_ops is used; however
the code managing the huge DMA window (DDW) ignores it and calls
H_PUT_TCE_INDIRECT even if it is explicitly disabled via
the "multitce=off" kernel command line parameter.

This adds FW_FEATURE_MULTITCE checking to the DDW code path.

This changes tce_build_pSeriesLP to take liobn and page size as
the huge window does not have iommu_table descriptor which usually
the place to store these numbers.

Fixes: 4e8b0cf46b25 ("powerpc/pseries: Add support for dynamic dma windows")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

I've put "Fixes" which is from 2011-02-10 but probably should remove it,
or otherwise all these "stable backport branch" scripts will react on
"Fixes" and try pulling this back and we do not really want this as
this patch won't help anyone with anything useful.

---
Changes:
v2
* added "fixes"
---
 arch/powerpc/platforms/pseries/iommu.c | 44 ++++++++++++++++++--------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index df7db33ca93b..f6e9b87c82fc 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -132,10 +132,10 @@ static unsigned long tce_get_pseries(struct iommu_table *tbl, long index)
 	return be64_to_cpu(*tcep);
 }
 
-static void tce_free_pSeriesLP(struct iommu_table*, long, long);
+static void tce_free_pSeriesLP(unsigned long liobn, long, long);
 static void tce_freemulti_pSeriesLP(struct iommu_table*, long, long);
 
-static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
+static int tce_build_pSeriesLP(unsigned long liobn, long tcenum, long tceshift,
 				long npages, unsigned long uaddr,
 				enum dma_data_direction direction,
 				unsigned long attrs)
@@ -146,25 +146,25 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	int ret = 0;
 	long tcenum_start = tcenum, npages_start = npages;
 
-	rpn = __pa(uaddr) >> TCE_SHIFT;
+	rpn = __pa(uaddr) >> tceshift;
 	proto_tce = TCE_PCI_READ;
 	if (direction != DMA_TO_DEVICE)
 		proto_tce |= TCE_PCI_WRITE;
 
 	while (npages--) {
-		tce = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
-		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, tce);
+		tce = proto_tce | (rpn & TCE_RPN_MASK) << tceshift;
+		rc = plpar_tce_put((u64)liobn, (u64)tcenum << tceshift, tce);
 
 		if (unlikely(rc == H_NOT_ENOUGH_RESOURCES)) {
 			ret = (int)rc;
-			tce_free_pSeriesLP(tbl, tcenum_start,
+			tce_free_pSeriesLP(liobn, tcenum_start,
 			                   (npages_start - (npages + 1)));
 			break;
 		}
 
 		if (rc && printk_ratelimit()) {
 			printk("tce_build_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
-			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\tindex   = 0x%llx\n", (u64)liobn);
 			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 			printk("\ttce val = 0x%llx\n", tce );
 			dump_stack();
@@ -193,7 +193,8 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	unsigned long flags;
 
 	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
-		return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
+		return tce_build_pSeriesLP(tbl->it_index, tcenum,
+					   tbl->it_page_shift, npages, uaddr,
 		                           direction, attrs);
 	}
 
@@ -209,8 +210,9 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 		/* If allocation fails, fall back to the loop implementation */
 		if (!tcep) {
 			local_irq_restore(flags);
-			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
-					    direction, attrs);
+			return tce_build_pSeriesLP(tbl->it_index, tcenum,
+					tbl->it_page_shift,
+					npages, uaddr, direction, attrs);
 		}
 		__this_cpu_write(tce_page, tcep);
 	}
@@ -261,16 +263,16 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	return ret;
 }
 
-static void tce_free_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
+static void tce_free_pSeriesLP(unsigned long liobn, long tcenum, long npages)
 {
 	u64 rc;
 
 	while (npages--) {
-		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, 0);
+		rc = plpar_tce_put((u64)liobn, (u64)tcenum << 12, 0);
 
 		if (rc && printk_ratelimit()) {
 			printk("tce_free_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
-			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
+			printk("\tindex   = 0x%llx\n", (u64)liobn);
 			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
 			dump_stack();
 		}
@@ -285,7 +287,7 @@ static void tce_freemulti_pSeriesLP(struct iommu_table *tbl, long tcenum, long n
 	u64 rc;
 
 	if (!firmware_has_feature(FW_FEATURE_MULTITCE))
-		return tce_free_pSeriesLP(tbl, tcenum, npages);
+		return tce_free_pSeriesLP(tbl->it_index, tcenum, npages);
 
 	rc = plpar_tce_stuff((u64)tbl->it_index, (u64)tcenum << 12, 0, npages);
 
@@ -400,6 +402,20 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
 	u64 rc = 0;
 	long l, limit;
 
+	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
+		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
+		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
+				be64_to_cpu(maprange->dma_base);
+		unsigned long tcenum = dmastart >> tceshift;
+		unsigned long npages = num_pfn << PAGE_SHIFT >>
+				be32_to_cpu(maprange->tce_shift);
+		void *uaddr = __va(start_pfn << PAGE_SHIFT);
+
+		return tce_build_pSeriesLP(be32_to_cpu(maprange->liobn),
+				tcenum, tceshift, npages, (unsigned long) uaddr,
+				DMA_BIDIRECTIONAL, 0);
+	}
+
 	local_irq_disable();	/* to protect tcep and the page behind it */
 	tcep = __this_cpu_read(tce_page);
 
-- 
2.17.1

