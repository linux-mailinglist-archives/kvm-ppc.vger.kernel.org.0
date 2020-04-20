Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FE81B0B49
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgDTMqN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:46:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59694 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728883AbgDTMqI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:46:08 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCWZBa134815;
        Mon, 20 Apr 2020 08:45:39 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghmb0xx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:39 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCWbWD135016;
        Mon, 20 Apr 2020 08:45:39 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ghmb0xwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:39 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCduKb007040;
        Mon, 20 Apr 2020 12:45:38 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 30fs66cqjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:38 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCjatI60359036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:36 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA98B136055;
        Mon, 20 Apr 2020 12:45:36 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 184B6136053;
        Mon, 20 Apr 2020 12:45:33 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:45:32 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 11/22] powerpc/kvm/book3s: Use kvm helpers to walk shadow or secondary table
Date:   Mon, 20 Apr 2020 18:14:23 +0530
Message-Id: <20200420124434.47330-12-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
References: <20200420124434.47330-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_03:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200107
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

update kvmppc_hv_handle_set_rc to use find_kvm_nested_guest_pte and
find_kvm_secondary_pte

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s.h    |  2 +-
 arch/powerpc/include/asm/kvm_book3s_64.h |  3 +++
 arch/powerpc/kvm/book3s_64_mmu_radix.c   | 18 +++++++++---------
 arch/powerpc/kvm/book3s_hv_nested.c      | 13 ++++++-------
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 506e4df2d730..37c8b50cb505 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -198,7 +198,7 @@ extern void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 			unsigned int shift,
 			const struct kvm_memory_slot *memslot,
 			unsigned int lpid);
-extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, pgd_t *pgtable,
+extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested,
 				    bool writing, unsigned long gpa,
 				    unsigned int lpid);
 extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 2c2635967d6e..2860521992b6 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -647,6 +647,9 @@ static inline pte_t *find_kvm_secondary_pte(struct kvm *kvm, unsigned long ea,
 	return pte;
 }
 
+extern pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
+					unsigned long ea, unsigned *hshift);
+
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 
 #endif /* __ASM_KVM_BOOK3S_64_H__ */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index bf8b72a274fa..7b18b298f513 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -735,7 +735,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 	return ret;
 }
 
-bool kvmppc_hv_handle_set_rc(struct kvm *kvm, pgd_t *pgtable, bool writing,
+bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested, bool writing,
 			     unsigned long gpa, unsigned int lpid)
 {
 	unsigned long pgflags;
@@ -750,12 +750,12 @@ bool kvmppc_hv_handle_set_rc(struct kvm *kvm, pgd_t *pgtable, bool writing,
 	pgflags = _PAGE_ACCESSED;
 	if (writing)
 		pgflags |= _PAGE_DIRTY;
-	/*
-	 * We are walking the secondary (partition-scoped) page table here.
-	 * We can do this without disabling irq because the Linux MM
-	 * subsystem doesn't do THP splits and collapses on this tree.
-	 */
-	ptep = __find_linux_pte(pgtable, gpa, NULL, &shift);
+
+	if (nested)
+		ptep = find_kvm_nested_guest_pte(kvm, lpid, gpa, &shift);
+	else
+		ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
+
 	if (ptep && pte_present(*ptep) && (!writing || pte_write(*ptep))) {
 		kvmppc_radix_update_pte(kvm, ptep, 0, pgflags, gpa, shift);
 		return true;
@@ -948,8 +948,8 @@ int kvmppc_book3s_radix_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	/* Failed to set the reference/change bits */
 	if (dsisr & DSISR_SET_RC) {
 		spin_lock(&kvm->mmu_lock);
-		if (kvmppc_hv_handle_set_rc(kvm, kvm->arch.pgtable,
-					    writing, gpa, kvm->arch.lpid))
+		if (kvmppc_hv_handle_set_rc(kvm, false, writing,
+					    gpa, kvm->arch.lpid))
 			dsisr &= ~DSISR_SET_RC;
 		spin_unlock(&kvm->mmu_lock);
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index b2cc3eaec618..99011f1b772a 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -750,8 +750,8 @@ static struct kvm_nested_guest *kvmhv_find_nested(struct kvm *kvm, int lpid)
 	return kvm->arch.nested_guests[lpid];
 }
 
-static pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
-					unsigned long ea, unsigned *hshift)
+pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
+				 unsigned long ea, unsigned *hshift)
 {
 	struct kvm_nested_guest *gp;
 	pte_t *pte;
@@ -767,7 +767,6 @@ static pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
 	return pte;
 }
 
-
 static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2)
 {
 	return !((rmap_1 ^ rmap_2) & (RMAP_NESTED_LPID_MASK |
@@ -1226,16 +1225,16 @@ static long kvmhv_handle_nested_set_rc(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 	/* Set the rc bit in the pte of our (L0) pgtable for the L1 guest */
-	ret = kvmppc_hv_handle_set_rc(kvm, kvm->arch.pgtable, writing,
-				     gpte.raddr, kvm->arch.lpid);
+	ret = kvmppc_hv_handle_set_rc(kvm, false, writing,
+				      gpte.raddr, kvm->arch.lpid);
 	if (!ret) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
 
 	/* Set the rc bit in the pte of the shadow_pgtable for the nest guest */
-	ret = kvmppc_hv_handle_set_rc(kvm, gp->shadow_pgtable, writing, n_gpa,
-				      gp->shadow_lpid);
+	ret = kvmppc_hv_handle_set_rc(kvm, true, writing,
+				      n_gpa, gp->shadow_lpid);
 	if (!ret)
 		ret = -EINVAL;
 	else
-- 
2.25.3

