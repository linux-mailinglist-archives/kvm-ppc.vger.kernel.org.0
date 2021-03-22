Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305AA34368F
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 03:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCVCJY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 21 Mar 2021 22:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhCVCJP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 21 Mar 2021 22:09:15 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F2AC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 19:09:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso9569424pji.3
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 19:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JFsejohb4GGy/6+7vYAcx2N5NH66/8Q56swBejy1LwA=;
        b=MgZbZ0AGt6UFhsgm0JNdpxwurPJpzzt+1AlV6uizLp6F7rD+Yx8nk6r5Qx/y9Xgx0R
         VIFGoQGlpgxP/kR4MAMmHEmxuExmZXiZTyNbIbLXG0i72q83mJ+rog3GmLzMCrZVgQP/
         Lb40hY6N2JuMA5gsyU7UZ2xJCwPKw38Nx97o+hO0UyewpS+9xNrNx7lHr12HkEKEhYou
         Rb2bZupso77M4F9b92MFmWzpRyHWQBda5KLQnKDBT4BlQrxUR7yynxL3VzcEahGcKHaS
         YgKMh3lpa7U8DntgUlVfzgvZXTsC3lAg9Ex1hoUxEEdNoIaH7UI2a//6rVyO38bUV+Sl
         w1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JFsejohb4GGy/6+7vYAcx2N5NH66/8Q56swBejy1LwA=;
        b=jBIu/C0DYXvWquPwau8r5JesxXYXoa5A9QgzEDfFjBF8tbXun/vIWxZrQ35bGIsIca
         ekp/WnN63L/tmOLIZW0AK1UttdmikCw5eW409dOTaR5hVzN/iowUuOfl4HOH6Oe3QEks
         t0oHGVwfPh6nzX+6BshIf62kCovCpFFKNL7z+JL4wWKIuLNqhxdmNX+43BGhjut6Wkhk
         1A+rZI8EFbWfoUuN9cPyutGlN9PJTGiDmWSktcayTYB9JXZCsVWin0hseSEl3tx/uffU
         RzbaGIiGSEBfFDvwDfgoVMMmrkE3zIxIgu5uTKHXiuOjfpbKFnbJGvk3g6xatP3nDFga
         DuZg==
X-Gm-Message-State: AOAM530d6iS/Lp0xeTjFSlf2IjH9QyjG9UbVwb+ZMvRnTQY5O7VEs+GD
        xHN3upndOJsGwVkmPU87CxRg2bBlZdlAFpiN
X-Google-Smtp-Source: ABdhPJz07Zkr6k/xW/2fxIf9ok3d9BQRE7rOcVy4fzW03RPA/khHfhehu+gdC2YFx7yJlyUYsofT/A==
X-Received: by 2002:a17:902:ea0e:b029:e4:81d4:ddae with SMTP id s14-20020a170902ea0eb02900e481d4ddaemr25204484plg.12.1616378952366;
        Sun, 21 Mar 2021 19:09:12 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id h6sm11170531pfb.157.2021.03.21.19.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 19:09:11 -0700 (PDT)
Message-ID: <3185a6cf-9eaa-8321-27f2-134ad70c7df8@ozlabs.ru>
Date:   Mon, 22 Mar 2021 13:09:07 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 15/41] KVM: PPC: Book3S 64: Minimise hcall handler
 calling convention differences
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-16-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-16-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> This sets up the same calling convention from interrupt entry to
> KVM interrupt handler for system calls as exists for other interrupt
> types.
> 
> This is a better API, it uses a save area rather than SPR, and it has
> more registers free to use. Using a single common API helps maintain
> it, and it becomes easier to use in C in a later patch.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>


Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>



> ---
>   arch/powerpc/kernel/exceptions-64s.S | 16 +++++++++++++++-
>   arch/powerpc/kvm/book3s_64_entry.S   | 22 +++-------------------
>   2 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index b4eab5084964..ce6f5f863d3d 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -1892,8 +1892,22 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
>   
>   #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
>   TRAMP_REAL_BEGIN(kvm_hcall)
> +	std	r9,PACA_EXGEN+EX_R9(r13)
> +	std	r11,PACA_EXGEN+EX_R11(r13)
> +	std	r12,PACA_EXGEN+EX_R12(r13)
> +	mfcr	r9
>   	mfctr	r10
> -	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
> +	std	r10,PACA_EXGEN+EX_R13(r13)
> +	li	r10,0
> +	std	r10,PACA_EXGEN+EX_CFAR(r13)
> +	std	r10,PACA_EXGEN+EX_CTR(r13)
> +BEGIN_FTR_SECTION
> +	mfspr	r10,SPRN_PPR
> +	std	r10,PACA_EXGEN+EX_PPR(r13)
> +END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
> +
> +	HMT_MEDIUM
> +
>   #ifdef CONFIG_RELOCATABLE
>   	/*
>   	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index 7a6b060ceed8..129d3f81800e 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -14,24 +14,9 @@
>   .global	kvmppc_hcall
>   .balign IFETCH_ALIGN_BYTES
>   kvmppc_hcall:
> -	/*
> -	 * This is a hcall, so register convention is as
> -	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
> -	 * R13		= PACA
> -	 * guest R13 saved in SPRN_SCRATCH0
> -	 * R10		= free
> -	 */
> -BEGIN_FTR_SECTION
> -	mfspr	r10,SPRN_PPR
> -	std	r10,HSTATE_PPR(r13)
> -END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
> -	HMT_MEDIUM
> -	mfcr	r10
> -	std	r12,HSTATE_SCRATCH0(r13)
> -	sldi	r12,r10,32
> -	ori	r12,r12,0xc00
> -	ld	r10,PACA_EXGEN+EX_R10(r13)
> -	b	do_kvm_interrupt
> +	ld	r10,PACA_EXGEN+EX_R13(r13)
> +	SET_SCRATCH0(r10)
> +	li	r10,0xc00
>   
>   .global	kvmppc_interrupt
>   .balign IFETCH_ALIGN_BYTES
> @@ -62,7 +47,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>   	ld	r10,EX_R10(r11)
>   	ld	r11,EX_R11(r11)
>   
> -do_kvm_interrupt:
>   	/*
>   	 * Hcalls and other interrupts come here after normalising register
>   	 * contents and save locations:
> 

-- 
Alexey
