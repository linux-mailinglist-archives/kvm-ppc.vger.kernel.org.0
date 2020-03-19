Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6C418AB74
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgCSD5o (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:57:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727337AbgCSD5n (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:57:43 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3WbXC104668;
        Wed, 18 Mar 2020 23:57:32 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8adxw3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:32 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3WlUd105170;
        Wed, 18 Mar 2020 23:57:31 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu8adxw3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:31 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3uulM006562;
        Thu, 19 Mar 2020 03:57:30 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 2yrpw6wnw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:57:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3vTAi48497030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:57:30 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3FB911206D;
        Thu, 19 Mar 2020 03:57:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D24F5112063;
        Thu, 19 Mar 2020 03:57:26 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:57:26 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v2 18/22] powerpc/kvm/book3s: Use find_kvm_host_pte in kvmppc_get_hpa
Date:   Thu, 19 Mar 2020 09:26:05 +0530
Message-Id: <20200319035609.158654-19-aneesh.kumar@linux.ibm.com>
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
 malwarescore=0 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=985
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190015
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 32 ++++++++++-------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 83e987fecf97..3b168c69d503 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -878,8 +878,8 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 	return ret;
 }
 
-static int kvmppc_get_hpa(struct kvm_vcpu *vcpu, unsigned long gpa,
-			  int writing, unsigned long *hpa,
+static int kvmppc_get_hpa(struct kvm_vcpu *vcpu, unsigned long mmu_seq,
+			  unsigned long gpa, int writing, unsigned long *hpa,
 			  struct kvm_memory_slot **memslot_p)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -898,7 +898,7 @@ static int kvmppc_get_hpa(struct kvm_vcpu *vcpu, unsigned long gpa,
 	hva = __gfn_to_hva_memslot(memslot, gfn);
 
 	/* Try to find the host pte for that virtual address */
-	ptep = __find_linux_pte(vcpu->arch.pgdir, hva, NULL, &shift);
+	ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &shift);
 	if (!ptep)
 		return H_TOO_HARD;
 	pte = kvmppc_read_update_linux_pte(ptep, writing);
@@ -933,16 +933,11 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
 	mmu_seq = kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	ret = kvmppc_get_hpa(vcpu, dest, 1, &pa, &memslot);
-	if (ret != H_SUCCESS)
-		return ret;
-
-	/* Check if we've been invalidated */
 	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
-	if (mmu_notifier_retry(kvm, mmu_seq)) {
-		ret = H_TOO_HARD;
+
+	ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &pa, &memslot);
+	if (ret != H_SUCCESS)
 		goto out_unlock;
-	}
 
 	/* Zero the page */
 	for (i = 0; i < SZ_4K; i += L1_CACHE_BYTES, pa += L1_CACHE_BYTES)
@@ -966,19 +961,14 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
 	mmu_seq = kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	ret = kvmppc_get_hpa(vcpu, dest, 1, &dest_pa, &dest_memslot);
-	if (ret != H_SUCCESS)
-		return ret;
-	ret = kvmppc_get_hpa(vcpu, src, 0, &src_pa, NULL);
+	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+	ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &dest_pa, &dest_memslot);
 	if (ret != H_SUCCESS)
-		return ret;
+		goto out_unlock;
 
-	/* Check if we've been invalidated */
-	arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
-	if (mmu_notifier_retry(kvm, mmu_seq)) {
-		ret = H_TOO_HARD;
+	ret = kvmppc_get_hpa(vcpu, mmu_seq, src, 0, &src_pa, NULL);
+	if (ret != H_SUCCESS)
 		goto out_unlock;
-	}
 
 	/* Copy the page */
 	memcpy((void *)dest_pa, (void *)src_pa, SZ_4K);
-- 
2.24.1

