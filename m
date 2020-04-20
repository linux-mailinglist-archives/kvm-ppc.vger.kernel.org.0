Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC281B0A45
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgDTMqt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:46:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728958AbgDTMqj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:46:39 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCXXpj039417;
        Mon, 20 Apr 2020 08:46:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnshac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:25 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCb6Y5050200;
        Mon, 20 Apr 2020 08:46:25 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnsha1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:46:24 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KChNlD028911;
        Mon, 20 Apr 2020 12:46:24 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 30fs66cpxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:46:24 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCkMbl52101380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:46:22 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E6EB136051;
        Mon, 20 Apr 2020 12:46:22 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 269EB13604F;
        Mon, 20 Apr 2020 12:46:18 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:46:17 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        akpm@linux-foundation.org
Subject: [PATCH v3 21/22] mm: change pmdp_huge_get_and_clear_full take vm_area_struct as arg
Date:   Mon, 20 Apr 2020 18:14:33 +0530
Message-Id: <20200420124434.47330-22-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_04:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200110
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

We will use this in later patch to do tlb flush when clearing pmd entries.

Cc: kirill@shutemov.name
Cc: akpm@linux-foundation.org
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 4 ++--
 include/asm-generic/pgtable.h   | 4 ++--
 mm/huge_memory.c                | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6076c8c912d2..e2528e057980 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1560,7 +1560,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 }
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
-static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
+static inline pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
 						 unsigned long addr,
 						 pmd_t *pmdp, int full)
 {
@@ -1569,7 +1569,7 @@ static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
 		*pmdp = __pmd(_SEGMENT_ENTRY_EMPTY);
 		return pmd;
 	}
-	return pmdp_xchg_lazy(mm, addr, pmdp, __pmd(_SEGMENT_ENTRY_EMPTY));
+	return pmdp_xchg_lazy(vma->vm_mm, addr, pmdp, __pmd(_SEGMENT_ENTRY_EMPTY));
 }
 
 #define __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 329b8c8ca703..d10be362eafa 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -159,11 +159,11 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
-static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
+static inline pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
 					    unsigned long address, pmd_t *pmdp,
 					    int full)
 {
-	return pmdp_huge_get_and_clear(mm, address, pmdp);
+	return pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 }
 #endif
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6ecd1045113b..16f2bd6f1549 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1852,8 +1852,8 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 * pgtable_trans_huge_withdraw after finishing pmdp related
 	 * operations.
 	 */
-	orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
-			tlb->fullmm);
+	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
+						tlb->fullmm);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 	if (vma_is_special_huge(vma)) {
 		if (arch_needs_pgtable_deposit())
-- 
2.25.3

