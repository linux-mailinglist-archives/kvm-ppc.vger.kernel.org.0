Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C11F39B3BC
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Jun 2021 09:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFDHXt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Jun 2021 03:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229978AbhFDHXs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 4 Jun 2021 03:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622791322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=orYq01Q31Yc39qB3ORg0nxtfa/WHWL4qWvUfOGPRsP0=;
        b=h3WrJaDP9ODhTKq3W2jWIX5DqBJH2Yi/x89nhHS4aIwbppRk6Nk+eUWRo8x+J6DXLbp+El
        pxgINOKt/v6jqUE1jljJMht25S6XLkiGA9rb8Z2XG4WokzCmOVNpkzNkwONPCtK/P08YBy
        adF2+VzNGqqknRnLjK2nCa5qYz+rzE0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-kvn5BLpDNmqY7674WnIeMQ-1; Fri, 04 Jun 2021 03:22:01 -0400
X-MC-Unique: kvn5BLpDNmqY7674WnIeMQ-1
Received: by mail-ed1-f70.google.com with SMTP id j13-20020aa7de8d0000b029038fc8e57037so4568337edv.0
        for <kvm-ppc@vger.kernel.org>; Fri, 04 Jun 2021 00:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=orYq01Q31Yc39qB3ORg0nxtfa/WHWL4qWvUfOGPRsP0=;
        b=qRmu9tY6M5tqkmM1qswuOfside8iDrx9sPDYKOj+V8l9TsIJzd3YtemVY2jtsSpJTS
         G4kGI9IvLlAPH9PYXz6J0hcPryQT73HI6hhY25j8WPEtDcgCAwWy2Jy+Y6FIZpcWkNrw
         9H+MXv+em/0N3GfgG4PkDXtK8AEiPlkcwmT5sHljuLf6tiv9aW6JZkI52H0fLQUrP/Ze
         /jeSlssMzXSg0AB2qma363Ytom4Hh5GytMzgL0/XAoNw+jVHRDPSoB3SOO4GgY2ZTg/w
         RESKys/AlJuEqp+0u2HlwMXRZqSSVMM6byvjKxC9nt8j43mKd2+cPxsV54NJpj029crJ
         SpKg==
X-Gm-Message-State: AOAM532p8NTXfvVL8q1bJV2LoU8OJKLrWw3ggCk/gbZS8eSDARmGWK1Q
        pVXP4xQyXl2HG5zsaThWG4oESWGVJC+gzZQSBoE985v+WH3fHgpHnoaqPVZb3VpzaaDgPqyEVcv
        lFwUa4/5mBuBvJaIRKQ==
X-Received: by 2002:a17:906:3042:: with SMTP id d2mr2962223ejd.234.1622791319624;
        Fri, 04 Jun 2021 00:21:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye48vq4jhWt3rfSGy/IZIfVkJe+CPcNZKJdo8nz+4VSYXPjlnXO0JZDmfdCwTwFNTDbvESog==
X-Received: by 2002:a17:906:3042:: with SMTP id d2mr2962196ejd.234.1622791319297;
        Fri, 04 Jun 2021 00:21:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gx23sm2456681ejb.125.2021.06.04.00.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 00:21:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
In-Reply-To: <20210603164315.682994-1-senozhatsky@chromium.org>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
Date:   Fri, 04 Jun 2021 09:21:56 +0200
Message-ID: <87a6o614dn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Sergey Senozhatsky <senozhatsky@chromium.org> writes:

> Add KVM suspend/hibernate PM-notifier which lets architectures
> to implement arch-specific VM suspend code. For instance, on x86
> this sets PVCLOCK_GUEST_STOPPED on all the VCPUs.
>
> Our case is that user puts the host system into sleep multiple
> times a day (e.g. closes the laptop's lid) so we need a reliable
> way to suspend VMs properly.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  arch/arm64/kvm/arm.c       |  4 ++++
>  arch/mips/kvm/mips.c       |  4 ++++
>  arch/powerpc/kvm/powerpc.c |  4 ++++
>  arch/s390/kvm/kvm-s390.c   |  4 ++++
>  arch/x86/kvm/x86.c         | 21 ++++++++++++++++++++
>  include/linux/kvm_host.h   |  8 ++++++++
>  virt/kvm/kvm_main.c        | 40 ++++++++++++++++++++++++++++++++++++++
>  7 files changed, 85 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1126eae27400..547dbe44d039 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1311,6 +1311,10 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>  	}
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 4d4af97dcc88..d4408acd2be6 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -980,6 +980,10 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>  	kvm_flush_remote_tlbs(kvm);
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  {
>  	long r;
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a2a68a958fa0..96e8a7b6fcf0 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -2334,6 +2334,10 @@ static int kvmppc_get_cpu_char(struct kvm_ppc_cpu_char *cp)
>  }
>  #endif
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>                         unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..c5f86fc1e497 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2367,6 +2367,10 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  	return r;
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04e67ad..3f3d6497593f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5613,6 +5613,27 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>  	return 0;
>  }
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm)
> +{
> +#ifdef CONFIG_PM
> +	int c;
> +
> +	mutex_lock(&kvm->lock);
> +	for (c = 0; c < kvm->created_vcpus; c++) {
> +		struct kvm_vcpu *vcpu = kvm->vcpus[c];
> +		int r;
> +
> +		if (!vcpu)
> +			continue;
> +		r = kvm_set_guest_paused(vcpu);
> +		if (!r)
> +			continue;
> +		pr_err("Failed to suspend VCPU-%d: %d\n", vcpu->vcpu_id,  r);
> +	}
> +	mutex_unlock(&kvm->lock);
> +#endif
> +}
> +
>  long kvm_arch_vm_ioctl(struct file *filp,
>  		       unsigned int ioctl, unsigned long arg)
>  {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2f34487e21f2..86695320a6b7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -37,6 +37,8 @@
>  #include <asm/kvm_host.h>
>  #include <linux/kvm_dirty_ring.h>
>  
> +#include <linux/notifier.h>
> +
>  #ifndef KVM_MAX_VCPU_ID
>  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
>  #endif
> @@ -579,6 +581,10 @@ struct kvm {
>  	pid_t userspace_pid;
>  	unsigned int max_halt_poll_ns;
>  	u32 dirty_ring_size;
> +
> +#ifdef CONFIG_PM
> +	struct notifier_block pm_notifier;
> +#endif
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -992,6 +998,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu);
>  
> +void kvm_arch_pm_notifier(struct kvm *kvm);
> +
>  #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry);
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6b4feb92dc79..86925ab7d162 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -51,6 +51,7 @@
>  #include <linux/io.h>
>  #include <linux/lockdep.h>
>  #include <linux/kthread.h>
> +#include <linux/suspend.h>
>  
>  #include <asm/processor.h>
>  #include <asm/ioctl.h>
> @@ -779,6 +780,43 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
>  
>  #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
>  
> +#ifdef CONFIG_PM
> +static int kvm_pm_notifier_call(struct notifier_block *bl,
> +				unsigned long state,
> +				void *unused)
> +{
> +	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
> +
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		kvm_arch_pm_notifier(kvm);
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static void kvm_init_pm_notifier(struct kvm *kvm)
> +{
> +	kvm->pm_notifier.notifier_call = kvm_pm_notifier_call;
> +	kvm->pm_notifier.priority = INT_MAX;
> +	register_pm_notifier(&kvm->pm_notifier);
> +}
> +
> +static void kvm_destroy_pm_notifier(struct kvm *kvm)
> +{
> +	unregister_pm_notifier(&kvm->pm_notifier);
> +}
> +#else
> +static void kvm_init_pm_notifier(struct kvm *kvm)
> +{
> +}
> +
> +static void kvm_destroy_pm_notifier(struct kvm *kvm)
> +{
> +}
> +#endif /* CONFIG_PM */
> +
>  static struct kvm_memslots *kvm_alloc_memslots(void)
>  {
>  	int i;
> @@ -962,6 +1000,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	mutex_unlock(&kvm_lock);
>  
>  	preempt_notifier_inc();
> +	kvm_init_pm_notifier(kvm);
>  

You've probably thought it through and I didn't but wouldn't it be
easier to have one global pm_notifier call for KVM which would go
through the list of VMs instead of registering/deregistering a
pm_notifier call for every created/destroyed VM?

>  	return kvm;
>  
> @@ -1009,6 +1048,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	int i;
>  	struct mm_struct *mm = kvm->mm;
>  
> +	kvm_destroy_pm_notifier(kvm);
>  	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
>  	kvm_destroy_vm_debugfs(kvm);
>  	kvm_arch_sync_events(kvm);

-- 
Vitaly

