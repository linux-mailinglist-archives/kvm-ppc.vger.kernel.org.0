Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6818AB5B
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgCSD4y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:56:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgCSD4y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:56:54 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3Wa3G104640;
        Wed, 18 Mar 2020 23:56:41 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8adxvh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:40 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3WhKr104976;
        Wed, 18 Mar 2020 23:56:40 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8adxvgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:39 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3gCQ4030527;
        Thu, 19 Mar 2020 03:56:38 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 2yrpw75ngb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:56:38 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3ucem39649772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:56:38 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FACD112064;
        Thu, 19 Mar 2020 03:56:38 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B9B611206D;
        Thu, 19 Mar 2020 03:56:34 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:56:34 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 05/22] powerpc/book3s64/hash: Use the pte_t address from the caller
Date:   Thu, 19 Mar 2020 09:25:52 +0530
Message-Id: <20200319035609.158654-6-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
References: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_10:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190015
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Don't fetch the pte value using lockless page table walk. Instead use the value from the
caller. hash_preload is called with ptl lock held. So it is safe to use the
pte_t address directly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index e2a7873c7760..81b4130ceb05 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1545,14 +1545,11 @@ static bool should_hash_preload(struct mm_struct *mm, unsigned long ea)
 }
 #endif
 
-static void hash_preload(struct mm_struct *mm, unsigned long ea,
+static void hash_preload(struct mm_struct *mm, pte_t *ptep, unsigned long ea,
 			 bool is_exec, unsigned long trap)
 {
-	int hugepage_shift;
 	unsigned long vsid;
 	pgd_t *pgdir;
-	pte_t *ptep;
-	unsigned long flags;
 	int rc, ssize, update_flags = 0;
 	unsigned long access = _PAGE_PRESENT | _PAGE_READ | (is_exec ? _PAGE_EXEC : 0);
 
@@ -1574,30 +1571,18 @@ static void hash_preload(struct mm_struct *mm, unsigned long ea,
 	vsid = get_user_vsid(&mm->context, ea, ssize);
 	if (!vsid)
 		return;
-	/*
-	 * Hash doesn't like irqs. Walking linux page table with irq disabled
-	 * saves us from holding multiple locks.
-	 */
-	local_irq_save(flags);
 
-	/*
-	 * THP pages use update_mmu_cache_pmd. We don't do
-	 * hash preload there. Hence can ignore THP here
-	 */
-	ptep = find_current_mm_pte(pgdir, ea, NULL, &hugepage_shift);
-	if (!ptep)
-		goto out_exit;
-
-	WARN_ON(hugepage_shift);
 #ifdef CONFIG_PPC_64K_PAGES
 	/* If either H_PAGE_4K_PFN or cache inhibited is set (and we are on
 	 * a 64K kernel), then we don't preload, hash_page() will take
 	 * care of it once we actually try to access the page.
 	 * That way we don't have to duplicate all of the logic for segment
 	 * page size demotion here
+	 * Called with  PTL held, hence can be sure the value won't change in
+	 * between.
 	 */
 	if ((pte_val(*ptep) & H_PAGE_4K_PFN) || pte_ci(*ptep))
-		goto out_exit;
+		return;
 #endif /* CONFIG_PPC_64K_PAGES */
 
 	/* Is that local to this CPU ? */
@@ -1622,8 +1607,6 @@ static void hash_preload(struct mm_struct *mm, unsigned long ea,
 				   mm_ctx_user_psize(&mm->context),
 				   mm_ctx_user_psize(&mm->context),
 				   pte_val(*ptep));
-out_exit:
-	local_irq_restore(flags);
 }
 
 /*
@@ -1674,7 +1657,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
 		return;
 	}
 
-	hash_preload(vma->vm_mm, address, is_exec, trap);
+	hash_preload(vma->vm_mm, ptep, address, is_exec, trap);
 }
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-- 
2.24.1

