Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADFD486ED3
	for <lists+kvm-ppc@lfdr.de>; Fri,  7 Jan 2022 01:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbiAGAae (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jan 2022 19:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344331AbiAGAaa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jan 2022 19:30:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D068C061245
        for <kvm-ppc@vger.kernel.org>; Thu,  6 Jan 2022 16:30:30 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id h1so3622738pls.11
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jan 2022 16:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lprQNZoVyIwFc88+ZDsWucdXRZyZ/0iZgJO/DKb46sA=;
        b=ptMDyqLPCn0qgrelpm9g0SFYXuZ9+k1AxI3GqMBAx5ljQa0KLdtpKA5+534nIVZ667
         zsRB1dw6XBxQYqTuZlXIy2ehqdTamVi7dgloC6l4/4fke+qF92V9XNzxXrLVKOfnQDgf
         E76yAC0NQtrlZwQwbPpexftfklvQY2ndBArQarD2AQsjGKuVbU5NFClyY/oEmxrJIpll
         F2l4mQNC5n9RkJibo9Z/MHQlGGkkKeMY/3jb3F3agGYr//AA1rA5JflfXB3q+3dz9zwj
         9uL+fKG7WKCjnAOj/fbXqTWgG/B8vwTa0eaNRhgCz5OnEX1JnVIYXgHSbTnEnHY1xKYS
         c56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lprQNZoVyIwFc88+ZDsWucdXRZyZ/0iZgJO/DKb46sA=;
        b=mT0lwXGWIKIJYG7jJsyxjPgMKXyi3i+stxZ3HMGQ0BGaTR2YlFU02x4tktQMEBOmgm
         kD1kHJxZG51VEnH05hg2nppRrs8i6HezK4YmY9QeXRUM/affAuc0XonHfBMrmnSG50ZP
         1dw1ZNxjK1CrzLA6Y6/vRNdpKo22OeKoqI21Uo+/xnkfjMQBT7DkI9QS9gteg8JYTqE0
         90CN39QVI7sB+TvGELzHxGuhipgbieqEHE+zRE1jJO5u0aPpK8ZBI8yucplTgXIfsex0
         17X8hhCpUM8GU5e7N8sEZbqdW0z5IVyQOOjtnOOyAufJiKLxut59L+BRafnQgq4z4A7U
         PCYA==
X-Gm-Message-State: AOAM532NQoibijki7sdWYQeaAH8ntGhDrJlITEMmYsbnTYD5B3gSq7VE
        MQBh6SiANXCqFk+4PptPQ843YQ==
X-Google-Smtp-Source: ABdhPJyJY0plWYKVlHuKluYNR3d3Reap36XUR5DXgofbxpefsTl/LoWg0jdSfot5s5qeDhLwPkd1Lw==
X-Received: by 2002:a17:902:c784:b0:148:ef6f:fc4a with SMTP id w4-20020a170902c78400b00148ef6ffc4amr61583580pla.165.1641515429634;
        Thu, 06 Jan 2022 16:30:29 -0800 (PST)
Received: from [192.168.10.153] (203-7-124-83.dyn.iinet.net.au. [203.7.124.83])
        by smtp.gmail.com with ESMTPSA id t8sm3505589pfj.114.2022.01.06.16.30.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 16:30:29 -0800 (PST)
Message-ID: <4ceb77f5-4c31-1d18-e29e-849ab111475c@ozlabs.ru>
Date:   Fri, 7 Jan 2022 11:30:24 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v2 7/7] KVM: PPC: mmio: Reject instructions that access
 more than mmio.data size
Content-Language: en-US
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, npiggin@gmail.com
References: <20220106200304.4070825-1-farosas@linux.ibm.com>
 <20220106200304.4070825-8-farosas@linux.ibm.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20220106200304.4070825-8-farosas@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 07/01/2022 07:03, Fabiano Rosas wrote:
> The MMIO interface between the kernel and userspace uses a structure
> that supports a maximum of 8-bytes of data. Instructions that access
> more than that need to be emulated in parts.
> 
> We currently don't have generic support for splitting the emulation in
> parts and each set of instructions needs to be explicitly included.
> 
> There's already an error message being printed when a load or store
> exceeds the mmio.data buffer but we don't fail the emulation until
> later at kvmppc_complete_mmio_load and even then we allow userspace to
> make a partial copy of the data, which ends up overwriting some fields
> of the mmio structure.
> 
> This patch makes the emulation fail earlier at kvmppc_handle_load|store,
> which will send a Program interrupt to the guest. This is better than
> allowing the guest to proceed with partial data.
> 
> Note that this was caught in a somewhat artificial scenario using
> quadword instructions (lq/stq), there's no account of an actual guest
> in the wild running instructions that are not properly emulated.



Ah thereee it is :-)
I'd merge it into 3/7.

anyway,
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>


> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>   arch/powerpc/kvm/powerpc.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 50e08635e18a..a1643ca988e0 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1247,6 +1247,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vcpu,
>   	if (bytes > sizeof(run->mmio.data)) {
>   		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
>   		       bytes);
> +		return EMULATE_FAIL;
>   	}
>   
>   	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
> @@ -1336,6 +1337,7 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
>   	if (bytes > sizeof(run->mmio.data)) {
>   		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
>   		       bytes);
> +		return EMULATE_FAIL;
>   	}
>   
>   	run->mmio.phys_addr = vcpu->arch.paddr_accessed;

-- 
Alexey
