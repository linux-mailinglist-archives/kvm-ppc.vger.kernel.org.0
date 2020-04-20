Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89C01B0B74
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgDTMpU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:45:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728694AbgDTMpU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:45:20 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCVsnv034218;
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvfnwuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCWpaJ037375;
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmvfnwtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:07 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCdtnq020519;
        Mon, 20 Apr 2020 12:45:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 30fs660jfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:05 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCj4CI58917252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:04 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 820DF136059;
        Mon, 20 Apr 2020 12:45:04 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4CC513604F;
        Mon, 20 Apr 2020 12:45:00 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:45:00 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 04/22] powerpc/hash64: Restrict page table lookup using init_mm with __flush_hash_table_range
Date:   Mon, 20 Apr 2020 18:14:16 +0530
Message-Id: <20200420124434.47330-5-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200107
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is only used with init_mm currently. Walking init_mm is much simpler
because we don't need to handle concurrent page table like other mm_context

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 .../include/asm/book3s/64/tlbflush-hash.h        |  3 +--
 arch/powerpc/kernel/pci_64.c                     |  2 +-
 arch/powerpc/mm/book3s64/hash_tlb.c              | 16 +++-------------
 3 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 64d02a704bcb..3b95769739c7 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -113,8 +113,7 @@ static inline void hash__flush_tlb_kernel_range(unsigned long start,
 struct mmu_gather;
 extern void hash__tlb_flush(struct mmu_gather *tlb);
 /* Private function for use by PCI IO mapping code */
-extern void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
-				     unsigned long end);
+extern void __flush_hash_table_range(unsigned long start, unsigned long end);
 extern void flush_tlb_pmd_range(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr);
 #endif /*  _ASM_POWERPC_BOOK3S_64_TLBFLUSH_HASH_H */
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index f83d1f69b1dd..30d07fc79dd1 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -100,7 +100,7 @@ int pcibios_unmap_io_space(struct pci_bus *bus)
 			 pci_name(bus->self));
 
 #ifdef CONFIG_PPC_BOOK3S_64
-		__flush_hash_table_range(&init_mm, res->start + _IO_BASE,
+		__flush_hash_table_range(res->start + _IO_BASE,
 					 res->end + _IO_BASE + 1);
 #endif
 		return 0;
diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index 4a70d8dd39cd..1fa2173413b5 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -176,7 +176,6 @@ void hash__tlb_flush(struct mmu_gather *tlb)
  *                            from the hash table (and the TLB). But keeps
  *                            the linux PTEs intact.
  *
- * @mm		: mm_struct of the target address space (generally init_mm)
  * @start	: starting address
  * @end         : ending address (not included in the flush)
  *
@@ -189,17 +188,14 @@ void hash__tlb_flush(struct mmu_gather *tlb)
  * Because of that usage pattern, it is implemented for small size rather
  * than speed.
  */
-void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
-			      unsigned long end)
+void __flush_hash_table_range(unsigned long start, unsigned long end)
 {
-	bool is_thp;
 	int hugepage_shift;
 	unsigned long flags;
 
 	start = _ALIGN_DOWN(start, PAGE_SIZE);
 	end = _ALIGN_UP(end, PAGE_SIZE);
 
-	BUG_ON(!mm->pgd);
 
 	/*
 	 * Note: Normally, we should only ever use a batch within a
@@ -212,21 +208,15 @@ void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
 	local_irq_save(flags);
 	arch_enter_lazy_mmu_mode();
 	for (; start < end; start += PAGE_SIZE) {
-		pte_t *ptep = find_current_mm_pte(mm->pgd, start, &is_thp,
-						  &hugepage_shift);
+		pte_t *ptep = find_init_mm_pte(start, &hugepage_shift);
 		unsigned long pte;
 
 		if (ptep == NULL)
 			continue;
 		pte = pte_val(*ptep);
-		if (is_thp)
-			trace_hugepage_invalidate(start, pte);
 		if (!(pte & H_PAGE_HASHPTE))
 			continue;
-		if (unlikely(is_thp))
-			hpte_do_hugepage_flush(mm, start, (pmd_t *)ptep, pte);
-		else
-			hpte_need_flush(mm, start, ptep, pte, hugepage_shift);
+		hpte_need_flush(&init_mm, start, ptep, pte, hugepage_shift);
 	}
 	arch_leave_lazy_mmu_mode();
 	local_irq_restore(flags);
-- 
2.25.3

