Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1BA3A17AB
	for <lists+kvm-ppc@lfdr.de>; Wed,  9 Jun 2021 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbhFIOrf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 9 Jun 2021 10:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238079AbhFIOrc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 9 Jun 2021 10:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623249937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
        b=FltXgozsdU5YjSr6PxEIBjs51ZeeoCGVOxczcYeSBH1wbhsuxY3gf9FatwI9hTDLHA6kWj
        OCejbUBMCcDoCT40qmgONxO4ZYCNwXskSFsyRSLgGCR2bzN6vvmPTbS+WxiF7q6AUyC99A
        RtE/SHtGtGlE43sj9mjSsL2Tiqk5rK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-jUq-3bTmMRK09XO4PFafIg-1; Wed, 09 Jun 2021 10:45:35 -0400
X-MC-Unique: jUq-3bTmMRK09XO4PFafIg-1
Received: by mail-wr1-f69.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so10792152wrb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 09 Jun 2021 07:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tnzGT8LB+qqMPyhJStfYGlKykN8fg6Vcl9Y43OphKvE=;
        b=HeYMJ7P+BNZadtHyXXsMd8yHKzVX1btWOxOJoSsrmAcRar+hJA5Qm1Foc9GTZWIuP1
         1qyBtlGopt/PVLP8B7MJfpVZHuPIF9mkoscf7QetQiaSDCcncnG+ilae6GiZvVcejl55
         IuyH/LPB3ff7OEKmwRmO+Ase2n535y7IqvK0PzWM3EEDsu1ZkMrWDKReLOkga2gRQyTC
         tefoz+GOa2y51Q3w7AnfQb4xludZDceWGJXbM8bp9XbYzDP4ShjCYl2iohkCdHyTn6+a
         hYze+psoVkTm1jZz4UfIyUEStq6apofQyGGjMhN/VUaXMW9DTbGEMRTeyoSIC1hnBkoD
         Tw8g==
X-Gm-Message-State: AOAM530G4xZ5J7iA0FGRBSEuNL2Uk9r+P4y6Z4ZlcKwCbJ8QY0l7wZ3C
        5TdzmpQ2dnYiG6Iwq+JJ/zShwxWNRX24f+CAozwW2xAqyFL7LhrbknFgiwDw9EHr2iw0oMoqdqC
        whC2CckWcKnJTFUlHYQ==
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr166300wri.61.1623249934239;
        Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBlt+Qd2SzrFOQD3lcTBbx/uITEZdEoScRy5/tAvd6+BgUrQgY42qMDWZ4IPIP1cvrcUECgg==
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr166282wri.61.1623249934070;
        Wed, 09 Jun 2021 07:45:34 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
        by smtp.gmail.com with ESMTPSA id k82sm6877536wmf.11.2021.06.09.07.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 07:45:33 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 1/7] README.md: add guideline for header
 guards format
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
 <20210609143712.60933-2-cohuck@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <4884a501-939e-a343-7cb3-a31d2f59914f@redhat.com>
Date:   Wed, 9 Jun 2021 16:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-2-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 09.06.21 16:37, Cornelia Huck wrote:
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   README.md | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/README.md b/README.md
> index 24d4bdaaee0d..687ff50d0af1 100644
> --- a/README.md
> +++ b/README.md
> @@ -156,6 +156,15 @@ Exceptions:
>   
>     - While the kernel standard requires 80 columns, we allow up to 120.
>   
> +Header guards:
> +
> +Please try to adhere to adhere to the following patterns when adding
> +"#ifndef <...> #define <...>" header guards:
> +    ./lib:             _HEADER_H_
> +    ./lib/<ARCH>:      _ARCH_HEADER_H_
> +    ./lib/<ARCH>/asm:  _ASMARCH_HEADER_H_

I'd have used _ARCH_ASM_HEADER_H_

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

