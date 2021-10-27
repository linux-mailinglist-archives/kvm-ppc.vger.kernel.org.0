Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B2743C82B
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Oct 2021 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbhJ0LBB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 27 Oct 2021 07:01:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232080AbhJ0LBA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 27 Oct 2021 07:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635332315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qj8iuBeW+SwYxG4JX9Q8fVc5FJNZbXtV8v6zQfHvcBQ=;
        b=QDLV2blBHAkMQ1RsqtZ2UZVyfoFdSmlvPqt7BBr/Jpy7KSvj+nJlUETNTZ+dONUuMdpztz
        xfTtqhFYjsPnHg4fi8ThANPkYF1N8Sbc7rBOogvhJARLxFPxbiHIgnjj98koqLFN9lz9U7
        pfGgPx6uV39cZLlSRmU9au5P5Qq1Fa8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-lMaI94hVPa-djNjs4k27pg-1; Wed, 27 Oct 2021 06:58:33 -0400
X-MC-Unique: lMaI94hVPa-djNjs4k27pg-1
Received: by mail-ed1-f69.google.com with SMTP id x13-20020a05640226cd00b003dd4720703bso1934520edd.8
        for <kvm-ppc@vger.kernel.org>; Wed, 27 Oct 2021 03:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qj8iuBeW+SwYxG4JX9Q8fVc5FJNZbXtV8v6zQfHvcBQ=;
        b=qDOuXu1Lmf7uOOWUvPaPf/Xuni5pYNBrkZNDfw3sEzQC2dQqVP4xzwFjRtNZNJdPxc
         8A5TunwX1yfw9KWoSDqmXujzhA6LVQbqbdJvwUAfoXWPGxbih9PC0XPlBY6CE3/bpYrP
         nrj0GhiUYKR/fU9N/6gbMI07p3j+2TLCAT8cgYxrJZUQJkzT13CyZDepR5J8AhVtIFxj
         fUThiGYRWlDh2usD04bbmTplDZ6ppwDVIdsM7NK50sbxyopRx8JbsYnrDUtwfjexx4DR
         wH/qEzEFzEuQ3OTnAd6SPsSPWFwyYEfNGsFNv0w21nvpo43BXU4IiQOzUGlq4BOE9aYj
         EUpA==
X-Gm-Message-State: AOAM532gfskR4s6DL+AJags++QNxQp/kvDQMywBiLIQe4oA4aFrLtD5A
        zxF3RgarBIdD2fJ80TEuA8LT7iR/w5CNSLmtpuY00JolNEwdTCePzFZZI++CjAufZqhOSc9iYwJ
        eiW2CTqWyGY1+trLD8g==
X-Received: by 2002:a50:fd93:: with SMTP id o19mr521146edt.174.1635332312267;
        Wed, 27 Oct 2021 03:58:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8+o6dvUUaSaBXx8qz7NmzfUaR6FGeBVuoZSngvvAw9kfQvVWaceKd6ZFZNCZp9huNPMjDeg==
X-Received: by 2002:a50:fd93:: with SMTP id o19mr521126edt.174.1635332312094;
        Wed, 27 Oct 2021 03:58:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p25sm12439125edt.23.2021.10.27.03.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 03:58:31 -0700 (PDT)
Message-ID: <1216740e-ba36-4f9b-d393-d6364c545a09@redhat.com>
Date:   Wed, 27 Oct 2021 12:58:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] MAINTAINERS: Update powerpc KVM entry
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, paulus@samba.org
Cc:     npiggin@gmail.com, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20211027061646.540708-1-mpe@ellerman.id.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211027061646.540708-1-mpe@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 27/10/21 08:16, Michael Ellerman wrote:
> Paul is no longer handling patches for kvmppc.
> 
> Instead we'll treat them as regular powerpc patches, taking them via the
> powerpc tree, using the topic/ppc-kvm branch when necessary.
> 
> Also drop the web reference, it doesn't have any information
> specifically relevant to powerpc KVM.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>   MAINTAINERS | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ca6d6fde85cf..fbfd3345c40d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10260,11 +10260,8 @@ F:	arch/mips/include/uapi/asm/kvm*
>   F:	arch/mips/kvm/
>   
>   KERNEL VIRTUAL MACHINE FOR POWERPC (KVM/powerpc)
> -M:	Paul Mackerras <paulus@ozlabs.org>
> -L:	kvm-ppc@vger.kernel.org
> -S:	Supported
> -W:	http://www.linux-kvm.org/
> -T:	git git://github.com/agraf/linux-2.6.git
> +L:	linuxppc-dev@lists.ozlabs.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
>   F:	arch/powerpc/include/asm/kvm*
>   F:	arch/powerpc/include/uapi/asm/kvm*
>   F:	arch/powerpc/kernel/kvm*
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks Michael and Paul!

Paolo

