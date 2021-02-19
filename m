Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F6531F3D8
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 03:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBSCIq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Feb 2021 21:08:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3687 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSCIp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 18 Feb 2021 21:08:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602f1d840002>; Thu, 18 Feb 2021 18:08:04 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 19 Feb
 2021 02:08:03 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, <jgg@nvidia.com>, <hch@infradead.org>,
        <daniel@ffwll.ch>, Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 1/4] hmm: Device exclusive memory access
Date:   Fri, 19 Feb 2021 13:07:47 +1100
Message-ID: <20210219020750.16444-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210219020750.16444-1-apopple@nvidia.com>
References: <20210219020750.16444-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613700484; bh=yJEw++cy7k4OV8g+WZwQgmITlJnjAGszf9m72gZIjL4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lnyJ7y2+LN1OtyfRHDIBrXXyeXUbinqpXE/WZtS9rx8ZJJ3Q/w/VsJl/5T9+xxCoU
         wknnZIDrQqy62Bxozhpza1/Au83ZhUJ8POeH5KVrt2ME13Q2W46FOSJ4S8a6hZZPmO
         xz/OKF206P6wOz7t9+kSDTJUFun+N/8R029iacerhOCpiZ/Foj9dUHAqDV9+HDi6AH
         LH02xYJcUnlAD445B3BARfRFhGyMQbmF9N0CjWq5TJPGLJXZgAMZ7Elr8OXgd4Rd49
         bDJeBfHthWjWUW2jD1ASC+7oJ3ArtjYg0Nm9jUzokfSTFyrBjuqIblqCNl6ofBQdEB
         SuaQjCpGImV9A==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some devices require exclusive write access to shared virtual
memory (SVM) ranges to perform atomic operations on that memory. This
requires CPU page tables to be updated to deny access whilst atomic
operations are occurring.

In order to do this introduce a new swap entry
type (SWP_DEVICE_EXCLUSIVE). When a SVM range needs to be marked for
exclusive access by a device all page table mappings for the particular
range are replaced with device exclusive swap entries. This causes any
CPU access to the page to result in a fault.

Faults are resovled by replacing the faulting entry with the original
mapping. This results in MMU notifiers being called which a driver uses
to update access permissions such as revoking atomic access. After
notifiers have been called the device will no longer have exclusive
access to the region.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 Documentation/vm/hmm.rst |  15 +++
 fs/proc/task_mmu.c       |   7 ++
 include/linux/hmm.h      |   4 +
 include/linux/rmap.h     |   1 +
 include/linux/swap.h     |  10 +-
 include/linux/swapops.h  |  32 ++++++
 mm/hmm.c                 | 206 +++++++++++++++++++++++++++++++++++++++
 mm/memory.c              |  34 ++++++-
 mm/mprotect.c            |   7 ++
 mm/page_vma_mapped.c     |  14 ++-
 mm/rmap.c                |  29 +++++-
 11 files changed, 347 insertions(+), 12 deletions(-)

diff --git a/Documentation/vm/hmm.rst b/Documentation/vm/hmm.rst
index 09e28507f5b2..ffdc58cb2e7c 100644
--- a/Documentation/vm/hmm.rst
+++ b/Documentation/vm/hmm.rst
@@ -405,6 +405,21 @@ between device driver specific code and shared common =
code:
=20
    The lock can now be released.
=20
+Exclusive access memory
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Not all devices support atomic access to system memory. To support atomic
+operations to a shared virtual memory page such a device needs access to t=
hat
+page which is exclusive of any userspace access from the CPU. The
+``hmm_exclusive_range()`` function can be used to make a memory range
+inaccessible from userspace.
+
+This replaces all mappings for pages in the given range with special swap
+entries. Any attempt to access the swap entry results in a fault which is
+resovled by replacing the entry with the original mapping. A driver gets
+notified that the mapping has been changed by MMU notifiers, after which p=
oint
+it will no longer have exclusive access to the page.
+
 Memory cgroup (memcg) and rss accounting
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 602e3a52884d..79aaf8768be3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -518,6 +518,8 @@ static void smaps_pte_entry(pte_t *pte, unsigned long a=
ddr,
 			page =3D migration_entry_to_page(swpent);
 		else if (is_device_private_entry(swpent))
 			page =3D device_private_entry_to_page(swpent);
+		else if (is_device_exclusive_entry(swpent))
+			page =3D device_exclusive_entry_to_page(swpent);
 	} else if (unlikely(IS_ENABLED(CONFIG_SHMEM) && mss->check_shmem_swap
 							&& pte_none(*pte))) {
 		page =3D xa_load(&vma->vm_file->f_mapping->i_pages,
@@ -695,6 +697,8 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned lon=
g hmask,
 			page =3D migration_entry_to_page(swpent);
 		else if (is_device_private_entry(swpent))
 			page =3D device_private_entry_to_page(swpent);
+		else if (is_device_exclusive_entry(swpent))
+			page =3D device_exclusive_entry_to_page(swpent);
 	}
 	if (page) {
 		int mapcount =3D page_mapcount(page);
@@ -1387,6 +1391,9 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pa=
gemapread *pm,
=20
 		if (is_device_private_entry(entry))
 			page =3D device_private_entry_to_page(entry);
+
+		if (is_device_exclusive_entry(entry))
+			page =3D device_exclusive_entry_to_page(entry);
 	}
=20
 	if (page && !PageAnon(page))
diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 866a0fa104c4..5d28ff6d4d80 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -109,6 +109,10 @@ struct hmm_range {
  */
 int hmm_range_fault(struct hmm_range *range);
=20
+int hmm_exclusive_range(struct mm_struct *mm, unsigned long start,
+			unsigned long end, struct page **pages);
+vm_fault_t hmm_remove_exclusive_entry(struct vm_fault *vmf);
+
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a ran=
ge
  *
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 70085ca1a3fc..5503fc4d1138 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -98,6 +98,7 @@ enum ttu_flags {
 	TTU_RMAP_LOCKED		=3D 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
 	TTU_SPLIT_FREEZE	=3D 0x100,		/* freeze pte under splitting thp */
+	TTU_EXCLUSIVE		=3D 0x200,		/* replace with exclusive access */
 };
=20
 #ifdef CONFIG_MMU
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 596bc2f4d9b0..9803753b0302 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -63,9 +63,11 @@ static inline int current_is_kswapd(void)
  * to a special SWP_DEVICE_* entry.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 2
+#define SWP_DEVICE_NUM 4
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM=
)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+=
1)
+#define SWP_DEVICE_EXCLUSIVE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIG=
RATION_NUM+2)
+#define SWP_DEVICE_EXCLUSIVE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGR=
ATION_NUM+3)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
@@ -519,8 +521,10 @@ static inline void show_swap_cache_info(void)
 {
 }
=20
-#define free_swap_and_cache(e) ({(is_migration_entry(e) || is_device_priva=
te_entry(e));})
-#define swapcache_prepare(e) ({(is_migration_entry(e) || is_device_private=
_entry(e));})
+#define free_swap_and_cache(e) ({(is_migration_entry(e) || is_device_priva=
te_entry(e) \
+					|| is_device_exclusive_entry(e)); })
+#define swapcache_prepare(e) ({(is_migration_entry(e) || is_device_private=
_entry(e) \
+					|| is_device_exclusive_entry(e)); })
=20
 static inline int add_swap_count_continuation(swp_entry_t swp, gfp_t gfp_m=
ask)
 {
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index d9b7c9132c2f..a307134bfee5 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -122,6 +122,38 @@ static inline bool is_write_device_private_entry(swp_e=
ntry_t entry)
 	return unlikely(swp_type(entry) =3D=3D SWP_DEVICE_WRITE);
 }
=20
+static inline void make_device_exclusive_entry_read(swp_entry_t *entry)
+{
+	*entry =3D swp_entry(SWP_DEVICE_EXCLUSIVE_READ, swp_offset(*entry));
+}
+
+static inline swp_entry_t make_device_exclusive_entry(struct page *page, b=
ool write)
+{
+	return swp_entry(write ? SWP_DEVICE_EXCLUSIVE_WRITE : SWP_DEVICE_EXCLUSIV=
E_READ,
+			 page_to_pfn(page));
+}
+
+static inline bool is_device_exclusive_entry(swp_entry_t entry)
+{
+	int type =3D swp_type(entry);
+	return type =3D=3D SWP_DEVICE_EXCLUSIVE_READ || type =3D=3D SWP_DEVICE_EX=
CLUSIVE_WRITE;
+}
+
+static inline bool is_write_device_exclusive_entry(swp_entry_t entry)
+{
+	return swp_type(entry) =3D=3D SWP_DEVICE_EXCLUSIVE_WRITE;
+}
+
+static inline unsigned long device_exclusive_entry_to_pfn(swp_entry_t entr=
y)
+{
+	return swp_offset(entry);
+}
+
+static inline struct page *device_exclusive_entry_to_page(swp_entry_t entr=
y)
+{
+	return pfn_to_page(swp_offset(entry));
+}
+
 static inline unsigned long device_private_entry_to_pfn(swp_entry_t entry)
 {
 	return swp_offset(entry);
diff --git a/mm/hmm.c b/mm/hmm.c
index 943cb2ba4442..90cdf99bee52 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -26,6 +26,8 @@
 #include <linux/mmu_notifier.h>
 #include <linux/memory_hotplug.h>
=20
+#include "internal.h"
+
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
@@ -272,6 +274,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, uns=
igned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
=20
+		if (is_device_exclusive_entry(entry))
+			goto fault;
+
 		if (is_migration_entry(entry)) {
 			pte_unmap(ptep);
 			hmm_vma_walk->last =3D addr;
@@ -593,3 +598,204 @@ int hmm_range_fault(struct hmm_range *range)
 	return ret;
 }
 EXPORT_SYMBOL(hmm_range_fault);
+
+struct hmm_exclusive_walk {
+	struct page **pages;
+	int npages;
+};
+
+static int hmm_exclusive_skip(unsigned long start,
+		      unsigned long end,
+		      __always_unused int depth,
+		      struct mm_walk *walk)
+{
+	struct hmm_exclusive_walk *hmm_exclusive_walk =3D walk->private;
+	unsigned long addr;
+
+	for (addr =3D start; addr < end; addr +=3D PAGE_SIZE)
+		hmm_exclusive_walk->pages[hmm_exclusive_walk->npages++] =3D NULL;
+
+	return 0;
+}
+
+static int hmm_exclusive_pmd(pmd_t *pmdp, unsigned long addr, unsigned lon=
g end,
+		  struct mm_walk *walk)
+{
+	struct hmm_exclusive_walk *hmm_exclusive_walk =3D walk->private;
+	struct vm_area_struct *vma =3D walk->vma;
+	struct mm_struct *mm =3D vma->vm_mm;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (pmd_trans_huge(*pmdp)) {
+		int ret;
+		struct page *page;
+
+		ptl =3D pmd_lock(mm, pmdp);
+		if (unlikely(!pmd_trans_huge(*pmdp))) {
+			spin_unlock(ptl);
+			walk->action =3D ACTION_AGAIN;
+			return 0;
+		}
+
+		page =3D pmd_page(*pmdp);
+		if (is_huge_zero_page(page)) {
+			spin_unlock(ptl);
+			return hmm_exclusive_skip(addr, end, -1, walk);
+		}
+
+		get_page(page);
+		spin_unlock(ptl);
+		if (unlikely(!trylock_page(page)))
+			return hmm_exclusive_skip(addr, end, -1, walk);
+
+		ret =3D split_huge_page(page);
+		unlock_page(page);
+		put_page(page);
+		if (ret || pmd_none(*pmdp))
+			return hmm_exclusive_skip(addr, end, -1, walk);
+	}
+
+	if (unlikely(pmd_bad(*pmdp)))
+		return hmm_exclusive_skip(addr, end, -1, walk);
+
+	ptep =3D pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	for (; addr < end; addr +=3D PAGE_SIZE, ptep++) {
+		struct page *page;
+		pte_t pte =3D *ptep;
+
+		if (pte_none(pte) || !pte_present(pte) ||
+		    is_zero_pfn(pte_pfn(pte)))
+			continue;
+
+		page =3D vm_normal_page(vma, addr, pte);
+		if (!page)
+			continue;
+
+		get_page(page);
+		if (!trylock_page(page)) {
+			put_page(page);
+			continue;
+		}
+
+		hmm_exclusive_walk->pages[hmm_exclusive_walk->npages++] =3D page;
+	}
+
+	pte_unmap_unlock(ptep - 1, ptl);
+	return 0;
+}
+
+static const struct mm_walk_ops hmm_exclusive_walk_ops =3D {
+	.pmd_entry	=3D hmm_exclusive_pmd,
+	.pte_hole	=3D hmm_exclusive_skip,
+};
+
+/**
+ * hmm_exclusive_range() - Mark a range for exclusive use by a device
+ * @mm: mm_struct of assoicated target process
+ * @start: start of the region to mark for exclusive device access
+ * @end: end address of region
+ * @pages: returns the pages which were successfully mark for exclusive ac=
ces
+ *
+ * Returns: number of pages successfully marked for exclusive access
+ *
+ * This function finds the ptes mapping page(s) to the given address range=
 and
+ * replaces them with special swap entries preventing userspace CPU access=
. On
+ * fault these entries are replaced with the original mapping after callin=
g MMU
+ * notifiers.
+ */
+int hmm_exclusive_range(struct mm_struct *mm, unsigned long start,
+			unsigned long end, struct page **pages)
+{
+	struct hmm_exclusive_walk hmm_exclusive_walk =3D { .pages =3D pages, .npa=
ges =3D 0 };
+	int i;
+
+	/* Collect and lock candidate pages */
+	walk_page_range(mm, start, end, &hmm_exclusive_walk_ops, &hmm_exclusive_w=
alk);
+
+	for (i =3D 0; i < hmm_exclusive_walk.npages; i++)
+		if (pages[i])
+			if (!try_to_unmap(pages[i], TTU_EXCLUSIVE | TTU_IGNORE_MLOCK)) {
+				unlock_page(pages[i]);
+				put_page(pages[i]);
+				pages[i] =3D NULL;
+			}
+
+	return hmm_exclusive_walk.npages;
+}
+EXPORT_SYMBOL_GPL(hmm_exclusive_range);
+
+/*
+ * Restore a potential migration pte to a working pte entry
+ */
+vm_fault_t hmm_remove_exclusive_entry(struct vm_fault *vmf)
+{
+	struct page *page =3D vmf->page;
+	struct vm_area_struct *vma =3D vmf->vma;
+	struct page_vma_mapped_walk pvmw =3D {
+		.page =3D page,
+		.vma =3D vma,
+		.address =3D vmf->address,
+		.flags =3D PVMW_SYNC,
+	};
+	pte_t pte;
+	vm_fault_t ret =3D 0;
+	struct mmu_notifier_range range;
+
+	lock_page(page);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				vmf->address & PAGE_MASK,
+				(vmf->address & PAGE_MASK) + PAGE_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		swp_entry_t entry;
+
+		if (unlikely(!pte_same(*pvmw.pte, vmf->orig_pte))) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+
+#if defined(CONFIG_ARCH_ENABLE_THP_MIGRATION) || defined(CONFIG_HUGETLB)
+		if (PageTransHuge(page)) {
+			VM_BUG_ON_PAGE(1, page);
+			continue;
+		}
+#endif
+
+		pte =3D pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+		if (pte_swp_soft_dirty(*pvmw.pte))
+			pte =3D pte_mksoft_dirty(pte);
+
+		entry =3D pte_to_swp_entry(*pvmw.pte);
+		if (pte_swp_uffd_wp(*pvmw.pte))
+			pte =3D pte_mkuffd_wp(pte);
+		else if (is_write_device_exclusive_entry(entry))
+			pte =3D maybe_mkwrite(pte_mkdirty(pte), vma);
+
+		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+
+		/*
+		 * No need to take a page reference as one was already
+		 * created when the swap entry was made.
+		 */
+		if (PageAnon(page))
+			page_add_anon_rmap(page, vma, pvmw.address, false);
+		else
+			page_add_file_rmap(page, false);
+
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_vma_page(page);
+
+		/*
+		 * No need to invalidate - it was non-present before. However
+		 * secondary CPUs may have mappings that need invalidating.
+		 */
+		update_mmu_cache(vma, pvmw.address, pvmw.pte);
+	}
+
+	unlock_page(page);
+
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..ed03a37f25cb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -73,6 +73,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/hmm.h>
=20
 #include <trace/events/kmem.h>
=20
@@ -736,9 +737,29 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct m=
m_struct *src_mm,
 				pte =3D pte_swp_mkuffd_wp(pte);
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
-	} else if (is_device_private_entry(entry)) {
+	} else if (is_device_exclusive_entry(entry)) {
 		page =3D device_private_entry_to_page(entry);
=20
+		get_page(page);
+		rss[mm_counter(page)]++;
+
+		if (is_write_device_exclusive_entry(entry) &&
+				is_cow_mapping(vm_flags)) {
+			/*
+			 * COW mappings require pages in both
+			 * parent and child to be set to read.
+			 */
+			make_device_exclusive_entry_read(&entry);
+			pte =3D swp_entry_to_pte(entry);
+			if (pte_swp_soft_dirty(*src_pte))
+				pte =3D pte_swp_mksoft_dirty(pte);
+			if (pte_swp_uffd_wp(*src_pte))
+				pte =3D pte_swp_mkuffd_wp(pte);
+			set_pte_at(src_mm, addr, src_pte, pte);
+		}
+	} else if (is_device_private_entry(entry)) {
+		page =3D device_exclusive_entry_to_page(entry);
+
 		/*
 		 * Update rss count even for unaddressable pages, as
 		 * they should treated just like normal pages in this
@@ -1273,7 +1294,8 @@ static unsigned long zap_pte_range(struct mmu_gather =
*tlb,
 		}
=20
 		entry =3D pte_to_swp_entry(ptent);
-		if (is_device_private_entry(entry)) {
+		if (is_device_private_entry(entry) ||
+		    is_device_exclusive_entry(entry)) {
 			struct page *page =3D device_private_entry_to_page(entry);
=20
 			if (unlikely(details && details->check_mapping)) {
@@ -1289,7 +1311,10 @@ static unsigned long zap_pte_range(struct mmu_gather=
 *tlb,
=20
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
-			page_remove_rmap(page, false);
+
+			if (is_device_private_entry(entry))
+				page_remove_rmap(page, false);
+
 			put_page(page);
 			continue;
 		}
@@ -3270,6 +3295,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		if (is_migration_entry(entry)) {
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
 					     vmf->address);
+		} else if (is_device_exclusive_entry(entry)) {
+			vmf->page =3D device_exclusive_entry_to_page(entry);
+			ret =3D hmm_remove_exclusive_entry(vmf);
 		} else if (is_device_private_entry(entry)) {
 			vmf->page =3D device_private_entry_to_page(entry);
 			ret =3D vmf->page->pgmap->ops->migrate_to_ram(vmf);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ab709023e9aa..f93967211e52 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -163,6 +163,13 @@ static unsigned long change_pte_range(struct vm_area_s=
truct *vma, pmd_t *pmd,
 				newpte =3D swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte =3D pte_swp_mkuffd_wp(newpte);
+			} else if (is_write_device_exclusive_entry(entry)) {
+				make_device_exclusive_entry_read(&entry);
+				newpte =3D swp_entry_to_pte(entry);
+				if (pte_swp_soft_dirty(oldpte))
+					newpte =3D pte_swp_mksoft_dirty(newpte);
+				if (pte_swp_uffd_wp(oldpte))
+					newpte =3D pte_swp_mkuffd_wp(newpte);
 			} else {
 				newpte =3D oldpte;
 			}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 86e3a3688d59..ff65a2c35996 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -41,7 +41,8 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw)
=20
 				/* Handle un-addressable ZONE_DEVICE memory */
 				entry =3D pte_to_swp_entry(*pvmw->pte);
-				if (!is_device_private_entry(entry))
+				if (!is_device_private_entry(entry) &&
+					!is_device_exclusive_entry(entry))
 					return false;
 			} else if (!pte_present(*pvmw->pte))
 				return false;
@@ -93,16 +94,18 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw=
)
 			return false;
 		entry =3D pte_to_swp_entry(*pvmw->pte);
=20
-		if (!is_migration_entry(entry))
+		if (is_migration_entry(entry))
+			pfn =3D migration_entry_to_pfn(entry);
+		else if (is_device_exclusive_entry(entry))
+			pfn =3D device_exclusive_entry_to_pfn(entry);
+		else
 			return false;
-
-		pfn =3D migration_entry_to_pfn(entry);
 	} else if (is_swap_pte(*pvmw->pte)) {
 		swp_entry_t entry;
=20
 		/* Handle un-addressable ZONE_DEVICE memory */
 		entry =3D pte_to_swp_entry(*pvmw->pte);
-		if (!is_device_private_entry(entry))
+		if (!is_device_private_entry(entry) && !is_device_exclusive_entry(entry)=
)
 			return false;
=20
 		pfn =3D device_private_entry_to_pfn(entry);
@@ -216,6 +219,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *=
pvmw)
 	}
 	if (!map_pte(pvmw))
 		goto next_pte;
+
 	while (1) {
 		if (check_pte(pvmw))
 			return true;
diff --git a/mm/rmap.c b/mm/rmap.c
index 08c56aaf72eb..e4d03f7a8c22 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1395,7 +1395,7 @@ static bool try_to_unmap_one(struct page *page, struc=
t vm_area_struct *vma,
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
=20
-	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
+	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & (TTU_MIGRATION | TTU_EXCLUSI=
VE)) &&
 	    is_zone_device_page(page) && !is_device_private_page(page))
 		return true;
=20
@@ -1591,6 +1591,33 @@ static bool try_to_unmap_one(struct page *page, stru=
ct vm_area_struct *vma,
 			/* We have to invalidate as we cleared the pte */
 			mmu_notifier_invalidate_range(mm, address,
 						      address + PAGE_SIZE);
+		} else if (flags & TTU_EXCLUSIVE) {
+			swp_entry_t entry;
+			pte_t swp_pte;
+
+			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				ret =3D false;
+				page_vma_mapped_walk_done(&pvmw);
+				break;
+			}
+
+			/*
+			 * Store the pfn of the page in a special migration
+			 * pte. do_swap_page() will wait until the migration
+			 * pte is removed and then restart fault handling.
+			 */
+			entry =3D make_device_exclusive_entry(subpage,
+					pte_write(pteval));
+			swp_pte =3D swp_entry_to_pte(entry);
+			if (pte_soft_dirty(pteval))
+				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
+			if (pte_uffd_wp(pteval))
+				swp_pte =3D pte_swp_mkuffd_wp(swp_pte);
+
+			/* Take a reference for the swap entry */
+			get_page(page);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
 		} else if (IS_ENABLED(CONFIG_MIGRATION) &&
 				(flags & (TTU_MIGRATION|TTU_SPLIT_FREEZE))) {
 			swp_entry_t entry;
--=20
2.20.1

