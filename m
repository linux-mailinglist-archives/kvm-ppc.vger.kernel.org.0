Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D4165ACA2
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Jan 2023 01:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjABAnx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 1 Jan 2023 19:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABAnw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 1 Jan 2023 19:43:52 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5125C7
        for <kvm-ppc@vger.kernel.org>; Sun,  1 Jan 2023 16:43:48 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y19so9016988plb.2
        for <kvm-ppc@vger.kernel.org>; Sun, 01 Jan 2023 16:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F4QoSb/fWOPAg1k5IeIPrqcXyDvMYgELY/nQCzCaUW8=;
        b=eJCM1tGrNRNxUZMWE16lv0C43iH8oRjPiOFPEamdTYzMDfga5XZEd5nmaHr7jaf5NW
         s36laxaSoVzQlwOOkJ5mVEopFkkwEeR8t33XG9/opwTCRRdF64XKl8irzjtvfBjZt1zL
         MJYVBgnA10x8/iIWTZzoMvT1aYtGqsNtnliKTvTDPSlBLbM2ic+pdrXFn0fQsUEQfl+D
         KH9tUAPzqLjZb3TgzPzieK7AwVGuBTvDCN+zZzNoLxvzLxZBwDyOKz+IP79udYDapC3F
         Y8FM0az53iVf+SQHFnXOA7AVqLFjr2bT0SHdykl5DxmX3oZiDdaQwrrzUWaO/WWNJqzE
         dxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4QoSb/fWOPAg1k5IeIPrqcXyDvMYgELY/nQCzCaUW8=;
        b=4iq7GAYsnQ+aAyV9KjdSEsn7QmhqP4CQ29RERxv/zVQc23ZX87WAFrSA3QZEloNzsD
         APOL65AUMgRh7xGfT8BnMpxMmzgYAdt6xEWzRpbcn8daeM5Gdrr57+AV8kjWe3tsdpeM
         QEziiLD97mO+fxlGnBovomFQdiGzgoh+NTKP2kgfsLJERLiTiTbhF9MU52mNpDAUzZ1h
         cCjEimRZMkuO9hlaokub1FuleuyZ0Mt8qhRxAW8abMykZdwJ2zHu7/2ectRls19yLhEy
         eD5oD8taWhqQlkaiQZ5KZAuJ8TDI/nwebFNwBEF0dDzQVo82sCaQ6a2jOL06I8JW7soy
         GjCg==
X-Gm-Message-State: AFqh2kqKeSRuHvQIaqJN5Crq1ylrnO4EQkN9f2vf4sM2J06kwXJyrLNF
        k+Go++5C6DwvGkZAD93nuDG87g==
X-Google-Smtp-Source: AMrXdXuzvP/wwe5AzmqaqFsffygkIQ5oV5ALsfR8HbJvtvgLYjKM+6MTfu/2jdgg5Elbz4z4xDI7BA==
X-Received: by 2002:a17:90a:f309:b0:219:9e19:8259 with SMTP id ca9-20020a17090af30900b002199e198259mr42358873pjb.46.1672620227617;
        Sun, 01 Jan 2023 16:43:47 -0800 (PST)
Received: from [192.168.10.153] (ppp118-208-188-115.cbr-trn-nor-bras39.tpg.internode.on.net. [118.208.188.115])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090a1d4700b00225bc0e5f19sm15834468pju.1.2023.01.01.16.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Jan 2023 16:43:46 -0800 (PST)
Message-ID: <cea59fc2-1052-53fd-42b0-ac53f5699aa9@ozlabs.ru>
Date:   Mon, 2 Jan 2023 11:43:40 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH kernel v4] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, Anup Patel <anup@brainfault.org>,
        kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20221003235722.2085145-1-aik@ozlabs.ru>
 <7a790aa8-c643-1098-4d28-bd3b10399fcd@ozlabs.ru>
 <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
In-Reply-To: <5178485f-60d8-0f16-558b-05207102a37e@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Paolo, ping?


On 06/12/2022 15:39, Alexey Kardashevskiy wrote:
> Paolo, ping? :)
> 
> 
> On 27/10/2022 18:38, Alexey Kardashevskiy wrote:
>> Paolo, ping?
>>
>>
>> On 04/10/2022 10:57, Alexey Kardashevskiy wrote:
>>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>>> KVM on POWER9 has never implemented it - the compatibility mode code
>>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>>> XIVE mode does not handle INTx in KVM at all.
>>>
>>> This moved the capability support advertising to platforms and stops
>>> advertising it on XIVE, i.e. POWER9 and later.
>>>
>>> This should cause no behavioural change for other architectures.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>>> Acked-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> Changes:
>>> v4:
>>> * removed incorrect clause about changing behavoir on MIPS and RISCV
>>>
>>> v3:
>>> * removed all ifdeferry
>>> * removed the capability for MIPS and RISCV
>>> * adjusted the commit log about MIPS and RISCV
>>>
>>> v2:
>>> * removed ifdef for ARM64.
>>> ---
>>>   arch/arm64/kvm/arm.c       | 1 +
>>>   arch/powerpc/kvm/powerpc.c | 6 ++++++
>>>   arch/s390/kvm/kvm-s390.c   | 1 +
>>>   arch/x86/kvm/x86.c         | 1 +
>>>   virt/kvm/kvm_main.c        | 1 -
>>>   5 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 2ff0ef62abad..d2daa4d375b5 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -218,6 +218,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>>> long ext)
>>>       case KVM_CAP_VCPU_ATTRIBUTES:
>>>       case KVM_CAP_PTP_KVM:
>>>       case KVM_CAP_ARM_SYSTEM_SUSPEND:
>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>           r = 1;
>>>           break;
>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>>> index fb1490761c87..908ce8bd91c9 100644
>>> --- a/arch/powerpc/kvm/powerpc.c
>>> +++ b/arch/powerpc/kvm/powerpc.c
>>> @@ -593,6 +593,12 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>> *kvm, long ext)
>>>           break;
>>>   #endif
>>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>> +        r = !xive_enabled();
>>> +        break;
>>> +#endif
>>> +
>>>       case KVM_CAP_PPC_ALLOC_HTAB:
>>>           r = hv_enabled;
>>>           break;
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index edfd4bbd0cba..7521adadb81b 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -577,6 +577,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>>> long ext)
>>>       case KVM_CAP_SET_GUEST_DEBUG:
>>>       case KVM_CAP_S390_DIAG318:
>>>       case KVM_CAP_S390_MEM_OP_EXTENSION:
>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>           r = 1;
>>>           break;
>>>       case KVM_CAP_SET_GUEST_DEBUG2:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 43a6a7efc6ec..2d6c5a8fdf14 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -4395,6 +4395,7 @@ int kvm_vm_ioctl_check_extension(struct kvm 
>>> *kvm, long ext)
>>>       case KVM_CAP_VAPIC:
>>>       case KVM_CAP_ENABLE_CAP:
>>>       case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>>> +    case KVM_CAP_IRQFD_RESAMPLE:
>>>           r = 1;
>>>           break;
>>>       case KVM_CAP_EXIT_HYPERCALL:
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 584a5bab3af3..05cf94013f02 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -4447,7 +4447,6 @@ static long 
>>> kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>>   #endif
>>>   #ifdef CONFIG_HAVE_KVM_IRQFD
>>>       case KVM_CAP_IRQFD:
>>> -    case KVM_CAP_IRQFD_RESAMPLE:
>>>   #endif
>>>       case KVM_CAP_IOEVENTFD_ANY_LENGTH:
>>>       case KVM_CAP_CHECK_EXTENSION_VM:
>>
> 

-- 
Alexey
