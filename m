Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B7646F8
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jul 2019 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbfGJN2E (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jul 2019 09:28:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbfGJN2E (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jul 2019 09:28:04 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ADQVC8066691;
        Wed, 10 Jul 2019 09:27:55 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tng242mty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 09:27:55 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6ADPvAE030314;
        Wed, 10 Jul 2019 13:27:54 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 2tjk97c56h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jul 2019 13:27:54 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6ADRrVG43516198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 13:27:53 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 691D4AC059;
        Wed, 10 Jul 2019 13:27:53 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 308D1AC05B;
        Wed, 10 Jul 2019 13:27:52 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jul 2019 13:27:52 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Jul 2019 08:30:21 -0500
From:   janani <janani@linux.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, paulus@au1.ibm.com,
        sukadev@linux.vnet.ibm.com,
        Linuxppc-dev 
        <linuxppc-dev-bounces+janani=linux.ibm.com@lists.ozlabs.org>
Subject: Re: [RFC PATCH v5 6/7] kvmppc: Support reset of secure guest
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190709102545.9187-7-bharata@linux.ibm.com>
References: <20190709102545.9187-1-bharata@linux.ibm.com>
 <20190709102545.9187-7-bharata@linux.ibm.com>
Message-ID: <f0c874af38a227cc721b27b77e40400f@linux.vnet.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100156
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-07-09 05:25, Bharata B Rao wrote:
> Add support for reset of secure guest via a new ioctl KVM_PPC_SVM_OFF.
> This ioctl will be issued by QEMU during reset and includes the
> the following steps:
> 
> - Ask UV to terminate the guest via UV_SVM_TERMINATE ucall
> - Unpin the VPA pages so that they can be migrated back to secure
>   side when guest becomes secure again. This is required because
>   pinned pages can't be migrated.
> - Reinitialize guest's partitioned scoped page tables. These are
>   freed when guest become secure (H_SVM_INIT_DONE)
> - Release all HMM pages of the secure guest.
> 
> After these steps, guest is ready to issue UV_ESM call once again
> to switch to secure mode.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 	[Implementation of uv_svm_terminate() and its call from
> 	guest shutdown path]
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 	[Unpinning of VPA pages]
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  Documentation/virtual/kvm/api.txt         | 19 ++++++
>  arch/powerpc/include/asm/kvm_book3s_hmm.h |  7 +++
>  arch/powerpc/include/asm/kvm_ppc.h        |  2 +
>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>  arch/powerpc/include/asm/ultravisor.h     |  7 +++
>  arch/powerpc/kvm/book3s_hv.c              | 70 +++++++++++++++++++++++
>  arch/powerpc/kvm/book3s_hv_hmm.c          | 60 +++++++++++++++++++
>  arch/powerpc/kvm/powerpc.c                | 12 ++++
>  include/uapi/linux/kvm.h                  |  1 +
>  tools/include/uapi/linux/kvm.h            |  1 +
>  10 files changed, 180 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt
> b/Documentation/virtual/kvm/api.txt
> index ba6c42c576dd..c89c24ad86ed 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4065,6 +4065,25 @@ KVM_ARM_VCPU_FINALIZE call.
>  See KVM_ARM_VCPU_INIT for details of vcpu features that require 
> finalization
>  using this ioctl.
> 
> +4.120 KVM_PPC_SVM_OFF
> +
> +Capability: basic
> +Architectures: powerpc
> +Type: vm ioctl
> +Parameters: none
> +Returns: 0 on successful completion,
> +Errors:
> +  EINVAL:    if ultravisor failed to terminate the secure guest
> +  ENOMEM:    if hypervisor failed to allocate new radix page tables 
> for guest
> +
> +This ioctl is used to turn off the secure mode of the guest or 
> transition
> +the guest from secure mode to normal mode. This is invoked when the 
> guest
> +is reset. This has no effect if called for a normal guest.
> +
> +This ioctl issues an ultravisor call to terminate the secure guest,
> +unpin the VPA pages, reinitialize guest's partition scoped page
> +tables and releases all the HMM pages that is associated with this 
> guest.
> +
>  5. The kvm_run structure
>  ------------------------
> 
> diff --git a/arch/powerpc/include/asm/kvm_book3s_hmm.h
> b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> index 8c7aacabb2e0..cd2b0f927766 100644
> --- a/arch/powerpc/include/asm/kvm_book3s_hmm.h
> +++ b/arch/powerpc/include/asm/kvm_book3s_hmm.h
> @@ -13,6 +13,8 @@ extern unsigned long kvmppc_h_svm_page_out(struct kvm 
> *kvm,
>  					  unsigned long page_shift);
>  extern unsigned long kvmppc_h_svm_init_start(struct kvm *kvm);
>  extern unsigned long kvmppc_h_svm_init_done(struct kvm *kvm);
> +extern void kvmppc_hmm_free_memslot_pfns(struct kvm *kvm,
> +		struct kvm_memslots *slots);
>  #else
>  static inline unsigned long
>  kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gra,
> @@ -37,5 +39,10 @@ static inline unsigned long
> kvmppc_h_svm_init_done(struct kvm *kvm)
>  {
>  	return H_UNSUPPORTED;
>  }
> +
> +static inline void kvmppc_hmm_free_memslot_pfns(struct kvm *kvm,
> +		struct kvm_memslots *slots)
> +{
> +}
>  #endif /* CONFIG_PPC_UV */
>  #endif /* __POWERPC_KVM_PPC_HMM_H__ */
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h
> b/arch/powerpc/include/asm/kvm_ppc.h
> index bc892380e6cd..d80ece28d65d 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -188,6 +188,7 @@ extern void
> kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
>  extern int kvmppc_switch_mmu_to_hpt(struct kvm *kvm);
>  extern int kvmppc_switch_mmu_to_radix(struct kvm *kvm);
>  extern void kvmppc_setup_partition_table(struct kvm *kvm);
> +extern int kvmppc_reinit_partition_table(struct kvm *kvm);
> 
>  extern long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  				struct kvm_create_spapr_tce_64 *args);
> @@ -332,6 +333,7 @@ struct kvmppc_ops {
>  			       int size);
>  	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  			      int size);
> +	int (*svm_off)(struct kvm *kvm);
>  };
> 
>  extern struct kvmppc_ops *kvmppc_hv_ops;
> diff --git a/arch/powerpc/include/asm/ultravisor-api.h
> b/arch/powerpc/include/asm/ultravisor-api.h
> index 9f5510b55892..c8180427fa01 100644
> --- a/arch/powerpc/include/asm/ultravisor-api.h
> +++ b/arch/powerpc/include/asm/ultravisor-api.h
> @@ -25,5 +25,6 @@
>  #define UV_PAGE_IN			0xF128
>  #define UV_PAGE_OUT			0xF12C
>  #define UV_PAGE_INVAL			0xF138
> +#define UV_SVM_TERMINATE		0xF13C
> 
>  #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> diff --git a/arch/powerpc/include/asm/ultravisor.h
> b/arch/powerpc/include/asm/ultravisor.h
> index f4f674794b35..a5e4516c8ddb 100644
> --- a/arch/powerpc/include/asm/ultravisor.h
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -84,6 +84,13 @@ static inline int uv_page_inval(u64 lpid, u64 gpa,
> u64 page_shift)
> 
>  	return ucall(UV_PAGE_INVAL, retbuf, lpid, gpa, page_shift);
>  }
> +
> +static inline int uv_svm_terminate(u64 lpid)
> +{
> +	unsigned long retbuf[UCALL_BUFSIZE];
> +
> +	return ucall(UV_SVM_TERMINATE, retbuf, lpid);
> +}
>  #endif /* !__ASSEMBLY__ */
> 
>  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kvm/book3s_hv.c 
> b/arch/powerpc/kvm/book3s_hv.c
> index 7cbb5edaed01..41b0fff199d3 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2437,6 +2437,15 @@ static void unpin_vpa(struct kvm *kvm, struct
> kvmppc_vpa *vpa)
>  					vpa->dirty);
>  }
> 
> +static void unpin_vpa_reset(struct kvm *kvm, struct kvmppc_vpa *vpa)
> +{
> +	unpin_vpa(kvm, vpa);
> +	vpa->gpa = 0;
> +	vpa->pinned_addr = NULL;
> +	vpa->dirty = false;
> +	vpa->update_pending = 0;
> +}
> +
>  static void kvmppc_core_vcpu_free_hv(struct kvm_vcpu *vcpu)
>  {
>  	spin_lock(&vcpu->arch.vpa_update_lock);
> @@ -4577,6 +4586,22 @@ void kvmppc_setup_partition_table(struct kvm 
> *kvm)
>  	kvmhv_set_ptbl_entry(kvm->arch.lpid, dw0, dw1);
>  }
> 
> +/*
> + * Called from KVM_PPC_SVM_OFF ioctl at guest reset time when secure
> + * guest is converted back to normal guest.
> + */
> +int kvmppc_reinit_partition_table(struct kvm *kvm)
> +{
> +	int ret;
> +
> +	ret = kvmppc_init_vm_radix(kvm);
> +	if (ret)
> +		return ret;
> +
> +	kvmppc_setup_partition_table(kvm);
> +	return 0;
> +}
> +
>  /*
>   * Set up HPT (hashed page table) and RMA (real-mode area).
>   * Must be called with kvm->lock held.
> @@ -4956,6 +4981,7 @@ static void kvmppc_core_destroy_vm_hv(struct kvm 
> *kvm)
>  		if (nesting_enabled(kvm))
>  			kvmhv_release_all_nested(kvm);
>  		kvm->arch.process_table = 0;
> +		uv_svm_terminate(kvm->arch.lpid);
>  		kvmhv_set_ptbl_entry(kvm->arch.lpid, 0, 0);
>  	}
>  	kvmppc_free_lpid(kvm->arch.lpid);
> @@ -5397,6 +5423,49 @@ static int kvmhv_store_to_eaddr(struct kvm_vcpu
> *vcpu, ulong *eaddr, void *ptr,
>  	return rc;
>  }
> 
> +/*
> + *  IOCTL handler to turn off secure mode of guest
> + *
> + * - Issue ucall to terminate the guest on the UV side
> + * - Unpin the VPA pages (Enables these pages to be migrated back
> + *   when VM becomes secure again)
> + * - Recreate partition table as the guest is transitioning back to
> + *   normal mode
> + * - Release all HMM pages
> + */
> +static int kvmhv_svm_off(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int ret = 0;
> +	int i;
> +
> +	if (kvmppc_is_guest_secure(kvm)) {
> +		ret = uv_svm_terminate(kvm->arch.lpid);
> +		if (ret != U_SUCCESS) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			spin_lock(&vcpu->arch.vpa_update_lock);
> +			unpin_vpa_reset(kvm, &vcpu->arch.dtl);
> +			unpin_vpa_reset(kvm, &vcpu->arch.slb_shadow);
> +			unpin_vpa_reset(kvm, &vcpu->arch.vpa);
> +			spin_unlock(&vcpu->arch.vpa_update_lock);
> +		}
> +
> +		ret = kvmppc_reinit_partition_table(kvm);
> +		if (ret)
> +			goto out;
> +		kvm->arch.secure_guest = 0;
> +		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> +			kvmppc_hmm_free_memslot_pfns(kvm,
> +			__kvm_memslots(kvm, i));
> +	}
> +out:
> +	return ret;
> +}
> +
>  static struct kvmppc_ops kvm_ops_hv = {
>  	.get_sregs = kvm_arch_vcpu_ioctl_get_sregs_hv,
>  	.set_sregs = kvm_arch_vcpu_ioctl_set_sregs_hv,
> @@ -5439,6 +5508,7 @@ static struct kvmppc_ops kvm_ops_hv = {
>  	.enable_nested = kvmhv_enable_nested,
>  	.load_from_eaddr = kvmhv_load_from_eaddr,
>  	.store_to_eaddr = kvmhv_store_to_eaddr,
> +	.svm_off = kvmhv_svm_off,
>  };
> 
>  static int kvm_init_subcore_bitmap(void)
> diff --git a/arch/powerpc/kvm/book3s_hv_hmm.c 
> b/arch/powerpc/kvm/book3s_hv_hmm.c
> index 9e6c88de456f..165926c069ba 100644
> --- a/arch/powerpc/kvm/book3s_hv_hmm.c
> +++ b/arch/powerpc/kvm/book3s_hv_hmm.c
> @@ -38,6 +38,8 @@
>  #include <linux/kvm_host.h>
>  #include <linux/sched/mm.h>
>  #include <asm/ultravisor.h>
> +#include <asm/kvm_ppc.h>
> +#include <asm/kvm_book3s.h>
> 
>  struct kvmppc_hmm_device {
>  	struct hmm_device *device;
> @@ -98,6 +100,12 @@ unsigned long kvmppc_h_svm_init_done(struct kvm 
> *kvm)
>  		return H_UNSUPPORTED;
> 
>  	kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
> +	if (kvm_is_radix(kvm)) {
> +		pr_info("LPID %d went secure, freeing HV side radix pgtables\n",
> +			kvm->arch.lpid);
> +		kvmppc_free_radix(kvm);
> +	}
> +
>  	return H_SUCCESS;
>  }
> 
> @@ -113,6 +121,58 @@ static inline bool kvmppc_is_hmm_pfn(unsigned long 
> pfn)
>  	return !!(pfn & KVMPPC_PFN_HMM);
>  }
> 
> +/*
> + * Drop HMM pages that we maintain for the secure guest
> + *
> + * We mark the pages to be skipped from UV_PAGE_OUT when there is HMM
> + * fault on these pages. Next we get these pages, force HMM fault,
> + * do fault migration to replace the HMM PTEs from QEMU page tables
> + * with normal PTEs from newly allocated pages.
> + */
> +static void kvmppc_hmm_drop_pages(struct kvm_memory_slot *free,
> struct kvm *kvm)
> +{
> +	int i;
> +	struct kvmppc_hmm_page_pvt *pvt;
> +	unsigned long pfn;
> +
> +	for (i = 0; i < free->npages; i++) {
> +		unsigned long *rmap = &free->arch.rmap[i];
> +		struct page *hmm_page;
> +
> +		if (kvmppc_is_hmm_pfn(*rmap)) {
> +			hmm_page = pfn_to_page(*rmap & ~KVMPPC_PFN_HMM);
> +			pvt = (struct kvmppc_hmm_page_pvt *)
> +				hmm_devmem_page_get_drvdata(hmm_page);
> +			pvt->skip_page_out = true;
> +
> +			pfn = gfn_to_pfn(kvm, pvt->gpa >> PAGE_SHIFT);
> +			if (is_error_noslot_pfn(pfn))
> +				continue;
> +			kvm_release_pfn_clean(pfn);
> +		}
> +	}
> +}
> +
> +/*
> + * Called from KVM_PPC_SVM_OFF ioctl when secure guest is reset
> + *
> + * UV has already cleaned up the guest, we release any HMM pages that
> + * we maintain
> + */
> +void kvmppc_hmm_free_memslot_pfns(struct kvm *kvm, struct kvm_memslots 
> *slots)
> +{
> +	struct kvm_memory_slot *memslot;
> +	int srcu_idx;
> +
> +	if (!slots)
> +		return;
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +	kvm_for_each_memslot(memslot, slots)
> +		kvmppc_hmm_drop_pages(memslot, kvm);
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +}
> +
>  /*
>   * Get a free HMM PFN from the pool
>   *
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 3393b166817a..0c5fae004adf 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -42,6 +42,8 @@
>  #include <asm/hvcall.h>
>  #include <asm/plpar_wrappers.h>
>  #endif
> +#include <asm/ultravisor.h>
> +#include <asm/kvm_host.h>
> 
>  #include "timing.h"
>  #include "irq.h"
> @@ -2423,6 +2425,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			r = -EFAULT;
>  		break;
>  	}
> +	case KVM_PPC_SVM_OFF: {
> +		struct kvm *kvm = filp->private_data;
> +
> +		r = 0;
> +		if (!kvm->arch.kvm_ops->svm_off)
> +			goto out;
> +
> +		r = kvm->arch.kvm_ops->svm_off(kvm);
> +		break;
> +	}
>  	default: {
>  		struct kvm *kvm = filp->private_data;
>  		r = kvm->arch.kvm_ops->arch_vm_ioctl(filp, ioctl, arg);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2fe12b40d503..c1dbdd428025 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1327,6 +1327,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct 
> kvm_ppc_rmmu_info)
>  /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
>  #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct 
> kvm_ppc_cpu_char)
> +#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb2)
> 
>  /* ioctl for vm fd */
>  #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct 
> kvm_create_device)
> diff --git a/tools/include/uapi/linux/kvm.h 
> b/tools/include/uapi/linux/kvm.h
> index 6d4ea4b6c922..03c89f4a01b2 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1319,6 +1319,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct 
> kvm_ppc_rmmu_info)
>  /* Available with KVM_CAP_PPC_GET_CPU_CHAR */
>  #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct 
> kvm_ppc_cpu_char)
> +#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb2)
> 
>  /* ioctl for vm fd */
>  #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct 
> kvm_create_device)
