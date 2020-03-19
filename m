Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D285618AB6D
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgCSD5d (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:57:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64384 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgCSD5c (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:57:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3X5pi082057;
        Wed, 18 Mar 2020 23:57:15 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu932mftv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:15 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3XAx3082281;
        Wed, 18 Mar 2020 23:57:15 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu932mftq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:15 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3v0mh000836;
        Thu, 19 Mar 2020 03:57:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 2yrpw6y0gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:57:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3vDZ450987506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:57:13 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 867E5112063;
        Thu, 19 Mar 2020 03:57:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 108B8112062;
        Thu, 19 Mar 2020 03:57:10 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:57:09 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 14/22] powerpc/kvm/book3s: Use find_kvm_host_pte in h_enter
Date:   Thu, 19 Mar 2020 09:26:01 +0530
Message-Id: <20200319035609.158654-15-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
References: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_10:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 mlxlogscore=857
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190015
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since kvmppc_do_h_enter can get called in realmode use low level
arch_spin_lock which is safe to be called in realmode.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  5 ++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 22 ++++++----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index fbabdcf24c86..7f19192a8185 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -281,11 +281,10 @@ static long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
 {
 	long ret;
 
-	/* Protect linux PTE lookup from page table destruction */
-	rcu_read_lock_sched();	/* this disables preemption too */
+	preempt_disable();
 	ret = kvmppc_do_h_enter(kvm, flags, pte_index, pteh, ptel,
 				kvm->mm->pgd, false, pte_idx_ret);
-	rcu_read_unlock_sched();
+	preempt_enable();
 	if (ret == H_TOO_HARD) {
 		/* this can't happen */
 		pr_err("KVM: Oops, kvmppc_h_enter returned too hard!\n");
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 03f8347de48b..83e987fecf97 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -210,7 +210,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 	pte_t *ptep;
 	unsigned int writing;
 	unsigned long mmu_seq;
-	unsigned long rcbits, irq_flags = 0;
+	unsigned long rcbits;
 
 	if (kvm_is_radix(kvm))
 		return H_FUNCTION;
@@ -248,17 +248,9 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 
 	/* Translate to host virtual address */
 	hva = __gfn_to_hva_memslot(memslot, gfn);
-	/*
-	 * If we had a page table table change after lookup, we would
-	 * retry via mmu_notifier_retry.
-	 */
-	if (!realmode)
-		local_irq_save(irq_flags);
-	/*
-	 * If called in real mode we have MSR_EE = 0. Otherwise
-	 * we disable irq above.
-	 */
-	ptep = __find_linux_pte(pgdir, hva, NULL, &hpage_shift);
+
+	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &hpage_shift);
 	if (ptep) {
 		pte_t pte;
 		unsigned int host_pte_size;
@@ -272,8 +264,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 		 * to <= host page size, if host is using hugepage
 		 */
 		if (host_pte_size < psize) {
-			if (!realmode)
-				local_irq_restore(flags);
+			arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
 			return H_PARAMETER;
 		}
 		pte = kvmppc_read_update_linux_pte(ptep, writing);
@@ -287,8 +278,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
 			pa |= gpa & ~PAGE_MASK;
 		}
 	}
-	if (!realmode)
-		local_irq_restore(irq_flags);
+	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
 
 	ptel &= HPTE_R_KEY | HPTE_R_PP0 | (psize-1);
 	ptel |= pa;
-- 
2.24.1

