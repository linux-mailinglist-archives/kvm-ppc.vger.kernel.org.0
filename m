Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B69B18735E
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbgCPTc3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:32:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732473AbgCPTc3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:32:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bBAvW2afjKzm/CoJ7emh/yYG6aougu4F1J1DHDVjhAI=; b=lL4/z/qFJ7ebSsvMzYtVfbYA8I
        +DPJe3y1MWECUO6DTyKNTahMd5FC9+N1s3WUBjoU+Bg1wVwP7FTo209MxeaW44YDLyyo5jdp05LAG
        srCw/KyXrnEtCN1cL5ux2jnsw/NuqKsjHmWCorCXbLxe45uSKYN+MRVHStLGSblvaFdKby/vZMpjk
        +iT+DrjqFutr3xo1giwm3z/eyPZhc73DNr8i+uhRt/KMdcGy1OKTQoC+egox6uGgTXSPged1+1OUL
        Ipb9+sk2qKPrCkzTZhIMoc/HRiXNNjUkBriSIY/9GeQ5ZkdCfhwac/2Vu8bCQMVN7xf+FljWF4DJK
        Bj/gyusQ==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDvTL-0003bV-1l; Mon, 16 Mar 2020 19:32:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Cc:     Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: [PATCH 2/4] mm: handle multiple owners of device private pages in migrate_vma
Date:   Mon, 16 Mar 2020 20:32:14 +0100
Message-Id: <20200316193216.920734-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316193216.920734-1-hch@lst.de>
References: <20200316193216.920734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a new src_owner field to struct migrate_vma.  If the field is set,
only device private pages with page->pgmap->owner equal to that field
are migrated.  If the field is not set only "normal" pages are migrated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: df6ad69838fc ("mm/device-public-memory: device memory cache coherent with CPU")
---
 arch/powerpc/kvm/book3s_hv_uvmem.c     | 1 +
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 1 +
 include/linux/migrate.h                | 8 ++++++++
 mm/migrate.c                           | 9 ++++++---
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 67fefb03b9b7..f44f6b27950f 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -563,6 +563,7 @@ kvmppc_svm_page_out(struct vm_area_struct *vma, unsigned long start,
 	mig.end = end;
 	mig.src = &src_pfn;
 	mig.dst = &dst_pfn;
+	mig.src_owner = &kvmppc_uvmem_pgmap;
 
 	mutex_lock(&kvm->arch.uvmem_lock);
 	/* The requested page is already paged-out, nothing to do */
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index a4682272586e..0e36345d395c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -176,6 +176,7 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 		.end		= vmf->address + PAGE_SIZE,
 		.src		= &src,
 		.dst		= &dst,
+		.src_owner	= drm->dev,
 	};
 
 	/*
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 72120061b7d4..3e546cbf03dd 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -196,6 +196,14 @@ struct migrate_vma {
 	unsigned long		npages;
 	unsigned long		start;
 	unsigned long		end;
+
+	/*
+	 * Set to the owner value also stored in page->pgmap->owner for
+	 * migrating out of device private memory.  If set only device
+	 * private pages with this owner are migrated.  If not set
+	 * device private pages are not migrated at all.
+	 */
+	void			*src_owner;
 };
 
 int migrate_vma_setup(struct migrate_vma *args);
diff --git a/mm/migrate.c b/mm/migrate.c
index b1092876e537..7605d2c23433 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2241,7 +2241,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	arch_enter_lazy_mmu_mode();
 
 	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		unsigned long mpfn, pfn;
+		unsigned long mpfn = 0, pfn;
 		struct page *page;
 		swp_entry_t entry;
 		pte_t pte;
@@ -2255,8 +2255,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 		}
 
 		if (!pte_present(pte)) {
-			mpfn = 0;
-
 			/*
 			 * Only care about unaddressable device page special
 			 * page table entry. Other special swap entries are not
@@ -2267,11 +2265,16 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				goto next;
 
 			page = device_private_entry_to_page(entry);
+			if (page->pgmap->owner != migrate->src_owner)
+				goto next;
+
 			mpfn = migrate_pfn(page_to_pfn(page)) |
 					MIGRATE_PFN_MIGRATE;
 			if (is_write_device_private_entry(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
 		} else {
+			if (migrate->src_owner)
+				goto next;
 			pfn = pte_pfn(pte);
 			if (is_zero_pfn(pfn)) {
 				mpfn = MIGRATE_PFN_MIGRATE;
-- 
2.24.1

