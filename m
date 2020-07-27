Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C212022F74E
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Jul 2020 20:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgG0SHy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Jul 2020 14:07:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728545AbgG0SHy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Jul 2020 14:07:54 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RI25HS006789;
        Mon, 27 Jul 2020 14:07:42 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32j2paj7sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 14:07:41 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RI6QkR006570;
        Mon, 27 Jul 2020 18:07:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32gcq0shrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 18:07:39 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RI7aL530802276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 18:07:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24A9AA4055;
        Mon, 27 Jul 2020 18:07:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA2B0A4051;
        Mon, 27 Jul 2020 18:07:32 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.69.7])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 18:07:32 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v6 2/5] KVM: PPC: Book3S HV: Disable page merging in H_SVM_INIT_START
Date:   Mon, 27 Jul 2020 11:07:15 -0700
Message-Id: <1595873238-26184-3-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595873238-26184-1-git-send-email-linuxram@us.ibm.com>
References: <1595873238-26184-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_12:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=2 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270118
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Page-merging of pages in memory-slots associated with a Secure VM,
is disabled in H_SVM_PAGE_IN handler.

This operation should have been done the much earlier; the moment the VM
is initiated for secure-transition. Delaying this operation, increases
the probability for those pages to acquire new references , making it
impossible to migrate those pages in H_SVM_PAGE_IN handler.

Disable page-migration in H_SVM_INIT_START handling.

Reviewed-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 Documentation/powerpc/ultravisor.rst |   1 +
 arch/powerpc/kvm/book3s_hv_uvmem.c   | 123 +++++++++++++++++++++++++----------
 2 files changed, 89 insertions(+), 35 deletions(-)

diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
index df136c8..a1c8c37 100644
--- a/Documentation/powerpc/ultravisor.rst
+++ b/Documentation/powerpc/ultravisor.rst
@@ -895,6 +895,7 @@ Return values
     One of the following values:
 
 	* H_SUCCESS	 on success.
+        * H_STATE        if the VM is not in a position to switch to secure.
 
 Description
 ~~~~~~~~~~~
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e6f76bc..533b608 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -211,10 +211,79 @@ static bool kvmppc_gfn_is_uvmem_pfn(unsigned long gfn, struct kvm *kvm,
 	return false;
 }
 
+static int kvmppc_memslot_page_merge(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot, bool merge)
+{
+	unsigned long gfn = memslot->base_gfn;
+	unsigned long end, start = gfn_to_hva(kvm, gfn);
+	int ret = 0;
+	struct vm_area_struct *vma;
+	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
+
+	if (kvm_is_error_hva(start))
+		return H_STATE;
+
+	end = start + (memslot->npages << PAGE_SHIFT);
+
+	mmap_write_lock(kvm->mm);
+	do {
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma) {
+			ret = H_STATE;
+			break;
+		}
+		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
+			  merge_flag, &vma->vm_flags);
+		if (ret) {
+			ret = H_STATE;
+			break;
+		}
+		start = vma->vm_end;
+	} while (end > vma->vm_end);
+
+	mmap_write_unlock(kvm->mm);
+	return ret;
+}
+
+static void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot)
+{
+	uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
+	kvmppc_uvmem_slot_free(kvm, memslot);
+	kvmppc_memslot_page_merge(kvm, memslot, true);
+}
+
+static int kvmppc_uvmem_memslot_create(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot)
+{
+	int ret = H_PARAMETER;
+
+	if (kvmppc_memslot_page_merge(kvm, memslot, false))
+		return ret;
+
+	if (kvmppc_uvmem_slot_init(kvm, memslot))
+		goto out1;
+
+	ret = uv_register_mem_slot(kvm->arch.lpid,
+				   memslot->base_gfn << PAGE_SHIFT,
+				   memslot->npages * PAGE_SIZE,
+				   0, memslot->id);
+	if (ret < 0) {
+		ret = H_PARAMETER;
+		goto out;
+	}
+	return 0;
+out:
+	kvmppc_uvmem_slot_free(kvm, memslot);
+out1:
+	kvmppc_memslot_page_merge(kvm, memslot, true);
+	return ret;
+}
+
 unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot *memslot, *m;
 	int ret = H_SUCCESS;
 	int srcu_idx;
 
@@ -232,23 +301,24 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 		return H_AUTHORITY;
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	/* register the memslot */
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
-		if (kvmppc_uvmem_slot_init(kvm, memslot)) {
-			ret = H_PARAMETER;
-			goto out;
-		}
-		ret = uv_register_mem_slot(kvm->arch.lpid,
-					   memslot->base_gfn << PAGE_SHIFT,
-					   memslot->npages * PAGE_SIZE,
-					   0, memslot->id);
-		if (ret < 0) {
-			kvmppc_uvmem_slot_free(kvm, memslot);
-			ret = H_PARAMETER;
-			goto out;
+		ret = kvmppc_uvmem_memslot_create(kvm, memslot);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		slots = kvm_memslots(kvm);
+		kvm_for_each_memslot(m, slots) {
+			if (m == memslot)
+				break;
+			kvmppc_uvmem_memslot_delete(kvm, memslot);
 		}
 	}
-out:
+
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
 }
@@ -384,7 +454,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
  */
 static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 		   unsigned long end, unsigned long gpa, struct kvm *kvm,
-		   unsigned long page_shift, bool *downgrade)
+		   unsigned long page_shift)
 {
 	unsigned long src_pfn, dst_pfn = 0;
 	struct migrate_vma mig;
@@ -400,18 +470,6 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 	mig.src = &src_pfn;
 	mig.dst = &dst_pfn;
 
-	/*
-	 * We come here with mmap_lock write lock held just for
-	 * ksm_madvise(), otherwise we only need read mmap_lock.
-	 * Hence downgrade to read lock once ksm_madvise() is done.
-	 */
-	ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  MADV_UNMERGEABLE, &vma->vm_flags);
-	mmap_write_downgrade(kvm->mm);
-	*downgrade = true;
-	if (ret)
-		return ret;
-
 	ret = migrate_vma_setup(&mig);
 	if (ret)
 		return ret;
@@ -503,7 +561,6 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 		unsigned long flags,
 		unsigned long page_shift)
 {
-	bool downgrade = false;
 	unsigned long start, end;
 	struct vm_area_struct *vma;
 	int srcu_idx;
@@ -524,7 +581,7 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 
 	ret = H_PARAMETER;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	mmap_write_lock(kvm->mm);
+	mmap_read_lock(kvm->mm);
 
 	start = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(start))
@@ -540,16 +597,12 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 	if (!vma || vma->vm_start > start || vma->vm_end < end)
 		goto out_unlock;
 
-	if (!kvmppc_svm_page_in(vma, start, end, gpa, kvm, page_shift,
-				&downgrade))
+	if (!kvmppc_svm_page_in(vma, start, end, gpa, kvm, page_shift))
 		ret = H_SUCCESS;
 out_unlock:
 	mutex_unlock(&kvm->arch.uvmem_lock);
 out:
-	if (downgrade)
-		mmap_read_unlock(kvm->mm);
-	else
-		mmap_write_unlock(kvm->mm);
+	mmap_read_unlock(kvm->mm);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
 }
-- 
1.8.3.1

