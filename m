Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D056A28BF27
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Oct 2020 19:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbgJLRpv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Oct 2020 13:45:51 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13011 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389562AbgJLRpv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Oct 2020 13:45:51 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8496140001>; Mon, 12 Oct 2020 10:44:52 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 17:45:49 +0000
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 12 Oct 2020 17:45:49 +0000
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
        Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>
Subject: [PATCH v2] mm/hmm: make device private reference counts zero based
Date:   Mon, 12 Oct 2020 10:45:40 -0700
Message-ID: <20201012174540.17328-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602524692; bh=tDNnEsAwjl/cBl/OW9DOeVY+RZaX85ATtp4Y/UwEEpQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=rqij9IhU4SsaTR7ZyO5PvYIkzFgHb5UR1uwWyA+QNoLvJsaWBdvI9CMHc5UvE4WjY
         TO78AxpiKDndBmtbXr+lUN+1LNTriZsLDvHxw71T9522kccGTkc/5pbTntYdRPDe3z
         flvB6FTF0Uiv/jWbvMh6GA4v3+X86HIwsZwIGIztnFP4WVhAJWuIyVManOPBoTDQ/T
         wdUdsNAyFe0I2YfFxagdUrnLQO4mH32ZLj++ah8DgpVyL1ErWl/mpeiDMaRYEUFYE+
         9SBWHnaxt+cYz96j2VbSJOXc5IvaTPts8CB5gCsqYRmDT5ibyzux3+u7l3nPvW6ygx
         Jmx7bKT2DQafw==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

ZONE_DEVICE struct pages have an extra reference count that complicates the
code for put_page() and several places in the kernel that need to check the
reference count to see that a page is not being used (gup, compaction,
migration, etc.). Clean up the code so the reference count doesn't need to
be treated specially for device private pages, leaving DAX as still being
a special case.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---

I'm sending this as a separate patch since I think it is ready to
merge. Originally, this was part of an RFC:
https://lore.kernel.org/linux-mm/20201001181715.17416-1-rcampbell@nvidia.co=
m
and is changed to only make device private struct page reference
counts be zero based since DAX needs to detect when a page is not
referenced by GUP and not no references at all.

It applies cleanly to linux-5.9.0-rc8-mm1 plus my patch
("ext4/xfs: add page refcount helper")
https://lore.kernel.org/linux-mm/20201007214925.11181-1-rcampbell@nvidia.co=
m
and also
("mm/memcg: fix device private memcg accounting")
https://lore.kernel.org/linux-mm/20201009215952.2726-1-rcampbell@nvidia.com
but doesn't really depend on them, just simple merge conflicts
without them.

This is for Andrew Morton after the 5.10.0-rc1 merge window closes.

Changes in v2:
Fixed the call to page_ref_add_unless() when moving a process from one
memory cgroup to another thanks to Ira Weiny's comment.

 arch/powerpc/kvm/book3s_hv_uvmem.c     | 13 +++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.c |  2 +-
 include/linux/memremap.h               |  6 ++--
 include/linux/mm.h                     |  9 +-----
 lib/test_hmm.c                         |  7 ++++-
 mm/internal.h                          |  8 +++++
 mm/memcontrol.c                        | 11 ++-----
 mm/memremap.c                          | 42 ++++++++++----------------
 mm/migrate.c                           |  5 ---
 mm/swap.c                              |  6 ++--
 10 files changed, 54 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_h=
v_uvmem.c
index 84e5a2dc8be5..a0d08b1d8c1e 100644
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
@@ -1151,6 +1151,7 @@ int kvmppc_uvmem_init(void)
 	struct resource *res;
 	void *addr;
 	unsigned long pfn_last, pfn_first;
+	unsigned long pfn;
=20
 	size =3D kvmppc_get_secmem_size();
 	if (!size) {
@@ -1191,6 +1192,16 @@ int kvmppc_uvmem_init(void)
 		goto out_unmap;
 	}
=20
+	/*
+	 * Pages are created with an initial reference count of one but should
+	 * have a reference count of zero while in the free state.
+	 */
+	for (pfn =3D pfn_first; pfn < pfn_last; pfn++) {
+		struct page *dpage =3D pfn_to_page(pfn);
+
+		set_page_count(dpage, 0);
+	}
+
 	pr_info("KVMPPC-UVMEM: Secure Memory size 0x%lx\n", size);
 	return ret;
 out_unmap:
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
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 86c6c368ce9b..43860870bc51 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -66,9 +66,9 @@ enum memory_type {
=20
 struct dev_pagemap_ops {
 	/*
-	 * Called once the page refcount reaches 1.  (ZONE_DEVICE pages never
-	 * reach 0 refcount unless there is a refcount bug. This allows the
-	 * device driver to implement its own memory management.)
+	 * Called once the page refcount reaches 0. The reference count should
+	 * be reset to one with init_page_count(page) before reusing the page.
+	 * This allows device drivers to implement their own memory management.
 	 */
 	void (*page_free)(struct page *page);
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ef360fe70aaf..7a7013c57a4a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1110,14 +1110,7 @@ static inline bool page_is_devmap_managed(struct pag=
e *page)
 		return false;
 	if (!is_zone_device_page(page))
 		return false;
-	switch (page->pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_FS_DAX:
-		return true;
-	default:
-		break;
-	}
-	return false;
+	return page->pgmap->type =3D=3D MEMORY_DEVICE_FS_DAX;
 }
=20
 void put_devmap_managed_page(struct page *page);
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index e151a7f10519..bf92a261fa6f 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -509,10 +509,15 @@ static bool dmirror_allocate_chunk(struct dmirror_dev=
ice *mdevice,
 		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),
 		pfn_first, pfn_last);
=20
+	/*
+	 * Pages are created with an initial reference count of one but should
+	 * have a reference count of zero while in the free state.
+	 */
 	spin_lock(&mdevice->lock);
 	for (pfn =3D pfn_first; pfn < pfn_last; pfn++) {
 		struct page *page =3D pfn_to_page(pfn);
=20
+		set_page_count(page, 0);
 		page->zone_device_data =3D mdevice->free_pages;
 		mdevice->free_pages =3D page;
 	}
@@ -561,7 +566,7 @@ static struct page *dmirror_devmem_alloc_page(struct dm=
irror_device *mdevice)
 	}
=20
 	dpage->zone_device_data =3D rpage;
-	get_page(dpage);
+	init_page_count(dpage);
 	lock_page(dpage);
 	return dpage;
=20
diff --git a/mm/internal.h b/mm/internal.h
index c43ccdddb0f6..e1443b73aa9b 100644
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
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3a24e3b619f5..affab09fe35e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5553,17 +5553,12 @@ static struct page *mc_handle_swap_pte(struct vm_ar=
ea_struct *vma,
 		return NULL;
=20
 	/*
-	 * Handle MEMORY_DEVICE_PRIVATE which are ZONE_DEVICE page belonging to
-	 * a device and because they are not accessible by CPU they are store
-	 * as special swap entry in the CPU page table.
+	 * Device private pages are not accessible by the CPU and are stored
+	 * as a special swap entry in the CPU page table.
 	 */
 	if (is_device_private_entry(ent)) {
 		page =3D device_private_entry_to_page(ent);
-		/*
-		 * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
-		 * a refcount of 1 when free (unlike normal page)
-		 */
-		if (!page_ref_add_unless(page, 1, 1))
+		if (!page_ref_add_unless(page, 1, 0))
 			return NULL;
 		return page;
 	}
diff --git a/mm/memremap.c b/mm/memremap.c
index 504a10ff2edf..a163a9e36e56 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -49,12 +49,6 @@ static void devmap_managed_enable_put(void)
=20
 static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
-	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE &&
-	    (!pgmap->ops || !pgmap->ops->page_free)) {
-		WARN(1, "Missing page_free method\n");
-		return -EINVAL;
-	}
-
 	static_branch_inc(&devmap_managed_key);
 	return 0;
 }
@@ -92,13 +86,6 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, =
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
@@ -119,9 +106,6 @@ bool pfn_zone_device_reserved(unsigned long pfn)
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
@@ -177,20 +161,20 @@ static void pageunmap_range(struct dev_pagemap *pgmap=
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
+	if (pgmap->type =3D=3D MEMORY_DEVICE_FS_DAX)
+		devmap_managed_enable_put();
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
=20
@@ -328,7 +312,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid=
)
 		.pgprot =3D PAGE_KERNEL,
 	};
 	const int nr_range =3D pgmap->nr_range;
-	bool need_devmap_managed =3D true;
+	bool need_devmap_managed =3D false;
 	int error, i;
=20
 	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
@@ -344,6 +328,10 @@ void *memremap_pages(struct dev_pagemap *pgmap, int ni=
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
@@ -355,13 +343,12 @@ void *memremap_pages(struct dev_pagemap *pgmap, int n=
id)
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		need_devmap_managed =3D true;
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
@@ -508,10 +495,13 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_devmap_managed_page(struct page *page)
 {
 	/* notify page idle for dax */
-	if (!is_device_private_page(page)) {
-		dax_wakeup_page(page);
+	dax_wakeup_page(page);
+}
+
+void free_zone_device_page(struct page *page)
+{
+	if (!is_device_private_page(page))
 		return;
-	}
=20
 	__ClearPageWaiters(page);
=20
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
diff --git a/mm/swap.c b/mm/swap.c
index 0eb057141a04..93d880c6f73c 100644
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
@@ -907,6 +906,9 @@ void release_pages(struct page **pages, int nr)
 				put_devmap_managed_page(page);
 				continue;
 			}
+			if (put_page_testzero(page))
+				__put_page(page);
+			continue;
 		}
=20
 		if (!put_page_testzero(page))
--=20
2.20.1

