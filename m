Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C71253358D
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 04:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiEYC6v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 22:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiEYC6u (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 22:58:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC112ED74
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 19:58:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u12-20020a17090a1d4c00b001df78c7c209so517892pju.1
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 19:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=YK1wCpCRboLwffskekgnWbUl6nIZlpuhCNf3mYDZPpU=;
        b=PtpIRRwFj/q816SmM7zw1Hnj7L8SNrWSU1anLslWGSwN0KfueD4j20tJvQYYyYPMZ7
         Lx5J1me79HRChl2o6oWtGKZJxIoOPFG2yECi5qX2r6RPrVJbK7RTB9mZ++tO/mcZCuqS
         8EXUFDXUl/bicPsb6EzbTfeYRBdQ44H/cseK3JOlgHBk0iapBu5aB2AU2JSXq0gMPQTQ
         n20j+4uEpqHPFD2uFLkP6bWq43rT+WaMJqRqcW6v9Q84Wm7Un6mSSsJKN7nssA3vyMXa
         wGcllgKlchS+8BIF2KxwQsR+GX9UOecqHDsGsFfmKb2YRNkwLx3KUPl+2dFRx/DMnMtJ
         VM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YK1wCpCRboLwffskekgnWbUl6nIZlpuhCNf3mYDZPpU=;
        b=AuxMHVazfDMEndn2GPOD8b9D6viQa+4uMUIqQbEDj3iyehRHSQ5573w6i+q6Gnr9i+
         x/LSqFNbyIhZ7d4zhCuT+TR0ZPwIxjgEeW90c0LL1aqbSUIXZEcRfoOJvLm8l71Yq3L3
         QY5Mhg0EHdYS2hXhvjdY0MozNZK83gqmypv8OymTOJLzCISilesnNcPRBd45Txbitqwp
         sJ7wywNqMGod2I7eaIAesX3T+mcMqUFHoCNrNy7ZDRoWgNpLoC8L09ICRt5p6G8twaTc
         nMKb3B1X1jt2Qgh8LJZ1dH6M/lJtTzTKDonUwwr0zlfq4p+DP2pYeEptpQfViTqDA56n
         1B1g==
X-Gm-Message-State: AOAM530bVPHScRpK+pSZIS30i1rBC9OaqnaMN2TmiTxJaXztqS4Nxi0m
        FjRNrJRkR0NiYxnBGlLwb6s0D3o3JevnPw==
X-Google-Smtp-Source: ABdhPJwEYgmMAy7wgZWt09CThY9XrTxAbiuM8JQFI5KtQXXlfe79I0fwyydxqgVJ3pr+knW4+NKw5w==
X-Received: by 2002:a17:90b:1c92:b0:1dd:10ff:8f13 with SMTP id oo18-20020a17090b1c9200b001dd10ff8f13mr7860126pjb.54.1653447527364;
        Tue, 24 May 2022 19:58:47 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id l17-20020a629111000000b0050dc76281ccsm9926630pfe.166.2022.05.24.19.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 19:58:46 -0700 (PDT)
Message-ID: <6d291eba-1055-51c3-f015-d029a434b2c0@ozlabs.ru>
Date:   Wed, 25 May 2022 12:58:41 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101
 Thunderbird/101.0
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20220524055208.1269279-1-aik@ozlabs.ru>
 <Yo05tuQZorCO/kc0@google.com>
 <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
In-Reply-To: <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 5/25/22 11:52, Alexey Kardashevskiy wrote:
> 
> 
> On 5/25/22 06:01, Sean Christopherson wrote:
>> On Tue, May 24, 2022, Alexey Kardashevskiy wrote:
>>> There are 2 places calling kvm_device_ops::destroy():
>>> 1) when creating a KVM device failed;
>>> 2) when a VM is destroyed: kvm_destroy_devices() destroys all devices
>>> from &kvm->devices.
>>>
>>> All 3 Book3s's interrupt controller KVM devices (XICS, XIVE, 
>>> XIVE-native)
>>> do not define kvm_device_ops::destroy() and only define release() which
>>> is normally fine as device fds are closed before KVM gets to 2) but
>>> by then the &kvm->devices list is empty.
>>>
>>> However Syzkaller manages to trigger 1).
>>>
>>> This adds checks in 1) and 2).
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>>
>>> I could define empty handlers for XICS/XIVE guys but
>>> kvm_ioctl_create_device() already checks for ops->init() so I guess
>>> kvm_device_ops are expected to not have certain handlers.
>>
>> Oof.  IMO, ->destroy() should be mandatory in order to pair with 
>> ->create().


After reading
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2bde9b3ec8bdf60788e9e 
and neighboring commits, it sounds that each create() should be paired 
with either destroy() or release() but not necessarily both.

So I'm really not sure dummy handlers is a good idea. Thanks,


>> kvmppc_xive_create(), kvmppc_xics_create(), and 
>> kvmppc_core_destroy_vm() are doing
>> some truly funky stuff to avoid leaking the device that's allocate in 
>> ->create().
> 
> Huh it used to be release() actually, nice:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5422e95103cf9663bc
> 
> 
>> A nop/dummy ->destroy() would be a good place to further document 
>> those shenanigans.
>> There's a comment at the end of the ->release() hooks, but that's 
>> still not very
>> obvious.
> 
> I could probably borrow some docs from here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f868405faf067e8cfb
> 
> 
> Thanks for the review! At very least I'll add the dummies.
> 
> 
>> The comment above kvmppc_xive_get_device() strongly suggests that 
>> keeping the
>> allocation is a hack to avoid having to audit all relevant code paths, 
>> i.e. isn't
>> done for performance reasons.




-- 
Alexey
