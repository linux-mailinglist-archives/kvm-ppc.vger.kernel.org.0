Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10332325D48
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Feb 2021 06:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZFp2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 00:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhBZFp2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 00:45:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01E7C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:44:47 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id a4so5555106pgc.11
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 21:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=E/dfagB4FaG4H2fCz24vVII4im/B44PZDtiXI570grU=;
        b=A5KVh2kKRgNRTjIZanwgr4I0zLaNYz+l4K8cZlpLknBHHs/8lzXfineS6EgtyHJyCK
         tonT4LUtOZEigF0UBUBj0D4OCH3oPpAkyceZl85i8H9OIFdltN8KAy7WRaFdCV6hsW6y
         iNLjCVZu5ul/FsSwNWe2t5d+CLugy1vSmIPQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=E/dfagB4FaG4H2fCz24vVII4im/B44PZDtiXI570grU=;
        b=kR/ZlDw6UX4C7HYLTFa/boFGUvP8scIJS4385um8TpwNj9WWhLe2QOPJXjixKyv/4P
         ljpz2LEreFNA4MONTV6CQ4gqWJcCZ7EsFKrlCPpxAjRfIiIOLoZANvFvAoGDB43/jv+k
         jvfEwFd/fMseuagodMeE94EobCSQ0LA6MeyJk5GJ2iZHICYOWcW1Ib0TGMISt3IMUNdp
         JoDeDT87iyD9/Cq6i0+H6ScY2bQvr0yecyU0ZtrYfTxSc9r1LpnSzxLEH+5lXOWVjOIt
         Am/TtBepmW4S1EQ5MZPKsw57SFc02dwKQOxAS2UY11v2xXf1qaQY5fmAozOcC1dSuZ4/
         9ktg==
X-Gm-Message-State: AOAM532I5Gx3zDC6Sq5IdxAbIS6PiyRZSd3aYoWAa+eMsaKMBIf6BlYd
        yluyb9VMshpZra4Vw7l9SKRMCKjGcdyz5s73
X-Google-Smtp-Source: ABdhPJwVMnjoMt72/ETIQr7b7Q2dwRDbkG/lb415Nm/jLHog2PYuZIsYRMlxff9LXLs4nPwtJHyVkA==
X-Received: by 2002:aa7:88c7:0:b029:1d1:4f1f:5fb6 with SMTP id k7-20020aa788c70000b02901d14f1f5fb6mr1647850pff.14.1614318287301;
        Thu, 25 Feb 2021 21:44:47 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-7ad2-5bb3-4fd4-d737.static.ipv6.internode.on.net. [2001:44b8:1113:6700:7ad2:5bb3:4fd4:d737])
        by smtp.gmail.com with ESMTPSA id u3sm8772342pfm.144.2021.02.25.21.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 21:44:46 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v2 04/37] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
In-Reply-To: <20210225134652.2127648-5-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com> <20210225134652.2127648-5-npiggin@gmail.com>
Date:   Fri, 26 Feb 2021 16:44:39 +1100
Message-ID: <8735xj9yd4.fsf@linkitivity.dja.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> The code being executed in KVM_GUEST_MODE_SKIP is hypervisor code with
> MSR[IR]=0, so the faults of concern are the d-side ones caused by access
> to guest context by the hypervisor.
>
> Instruction breakpoint interrupts are not a concern here. It's unlikely
> any good would come of causing breaks in this code, but skipping the
> instruction that caused it won't help matters (e.g., skip the mtmsr that
> sets MSR[DR]=0 or clears KVM_GUEST_MODE_SKIP).

I'm not entirely clear on the example here, but the patch makes sense
and I can follow your logic for removing the IKVM_SKIP handler from the
instruction breakpoint exception.

On that basis:
Reviewed-by: Daniel Axtens <dja@axtens.net>

Kind regards,
Daniel

>
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index a027600beeb1..0097e0676ed7 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -2553,7 +2553,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
>  INT_DEFINE_BEGIN(instruction_breakpoint)
>  	IVEC=0x1300
>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> -	IKVM_SKIP=1
>  	IKVM_REAL=1
>  #endif
>  INT_DEFINE_END(instruction_breakpoint)
> -- 
> 2.23.0
