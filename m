Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF47C47C1D9
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Dec 2021 15:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhLUOsn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Dec 2021 09:48:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232589AbhLUOsl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Dec 2021 09:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640098121;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Po1CD9ebNb27oFA4NxD8Jv9jBdePgnFKbWG3JPgxruU=;
        b=Iifd7q+rzho7xEjjiUrVhd1KuGz9uqWHUbZHuNw9p10CdCfARc05BNnuMPuIuUnQiCa8Hj
        mNfO9/DpiztVhsv/7WzJVPOykmCLEqJdLQOGL98sP5BD7KcAoRySvpM3matePObFfDDBW5
        snVkCcMwzI2TA7bQB73hIOUt1Gt/ljE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-dqIJoC9KNpGP7MlQ8XALSA-1; Tue, 21 Dec 2021 09:48:40 -0500
X-MC-Unique: dqIJoC9KNpGP7MlQ8XALSA-1
Received: by mail-wr1-f72.google.com with SMTP id l9-20020adfa389000000b001a23bd1c661so4758660wrb.6
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Dec 2021 06:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=Po1CD9ebNb27oFA4NxD8Jv9jBdePgnFKbWG3JPgxruU=;
        b=xk0rzupjyL9f6D41zx1YNIlEx3Cgy2sCxICGo11FwFDB7qdenq4lrEy4yM048E5jn7
         u4LKdU9pgRUPlKGEkw/TCiIL0330ZoICrWy3D7BdQgpyKxfKSCeACBTF+x9bC/tPhoCC
         MqwJIbpk6L/jIHIN/R+1IucleFYk/uoduMD4LhzK4qEuQh5b4pm5UPG5QU7OXunyJhI1
         Ed+kSikkq5WckoBDp+WxIIUIABpbXr2ZYGf5bg4s+/fW/zWrfY+nSUtj/+mCCI3YL3ap
         xAHxVaxm6WvuzeIT+09kvuC0kGbD2nJTF+a0GnOX0Gu9xFKWuJ6MSJZgSBJg7+IrsEiY
         zJLw==
X-Gm-Message-State: AOAM531SY+kblBdlYcHQrGwj5ZKN/2nCcKAgBg6m5MEo+kMEZaadA6xh
        l7S6vY7QLKWpn2LGNr5ehY3v7URxe2eAmQGi6eQJxbYQopyy5RuT+WlpNV6ihtO6K0DEdLN26Xd
        UKQL6NpByi+hv/Ycv0eLyA4ATvA9UV77uQCEIeCCC57gX5KmPbilEqwWiu81p6eUVzgQSQhzT
X-Received: by 2002:adf:aa9a:: with SMTP id h26mr2867475wrc.437.1640098118328;
        Tue, 21 Dec 2021 06:48:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqpbyheZzEJO8vD1Cvx8JorX9wdzQV9iphsDeC1LYVbC3LBGcZc5m+cIVA4K0tl4CHjTdZqQ==
X-Received: by 2002:adf:aa9a:: with SMTP id h26mr2867459wrc.437.1640098118095;
        Tue, 21 Dec 2021 06:48:38 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12sm1898081wmq.2.2021.12.21.06.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 06:48:37 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] scripts/arch-run: Mark migration tests as
 SKIP if ncat is not available
To:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm-ppc@vger.kernel.org
References: <20211221092130.444225-1-thuth@redhat.com>
 <ae15b86d-6e4d-78be-74da-845c3ef6b9ba@redhat.com>
 <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <5da99523-9102-ae64-52e8-f081df5976bb@redhat.com>
Date:   Tue, 21 Dec 2021 15:48:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f8d97780-1d58-3dfb-10cc-eb1b8cd0c25a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi,
On 12/21/21 11:12 AM, Thomas Huth wrote:
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
>> easy to debug.  The only disadvantage is that they are harder to write.
>
> I disagree: We're testing migration with QEMU here - the KVM selftests
> don't include QEMU, so we'd lose some test coverage here.
> And at least the powerpc/sprs.c test helped to find some nasty bugs in
> the past already.
I do agree. The ITS migration tests were good reproducer for upstream bugs.

Thanks

Eric
>
>  Thomas
>

