Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8AB3A17B3
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 16:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhFIOsU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 10:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36745 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237130AbhFIOsT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 10:48:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIqvjSEU4FgOL3T+Qh1WRtqKFo8pGZcLfL/2xIjJVgQ=;
        b=XP5Ve8UmEdyIUAFXnJjcu7YjbrDp5I20OItyp7NR5XvFKh5FYWS8C+91sHdVhVARGq0sQp
        CPtZn6upHbI/iz7En0ivZYXK793rjMPqEK7Hzs500NMVBg+i3hMjrEn/VYR9farToSS5SA
        F0sH3OpZI3IygDptTd5f74DJ7Cnl7HA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-xoO-i0jaPVmvM9F-eWWe5Q-1; Wed, 09 Jun 2021 10:46:23 -0400
X-MC-Unique: xoO-i0jaPVmvM9F-eWWe5Q-1
Received: by mail-wm1-f71.google.com with SMTP id z25-20020a1c4c190000b029019f15b0657dso2009457wmf.8
        for <kvm-ppc@vger.kernel.org>; Wed, 09 Jun 2021 07:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YIqvjSEU4FgOL3T+Qh1WRtqKFo8pGZcLfL/2xIjJVgQ=;
        b=bNmX2C/swjhZEBT2V0HH0FGRrovXeIk3TporIu8uqia6WFpTAJW+Yz77SQPU2LsVJT
         TNXMrmltxqFx0CQzsXbIzs8KnC6W8JU2+hiYW2XDmjZETTULvfrUUMFOxCFp7WFvKHOC
         Qy2c981f/1Cg+kah57eZrVpjz5RvopqMvE8+AibpjX/e/GFPiWdueS/eXSD2dD7vDBYK
         8arJiwt386m7Zl1p58DSHxkVrO9y3M2xiGRiXUtvJaz69vqElPVQMKHaKL0T9/0S+W3c
         MTDGxlDjWH57c+BRqqCZveU5ngelBGojsXdO53VSjK8wuf+V4XwWmbPNxgSi5BvBixEG
         qF1w==
X-Gm-Message-State: AOAM532PBiza7oUBqcunJ9fSh1HYtFHfdbRBxw8SxT5+DSnBXQwThbGT
        GGmzZCH4BRD0aMUXGRMJ5FkrX/9Hr/lsP3YSINqooK/UKSmUCY7FXjq+Q4RLsldmXkST4+XhzyX
        K9ewQ+n8bhGpM/otPFA==
X-Received: by 2002:a05:6000:1c1:: with SMTP id t1mr188263wrx.282.1623249982391;
        Wed, 09 Jun 2021 07:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYGAMXz2ChPOq3Q/uYsovwSNcvm3wQtqcAcXSOMYfajhjXyyWekzuMWA5VoJWHNrDFPXvJrw==
X-Received: by 2002:a05:6000:1c1:: with SMTP id t1mr188234wrx.282.1623249982170;
        Wed, 09 Jun 2021 07:46:22 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id u20sm10489wmq.24.2021.06.09.07.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:46:21 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] asm-generic: unify header guards
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
 <20210609143712.60933-4-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <3b614940-b8be-244c-5271-23dffbd02ae9@redhat.com>
Date:   Wed, 9 Jun 2021 16:46:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-4-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Standardize header guards to _ASM_GENERIC_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/asm-generic/atomic.h          | 4 ++--
>   lib/asm-generic/barrier.h         | 6 +++---
>   lib/asm-generic/memory_areas.h    | 4 ++--
>   lib/asm-generic/pci-host-bridge.h | 4 ++--
>   4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/asm-generic/atomic.h b/lib/asm-generic/atomic.h
> index 26b645a7cc18..b09ce95053e7 100644
> --- a/lib/asm-generic/atomic.h
> +++ b/lib/asm-generic/atomic.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_ATOMIC_H__
> -#define __ASM_GENERIC_ATOMIC_H__
> +#ifndef _ASM_GENERIC_ATOMIC_H_
> +#define _ASM_GENERIC_ATOMIC_H_
>   
>   /* From QEMU include/qemu/atomic.h */
>   #define atomic_fetch_inc(ptr)  __sync_fetch_and_add(ptr, 1)
> diff --git a/lib/asm-generic/barrier.h b/lib/asm-generic/barrier.h
> index 6a990ff8d5a5..5499a5664d4d 100644
> --- a/lib/asm-generic/barrier.h
> +++ b/lib/asm-generic/barrier.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_BARRIER_H_
> -#define _ASM_BARRIER_H_
> +#ifndef _ASM_GENERIC_BARRIER_H_
> +#define _ASM_GENERIC_BARRIER_H_
>   /*
>    * asm-generic/barrier.h
>    *
> @@ -32,4 +32,4 @@
>   #define cpu_relax()	asm volatile ("":::"memory")
>   #endif
>   
> -#endif /* _ASM_BARRIER_H_ */
> +#endif /* _ASM_GENERIC_BARRIER_H_ */
> diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
> index 3074afe23393..c86db255ecee 100644
> --- a/lib/asm-generic/memory_areas.h
> +++ b/lib/asm-generic/memory_areas.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
> -#define __ASM_GENERIC_MEMORY_AREAS_H__
> +#ifndef _ASM_GENERIC_MEMORY_AREAS_H_
> +#define _ASM_GENERIC_MEMORY_AREAS_H_
>   
>   #define AREA_NORMAL_PFN 0
>   #define AREA_NORMAL_NUMBER 0
> diff --git a/lib/asm-generic/pci-host-bridge.h b/lib/asm-generic/pci-host-bridge.h
> index 9e91499b9446..174ff341dd0d 100644
> --- a/lib/asm-generic/pci-host-bridge.h
> +++ b/lib/asm-generic/pci-host-bridge.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_PCI_HOST_BRIDGE_H_
> -#define _ASM_PCI_HOST_BRIDGE_H_
> +#ifndef _ASM_GENERIC_PCI_HOST_BRIDGE_H_
> +#define _ASM_GENERIC_PCI_HOST_BRIDGE_H_
>   /*
>    * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
>    *
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

