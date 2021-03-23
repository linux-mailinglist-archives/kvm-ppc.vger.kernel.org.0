Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA93459E8
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 09:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhCWIhR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 04:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCWIhK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 04:37:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDAEC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 01:36:59 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b184so13559634pfa.11
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 01:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jN5HG3Z7JQSh5RH3WCWd1hLZbONUmt0c5YylqPs4xT4=;
        b=D0h0vz8g1KyCKIYnd63QZf0Qd3o07YZUIpKZYi4P85ZIEhTqmYjil9Yown7zOG60xh
         iESiee25NRfqTtHvrbN3XqiTyoJHptkjj48KtDlAX7DqOTmxuhAJTFiOYVGvvQTyjLyz
         eN/79aVJ7oo3LqzCy7d21RAFg8VOpvglbEtsbbJeh6qgtv/55tspYnyNi9rqq8b4S4Rv
         uy78HnDNvltE3j1WBXh05u5UoUkuBrM41lbTZAYks96Jf0e5bAMzEBnfKZujxmZBJpP7
         KPwTz0Nbxa0pLLHRvMmO5ZNnglXhybMD2qUbZ9k8CrOPf+fReMFjAhUkGD4Of+WH+D2c
         A0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jN5HG3Z7JQSh5RH3WCWd1hLZbONUmt0c5YylqPs4xT4=;
        b=UvPoNdhDTWBMk4xlt6twcscqAWIVORGtS7DY1omloEPOWz9ymKA6mIQyMmuzPFSjbZ
         xPd9RttkEfZMwPtRrbuEuPEdvZNaJCeQVrqB1bp4OoaUYulinkOcXVChTKDL72buIGJn
         nXydGuUGuhd05cQuzsCf2Zl6em8aDKMF+N1aJU+rYkx+PiUHPRkJZrhQeerqVKGAFU15
         6Bz+XJzRA2tWpuTyQSRflGOpAIns2Uk1MG22dFOt+DMCTmdPWV9thOdunJUxalovBkVc
         XJS6/6DKLDptkS0AzWHtm7y2VPQmCbQZLJSCvHvzW26HqBZR6CPd031z8b80Ow6pUciE
         ZruQ==
X-Gm-Message-State: AOAM53282W7NToF5zPRi7zT+q05m/Jm9xVaeZ01R5KTFS6F+U9JqPgFc
        MBsQoqz+tJeHvrFhw7naGd8lyg==
X-Google-Smtp-Source: ABdhPJw22HT3fMJlX3CqClhcXpEBjWosJQcb3XgGXhanOKSlabMuBpdS63L42+ZwJEJElYbgL87KSg==
X-Received: by 2002:a63:f055:: with SMTP id s21mr3151448pgj.293.1616488619359;
        Tue, 23 Mar 2021 01:36:59 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id m5sm16525581pfd.96.2021.03.23.01.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 01:36:58 -0700 (PDT)
Message-ID: <efcbb80d-2d91-aee7-6e8a-e9904ce4c987@ozlabs.ru>
Date:   Tue, 23 Mar 2021 19:36:54 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v4 04/46] KVM: PPC: Book3S HV: Prevent radix guests from
 setting LPCR[TC]
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-5-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210323010305.1045293-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 23/03/2021 12:02, Nicholas Piggin wrote:
> This bit only applies to hash partitions.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>



Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

> ---
>   arch/powerpc/kvm/book3s_hv.c        | 6 ++++++
>   arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c5de7e3f22b6..1ffb0902e779 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1645,6 +1645,12 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
>    */
>   unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned long lpcr)
>   {
> +	struct kvm *kvm = vc->kvm;
> +
> +	/* LPCR_TC only applies to HPT guests */
> +	if (kvm_is_radix(kvm))
> +		lpcr &= ~LPCR_TC;
> +
>   	/* On POWER8 and above, userspace can modify AIL */
>   	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
>   		lpcr &= ~LPCR_AIL;
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index f7b441b3eb17..851e3f527eb2 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -140,8 +140,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
>   	/*
>   	 * Don't let L1 change LPCR bits for the L2 except these:
>   	 */
> -	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
> -		LPCR_LPES | LPCR_MER;
> +	mask = LPCR_DPFD | LPCR_ILE | LPCR_AIL | LPCR_LD | LPCR_LPES | LPCR_MER;
>   	hr->lpcr = kvmppc_filter_lpcr_hv(vc,
>   			(vc->lpcr & ~mask) | (hr->lpcr & mask));
>   
> 

-- 
Alexey
