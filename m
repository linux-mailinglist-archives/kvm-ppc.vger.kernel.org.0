Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE85353350C
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 May 2022 03:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243432AbiEYBw0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 21:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243440AbiEYBwU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 21:52:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4C54B40A
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 18:52:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 137so17738296pgb.5
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 18:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i0kR0Ce4v2WokO47YQlNMlHOMCtDXsJLHRKJYXEESG4=;
        b=EIaUwYvdIXek/G6itJNjr91E+CWG5UHdbTPUuZN8/LMJ8JZw1HnCxG+yijW2pqyhyT
         tpxdsj16+0CiFYQ9w/7cNSenKLxof/EODtBsXV7TsxAlnz+fdX88/tBQoyPF3K/APQFB
         6DyEf+f9Kk/XR1OImpUsr7BtTpPMgx7QZ83VzN+6xGY556jMYQaoVxdaFn19/CtzqB5v
         rlz8om/lm0W3JfD/tvtdtTiu7EZa8QIf4TDPGzsUXdyH05i7VWqmpsZwtEsyocXO1zlv
         7WggbA92EUGFaCAcG1ZUHnTv6REKEk59wRo+LDH+fxrms5MA+oEKEWshBGpNg9SauTYU
         9m7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i0kR0Ce4v2WokO47YQlNMlHOMCtDXsJLHRKJYXEESG4=;
        b=394XbNaN+mvs6O9oxhg4mLJ6IuYjoUD3GH4PYpJAi38wMVQ8zYXhltCFzfxPavrKpX
         fsLB4+O2/OoNGfKvXRhhxlmz2ci+sMajVa2VGoGBvs5wb8fRqkrWYa5uco0F0Y6Zio6M
         cgvbHZHVjoHh7FXmube1ic5/m9FrGzNsvKFCRxuQq0LWFvhqMg96iTYGOpxoT8mcRWPl
         qxGH/9yG5s6oBgDovuVr/fg97F/gLtX23/eNsOMF1KewK63sJo+maz4zuhob21QttAI6
         2sDEoBLVP8ZvsX2WRQBoUDapWJQKZ1XrHoD1QOu+KA2B3KEiGQRGneu/6qbbPrVQLD2k
         zGvw==
X-Gm-Message-State: AOAM532Xa5qR5zdfjEv3y8gTNH1LaNIgEm7wxmjdxV7L5dFal9Ls9RV3
        sWP/JueyCc1Xksim/ynFfRifgJ1j1RQHMw==
X-Google-Smtp-Source: ABdhPJxm8a5A8vCsS+KCBryIky2oAH/sUgcf8cm5IJaqFiiKYIHolgU0FmB6hRGxAZogNx894mmAEQ==
X-Received: by 2002:a65:6852:0:b0:3fa:9371:9de with SMTP id q18-20020a656852000000b003fa937109demr7256558pgt.413.1653443528612;
        Tue, 24 May 2022 18:52:08 -0700 (PDT)
Received: from [10.61.2.177] (110-175-254-242.static.tpgi.com.au. [110.175.254.242])
        by smtp.gmail.com with ESMTPSA id p19-20020a1709028a9300b00161a9df4de8sm7855230plo.145.2022.05.24.18.52.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 18:52:07 -0700 (PDT)
Message-ID: <cc19c541-0b5b-423e-4323-493fd8dafdd8@ozlabs.ru>
Date:   Wed, 25 May 2022 11:52:03 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:101.0) Gecko/20100101
 Thunderbird/101.0
Subject: Re: [PATCH kernel] KVM: Don't null dereference ops->destroy
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm-ppc@vger.kernel.org
References: <20220524055208.1269279-1-aik@ozlabs.ru>
 <Yo05tuQZorCO/kc0@google.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <Yo05tuQZorCO/kc0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 5/25/22 06:01, Sean Christopherson wrote:
> On Tue, May 24, 2022, Alexey Kardashevskiy wrote:
>> There are 2 places calling kvm_device_ops::destroy():
>> 1) when creating a KVM device failed;
>> 2) when a VM is destroyed: kvm_destroy_devices() destroys all devices
>> from &kvm->devices.
>>
>> All 3 Book3s's interrupt controller KVM devices (XICS, XIVE, XIVE-native)
>> do not define kvm_device_ops::destroy() and only define release() which
>> is normally fine as device fds are closed before KVM gets to 2) but
>> by then the &kvm->devices list is empty.
>>
>> However Syzkaller manages to trigger 1).
>>
>> This adds checks in 1) and 2).
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>
>> I could define empty handlers for XICS/XIVE guys but
>> kvm_ioctl_create_device() already checks for ops->init() so I guess
>> kvm_device_ops are expected to not have certain handlers.
> 
> Oof.  IMO, ->destroy() should be mandatory in order to pair with ->create().
> kvmppc_xive_create(), kvmppc_xics_create(), and kvmppc_core_destroy_vm() are doing
> some truly funky stuff to avoid leaking the device that's allocate in ->create().

Huh it used to be release() actually, nice:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5422e95103cf9663bc


> A nop/dummy ->destroy() would be a good place to further document those shenanigans.
> There's a comment at the end of the ->release() hooks, but that's still not very
> obvious.

I could probably borrow some docs from here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f868405faf067e8cfb


Thanks for the review! At very least I'll add the dummies.


> The comment above kvmppc_xive_get_device() strongly suggests that keeping the
> allocation is a hack to avoid having to audit all relevant code paths, i.e. isn't
> done for performance reasons.




-- 
Alexey
