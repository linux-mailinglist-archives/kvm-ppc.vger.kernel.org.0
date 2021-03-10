Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14E833421C
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Mar 2021 16:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhCJPva (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Mar 2021 10:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhCJPvK (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 10 Mar 2021 10:51:10 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE1D864FB9;
        Wed, 10 Mar 2021 15:51:09 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.misterjones.org)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lK175-000nQG-Kj; Wed, 10 Mar 2021 15:51:07 +0000
Date:   Wed, 10 Mar 2021 15:51:06 +0000
Message-ID: <875z1zxb11.wl-maz@kernel.org>
From:   Marc Zyngier <maz@kernel.org>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Linux MIPS <linux-mips@vger.kernel.org>,
        KVM PPC <kvm-ppc@vger.kernel.org>,
        Linux S390 <linux-s390@vger.kernel.org>,
        Linux kselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics in binary format
In-Reply-To: <20210310003024.2026253-4-jingzhangos@google.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
        <20210310003024.2026253-4-jingzhangos@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/27.1
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: jingzhangos@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, pshier@google.com, oupton@google.com, rientjes@google.com, eesposit@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 10 Mar 2021 00:30:23 +0000,
Jing Zhang <jingzhangos@google.com> wrote:
> 
> Three ioctl commands are added to support binary form statistics data
> retrieval. KVM_STATS_GET_INFO, KVM_STATS_GET_NAMES, KVM_STATS_GET_DATA.
> KVM_CAP_STATS_BINARY_FORM indicates the capability.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  virt/kvm/kvm_main.c | 115 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 383df23514b9..87dd62516c8b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3464,6 +3464,51 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = kvm_arch_vcpu_ioctl_set_fpu(vcpu, fpu);
>  		break;
>  	}
> +	case KVM_STATS_GET_INFO: {
> +		struct kvm_stats_info stats_info;
> +
> +		r = -EFAULT;
> +		stats_info.num_stats = VCPU_STAT_COUNT;
> +		if (copy_to_user(argp, &stats_info, sizeof(stats_info)))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	case KVM_STATS_GET_NAMES: {
> +		struct kvm_stats_names stats_names;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&stats_names, argp, sizeof(stats_names)))
> +			goto out;
> +		r = -EINVAL;
> +		if (stats_names.size < VCPU_STAT_COUNT * KVM_STATS_NAME_LEN)
> +			goto out;
> +
> +		r = -EFAULT;
> +		if (copy_to_user(argp + sizeof(stats_names),
> +				kvm_vcpu_stat_strings,
> +				VCPU_STAT_COUNT * KVM_STATS_NAME_LEN))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	case KVM_STATS_GET_DATA: {
> +		struct kvm_stats_data stats_data;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&stats_data, argp, sizeof(stats_data)))
> +			goto out;
> +		r = -EINVAL;
> +		if (stats_data.size < sizeof(vcpu->stat))
> +			goto out;
> +
> +		r = -EFAULT;
> +		argp += sizeof(stats_data);
> +		if (copy_to_user(argp, &vcpu->stat, sizeof(vcpu->stat)))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
>  	default:
>  		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
>  	}
> @@ -3695,6 +3740,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  	case KVM_CAP_CHECK_EXTENSION_VM:
>  	case KVM_CAP_ENABLE_CAP_VM:
>  	case KVM_CAP_HALT_POLL:
> +	case KVM_CAP_STATS_BINARY_FORM:
>  		return 1;
>  #ifdef CONFIG_KVM_MMIO
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -3825,6 +3871,40 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  	}
>  }
>  
> +static long kvm_vm_ioctl_stats_get_data(struct kvm *kvm, unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_stats_data stats_data;
> +	u64 *data = NULL, *pdata;
> +	int i, j, ret = 0;
> +	size_t dsize = (VM_STAT_COUNT + VCPU_STAT_COUNT) * sizeof(*data);
> +
> +
> +	if (copy_from_user(&stats_data, argp, sizeof(stats_data)))
> +		return -EFAULT;
> +	if (stats_data.size < dsize)
> +		return -EINVAL;
> +	data = kzalloc(dsize, GFP_KERNEL_ACCOUNT);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < VM_STAT_COUNT; i++)
> +		*(data + i) = *((ulong *)&kvm->stat + i);

This kind of dance could be avoided if your stats were just an array,
or a union of the current data structure and an array.

> +
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		pdata = data + VM_STAT_COUNT;
> +		for (i = 0; i < VCPU_STAT_COUNT; i++, pdata++)
> +			*pdata += *((u64 *)&vcpu->stat + i);

Do you really need the in-kernel copy? Why not directly organise the
data structures in a way that would allow a bulk copy using
copy_to_user()?

Another thing is the atomicity of what you are reporting. Don't you
care about the consistency of the counters?

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.
