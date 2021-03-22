Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AC0343824
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 06:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCVFGT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 01:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVFFt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 01:05:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30BBC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 22:05:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h25so7842427pgm.3
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 22:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S77D8L3UAMxKrJ/VDWFeVz077lFS1UobdDs7mqKVBSk=;
        b=xTRCZqxIWT29Q/ifOxeLDEpipdFiAjSztQeULrzSlxJog1i6sgBPIGo+Fv+moWetZk
         NO+uFG9aIy4jmliLICiFg3R6F2cDKSXJNawZ8lFXBx4CHDDhi1EiF6mtNuR6l5bsXqh1
         VzKApSVjLNX5QaERiF+rBrQWFp9ksd2cfzJuyNBcm7al7pTCyU1SdzoWTXgED3bFWW3m
         xan/ssx+9v5G5iZGd+3X6l1IK4oNfLXj9bh0dgXioTLah7Ez/ZIGt63ZK6FUWZAJpJ1X
         G8nMPIWXrk0Rim2tM+r0ah01oBNXNPTr8IDij+6ZjQzT/1D8iflCyLS8LOQVr7ojWhcR
         y+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S77D8L3UAMxKrJ/VDWFeVz077lFS1UobdDs7mqKVBSk=;
        b=pD20qarpFLdlJPRnGoJg4i3SX4qulv+03mOG0XD7mM8ImJvOzELIGpiouc8BOpF2hz
         4Fowiy4pkOks9FOKyz3Shq0Sdz85D0UXY67N8+ndBtoThhgrV6mfRPSfyY/Ci7NkTUyu
         O6UQmvTNvWXLrd1uciZ+ee4x3rYOXfwMyeYKVl183ewHZFINbn9HurVrCccfQCbnGrdS
         r9aJtl4TDZCtek3WAnEcJMH6b9Zo+/TCPZa02HqW3QUab21jbJi1tSNkrrGPzyDG8Fk0
         FtiMkH5mdrt6bUwwK5L4TL5+P/YWzrBBVmr8BTykCFKKoOyAdectFbCYkjFAvNP9NdL6
         Flhg==
X-Gm-Message-State: AOAM5310OS91K/qixpAwHjcpR7CLBNqdkV9H4Whmz9SK7H3Fgl5SSLHB
        7WLGuZrW2mD3kYBjD/tQ/Y2Cnw==
X-Google-Smtp-Source: ABdhPJwLFCn0agpknpQILBQYMVj9nrwhgNHv5KoZUrYCu/LyqL7rEPcx3qw1H4HO3NrHaJvU/vRaBA==
X-Received: by 2002:a62:8c05:0:b029:1d8:7f36:bcd8 with SMTP id m5-20020a628c050000b02901d87f36bcd8mr20070184pfd.43.1616389548091;
        Sun, 21 Mar 2021 22:05:48 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id gm9sm11836511pjb.13.2021.03.21.22.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 22:05:47 -0700 (PDT)
Message-ID: <6316c619-1ba8-f8fa-3e30-95f3182505d5@ozlabs.ru>
Date:   Mon, 22 Mar 2021 16:05:44 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 17/41] KVM: PPC: Book3S HV P9: implement
 kvmppc_xive_pull_vcpu in C
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-18-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-18-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> This is more symmetric with kvmppc_xive_push_vcpu. The extra test in
> the asm will go away in a later change.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arch/powerpc/include/asm/kvm_ppc.h      |  2 ++
>   arch/powerpc/kvm/book3s_hv.c            |  2 ++
>   arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 ++++
>   arch/powerpc/kvm/book3s_xive.c          | 31 +++++++++++++++++++++++++
>   4 files changed, 40 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 9531b1c1b190..73b1ca5a6471 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -672,6 +672,7 @@ extern int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
>   extern int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
>   			       int level, bool line_status);
>   extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
> +extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
>   
>   static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>   {
> @@ -712,6 +713,7 @@ static inline int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval) { retur
>   static inline int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
>   				      int level, bool line_status) { return -ENODEV; }
>   static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
> +static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
>   
>   static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
>   	{ return 0; }
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index b9cae42b9cd5..b265522fc467 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3565,6 +3565,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	trap = __kvmhv_vcpu_entry_p9(vcpu);
>   
> +	kvmppc_xive_pull_vcpu(vcpu);
> +
>   	/* Advance host PURR/SPURR by the amount used by guest */
>   	purr = mfspr(SPRN_PURR);
>   	spurr = mfspr(SPRN_SPURR);
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 75405ef53238..c11597f815e4 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1442,6 +1442,11 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
>   	bl	kvmhv_accumulate_time
>   #endif
>   #ifdef CONFIG_KVM_XICS
> +	/* If we came in through the P9 short path, xive pull is done in C */
> +	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
> +	cmpwi	r0, 0
> +	bne	1f
> +
>   	/* We are exiting, pull the VP from the XIVE */
>   	lbz	r0, VCPU_XIVE_PUSHED(r9)
>   	cmpwi	cr0, r0, 0
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index e7219b6f5f9a..52cdb9e2660a 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -127,6 +127,37 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvmppc_xive_push_vcpu);
>   
> +/*
> + * Pull a vcpu's context from the XIVE on guest exit.
> + * This assumes we are in virtual mode (MMU on)
> + */
> +void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
> +
> +	if (!vcpu->arch.xive_pushed)
> +		return;
> +
> +	/*
> +	 * Sould not have been pushed if there is no tima


s/Sould/Should/

Otherwise good

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>



> +	 */
> +	if (WARN_ON(!tima))
> +		return;
> +
> +	eieio();
> +	/* First load to pull the context, we ignore the value */
> +	__raw_readl(tima + TM_SPC_PULL_OS_CTX);
> +	/* Second load to recover the context state (Words 0 and 1) */
> +	vcpu->arch.xive_saved_state.w01 = __raw_readq(tima + TM_QW1_OS);
> +
> +	/* Fixup some of the state for the next load */
> +	vcpu->arch.xive_saved_state.lsmfb = 0;
> +	vcpu->arch.xive_saved_state.ack = 0xff;
> +	vcpu->arch.xive_pushed = 0;
> +	eieio();
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_xive_pull_vcpu);
> +
>   /*
>    * This is a simple trigger for a generic XIVE IRQ. This must
>    * only be called for interrupts that support a trigger page
> 

-- 
Alexey
