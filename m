Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9654147BDF3
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Dec 2021 11:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhLUKNC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Dec 2021 05:13:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232012AbhLUKNB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Dec 2021 05:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640081581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZWcYFt4dOZiNFHy108ynicEUnLGXxt1oq+4PEwW1O8=;
        b=cH5XVP7MvLfQo5/3IV4juRHKy1WRNYdY0JQsT4xPyUpoYpIT4Ci6gpUUvHKYwG4cv32xVV
        lEkLi8xu6ka4KEhpw2nb4L7HzgcP7BvMOCAzdaObxiE3zA5PiMQWngSovsAnquTCTeKU5l
        H91yKQASfxq1jTkB/cSuRnwQFxBsQ6M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-xYmqohzhOkG7Xibk4XNZaA-1; Tue, 21 Dec 2021 05:13:00 -0500
X-MC-Unique: xYmqohzhOkG7Xibk4XNZaA-1
Received: by mail-wr1-f71.google.com with SMTP id s30-20020adfa29e000000b001a25caee635so4102639wra.19
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Dec 2021 02:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ZWcYFt4dOZiNFHy108ynicEUnLGXxt1oq+4PEwW1O8=;
        b=idnFugtqokWe6VYP0MFKqZ1Lju03qC3lT3REoEqs/OsndsW4qlszOxmI8AErUdIN8R
         Gwje1KdB0gqwxvzwOtmqnqrBZkudQ4Boz1H9gnSs0G8/Iz/HzrwhqIzWZsSZro4unoFl
         r2pIS5ognl4KCTZUcHa3y3dS1dpXTB862DRTcv22nBilQwlQPs65QveWeO6Z6aCnocsj
         2CLhoNbvTxaNDIyjVpHAq0jdqJNbMmAPMvibhSFhNjmkGbnjuwcJZNPyjpuX2j/SO5/l
         xsPFehNEy+39lfh/JYYZYqHiHwy/1fE+2mWN9bLlW+1SiCg86ATqoFe31wRUOwivWTNr
         BKag==
X-Gm-Message-State: AOAM533Ah2ityCFV7Oh5wpcOH5ORPv3Luj0cWYac2yBZhDV0+hiyYD3g
        9mstE6MT2la8MTXLRq9oVnaJbZhg8MDgc1K1Ipq/j3KC+ut35tGkKiPNkwjeT0ph1R8sSwKBU2i
        q4mg5uw5EKgXzVOA9Aw==
X-Received: by 2002:adf:ef81:: with SMTP id d1mr2035069wro.132.1640081577921;
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzt2iiDOniT1iPRYgQvGeFCZZHloWJeydwQM3MmUPjzTemJmeZm8H4bA//9OCzA5aPObc0E4g==
X-Received: by 2002:adf:ef81:: with SMTP id d1mr2035054wro.132.1640081577732;
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id f13sm2144696wmq.29.2021.12.21.02.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 02:12:57 -0800 (PST)
Message-ID: <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
Date:   Tue, 21 Dec 2021 11:12:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 21/12/2021 10.58, Paolo Bonzini wrote:
> On 12/21/21 10:21, Thomas Huth wrote:
>> Instead of failing the tests, we should rather skip them if ncat is
>> not available.
>> While we're at it, also mention ncat in the README.md file as a
>> requirement for the migration tests.
>>
>> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> I would rather remove the migration tests.  There's really no reason for 
> them, the KVM selftests in the Linux tree are much better: they can find 
> migration bugs deterministically and they are really really easy to debug.  
> The only disadvantage is that they are harder to write.

I disagree: We're testing migration with QEMU here - the KVM selftests don't 
include QEMU, so we'd lose some test coverage here.
And at least the powerpc/sprs.c test helped to find some nasty bugs in the 
past already.

  Thomas

