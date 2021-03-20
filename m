Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478E0342BC7
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Mar 2021 12:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhCTLMf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 20 Mar 2021 07:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhCTLMM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 20 Mar 2021 07:12:12 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D52C0604DD
        for <kvm-ppc@vger.kernel.org>; Sat, 20 Mar 2021 04:02:38 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id n140so7647541oig.9
        for <kvm-ppc@vger.kernel.org>; Sat, 20 Mar 2021 04:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bXKKCKnz/33aAei7zUlJGr2xMyWZ9KodS3FoI2Gsia4=;
        b=snN3tVHSqTWGJQIiCP/UTPKWnguOwN1n3tRbrw4J9wqgSBZ2ogRAuvponaYotPLrys
         E/qEW8KWKDsRmfRzNGdrc6YqU9bv9aqqe80d4uXZSplDOVRhWWMDUby5sqJHK2s/jVNZ
         n8lDusSFQd6o6rrXCinufXdoy6iRtuFo0Zuf4kye/1PmFbwq4UB/SSXSlm3GBmCDrNyn
         9aBAyYAN2wHSSCdQXjxsGe8ObCwQqJ0/oeszpKVzVGz0/Tkbo5UUN3gVxRmm2tpVaLk3
         +Db4s/QbKtTdb1zrKiWvwpXfeh95hKjYjfkwbdJ5XNMs0rwNCsqmCTsuZ4hzX25ZEX2U
         FTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bXKKCKnz/33aAei7zUlJGr2xMyWZ9KodS3FoI2Gsia4=;
        b=fZYjfzknRy8GygJm0ujVo7wRhFMVbo8EMNqSwiKFBdbO6Df5NJI9P/v6+z8Z950YN9
         lZopO3qHmyiF1f0rUJyZnjoohN7uG6B9LFpMo8svSL2M0LaIV25SmscBbzZCaDNGZHM9
         qTlosLTCuIe96vnZDYD1RcQDJxlIZFadVtzsADn9GgS1yLW+G4P88ATu/GNDOu5hlMFT
         0Mq2QJCLm0etWlgcjiypXi7dg/tsBLMCMHazQbnHsEIQDwBkRXyFueAyVivB3KLtYQIa
         UZ/nntxjL2813gpXF01K6JqHpK7rhyaZ/TAohDmjzApouJb4Idy+NTodbN5Hz0E7CjiC
         gVQQ==
X-Gm-Message-State: AOAM531AJEGMiy2WzGTFvZDdXTL7KTq8k1+Ym2ouK+O5WOsdALaxIyqg
        7j/fKS7azIMmog7G4Eo50ooxZ6leKbbn/fXs
X-Google-Smtp-Source: ABdhPJxOSI1SGW4UP6cRyzkQzxM3OHVzn049dE5cOy6QTjHTlSzgr+RYPwVLLFba9uvnq3aQtfbxIA==
X-Received: by 2002:a17:90a:df91:: with SMTP id p17mr2704648pjv.23.1616231256476;
        Sat, 20 Mar 2021 02:07:36 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id gm9sm7333749pjb.13.2021.03.20.02.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 02:07:35 -0700 (PDT)
Message-ID: <1f68b37c-7167-30d7-ee19-f6ebc69bd4a6@ozlabs.ru>
Date:   Sat, 20 Mar 2021 20:07:31 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 14/41] KVM: PPC: Book3S 64: move bad_host_intr check to
 HV handler
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-15-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-15-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> This is not used by PR KVM.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>


Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

a small tote - it probably makes sense to move this before 09/41 as this 
one removes what 09/41 added to book3s_64_entry.S. Thanks,


> ---
>   arch/powerpc/kvm/book3s_64_entry.S      | 3 ---
>   arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
>   arch/powerpc/kvm/book3s_segment.S       | 7 +++++++
>   3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index d06e81842368..7a6b060ceed8 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -78,11 +78,8 @@ do_kvm_interrupt:
>   	beq-	.Lmaybe_skip
>   .Lno_skip:
>   #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> -	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
> -	beq	kvmppc_bad_host_intr
>   #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
>   	cmpwi	r9,KVM_GUEST_MODE_GUEST
> -	ld	r9,HSTATE_SCRATCH2(r13)
>   	beq	kvmppc_interrupt_pr
>   #endif
>   	b	kvmppc_interrupt_hv
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index f976efb7e4a9..75405ef53238 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1265,6 +1265,7 @@ hdec_soon:
>   kvmppc_interrupt_hv:
>   	/*
>   	 * Register contents:
> +	 * R9		= HSTATE_IN_GUEST
>   	 * R12		= (guest CR << 32) | interrupt vector
>   	 * R13		= PACA
>   	 * guest R12 saved in shadow VCPU SCRATCH0
> @@ -1272,6 +1273,8 @@ kvmppc_interrupt_hv:
>   	 * guest R9 saved in HSTATE_SCRATCH2
>   	 */
>   	/* We're now back in the host but in guest MMU context */
> +	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
> +	beq	kvmppc_bad_host_intr
>   	li	r9, KVM_GUEST_MODE_HOST_HV
>   	stb	r9, HSTATE_IN_GUEST(r13)
>   
> @@ -3272,7 +3275,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
>    * cfar is saved in HSTATE_CFAR(r13)
>    * ppr is saved in HSTATE_PPR(r13)
>    */
> -.global kvmppc_bad_host_intr
>   kvmppc_bad_host_intr:
>   	/*
>   	 * Switch to the emergency stack, but start half-way down in
> diff --git a/arch/powerpc/kvm/book3s_segment.S b/arch/powerpc/kvm/book3s_segment.S
> index 1f492aa4c8d6..ef1d88b869bf 100644
> --- a/arch/powerpc/kvm/book3s_segment.S
> +++ b/arch/powerpc/kvm/book3s_segment.S
> @@ -167,8 +167,15 @@ kvmppc_interrupt_pr:
>   	 * R12             = (guest CR << 32) | exit handler id
>   	 * R13             = PACA
>   	 * HSTATE.SCRATCH0 = guest R12
> +	 *
> +	 * If HV is possible, additionally:
> +	 * R9              = HSTATE_IN_GUEST
> +	 * HSTATE.SCRATCH2 = guest R9
>   	 */
>   #ifdef CONFIG_PPC64
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +#endif
>   	/* Match 32-bit entry */
>   	rotldi	r12, r12, 32		  /* Flip R12 halves for stw */
>   	stw	r12, HSTATE_SCRATCH1(r13) /* CR is now in the low half */
> 

-- 
Alexey
