Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DDB34FD3B
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 11:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhCaJlh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 05:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234933AbhCaJlL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 05:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617183670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
        b=RI1K6Fssqt7hUlhyzbMKI4QBb13TuCj0sR1qxdT2zpsJX5eEBTwH41nrGg66jFIFLks5cj
        wCA6xSTfgSkES/2Pm4VJzUOZgswA9oFGBYwpb5jxIlH51xia4Lg1awqDbGr1lQIba67LE1
        H3Cr9eOiXaYTJa6fel6vf9JWsjenQoY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-u1M4M-LEOPCz8l3VZnOeJw-1; Wed, 31 Mar 2021 05:41:08 -0400
X-MC-Unique: u1M4M-LEOPCz8l3VZnOeJw-1
Received: by mail-ej1-f70.google.com with SMTP id fy8so534320ejb.19
        for <kvm-ppc@vger.kernel.org>; Wed, 31 Mar 2021 02:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=13ETPGXsf76nLgxQSYUcOfnDRwF5dXOwh3DpIOsgydE=;
        b=rbclDGB3WTXuttBhDusAJbu5IhX+Up9q8mE/wdN3ohnYYpLFcKWklG4aP7SyR4+NfZ
         ZcR2xqu3PZZULsk3XQ+9sMlk03qJ+0vQEeioM8pQDhuy4cx5xtamf3st9wRKsoti7tIf
         aZQREJ1e/VVRz9iURvUiyqefzIdK4mtM3ZAwM+bsHVmfqnSIZjt5H02QmGVK/N5KYbzr
         CocSWGXKB13+vadjolwv4sRLIqBOtSQzzGTdPSeT5SZhTp9nu8W0rFDbn3KDfN2L2ilj
         RumrFC0mZmboMXkUB6dNB96u/9Mc46kbJDUFOOH6fxwqnOKephRSgQQWD5kCCJ/npj2H
         82Bg==
X-Gm-Message-State: AOAM5308cBo3fKCkw3Yzn6T2mPXbQgLdl5DkgGWpT32XEc38yd1cHH3H
        e1frGUnoc9SE445lY/d3HOQ6EJ1iTYhvqc7ElC8UoaLjsfFuAuiKgYBq3rz8XkrlrmSXf2nE2Pf
        3embN6ZmXCFPdemEr5Q==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr2580924ejg.418.1617183667249;
        Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSsS0Tsx00ZWZ0/lu50AT1LbGXR9x8m5wdROjQWRD+Wcg6SCBEWtjgSLJ9LavhsubZOMOLAQ==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr2580906ejg.418.1617183667053;
        Wed, 31 Mar 2021 02:41:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id t15sm1151761edc.34.2021.03.31.02.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 02:41:05 -0700 (PDT)
Subject: Re: [PATCH 00/18] KVM: Consolidate and optimize MMU notifiers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <a2ca8cb2-5c91-b971-9b6e-65cf9ee97ffa@redhat.com>
 <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <569a089e-471f-8182-cdb2-74188f0cc81d@redhat.com>
Date:   Wed, 31 Mar 2021 11:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <e50f6f28c0446cd328e475859ef05dc4@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 31/03/21 11:34, Marc Zyngier wrote:
> 
>> Queued and 1-9 and 18, thanks.  There's a small issue in patch 10 that
>> prevented me from committing 10-15, but they mostly look good.
> 
> Can you please push the resulting merge somewhere?
> 
> I'm concerned that it will conflict in interesting way with other stuff
> that is on its way on the arm64 side, not to mentiobn that this hasn't
> been tested at all on anything but x86 (and given the series was posted
> on Friday, that's a bit of a short notice).

Yes, I will push it shortly to kvm/queue.  Note that the patches I have 
pushed are x86 only apart from changes to tracepoints.  The rest will 
certainly need a lot more baking, which is also why I got rid quickly of 
the easy ones.

Paolo

