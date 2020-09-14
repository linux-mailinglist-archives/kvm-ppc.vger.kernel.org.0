Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341D626992A
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Sep 2020 00:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgINWp0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Sep 2020 18:45:26 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5584 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgINWpY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Sep 2020 18:45:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5ff2540000>; Mon, 14 Sep 2020 15:44:36 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 15:45:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 14 Sep 2020 15:45:23 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 22:45:18 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 14 Sep 2020 22:45:17 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f5ff27c000c>; Mon, 14 Sep 2020 15:45:17 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Bharata B Rao" <bharata@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>
Subject: [PATCH] mm: remove extra ZONE_DEVICE struct page refcount
Date:   Mon, 14 Sep 2020 15:45:09 -0700
Message-ID: <20200914224509.17699-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600123476; bh=TrRl3azN6SwFUxcMS7ApiDfcorJzP72BM2+t30cx8kQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=ZgPlVabhBfcpSWC0Ato5ShzEmDINfG8SQd16FG++OHnHkiqzL04voWUncPJBNemi3
         U8D/i32skLIy69WQ1t3kyUgLS0MR3iURi5Xw529Gga8EjUXz+1gFXwB9pqsa0iEheo
         WHC0hPS1mRr/GrvAjkTxEg63z4XlPb9mFdGbbtDDtC6vkywbkgWCbrJS6kSDPBCXs/
         zd213NXd0L5RSGBqFAHxZCipVVtJlblwQspjCPnDdCAq+V0oGW3twWYQB0OZrIqgTK
         wAaCEXxQOKm+2C0I/VS9uxIz37B+oh8O57tsIN913lh1QY3ga23liwU3IBVbhz0LdR
         98P1Zvo5mvWFA==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

ZONE_DEVICE struct pages have an extra reference count that complicates the
code for put_page() and several places in the kernel that need to check the
reference count to see that a page is not being used (gup, compaction,
migration, etc.). Clean up the code so the reference count doesn't need to
be treated specially for ZONE_DEVICE.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---

Matthew Wilcox, Ira Weiny, and others have complained that ZONE_DEVICE
struct page reference counting is ugly/broken. This is my attempt to
fix it and it works for the HMM migration self tests.

I'm only sending this out as a RFC since I'm not that familiar with the
DAX, PMEM, XEN, and other uses of ZONE_DEVICE struct pages allocated
with devm_memremap_pages() or memremap_pages() but my best reading of
the code looks like it might be OK. I could use help testing these
configurations.

I have a modified THP migration patch series that applies on top of
this one and is cleaner since I don't have to add code to handle the
+1 reference count. The link below is for the earlier v2:
("mm/hmm/nouveau: add THP migration to migrate_vma_*")
https://lore.kernel.org/linux-mm/20200902165830.5367-1-rcampbell@nvidia.com


 arch/powerpc/kvm/book3s_hv_uvmem.c     |  1 -
 drivers/gpu/drm/nouveau/nouveau_dmem.c |  1 -
 include/linux/memremap.h               |  6 +--
 include/linux/mm.h                     | 39 ---------------
 lib/test_hmm.c                         |  1 -
 mm/gup.c                               | 44 -----------------
 mm/memremap.c                          | 20 ++++----
 mm/migrate.c                           |  5 --
 mm/swap.c                              | 66 +++++++++++---------------
 9 files changed, 41 insertions(+), 142 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_h=
v_uvmem.c
index 84e5a2dc8be5..00d97050d7ff 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -711,7 +711,6 @@ static struct page *kvmppc_uvmem_get_page(unsigned long=
 gpa, struct kvm *kvm)
=20
 	dpage =3D pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data =3D pvt;
-	get_page(dpage);
 	lock_page(dpage);
 	return dpage;
 out_clear:
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouve=
au/nouveau_dmem.c
index a13c6215bba8..2a4bbe01a455 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -324,7 +324,6 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 			return NULL;
 	}
=20
-	get_page(page);
 	lock_page(page);
 	return page;
 }
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4e9c738f4b31..7dd9802d2612 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -67,9 +67,9 @@ enum memory_type {
=20
 struct dev_pagemap_ops {
 	/*
-	 * Called once the page refcount reaches 1.  (ZONE_DEVICE pages never
-	 * reach 0 refcount unless there is a refcount bug. This allows the
-	 * device driver to implement its own memory management.)
+	 * Called once the page refcount reaches 0. The reference count is
+	 * reset to 1 before calling page_free(). This allows the
+	 * device driver to implement its own memory management.
 	 */
 	void (*page_free)(struct page *page);
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 517751310dd2..5a82037a4b26 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1093,34 +1093,6 @@ static inline bool is_zone_device_page(const struct =
page *page)
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 void free_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
-
-static inline bool page_is_devmap_managed(struct page *page)
-{
-	if (!static_branch_unlikely(&devmap_managed_key))
-		return false;
-	if (!is_zone_device_page(page))
-		return false;
-	switch (page->pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_FS_DAX:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
-void put_devmap_managed_page(struct page *page);
-
-#else /* CONFIG_DEV_PAGEMAP_OPS */
-static inline bool page_is_devmap_managed(struct page *page)
-{
-	return false;
-}
-
-static inline void put_devmap_managed_page(struct page *page)
-{
-}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
=20
 static inline bool is_device_private_page(const struct page *page)
@@ -1169,17 +1141,6 @@ static inline void put_page(struct page *page)
 {
 	page =3D compound_head(page);
=20
-	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * 2 to 1, when refcount reach one it means the page is free and we
-	 * need to inform the device driver through callback. See
-	 * include/linux/memremap.h and HMM for details.
-	 */
-	if (page_is_devmap_managed(page)) {
-		put_devmap_managed_page(page);
-		return;
-	}
-
 	if (put_page_testzero(page))
 		__put_page(page);
 }
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index c8133f50160b..5410f7328577 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -561,7 +561,6 @@ static struct page *dmirror_devmem_alloc_page(struct dm=
irror_device *mdevice)
 	}
=20
 	dpage->zone_device_data =3D rpage;
-	get_page(dpage);
 	lock_page(dpage);
 	return dpage;
=20
diff --git a/mm/gup.c b/mm/gup.c
index b9b1cd8bcd6a..3c54f0c190a3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -177,41 +177,6 @@ bool __must_check try_grab_page(struct page *page, uns=
igned int flags)
 	return true;
 }
=20
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	int count, refs =3D 1;
-
-	if (!page_is_devmap_managed(page))
-		return false;
-
-	if (hpage_pincount_available(page))
-		hpage_pincount_sub(page, 1);
-	else
-		refs =3D GUP_PIN_COUNTING_BIAS;
-
-	count =3D page_ref_sub_return(page, refs);
-
-	mod_node_page_state(page_pgdat(page), NR_FOLL_PIN_RELEASED, 1);
-	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (count =3D=3D 1)
-		free_devmap_managed_page(page);
-	else if (!count)
-		__put_page(page);
-
-	return true;
-}
-#else
-static bool __unpin_devmap_managed_user_page(struct page *page)
-{
-	return false;
-}
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
-
 /**
  * unpin_user_page() - release a dma-pinned page
  * @page:            pointer to page to be released
@@ -227,15 +192,6 @@ void unpin_user_page(struct page *page)
=20
 	page =3D compound_head(page);
=20
-	/*
-	 * For devmap managed pages we need to catch refcount transition from
-	 * GUP_PIN_COUNTING_BIAS to 1, when refcount reach one it means the
-	 * page is free and we need to inform the device driver through
-	 * callback. See include/linux/memremap.h and HMM for details.
-	 */
-	if (__unpin_devmap_managed_user_page(page))
-		return;
-
 	if (hpage_pincount_available(page))
 		hpage_pincount_sub(page, 1);
 	else
diff --git a/mm/memremap.c b/mm/memremap.c
index 9c951bbfee91..f09562789079 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -91,13 +91,6 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, =
int range_id)
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
=20
-static unsigned long pfn_next(unsigned long pfn)
-{
-	if (pfn % 1024 =3D=3D 0)
-		cond_resched();
-	return pfn + 1;
-}
-
 /*
  * This returns true if the page is reserved by ZONE_DEVICE driver.
  */
@@ -176,13 +169,12 @@ static void pageunmap_range(struct dev_pagemap *pgmap=
, int range_id)
=20
 void memunmap_pages(struct dev_pagemap *pgmap)
 {
-	unsigned long pfn;
 	int i;
=20
 	dev_pagemap_kill(pgmap);
 	for (i =3D 0; i < pgmap->nr_range; i++)
-		for_each_device_pfn(pfn, pgmap, i)
-			put_page(pfn_to_page(pfn));
+		percpu_ref_put_many(pgmap->ref, pfn_end(pgmap, i) -
+						pfn_first(pgmap, i));
 	dev_pagemap_cleanup(pgmap);
=20
 	for (i =3D 0; i < pgmap->nr_range; i++)
@@ -516,6 +508,14 @@ void free_devmap_managed_page(struct page *page)
=20
 	mem_cgroup_uncharge(page);
=20
+	/*
+	 * ZONE_DEVICE drivers keep a reference to the page while it is on
+	 * the driver's free list so we reset the reference count here.
+	 * This matches the initial reference when the struct pages are
+	 * created by memremap_pages().
+	 */
+	set_page_refcounted(page);
+
 	/*
 	 * When a device_private page is freed, the page->mapping field
 	 * may still contain a (stale) mapping value. For example, the
diff --git a/mm/migrate.c b/mm/migrate.c
index 4f89360d9e77..be1586582b52 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -380,11 +380,6 @@ static int expected_page_refs(struct address_space *ma=
pping, struct page *page)
 {
 	int expected_count =3D 1;
=20
-	/*
-	 * Device private pages have an extra refcount as they are
-	 * ZONE_DEVICE pages.
-	 */
-	expected_count +=3D is_device_private_page(page);
 	if (mapping)
 		expected_count +=3D thp_nr_pages(page) + page_has_private(page);
=20
diff --git a/mm/swap.c b/mm/swap.c
index feff680d3de9..8468e72e397f 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -113,10 +113,31 @@ static void __put_compound_page(struct page *page)
 	destroy_compound_page(page);
 }
=20
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+static void __put_devmap_managed_page(struct page *page)
+{
+	if (!static_branch_unlikely(&devmap_managed_key))
+		return;
+
+	switch (page->pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_FS_DAX:
+		free_devmap_managed_page(page);
+		break;
+	default:
+		break;
+	}
+}
+#else
+static inline void __put_devmap_managed_page(struct page *page)
+{
+}
+#endif
+
 void __put_page(struct page *page)
 {
 	if (is_zone_device_page(page)) {
-		put_dev_pagemap(page->pgmap);
+		__put_devmap_managed_page(page);
=20
 		/*
 		 * The page belongs to the device that created pgmap. Do
@@ -851,27 +872,19 @@ void release_pages(struct page **pages, int nr)
 		if (is_huge_zero_page(page))
 			continue;
=20
+		page =3D compound_head(page);
+		if (!put_page_testzero(page))
+			continue;
+
 		if (is_zone_device_page(page)) {
 			if (locked_pgdat) {
 				spin_unlock_irqrestore(&locked_pgdat->lru_lock,
 						       flags);
 				locked_pgdat =3D NULL;
 			}
-			/*
-			 * ZONE_DEVICE pages that return 'false' from
-			 * put_devmap_managed_page() do not require special
-			 * processing, and instead, expect a call to
-			 * put_page_testzero().
-			 */
-			if (page_is_devmap_managed(page)) {
-				put_devmap_managed_page(page);
-				continue;
-			}
-		}
-
-		page =3D compound_head(page);
-		if (!put_page_testzero(page))
+			__put_devmap_managed_page(page);
 			continue;
+		}
=20
 		if (PageCompound(page)) {
 			if (locked_pgdat) {
@@ -1149,26 +1162,3 @@ void __init swap_setup(void)
 	 * _really_ don't want to cluster much more
 	 */
 }
-
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-void put_devmap_managed_page(struct page *page)
-{
-	int count;
-
-	if (WARN_ON_ONCE(!page_is_devmap_managed(page)))
-		return;
-
-	count =3D page_ref_dec_return(page);
-
-	/*
-	 * devmap page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (count =3D=3D 1)
-		free_devmap_managed_page(page);
-	else if (!count)
-		__put_page(page);
-}
-EXPORT_SYMBOL(put_devmap_managed_page);
-#endif
--=20
2.20.1

