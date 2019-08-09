Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA408746F
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Aug 2019 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405807AbfHIIlg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Aug 2019 04:41:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405981AbfHIIlg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Aug 2019 04:41:36 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x798bb81005179
        for <kvm-ppc@vger.kernel.org>; Fri, 9 Aug 2019 04:41:34 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u940u3ner-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 09 Aug 2019 04:41:33 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 9 Aug 2019 09:41:31 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 9 Aug 2019 09:41:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x798fStq33423854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Aug 2019 08:41:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DFC0A4054;
        Fri,  9 Aug 2019 08:41:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75D41A405B;
        Fri,  9 Aug 2019 08:41:26 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.95.61])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Aug 2019 08:41:26 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v6 5/7] kvmppc: Radix changes for secure guest
Date:   Fri,  9 Aug 2019 14:11:06 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809084108.30343-1-bharata@linux.ibm.com>
References: <20190809084108.30343-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19080908-0012-0000-0000-0000033CA6CA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080908-0013-0000-0000-00002176ABF4
Message-Id: <20190809084108.30343-6-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090089
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
 arch/powerpc/kvm/book3s_hv_devm.c         | 20 ++++++++++++++++++++
 5 files changed, 60 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1827c22909cd..db680d7f5779 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -856,6 +856,8 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 #ifdef CONFIG_PPC_UV
 extern int kvmppc_devm_init(void);
 extern void kvmppc_devm_free(void);
+extern bool kvmppc_is_guest_secure(struct kvm *kvm);
+extern int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa);
 #else
 static inline int kvmppc_devm_init(void)
 {
@@ -863,6 +865,16 @@ static inline int kvmppc_devm_init(void)
 }
 
 static inline void kvmppc_devm_free(void) {}
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
index 79c415bf5ee8..640db659c8c8 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -45,4 +45,9 @@ static inline int uv_unregister_mem_slot(u64 lpid, u64 slotid)
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
diff --git a/arch/powerpc/kvm/book3s_hv_devm.c b/arch/powerpc/kvm/book3s_hv_devm.c
index c55bb5f57928..9c4b05cd5b0a 100644
--- a/arch/powerpc/kvm/book3s_hv_devm.c
+++ b/arch/powerpc/kvm/book3s_hv_devm.c
@@ -65,6 +65,11 @@ struct kvmppc_devm_copy_args {
 	unsigned long page_shift;
 };
 
+bool kvmppc_is_guest_secure(struct kvm *kvm)
+{
+	return !!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE);
+}
+
 unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
@@ -483,6 +488,21 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gpa,
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

