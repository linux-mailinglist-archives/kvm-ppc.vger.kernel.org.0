Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6530F3438AC
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Mar 2021 06:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCVFbX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 01:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhCVFau (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 01:30:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D739C061756
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 22:30:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g1so5939234plg.7
        for <kvm-ppc@vger.kernel.org>; Sun, 21 Mar 2021 22:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DYK1va0J17C8K7UJDUeSzbRBcaCN8zcsfIRDdQK2F5o=;
        b=K1l8oDBjUv+tdgioqBAL6KhXYYBtZ459MaWjF3i18jf5042G9cm8i7f14i5aN2121E
         jJSpCkCfmK/V3E9v5hBk5S/qNp0/bHI81oE7yNBx+vtVTh+VH055TZFXYfXoG6tf08DE
         V8e5dk2F/nlDk6U3NkDoxXyGW5pMQaaIEYp8P69K0AoymmvhyyeCArovDoqtct3o4FCS
         ENLtWWSPpw/Nu3E2yiYXYkHYr+WfKz0kVLJ3HG1vJar84WPA9taCl+awe3kcpb94NKCp
         o23FZqmQsz++77IBAKqgOiQXE0EkXGX6+K9QH7IzLQvmNnyPyS39rPKZHkNVw1hJf4X5
         H4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DYK1va0J17C8K7UJDUeSzbRBcaCN8zcsfIRDdQK2F5o=;
        b=hWkBjR0cB7c8yUBdsnW3qI8Exq3UQ6KepMNaYIXsT89NvIGgeXphC8tQ/jHHAzdrgN
         W4LV8RWJDOrFaRgs570MtAD7uZSqbTuvNbKjk2+P5b0cOOa4INdD1RaFe7yrTlaZ5CYj
         KytuthZy4OWxCakTVhLSTBdSWBgqSJwwhNkAuaWZWoZ0n4gUev5Lmx1HAhI21nPe861b
         gCzC11009e7oAO+PDPhLg/A2gWAFR8J5H9zCDJbOLf09bQJTx89ETiu1mZOGFzR7yKRJ
         Go4WoHE0RBY58n0aJT2tTT+dqtrY8aaI+C14vlgWxCYLWrz9HEyJrJj6WrILAvzOgstu
         lzEw==
X-Gm-Message-State: AOAM5319AborSd9O0tt9zYRMpIi5zYr3ddJ38iPTYTFMwa5vdWwW8tlC
        t2vWbHDegZLMKxnUi14mKfdtrfQzRz0g1VVp
X-Google-Smtp-Source: ABdhPJwZYnRy9SxkqxvX3iIvq7BLLRH7kN6jLmue9KJW6HsQOxeV6OW2UOBuETxNxYqxf1Yd0S7maA==
X-Received: by 2002:a17:90a:d3d8:: with SMTP id d24mr11075127pjw.166.1616391036183;
        Sun, 21 Mar 2021 22:30:36 -0700 (PDT)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id 186sm12710435pfb.143.2021.03.21.22.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 22:30:35 -0700 (PDT)
Message-ID: <f2c456f7-edc2-9e73-9ee2-58179cebfdda@ozlabs.ru>
Date:   Mon, 22 Mar 2021 16:30:31 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [PATCH v3 18/41] KVM: PPC: Book3S HV P9: Move xive vcpu context
 management into kvmhv_p9_guest_entry
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-19-npiggin@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210305150638.2675513-19-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 06/03/2021 02:06, Nicholas Piggin wrote:
> Move the xive management up so the low level register switching can be
> pushed further down in a later patch. XIVE MMIO CI operations can run in
> higher level code with machine checks, tracing, etc., available.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>



Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> ---
>   arch/powerpc/kvm/book3s_hv.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index b265522fc467..497f216ad724 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3558,15 +3558,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>   
>   	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>   
> -	kvmppc_xive_push_vcpu(vcpu);
> -
>   	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>   	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
>   
>   	trap = __kvmhv_vcpu_entry_p9(vcpu);
>   
> -	kvmppc_xive_pull_vcpu(vcpu);
> -
>   	/* Advance host PURR/SPURR by the amount used by guest */
>   	purr = mfspr(SPRN_PURR);
>   	spurr = mfspr(SPRN_SPURR);
> @@ -3749,7 +3745,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>   			trap = 0;
>   		}
>   	} else {
> +		kvmppc_xive_push_vcpu(vcpu);
>   		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
> +		kvmppc_xive_pull_vcpu(vcpu);
> +
>   	}
>   
>   	vcpu->arch.slb_max = 0;
> 

-- 
Alexey
