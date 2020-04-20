Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25CA1B0B57
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Apr 2020 14:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgDTMzU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Apr 2020 08:55:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7734 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728827AbgDTMpu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 20 Apr 2020 08:45:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KCXXSY039390;
        Mon, 20 Apr 2020 08:45:31 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnsga4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:30 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03KCXWLq039378;
        Mon, 20 Apr 2020 08:45:30 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ggxnsg9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 08:45:30 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KCdtld005947;
        Mon, 20 Apr 2020 12:45:29 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 30fs65rj1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 12:45:29 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KCjRER37290462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 12:45:27 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE0FA13604F;
        Mon, 20 Apr 2020 12:45:27 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0ABF136051;
        Mon, 20 Apr 2020 12:45:23 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.51.43])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 12:45:23 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 09/22] powerpc/kvm/book3s: Add helper to walk partition scoped linux page table.
Date:   Mon, 20 Apr 2020 18:14:21 +0530
Message-Id: <20200420124434.47330-10-aneesh.kumar@linux.ibm.com>
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

The locking rules for walking partition scoped table is different from process
scoped table. Hence add a helper for secondary linux page table walk and also
add check whether we are holding the right locks.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 13 +++++++++++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c   | 12 ++++++------
 arch/powerpc/kvm/book3s_hv_nested.c      |  2 +-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 04b2b927bb5a..2c2635967d6e 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -14,6 +14,7 @@
 #include <asm/book3s/64/mmu-hash.h>
 #include <asm/cpu_has_feature.h>
 #include <asm/ppc-opcode.h>
+#include <asm/pte-walk.h>
 
 #ifdef CONFIG_PPC_PSERIES
 static inline bool kvmhv_on_pseries(void)
@@ -634,6 +635,18 @@ extern void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
 				unsigned long gpa, unsigned long hpa,
 				unsigned long nbytes);
 
+static inline pte_t *find_kvm_secondary_pte(struct kvm *kvm, unsigned long ea,
+					    unsigned *hshift)
+{
+	pte_t *pte;
+
+	VM_WARN(!spin_is_locked(&kvm->mmu_lock),
+		"%s called with kvm mmu_lock not held \n", __func__);
+	pte = __find_linux_pte(kvm->arch.pgtable, ea, NULL, hshift);
+
+	return pte;
+}
+
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 
 #endif /* __ASM_KVM_BOOK3S_64_H__ */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 9f050064d2a2..bf8b72a274fa 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -980,11 +980,11 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		return 0;
 	}
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 				 kvm->arch.lpid);
-	return 0;				
+	return 0;
 }
 
 /* Called with kvm->mmu_lock held */
@@ -1000,7 +1000,7 @@ int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ref;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep)) {
 		old = kvmppc_radix_update_pte(kvm, ptep, _PAGE_ACCESSED, 0,
 					      gpa, shift);
@@ -1027,7 +1027,7 @@ int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ref;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep))
 		ref = 1;
 	return ref;
@@ -1047,7 +1047,7 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE)
 		return ret;
 
-	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep) && pte_dirty(*ptep)) {
 		ret = 1;
 		if (shift)
@@ -1108,7 +1108,7 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	gpa = memslot->base_gfn << PAGE_SHIFT;
 	spin_lock(&kvm->mmu_lock);
 	for (n = memslot->npages; n; --n) {
-		ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+		ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 		if (ptep && pte_present(*ptep))
 			kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 					 kvm->arch.lpid);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index dc97e5be76f6..7f1fc5db13ea 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1362,7 +1362,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_run *run,
 	/* See if can find translation in our partition scoped tables for L1 */
 	pte = __pte(0);
 	spin_lock(&kvm->mmu_lock);
-	pte_p = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
+	pte_p = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (!shift)
 		shift = PAGE_SHIFT;
 	if (pte_p)
-- 
2.25.3

