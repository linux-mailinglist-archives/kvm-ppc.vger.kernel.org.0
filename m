Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2F43A17CD
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhFIOtT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 10:49:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238212AbhFIOtI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 10:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623250033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
        b=JQG1am9NP5YHIY+B7O9tBJaSCRqoG5OlqeORopzXIR3D5PwLy1VtSt1FWVAc8jP4q8864L
        JTW8JHSdZFpPOWBVuvrHWnmYTZAX42dbRmC682N3L6g6OkWtxP6uA72yQTUz5JTqjX2q1L
        VKF4K+ehaPyOW2HgbYaetyVkvZQ88Zg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-xLW6RozuMHq6y1cMwzaGfg-1; Wed, 09 Jun 2021 10:47:09 -0400
X-MC-Unique: xLW6RozuMHq6y1cMwzaGfg-1
Received: by mail-wm1-f69.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so2716449wmq.0
        for <kvm-ppc@vger.kernel.org>; Wed, 09 Jun 2021 07:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r7p3iSSBeE9IsLDvewBcO4q2lNyiQ1LDLULJ0BkngOw=;
        b=RqpoxgvYL0YjK4MjAO60dHHcBOnmGhG8/ECONHdvASRlnxLX6XgODwAPNGVAUvuZ94
         4VLt8vKViPuX+AW6rnH15IXjErCqPxS7pCvCQ9ebaiTzCjpxJ2wTkfsOJAipm1ZfxEbb
         lpJ53ma0w17JWgaSN4VlLmjLmFqf2Zzwfit1svo5O7LIwlwxbeKtqTKSMCIYbLjRZyaj
         vmzqwpj7jVjRDqbgH/2dBJdfypzUt+Kw6Qcti/HwJBxFBsqKAcMaaW1oiJpUTCTS/mIr
         dCF/jTpkj0IvCFxAJwsQejabAGwLByRDhMQIoodxRWtFVWmlplihfsThG+4LKlDcqRv2
         Tt7Q==
X-Gm-Message-State: AOAM53295b5+IA6rapMBZOlo9iDhiWlE9At/Ov99gXQJuilJHe6EmSxj
        DrutWVTIa/xdGm5ln5y+gbpYNG+SuYBuOMPIoA5OV17xpc1OZ9o6YAiR6KMGZ9nb7+PnZRZxEHA
        iM1oCf7dugRsNIJA/xw==
X-Received: by 2002:adf:a195:: with SMTP id u21mr137232wru.367.1623250028742;
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweqEQec2chpibdCqZRkKANHtLLkFIjRh58mELPpwoK9PTJW2sYNOXC6gBVGIEq5Mnyq5WnhA==
X-Received: by 2002:adf:a195:: with SMTP id u21mr137211wru.367.1623250028562;
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id l16sm6741263wmj.47.2021.06.09.07.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:47:08 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] powerpc: unify header guards
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
 <20210609143712.60933-6-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <2eefe369-2eeb-17dc-0aec-cc262485c4e3@redhat.com>
Date:   Wed, 9 Jun 2021 16:47:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-6-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Only spapr.h needed a tweak.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   powerpc/spapr.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/powerpc/spapr.h b/powerpc/spapr.h
> index b41aece07968..3a29598be44f 100644
> --- a/powerpc/spapr.h
> +++ b/powerpc/spapr.h
> @@ -1,6 +1,6 @@
> -#ifndef _ASMPOWERPC_SPAPR_H_
> -#define _ASMPOWERPC_SPAPR_H_
> +#ifndef POWERPC_SPAPR_H
> +#define POWERPC_SPAPR_H
>   
>   #define SPAPR_KERNEL_LOAD_ADDR 0x400000
>   
> -#endif /* _ASMPOWERPC_SPAPR_H_ */
> +#endif /* POWERPC_SPAPR_H */
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

