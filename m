Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0946F223668
	for <lists+kvm-ppc@lfdr.de>; Fri, 17 Jul 2020 10:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGQIBR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 17 Jul 2020 04:01:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52172 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728028AbgGQIBR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 17 Jul 2020 04:01:17 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06H7WgxR020794;
        Fri, 17 Jul 2020 04:01:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ax78p5jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 04:01:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06H7fhMa025998;
        Fri, 17 Jul 2020 08:00:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgx8m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 08:00:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06H80uxX13566458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 08:00:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B28E2A406E;
        Fri, 17 Jul 2020 08:00:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E12EA406D;
        Fri, 17 Jul 2020 08:00:52 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.39.1])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 08:00:52 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [v4 4/5] KVM: PPC: Book3S HV: retry page migration before erroring-out
Date:   Fri, 17 Jul 2020 01:00:26 -0700
Message-Id: <1594972827-13928-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
References: <1594972827-13928-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_04:2020-07-16,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170054
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The page requested for page-in; sometimes, can have transient
references, and hence cannot migrate immediately. Retry a few times
before returning error.

The same is true for non-migrated pages that are migrated in
H_SVM_INIT_DONE hanlder.  Retry a few times before returning error.

H_SVM_PAGE_IN interface is enhanced to return H_BUSY if the page is
not in a migratable state.

Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Claudio Carvalho <cclaudio@linux.ibm.com>
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 Documentation/powerpc/ultravisor.rst |   1 +
 arch/powerpc/kvm/book3s_hv_uvmem.c   | 106 ++++++++++++++++++++++++-----------
 2 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
index ba6b1bf..fe533ad 100644
--- a/Documentation/powerpc/ultravisor.rst
+++ b/Documentation/powerpc/ultravisor.rst
@@ -1035,6 +1035,7 @@ Return values
 	* H_PARAMETER	if ``guest_pa`` is invalid.
 	* H_P2		if ``flags`` is invalid.
 	* H_P3		if ``order`` of page is invalid.
+	* H_BUSY	if ``page`` is not in a state to pagein
 
 Description
 ~~~~~~~~~~~
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 3274663..a206984 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -672,7 +672,7 @@ static int kvmppc_svm_migrate_page(struct vm_area_struct *vma,
 		return ret;
 
 	if (!(*mig.src & MIGRATE_PFN_MIGRATE)) {
-		ret = -1;
+		ret = -2;
 		goto out_finalize;
 	}
 
@@ -700,43 +700,73 @@ static int kvmppc_svm_migrate_page(struct vm_area_struct *vma,
 	return ret;
 }
 
-int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
-		const struct kvm_memory_slot *memslot)
+/*
+ * return 1, if some page migration failed because of transient error,
+ * while the remaining pages migrated successfully.
+ * The caller can use this as a hint to retry.
+ *
+ * return 0 otherwise. *ret indicates the success status
+ * of this call.
+ */
+static bool __kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot, int *ret)
 {
 	unsigned long gfn = memslot->base_gfn;
 	struct vm_area_struct *vma;
 	unsigned long start, end;
-	int ret = 0;
+	bool retry = false;
 
+	*ret = 0;
 	while (kvmppc_next_nontransitioned_gfn(memslot, kvm, &gfn)) {
 
 		mmap_read_lock(kvm->mm);
 		start = gfn_to_hva(kvm, gfn);
 		if (kvm_is_error_hva(start)) {
-			ret = H_STATE;
+			*ret = H_STATE;
 			goto next;
 		}
 
 		end = start + (1UL << PAGE_SHIFT);
 		vma = find_vma_intersection(kvm->mm, start, end);
 		if (!vma || vma->vm_start > start || vma->vm_end < end) {
-			ret = H_STATE;
+			*ret = H_STATE;
 			goto next;
 		}
 
 		mutex_lock(&kvm->arch.uvmem_lock);
-		ret = kvmppc_svm_migrate_page(vma, start, end,
+		*ret = kvmppc_svm_migrate_page(vma, start, end,
 				(gfn << PAGE_SHIFT), kvm, PAGE_SHIFT, false);
 		mutex_unlock(&kvm->arch.uvmem_lock);
-		if (ret)
-			ret = H_STATE;
 
 next:
 		mmap_read_unlock(kvm->mm);
+		if (*ret == -2) {
+			retry = true;
+			continue;
+		}
 
-		if (ret)
-			break;
+		if (*ret)
+			return false;
 	}
+	return retry;
+}
+
+#define REPEAT_COUNT 10
+
+int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot)
+{
+	int ret = 0, repeat_count = REPEAT_COUNT;
+
+	/*
+	 * try migration of pages in the memslot 'repeat_count' number of
+	 * times, provided each time migration fails because of transient
+	 * errors only.
+	 */
+	while (__kvmppc_uv_migrate_mem_slot(kvm, memslot, &ret) &&
+		repeat_count--)
+		;
+
 	return ret;
 }
 
@@ -812,7 +842,7 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 	struct vm_area_struct *vma;
 	int srcu_idx;
 	unsigned long gfn = gpa >> page_shift;
-	int ret;
+	int ret, repeat_count = REPEAT_COUNT;
 
 	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
 		return H_UNSUPPORTED;
@@ -826,34 +856,44 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 	if (flags & H_PAGE_IN_SHARED)
 		return kvmppc_share_page(kvm, gpa, page_shift);
 
-	ret = H_PARAMETER;
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-	mmap_read_lock(kvm->mm);
 
-	start = gfn_to_hva(kvm, gfn);
-	if (kvm_is_error_hva(start))
-		goto out;
-
-	mutex_lock(&kvm->arch.uvmem_lock);
 	/* Fail the page-in request of an already paged-in page */
-	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL))
-		goto out_unlock;
+	mutex_lock(&kvm->arch.uvmem_lock);
+	ret = kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL);
+	mutex_unlock(&kvm->arch.uvmem_lock);
+	if (ret) {
+		srcu_read_unlock(&kvm->srcu, srcu_idx);
+		return H_PARAMETER;
+	}
 
-	end = start + (1UL << page_shift);
-	vma = find_vma_intersection(kvm->mm, start, end);
-	if (!vma || vma->vm_start > start || vma->vm_end < end)
-		goto out_unlock;
+	do {
+		ret = H_PARAMETER;
+		mmap_read_lock(kvm->mm);
 
-	if (kvmppc_svm_migrate_page(vma, start, end, gpa, kvm, page_shift,
-				true))
-		goto out_unlock;
+		start = gfn_to_hva(kvm, gfn);
+		if (kvm_is_error_hva(start)) {
+			mmap_read_unlock(kvm->mm);
+			break;
+		}
 
-	ret = H_SUCCESS;
+		end = start + (1UL << page_shift);
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma || vma->vm_start > start || vma->vm_end < end) {
+			mmap_read_unlock(kvm->mm);
+			break;
+		}
+
+		mutex_lock(&kvm->arch.uvmem_lock);
+		ret = kvmppc_svm_migrate_page(vma, start, end, gpa, kvm, page_shift, true);
+		mutex_unlock(&kvm->arch.uvmem_lock);
+
+		mmap_read_unlock(kvm->mm);
+	} while (ret == -2 && repeat_count--);
+
+	if (ret == -2)
+		ret = H_BUSY;
 
-out_unlock:
-	mutex_unlock(&kvm->arch.uvmem_lock);
-out:
-	mmap_read_unlock(kvm->mm);
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return ret;
 }
-- 
1.8.3.1

