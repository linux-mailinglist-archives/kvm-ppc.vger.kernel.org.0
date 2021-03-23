Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68434550F
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhCWBnz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhCWBnx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:43:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EED3C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:43:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h3so12608614pfr.12
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hQmoN07pSxYuHOAET0vCC+e70OLR6jAQK2ogz5XslTs=;
        b=M5S+OSXKqv93PwyBNbYD5UxWAV+NsHE5gDpaMZMtsYsPzjHlTLNRJfStYMbULfTe8w
         ZCe6G3b8ow6RNCp5T7tTrc5menbYPDJe6aftxMSFyKMvXL8t9D5mBMt527j8+s8tH1M+
         XCsTuJLpx1Qrz0ekL52XysbWR5pSEWjdt61iNeX8gfPMGxG7xqi4HGfEXgnvtLTExGdN
         in57FgR8OGOeB+PVsquW+15aPUg9q1jRy3JYqlF3C2VCIZb+0RWdOb3sR3QjgKQRlyYv
         JZ3StA1SvScSxejq7T0uU9xOEQ3qAynFafgTdqP7ozgC34sYng0WLgub7+QnDJQFI1LF
         JNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hQmoN07pSxYuHOAET0vCC+e70OLR6jAQK2ogz5XslTs=;
        b=XtedgdF98GGbKD0o93iiUaD6gjve2U33ikMQCjTqOOZJvZgHda4oFlC2jkpUlwAg1p
         pP1TVuwSC51FqKtIyVZn+WiK30IRD2iprf6WUD24UyzWVEtMiCTlHeZ7fHExvlqaCwsn
         Ken48tvaswPUHtvZDpEbgilas1s4aWe7rPOjY14CAbCf0PDRfywR0fBPJHWS8v1zqKJ9
         GhzUYPIbwhujShDaxDv9WzNhgROtz8ehFM5sd4XbCox8ITPR6BgxSI8/j1IG3LKegRrk
         9MxrS9jpZftNownMP0ya2ir5Q7eLMjdC7nfQyouHuUUg21sTw+WUmYBBluolkuZDbVFg
         dqZQ==
X-Gm-Message-State: AOAM533/GmyuAGDgjH2rubk4mDgcvT1IRLZVVtkNMwCDAqtMvOJiPsb2
        67eD1p/MfKoJi94f+ksbhZRK0g==
X-Google-Smtp-Source: ABdhPJwy9WcJo/lqUHdK3yHAVQZiv7UD6U0EvvIjZf/ueJk5zzV3P4fzpiYZiBoeWwYnuH8SfsyeLg==
X-Received: by 2002:a62:1c93:0:b029:1fd:2216:fb45 with SMTP id c141-20020a621c930000b02901fd2216fb45mr2426230pfc.13.1616463832818;
        Mon, 22 Mar 2021 18:43:52 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id z2sm15621848pfq.198.2021.03.22.18.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 18:43:52 -0700 (PDT)
Message-ID: <869f47fd-efc7-3cf8-25b6-6aee18f4f082@ozlabs.ru>
Date:   Tue, 23 Mar 2021 12:43:46 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 25/41] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest
 decrementer races
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-26-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-26-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> irq_work's use of the DEC SPR is racy with guest<->host switch and guest
> entry which flips the DEC interrupt to guest, which could lose a host
> work interrupt.
> 
> This patch closes one race, and attempts to comment another class of
> races.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 6f3e3aed99aa..b7a88960ac49 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3704,6 +3704,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   	if (!(vcpu->arch.ctrl & 1))
>   		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>   
> +	/*
> +	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
> +	 * setting DEC. The problem occurs right as we switch into guest mode
> +	 * if a NMI hits and sets pending work and sets DEC, then that will
> +	 * apply to the guest and not bring us back to the host.
> +	 *
> +	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
> +	 * example) and set HDEC to 1? That wouldn't solve the nested hv
> +	 * case which needs to abort the hcall or zero the time limit.
> +	 *
> +	 * XXX: Another day's problem.
> +	 */
>   	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
>   
>   	if (kvmhv_on_pseries()) {
> @@ -3838,7 +3850,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   	vc->entry_exit_map = 0x101;
>   	vc->in_guest = 0;
>   
> -	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
> +	set_dec_or_work(local_paca->kvm_hstate.dec_expires - tb);

set_dec_or_work() will write local_paca->kvm_hstate.dec_expires - tb - 1 
to SPRN_DEC which is not exactly the same, is this still alright?


> +
>   	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
>   
>   	kvmhv_load_host_pmu();
> 

-- 
Alexey
