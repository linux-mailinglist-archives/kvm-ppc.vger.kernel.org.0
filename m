Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B74AE58D
	for <lists+kvm-ppc@lfdr.de>; Tue, 10 Sep 2019 10:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfIJIaM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 10 Sep 2019 04:30:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10710 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727058AbfIJIaM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 10 Sep 2019 04:30:12 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8A8RuiC066324
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Sep 2019 04:30:10 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ux6hcbh4w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 10 Sep 2019 04:30:10 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Tue, 10 Sep 2019 09:30:08 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Sep 2019 09:30:06 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8A8U5OL47186094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 08:30:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFFD452065;
        Tue, 10 Sep 2019 08:30:04 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.199.35.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DFB605204F;
        Tue, 10 Sep 2019 08:30:02 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v8 6/8] kvmppc: Radix changes for secure guest
Date:   Tue, 10 Sep 2019 13:59:44 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190910082946.7849-1-bharata@linux.ibm.com>
References: <20190910082946.7849-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19091008-0016-0000-0000-000002A9683C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091008-0017-0000-0000-00003309ED9C
Message-Id: <20190910082946.7849-7-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909100085
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

- After the guest becomes secure, when we handle a page fault of a page
  belonging to SVM in HV, send that page to UV via UV_PAGE_IN.
- Whenever a page is unmapped on the HV side, inform UV via UV_PAGE_INVAL.
- Ensure all those routines that walk the secondary page tables of
  the guest don't do so in case of secure VM. For secure guest, the
  active secondary page tables are in secure memory and the secondary
  page tables in HV are freed when guest becomes secure.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
---
 arch/powerpc/include/asm/kvm_host.h       | 12 ++++++++++++
 arch/powerpc/include/asm/ultravisor-api.h |  1 +
 arch/powerpc/include/asm/ultravisor.h     |  5 +++++
 arch/powerpc/kvm/book3s_64_mmu_radix.c    | 22 ++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_uvmem.c        | 20 ++++++++++++++++++++
 5 files changed, 60 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index cab3099db8d4..17780c82c1b4 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -876,6 +876,8 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 #ifdef CONFIG_PPC_UV
 int kvmppc_uvmem_init(void);
 void kvmppc_uvmem_free(void);
+bool kvmppc_is_guest_secure(struct kvm *kvm);
+int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa);
 #else
 static inline int kvmppc_uvmem_init(void)
 {
@@ -883,6 +885,16 @@ static inline int kvmppc_uvmem_init(void)
 }
 
 static inline void kvmppc_uvmem_free(void) {}
+
+static inline bool kvmppc_is_guest_secure(struct kvm *kvm)
+{
+	return false;
+}
+
+static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa)
+{
+	return -EFAULT;
+}
 #endif /* CONFIG_PPC_UV */
 
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
index 46b1ee381695..cf200d4ce703 100644
--- a/arch/powerpc/include/asm/ultravisor-api.h
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -29,5 +29,6 @@
 #define UV_UNREGISTER_MEM_SLOT		0xF124
 #define UV_PAGE_IN			0xF128
 #define UV_PAGE_OUT			0xF12C
+#define UV_PAGE_INVAL			0xF138
 
 #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index 719c0c3930b9..b333241bbe4c 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -57,4 +57,9 @@ static inline int uv_unregister_mem_slot(u64 lpid, u64 slotid)
 	return ucall_norets(UV_UNREGISTER_MEM_SLOT, lpid, slotid);
 }
 
+static inline int uv_page_inval(u64 lpid, u64 gpa, u64 page_shift)
+{
+	return ucall_norets(UV_PAGE_INVAL, lpid, gpa, page_shift);
+}
+
 #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 2d415c36a61d..93ad34e63045 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -19,6 +19,8 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
+#include <asm/ultravisor.h>
+#include <asm/kvm_host.h>
 
 /*
  * Supported radix tree geometry.
@@ -915,6 +917,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	if (!(dsisr & DSISR_PRTABLE_FAULT))
 		gpa |= ea & 0xfff;
 
+	if (kvmppc_is_guest_secure(kvm))
+		return kvmppc_send_page_to_uv(kvm, gpa & PAGE_MASK);
+
 	/* Get the corresponding memslot */
 	memslot = gfn_to_memslot(kvm, gfn);
 
@@ -972,6 +977,11 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	unsigned long gpa = gfn << PAGE_SHIFT;
 	unsigned int shift;
 
+	if (kvmppc_is_guest_secure(kvm)) {
+		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SIZE);
+		return 0;
+	}
+
 	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
 	if (ptep && pte_present(*ptep))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
@@ -989,6 +999,9 @@ int kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	int ref = 0;
 	unsigned long old, *rmapp;
 
+	if (kvmppc_is_guest_secure(kvm))
+		return ref;
+
 	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep)) {
 		old = kvmppc_radix_update_pte(kvm, ptep, _PAGE_ACCESSED, 0,
@@ -1013,6 +1026,9 @@ int kvm_test_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	unsigned int shift;
 	int ref = 0;
 
+	if (kvmppc_is_guest_secure(kvm))
+		return ref;
+
 	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
 	if (ptep && pte_present(*ptep) && pte_young(*ptep))
 		ref = 1;
@@ -1030,6 +1046,9 @@ static int kvm_radix_test_clear_dirty(struct kvm *kvm,
 	int ret = 0;
 	unsigned long old, *rmapp;
 
+	if (kvmppc_is_guest_secure(kvm))
+		return ret;
+
 	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
 	if (ptep && pte_present(*ptep) && pte_dirty(*ptep)) {
 		ret = 1;
@@ -1082,6 +1101,9 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
 	unsigned long gpa;
 	unsigned int shift;
 
+	if (kvmppc_is_guest_secure(kvm))
+		return;
+
 	gpa = memslot->base_gfn << PAGE_SHIFT;
 	spin_lock(&kvm->mmu_lock);
 	for (n = memslot->npages; n; --n) {
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 68a00df1ed79..6e1da68bbdd5 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -49,6 +49,11 @@ struct kvmppc_uvmem_page_pvt {
 	bool skip_page_out;
 };
 
+bool kvmppc_is_guest_secure(struct kvm *kvm)
+{
+	return !!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE);
+}
+
 unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
@@ -443,6 +448,21 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gpa,
 	return ret;
 }
 
+int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa)
+{
+	unsigned long pfn;
+	int ret;
+
+	pfn = gfn_to_pfn(kvm, gpa >> PAGE_SHIFT);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
+
+	ret = uv_page_in(kvm->arch.lpid, pfn << PAGE_SHIFT, gpa, 0, PAGE_SHIFT);
+	kvm_release_pfn_clean(pfn);
+
+	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
+}
+
 static u64 kvmppc_get_secmem_size(void)
 {
 	struct device_node *np;
-- 
2.21.0

