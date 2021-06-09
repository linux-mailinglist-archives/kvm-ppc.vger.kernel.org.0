Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84143A17C9
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhFIOs6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 10:48:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238101AbhFIOsv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 10:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0hZQMWWxDl7Xi8l29AWO8IasO+rf5yU93tb5RzLQ7g=;
        b=AS3RqPwpMDT7vZL5LWADR6NPLrYQ3XcTSpWHa3SDKcfG6GzujJ7ZxMTMKEyfNI+OmAIbJh
        oqAGQYRb4lYNTgDpovgX2Ast9ohznA9xiLyyxtnrKBA5LRBkmt4jcKIV2B6x12LeGxfE6s
        7w++lC9llY8K5SwQbwyH2WKdwcIbbg0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-DX8QR5tmOrGByzJ-G6NmSQ-1; Wed, 09 Jun 2021 10:46:53 -0400
X-MC-Unique: DX8QR5tmOrGByzJ-G6NmSQ-1
Received: by mail-wm1-f72.google.com with SMTP id l18-20020a05600c4f12b02901921c0f2098so1053246wmq.0
        for <kvm-ppc@vger.kernel.org>; Wed, 09 Jun 2021 07:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=t0hZQMWWxDl7Xi8l29AWO8IasO+rf5yU93tb5RzLQ7g=;
        b=hZjG7kTN5U6Ex68/jmBhwjRyxfpF1qW2hJWVIOmSkGyizARw7WAOMStBNMzoa4J5tQ
         TdB4m+4or2r1hSwqh+M7qc0k7ji1PP7fC5IZWClEyiTGk2fPt4l0TMvCCxwbgg3oYJ7u
         Wc1N9Z7JLIXzpD+sHOQUsHBKH23muEhKZmI2dRCoc668mVJzkYBnNOnhz/B39oZ1XgK9
         VOomZXtv0n+n8lXj9qVG2uL2q1R4pIDvv5rI/J2kd+XgGlmX+EwrRCJVSM1zNd3FIkvM
         pcWZPiYUyXW10RZpzHrlhI5IppqKVy6VDgyfScTliwBlwSHwieT7crQ2JFp5r7dWKEWC
         B/zg==
X-Gm-Message-State: AOAM530dd27rgD4HN0vju1xse7ucBAhijgTQ4F1HRRjmuwCQwwsdxybV
        hLpuY9Bnqhz5iXAhHxjqboJolAdDGGMeFBqwj8WBPH3HxFY2+J133M8aoKLpUBKykao2XvH773c
        xVFoi4g4c/RglJbCJSA==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr10383505wmq.31.1623250011951;
        Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzboBk7WBqh0GgSbryL8mzgfVK8EI4S6S8GDygMVs49zQtyl7XBe/7JeBQTIe1GgwDVwlYqzQ==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr10383492wmq.31.1623250011775;
        Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id e16sm175080wrw.49.2021.06.09.07.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:46:51 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] arm: unify header guards
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-5-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <97d532a5-af52-c2f6-0f0f-7334299aef1a@redhat.com>
Date:   Wed, 9 Jun 2021 16:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-5-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> The assembler.h files were the only ones not already following
> the convention.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/arm/asm/assembler.h   | 6 +++---
>   lib/arm64/asm/assembler.h | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
> index dfd3c51bf6ad..4200252dd14d 100644
> --- a/lib/arm/asm/assembler.h
> +++ b/lib/arm/asm/assembler.h
> @@ -8,8 +8,8 @@
>   #error "Only include this from assembly code"
>   #endif
>   
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM_ASSEMBLER_H_
> +#define _ASMARM_ASSEMBLER_H_
>   
>   /*
>    * dcache_line_size - get the minimum D-cache line size from the CTR register
> @@ -50,4 +50,4 @@
>   	dsb	\domain
>   	.endm
>   
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM_ASSEMBLER_H_ */
> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> index 0a6ab9720bdd..a271e4ceefe6 100644
> --- a/lib/arm64/asm/assembler.h
> +++ b/lib/arm64/asm/assembler.h
> @@ -12,8 +12,8 @@
>   #error "Only include this from assembly code"
>   #endif
>   
> -#ifndef __ASM_ASSEMBLER_H
> -#define __ASM_ASSEMBLER_H
> +#ifndef _ASMARM64_ASSEMBLER_H_
> +#define _ASMARM64_ASSEMBLER_H_
>   
>   /*
>    * raw_dcache_line_size - get the minimum D-cache line size on this CPU
> @@ -51,4 +51,4 @@
>   	dsb	\domain
>   	.endm
>   
> -#endif	/* __ASM_ASSEMBLER_H */
> +#endif	/* _ASMARM64_ASSEMBLER_H_ */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

