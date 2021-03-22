Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D4E343B14
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 08:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCVH6y (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 03:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhCVH6t (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 03:58:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF44C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 00:58:49 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so8055292pjg.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 00:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SV1JmF5jI6hBhmsXPOoH9WCSO0IGU+uMmfBL8+n1w0k=;
        b=0Lh1cosMR1BLYkp7/XbLzo6yQSDwNX4gS2sX/Bxqc3OHZw5rtU3ALqpBaPtnhnodQ8
         T6aspYPia/9vkc8e3gqVEHFv9YOkkLq7r0xOxMkp7ra6gK7X8nCiEauD1eIz9iKIcUCD
         81JNOObhpBcLZA58ElzIts9T9nfOkZLYsZworAKKfSkoAwpQCIdcn8Izg2BTighKEwu+
         HHAzaKvQe4tTV+2QpJjGm1ypxQj2MPGUY2hJhwdxTr3qgt1SgAAewiyp7atb6ScsyobL
         xYTXo+yZXs7w9DrniAotXxRsL8lWU8XiI+rrIZyZ/ZWsqXWBR7aqvPzVvWeFPuwahqmN
         /btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SV1JmF5jI6hBhmsXPOoH9WCSO0IGU+uMmfBL8+n1w0k=;
        b=XUvxxzdNzv9eA52EjYtH9k0gebsmCC5hl12KI6wRdUkI2iKxK9Td9mpdfLtLW4YsF7
         jMZ85JBKRH1pDahXoj+gb7XlkvEb68pZCrHHgba+4HuabFPjrbxuXdj2ei5725IrGvAQ
         nLOCGrliqXtt/VCLQOE97W6z3DXcbRRMk+7LAg6UcfBiuZ5iNV6xMoFf8jVz/EBmVFzp
         3W8JL9v2/iMSAHu4r0SZNpvR21z0JSVkSs//LgjkA0ljiGdTk7F9kICalQzaHpzgb7lb
         gbGS3Q1FoKxjYZEIiD4hsUNnAVYLtMnzKLlx89J2Hy/Uu2nqLD8chIslu8AUlVLbyvQ/
         LomA==
X-Gm-Message-State: AOAM533fd2TcUnueRwuUIEY/oGFhgdYUD8n75/JaJYw0mrnNAxpfe83r
        4+3FJOpFLvpZzJEEVOh9vawzeg==
X-Google-Smtp-Source: ABdhPJysgIKQ5ANlDj5YACAaHZKuy80S0VKVypSFucQvMwqG/iLk/cXRthM98iEePXqEinb+c82F4g==
X-Received: by 2002:a17:90a:bf07:: with SMTP id c7mr12588847pjs.15.1616399928690;
        Mon, 22 Mar 2021 00:58:48 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id g21sm12885405pfk.30.2021.03.22.00.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 00:58:48 -0700 (PDT)
Message-ID: <6de508df-319a-3be9-8e8c-3326b547be2a@ozlabs.ru>
Date:   Mon, 22 Mar 2021 18:58:44 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 21/41] KVM: PPC: Book3S HV P9: Use large decrementer
 for HDEC
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-22-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-22-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
> this could help reduce needless guest exits due to leftover exceptions on
> entering the guest.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> ---
>   arch/powerpc/include/asm/time.h | 2 ++
>   arch/powerpc/kvm/book3s_hv.c    | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
> index 8dd3cdb25338..68d94711811e 100644
> --- a/arch/powerpc/include/asm/time.h
> +++ b/arch/powerpc/include/asm/time.h
> @@ -18,6 +18,8 @@
>   #include <asm/vdso/timebase.h>
>   
>   /* time.c */
> +extern u64 decrementer_max;
> +
>   extern unsigned long tb_ticks_per_jiffy;
>   extern unsigned long tb_ticks_per_usec;
>   extern unsigned long tb_ticks_per_sec;
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index ffde1917ab68..24b0680f0ad7 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3623,7 +3623,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   		vc->tb_offset_applied = 0;
>   	}
>   
> -	mtspr(SPRN_HDEC, 0x7fffffff);
> +	/* HDEC must be at least as large as DEC, so decrementer_max fits */
> +	mtspr(SPRN_HDEC, decrementer_max);
>   
>   	switch_mmu_to_host_radix(kvm, host_pidr);
>   




-- 
Alexey
