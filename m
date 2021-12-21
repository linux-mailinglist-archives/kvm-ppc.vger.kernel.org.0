Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9323947C4FC
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Dec 2021 18:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhLURZg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Dec 2021 12:25:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231292AbhLURZf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Dec 2021 12:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640107535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpMAKTPI9NtZbIkMOT0OjSfsB3dq7tMKVr95wUp0KCk=;
        b=bf/I8JURNARNAmEapJbL2CXWXo5/WFDSadaTZRdVTCNYrAU1QGWvQPEkuCXhFEI1BpU7Kq
        Tua2FJEk879ZQzY97FxqKYzrYotaZQNuxedMSrpx5JDgzmccYLvxk3UotdFqIuaaqyNji7
        NqUT6FL9Nro5A3IabtC1tq2+yqs9NKQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-CrVNTVAMM76dPx45hwcQug-1; Tue, 21 Dec 2021 12:25:33 -0500
X-MC-Unique: CrVNTVAMM76dPx45hwcQug-1
Received: by mail-wm1-f72.google.com with SMTP id 69-20020a1c0148000000b0033214e5b021so3029246wmb.3
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Dec 2021 09:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bpMAKTPI9NtZbIkMOT0OjSfsB3dq7tMKVr95wUp0KCk=;
        b=KDkNuZrvbAAtkz1nOVBVWG5KJLfNp4VPXvXkf3wnEy5MsRdSC8O4yk0p2Okcfca/Ij
         gJfhwWlVv419HjRWt07G8NsNNKQPfePhOqJl1Z5I0ME6RYS2EC4+pYtu79v+8s25zc3F
         6h/SuAFCq9F+uqdsJSo+sco75nRdYgbMiFSMKsL9CsqmywJrZZw0zGv8ADremqgh4bxI
         P+pvNybZ3Ef0n6pMLXJ3YPkn/rgg5pyEf8Zc/p/zz5jPElCzgMblouTHXixq6REdmucR
         0MYEtmY6s/8gowNpdRWoSWjeFuUBNcjSz1AO9LeyrsGoomnAeRwMh9PTeuAIBiDGrZmx
         j95g==
X-Gm-Message-State: AOAM531qVQXgXvDeg2o5hCM2F1RX4tb782j3jH1IPY4AisXS2nxLfpGC
        O+AJCqpVVZlYyk+cJPAb+Sqzwl3yYCVGEg3IdGd8U3qKjrF0rUZP4IRceLG98aR1ZbjnOkbi3dE
        /KadqWo3+qyru/tqy3w==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr3563597wmj.117.1640107532498;
        Tue, 21 Dec 2021 09:25:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxn98hSTsTiU6xkhBq04DmmPCoKBPrX0VAlZIsbWZ8NWz/sDBAVPuXIc3JRaD2wYbHKO7989Q==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr3563585wmj.117.1640107532312;
        Tue, 21 Dec 2021 09:25:32 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c7sm22285422wrq.81.2021.12.21.09.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:25:31 -0800 (PST)
Message-ID: <a53a5e76-1bc7-075a-f644-2eded9963554@redhat.com>
Date:   Tue, 21 Dec 2021 18:25:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
 <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 12/21/21 11:12, Thomas Huth wrote:
> On 21/12/2021 10.58, Paolo Bonzini wrote:
>> On 12/21/21 10:21, Thomas Huth wrote:
>>> Instead of failing the tests, we should rather skip them if ncat is
>>> not available.
>>> While we're at it, also mention ncat in the README.md file as a
>>> requirement for the migration tests.
>>>
>>> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/4
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>
>> I would rather remove the migration tests.  There's really no reason 
>> for them, the KVM selftests in the Linux tree are much better: they 
>> can find migration bugs deterministically and they are really really 
>> easy to debug. The only disadvantage is that they are harder to write.
> 
> I disagree: We're testing migration with QEMU here - the KVM selftests 
> don't include QEMU, so we'd lose some test coverage here.
> And at least the powerpc/sprs.c test helped to find some nasty bugs in 
> the past already.

I understand that this is testing QEMU, but I'm not sure that testing 
QEMU should be part of kvm-unit-tests.  Migrating an instance of QEMU 
that runs kvm-unit-tests would be done more easily in avocado-vt or 
avocado-qemu.

Paolo

