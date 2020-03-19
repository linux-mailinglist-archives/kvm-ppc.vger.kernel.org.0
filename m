Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250AA18AB6F
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 04:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSD5g (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 23:57:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727234AbgCSD5g (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 18 Mar 2020 23:57:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J3WfX8081581;
        Wed, 18 Mar 2020 23:57:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu98tyepk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:19 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02J3jqia135984;
        Wed, 18 Mar 2020 23:57:19 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu98tyepa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Mar 2020 23:57:19 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02J3uwWE029795;
        Thu, 19 Mar 2020 03:57:18 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01wdc.us.ibm.com with ESMTP id 2yrpw6nmvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 03:57:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02J3vHtv36372842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Mar 2020 03:57:17 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D03D7112062;
        Thu, 19 Mar 2020 03:57:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28347112063;
        Thu, 19 Mar 2020 03:57:14 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.34.213])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 Mar 2020 03:57:13 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc:     npiggin@gmail.com, paulus@ozlabs.org, leonardo@linux.ibm.com,
        kirill@shutemov.name,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v2 15/22] powerpc/kvm/book3s: use find_kvm_host_pte in pute_tce functions
Date:   Thu, 19 Mar 2020 09:26:02 +0530
Message-Id: <20200319035609.158654-16-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
References: <20200319035609.158654-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_10:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 suspectscore=8 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190013
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Current code just hold rmap lock to ensure parallel page table update is
prevented. That is not sufficient. The kernel should also check whether
a mmu_notifer callback was running in parallel.

Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_64_vio_hv.c | 30 +++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index ab6eeb8e753e..8a6bf12d2e88 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -438,8 +438,8 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	return H_SUCCESS;
 }
 
-static long kvmppc_rm_ua_to_hpa(struct kvm_vcpu *vcpu,
-		unsigned long ua, unsigned long *phpa)
+static long kvmppc_rm_ua_to_hpa(struct kvm_vcpu *vcpu, unsigned long mmu_seq,
+				unsigned long ua, unsigned long *phpa)
 {
 	pte_t *ptep, pte;
 	unsigned shift = 0;
@@ -453,10 +453,17 @@ static long kvmppc_rm_ua_to_hpa(struct kvm_vcpu *vcpu,
 	 * to exit which will agains result in the below page table walk
 	 * to finish.
 	 */
-	ptep = __find_linux_pte(vcpu->arch.pgdir, ua, NULL, &shift);
-	if (!ptep || !pte_present(*ptep))
+	/* an rmap lock won't make it safe. because that just ensure hash
+	 * page table entries are removed with rmap lock held. After that
+	 * mmu notifier returns and we go ahead and removing ptes from Qemu page table.
+	 */
+	ptep = find_kvm_host_pte(vcpu->kvm, mmu_seq, ua, &shift);
+	if (!ptep)
+		return -ENXIO;
+
+	pte = READ_ONCE(*ptep);
+	if (!pte_present(pte))
 		return -ENXIO;
-	pte = *ptep;
 
 	if (!shift)
 		shift = PAGE_SHIFT;
@@ -478,10 +485,12 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		unsigned long liobn, unsigned long ioba,
 		unsigned long tce_list,	unsigned long npages)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvmppc_spapr_tce_table *stt;
 	long i, ret = H_SUCCESS;
 	unsigned long tces, entry, ua = 0;
 	unsigned long *rmap = NULL;
+	unsigned long mmu_seq;
 	bool prereg = false;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
@@ -489,6 +498,12 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (kvm_is_radix(vcpu->kvm))
 		return H_TOO_HARD;
 
+	/*
+	 * used to check for invalidations in progress
+	 */
+	mmu_seq = kvm->mmu_notifier_seq;
+	smp_rmb();
+
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
@@ -548,7 +563,9 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 		 * real page.
 		 */
 		lock_rmap(rmap);
-		if (kvmppc_rm_ua_to_hpa(vcpu, ua, &tces)) {
+
+		arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
+		if (kvmppc_rm_ua_to_hpa(vcpu, mmu_seq, ua, &tces)) {
 			ret = H_TOO_HARD;
 			goto unlock_exit;
 		}
@@ -594,6 +611,7 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	if (rmap)
 		unlock_rmap(rmap);
 
+	arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
 	return ret;
 }
 
-- 
2.24.1

