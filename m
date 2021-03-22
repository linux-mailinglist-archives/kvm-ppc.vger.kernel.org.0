Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237F3343BEF
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVIji (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 04:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVIje (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 04:39:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BE3C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 01:39:34 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f10so1077151pgl.9
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 01:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YDk3M29WK38ED6rO/E7cSXZFIP5TSdF9UVZ8+hEukoA=;
        b=MyXE2Ry4BWBpg8VJu8ZcuHZ1ddGC7IwxI9EwlUHS9BlVnY3EsrdZxmkuJ8FUUGQ0xV
         FU6m6fxfXGUAQOakMd/HK204nHMiqaqu7fwCa9/7ujHdizbClhGT7WTbrrgfNjNdYM6x
         KlD4oI0DIKdpWoDMIL0MkyOeNxdVpZFFOz26XTOIihP8t4uLab9lt6uzOmK3SfMZwwta
         U0MkHPJL19jCN0tA/IjVfhcT8OOtg/JnVJji9OPMav/+QPEaOwDud5jjkew2Yd04vFT5
         w9ov5DpHmP8rNt1uv8qosGBbZbyjtGib7nNVvfGhIogWIzIjmJGFVTJ99I8ZjJ5kweFR
         7AXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YDk3M29WK38ED6rO/E7cSXZFIP5TSdF9UVZ8+hEukoA=;
        b=HO///waqvipwF7W4NduMbs+zOB3qA+byPLxdnEM7ra0Po4RJ9bvVu2tdIsnT0w/ry1
         od9HOcVGvljeL7AFUlZhRISb27GlB+jhdSLRMtIjj1auBD0QWBYzGO/fKOXd+j7E6EWo
         BUR9kVSQBdIclS1Nkhnh6lDJ7g02b3JBouJm9wAuCjiz3UgohZ/ZjEZDVDX7KxdgT8wT
         xzCGFxfRfQ3dvuS3PuG2nLWBOZyIXd7TnZj521vnYg/Y8lFjk6wBrz9jVUkupxRXLvQc
         AAcJOUyxEd7PtA5vqe9t6xNW9xVM0LHpVlfDaQ+DeFssO+6JC7AErH5NfcXddMO2pEH9
         oA4A==
X-Gm-Message-State: AOAM531MWc63n6GOaUgqQ7fGRy3Up05VJCqatn/uK8JFim9kg8K5XXVU
        oPL8TuRxrIH2D41KKK5oNCyCRqX9e+y9P7qF
X-Google-Smtp-Source: ABdhPJw46kRhbdEbKjJn0I7N+u7IU/TkW3uxt0PCicci+R0A+zJinqevR2PWJR6/hp99OWjVc/Yojw==
X-Received: by 2002:a63:f247:: with SMTP id d7mr7717891pgk.112.1616402373698;
        Mon, 22 Mar 2021 01:39:33 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id t4sm12976444pjs.12.2021.03.22.01.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 01:39:33 -0700 (PDT)
Message-ID: <21be26e7-d8c9-6681-d89d-4ffdf46d23f7@ozlabs.ru>
Date:   Mon, 22 Mar 2021 19:39:29 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 20/41] KVM: PPC: Book3S HV P9: Move setting HDEC after
 switching to guest LPCR
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-21-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-21-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> LPCR[HDICE]=0 suppresses hypervisor decrementer exceptions on some
> processors, so it must be enabled before HDEC is set.

Educating myself - is not it a processor bug when it does not suppress 
hdec exceptions with HDICE=0?

Also, why do we want to enable interrupts before writing HDEC? Enabling 
it may cause an interrupt right away a

Anyway whatever the answers are, this is not changed by this patch and 
the change makes sense so

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> Rather than set it in the host LPCR then setting HDEC, move the HDEC
> update to after the guest MMU context (including LPCR) is loaded.
> There shouldn't be much concern with delaying HDEC by some 10s or 100s
> of nanoseconds by setting it a bit later.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1f2ba8955c6a..ffde1917ab68 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3505,20 +3505,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   		host_dawrx1 = mfspr(SPRN_DAWRX1);
>   	}
>   
> -	/*
> -	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
> -	 * so set HDICE before writing HDEC.
> -	 */
> -	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
> -	isync();
> -
>   	hdec = time_limit - mftb();
> -	if (hdec < 0) {
> -		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
> -		isync();
> +	if (hdec < 0)
>   		return BOOK3S_INTERRUPT_HV_DECREMENTER;
> -	}
> -	mtspr(SPRN_HDEC, hdec);
>   
>   	if (vc->tb_offset) {
>   		u64 new_tb = mftb() + vc->tb_offset;
> @@ -3564,6 +3553,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>   
> +	/*
> +	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
> +	 * so set guest LPCR (with HDICE) before writing HDEC.
> +	 */
> +	mtspr(SPRN_HDEC, hdec);
> +
>   	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>   	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
>   
> 

-- 
Alexey
