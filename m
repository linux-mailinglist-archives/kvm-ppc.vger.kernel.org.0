Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A11D338583
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 06:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCLFp5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Mar 2021 00:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhCLFpf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Mar 2021 00:45:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFCC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 21:45:35 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t37so4351614pga.11
        for <kvm-ppc@vger.kernel.org>; Thu, 11 Mar 2021 21:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=CWxJlwGn1NuWkmPxdTVZBAxjlKIjovEumllQy9u3WWo=;
        b=WaOss1/3YHGMm1k4CmL3UsJXzH0ZlOojW6EE4DQIE0k7Jy57POASoFW0iQV7ScSP9E
         u4IfECOiTIYpM8ZG7qkxZACB2xpcO7HdLjFtDrADISphfKYEwEDMDVWGFDJxfzCL8TU5
         r276YC7TXNYCs1yvn64gPKI4SW6ilZ7XUimGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CWxJlwGn1NuWkmPxdTVZBAxjlKIjovEumllQy9u3WWo=;
        b=AbQ53l4jE0trm0VaEi3Ost8LDILdyIhw7g/dUQKeHbh07I5dJ4JMbgrUrQP9G/9rRE
         oKI7uGc7NBpAGwYC3pHyH/k/8s8SAlHiYfNx0nvWA9fb0H76O9Pl/yr31JjPpoDeZOkT
         GmURmBLGlJH/82DL2ehJcJNS3Qmb/FgjrdohCr1Q3lGgfqRrwTxDcttlG5lZbIjlyxWe
         AcfxCTzUC9C786SHRDOonPfwRR3QYyuee0nH6uctk/67Y++MyRYnJ4fMdX7QT+jmkSbi
         2VJpJo84XKmS0loCk68d1jS7OxzculIfmZ2f71TY0ZaJ1BnRhR6+WgWrqWHP9lCnLMfX
         B1KQ==
X-Gm-Message-State: AOAM533STJHSVgy1aOz5OzzPqxZ/gmAggloTk/bDoUi31DzFE+VhErjy
        wqb4bL0jlU5mzuFHFF3acXyXZPRuyhfiahl4
X-Google-Smtp-Source: ABdhPJxLS3jRjqify86O0mlbitD3RcbwkeBC0cjFbKGDLIFUdtUVpnDZ6mjw+O2zHM/MmuuyKkdvNQ==
X-Received: by 2002:a63:fb10:: with SMTP id o16mr10217360pgh.368.1615527934904;
        Thu, 11 Mar 2021 21:45:34 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id m7sm830815pjc.54.2021.03.11.21.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 21:45:34 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 12/41] KVM: PPC: Book3S 64: Move hcall early register setup to KVM
In-Reply-To: <20210305150638.2675513-13-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com> <20210305150638.2675513-13-npiggin@gmail.com>
Date:   Fri, 12 Mar 2021 16:45:31 +1100
Message-ID: <87czw57wn8.fsf@linkitivity.dja.id.au>
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
>  arch/powerpc/include/asm/exception-64s.h | 13 ++++++++
>  arch/powerpc/kernel/exceptions-64s.S     | 42 +-----------------------
>  arch/powerpc/kvm/book3s_64_entry.S       | 17 ++++++++++
>  3 files changed, 31 insertions(+), 41 deletions(-)
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
> +
>  /*
>   * maximum recursive depth of MCE exceptions
>   */
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 292435bd80f0..b7092ba87da8 100644
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
> @@ -1964,29 +1948,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
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

If I've understood correctly, you've saved the _original_/guest r13 in
SCRATCH0. That makes sense - it just took me a while to follow the
logic, especially because the parameter to SET_SCRATCH0 is r10, not r13.

I would probably expand the comment to say the original or guest r13 (as
you do in the comment at the start of kvmppc_hcall), but if there's a
convention here that I've missed that might not be necessary.

>  #ifdef CONFIG_RELOCATABLE
>  	/*
>  	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
> @@ -1994,15 +1957,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
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
> index 8cf5e24a81eb..a7b6edd18bc8 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -14,6 +14,23 @@
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

Do we want to preserve the comment about why we save the PPR?

> +	HMT_MEDIUM
> +	mfcr	r10
> +	std	r12,HSTATE_SCRATCH0(r13)
> +	sldi	r12,r10,32
> +	ori	r12,r12,0xc00

I see that this is a direct copy from the earlier code, but it confuses
me a bit. Looking at exceptions-64s.S, there's the following comment:

 * In HPT, sc 1 always goes to 0xc00 real mode. In RADIX, sc 1 can go to
 * 0x4c00 virtual mode.

However, this code uncondionally sets the low bits to be c00, even if
the exception came in via 4c00. Is this right? Do we need to pass
that through somehow?

> +	ld	r10,PACA_EXGEN+EX_R10(r13)
>

Otherwise, this looks good to me so far.

Kind regards,
Daniel

>  .global	kvmppc_interrupt
>  .balign IFETCH_ALIGN_BYTES
> -- 
> 2.23.0
