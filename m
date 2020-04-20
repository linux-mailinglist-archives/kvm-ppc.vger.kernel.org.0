Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BD61B0B24
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgDTMxw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:53:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728951AbgDTMqe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:46:34 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCe1bD033467;
        Mon, 20 Apr 2020 08:46:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu6wt7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:20 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCXneI006890;
        Mon, 20 Apr 2020 08:46:20 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu6wt77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:20 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KChHwP008911;
        Mon, 20 Apr 2020 12:46:19 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 30fs65rj6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:46:19 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCkHha62325118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:46:17 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E2D113604F;
        Mon, 20 Apr 2020 12:46:17 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ED39136059;
        Mon, 20 Apr 2020 12:46:13 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:46:13 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 20/22] powerpc/mm/book3s64: Avoid sending IPI on clearing PMD
Date:   Mon, 20 Apr 2020 18:14:32 +0530
Message-Id: <20200420124434.47330-21-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=962
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200107
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Now that all the lockless page table walk is careful w.r.t the PTE
address returned, we can now revert
commit: 13bd817bb884 ("powerpc/thp: Serialize pmd clear against a linux page table walk.")

We also drop the equivalent IPI from other pte updates routines. We still keep
IPI in hash pmdp collapse and that is to take care of parallel hash page table
insert. The radix pmdp collapse flush can possibly be removed once I am sure
generic code doesn't have the any expectations around parallel gup walk.

This speeds up Qemu guest RAM del/unplug time as below

128 core, 496GB guest:

Without patch:
munmap start: timer = 13162 ms, PID=7684
munmap finish: timer = 95312 ms, PID=7684 - delta = 82150 ms

With patch:
munmap start: timer = 196449 ms, PID=6681
munmap finish: timer = 196488 ms, PID=6681 - delta = 39ms

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/mm/book3s64/hash_pgtable.c  | 11 -----------
 arch/powerpc/mm/book3s64/pgtable.c       |  8 --------
 arch/powerpc/mm/book3s64/radix_pgtable.c | 19 +++++++------------
 3 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index 64733b9cb20a..64ca375278dc 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -363,17 +363,6 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
 	 * hash fault look at them.
 	 */
 	memset(pgtable, 0, PTE_FRAG_SIZE);
-	/*
-	 * Serialize against find_current_mm_pte variants which does lock-less
-	 * lookup in page tables with local interrupts disabled. For huge pages
-	 * it casts pmd_t to pte_t. Since format of pte_t is different from
-	 * pmd_t we want to prevent transit from pmd pointing to page table
-	 * to pmd pointing to huge page (and back) while interrupts are disabled.
-	 * We clear pmd to possibly replace it with page table pointer in
-	 * different code paths. So make sure we wait for the parallel
-	 * find_curren_mm_pte to finish.
-	 */
-	serialize_against_pte_lookup(mm);
 	return old_pmd;
 }
 
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index e0bb69c616e4..127325ead505 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -109,14 +109,6 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 
 	old_pmd = pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, _PAGE_INVALID);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-	/*
-	 * This ensures that generic code that rely on IRQ disabling
-	 * to prevent a parallel THP split work as expected.
-	 *
-	 * Marking the entry with _PAGE_INVALID && ~_PAGE_PRESENT requires
-	 * a special case check in pmd_access_permitted.
-	 */
-	serialize_against_pte_lookup(vma->vm_mm);
 	return __pmd(old_pmd);
 }
 
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 8f9edf07063a..dfb9fe92aea8 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -962,7 +962,13 @@ pmd_t radix__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long addre
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
-	/*FIXME!!  Verify whether we need this kick below */
+	/*
+	 * pmdp collapse_flush need to ensure that there are no parallel gup
+	 * walk after this call. This is needed so that we can have stable
+	 * page ref count when collapsing a page. We don't allow a collapse page
+	 * if we have gup taken on the page. We can ensure that by sending IPI
+	 * because gup walk happens with IRQ disabled.
+	 */
 	serialize_against_pte_lookup(vma->vm_mm);
 
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
@@ -1023,17 +1029,6 @@ pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 	old = radix__pmd_hugepage_update(mm, addr, pmdp, ~0UL, 0);
 	old_pmd = __pmd(old);
-	/*
-	 * Serialize against find_current_mm_pte which does lock-less
-	 * lookup in page tables with local interrupts disabled. For huge pages
-	 * it casts pmd_t to pte_t. Since format of pte_t is different from
-	 * pmd_t we want to prevent transit from pmd pointing to page table
-	 * to pmd pointing to huge page (and back) while interrupts are disabled.
-	 * We clear pmd to possibly replace it with page table pointer in
-	 * different code paths. So make sure we wait for the parallel
-	 * find_current_mm_pte to finish.
-	 */
-	serialize_against_pte_lookup(mm);
 	return old_pmd;
 }
 
-- 
2.25.3

