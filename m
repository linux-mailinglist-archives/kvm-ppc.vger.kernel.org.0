Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3681163C2E
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Jul 2019 21:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfGITv2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Jul 2019 15:51:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbfGITv1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Jul 2019 15:51:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69JlKIC126474;
        Tue, 9 Jul 2019 15:51:22 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tn0mjj18t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 15:51:22 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x69JnVJl002826;
        Tue, 9 Jul 2019 19:51:21 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 2tjk96qar8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 19:51:21 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69JpJ8Z57737560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 19:51:19 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53FB06A04F;
        Tue,  9 Jul 2019 19:51:19 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E941B6A054;
        Tue,  9 Jul 2019 19:51:18 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 19:51:18 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 09 Jul 2019 14:53:47 -0500
From:   janani <janani@linux.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, paulus@au1.ibm.com,
        sukadev@linux.vnet.ibm.com,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [RFC PATCH v5 5/7] kvmppc: Radix changes for secure guest
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190709102545.9187-6-bharata@linux.ibm.com>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-6-bharata@linux.ibm.com>
Message-ID: <5c7231766bc1f78e3cc1a467186e3356@linux.vnet.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090235
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-07-09 05:25, Bharata B Rao wrote:
> - After the guest becomes secure, when we handle a page fault of a page
>   belonging to SVM in HV, send that page to UV via UV_PAGE_IN.
> - Whenever a page is unmapped on the HV side, inform UV via 
> UV_PAGE_INVAL.
> - Ensure all those routines that walk the secondary page tables of
>   the guest don't do so in case of secure VM. For secure guest, the
>   active secondary page tables are in secure memory and the secondary
>   page tables in HV are freed when guest becomes secure.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h       | 12 ++++++++++++
>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>  arch/powerpc/include/asm/ultravisor.h     |  7 +++++++
>  arch/powerpc/kvm/book3s_64_mmu_radix.c    | 22 ++++++++++++++++++++++
>  arch/powerpc/kvm/book3s_hv_hmm.c          | 20 ++++++++++++++++++++
>  5 files changed, 62 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h
> b/arch/powerpc/include/asm/kvm_host.h
> index 0c49c3401c63..dcbf7480cb10 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -865,6 +865,8 @@ static inline void
> kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  #ifdef CONFIG_PPC_UV
>  extern int kvmppc_hmm_init(void);
>  extern void kvmppc_hmm_free(void);
> +extern bool kvmppc_is_guest_secure(struct kvm *kvm);
> +extern int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa);
>  #else
>  static inline int kvmppc_hmm_init(void)
>  {
> @@ -872,6 +874,16 @@ static inline int kvmppc_hmm_init(void)
>  }
> 
>  static inline void kvmppc_hmm_free(void) {}
> +
> +static inline bool kvmppc_is_guest_secure(struct kvm *kvm)
> +{
> +	return false;
> +}
> +
> +static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned 
> long gpa)
> +{
> +	return -EFAULT;
> +}
>  #endif /* CONFIG_PPC_UV */
> 
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/powerpc/include/asm/ultravisor-api.h
> b/arch/powerpc/include/asm/ultravisor-api.h
> index d6d6eb2e6e6b..9f5510b55892 100644
> --- a/arch/powerpc/include/asm/ultravisor-api.h
> +++ b/arch/powerpc/include/asm/ultravisor-api.h
> @@ -24,5 +24,6 @@
>  #define UV_UNREGISTER_MEM_SLOT		0xF124
>  #define UV_PAGE_IN			0xF128
>  #define UV_PAGE_OUT			0xF12C
> +#define UV_PAGE_INVAL			0xF138
> 
>  #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> diff --git a/arch/powerpc/include/asm/ultravisor.h
> b/arch/powerpc/include/asm/ultravisor.h
> index fe45be9ee63b..f4f674794b35 100644
> --- a/arch/powerpc/include/asm/ultravisor.h
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -77,6 +77,13 @@ static inline int uv_unregister_mem_slot(u64 lpid,
> u64 slotid)
> 
>  	return ucall(UV_UNREGISTER_MEM_SLOT, retbuf, lpid, slotid);
>  }
> +
> +static inline int uv_page_inval(u64 lpid, u64 gpa, u64 page_shift)
> +{
> +	unsigned long retbuf[UCALL_BUFSIZE];
> +
> +	return ucall(UV_PAGE_INVAL, retbuf, lpid, gpa, page_shift);
> +}
>  #endif /* !__ASSEMBLY__ */
> 
>  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index f55ef071883f..c454600c454f 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -21,6 +21,8 @@
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
>  #include <asm/pte-walk.h>
> +#include <asm/ultravisor.h>
> +#include <asm/kvm_host.h>
> 
>  /*
>   * Supported radix tree geometry.
> @@ -923,6 +925,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_run
> *run, struct kvm_vcpu *vcpu,
>  	if (!(dsisr & DSISR_PRTABLE_FAULT))
>  		gpa |= ea & 0xfff;
> 
> +	if (kvmppc_is_guest_secure(kvm))
> +		return kvmppc_send_page_to_uv(kvm, gpa & PAGE_MASK);
> +
>  	/* Get the corresponding memslot */
>  	memslot = gfn_to_memslot(kvm, gfn);
> 
> @@ -980,6 +985,11 @@ int kvm_unmap_radix(struct kvm *kvm, struct
> kvm_memory_slot *memslot,
>  	unsigned long gpa = gfn << PAGE_SHIFT;
>  	unsigned int shift;
> 
> +	if (kvmppc_is_guest_secure(kvm)) {
> +		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SIZE);
> +		return 0;
> +	}
> +
>  	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
>  	if (ptep && pte_present(*ptep))
>  		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
> @@ -997,6 +1007,9 @@ int kvm_age_radix(struct kvm *kvm, struct
> kvm_memory_slot *memslot,
>  	int ref = 0;
>  	unsigned long old, *rmapp;
> 
> +	if (kvmppc_is_guest_secure(kvm))
> +		return ref;
> +
>  	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
>  	if (ptep && pte_present(*ptep) && pte_young(*ptep)) {
>  		old = kvmppc_radix_update_pte(kvm, ptep, _PAGE_ACCESSED, 0,
> @@ -1021,6 +1034,9 @@ int kvm_test_age_radix(struct kvm *kvm, struct
> kvm_memory_slot *memslot,
>  	unsigned int shift;
>  	int ref = 0;
> 
> +	if (kvmppc_is_guest_secure(kvm))
> +		return ref;
> +
>  	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
>  	if (ptep && pte_present(*ptep) && pte_young(*ptep))
>  		ref = 1;
> @@ -1038,6 +1054,9 @@ static int kvm_radix_test_clear_dirty(struct kvm 
> *kvm,
>  	int ret = 0;
>  	unsigned long old, *rmapp;
> 
> +	if (kvmppc_is_guest_secure(kvm))
> +		return ret;
> +
>  	ptep = __find_linux_pte(kvm->arch.pgtable, gpa, NULL, &shift);
>  	if (ptep && pte_present(*ptep) && pte_dirty(*ptep)) {
>  		ret = 1;
> @@ -1090,6 +1109,9 @@ void kvmppc_radix_flush_memslot(struct kvm *kvm,
>  	unsigned long gpa;
>  	unsigned int shift;
> 
> +	if (kvmppc_is_guest_secure(kvm))
> +		return;
> +
>  	gpa = memslot->base_gfn << PAGE_SHIFT;
>  	spin_lock(&kvm->mmu_lock);
>  	for (n = memslot->npages; n; --n) {
> diff --git a/arch/powerpc/kvm/book3s_hv_hmm.c 
> b/arch/powerpc/kvm/book3s_hv_hmm.c
> index 55bab9c4e60a..9e6c88de456f 100644
> --- a/arch/powerpc/kvm/book3s_hv_hmm.c
> +++ b/arch/powerpc/kvm/book3s_hv_hmm.c
> @@ -62,6 +62,11 @@ struct kvmppc_hmm_migrate_args {
>  	unsigned long page_shift;
>  };
> 
> +bool kvmppc_is_guest_secure(struct kvm *kvm)
> +{
> +	return !!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE);
> +}
> +
>  unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
>  {
>  	struct kvm_memslots *slots;
> @@ -494,6 +499,21 @@ kvmppc_h_svm_page_out(struct kvm *kvm, unsigned 
> long gpa,
>  	return ret;
>  }
> 
> +int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa)
> +{
> +	unsigned long pfn;
> +	int ret;
> +
> +	pfn = gfn_to_pfn(kvm, gpa >> PAGE_SHIFT);
> +	if (is_error_noslot_pfn(pfn))
> +		return -EFAULT;
> +
> +	ret = uv_page_in(kvm->arch.lpid, pfn << PAGE_SHIFT, gpa, 0, 
> PAGE_SHIFT);
> +	kvm_release_pfn_clean(pfn);
> +
> +	return (ret == U_SUCCESS) ? RESUME_GUEST : -EFAULT;
> +}
> +
>  static u64 kvmppc_get_secmem_size(void)
>  {
>  	struct device_node *np;
