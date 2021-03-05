Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB0332E0F4
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 06:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEFDN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 00:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEFDN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 00:03:13 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3AAC061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 21:03:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id jx13so1134083pjb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 21:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=grIw8UIVqIWLDk6Bf7euU7Jj11KPFQ17JUW2JJKotmA=;
        b=OFZ6rXHd/DFOQYbEKZkR+md/6q5C799A/VSYS2y3stBzHYkBR6XLRWcKleF5V7cvg1
         WXOioysyJYwnyUcLfud6nIMdwWdyOtrFD2jKSLEQ5X+eJbBuDJiTbSZwYePtfAKw58J0
         JEhf6qM94kgpM69/03b2/JC/HzvNrl2d1BLJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=grIw8UIVqIWLDk6Bf7euU7Jj11KPFQ17JUW2JJKotmA=;
        b=uf35xqn0FpR88lZGDhSWLQsjSmuf+EidgeMAV7TiUNfbk4nfj1/x7pwNc8vf0h/CQn
         G3HLWdYevFtMiAe4jMWPuihzGirBuXyay3MxmQapyei/zIJ/TQS3Q/reUDRnGB5GLjqP
         5YkUjjqAPdCgpi3GRD95MlVmSzSlaxtWY35yZgbq/rYI2cWdmi+/Ue6eNotAXNnZcYhQ
         3jVtRSiK02FtAYXKVSMLO8m4tYOdd1KLf3yc/B4LSnYv+2/BgZQ6xTWLyB+SglMIQnVb
         W5d9jtNbkqDPV5Qa2Ge+M0NS/vD8XS1weK2QQUyiFL9AgwnS0a8rZgh6VfO4Oq2VBI0I
         eKDg==
X-Gm-Message-State: AOAM530Fyn/EMrJn2grsTjMVAn++Uf8j++wKCjod2Vmb7woTVyLxOZ7B
        WQXBz8PQ/sh39ZypG4timLxqqQ==
X-Google-Smtp-Source: ABdhPJwYqdFCG78OEDoGtYSwQF+Dd2EnMdYRgf0rwgi3SF0pS3pHXBFQEWRt8vqGd/u0UFX4k5uyLw==
X-Received: by 2002:a17:90a:d3cc:: with SMTP id d12mr8591446pjw.202.1614920592590;
        Thu, 04 Mar 2021 21:03:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id j20sm798446pjn.27.2021.03.04.21.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 21:03:12 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v2 06/37] KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
In-Reply-To: <20210225134652.2127648-7-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-7-npiggin@gmail.com>
Date:   Fri, 05 Mar 2021 16:03:09 +1100
Message-ID: <87r1ku8a5u.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> Rather than bifurcate the call depending on whether or not HV is
> possible, and have the HV entry test for PR, just make a single
> common point which does the demultiplexing. This makes it simpler
> to add another type of exit handler.
>
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

I checked this against the RFC which I was happy with and there are no
changes that I am concerned about. The expanded comment is also nice.

As such:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S    |  8 +-----
>  arch/powerpc/kvm/Makefile               |  3 +++
>  arch/powerpc/kvm/book3s_64_entry.S      | 35 +++++++++++++++++++++++++
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 ++------
>  4 files changed, 41 insertions(+), 16 deletions(-)
>  create mode 100644 arch/powerpc/kvm/book3s_64_entry.S
>
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 0097e0676ed7..ba13d749d203 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -208,7 +208,6 @@ do_define_int n
>  .endm
>  
>  #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
> -#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>  /*
>   * All interrupts which set HSRR registers, as well as SRESET and MCE and
>   * syscall when invoked with "sc 1" switch to MSR[HV]=1 (HVMODE) to be taken,
> @@ -238,13 +237,8 @@ do_define_int n
>  
>  /*
>   * If an interrupt is taken while a guest is running, it is immediately routed
> - * to KVM to handle. If both HV and PR KVM arepossible, KVM interrupts go first
> - * to kvmppc_interrupt_hv, which handles the PR guest case.
> + * to KVM to handle.
>   */
> -#define kvmppc_interrupt kvmppc_interrupt_hv
> -#else
> -#define kvmppc_interrupt kvmppc_interrupt_pr
> -#endif
>  
>  .macro KVMTEST name
>  	lbz	r10,HSTATE_IN_GUEST(r13)
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 2bfeaa13befb..cdd119028f64 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -59,6 +59,9 @@ kvm-pr-y := \
>  kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
>  	tm.o
>  
> +kvm-book3s_64-builtin-objs-y += \
> +	book3s_64_entry.o
> +
>  ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
>  kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
>  	book3s_rmhandlers.o
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> new file mode 100644
> index 000000000000..e9a6a8fbb164
> --- /dev/null
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -0,0 +1,35 @@
> +#include <asm/asm-offsets.h>
> +#include <asm/cache.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_book3s_asm.h>
> +#include <asm/ppc_asm.h>
> +#include <asm/reg.h>
> +
> +/*
> + * This is branched to from interrupt handlers in exception-64s.S which set
> + * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
> + */
> +.global	kvmppc_interrupt
> +.balign IFETCH_ALIGN_BYTES
> +kvmppc_interrupt:
> +	/*
> +	 * Register contents:
> +	 * R12		= (guest CR << 32) | interrupt vector
> +	 * R13		= PACA
> +	 * guest R12 saved in shadow VCPU SCRATCH0
> +	 * guest R13 saved in SPRN_SCRATCH0
> +	 */
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	std	r9,HSTATE_SCRATCH2(r13)
> +	lbz	r9,HSTATE_IN_GUEST(r13)
> +	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
> +	beq	kvmppc_bad_host_intr
> +#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> +	cmpwi	r9,KVM_GUEST_MODE_GUEST
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	beq	kvmppc_interrupt_pr
> +#endif
> +	b	kvmppc_interrupt_hv
> +#else
> +	b	kvmppc_interrupt_pr
> +#endif
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 5e634db4809b..f976efb7e4a9 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1269,16 +1269,8 @@ kvmppc_interrupt_hv:
>  	 * R13		= PACA
>  	 * guest R12 saved in shadow VCPU SCRATCH0
>  	 * guest R13 saved in SPRN_SCRATCH0
> +	 * guest R9 saved in HSTATE_SCRATCH2
>  	 */
> -	std	r9, HSTATE_SCRATCH2(r13)
> -	lbz	r9, HSTATE_IN_GUEST(r13)
> -	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
> -	beq	kvmppc_bad_host_intr
> -#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> -	cmpwi	r9, KVM_GUEST_MODE_GUEST
> -	ld	r9, HSTATE_SCRATCH2(r13)
> -	beq	kvmppc_interrupt_pr
> -#endif
>  	/* We're now back in the host but in guest MMU context */
>  	li	r9, KVM_GUEST_MODE_HOST_HV
>  	stb	r9, HSTATE_IN_GUEST(r13)
> @@ -3280,6 +3272,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
>   * cfar is saved in HSTATE_CFAR(r13)
>   * ppr is saved in HSTATE_PPR(r13)
>   */
> +.global kvmppc_bad_host_intr
>  kvmppc_bad_host_intr:
>  	/*
>  	 * Switch to the emergency stack, but start half-way down in
> -- 
> 2.23.0
