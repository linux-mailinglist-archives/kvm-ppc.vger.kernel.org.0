Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FCE359978
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Apr 2021 11:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhDIJkv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Apr 2021 05:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhDIJku (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Apr 2021 05:40:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A25DC061760
        for <kvm-ppc@vger.kernel.org>; Fri,  9 Apr 2021 02:40:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id i4so2623253pjk.1
        for <kvm-ppc@vger.kernel.org>; Fri, 09 Apr 2021 02:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YmU4UiRVkN1jsGVU6rQrNh3lTqcstMlm4Jq3GPaOiBg=;
        b=eqIhnDSzpDVsrQPF0Ue5XOV2jhZhuABTesoYNs+8JkS5P/26nSC6kEcLaTg6hhRs+t
         EBn18+xL8oMlFGcuH9Ho7V6URI56y7m4z5vHbYa7+1WeuFI6HTryEpAMA0spRWinOHbu
         TjZj1V6txt49AJklDB7yEWntiF/Hwc/BSpVZQSWr8dxlfjBpaDW+sv0KA/ssn8lgSXy3
         VEtN5j/XE1PqAa2I3SRlaFueEtpOSlPLqABVnvwwvALloBokUoGBWMUNZBTiOvzFYR03
         XvduPait262wk1qAQkFlT+rNEQ0U4oTfGjEYo9XgS9sV+zV1+f2d85IwmJffEFNWhQR6
         LxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YmU4UiRVkN1jsGVU6rQrNh3lTqcstMlm4Jq3GPaOiBg=;
        b=m5RlUYez4kCiKdiyE0ANwsC5lgnSgF96l9m+r223hx+GWt9MWfizGlvg+Lq/TxRI79
         lqK1i0H/XgtqocH7cykLTePRPMOtiIyHR1jvfDVWQsSFSOb4NvVU1oi097mjcAyrGVwB
         Me7v1o6/NSO0vpSoEEdVqMPUDfmBS9F0kdZP57r6ed78ie2CW1QMo18AU04OQFvBOjXl
         XRJ4n9/pIu910lINtnXB1YNnql+GQNX41YojN1NVhmzpiUQJE7tNV1yY4eYHCEfAAQJC
         NsAjnYTvUZUS1O+S87gBsZ0IrEwnT9rY+ML1OQlqBUH7y+JodRpUr+SY8BeUZLq5h0pa
         BHow==
X-Gm-Message-State: AOAM532klfUpEq40+xpO5uMoiwQLc9j9owzcLe754zLKhk4P3P2hAi0R
        2/JLfIfrXzR7TjmPrqikC+409w==
X-Google-Smtp-Source: ABdhPJzBJnlNgNVxBVoaHcGTjRjTuUWT11L073en1sQkvqt5WFQV4jpmf9QTqoOhmXIVyzYlH7u8eQ==
X-Received: by 2002:a17:902:f686:b029:e5:de44:af60 with SMTP id l6-20020a170902f686b02900e5de44af60mr12117445plg.64.1617961237726;
        Fri, 09 Apr 2021 02:40:37 -0700 (PDT)
Received: from localhost (ppp121-45-194-51.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.194.51])
        by smtp.gmail.com with UTF8SMTPSA id f135sm1721237pfa.102.2021.04.09.02.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 02:40:36 -0700 (PDT)
Message-ID: <19d2d94d-8c7e-70ae-1a40-97c67654a373@ozlabs.ru>
Date:   Fri, 9 Apr 2021 19:40:33 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:88.0) Gecko/20100101
 Thunderbird/88.0
Subject: Re: [PATCH v6 33/48] KVM: PPC: Book3S HV P9: Improve exit timing
 accounting coverage
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210405011948.675354-1-npiggin@gmail.com>
 <20210405011948.675354-34-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210405011948.675354-34-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 05/04/2021 11:19, Nicholas Piggin wrote:
> The C conversion caused exit timing to become a bit cramped. Expand it
> to cover more of the entry and exit code.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>


Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

> ---
>   arch/powerpc/kvm/book3s_hv_interrupt.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
> index e93d2a6456ff..44c77f907f91 100644
> --- a/arch/powerpc/kvm/book3s_hv_interrupt.c
> +++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
> @@ -154,6 +154,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   	if (hdec < 0)
>   		return BOOK3S_INTERRUPT_HV_DECREMENTER;
>   
> +	start_timing(vcpu, &vcpu->arch.rm_entry);
> +
>   	if (vc->tb_offset) {
>   		u64 new_tb = tb + vc->tb_offset;
>   		mtspr(SPRN_TBU40, new_tb);
> @@ -204,8 +206,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   	 */
>   	mtspr(SPRN_HDEC, hdec);
>   
> -	start_timing(vcpu, &vcpu->arch.rm_entry);
> -
>   	vcpu->arch.ceded = 0;
>   
>   	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
> @@ -349,8 +349,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   
>   	accumulate_time(vcpu, &vcpu->arch.rm_exit);
>   
> -	end_timing(vcpu);
> -
>   	/* Advance host PURR/SPURR by the amount used by guest */
>   	purr = mfspr(SPRN_PURR);
>   	spurr = mfspr(SPRN_SPURR);
> @@ -415,6 +413,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>   
>   	switch_mmu_to_host_radix(kvm, host_pidr);
>   
> +	end_timing(vcpu);
> +
>   	return trap;
>   }
>   EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
> 

-- 
Alexey
