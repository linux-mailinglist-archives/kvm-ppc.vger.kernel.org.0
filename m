Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E870B349F4F
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Mar 2021 03:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhCZCFh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Mar 2021 22:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhCZCFP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Mar 2021 22:05:15 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64141C06174A
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:05:15 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j25so3858193pfe.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Mar 2021 19:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yKhmmXY4pTqCWXAljZwZF1SSxy2c+IrHiu41koX7ecI=;
        b=GjUuWAup17rU3k6hJzbVBoLpdx1x9vaBoRfVofdlodQDzk3DkIuj2xbDWykBCUopR8
         a3Rv65ZOMsBk9ehPsXqLN8xzYdi0bEZJfm6JekzWtJcrYVIhTqTFlSDhjQm6Grl3H76V
         ihS1r503zJa5FVBIJL6S/va79niYeihhuOtIr0IBEXrAyMoVRBL6MYPBebfmJp6sXO0i
         txfssh/1GBPgUxmJckwXb9Ja9VBapseEEYlxZ5pqCMcaEyJV3y00Za+iJlYU+IhDu3yo
         WU+T3GgSVxWgrWlDhlVE1qB9/QmqOufOEoMd9UVjyf8pGAq9yHwRUjn/7TjeLqTrBvl5
         nDtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yKhmmXY4pTqCWXAljZwZF1SSxy2c+IrHiu41koX7ecI=;
        b=Rt1Ea4rEX5C/PKBVV7tJojzgWUu/rgMTqUeIfizvQ7QosVbl5+pKt2dTec9d545d/M
         g9V2piups+Tcu4JGxam/tOaJY/ULYDc8n/V+Cb+I3A6ZKwrZP7ZH500cP3jwBq2Gwz8Q
         m5/pzVHS7/c+6saLyiCFffS1qQUdaM9sfoBOZsBiU5ib14djcbFRtadfnBXvCeeFTc3/
         0ZR7kXzj0qMIxUXY65MuQf3/VT10zU4pg3Xf98j9N/2+xHA8QrVhz7D6zaMF3B79DrWG
         adCXZY8e/0bDxv6tlNHG/80pcraj84dqhMjKGkHV9PhVVu+2jnyCLVTFWUYBtbJW3JIy
         wkUA==
X-Gm-Message-State: AOAM530LX6iH62VFUB2tSX/eLVJjyx6EOKYD0xNtrZ+9NrTLgyg6BLOy
        nNb9wTq8bjvE/cpVLzj7/zAmDGUJdc47kQ==
X-Google-Smtp-Source: ABdhPJytNWZBIFBatQ0RJL7vsJKciW8PCsq+Tu4UZ5ZSHSUmrZ0jmUWmQkMo8hWDzHUdZHcmVXCHuA==
X-Received: by 2002:aa7:9a95:0:b029:1f3:4169:ccf2 with SMTP id w21-20020aa79a950000b02901f34169ccf2mr10373184pfi.14.1616724314826;
        Thu, 25 Mar 2021 19:05:14 -0700 (PDT)
Received: from [192.168.10.23] (ppp121-45-194-51.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.194.51])
        by smtp.gmail.com with UTF8SMTPSA id r10sm6800294pfq.216.2021.03.25.19.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 19:05:14 -0700 (PDT)
Message-ID: <11ba0a43-a64a-ca06-581c-e8b7dc97b1d7@ozlabs.ru>
Date:   Fri, 26 Mar 2021 13:05:10 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v4 24/46] KVM: PPC: Book3S HV P9: Use large decrementer
 for HDEC
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-25-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210323010305.1045293-25-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 23/03/2021 12:02, Nicholas Piggin wrote:
> On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
> this could help reduce needless guest exits due to leftover exceptions on
> entering the guest.
> 
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>


ERROR: modpost: "decrementer_max" [arch/powerpc/kvm/kvm-hv.ko] undefined!


need this:

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase = {

  #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
  u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max);


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
> index 8215430e6d5e..bb30c5ab53d1 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3658,7 +3658,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   		vc->tb_offset_applied = 0;
>   	}
>   
> -	mtspr(SPRN_HDEC, 0x7fffffff);
> +	/* HDEC must be at least as large as DEC, so decrementer_max fits */
> +	mtspr(SPRN_HDEC, decrementer_max);
>   
>   	switch_mmu_to_host_radix(kvm, host_pidr);
>   
> 

-- 
Alexey
