Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F33486E97
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 01:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343956AbiAGAUE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 19:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343948AbiAGAUE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 19:20:04 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BEAC061245
        for <kvm-ppc@vger.kernel.org>; Thu,  6 Jan 2022 16:20:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f5so3977977pgk.12
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jan 2022 16:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X7KaqNcHCCOkAU37GOJO3qlHigFSzpcBdrbhs9RDte8=;
        b=ubRsDgaOTkfgqjXYczjyRXzKHPC623ahI7l/PK74JBcBqFmIbMpIrs1xWrpWwmG8xm
         3U1o8HkcKpc2dFL+Frg8xTuYxGuc+SYbxIHaEwoEg3UatR4Ro0gj6mnGkNubHCz60I3W
         oiF5D7pIUW4VHTS31vbQ2Ey3f38VmwTduwYCpe2jcByjior8eB3QBETgp/OIL+1IGjIT
         hX10jgULJnoliAdsVKyYUq2IjtfdvrigFgdXgqPGPjHtmLsMrHiaqkDVbocBooG7oDw7
         GNewpIj8j03H8rJ3O8Tv0Yh5tAIpGPZtK/STok+lCs5l4YxW4dz4KN4fWJRz3npSzTaJ
         9VgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X7KaqNcHCCOkAU37GOJO3qlHigFSzpcBdrbhs9RDte8=;
        b=nrrjvf2APxD0NaKmYFvbRh6VW0KEWFqCZDECODIbPdDt7EiY1kdbRrWgKK2Uw+M+qM
         IolXcLOErERQvGKpMeXXkK/uJHz4W2VZh3c2XSB8kfMD+o7O3zi5Vm7Ddthdkw1QLqIA
         xUR+l7z4RHwA0ydR2sNcz+/uJuOZpL7uewoip8a8FodDK8lKM/t6b+eGPlmCatmWKSwg
         DVeT+7AYiGDejzSAbAeEJi8HONRS6GKjW5UGSPMXKYpEeuyIh+WB97McIInoonuVK+0B
         4YWAqOlp9VZ9hUgxKxgrJI95TIkR2KrIE4tjtDnj6I3F7hSxgTUBP8nJ/2QlsWle/T9H
         bY3w==
X-Gm-Message-State: AOAM531WKzKG9QEOOKrsWB3VdWmnYgv7ddQ7S/kjFyNORFSFZjYDUOmt
        5N1wSKjiywi1ofdp2XxHEeZTJ3E5Kwi4BA==
X-Google-Smtp-Source: ABdhPJzULnKcypv8WIXnTMPEvNj/K+WRa8PL+yP2if89CKSD+qv/FGHa0W+YeYJg/BcRzq5Qg9ZgYw==
X-Received: by 2002:a63:fd53:: with SMTP id m19mr53560148pgj.563.1641514803247;
        Thu, 06 Jan 2022 16:20:03 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id ip2sm6794471pjb.34.2022.01.06.16.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 16:20:02 -0800 (PST)
Message-ID: <21736a11-1b0f-d4b6-bdd5-2560fc8ffcf1@ozlabs.ru>
Date:   Fri, 7 Jan 2022 11:19:56 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v2 3/7] KVM: PPC: Fix mmio length message
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
 <20220106200304.4070825-4-farosas@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220106200304.4070825-4-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 07/01/2022 07:03, Fabiano Rosas wrote:
> We check against 'bytes' but print 'run->mmio.len' which at that point
> has an old value.
> 
> e.g. 16-byte load:
> 
> before:
> __kvmppc_handle_load: bad MMIO length: 8
> 
> now:
> __kvmppc_handle_load: bad MMIO length: 16
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>   arch/powerpc/kvm/powerpc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 92e552ab5a77..0b0818d032e1 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1246,7 +1246,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
>   
>   	if (bytes > sizeof(run->mmio.data)) {
>   		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> +		       bytes);


"return EMULATE_FAIL;" here and below as there is really no point in 
trashing kvm_run::mmio (not much harm too but still) and this code does 
not handle more than 8 bytes anyway.



>   	}
>   
>   	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
> @@ -1335,7 +1335,7 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
>   
>   	if (bytes > sizeof(run->mmio.data)) {
>   		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> +		       bytes);
>   	}
>   
>   	run->mmio.phys_addr = vcpu->arch.paddr_accessed;

-- 
Alexey
