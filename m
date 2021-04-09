Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9230A35985F
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Apr 2021 10:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhDII4C (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Apr 2021 04:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhDII4B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Apr 2021 04:56:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B67EC061760
        for <kvm-ppc@vger.kernel.org>; Fri,  9 Apr 2021 01:55:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso4633666pji.3
        for <kvm-ppc@vger.kernel.org>; Fri, 09 Apr 2021 01:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sUXvc9Rs3BvgA6UTa+HqSXYPjHmcn5VWnyRnzMqQMmE=;
        b=oZItCmWw+MBNReqY1G/WrJsMfBMkDwacOpfFsqD3veqEvDyXq8IWnnF0CQtunrq74v
         As33ZdCZtLLAaHh9K/uQWl71r7BFhhlqmSkn9WA800hDsr1u0VJqdeXx4xdounTQ4fHm
         w+os5h0QW7BuAxd3fD1KP+FoSHoXqVBT5CTAohFAAkvN9oJZZvEhWOOL/YBLqR+QBe06
         ekR+nQMAhhlILWqPtGzIr98X48AATxzfxSWvnRTa2jYCniRRNa7KHfwmNzRC+ITWqDjE
         NdgByNmRa6kznXdqDl+lxgNkI+iRS7zADplWL8RHV2IssrhdmU8wUBRebxWNjVMdA4tk
         ucfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sUXvc9Rs3BvgA6UTa+HqSXYPjHmcn5VWnyRnzMqQMmE=;
        b=caO5OWCSYHGmb4M7E19c1JRgtkZRD62FPVUxxsHfncFDrsQ+mAI6Zoy62lVd5ur3pu
         BSwYHrNF2HMbEed83q0BZgffu/Q7ejtDYyItGFiqTUwKm0MCQPBvsnMTe1vE/tCOm0Sq
         acVhlI4w9KURmziTD70xpoSs8VrfhsHU72Pv5mOG8LjSOQ+iQC6JE1exKp9R6Tuf/gVH
         xC+dHmUA16kSz3bVIeGWKh0RcTgR+j7RRqIXDGoyFZ1uDTOxKXrX19SRLTdiRtucYtR4
         /IJAGkTnH4kySDalx9xerUU2u1mxwjyitmlKIqYggu1SIqtD9YqMpm7VfbQay5z8Zglk
         2GrQ==
X-Gm-Message-State: AOAM532r6JKGI70BDmj52/Yj1u+m1ocFnZyzod6HtRg+Kl1/Kb3rUUyO
        NQx5eP6fo4+QOUujgZBpBC3tLQ==
X-Google-Smtp-Source: ABdhPJyksiZnIhycx8d/niDb7rEL5vmS3lHv4pGIUyaBlWc4I7o4JDG13Y7qtSETQD01+QOc/zb8Nw==
X-Received: by 2002:a17:90a:eacf:: with SMTP id ev15mr12378416pjb.130.1617958548856;
        Fri, 09 Apr 2021 01:55:48 -0700 (PDT)
Received: from localhost (ppp121-45-194-51.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.194.51])
        by smtp.gmail.com with UTF8SMTPSA id m9sm1887390pgt.65.2021.04.09.01.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 01:55:48 -0700 (PDT)
Message-ID: <0adc89d0-c765-d11b-ffe4-cbbf2f8f9c49@ozlabs.ru>
Date:   Fri, 9 Apr 2021 18:55:44 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:88.0) Gecko/20100101
 Thunderbird/88.0
Subject: Re: [PATCH v6 32/48] KVM: PPC: Book3S HV P9: Read machine check
 registers while MSR[RI] is 0
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
 <20210405011948.675354-33-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210405011948.675354-33-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 05/04/2021 11:19, Nicholas Piggin wrote:
> SRR0/1, DAR, DSISR must all be protected from machine check which can
> clobber them. Ensure MSR[RI] is clear while they are live.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arch/powerpc/kvm/book3s_hv.c           | 11 +++++++--
>   arch/powerpc/kvm/book3s_hv_interrupt.c | 33 +++++++++++++++++++++++---
>   arch/powerpc/kvm/book3s_hv_ras.c       |  2 ++
>   3 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index d6eecedaa5a5..5f0ac6567a06 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3567,11 +3567,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   	mtspr(SPRN_BESCR, vcpu->arch.bescr);
>   	mtspr(SPRN_WORT, vcpu->arch.wort);
>   	mtspr(SPRN_TIDR, vcpu->arch.tid);
> -	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
> -	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
>   	mtspr(SPRN_AMR, vcpu->arch.amr);
>   	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
>   
> +	/*
> +	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
> +	 * clear (or hstate set appropriately to catch those registers
> +	 * being clobbered if we take a MCE or SRESET), so those are done
> +	 * later.
> +	 */
> +
>   	if (!(vcpu->arch.ctrl & 1))
>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>   
> @@ -3614,6 +3619,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   			hvregs.vcpu_token = vcpu->vcpu_id;
>   		}
>   		hvregs.hdec_expiry = time_limit;
> +		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
> +		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
>   		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
>   					  __pa(&vcpu->arch.regs));
>   		kvmhv_restore_hv_return_state(vcpu, &hvregs);
> diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
> index 6fdd93936e16..e93d2a6456ff 100644
> --- a/arch/powerpc/kvm/book3s_hv_interrupt.c
> +++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
> @@ -132,6 +132,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   	s64 hdec;
>   	u64 tb, purr, spurr;
>   	u64 *exsave;
> +	bool ri_set;
>   	unsigned long msr = mfmsr();
>   	int trap;
>   	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
> @@ -203,9 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   	 */
>   	mtspr(SPRN_HDEC, hdec);
>   
> -	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
> -	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
> -
>   	start_timing(vcpu, &vcpu->arch.rm_entry);
>   
>   	vcpu->arch.ceded = 0;
> @@ -231,6 +229,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   	 */
>   	mtspr(SPRN_HDSISR, HDSISR_CANARY);
>   
> +	__mtmsrd(0, 1); /* clear RI */
> +
> +	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
> +	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
> +	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
> +	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
> +
>   	accumulate_time(vcpu, &vcpu->arch.guest_time);
>   
>   	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
> @@ -248,7 +253,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   
>   	/* 0x2 bit for HSRR is only used by PR and P7/8 HV paths, clear it */
>   	trap = local_paca->kvm_hstate.scratch0 & ~0x2;
> +
> +	/* HSRR interrupts leave MSR[RI] unchanged, SRR interrupts clear it. */
> +	ri_set = false;
>   	if (likely(trap > BOOK3S_INTERRUPT_MACHINE_CHECK)) {
> +		if (trap != BOOK3S_INTERRUPT_SYSCALL &&
> +				(vcpu->arch.shregs.msr & MSR_RI))
> +			ri_set = true;
>   		exsave = local_paca->exgen;
>   	} else if (trap == BOOK3S_INTERRUPT_SYSTEM_RESET) {
>   		exsave = local_paca->exnmi;
> @@ -258,6 +269,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   
>   	vcpu->arch.regs.gpr[1] = local_paca->kvm_hstate.scratch1;
>   	vcpu->arch.regs.gpr[3] = local_paca->kvm_hstate.scratch2;
> +
> +	/*
> +	 * Only set RI after reading machine check regs (DAR, DSISR, SRR0/1)
> +	 * and hstate scratch (which we need to move into exsave to make
> +	 * re-entrant vs SRESET/MCE)
> +	 */
> +	if (ri_set) {
> +		if (unlikely(!(mfmsr() & MSR_RI))) {
> +			__mtmsrd(MSR_RI, 1);
> +			WARN_ON_ONCE(1);
> +		}
> +	} else {
> +		WARN_ON_ONCE(mfmsr() & MSR_RI);
> +		__mtmsrd(MSR_RI, 1);
> +	}
> +
>   	vcpu->arch.regs.gpr[9] = exsave[EX_R9/sizeof(u64)];
>   	vcpu->arch.regs.gpr[10] = exsave[EX_R10/sizeof(u64)];
>   	vcpu->arch.regs.gpr[11] = exsave[EX_R11/sizeof(u64)];
> diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
> index d4bca93b79f6..8d8a4d5f0b55 100644
> --- a/arch/powerpc/kvm/book3s_hv_ras.c
> +++ b/arch/powerpc/kvm/book3s_hv_ras.c
> @@ -199,6 +199,8 @@ static void kvmppc_tb_resync_done(void)
>    * know about the exact state of the TB value. Resync TB call will
>    * restore TB to host timebase.
>    *
> + * This could use the new OPAL_HANDLE_HMI2 to avoid resyncing TB every time.


Educating myself - is it because OPAL_HANDLE_HMI2 tells if it is TB/TOD 
which is the problem so we can avoid calling opal_resync_timebase() if 
it is not TB? OPAL_HANDLE_HMI2 does not seem to resync TB itself. The 
comment just does not seem related to the rest of the patch.

Otherwise, looks good.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> + *
>    * Things to consider:
>    * - On TB error, HMI interrupt is reported on all the threads of the core
>    *   that has encountered TB error irrespective of split-core mode.
> 

-- 
Alexey
