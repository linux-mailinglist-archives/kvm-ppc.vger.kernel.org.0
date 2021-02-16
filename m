Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A052131C5DD
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Feb 2021 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhBPDe1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Feb 2021 22:34:27 -0500
Received: from ozlabs.ru ([107.174.27.60]:48886 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhBPDe1 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 15 Feb 2021 22:34:27 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id DF05DAE80225;
        Mon, 15 Feb 2021 22:33:13 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 1/2] powerpc/iommu: Allocate it_map by vmalloc
Date:   Tue, 16 Feb 2021 14:33:06 +1100
Message-Id: <20210216033307.69863-2-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210216033307.69863-1-aik@ozlabs.ru>
References: <20210216033307.69863-1-aik@ozlabs.ru>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The IOMMU table uses the it_map bitmap to keep track of allocated DMA
pages. This has always been a contiguous array allocated at either
the boot time or when a passed through device is returned to the host OS.
The it_map memory is allocated by alloc_pages() which allocates
contiguous physical memory.

Such allocation method occasionally creates a problem when there is
no big chunk of memory available (no free memory or too fragmented).
On powernv/ioda2 the default DMA window requires 16MB for it_map.

This replaces alloc_pages_node() with vzalloc_node() which allocates
contiguous block but in virtual memory. This should reduce changes of
failure but should not cause other behavioral changes as it_map is only
used by the kernel's DMA hooks/api when MMU is on.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kernel/iommu.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c00214a4355c..8eb6eb0afa97 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -719,7 +719,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
 {
 	unsigned long sz;
 	static int welcomed = 0;
-	struct page *page;
 	unsigned int i;
 	struct iommu_pool *p;
 
@@ -728,11 +727,9 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
 	/* number of bytes needed for the bitmap */
 	sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
 
-	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
-	if (!page)
+	tbl->it_map = vzalloc_node(sz, nid);
+	if (!tbl->it_map)
 		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
-	tbl->it_map = page_address(page);
-	memset(tbl->it_map, 0, sz);
 
 	iommu_table_reserve_pages(tbl, res_start, res_end);
 
@@ -774,8 +771,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
 
 static void iommu_table_free(struct kref *kref)
 {
-	unsigned long bitmap_sz;
-	unsigned int order;
 	struct iommu_table *tbl;
 
 	tbl = container_of(kref, struct iommu_table, it_kref);
@@ -796,12 +791,8 @@ static void iommu_table_free(struct kref *kref)
 	if (!bitmap_empty(tbl->it_map, tbl->it_size))
 		pr_warn("%s: Unexpected TCEs\n", __func__);
 
-	/* calculate bitmap size in bytes */
-	bitmap_sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
-
 	/* free bitmap */
-	order = get_order(bitmap_sz);
-	free_pages((unsigned long) tbl->it_map, order);
+	vfree(tbl->it_map);
 
 	/* free table */
 	kfree(tbl);
-- 
2.17.1

