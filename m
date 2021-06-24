Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3813B2BA8
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhFXJpA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 05:45:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231984AbhFXJo6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 05:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624527759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyD4vH5kMZavgg+0al23ybbW1mNcrfB3c+Wxr6kYX38=;
        b=Dg09Q1JBF1FT2yGNlpUzg5ZmMVjnOBAvUUr/3l3rEgNzCEWl6NxXAbpZOaTky7eftJRdKJ
        oLpHNwtWiHd3s5w1WybrIvw/U5xAXkcr7IYk7Yf6x3VaO8BxsZglrteqpEmK2bmTaeJjz8
        YWZIaYY8hOjiyj/sr/s0Lnv4p8Zlgy0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-LP80efYVMiqeYY3vzs8JWA-1; Thu, 24 Jun 2021 05:42:38 -0400
X-MC-Unique: LP80efYVMiqeYY3vzs8JWA-1
Received: by mail-ed1-f72.google.com with SMTP id v12-20020aa7dbcc0000b029038fc8e57037so3065341edt.0
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 02:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jyD4vH5kMZavgg+0al23ybbW1mNcrfB3c+Wxr6kYX38=;
        b=fWMtqa4ZsHanvWkEfEX+wRdbo56iKtqgdzl9JQdBJ2txkulQEXvWbwrmG7+DMkyKV4
         IbQU2WSWjzMrW1yHoX1A2VSM4eAYLjPdpWJGxrW9osqO19y9Vh/fTzqo7If8LcKsFGJV
         DsOhJB9LfnwuDYhXbhriK3HxuDMJpPIb9BusA6N1O/pRaWk+tPT+tdXSFJKExsFBGsSb
         hUYQ76im/lr2uZNvZMq62VwtvtowEE1tM2rsI/9vVM7J6MJPK5wPJeT1A4XrOZqkzIvN
         N3oE2uMJ7fmoM6befu8EC8kc43NcEU7zHHgAu2wYUEQlddBaIQMLTnX9dKJa+H3QL1aH
         M7Jg==
X-Gm-Message-State: AOAM530uihFfTXSSqR5NagAJzfWHzN0ABiIj8dyzlTjAEc4Y8jU8uZvQ
        5ZVFck0F4QBC8QSHzWJF2RtcGYr3EDzyBFanSK9Nr+uZTxD9FneQ2KruKZczAOXwK+AYFyN25N/
        rOZNxXQz34P/wQheFCQ==
X-Received: by 2002:a05:6402:54c:: with SMTP id i12mr5909979edx.64.1624527756951;
        Thu, 24 Jun 2021 02:42:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUADYaxbQu5a0ZM6V5UX0tysDgP0Lb+XMxpzsUfVTNQ4yl7MEG7UQrmtC4bLiXvUVljS3Ohw==
X-Received: by 2002:a05:6402:54c:: with SMTP id i12mr5909945edx.64.1624527756727;
        Thu, 24 Jun 2021 02:42:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jz27sm944475ejc.33.2021.06.24.02.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 02:42:35 -0700 (PDT)
Subject: Re: [PATCH 2/6] KVM: mmu: also return page from gfn_to_pfn
To:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-3-stevensd@google.com>
 <1624524331.zsin3qejl9.astroid@bobo.none>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <201b68a7-10ea-d656-0c1e-5511b1f22674@redhat.com>
Date:   Thu, 24 Jun 2021 11:42:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624524331.zsin3qejl9.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 24/06/21 10:52, Nicholas Piggin wrote:
>> For now, wrap all calls to gfn_to_pfn functions in the new helper
>> function. Callers which don't need the page struct will be updated in
>> follow-up patches.
> Hmm. You mean callers that do need the page will be updated? Normally
> if there will be leftover users that don't need the struct page then
> you would go the other way and keep the old call the same, and add a new
> one (gfn_to_pfn_page) just for those that need it.

Needing kvm_pfn_page_unwrap is a sign that something might be buggy, so 
it's a good idea to move the short name to the common case and the ugly 
kvm_pfn_page_unwrap(gfn_to_pfn(...)) for the weird one.  In fact I'm not 
sure there should be any kvm_pfn_page_unwrap in the end.

Paolo

