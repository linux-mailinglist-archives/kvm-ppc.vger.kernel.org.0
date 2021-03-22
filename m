Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C993437E4
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 05:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhCVEYl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 00:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCVEYh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 00:24:37 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C474C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 21:24:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 32so1664170pgm.1
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 21:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Jk/UWUBTuek25gcQf24w6j3TceVnzQwrN0sozkH+Waw=;
        b=uL11HUWQs1TG7BouVaWfuk5JJw8rnibWEaFol58YX68TGaw87bg0xtmsLs+vpt9SZE
         g54JAaEnJY83sx6dZ9oWXsSUunCZxJF9UFQLIpyqaTO0Gwy56YhwSCiQgdUZqvqSX/5U
         HkYqD4WJ+ggNIC0/w+WEzYRSX9YQGblhUINRlOMxVjWe9esyL3tdB6XZEs9MSZn1N543
         ne6MN0ccvmNzFEsmY2ej5NoLEZkZOmCxnK2MX4xiu2YquyCwyYAsQ9HbwC1fYBsmMj2t
         teHIO7aPYVv6apfJnQhWfXW0wgFFxvST5FkNHC/zptDZr7RtRZt96A1l91Go2+ahpS+p
         d8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Jk/UWUBTuek25gcQf24w6j3TceVnzQwrN0sozkH+Waw=;
        b=IKZ6QCehy7rqTqNK19Oh4ubG1U0OkKxGFS+jWXzoToAbpItG2NE5a6KindGeHgUsHR
         9RzbnhjXd1EKw1Rt48ysrWqO1YSdQeTWyaFpfCZdiGNSy1wv2pISQhYIRExOb6AzOQTp
         eMe7VeRogZQyuudlqOky2oUk/T7LyeUPqCF87XJKbmmJFGzwMLuKlx4huKS9rSTv3ws4
         yep7qHoxj9Ei8N7OJXXenhefLzGX8Fv3GVz+y3xIhmS0hBu4TT3sIAuDgVIKJmCBmV2o
         FsZZhb4K0g9kHszXwujFt6xVCTNyXc2xzlAevFlteFEwO7sgv1O6UhQ//RO0uBy6EuEt
         ZU+Q==
X-Gm-Message-State: AOAM532UR0g5ayDDIOUnppkbpqstHvX0//jD3KmDl2KoT2FOq+j0+Hot
        yvov+12Ak1bBzKdvAUONN5OIjg==
X-Google-Smtp-Source: ABdhPJzlm+eN9ZsqQHWRsgkUDD4D61FDKWnpkvNXnM4754KsmWa40BR5F/hzUFntII4amj99IIWjyg==
X-Received: by 2002:a63:db10:: with SMTP id e16mr21370248pgg.234.1616387076755;
        Sun, 21 Mar 2021 21:24:36 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id g7sm10412878pgb.10.2021.03.21.21.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 21:24:36 -0700 (PDT)
Message-ID: <47284fdd-51ef-5ba7-487b-dfb46ec2816e@ozlabs.ru>
Date:   Mon, 22 Mar 2021 15:24:32 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 16/41] KVM: PPC: Book3S HV P9: Move radix MMU switching
 instructions together
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-17-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-17-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> Switching the MMU from radix<->radix mode is tricky particularly as the
> MMU can remain enabled and requires a certain sequence of SPR updates.
> Move these together into their own functions.
> 
> This also includes the radix TLB check / flush because it's tied in to
> MMU switching due to tlbiel getting LPID from LPIDR.
> 
> (XXX: isync / hwsync synchronisation TBD)


Looks alright but what is this comment about? Is something missing or 
just sub optimal?


> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>


> ---
>   arch/powerpc/kvm/book3s_hv.c | 55 +++++++++++++++++++++---------------
>   1 file changed, 32 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index f1230f9d98ba..b9cae42b9cd5 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3449,12 +3449,38 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>   	trace_kvmppc_run_core(vc, 1);
>   }
>   
> +static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
> +{
> +	struct kvmppc_vcore *vc = vcpu->arch.vcore;
> +	struct kvm_nested_guest *nested = vcpu->arch.nested;
> +	u32 lpid;
> +
> +	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
> +
> +	mtspr(SPRN_LPID, lpid);
> +	mtspr(SPRN_LPCR, lpcr);
> +	mtspr(SPRN_PID, vcpu->arch.pid);
> +	isync();
> +
> +	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
> +	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
> +}
> +
> +static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
> +{
> +	mtspr(SPRN_PID, pid);
> +	mtspr(SPRN_LPID, kvm->arch.host_lpid);
> +	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
> +	isync();
> +}
> +
>   /*
>    * Load up hypervisor-mode registers on P9.
>    */
>   static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   				     unsigned long lpcr)
>   {
> +	struct kvm *kvm = vcpu->kvm;
>   	struct kvmppc_vcore *vc = vcpu->arch.vcore;
>   	s64 hdec;
>   	u64 tb, purr, spurr;
> @@ -3477,12 +3503,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
>   	 * so set HDICE before writing HDEC.
>   	 */
> -	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
> +	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
>   	isync();
>   
>   	hdec = time_limit - mftb();
>   	if (hdec < 0) {
> -		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
> +		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
>   		isync();
>   		return BOOK3S_INTERRUPT_HV_DECREMENTER;
>   	}
> @@ -3517,7 +3543,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   	}
>   	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
>   	mtspr(SPRN_IC, vcpu->arch.ic);
> -	mtspr(SPRN_PID, vcpu->arch.pid);
>   
>   	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
>   	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
> @@ -3531,8 +3556,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	mtspr(SPRN_AMOR, ~0UL);
>   
> -	mtspr(SPRN_LPCR, lpcr);
> -	isync();
> +	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>   
>   	kvmppc_xive_push_vcpu(vcpu);
>   
> @@ -3571,7 +3595,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   		mtspr(SPRN_DAWR1, host_dawr1);
>   		mtspr(SPRN_DAWRX1, host_dawrx1);
>   	}
> -	mtspr(SPRN_PID, host_pidr);
>   
>   	/*
>   	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
> @@ -3586,9 +3609,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   	if (cpu_has_feature(CPU_FTR_ARCH_31))
>   		asm volatile(PPC_CP_ABORT);
>   
> -	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
> -	isync();
> -
>   	vc->dpdes = mfspr(SPRN_DPDES);
>   	vc->vtb = mfspr(SPRN_VTB);
>   	mtspr(SPRN_DPDES, 0);
> @@ -3605,7 +3625,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   	}
>   
>   	mtspr(SPRN_HDEC, 0x7fffffff);
> -	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
> +
> +	switch_mmu_to_host_radix(kvm, host_pidr);
>   
>   	return trap;
>   }
> @@ -4138,7 +4159,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>   {
>   	struct kvm_run *run = vcpu->run;
>   	int trap, r, pcpu;
> -	int srcu_idx, lpid;
> +	int srcu_idx;
>   	struct kvmppc_vcore *vc;
>   	struct kvm *kvm = vcpu->kvm;
>   	struct kvm_nested_guest *nested = vcpu->arch.nested;
> @@ -4212,13 +4233,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>   	vc->vcore_state = VCORE_RUNNING;
>   	trace_kvmppc_run_core(vc, 0);
>   
> -	if (cpu_has_feature(CPU_FTR_HVMODE)) {


The new location of mtspr(SPRN_LPID, lpid) does not check for 
CPU_FTR_HVMODE anymore, is this going to work with HV KVM on pseries? 
Thanks,




> -		lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
> -		mtspr(SPRN_LPID, lpid);
> -		isync();
> -		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
> -	}
> -
>   	guest_enter_irqoff();
>   
>   	srcu_idx = srcu_read_lock(&kvm->srcu);
> @@ -4237,11 +4251,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	srcu_read_unlock(&kvm->srcu, srcu_idx);
>   
> -	if (cpu_has_feature(CPU_FTR_HVMODE)) {
> -		mtspr(SPRN_LPID, kvm->arch.host_lpid);
> -		isync();
> -	}
> -
>   	set_irq_happened(trap);
>   
>   	kvmppc_set_host_core(pcpu);
> 

-- 
Alexey
