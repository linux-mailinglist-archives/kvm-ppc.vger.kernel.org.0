Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7D22C0E8
	for <lists+kvm-ppc@lfdr.de>; Fri, 24 Jul 2020 10:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgGXIfs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 24 Jul 2020 04:35:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgGXIfs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 24 Jul 2020 04:35:48 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06O8X8dd027433;
        Fri, 24 Jul 2020 04:35:35 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32fat2m9a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 04:35:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06O8UKRc014893;
        Fri, 24 Jul 2020 08:35:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 32brq83w60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 08:35:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06O8Y6ZC54985200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 08:34:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A03ACAE05A;
        Fri, 24 Jul 2020 08:35:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D584AE04D;
        Fri, 24 Jul 2020 08:35:30 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.182.168])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jul 2020 08:35:30 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     bharata@linux.ibm.com, linuxram@us.ibm.com
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.ibm.com,
        bauerman@linux.ibm.com, david@gibson.dropbear.id.au,
        cclaudio@linux.ibm.com, sathnaga@linux.vnet.ibm.com,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH] KVM: PPC: Book3S HV: rework secure mem slot dropping
Date:   Fri, 24 Jul 2020 10:35:27 +0200
Message-Id: <20200724083527.28027-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724030337.GC1082478@in.ibm.com>
References: <20200724030337.GC1082478@in.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_02:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 mlxlogscore=763
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240059
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When a secure memslot is dropped, all the pages backed in the secure
device (aka really backed by secure memory by the Ultravisor)
should be paged out to a normal page. Previously, this was
achieved by triggering the page fault mechanism which is calling
kvmppc_svm_page_out() on each pages.

This can't work when hot unplugging a memory slot because the memory
slot is flagged as invalid and gfn_to_pfn() is then not trying to access
the page, so the page fault mechanism is not triggered.

Since the final goal is to make a call to kvmppc_svm_page_out() it seems
simpler to call directly instead of triggering such a mechanism. This
way kvmppc_uvmem_drop_pages() can be called even when hot unplugging a
memslot.

Since kvmppc_uvmem_drop_pages() is already holding kvm->arch.uvmem_lock,
the call to __kvmppc_svm_page_out() is made.  As
__kvmppc_svm_page_out needs the vma pointer to migrate the pages,
the VMA is fetched in a lazy way, to not trigger find_vma() all
the time. In addition, the mmap_sem is held in read mode during
that time, not in write mode since the virual memory layout is not
impacted, and kvm->arch.uvmem_lock prevents concurrent operation
on the secure device.

Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
	[modified the changelog description]
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
        [modified check on the VMA in kvmppc_uvmem_drop_pages]
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 53 ++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index c772e921f769..5dd3e9acdcab 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -632,35 +632,54 @@ static inline int kvmppc_svm_page_out(struct vm_area_struct *vma,
  * fault on them, do fault time migration to replace the device PTEs in
  * QEMU page table with normal PTEs from newly allocated pages.
  */
-void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
+void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *slot,
 			     struct kvm *kvm, bool skip_page_out)
 {
 	int i;
 	struct kvmppc_uvmem_page_pvt *pvt;
-	unsigned long pfn, uvmem_pfn;
-	unsigned long gfn = free->base_gfn;
+	struct page *uvmem_page;
+	struct vm_area_struct *vma = NULL;
+	unsigned long uvmem_pfn, gfn;
+	unsigned long addr, end;
+
+	mmap_read_lock(kvm->mm);
+
+	addr = slot->userspace_addr;
+	end = addr + (slot->npages * PAGE_SIZE);
 
-	for (i = free->npages; i; --i, ++gfn) {
-		struct page *uvmem_page;
+	gfn = slot->base_gfn;
+	for (i = slot->npages; i; --i, ++gfn, addr += PAGE_SIZE) {
+
+		/* Fetch the VMA if addr is not in the latest fetched one */
+		if (!vma || addr >= vma->vm_end) {
+			vma = find_vma_intersection(kvm->mm, addr, addr+1);
+			if (!vma) {
+				pr_err("Can't find VMA for gfn:0x%lx\n", gfn);
+				break;
+			}
+		}
 
 		mutex_lock(&kvm->arch.uvmem_lock);
-		if (!kvmppc_gfn_is_uvmem_pfn(gfn, kvm, &uvmem_pfn)) {
+
+		if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, &uvmem_pfn)) {
+			uvmem_page = pfn_to_page(uvmem_pfn);
+			pvt = uvmem_page->zone_device_data;
+			pvt->skip_page_out = skip_page_out;
+			pvt->remove_gfn = true;
+
+			if (__kvmppc_svm_page_out(vma, addr, addr + PAGE_SIZE,
+						  PAGE_SHIFT, kvm, pvt->gpa))
+				pr_err("Can't page out gpa:0x%lx addr:0x%lx\n",
+				       pvt->gpa, addr);
+		} else {
+			/* Remove the shared flag if any */
 			kvmppc_gfn_remove(gfn, kvm);
-			mutex_unlock(&kvm->arch.uvmem_lock);
-			continue;
 		}
 
-		uvmem_page = pfn_to_page(uvmem_pfn);
-		pvt = uvmem_page->zone_device_data;
-		pvt->skip_page_out = skip_page_out;
-		pvt->remove_gfn = true;
 		mutex_unlock(&kvm->arch.uvmem_lock);
-
-		pfn = gfn_to_pfn(kvm, gfn);
-		if (is_error_noslot_pfn(pfn))
-			continue;
-		kvm_release_pfn_clean(pfn);
 	}
+
+	mmap_read_unlock(kvm->mm);
 }
 
 unsigned long kvmppc_h_svm_init_abort(struct kvm *kvm)
-- 
2.27.0

