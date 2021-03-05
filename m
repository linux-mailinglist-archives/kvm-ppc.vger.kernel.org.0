Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B133932E27B
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 07:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCEGsL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 01:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCEGsL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 01:48:11 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD99C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 22:48:11 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p21so710928pgl.12
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 22:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=F/qIU3IVSwnnhwoxv/S8JOpC9tqjeNus66Z68JkhNVs=;
        b=fnoBYN2i3hfuntuqeKOzbav0DqrHVOiQO/3vVCS1UOygE1ibRQXOKEgpd+2UYtaPbq
         Wc08puCItQsrHTHxnV/DIopaOKT2qzbSFRFX/Xa/zI1JqAr0Xvz6v5tquPDaByZKjNVi
         LhScXhC9jZm+jE0e90EKaSHqD5Xfyn1jn593s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F/qIU3IVSwnnhwoxv/S8JOpC9tqjeNus66Z68JkhNVs=;
        b=NshkPsNlwTHPADXCQhUIJ+E9AqNcHM2+CHIZIpJ5aKWbXIwTUCUa1OqSK61JdMcj0b
         8fuvc38DZ487he3NKvFt5zYV51fsbO1uOt5Q9CxH1tTd8+owVlkHtLkMc8DmJCULAejA
         5pgHYMwiLsSSzwNtG++fqivl/+QCux1IUya+iO1Z6cytrnwDbwD65bZLcUHmXlTGbnky
         QvKUhTxgqywidLLz00Q/kXo983SvbmNbGDjG3eKtRMNLtUsnRHkSHvztsF60JAGfH7oE
         2PaIRSquB0eQ0BVllmmLfcFunLqcUet6BTPJPxE/8oILWhIvfoHybggxiJGQpSwjO4i5
         NUCQ==
X-Gm-Message-State: AOAM531cuXUDukuF9IFFCa8QL60Gc8umyerEzFhUm9wYS9Mv1HrbctIJ
        Bnf3PdLcLbgH7Vs4mtuvhs0FDw==
X-Google-Smtp-Source: ABdhPJzMm4yOQ9+/nRdrJDidJj+rlT7dVotAw+MONYti662kDRf6XgZddV3hl4g2VN6SKNV0iGkqQQ==
X-Received: by 2002:aa7:88c3:0:b029:1ed:f702:7230 with SMTP id k3-20020aa788c30000b02901edf7027230mr7755503pff.76.1614926890875;
        Thu, 04 Mar 2021 22:48:10 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id u2sm1158316pjy.14.2021.03.04.22.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 22:48:10 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 09/37] KVM: PPC: Book3S 64: Move hcall early register setup to KVM
In-Reply-To: <20210225134652.2127648-10-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-10-npiggin@gmail.com>
Date:   Fri, 05 Mar 2021 17:48:07 +1100
Message-ID: <87im6685aw.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> System calls / hcalls have a different calling convention than
> other interrupts, so there is code in the KVMTEST to massage these
> into the same form as other interrupt handlers.
>
> Move this work into the KVM hcall handler. This means teaching KVM
> a little more about the low level interrupt handler setup, PACA save
> areas, etc., although that's not obviously worse than the current
> approach of coming up with an entirely different interrupt register
> / save convention.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/exception-64s.h | 13 +++++++
>  arch/powerpc/kernel/exceptions-64s.S     | 44 ++----------------------
>  arch/powerpc/kvm/book3s_64_entry.S       | 17 +++++++++
>  3 files changed, 32 insertions(+), 42 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
> index c1a8aac01cf9..bb6f78fcf981 100644
> --- a/arch/powerpc/include/asm/exception-64s.h
> +++ b/arch/powerpc/include/asm/exception-64s.h
> @@ -35,6 +35,19 @@
>  /* PACA save area size in u64 units (exgen, exmc, etc) */
>  #define EX_SIZE		10
>  
> +/* PACA save area offsets */
> +#define EX_R9		0
> +#define EX_R10		8
> +#define EX_R11		16
> +#define EX_R12		24
> +#define EX_R13		32
> +#define EX_DAR		40
> +#define EX_DSISR	48
> +#define EX_CCR		52
> +#define EX_CFAR		56
> +#define EX_PPR		64
> +#define EX_CTR		72

I wonder - now that EX_blah and EX_SIZE both live in the one header
file, if we could calculate EX_SIZE based on the last offset... or have
a BUILD_BUG_ON or something? ... just trying not to lose the sanity
checking afforded to us by the .if macro we lose when moving these out
of exceptions-64s.S...

> +
>  /*
>   * maximum recursive depth of MCE exceptions
>   */
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 9ae463e8522b..b7092ba87da8 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -21,22 +21,6 @@
>  #include <asm/feature-fixups.h>
>  #include <asm/kup.h>
>  
> -/* PACA save area offsets (exgen, exmc, etc) */
> -#define EX_R9		0
> -#define EX_R10		8
> -#define EX_R11		16
> -#define EX_R12		24
> -#define EX_R13		32
> -#define EX_DAR		40
> -#define EX_DSISR	48
> -#define EX_CCR		52
> -#define EX_CFAR		56
> -#define EX_PPR		64
> -#define EX_CTR		72
> -.if EX_SIZE != 10
> -	.error "EX_SIZE is wrong"
> -.endif
> -
>  /*
>   * Following are fixed section helper macros.
>   *
> @@ -1964,45 +1948,21 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
>  
>  #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
>  TRAMP_REAL_BEGIN(system_call_kvm)
> -	/*
> -	 * This is a hcall, so register convention is as above, with these
> -	 * differences:
> -	 * r13 = PACA
> -	 * ctr = orig r13
> -	 * orig r10 saved in PACA
> -	 */
> -	 /*
> -	  * Save the PPR (on systems that support it) before changing to
> -	  * HMT_MEDIUM. That allows the KVM code to save that value into the
> -	  * guest state (it is the guest's PPR value).
> -	  */
> -BEGIN_FTR_SECTION
> -	mfspr	r10,SPRN_PPR
> -	std	r10,HSTATE_PPR(r13)
> -END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
> -	HMT_MEDIUM
>  	mfctr	r10
> -	SET_SCRATCH0(r10)
> -	mfcr	r10
> -	std	r12,HSTATE_SCRATCH0(r13)
> -	sldi	r12,r10,32
> -	ori	r12,r12,0xc00
> +	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
>  #ifdef CONFIG_RELOCATABLE
>  	/*
> -	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
> +	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives

That change probably belongs in the previous patch :)

Beyond that, I'm still wrapping my head around the deep magic going on
here! Hopefully I'll get a bit a bit further next time I look.

Kind regards,
Daniel

>  	 * outside the head section.
>  	 */
>  	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
>  	mtctr   r10
> -	ld	r10,PACA_EXGEN+EX_R10(r13)
>  	bctr
>  #else
> -	ld	r10,PACA_EXGEN+EX_R10(r13)
>  	b       kvmppc_hcall
>  #endif
>  #endif
>  
> -
>  /**
>   * Interrupt 0xd00 - Trace Interrupt.
>   * This is a synchronous interrupt in response to instruction step or
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index 9572f759255c..1c9518ab7d96 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -13,6 +13,23 @@
>  .global	kvmppc_hcall
>  .balign IFETCH_ALIGN_BYTES
>  kvmppc_hcall:
> +	/*
> +	 * This is a hcall, so register convention is as
> +	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
> +	 * R13		= PACA
> +	 * guest R13 saved in SPRN_SCRATCH0
> +	 * R10		= free
> +	 */
> +BEGIN_FTR_SECTION
> +	mfspr	r10,SPRN_PPR
> +	std	r10,HSTATE_PPR(r13)
> +END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
> +	HMT_MEDIUM
> +	mfcr	r10
> +	std	r12,HSTATE_SCRATCH0(r13)
> +	sldi	r12,r10,32
> +	ori	r12,r12,0xc00
> +	ld	r10,PACA_EXGEN+EX_R10(r13)
>  
>  .global	kvmppc_interrupt
>  .balign IFETCH_ALIGN_BYTES
> -- 
> 2.23.0
