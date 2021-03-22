Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D43E34395A
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 07:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCVGWN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 02:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhCVGVr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 02:21:47 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A476C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 23:21:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ay2so5995664plb.3
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 23:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g0SJwkBamDFIg0whiCIvc0w+UZR9SjzysVz6onFjuEM=;
        b=Ytfi2/G8i8tgGuh2uVqVGkAbHUY4iGxGTEfPYQZ7eMG+GbPmpipy5eTc8V3xFEDAiF
         ZgqVGViobQQidlGJ4QI1m/qADie38IZRchmFeueYiywM+Q+NU/sNbhMYM0spKJYmfbsn
         rW/gqyuEdiwK9dZKVYLwZ6CwracumncQQ6UHSOfIkCDTjtNvMPXk+OIu1q1otymlNe/R
         FkEWG98/nJ4KCjsPmtxv58+aappN2j4PaTS9afevVG/08cpQkSbreI1QhydKBkyPjXeA
         vQ8QtQSaSj6vV/KBUxuChczkBuCCAAORRvN3+nwmI3QTwD9oEIiIgX/fZA+21k6OdU4S
         945w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g0SJwkBamDFIg0whiCIvc0w+UZR9SjzysVz6onFjuEM=;
        b=Si5iyMtQo82Tjzcd+3W85m0ABF8VrQw/vfajPxG4+sL+A0gzyrpIxiT4Ddh2xahTFl
         5KBs3MAzmt8tP5cUuwpTZ2K11omx5a/k39jcGYVteTDTWAfXXenDD2QrOlHkBFUISoqR
         1pF6UDfM9S1ltd0k3xfbXnRUuVAFShgLPajJi+Tj6xG0BttxBobvCFsgJwene1LGTWVs
         1fj/XwcrtPXSGYAW9IYjNBVUfb6YfvaOawZUQfQSIiPc/fI5o5rggOaJwV9tUIBEW2UE
         ccn5L2BgEQQ1WQ7CaS6H+ACU8Rc4oaD/Ybk9C7tXsuxQ/JdRcdy1KFpPT2H8e7GmlPRW
         xYjg==
X-Gm-Message-State: AOAM530MJctTncMeDgTN+SA330Zz9UMcn582uI4AZjnfzTppJ5BngBFE
        +IH9tXWl92JCFOV8n3UAp6PzNA==
X-Google-Smtp-Source: ABdhPJwzOrpJo7FYCS3ekcCy5pWvbE492WBkIuFyBnWv3J0CXwYA+CiUe+SUBGBYfHJnqvKpDUjO1g==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr11985141pjx.181.1616394107064;
        Sun, 21 Mar 2021 23:21:47 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id v2sm12260160pjg.34.2021.03.21.23.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 23:21:46 -0700 (PDT)
Message-ID: <d98b5556-8b34-cf81-1031-a28197444fdd@ozlabs.ru>
Date:   Mon, 22 Mar 2021 17:21:42 +1100
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
 <47284fdd-51ef-5ba7-487b-dfb46ec2816e@ozlabs.ru>
 <1616390221.1zx2axnuhk.astroid@bobo.none>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <1616390221.1zx2axnuhk.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 22/03/2021 16:25, Nicholas Piggin wrote:
> Excerpts from Alexey Kardashevskiy's message of March 22, 2021 2:24 pm:
>>
>>
>> On 06/03/2021 02:06, Nicholas Piggin wrote:
>>> Switching the MMU from radix<->radix mode is tricky particularly as the
>>> MMU can remain enabled and requires a certain sequence of SPR updates.
>>> Move these together into their own functions.
>>>
>>> This also includes the radix TLB check / flush because it's tied in to
>>> MMU switching due to tlbiel getting LPID from LPIDR.
>>>
>>> (XXX: isync / hwsync synchronisation TBD)
>>
>>
>> Looks alright but what is this comment about? Is something missing or
>> just sub optimal?
> 
> Ah, yeah the architecture says for example a CSI is required before +
> after each, but the fine print is that you only need those to separate
> between previous or subsequent accesses that may use those contexts
> being switched from/to.
> 
> Then there is the question of CSI between the instructions so e.g., you
> don't get the TLB prefetch bug if the mtPIDR could go out of order ahead
> of the mtLPIDR, but those instructions are serialized so they wouldn't.
> 
> There's possibly a few clarifications coming to the architecture around
> this as well.
> 
> I think things are relatively okay but probably need a bit more
> commenting to justify where the isyncs() aren't. It's possible we might
> be able to even remove the isyncs that are there.
> 
> Making a like-for-like conversion is a bit tricky because there are
> possible context synchronising instructions between them already.
> 
> Maybe for the first series, I'll just put an isync between all of them,
> and then a later patch can replace some of them with comments.
> 
>>
>>
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>
>>
>>> ---
>>>    arch/powerpc/kvm/book3s_hv.c | 55 +++++++++++++++++++++---------------
>>>    1 file changed, 32 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>> index f1230f9d98ba..b9cae42b9cd5 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -3449,12 +3449,38 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>>>    	trace_kvmppc_run_core(vc, 1);
>>>    }
>>>    
>>> +static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
>>> +{
>>> +	struct kvmppc_vcore *vc = vcpu->arch.vcore;
>>> +	struct kvm_nested_guest *nested = vcpu->arch.nested;
>>> +	u32 lpid;
>>> +
>>> +	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
>>> +
>>> +	mtspr(SPRN_LPID, lpid);
>>> +	mtspr(SPRN_LPCR, lpcr);
>>> +	mtspr(SPRN_PID, vcpu->arch.pid);
>>> +	isync();
>>> +
>>> +	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
>>> +	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
>>> +}
>>> +
>>> +static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
>>> +{
>>> +	mtspr(SPRN_PID, pid);
>>> +	mtspr(SPRN_LPID, kvm->arch.host_lpid);
>>> +	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
>>> +	isync();
>>> +}
>>> +
>>>    /*
>>>     * Load up hypervisor-mode registers on P9.
>>>     */
>>>    static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    				     unsigned long lpcr)
>>>    {
>>> +	struct kvm *kvm = vcpu->kvm;
>>>    	struct kvmppc_vcore *vc = vcpu->arch.vcore;
>>>    	s64 hdec;
>>>    	u64 tb, purr, spurr;
>>> @@ -3477,12 +3503,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
>>>    	 * so set HDICE before writing HDEC.
>>>    	 */
>>> -	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
>>> +	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
>>>    	isync();
>>>    
>>>    	hdec = time_limit - mftb();
>>>    	if (hdec < 0) {
>>> -		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
>>> +		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
>>>    		isync();
>>>    		return BOOK3S_INTERRUPT_HV_DECREMENTER;
>>>    	}
>>> @@ -3517,7 +3543,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    	}
>>>    	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
>>>    	mtspr(SPRN_IC, vcpu->arch.ic);
>>> -	mtspr(SPRN_PID, vcpu->arch.pid);
>>>    
>>>    	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
>>>    	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
>>> @@ -3531,8 +3556,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    
>>>    	mtspr(SPRN_AMOR, ~0UL);
>>>    
>>> -	mtspr(SPRN_LPCR, lpcr);
>>> -	isync();
>>> +	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>>>    
>>>    	kvmppc_xive_push_vcpu(vcpu);
>>>    
>>> @@ -3571,7 +3595,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    		mtspr(SPRN_DAWR1, host_dawr1);
>>>    		mtspr(SPRN_DAWRX1, host_dawrx1);
>>>    	}
>>> -	mtspr(SPRN_PID, host_pidr);
>>>    
>>>    	/*
>>>    	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
>>> @@ -3586,9 +3609,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    	if (cpu_has_feature(CPU_FTR_ARCH_31))
>>>    		asm volatile(PPC_CP_ABORT);
>>>    
>>> -	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
>>> -	isync();
>>> -
>>>    	vc->dpdes = mfspr(SPRN_DPDES);
>>>    	vc->vtb = mfspr(SPRN_VTB);
>>>    	mtspr(SPRN_DPDES, 0);
>>> @@ -3605,7 +3625,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    	}
>>>    
>>>    	mtspr(SPRN_HDEC, 0x7fffffff);
>>> -	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
>>> +
>>> +	switch_mmu_to_host_radix(kvm, host_pidr);
>>>    
>>>    	return trap;
>>>    }
>>> @@ -4138,7 +4159,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    {
>>>    	struct kvm_run *run = vcpu->run;
>>>    	int trap, r, pcpu;
>>> -	int srcu_idx, lpid;
>>> +	int srcu_idx;
>>>    	struct kvmppc_vcore *vc;
>>>    	struct kvm *kvm = vcpu->kvm;
>>>    	struct kvm_nested_guest *nested = vcpu->arch.nested;
>>> @@ -4212,13 +4233,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>>    	vc->vcore_state = VCORE_RUNNING;
>>>    	trace_kvmppc_run_core(vc, 0);
>>>    
>>> -	if (cpu_has_feature(CPU_FTR_HVMODE)) {
>>
>>
>> The new location of mtspr(SPRN_LPID, lpid) does not check for
>> CPU_FTR_HVMODE anymore, is this going to work with HV KVM on pseries?
> 
> Yes, these are moved to HVMODE specific code now.

ah right, kvmhv_on_pseries() is !cpu_has_feature(CPU_FTR_HVMODE).


Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


-- 
Alexey
