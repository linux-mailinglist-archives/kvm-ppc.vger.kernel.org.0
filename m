Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E659B343CFB
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 10:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCVJjN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhCVJil (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 05:38:41 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29883C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 02:38:41 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g15so10552724pfq.3
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 02:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LYfx+Q1yLmXU/wuqtBDKnJDVZV1V/UemyPv+2Y1FQas=;
        b=C2nhdFwgKhHX5XsZVviN37clt1DPl/7+Xe1SQzJSawGUerDGCrU2z5vm9hbbsx6h5P
         znk9i3ps09bjwExPNLXFvhIKSwtjtk8E1VHh8fkTbSwzyi8g/0MnQoSJ32bQqiBR6Weh
         4Q/8sV+de+2tDZ/76dIcQNN7GdmVcD8gxTBkZ/X4A5V/6eQCLLgeyi5RFUIIvHFw8nb0
         qVGIdTFd0NxQY1FbdsTQlMlXYTLhyGxWTCHxVgT1+YVbipKhVFh/MdU39UXntzOm4qPj
         8R/MDrrEX9t9E9GE01lM9L+qDQ2bhZh55nfcFT/7sHDriVnwgRebPBliEqsdekOzX6fN
         6VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LYfx+Q1yLmXU/wuqtBDKnJDVZV1V/UemyPv+2Y1FQas=;
        b=l3KcGSp/XVzyAJLeAGH/UQME4omQj7JjZALdbBtDu47wEMwDCGcvbS8jXOrd7eW4Mb
         1qpP+N6jx+yEsGzgcyZs9RaT7/pBt6Q5GgB45/FWzEdH8WyEUYLOS8R/mTz2856soMrE
         7dwVRYUxP38VkhVViEToeQd2DrlykuvLKkjjQ7uR2kx99q9a7pxr1w/9LzDDiEWyqXls
         mIzYg769xFj9pwtY8xlo+F1zCGp11gpWLlIU2uuvz+cJ/IqF/dB0izERFOBEGLKT5TSI
         TeF1SQJgYnJhVzd6ErhJkRW4v83eQIXF1Nh2dGvYcIbZ+c13vZatgy2EJNzWH4PTnMdc
         3aEA==
X-Gm-Message-State: AOAM531P1rsHw6iMMisOxCseP36jRW2p3sIBELNMn95ngMKVTVgbQG+3
        TJRQOVSA9mzCucj/iRi7FybVPA==
X-Google-Smtp-Source: ABdhPJyuJLh+46KJWLP+dgBfoOdbtxWBGPm8/6c+zh7I5jUfPNudFTgRYumfA8si+D40Ty5rnxG3lw==
X-Received: by 2002:a63:4502:: with SMTP id s2mr22963225pga.94.1616405920731;
        Mon, 22 Mar 2021 02:38:40 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id v27sm13051901pfi.89.2021.03.22.02.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 02:38:40 -0700 (PDT)
Message-ID: <65ca9c57-c988-dc59-5c93-a2a33adb4b6a@ozlabs.ru>
Date:   Mon, 22 Mar 2021 20:38:35 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 24/41] powerpc: add set_dec_or_work API for safely
 updating decrementer
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-25-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-25-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> Decrementer updates must always check for new irq work to avoid an
> irq work decrementer interrupt being lost.
> 
> Add an API for this in the timer code so callers don't have to care
> about details.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> ---
>   arch/powerpc/include/asm/time.h |  9 +++++++++
>   arch/powerpc/kernel/time.c      | 20 +++++++++++---------
>   2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
> index 0128cd9769bc..d62bde57bf02 100644
> --- a/arch/powerpc/include/asm/time.h
> +++ b/arch/powerpc/include/asm/time.h
> @@ -78,6 +78,15 @@ static inline void set_dec(u64 val)
>   		mtspr(SPRN_DEC, val - 1);
>   }
>   
> +#ifdef CONFIG_IRQ_WORK
> +void set_dec_or_work(u64 val);
> +#else
> +static inline void set_dec_or_work(u64 val)
> +{
> +	set_dec(val);
> +}
> +#endif
> +
>   static inline unsigned long tb_ticks_since(unsigned long tstamp)
>   {
>   	return mftb() - tstamp;
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index c5d524622c17..341cc8442e5e 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -562,6 +562,15 @@ void arch_irq_work_raise(void)
>   	preempt_enable();
>   }
>   
> +void set_dec_or_work(u64 val)
> +{
> +	set_dec(val);
> +	/* We may have raced with new irq work */
> +	if (unlikely(test_irq_work_pending()))
> +		set_dec(1);
> +}
> +EXPORT_SYMBOL_GPL(set_dec_or_work);
> +
>   #else  /* CONFIG_IRQ_WORK */
>   
>   #define test_irq_work_pending()	0
> @@ -629,10 +638,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
>   	} else {
>   		now = *next_tb - now;
>   		if (now <= decrementer_max)
> -			set_dec(now);
> -		/* We may have raced with new irq work */
> -		if (test_irq_work_pending())
> -			set_dec(1);
> +			set_dec_or_work(now);
>   		__this_cpu_inc(irq_stat.timer_irqs_others);
>   	}
>   
> @@ -874,11 +880,7 @@ static int decrementer_set_next_event(unsigned long evt,
>   				      struct clock_event_device *dev)
>   {
>   	__this_cpu_write(decrementers_next_tb, get_tb() + evt);
> -	set_dec(evt);
> -
> -	/* We may have raced with new irq work */
> -	if (test_irq_work_pending())
> -		set_dec(1);
> +	set_dec_or_work(evt);
>   
>   	return 0;
>   }
> 

-- 
Alexey
