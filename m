Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2823D8E00
	for <lists+kvm-ppc@lfdr.de>; Wed, 28 Jul 2021 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhG1Mjk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 28 Jul 2021 08:39:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235009AbhG1Mji (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 28 Jul 2021 08:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627475976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9Qexy3vyQ1WT2G4JaMh1Amg9BsqkfUkZn1xzPofcxE=;
        b=GodU87qe0NujaBMDb7x7SPl09MGw5xzZlH1yTpTUjNbzYKra/ddaEjDUqB6kePcQBCd1dZ
        yEHLQd7KRqhg0KSiA5kXBrtmLcVMA8eEy+NYksP+tyhAvq0hdUQRR4OEnikJqsFEOfguQE
        stWEjuX+VtBt/pNFFJSCpxGbJqHu+NU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-TmJV_1PsOOKsfqBBV9SEKg-1; Wed, 28 Jul 2021 08:39:35 -0400
X-MC-Unique: TmJV_1PsOOKsfqBBV9SEKg-1
Received: by mail-wr1-f69.google.com with SMTP id p12-20020a5d68cc0000b02901426384855aso899724wrw.11
        for <kvm-ppc@vger.kernel.org>; Wed, 28 Jul 2021 05:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9Qexy3vyQ1WT2G4JaMh1Amg9BsqkfUkZn1xzPofcxE=;
        b=drvbgrD+ls2/0Qtm0k4OOQEKUKScO2O6ABZHggYMaetbmNw/wiq4/Y4Jn9SFTUEiL3
         mZ5ogATd8b/3sTvz9AMSKvbeUYvIjyvcIhPjM05X00ci+XPojOpEPSwgNcAEF2eCLZ2y
         X0lMAgcdmR6qarCbotLJCcODIOI8+Mtbqdm44Fx/aSjPJK7vpKzzvTBW9wIvhJ9A9fGC
         HjguacM7WVIia9rFyBYj8pQYVx33lp0bkDQlZw7E+ifqnxpTEylJpLl2xi3Kls4T3qxy
         Lk9I/7bSGnSvfvnEquynJAnSKzaGySIg25KxeOmrJ09H6Le7nzfsmN5SZukCCuTIARe6
         xyDw==
X-Gm-Message-State: AOAM531XW4xFL9zI1i5qHxd1qNU66y/ACWS7qPEo3QFzfbJ4tJ1rgNy4
        D2LOddGSOhg0LSqlFDXshQbmYB7gf6nAzy4fT4Xw6fZ+y/2x+E5nm0ns5QwqDrXoA9XQ/TozG6i
        VRZ76m/gjImKoFaFJ9A==
X-Received: by 2002:adf:f704:: with SMTP id r4mr13879917wrp.389.1627475974155;
        Wed, 28 Jul 2021 05:39:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBwPBFLdhkJq8OBYdht9qNvQIxgBrDCuzNOysb/Vo1XYrh6/2bfMLDy3iDKWAOM2A9XgZkVQ==
X-Received: by 2002:adf:f704:: with SMTP id r4mr13879894wrp.389.1627475973976;
        Wed, 28 Jul 2021 05:39:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f26sm6805370wrd.41.2021.07.28.05.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 05:39:33 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] KVM: stats: Support linear and logarithmic
 histogram statistics
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-2-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b6f442e-c8bd-d175-471e-6e28b4548c3e@redhat.com>
Date:   Wed, 28 Jul 2021 14:39:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706180350.2838127-2-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 06/07/21 20:03, Jing Zhang wrote:
> +#define LINHIST_SIZE_SMALL		10
> +#define LINHIST_SIZE_MEDIUM		20
> +#define LINHIST_SIZE_LARGE		50
> +#define LINHIST_SIZE_XLARGE		100
> +#define LINHIST_BUCKET_SIZE_SMALL	10
> +#define LINHIST_BUCKET_SIZE_MEDIUM	100
> +#define LINHIST_BUCKET_SIZE_LARGE	1000
> +#define LINHIST_BUCKET_SIZE_XLARGE	10000
> +
> +#define LOGHIST_SIZE_SMALL		8
> +#define LOGHIST_SIZE_MEDIUM		16
> +#define LOGHIST_SIZE_LARGE		32
> +#define LOGHIST_SIZE_XLARGE		64
> +#define LOGHIST_BASE_2			2

I'd prefer inlining all of these.  For log histograms use 2 directly in 
STATS_DESC_LOG_HIST, since the update function below uses fls64.

> 
> + */
> +void kvm_stats_linear_hist_update(u64 *data, size_t size,
> +				  u64 value, size_t bucket_size)
> +{
> +	size_t index = value / bucket_size;
> +
> +	if (index >= size)
> +		index = size - 1;
> +	++data[index];
> +}
> +

Please make this function always inline, so that the compiler optimizes 
the division.

Also please use array_index_nospec to clamp the index to the size, in 
case value comes from a memory access as well.  Likewise for 
kvm_stats_log_hist_update.

Paolo

