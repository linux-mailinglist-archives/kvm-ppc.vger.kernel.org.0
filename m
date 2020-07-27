Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902E522F750
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Jul 2020 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgG0SIB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Jul 2020 14:08:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15132 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729618AbgG0SIA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Jul 2020 14:08:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RI0ngC126585;
        Mon, 27 Jul 2020 14:07:48 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32j09vfd21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 14:07:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RI2DWN010064;
        Mon, 27 Jul 2020 18:07:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqgjha0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 18:07:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RI7hA233161660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 18:07:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FC39A4055;
        Mon, 27 Jul 2020 18:07:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15E50A4051;
        Mon, 27 Jul 2020 18:07:40 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.69.7])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 18:07:39 +0000 (GMT)
From:   Ram Pai <linuxram@us.ibm.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        bharata@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, ldufour@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: [PATCH v6 4/5] KVM: PPC: Book3S HV: in H_SVM_INIT_DONE, migrate remaining normal-GFNs to secure-GFNs.
Date:   Mon, 27 Jul 2020 11:07:17 -0700
Message-Id: <1595873238-26184-5-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1595873238-26184-1-git-send-email-linuxram@us.ibm.com>
References: <1595873238-26184-1-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_12:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270118
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The Ultravisor is expected to explicitly call H_SVM_PAGE_IN for all the
pages of the SVM before calling H_SVM_INIT_DONE. This causes a huge
delay in tranistioning the VM to SVM. The Ultravisor is only interested
in the pages that contain the kernel, initrd and other important data
structures. The rest contain throw-away content.

However if not all pages are requested by the Ultravisor, the Hypervisor
continues to consider the GFNs corresponding to the non-requested pages
as normal GFNs. This can lead to data-corruption and undefined behavior.

In H_SVM_INIT_DONE handler, move all the PFNs associated with the SVM's
GFNs to secure-PFNs. Skip the GFNs that are already Paged-in or Shared
or Paged-in followed by a Paged-out.

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
Reviewed-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 Documentation/powerpc/ultravisor.rst |   2 +
 arch/powerpc/kvm/book3s_hv_uvmem.c   | 154 ++++++++++++++++++++++++++++++-----
 2 files changed, 134 insertions(+), 22 deletions(-)

diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
index a1c8c37..ba6b1bf 100644
--- a/Documentation/powerpc/ultravisor.rst
+++ b/Documentation/powerpc/ultravisor.rst
@@ -934,6 +934,8 @@ Return values
 	* H_UNSUPPORTED		if called from the wrong context (e.g.
 				from an SVM or before an H_SVM_INIT_START
 				hypercall).
+	* H_STATE		if the hypervisor could not successfully
+                                transition the VM to Secure VM.
 
 Description
 ~~~~~~~~~~~
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 1b2b029..a1664ae 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -93,6 +93,7 @@
 #include <asm/ultravisor.h>
 #include <asm/mman.h>
 #include <asm/kvm_ppc.h>
+#include <asm/kvm_book3s_uvmem.h>
 
 static struct dev_pagemap kvmppc_uvmem_pgmap;
 static unsigned long *kvmppc_uvmem_bitmap;
@@ -348,6 +349,41 @@ static bool kvmppc_gfn_is_uvmem_pfn(unsigned long gfn, struct kvm *kvm,
 	return false;
 }
 
+/*
+ * starting from *gfn search for the next available GFN that is not yet
+ * transitioned to a secure GFN.  return the value of that GFN in *gfn.  If a
+ * GFN is found, return true, else return false
+ *
+ * Must be called with kvm->arch.uvmem_lock  held.
+ */
+static bool kvmppc_next_nontransitioned_gfn(const struct kvm_memory_slot *memslot,
+		struct kvm *kvm, unsigned long *gfn)
+{
+	struct kvmppc_uvmem_slot *p;
+	bool ret = false;
+	unsigned long i;
+
+	list_for_each_entry(p, &kvm->arch.uvmem_pfns, list)
+		if (*gfn >= p->base_pfn && *gfn < p->base_pfn + p->nr_pfns)
+			break;
+	if (!p)
+		return ret;
+	/*
+	 * The code below assumes, one to one correspondence between
+	 * kvmppc_uvmem_slot and memslot.
+	 */
+	for (i = *gfn; i < p->base_pfn + p->nr_pfns; i++) {
+		unsigned long index = i - p->base_pfn;
+
+		if (!(p->pfns[index] & KVMPPC_GFN_FLAG_MASK)) {
+			*gfn = i;
+			ret = true;
+			break;
+		}
+	}
+	return ret;
+}
+
 static int kvmppc_memslot_page_merge(struct kvm *kvm,
 		const struct kvm_memory_slot *memslot, bool merge)
 {
@@ -460,16 +496,6 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 	return ret;
 }
 
-unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
-{
-	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
-		return H_UNSUPPORTED;
-
-	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
-	pr_info("LPID %d went secure\n", kvm->arch.lpid);
-	return H_SUCCESS;
-}
-
 /*
  * Drop device pages that we maintain for the secure guest
  *
@@ -588,12 +614,14 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 }
 
 /*
- * Alloc a PFN from private device memory pool and copy page from normal
- * memory to secure memory using UV_PAGE_IN uvcall.
+ * Alloc a PFN from private device memory pool. If @pagein is true,
+ * copy page from normal memory to secure memory using UV_PAGE_IN uvcall.
  */
-static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
-		   unsigned long end, unsigned long gpa, struct kvm *kvm,
-		   unsigned long page_shift)
+static int kvmppc_svm_page_in(struct vm_area_struct *vma,
+		unsigned long start,
+		unsigned long end, unsigned long gpa, struct kvm *kvm,
+		unsigned long page_shift,
+		bool pagein)
 {
 	unsigned long src_pfn, dst_pfn = 0;
 	struct migrate_vma mig;
@@ -624,11 +652,16 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 		goto out_finalize;
 	}
 
-	pfn = *mig.src >> MIGRATE_PFN_SHIFT;
-	spage = migrate_pfn_to_page(*mig.src);
-	if (spage)
-		uv_page_in(kvm->arch.lpid, pfn << page_shift, gpa, 0,
-			   page_shift);
+	if (pagein) {
+		pfn = *mig.src >> MIGRATE_PFN_SHIFT;
+		spage = migrate_pfn_to_page(*mig.src);
+		if (spage) {
+			ret = uv_page_in(kvm->arch.lpid, pfn << page_shift,
+					gpa, 0, page_shift);
+			if (ret)
+				goto out_finalize;
+		}
+	}
 
 	*mig.dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
 	migrate_vma_pages(&mig);
@@ -637,6 +670,80 @@ static int kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
 	return ret;
 }
 
+static int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
+		const struct kvm_memory_slot *memslot)
+{
+	unsigned long gfn = memslot->base_gfn;
+	struct vm_area_struct *vma;
+	unsigned long start, end;
+	int ret = 0;
+
+	mmap_read_lock(kvm->mm);
+	mutex_lock(&kvm->arch.uvmem_lock);
+	while (kvmppc_next_nontransitioned_gfn(memslot, kvm, &gfn)) {
+		ret = H_STATE;
+		start = gfn_to_hva(kvm, gfn);
+		if (kvm_is_error_hva(start))
+			break;
+
+		end = start + (1UL << PAGE_SHIFT);
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma || vma->vm_start > start || vma->vm_end < end)
+			break;
+
+		ret = kvmppc_svm_page_in(vma, start, end,
+				(gfn << PAGE_SHIFT), kvm, PAGE_SHIFT, false);
+		if (ret) {
+			ret = H_STATE;
+			break;
+		}
+
+		/* relinquish the cpu if needed */
+		cond_resched();
+	}
+	mutex_unlock(&kvm->arch.uvmem_lock);
+	mmap_read_unlock(kvm->mm);
+	return ret;
+}
+
+unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int srcu_idx;
+	long ret = H_SUCCESS;
+
+	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
+		return H_UNSUPPORTED;
+
+	/* migrate any unmoved normal pfn to device pfns*/
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(memslot, slots) {
+		ret = kvmppc_uv_migrate_mem_slot(kvm, memslot);
+		if (ret) {
+			/*
+			 * The pages will remain transitioned.
+			 * Its the callers responsibility to
+			 * terminate the VM, which will undo
+			 * all state of the VM. Till then
+			 * this VM is in a erroneous state.
+			 * Its KVMPPC_SECURE_INIT_DONE will
+			 * remain unset.
+			 */
+			ret = H_STATE;
+			goto out;
+		}
+	}
+
+	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
+	pr_info("LPID %d went secure\n", kvm->arch.lpid);
+
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	return ret;
+}
+
 /*
  * Shares the page with HV, thus making it a normal page.
  *
@@ -745,8 +852,11 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
 	if (!vma || vma->vm_start > start || vma->vm_end < end)
 		goto out_unlock;
 
-	if (!kvmppc_svm_page_in(vma, start, end, gpa, kvm, page_shift))
-		ret = H_SUCCESS;
+	if (kvmppc_svm_page_in(vma, start, end, gpa, kvm, page_shift,
+				true))
+		goto out_unlock;
+
+	ret = H_SUCCESS;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.uvmem_lock);
-- 
1.8.3.1

