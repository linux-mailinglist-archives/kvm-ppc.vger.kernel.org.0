Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383EC32E1F1
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 07:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbhCEGDc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 01:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCEGDc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 01:03:32 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63764C061574
        for <kvm-ppc@vger.kernel.org>; Thu,  4 Mar 2021 22:03:32 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d12so1319842pfo.7
        for <kvm-ppc@vger.kernel.org>; Thu, 04 Mar 2021 22:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=rdp7PWtpXvmUGn3d3PjdggcXQvhRMcWQXUln99EH/9I=;
        b=ptEg+KpzK5q7G5e8Xc5XAj2KGg5K8RBpO0pSyKdxJFfxxUtzZ2k+onRAyIpuTWzg/z
         fUTLvxyoMDID/zJyxx1xQPyvw3ymbnUpJtF0nTbGSMvG8kXIWfhHhd+HBMMj4f2HgHwf
         y4qD+fJnU/a7TEotEBuNJKw2M1PnNDeTABg/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rdp7PWtpXvmUGn3d3PjdggcXQvhRMcWQXUln99EH/9I=;
        b=ABxcLikZTfnTgg/nHTnEmoQ3m5atGLrmElmj3GOlCn6EjgNmEaqsiDUnAUUnIOxJrC
         Z8c9xlp6lEJVEvzT/Td7KLV/L1Gvni9ueFvd44ldL8xKEl7gb3EVQJjs5IqcUhdPHKOY
         CWQDGjobvPTOBDqMfiynapVmGYUMnAUb86nvC/zM5vbR/iHPaEcxJwBQWWNuu2VmsYTR
         +44w9WWRhrYhD3oz5Qpvg/aw3k2ony1f1F39HUavA9ZnROJyGxbyyf1Pb9F2XS12w/Yf
         gmnkSqs1GCxNVV56lJ/EwlWdlq8r1vCsCQU54z/+EKIEz1HCfFdUuWvxK2pQnks7Cvp4
         PTtw==
X-Gm-Message-State: AOAM5336xW8b09HSnamBit6Kiys0gBr24ayu8QWsmSIKq9uWPvsRCsqL
        b2QdX0V8S0Nc1oVBX/teO/LW/kHxHQoV1EoZ
X-Google-Smtp-Source: ABdhPJzobPGfgfjOJ1ogHKuAyIGpCQ2a0M1OEPiYJqbfNPUPoJghFDf9SgyhPjVYsXkZDIoWh81vLg==
X-Received: by 2002:a63:2164:: with SMTP id s36mr7096239pgm.268.1614924211873;
        Thu, 04 Mar 2021 22:03:31 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id a19sm1111262pff.186.2021.03.04.22.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 22:03:31 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v2 08/37] KVM: PPC: Book3S 64: add hcall interrupt handler
In-Reply-To: <20210225134652.2127648-9-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-9-npiggin@gmail.com>
Date:   Fri, 05 Mar 2021 17:03:28 +1100
Message-ID: <87lfb287db.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Nick,

> Add a separate hcall entry point. This can be used to deal with the
> different calling convention.

Looks good to me, makes sense, passes checkpatch.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel


> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S | 4 ++--
>  arch/powerpc/kvm/book3s_64_entry.S   | 6 +++++-
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index d956dd9ed61f..9ae463e8522b 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -1992,13 +1992,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>  	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
>  	 * outside the head section.
>  	 */
> -	__LOAD_FAR_HANDLER(r10, kvmppc_interrupt)
> +	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
>  	mtctr   r10
>  	ld	r10,PACA_EXGEN+EX_R10(r13)
>  	bctr
>  #else
>  	ld	r10,PACA_EXGEN+EX_R10(r13)
> -	b       kvmppc_interrupt
> +	b       kvmppc_hcall
>  #endif
>  #endif
>  
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index c1276f616af4..9572f759255c 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -7,9 +7,13 @@
>  #include <asm/reg.h>
>  
>  /*
> - * This is branched to from interrupt handlers in exception-64s.S which set
> + * These are branched to from interrupt handlers in exception-64s.S which set
>   * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
>   */
> +.global	kvmppc_hcall
> +.balign IFETCH_ALIGN_BYTES
> +kvmppc_hcall:
> +
>  .global	kvmppc_interrupt
>  .balign IFETCH_ALIGN_BYTES
>  kvmppc_interrupt:
> -- 
> 2.23.0
