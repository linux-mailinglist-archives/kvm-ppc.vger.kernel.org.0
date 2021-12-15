Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81954761B4
	for <lists+kvm-ppc@lfdr.de>; Wed, 15 Dec 2021 20:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbhLOT1Y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 Dec 2021 14:27:24 -0500
Received: from 9.mo548.mail-out.ovh.net ([46.105.48.137]:59945 "EHLO
        9.mo548.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238939AbhLOT1Y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 15 Dec 2021 14:27:24 -0500
X-Greylist: delayed 4198 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2021 14:27:23 EST
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.188])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id AD77620E85;
        Wed, 15 Dec 2021 18:11:50 +0000 (UTC)
Received: from kaod.org (37.59.142.95) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 15 Dec
 2021 19:11:49 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-95G0017cc86e53-eee5-40b7-a96b-21362674cb97,
                    DB2000250E14A505ED1736C7348301D5E40ED0AA) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 90.76.172.47
Message-ID: <d980eeb7-1f32-dbd3-f60d-ea6ef24dbaaa@kaod.org>
Date:   Wed, 15 Dec 2021 19:11:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH kernel v3] KVM: PPC: Merge powerpc's debugfs entry content
 into generic entry
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        <linuxppc-dev@lists.ozlabs.org>
CC:     <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>,
        Fabiano Rosas <farosas@linux.ibm.com>
References: <20211215013309.217102-1-aik@ozlabs.ru>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20211215013309.217102-1-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG5EX1.mxp5.local (172.16.2.41) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 865273c1-ade8-4b17-ac86-6ab14a2095e7
X-Ovh-Tracer-Id: 3451446168262249379
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvuddrledvgdduudduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvfhfhjggtgfhisehtjeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhephffhleegueektdetffdvffeuieeugfekkeelheelteeftdfgtefffeehueegleehnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehfrghrohhsrghssehlihhnuhigrdhisghmrdgtohhm
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 12/15/21 02:33, Alexey Kardashevskiy wrote:
> At the moment KVM on PPC creates 3 types of entries under the kvm debugfs:
> 1) "%pid-%fd" per a KVM instance (for all platforms);
> 2) "vm%pid" (for PPC Book3s HV KVM);
> 3) "vm%u_vcpu%u_timing" (for PPC Book3e KVM).
> 
> The problem with this is that multiple VMs per process is not allowed for
> 2) and 3) which makes it possible for userspace to trigger errors when
> creating duplicated debugfs entries.
> 
> This merges all these into 1).
> 
> This defines kvm_arch_create_kvm_debugfs() similar to
> kvm_arch_create_vcpu_debugfs().
> 
> This defines 2 hooks in kvmppc_ops that allow specific KVM implementations
> add necessary entries, this adds the _e500 suffix to
> kvmppc_create_vcpu_debugfs_e500() to make it clear what platform it is for.
> 
> This makes use of already existing kvm_arch_create_vcpu_debugfs() on PPC.
> 
> This removes no more used debugfs_dir pointers from PPC kvm_arch structs.
> 
> This stops removing vcpu entries as once created vcpus stay around
> for the entire life of a VM and removed when the KVM instance is closed,
> see commit d56f5136b010 ("KVM: let kvm_destroy_vm_debugfs clean up vCPU
> debugfs directories").

It would nice to also move the KVM device debugfs files :

   /sys/kernel/debug/powerpc/kvm-xive-%p

These are dynamically created and destroyed at run time depending
on the interrupt mode negociated by CAS. It might be more complex ?

C.

> 
> Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> Changes:
> v3:
> * reworked commit log, especially, the bit about removing vcpus
> 
> v2:
> * handled powerpc-booke
> * s/kvm/vm/ in arch hooks
> ---
>   arch/powerpc/include/asm/kvm_host.h    |  6 ++---
>   arch/powerpc/include/asm/kvm_ppc.h     |  2 ++
>   arch/powerpc/kvm/timing.h              |  9 ++++----
>   arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>   arch/powerpc/kvm/book3s_hv.c           | 31 ++++++++++----------------
>   arch/powerpc/kvm/e500.c                |  1 +
>   arch/powerpc/kvm/e500mc.c              |  1 +
>   arch/powerpc/kvm/powerpc.c             | 16 ++++++++++---
>   arch/powerpc/kvm/timing.c              | 20 ++++-------------
>   10 files changed, 41 insertions(+), 49 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 17263276189e..f5e14fa683f4 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -26,6 +26,8 @@
>   #include <asm/hvcall.h>
>   #include <asm/mce.h>
>   
> +#define __KVM_HAVE_ARCH_VCPU_DEBUGFS
> +
>   #define KVM_MAX_VCPUS		NR_CPUS
>   #define KVM_MAX_VCORES		NR_CPUS
>   
> @@ -295,7 +297,6 @@ struct kvm_arch {
>   	bool dawr1_enabled;
>   	pgd_t *pgtable;
>   	u64 process_table;
> -	struct dentry *debugfs_dir;
>   	struct kvm_resize_hpt *resize_hpt; /* protected by kvm->lock */
>   #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
>   #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> @@ -673,7 +674,6 @@ struct kvm_vcpu_arch {
>   	u64 timing_min_duration[__NUMBER_OF_KVM_EXIT_TYPES];
>   	u64 timing_max_duration[__NUMBER_OF_KVM_EXIT_TYPES];
>   	u64 timing_last_exit;
> -	struct dentry *debugfs_exit_timing;
>   #endif
>   
>   #ifdef CONFIG_PPC_BOOK3S
> @@ -829,8 +829,6 @@ struct kvm_vcpu_arch {
>   	struct kvmhv_tb_accumulator rm_exit;	/* real-mode exit code */
>   	struct kvmhv_tb_accumulator guest_time;	/* guest execution */
>   	struct kvmhv_tb_accumulator cede_time;	/* time napping inside guest */
> -
> -	struct dentry *debugfs_dir;
>   #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
>   };
>   
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 33db83b82fbd..d2b192dea0d2 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -316,6 +316,8 @@ struct kvmppc_ops {
>   	int (*svm_off)(struct kvm *kvm);
>   	int (*enable_dawr1)(struct kvm *kvm);
>   	bool (*hash_v3_possible)(void);
> +	int (*create_vm_debugfs)(struct kvm *kvm);
> +	int (*create_vcpu_debugfs)(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
>   };
>   
>   extern struct kvmppc_ops *kvmppc_hv_ops;
> diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
> index feef7885ba82..493a7d510fd5 100644
> --- a/arch/powerpc/kvm/timing.h
> +++ b/arch/powerpc/kvm/timing.h
> @@ -14,8 +14,8 @@
>   #ifdef CONFIG_KVM_EXIT_TIMING
>   void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu);
>   void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu);
> -void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id);
> -void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu);
> +void kvmppc_create_vcpu_debugfs_e500(struct kvm_vcpu *vcpu,
> +				     struct dentry *debugfs_dentry);
>   
>   static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type)
>   {
> @@ -26,9 +26,8 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type)
>   /* if exit timing is not configured there is no need to build the c file */
>   static inline void kvmppc_init_timing_stats(struct kvm_vcpu *vcpu) {}
>   static inline void kvmppc_update_timing_stats(struct kvm_vcpu *vcpu) {}
> -static inline void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
> -						unsigned int id) {}
> -static inline void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
> +static inline void kvmppc_create_vcpu_debugfs_e500(struct kvm_vcpu *vcpu,
> +						   struct dentry *debugfs_dentry) {}
>   static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
>   #endif /* CONFIG_KVM_EXIT_TIMING */
>   
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index c63e263312a4..33dae253a0ac 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -2112,7 +2112,7 @@ static const struct file_operations debugfs_htab_fops = {
>   
>   void kvmppc_mmu_debugfs_init(struct kvm *kvm)
>   {
> -	debugfs_create_file("htab", 0400, kvm->arch.debugfs_dir, kvm,
> +	debugfs_create_file("htab", 0400, kvm->debugfs_dentry, kvm,
>   			    &debugfs_htab_fops);
>   }
>   
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index 8cebe5542256..e4ce2a35483f 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -1454,7 +1454,7 @@ static const struct file_operations debugfs_radix_fops = {
>   
>   void kvmhv_radix_debugfs_init(struct kvm *kvm)
>   {
> -	debugfs_create_file("radix", 0400, kvm->arch.debugfs_dir, kvm,
> +	debugfs_create_file("radix", 0400, kvm->debugfs_dentry, kvm,
>   			    &debugfs_radix_fops);
>   }
>   
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index bf1eb1160ae2..4c52541b6f37 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2768,20 +2768,17 @@ static const struct file_operations debugfs_timings_ops = {
>   };
>   
>   /* Create a debugfs directory for the vcpu */
> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
> +static int kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>   {
> -	char buf[16];
> -	struct kvm *kvm = vcpu->kvm;
> -
> -	snprintf(buf, sizeof(buf), "vcpu%u", id);
> -	vcpu->arch.debugfs_dir = debugfs_create_dir(buf, kvm->arch.debugfs_dir);
> -	debugfs_create_file("timings", 0444, vcpu->arch.debugfs_dir, vcpu,
> +	debugfs_create_file("timings", 0444, debugfs_dentry, vcpu,
>   			    &debugfs_timings_ops);
> +	return 0;
>   }
>   
>   #else /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
> -static void debugfs_vcpu_init(struct kvm_vcpu *vcpu, unsigned int id)
> +static int kvmppc_arch_create_vcpu_debugfs_hv(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>   {
> +	return 0;
>   }
>   #endif /* CONFIG_KVM_BOOK3S_HV_EXIT_TIMING */
>   
> @@ -2904,8 +2901,6 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
>   	vcpu->arch.cpu_type = KVM_CPU_3S_64;
>   	kvmppc_sanity_check(vcpu);
>   
> -	debugfs_vcpu_init(vcpu, id);
> -
>   	return 0;
>   }
>   
> @@ -5226,7 +5221,6 @@ void kvmppc_free_host_rm_ops(void)
>   static int kvmppc_core_init_vm_hv(struct kvm *kvm)
>   {
>   	unsigned long lpcr, lpid;
> -	char buf[32];
>   	int ret;
>   
>   	mutex_init(&kvm->arch.uvmem_lock);
> @@ -5359,15 +5353,14 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
>   		kvm->arch.smt_mode = 1;
>   	kvm->arch.emul_smt_mode = 1;
>   
> -	/*
> -	 * Create a debugfs directory for the VM
> -	 */
> -	snprintf(buf, sizeof(buf), "vm%d", current->pid);
> -	kvm->arch.debugfs_dir = debugfs_create_dir(buf, kvm_debugfs_dir);
> +	return 0;
> +}
> +
> +static int kvmppc_arch_create_vm_debugfs_hv(struct kvm *kvm)
> +{
>   	kvmppc_mmu_debugfs_init(kvm);
>   	if (radix_enabled())
>   		kvmhv_radix_debugfs_init(kvm);
> -
>   	return 0;
>   }
>   
> @@ -5382,8 +5375,6 @@ static void kvmppc_free_vcores(struct kvm *kvm)
>   
>   static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
>   {
> -	debugfs_remove_recursive(kvm->arch.debugfs_dir);
> -
>   	if (!cpu_has_feature(CPU_FTR_ARCH_300))
>   		kvm_hv_vm_deactivated();
>   
> @@ -6044,6 +6035,8 @@ static struct kvmppc_ops kvm_ops_hv = {
>   	.svm_off = kvmhv_svm_off,
>   	.enable_dawr1 = kvmhv_enable_dawr1,
>   	.hash_v3_possible = kvmppc_hash_v3_possible,
> +	.create_vcpu_debugfs = kvmppc_arch_create_vcpu_debugfs_hv,
> +	.create_vm_debugfs = kvmppc_arch_create_vm_debugfs_hv,
>   };
>   
>   static int kvm_init_subcore_bitmap(void)
> diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
> index 7e8b69015d20..c8b2b4478545 100644
> --- a/arch/powerpc/kvm/e500.c
> +++ b/arch/powerpc/kvm/e500.c
> @@ -495,6 +495,7 @@ static struct kvmppc_ops kvm_ops_e500 = {
>   	.emulate_op = kvmppc_core_emulate_op_e500,
>   	.emulate_mtspr = kvmppc_core_emulate_mtspr_e500,
>   	.emulate_mfspr = kvmppc_core_emulate_mfspr_e500,
> +	.create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
>   };
>   
>   static int __init kvmppc_e500_init(void)
> diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> index 1c189b5aadcc..fa0d8dbbe484 100644
> --- a/arch/powerpc/kvm/e500mc.c
> +++ b/arch/powerpc/kvm/e500mc.c
> @@ -381,6 +381,7 @@ static struct kvmppc_ops kvm_ops_e500mc = {
>   	.emulate_op = kvmppc_core_emulate_op_e500,
>   	.emulate_mtspr = kvmppc_core_emulate_mtspr_e500,
>   	.emulate_mfspr = kvmppc_core_emulate_mfspr_e500,
> +	.create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
>   };
>   
>   static int __init kvmppc_e500mc_init(void)
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a72920f4f221..2ea73dfcebb2 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -763,7 +763,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   		goto out_vcpu_uninit;
>   
>   	vcpu->arch.waitp = &vcpu->wait;
> -	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
>   	return 0;
>   
>   out_vcpu_uninit:
> @@ -780,8 +779,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	/* Make sure we're not using the vcpu anymore */
>   	hrtimer_cancel(&vcpu->arch.dec_timer);
>   
> -	kvmppc_remove_vcpu_debugfs(vcpu);
> -
>   	switch (vcpu->arch.irq_type) {
>   	case KVMPPC_IRQ_MPIC:
>   		kvmppc_mpic_disconnect_vcpu(vcpu->arch.mpic, vcpu);
> @@ -2505,3 +2502,16 @@ int kvm_arch_init(void *opaque)
>   }
>   
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);
> +
> +void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
> +{
> +	if (vcpu->kvm->arch.kvm_ops->create_vcpu_debugfs)
> +		vcpu->kvm->arch.kvm_ops->create_vcpu_debugfs(vcpu, debugfs_dentry);
> +}
> +
> +int kvm_arch_create_vm_debugfs(struct kvm *kvm)
> +{
> +	if (kvm->arch.kvm_ops->create_vm_debugfs)
> +		kvm->arch.kvm_ops->create_vm_debugfs(kvm);
> +	return 0;
> +}
> diff --git a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
> index ba56a5cbba97..f6d472874c85 100644
> --- a/arch/powerpc/kvm/timing.c
> +++ b/arch/powerpc/kvm/timing.c
> @@ -204,21 +204,9 @@ static const struct file_operations kvmppc_exit_timing_fops = {
>   	.release = single_release,
>   };
>   
> -void kvmppc_create_vcpu_debugfs(struct kvm_vcpu *vcpu, unsigned int id)
> +void kvmppc_create_vcpu_debugfs_e500(struct kvm_vcpu *vcpu,
> +				     struct dentry *debugfs_dentry)
>   {
> -	static char dbg_fname[50];
> -	struct dentry *debugfs_file;
> -
> -	snprintf(dbg_fname, sizeof(dbg_fname), "vm%u_vcpu%u_timing",
> -		 current->pid, id);
> -	debugfs_file = debugfs_create_file(dbg_fname, 0666, kvm_debugfs_dir,
> -						vcpu, &kvmppc_exit_timing_fops);
> -
> -	vcpu->arch.debugfs_exit_timing = debugfs_file;
> -}
> -
> -void kvmppc_remove_vcpu_debugfs(struct kvm_vcpu *vcpu)
> -{
> -	debugfs_remove(vcpu->arch.debugfs_exit_timing);
> -	vcpu->arch.debugfs_exit_timing = NULL;
> +	debugfs_create_file("timing", 0666, debugfs_dentry,
> +			    vcpu, &kvmppc_exit_timing_fops);
>   }
> 

