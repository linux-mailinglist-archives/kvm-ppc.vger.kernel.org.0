Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7270B5BEF53
	for <lists+kvm-ppc@lfdr.de>; Tue, 20 Sep 2022 23:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiITVqd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 20 Sep 2022 17:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiITVqc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Sep 2022 17:46:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7151C6612E
        for <kvm-ppc@vger.kernel.org>; Tue, 20 Sep 2022 14:46:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so3767757pjh.3
        for <kvm-ppc@vger.kernel.org>; Tue, 20 Sep 2022 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=7l/du9tda2XXL7FC7D3+ws6V56vBPTifJOsgn5Df51U=;
        b=gOwSfOBbOr0MQjW5J+UipqgY2Yw0uaNGsdreNLLUTDAa9oJvasIrAg0xIqNd6JiCJa
         /lgGQS7Q7nYv6b+T6ZiQMMEBH/BgMj/HFdvRGGgH3smBNXbNaXSmFnTYFomPlG0Z0NGS
         2cenws1/5V21PiPBEdeHsWTCSLNfKNhlCdt/MAYtvkn9gp6c/7PG4lN9X16+DcF5/ij6
         e5f5cdzMkb9SYgvYUAkvx/e+KHrZ57z10+mRwcube170/DdHCki9xJNAnreu6apEm/HG
         zlrEnBZu26IHdG0QI6woc6awnSbNFJ7vtkmuhh2eW8WmicHnxp3rSI+lOebJnCfq36Z3
         sISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=7l/du9tda2XXL7FC7D3+ws6V56vBPTifJOsgn5Df51U=;
        b=B3aM9jpKNn9ztrrGBky22Yx96b1Sa7xH7ao6cBg14Xepc+pVsc/brIjeFoT/b95jIw
         DxINAP3+QGrFtVeOF0kF7NwBOj/WhIjyQ4n260CUPCPM6KbXraMEs0ESX5Ll0RoMpCoe
         j1mb7zS9dZes2kcX3sdUlY16mfYzj3Ga/zC1UvrRa8EQrvNxXld/JGU0AwgBXBoa359H
         7YAOnngDKohKPTKYjN1aZeuuqdJ9H9pLXcsbQpF8NHmIFeYvkA+JPraB6QcZWu0Zm/Nh
         jnsONftX1sh9+rz2gVB48org6eCgAwu+fKkEC2ugz6j3yAE31cJm/bQtiYrq53npKr9l
         Y5Aw==
X-Gm-Message-State: ACrzQf2GjhMIqbHum2Ut8ntYl7yUyb7of2xLqjgEnQPlXeuikFM4YHwI
        /1PLjn12+RX92nF5NOobCL85zw==
X-Google-Smtp-Source: AMsMyM4SuFzhjRKjEs3+Aoh19U+sLXTWgvCFX2DZggzYsKqwvyHbVXt9oLg9ZfwFqHhT7+94CUlpUg==
X-Received: by 2002:a17:902:aa8b:b0:178:8f1d:6936 with SMTP id d11-20020a170902aa8b00b001788f1d6936mr1595515plr.168.1663710388674;
        Tue, 20 Sep 2022 14:46:28 -0700 (PDT)
Received: from [192.168.10.153] (ppp121-45-204-168.cbr-trn-nor-bras38.tpg.internode.on.net. [121.45.204.168])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090332c200b0017834a6966csm367205plr.176.2022.09.20.14.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 14:46:27 -0700 (PDT)
Message-ID: <02490d2a-5e89-f342-f5b3-386406ffb2ea@ozlabs.ru>
Date:   Wed, 21 Sep 2022 07:46:21 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH kernel v2] KVM: PPC: Make KVM_CAP_IRQFD_RESAMPLE support
 platform dependent
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm-riscv@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup@brainfault.org>, kvm-ppc@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>
References: <20220920125143.28009-1-aik@ozlabs.ru>
 <874jx2kp02.wl-maz@kernel.org>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <874jx2kp02.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 21/09/2022 02:08, Marc Zyngier wr
ote:
> On Tue, 20 Sep 2022 13:51:43 +0100,
> Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>>
>> When introduced, IRQFD resampling worked on POWER8 with XICS. However
>> KVM on POWER9 has never implemented it - the compatibility mode code
>> ("XICS-on-XIVE") misses the kvm_notify_acked_irq() call and the native
>> XIVE mode does not handle INTx in KVM at all.
>>
>> This moved the capability support advertising to platforms and stops
>> advertising it on XIVE, i.e. POWER9 and later.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>> [For KVM RISC-V]
>> Acked-by: Anup Patel <anup@brainfault.org>
>> ---
>> Changes:
>> v2:
>> * removed ifdef for ARM64.
> 
> The same argument applies to both x86 and s390, which do select
> HAVE_KVM_IRQFD from the KVM config option. Only power allows this
> option to be selected depending on the underlying interrupt controller
> emulation.
> 
> As for riscv and mips, they don't select HAVE_KVM_IRQFD, and this
> isn't a user-selectable option. So why do they get patched at all?

Before the patch, the capability was advertised on those, with your 
proposal it will stop. Which is a change in behavior which some may say 
requires a separate patch (like, one per platform). I am definitely 
overthinking it though and you are right.

> My conclusion is that:
> 
> - only power needs the #ifdefery in the arch-specific code
> - arm64, s390 and x86 can use KVM_CAP_IRQFD_RESAMPLE without a #ifdef
> - mips and riscv should be left alone

Fair enough, thanks for the review! I'll post v3 shortly.

> 
> Thanks,
> 
> 	M.
> 

-- 
Alexey
