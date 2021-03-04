Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819AE32CC9E
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 07:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhCDGSB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 01:18:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4468 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhCDGRj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 01:17:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60407b5a0003>; Wed, 03 Mar 2021 22:16:58 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 06:16:57 +0000
Received: from localhost (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar 2021 06:16:57
 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Jason Gunthorpe" <jgg@nvidia.com>
Subject: [PATCH v4 2/8] mm/swapops: Rework swap entry manipulation code
Date:   Thu, 4 Mar 2021 17:16:39 +1100
Message-ID: <20210304061645.29747-3-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304061645.29747-1-apopple@nvidia.com>
References: <20210304061645.29747-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614838618; bh=vmakt/yNlTT7YYAdjyoMaPpkazAgjtUnTBP/cCUHxPo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DeqjjUvBqYX6bG0AO5q/c/DCQpocPniWhKvn3JZLQgwK+qHe4lwxYhk9WYzpKbJ18
         rDsEbkcVvyeLbqyQr4pslTrYx7FdOm7YfAqak9E5iEPsJjn2kUtOWv0FxWeE/BE66p
         o+cqSsHjTtM6xPPl0O3KJTd3v1hsTAkCAsQHGnU2tXhTbMUFTVQP4Jz0hVMLWR1c5l
         OxfC8qv4Btrmedk7fwEHiXCAzgXI03Vz9waTTZRV7lnuPKxcZZfUsDjZwEwJ3ajjVe
         ZbKv/xpx4aJKd9mLr7s5drTDz5Fi/AuIMujHU+beiP1rCRDYUeXPyfGOqRk5bh0vkY
         5e9licMe9z2Pg==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Both migration and device private pages use special swap entries that
are manipluated by a range of inline functions. The arguments to these
are somewhat inconsitent so rework them to remove flag type arguments
and to make the arguments similar for both read and write entry
creation.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/swapops.h | 56 ++++++++++++++++++++++-------------------
 mm/debug_vm_pgtable.c   | 12 ++++-----
 mm/hmm.c                |  2 +-
 mm/huge_memory.c        | 26 +++++++++++++------
 mm/hugetlb.c            | 10 +++++---
 mm/memory.c             | 10 +++++---
 mm/migrate.c            | 26 ++++++++++++++-----
 mm/mprotect.c           | 10 +++++---
 mm/rmap.c               | 10 +++++---
 9 files changed, 100 insertions(+), 62 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 3fd88081107c..81008b0179cc 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -100,35 +100,35 @@ static inline void *swp_to_radix_entry(swp_entry_t en=
try)
 }
=20
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
-static inline swp_entry_t make_device_private_entry(struct page *page, boo=
l write)
+static inline swp_entry_t make_readable_device_private_entry(pgoff_t offse=
t)
 {
-	return swp_entry(write ? SWP_DEVICE_WRITE : SWP_DEVICE_READ,
-			 page_to_pfn(page));
+	return swp_entry(SWP_DEVICE_READ, offset);
 }
=20
-static inline bool is_device_private_entry(swp_entry_t entry)
+static inline swp_entry_t make_writable_device_private_entry(pgoff_t offse=
t)
 {
-	int type =3D swp_type(entry);
-	return type =3D=3D SWP_DEVICE_READ || type =3D=3D SWP_DEVICE_WRITE;
+	return swp_entry(SWP_DEVICE_WRITE, offset);
 }
=20
-static inline void make_device_private_entry_read(swp_entry_t *entry)
+static inline bool is_device_private_entry(swp_entry_t entry)
 {
-	*entry =3D swp_entry(SWP_DEVICE_READ, swp_offset(*entry));
+	int type =3D swp_type(entry);
+	return type =3D=3D SWP_DEVICE_READ || type =3D=3D SWP_DEVICE_WRITE;
 }
=20
-static inline bool is_write_device_private_entry(swp_entry_t entry)
+static inline bool is_writable_device_private_entry(swp_entry_t entry)
 {
 	return unlikely(swp_type(entry) =3D=3D SWP_DEVICE_WRITE);
 }
 #else /* CONFIG_DEVICE_PRIVATE */
-static inline swp_entry_t make_device_private_entry(struct page *page, boo=
l write)
+static inline swp_entry_t make_readable_device_private_entry(pgoff_t offse=
t)
 {
 	return swp_entry(0, 0);
 }
=20
-static inline void make_device_private_entry_read(swp_entry_t *entry)
+static inline swp_entry_t make_writable_device_private_entry(pgoff_t offse=
t)
 {
+	return swp_entry(0, 0);
 }
=20
 static inline bool is_device_private_entry(swp_entry_t entry)
@@ -136,35 +136,32 @@ static inline bool is_device_private_entry(swp_entry_=
t entry)
 	return false;
 }
=20
-static inline bool is_write_device_private_entry(swp_entry_t entry)
+static inline bool is_writable_device_private_entry(swp_entry_t entry)
 {
 	return false;
 }
 #endif /* CONFIG_DEVICE_PRIVATE */
=20
 #ifdef CONFIG_MIGRATION
-static inline swp_entry_t make_migration_entry(struct page *page, int writ=
e)
-{
-	BUG_ON(!PageLocked(compound_head(page)));
-
-	return swp_entry(write ? SWP_MIGRATION_WRITE : SWP_MIGRATION_READ,
-			page_to_pfn(page));
-}
-
 static inline int is_migration_entry(swp_entry_t entry)
 {
 	return unlikely(swp_type(entry) =3D=3D SWP_MIGRATION_READ ||
 			swp_type(entry) =3D=3D SWP_MIGRATION_WRITE);
 }
=20
-static inline int is_write_migration_entry(swp_entry_t entry)
+static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return unlikely(swp_type(entry) =3D=3D SWP_MIGRATION_WRITE);
 }
=20
-static inline void make_migration_entry_read(swp_entry_t *entry)
+static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 {
-	*entry =3D swp_entry(SWP_MIGRATION_READ, swp_offset(*entry));
+	return swp_entry(SWP_MIGRATION_READ, offset);
+}
+
+static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_WRITE, offset);
 }
=20
 extern void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
@@ -174,21 +171,28 @@ extern void migration_entry_wait(struct mm_struct *mm=
, pmd_t *pmd,
 extern void migration_entry_wait_huge(struct vm_area_struct *vma,
 		struct mm_struct *mm, pte_t *pte);
 #else
+static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
=20
-#define make_migration_entry(page, write) swp_entry(0, 0)
 static inline int is_migration_entry(swp_entry_t swp)
 {
 	return 0;
 }
=20
-static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void __migration_entry_wait(struct mm_struct *mm, pte_t *pte=
p,
 					spinlock_t *ptl) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
 static inline void migration_entry_wait_huge(struct vm_area_struct *vma,
 		struct mm_struct *mm, pte_t *pte) { }
-static inline int is_write_migration_entry(swp_entry_t entry)
+static inline int is_writable_migration_entry(swp_entry_t entry)
 {
 	return 0;
 }
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index c05d9dcf7891..4932f65a88d4 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -772,17 +772,17 @@ static void __init swap_migration_tests(void)
 	 * locked, otherwise it stumbles upon a BUG_ON().
 	 */
 	__SetPageLocked(page);
-	swp =3D make_migration_entry(page, 1);
+	swp =3D make_writable_migration_entry(page_to_pfn(page));
 	WARN_ON(!is_migration_entry(swp));
-	WARN_ON(!is_write_migration_entry(swp));
+	WARN_ON(!is_writable_migration_entry(swp));
=20
-	make_migration_entry_read(&swp);
+	swp =3D make_readable_migration_entry(swp_offset(swp));
 	WARN_ON(!is_migration_entry(swp));
-	WARN_ON(is_write_migration_entry(swp));
+	WARN_ON(is_writable_migration_entry(swp));
=20
-	swp =3D make_migration_entry(page, 0);
+	swp =3D make_readable_migration_entry(page_to_pfn(page));
 	WARN_ON(!is_migration_entry(swp));
-	WARN_ON(is_write_migration_entry(swp));
+	WARN_ON(is_writable_migration_entry(swp));
 	__ClearPageLocked(page);
 	__free_page(page);
 }
diff --git a/mm/hmm.c b/mm/hmm.c
index 3b2dda71d0ed..11df3ca30b82 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -255,7 +255,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, uns=
igned long addr,
 		 */
 		if (hmm_is_device_private_entry(range, entry)) {
 			cpu_flags =3D HMM_PFN_VALID;
-			if (is_write_device_private_entry(entry))
+			if (is_writable_device_private_entry(entry))
 				cpu_flags |=3D HMM_PFN_WRITE;
 			*hmm_pfn =3D swp_offset(entry) | cpu_flags;
 			return 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d65eebf446ae..cb3bc9d3ed3a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1046,8 +1046,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm=
_struct *src_mm,
 		swp_entry_t entry =3D pmd_to_swp_entry(pmd);
=20
 		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (is_write_migration_entry(entry)) {
-			make_migration_entry_read(&entry);
+		if (is_writable_migration_entry(entry)) {
+			entry =3D make_readable_migration_entry(
+							swp_offset(entry));
 			pmd =3D swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd =3D pmd_swp_mksoft_dirty(pmd);
@@ -1820,13 +1821,14 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd=
_t *pmd,
 		swp_entry_t entry =3D pmd_to_swp_entry(*pmd);
=20
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
-		if (is_write_migration_entry(entry)) {
+		if (is_writable_migration_entry(entry)) {
 			pmd_t newpmd;
 			/*
 			 * A protection check is difficult so
 			 * just be safe and disable write
 			 */
-			make_migration_entry_read(&entry);
+			entry =3D make_readable_migration_entry(
+							swp_offset(entry));
 			newpmd =3D swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd =3D pmd_swp_mksoft_dirty(newpmd);
@@ -2104,7 +2106,7 @@ static void __split_huge_pmd_locked(struct vm_area_st=
ruct *vma, pmd_t *pmd,
=20
 		entry =3D pmd_to_swp_entry(old_pmd);
 		page =3D pfn_swap_entry_to_page(entry);
-		write =3D is_write_migration_entry(entry);
+		write =3D is_writable_migration_entry(entry);
 		young =3D false;
 		soft_dirty =3D pmd_swp_soft_dirty(old_pmd);
 		uffd_wp =3D pmd_swp_uffd_wp(old_pmd);
@@ -2136,7 +2138,12 @@ static void __split_huge_pmd_locked(struct vm_area_s=
truct *vma, pmd_t *pmd,
 		 */
 		if (freeze || pmd_migration) {
 			swp_entry_t swp_entry;
-			swp_entry =3D make_migration_entry(page + i, write);
+			if (write)
+				swp_entry =3D make_writable_migration_entry(
+							page_to_pfn(page + i));
+			else
+				swp_entry =3D make_readable_migration_entry(
+							page_to_pfn(page + i));
 			entry =3D swp_entry_to_pte(swp_entry);
 			if (soft_dirty)
 				entry =3D pte_swp_mksoft_dirty(entry);
@@ -2988,7 +2995,10 @@ void set_pmd_migration_entry(struct page_vma_mapped_=
walk *pvmw,
 	pmdval =3D pmdp_invalidate(vma, address, pvmw->pmd);
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
-	entry =3D make_migration_entry(page, pmd_write(pmdval));
+	if (pmd_write(pmdval))
+		entry =3D make_writable_migration_entry(page_to_pfn(page));
+	else
+		entry =3D make_readable_migration_entry(page_to_pfn(page));
 	pmdswp =3D swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp =3D pmd_swp_mksoft_dirty(pmdswp);
@@ -3014,7 +3024,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk=
 *pvmw, struct page *new)
 	pmde =3D pmd_mkold(mk_huge_pmd(new, vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde =3D pmd_mksoft_dirty(pmde);
-	if (is_write_migration_entry(entry))
+	if (is_writable_migration_entry(entry))
 		pmde =3D maybe_pmd_mkwrite(pmde, vma);
=20
 	flush_cache_range(vma, mmun_start, mmun_start + HPAGE_PMD_SIZE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4bdb58ab14cb..37cde6d4303c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3842,12 +3842,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, =
struct mm_struct *src,
 				    is_hugetlb_entry_hwpoisoned(entry))) {
 			swp_entry_t swp_entry =3D pte_to_swp_entry(entry);
=20
-			if (is_write_migration_entry(swp_entry) && cow) {
+			if (is_writable_migration_entry(swp_entry) && cow) {
 				/*
 				 * COW mappings require pages in both
 				 * parent and child to be set to read.
 				 */
-				make_migration_entry_read(&swp_entry);
+				swp_entry =3D make_readable_migration_entry(
+							swp_offset(swp_entry));
 				entry =3D swp_entry_to_pte(swp_entry);
 				set_huge_swap_pte_at(src, addr, src_pte,
 						     entry, sz);
@@ -5019,10 +5020,11 @@ unsigned long hugetlb_change_protection(struct vm_a=
rea_struct *vma,
 		if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry =3D pte_to_swp_entry(pte);
=20
-			if (is_write_migration_entry(entry)) {
+			if (is_writable_migration_entry(entry)) {
 				pte_t newpte;
=20
-				make_migration_entry_read(&entry);
+				entry =3D make_readable_migration_entry(
+							swp_offset(entry));
 				newpte =3D swp_entry_to_pte(entry);
 				set_huge_swap_pte_at(mm, address, ptep,
 						     newpte, huge_page_size(h));
diff --git a/mm/memory.c b/mm/memory.c
index 99a6a695b1b1..957e00525a9a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -722,13 +722,14 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct =
mm_struct *src_mm,
=20
 		rss[mm_counter(page)]++;
=20
-		if (is_write_migration_entry(entry) &&
+		if (is_writable_migration_entry(entry) &&
 				is_cow_mapping(vm_flags)) {
 			/*
 			 * COW mappings require pages in both
 			 * parent and child to be set to read.
 			 */
-			make_migration_entry_read(&entry);
+			entry =3D make_readable_migration_entry(
+							swp_offset(entry));
 			pte =3D swp_entry_to_pte(entry);
 			if (pte_swp_soft_dirty(*src_pte))
 				pte =3D pte_swp_mksoft_dirty(pte);
@@ -759,9 +760,10 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct m=
m_struct *src_mm,
 		 * when a device driver is involved (you cannot easily
 		 * save and restore device driver state).
 		 */
-		if (is_write_device_private_entry(entry) &&
+		if (is_writable_device_private_entry(entry) &&
 		    is_cow_mapping(vm_flags)) {
-			make_device_private_entry_read(&entry);
+			entry =3D make_readable_device_private_entry(
+							swp_offset(entry));
 			pte =3D swp_entry_to_pte(entry);
 			if (pte_swp_uffd_wp(*src_pte))
 				pte =3D pte_swp_mkuffd_wp(pte);
diff --git a/mm/migrate.c b/mm/migrate.c
index 39246907eac3..30c18e7c6089 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -237,13 +237,18 @@ static bool remove_migration_pte(struct page *page, s=
truct vm_area_struct *vma,
 		 * Recheck VMA as permissions can change since migration started
 		 */
 		entry =3D pte_to_swp_entry(*pvmw.pte);
-		if (is_write_migration_entry(entry))
+		if (is_writable_migration_entry(entry))
 			pte =3D maybe_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte =3D pte_mkuffd_wp(pte);
=20
 		if (unlikely(is_device_private_page(new))) {
-			entry =3D make_device_private_entry(new, pte_write(pte));
+			if (pte_write(pte))
+				entry =3D make_writable_device_private_entry(
+							page_to_pfn(new));
+			else
+				entry =3D make_readable_device_private_entry(
+							page_to_pfn(new));
 			pte =3D swp_entry_to_pte(entry);
 			if (pte_swp_soft_dirty(*pvmw.pte))
 				pte =3D pte_swp_mksoft_dirty(pte);
@@ -2445,7 +2450,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
=20
 			mpfn =3D migrate_pfn(page_to_pfn(page)) |
 					MIGRATE_PFN_MIGRATE;
-			if (is_write_device_private_entry(entry))
+			if (is_writable_device_private_entry(entry))
 				mpfn |=3D MIGRATE_PFN_WRITE;
 		} else {
 			if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
@@ -2491,8 +2496,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			ptep_get_and_clear(mm, addr, ptep);
=20
 			/* Setup special migration page table entry */
-			entry =3D make_migration_entry(page, mpfn &
-						     MIGRATE_PFN_WRITE);
+			if (mpfn & MIGRATE_PFN_WRITE)
+				entry =3D make_writable_migration_entry(
+							page_to_pfn(page));
+			else
+				entry =3D make_readable_migration_entry(
+							page_to_pfn(page));
 			swp_pte =3D swp_entry_to_pte(entry);
 			if (pte_present(pte)) {
 				if (pte_soft_dirty(pte))
@@ -2965,7 +2974,12 @@ static void migrate_vma_insert_page(struct migrate_v=
ma *migrate,
 		if (is_device_private_page(page)) {
 			swp_entry_t swp_entry;
=20
-			swp_entry =3D make_device_private_entry(page, vma->vm_flags & VM_WRITE)=
;
+			if (vma->vm_flags & VM_WRITE)
+				swp_entry =3D make_writable_device_private_entry(
+							page_to_pfn(page));
+			else
+				swp_entry =3D make_readable_device_private_entry(
+							page_to_pfn(page));
 			entry =3D swp_entry_to_pte(swp_entry);
 		}
 	} else {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ab709023e9aa..a6c757d87789 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -143,23 +143,25 @@ static unsigned long change_pte_range(struct vm_area_=
struct *vma, pmd_t *pmd,
 			swp_entry_t entry =3D pte_to_swp_entry(oldpte);
 			pte_t newpte;
=20
-			if (is_write_migration_entry(entry)) {
+			if (is_writable_migration_entry(entry)) {
 				/*
 				 * A protection check is difficult so
 				 * just be safe and disable write
 				 */
-				make_migration_entry_read(&entry);
+				entry =3D make_readable_migration_entry(
+							swp_offset(entry));
 				newpte =3D swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte =3D pte_swp_mksoft_dirty(newpte);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte =3D pte_swp_mkuffd_wp(newpte);
-			} else if (is_write_device_private_entry(entry)) {
+			} else if (is_writable_device_private_entry(entry)) {
 				/*
 				 * We do not preserve soft-dirtiness. See
 				 * copy_one_pte() for explanation.
 				 */
-				make_device_private_entry_read(&entry);
+				entry =3D make_readable_device_private_entry(
+							swp_offset(entry));
 				newpte =3D swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte =3D pte_swp_mkuffd_wp(newpte);
diff --git a/mm/rmap.c b/mm/rmap.c
index 08c56aaf72eb..ef9ef2694c58 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1512,7 +1512,7 @@ static bool try_to_unmap_one(struct page *page, struc=
t vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			entry =3D make_migration_entry(page, 0);
+			entry =3D make_readable_migration_entry(page_to_pfn(page));
 			swp_pte =3D swp_entry_to_pte(entry);
=20
 			/*
@@ -1608,8 +1608,12 @@ static bool try_to_unmap_one(struct page *page, stru=
ct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			entry =3D make_migration_entry(subpage,
-					pte_write(pteval));
+			if (pte_write(pteval))
+				entry =3D make_writable_migration_entry(
+							page_to_pfn(subpage));
+			else
+				entry =3D make_readable_migration_entry(
+							page_to_pfn(subpage));
 			swp_pte =3D swp_entry_to_pte(entry);
 			if (pte_soft_dirty(pteval))
 				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
--=20
2.20.1

