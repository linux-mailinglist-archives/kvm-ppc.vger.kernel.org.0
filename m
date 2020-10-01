Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A471280661
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Oct 2020 20:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgJASRd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Oct 2020 14:17:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5759 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgJASRd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Oct 2020 14:17:33 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f761d2f0004>; Thu, 01 Oct 2020 11:17:19 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 1 Oct
 2020 18:17:29 +0000
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 1 Oct 2020 18:17:29 +0000
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
Subject: [RFC PATCH v3 2/2] mm: remove extra ZONE_DEVICE struct page refcount
Date:   Thu, 1 Oct 2020 11:17:15 -0700
Message-ID: <20201001181715.17416-3-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001181715.17416-1-rcampbell@nvidia.com>
References: <20201001181715.17416-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601576239; bh=eICAAEDAl68SL52lVd+gF0pBTDz7QHci9kQJAtuvyZU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=TeNIiEK6NSzp6ZPG5w6q/118Cm8bGcvKC2AsmAp12qDh9PH/iPEzh2R4x1Qxp25C2
         bbxwtzXzfVMg7fcrHLW02SxsO4WRdnsQMUW3Y+YgLQdBwUf7JyC+ec7/YEDa8ub8Dz
         F47Yp63jq//ZNA3AO7Dh1B6N0q1JzBnS/MnIr8Yl5UzCsNrjw4xAq7rzeLbXlvVaFz
         b6D2B3ggerDyMXMPZ07OdE3F8NJEjHfhQcH+EM9ncNRz/i2DeSmOPd6SIvO8e8rcDX
         5SIa4z9UgTjyk+CpctG/cyKQPObOGjY9ZMePcWCDqMWMnLamX2HMK7bzr7FuLDAlqh
         I002Na60XZabw==
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
 arch/powerpc/kvm/book3s_hv_uvmem.c     |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c |  2 +-
 fs/dax.c                               |  4 +-
 include/linux/dax.h                    |  2 +-
 include/linux/memremap.h               |  7 ++-
 include/linux/mm.h                     | 44 --------------
 lib/test_hmm.c                         |  2 +-
 mm/gup.c                               | 44 --------------
 mm/internal.h                          |  8 +++
 mm/memremap.c                          | 84 +++++++-------------------
 mm/migrate.c                           |  5 --
 mm/page_alloc.c                        |  3 +
 mm/swap.c                              | 44 ++------------
 13 files changed, 50 insertions(+), 201 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_h=
v_uvmem.c
index 84e5a2dc8be5..acee67710620 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -711,7 +711,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long=
 gpa, struct kvm *kvm)
=20
 	dpage =3D pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data =3D pvt;
-	get_page(dpage);
+	init_page_count(dpage);
 	lock_page(dpage);
 	return dpage;
 out_clear:
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouve=
au/nouveau_dmem.c
index 92987daa5e17..8bc7120e1216 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -324,7 +324,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 			return NULL;
 	}
=20
-	get_page(page);
+	init_page_count(page);
 	lock_page(page);
 	return page;
 }
diff --git a/fs/dax.c b/fs/dax.c
index 85c63f735909..4804348f62e6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -560,14 +560,14 @@ static void *grab_mapping_entry(struct xa_state *xas,
=20
 /**
  * dax_layout_busy_page_range - find first pinned page in @mapping
- * @mapping: address space to scan for a page with ref count > 1
+ * @mapping: address space to scan for a page with ref count > 0
  * @start: Starting offset. Page containing 'start' is included.
  * @end: End offset. Page containing 'end' is included. If 'end' is LLONG_=
MAX,
  *       pages from 'start' till the end of file are included.
  *
  * DAX requires ZONE_DEVICE mapped pages. These pages are never
  * 'onlined' to the page allocator so they are considered idle when
- * page->count =3D=3D 1. A filesystem uses this interface to determine if
+ * page->count =3D=3D 0. A filesystem uses this interface to determine if
  * any page in the mapping is busy, i.e. for DMA, or other
  * get_user_pages() usages.
  *
diff --git a/include/linux/dax.h b/include/linux/dax.h
index f906cf4db1cc..e4920ea6abd3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -245,7 +245,7 @@ static inline bool dax_mapping(struct address_space *ma=
pping)
=20
 static inline bool dax_layout_is_idle_page(struct page *page)
 {
-	return page_ref_count(page) =3D=3D 1;
+	return page_ref_count(page) =3D=3D 0;
 }
=20
 #define dax_wait_page(_inode, _page, _wait_cb)				\
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 86c6c368ce9b..2f63747caf56 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -66,9 +66,10 @@ enum memory_type {
=20
 struct dev_pagemap_ops {
 	/*
-	 * Called once the page refcount reaches 1.  (ZONE_DEVICE pages never
-	 * reach 0 refcount unless there is a refcount bug. This allows the
-	 * device driver to implement its own memory management.)
+	 * Called once the page refcount reaches 0. The reference count
+	 * should be reset to one with init_page_count(page) before reusing
+	 * the page. This allows the device driver to implement its own
+	 * memory management.
 	 */
 	void (*page_free)(struct page *page);
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 27c64d0d7520..3d71a820ae38 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1100,39 +1100,6 @@ static inline bool is_zone_device_page(const struct =
page *page)
 }
 #endif
=20
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-void free_devmap_managed_page(struct page *page);
-DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
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
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
-
 static inline bool is_device_private_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
@@ -1179,17 +1146,6 @@ static inline void put_page(struct page *page)
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
index e151a7f10519..37a2dea5e805 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -561,7 +561,7 @@ static struct page *dmirror_devmem_alloc_page(struct dm=
irror_device *mdevice)
 	}
=20
 	dpage->zone_device_data =3D rpage;
-	get_page(dpage);
+	init_page_count(dpage);
 	lock_page(dpage);
 	return dpage;
=20
diff --git a/mm/gup.c b/mm/gup.c
index 102877ed77a4..ed117e225c86 100644
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
diff --git a/mm/internal.h b/mm/internal.h
index 6345b08ce86c..629959a6f26d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -618,4 +618,12 @@ struct migration_target_control {
 	gfp_t gfp_mask;
 };
=20
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+void free_zone_device_page(struct page *page);
+#else
+static inline void free_zone_device_page(struct page *page)
+{
+}
+#endif
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memremap.c b/mm/memremap.c
index 2bb276680837..336f088c92a1 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/wait_bit.h>
 #include <linux/xarray.h>
+#include "internal.h"
=20
 static DEFINE_XARRAY(pgmap_array);
=20
@@ -37,36 +38,6 @@ unsigned long memremap_compat_align(void)
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
=20
-#ifdef CONFIG_DEV_PAGEMAP_OPS
-DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
-EXPORT_SYMBOL(devmap_managed_key);
-
-static void devmap_managed_enable_put(void)
-{
-	static_branch_dec(&devmap_managed_key);
-}
-
-static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE &&
-	    (!pgmap->ops || !pgmap->ops->page_free)) {
-		WARN(1, "Missing page_free method\n");
-		return -EINVAL;
-	}
-
-	static_branch_inc(&devmap_managed_key);
-	return 0;
-}
-#else
-static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
-{
-	return -EINVAL;
-}
-static void devmap_managed_enable_put(void)
-{
-}
-#endif /* CONFIG_DEV_PAGEMAP_OPS */
-
 static void pgmap_array_delete(struct range *range)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end)=
,
@@ -91,13 +62,6 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, =
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
@@ -118,9 +82,6 @@ bool pfn_zone_device_reserved(unsigned long pfn)
 	return ret;
 }
=20
-#define for_each_device_pfn(pfn, map, i) \
-	for (pfn =3D pfn_first(map, i); pfn < pfn_end(map, i); pfn =3D pfn_next(p=
fn))
-
 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
 	if (pgmap->ops && pgmap->ops->kill)
@@ -176,20 +137,18 @@ static void pageunmap_range(struct dev_pagemap *pgmap=
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
 		pageunmap_range(pgmap, i);
=20
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
-	devmap_managed_enable_put();
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
=20
@@ -327,7 +286,6 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid=
)
 		.pgprot =3D PAGE_KERNEL,
 	};
 	const int nr_range =3D pgmap->nr_range;
-	bool need_devmap_managed =3D true;
 	int error, i;
=20
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
@@ -343,6 +301,10 @@ void *memremap_pages(struct dev_pagemap *pgmap, int ni=
d)
 			WARN(1, "Missing migrate_to_ram method\n");
 			return ERR_PTR(-EINVAL);
 		}
+		if (!pgmap->ops->page_free) {
+			WARN(1, "Missing page_free method\n");
+			return ERR_PTR(-EINVAL);
+		}
 		if (!pgmap->owner) {
 			WARN(1, "Missing owner\n");
 			return ERR_PTR(-EINVAL);
@@ -356,11 +318,9 @@ void *memremap_pages(struct dev_pagemap *pgmap, int ni=
d)
 		}
 		break;
 	case MEMORY_DEVICE_GENERIC:
-		need_devmap_managed =3D false;
 		break;
 	case MEMORY_DEVICE_PCI_P2PDMA:
 		params.pgprot =3D pgprot_noncached(params.pgprot);
-		need_devmap_managed =3D false;
 		break;
 	default:
 		WARN(1, "Invalid pgmap type %d\n", pgmap->type);
@@ -384,12 +344,6 @@ void *memremap_pages(struct dev_pagemap *pgmap, int ni=
d)
 		}
 	}
=20
-	if (need_devmap_managed) {
-		error =3D devmap_managed_enable_get(pgmap);
-		if (error)
-			return ERR_PTR(error);
-	}
-
 	/*
 	 * Clear the pgmap nr_range as it will be incremented for each
 	 * successfully processed range. This communicates how many
@@ -504,16 +458,9 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void free_devmap_managed_page(struct page *page)
+static void free_device_private_page(struct page *page)
 {
-	/* notify page idle for dax */
-	if (!is_device_private_page(page)) {
-		wake_up_var(&page->_refcount);
-		return;
-	}
-
 	__ClearPageWaiters(page);
-
 	mem_cgroup_uncharge(page);
=20
 	/*
@@ -540,4 +487,19 @@ void free_devmap_managed_page(struct page *page)
 	page->mapping =3D NULL;
 	page->pgmap->ops->page_free(page);
 }
+
+void free_zone_device_page(struct page *page)
+{
+	switch (page->pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+		/* notify page idle */
+		wake_up_var(&page->_refcount);
+		return;
+	case MEMORY_DEVICE_PRIVATE:
+		free_device_private_page(page);
+		return;
+	default:
+		return;
+	}
+}
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
diff --git a/mm/migrate.c b/mm/migrate.c
index 5ca5842df5db..ee09334b46d8 100644
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb0962976a0e..039b88bb3978 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6154,6 +6154,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
=20
 		__init_single_page(page, pfn, zone_idx, nid);
=20
+		/* ZONE_DEVICE pages start with a zero reference count. */
+		set_page_count(page, 0);
+
 		/*
 		 * Mark page reserved as it will need to wait for onlining
 		 * phase for it to be fully associated with a zone.
diff --git a/mm/swap.c b/mm/swap.c
index 0eb057141a04..82cbe069dcf3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -116,12 +116,11 @@ static void __put_compound_page(struct page *page)
 void __put_page(struct page *page)
 {
 	if (is_zone_device_page(page)) {
-		put_dev_pagemap(page->pgmap);
-
 		/*
 		 * The page belongs to the device that created pgmap. Do
 		 * not return it to page allocator.
 		 */
+		free_zone_device_page(page);
 		return;
 	}
=20
@@ -891,26 +890,18 @@ void release_pages(struct page **pages, int nr)
 		if (is_huge_zero_page(page))
 			continue;
=20
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
-			 * page_is_devmap_managed() do not require special
-			 * processing, and instead, expect a call to
-			 * put_page_testzero().
-			 */
-			if (page_is_devmap_managed(page)) {
-				put_devmap_managed_page(page);
-				continue;
-			}
-		}
-
-		if (!put_page_testzero(page))
+			free_zone_device_page(page);
 			continue;
+		}
=20
 		if (PageCompound(page)) {
 			if (locked_pgdat) {
@@ -1188,26 +1179,3 @@ void __init swap_setup(void)
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

