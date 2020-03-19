Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1160F18AB65
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCSD5S (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:57:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726596AbgCSD5R (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:57:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3WluX099729;
        Wed, 18 Mar 2020 23:56:59 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yua2bpf5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:58 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3XTaE102838;
        Wed, 18 Mar 2020 23:56:58 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yua2bpf51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:56:58 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3uvGf013593;
        Thu, 19 Mar 2020 03:56:58 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 2yrpw75nht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:56:58 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3uvAs10486296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:56:57 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F98B112063;
        Thu, 19 Mar 2020 03:56:57 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93DF0112062;
        Thu, 19 Mar 2020 03:56:54 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:56:54 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 10/22] powerpc/kvm/nested: Add helper to walk nested shadow linux page table.
Date:   Thu, 19 Mar 2020 09:25:57 +0530
Message-Id: <20200319035609.158654-11-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
References: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_10:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190015
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The locking rules for walking nested shadow linux page table is different from process
scoped table. Hence add a helper for nested page table walk and also
add check whether we are holding the right locks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 7f1fc5db13ea..b2cc3eaec618 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -750,6 +750,24 @@ static struct kvm_nested_guest *kvmhv_find_nested(struct kvm *kvm, int lpid)
 	return kvm->arch.nested_guests[lpid];
 }
 
+static pte_t *find_kvm_nested_guest_pte(struct kvm *kvm, unsigned long lpid,
+					unsigned long ea, unsigned *hshift)
+{
+	struct kvm_nested_guest *gp;
+	pte_t *pte;
+
+	gp = kvmhv_find_nested(kvm, lpid);
+	if (!gp)
+		return NULL;
+
+	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
+		"%s called with kvm mmu_lock not held \n", __func__);
+	pte = __find_linux_pte(gp->shadow_pgtable, ea, NULL, hshift);
+
+	return pte;
+}
+
+
 static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2)
 {
 	return !((rmap_1 ^ rmap_2) & (RMAP_NESTED_LPID_MASK |
@@ -792,19 +810,15 @@ static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 				      unsigned long clr, unsigned long set,
 				      unsigned long hpa, unsigned long mask)
 {
-	struct kvm_nested_guest *gp;
 	unsigned long gpa;
 	unsigned int shift, lpid;
 	pte_t *ptep;
 
 	gpa = n_rmap & RMAP_NESTED_GPA_MASK;
 	lpid = (n_rmap & RMAP_NESTED_LPID_MASK) >> RMAP_NESTED_LPID_SHIFT;
-	gp = kvmhv_find_nested(kvm, lpid);
-	if (!gp)
-		return;
 
 	/* Find the pte */
-	ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_nested_guest_pte(kvm, lpid, gpa, &shift);
 	/*
 	 * If the pte is present and the pfn is still the same, update the pte.
 	 * If the pfn has changed then this is a stale rmap entry, the nested
@@ -854,7 +868,7 @@ static void kvmhv_remove_nest_rmap(struct kvm *kvm, u64 n_rmap,
 		return;
 
 	/* Find and invalidate the pte */
-	ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_nested_guest_pte(kvm, lpid, gpa, &shift);
 	/* Don't spuriously invalidate ptes if the pfn has changed */
 	if (ptep && pte_present(*ptep) && ((pte_val(*ptep) & mask) == hpa))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL, gp->shadow_lpid);
@@ -921,7 +935,7 @@ static bool kvmhv_invalidate_shadow_pte(struct kvm_vcpu *vcpu,
 	int shift;
 
 	spin_lock(&kvm->mmu_lock);
-	ptep = __find_linux_pte(gp->shadow_pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_nested_guest_pte(kvm, gp->l1_lpid, gpa, &shift);
 	if (!shift)
 		shift = PAGE_SHIFT;
 	if (ptep && pte_present(*ptep)) {
-- 
2.24.1

