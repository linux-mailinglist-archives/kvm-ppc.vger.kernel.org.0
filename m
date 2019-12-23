Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535681291B7
	for <lists+kvm-ppc@lfdr.de>; Mon, 23 Dec 2019 07:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfLWGD6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 23 Dec 2019 01:03:58 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:51832 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfLWGD6 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 23 Dec 2019 01:03:58 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 46322AE80026;
        Mon, 23 Dec 2019 01:02:44 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH kernel v3] powerpc/book3s64: Fix error handling in mm_iommu_do_alloc()
Date:   Mon, 23 Dec 2019 17:03:51 +1100
Message-Id: <20191223060351.26359-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The last jump to free_exit in mm_iommu_do_alloc() happens after page
pointers in struct mm_iommu_table_group_mem_t were already converted to
physical addresses. Thus calling put_page() on these physical addresses
will likely crash.

This moves the loop which calculates the pageshift and converts page
struct pointers to physical addresses later after the point when
we cannot fail; thus eliminating the need to convert pointers back.

Fixes: eb9d7a62c386 ("powerpc/mm_iommu: Fix potential deadlock")
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v3:
* move pointers conversion after the last possible failure point
---
 arch/powerpc/mm/book3s64/iommu_api.c | 39 +++++++++++++++-------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 56cc84520577..ef164851738b 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -121,24 +121,6 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 		goto free_exit;
 	}
 
-	pageshift = PAGE_SHIFT;
-	for (i = 0; i < entries; ++i) {
-		struct page *page = mem->hpages[i];
-
-		/*
-		 * Allow to use larger than 64k IOMMU pages. Only do that
-		 * if we are backed by hugetlb.
-		 */
-		if ((mem->pageshift > PAGE_SHIFT) && PageHuge(page))
-			pageshift = page_shift(compound_head(page));
-		mem->pageshift = min(mem->pageshift, pageshift);
-		/*
-		 * We don't need struct page reference any more, switch
-		 * to physical address.
-		 */
-		mem->hpas[i] = page_to_pfn(page) << PAGE_SHIFT;
-	}
-
 good_exit:
 	atomic64_set(&mem->mapped, 1);
 	mem->used = 1;
@@ -158,6 +140,27 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 		}
 	}
 
+	if (mem->dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
+		/*
+		 * Allow to use larger than 64k IOMMU pages. Only do that
+		 * if we are backed by hugetlb. Skip device memory as it is not
+		 * backed with page structs.
+		 */
+		pageshift = PAGE_SHIFT;
+		for (i = 0; i < entries; ++i) {
+			struct page *page = mem->hpages[i];
+
+			if ((mem->pageshift > PAGE_SHIFT) && PageHuge(page))
+				pageshift = page_shift(compound_head(page));
+			mem->pageshift = min(mem->pageshift, pageshift);
+			/*
+			 * We don't need struct page reference any more, switch
+			 * to physical address.
+			 */
+			mem->hpas[i] = page_to_pfn(page) << PAGE_SHIFT;
+		}
+	}
+
 	list_add_rcu(&mem->next, &mm->context.iommu_group_mem_list);
 
 	mutex_unlock(&mem_list_mutex);
-- 
2.17.1

