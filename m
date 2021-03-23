Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66E345B55
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 10:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCWJta (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 05:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhCWJtD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 23 Mar 2021 05:49:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3196C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 02:49:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so9894895pjb.2
        for <kvm-ppc@vger.kernel.org>; Tue, 23 Mar 2021 02:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=c1kuMFGWEbTOeFhDqSYJCZMejdonWc5t7uysZdJ61Xg=;
        b=dCwBg30eq7kvsgo/KtoSqLNtbWKmVgtrpPAwvBXo1gnVhDObcOBvp0TsB/tXB0WKsG
         N9F1Y4uCPGm5Tw/mj409OgYFHHwqIzbjT97f4zKHRPierYL5pOYvT/6dGbSgE0xCRJuR
         t1lA0LJYXBwyFqgppJh3iQLkTaxJmDfOUKDCDVZ2vgtzB1vSp6IQSDrhjdlZxlE/USAs
         XDXZcoWoyMO27OuvBRHFCLl+qwv+C+82ZmNrW/V+7GXBC9EOQcznUmmtdT1dBAUE16Ds
         mDCi2IICdzBPz/4Nj9yOse0QbsugBJyvZEdMI3yGMH3rxn/08FS3FrYsrHUDBNCzH0Zk
         BX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=c1kuMFGWEbTOeFhDqSYJCZMejdonWc5t7uysZdJ61Xg=;
        b=WOLF1/0CKEGU66qnQQpUbP9pcTRcusxc1b6aDrj0CqRK3j9/4Q8u5b2NzKzqEZ0M0S
         Sdzhw7inSi8A8oVRZlWVEqwsVeIFhNubjZDs2VGwnuYP1l60S12YlUrNbWhlekKf5qtP
         8FvnSpnATF28ZIVL39S11hqrMYHQ5CNYwww6R40pBcq08xb7Nw3hXOaX+3Kcna3/JRl3
         g08IVRwc8XyKmYLFUD9ciGj/dbhXegzBohV6HR8xtSxW2EkW9k45q7g0GBjbtlrFpDUN
         PW8uV91FtMv4DBCCxGFOdolGaNS6BDtzYYi2HN+Bfy2f8cUfz5vepHtatMXZc9JpSws5
         CFRQ==
X-Gm-Message-State: AOAM530lbZyeV+jmvk2izs7gZy/wZHHqIqzTQ/JkoQ4QzAPDzcy6BGXx
        h/3mD4BkTA9V7GcQvGKULc4=
X-Google-Smtp-Source: ABdhPJwTA/SMB23drVhANK+kBQOX7U1rMdAEfO8vZlCydkn8E2Fd4H7asUOKskWbdhNlVCco9RxEkg==
X-Received: by 2002:a17:90a:d801:: with SMTP id a1mr3761057pjv.84.1616492943289;
        Tue, 23 Mar 2021 02:49:03 -0700 (PDT)
Received: from localhost ([1.132.174.211])
        by smtp.gmail.com with ESMTPSA id q95sm2255130pjq.20.2021.03.23.02.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 02:49:02 -0700 (PDT)
Date:   Tue, 23 Mar 2021 19:48:57 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 22/46] KVM: PPC: Book3S HV P9: Stop handling hcalls in
 real-mode in the P9 path
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210323010305.1045293-1-npiggin@gmail.com>
        <20210323010305.1045293-23-npiggin@gmail.com>
        <6901d698-f3d8-024b-3aa1-47b157bbd57d@ozlabs.ru>
        <1616490842.v369xyk7do.astroid@bobo.none>
        <994fb056-4445-4301-faca-b53394fb6b35@ozlabs.ru>
In-Reply-To: <994fb056-4445-4301-faca-b53394fb6b35@ozlabs.ru>
MIME-Version: 1.0
Message-Id: <1616492251.gsmvgdqq5o.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Alexey Kardashevskiy's message of March 23, 2021 7:24 pm:
>=20
>=20
> On 23/03/2021 20:16, Nicholas Piggin wrote:
>> Excerpts from Alexey Kardashevskiy's message of March 23, 2021 7:02 pm:
>>>
>>>
>>> On 23/03/2021 12:02, Nicholas Piggin wrote:
>>>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kv=
m/book3s_hv_rmhandlers.S
>>>> index c11597f815e4..2d0d14ed1d92 100644
>>>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>>>> @@ -1397,9 +1397,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>>>>    	mr	r4,r9
>>>>    	bge	fast_guest_return
>>>>    2:
>>>> +	/* If we came in through the P9 short path, no real mode hcalls */
>>>> +	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
>>>> +	cmpwi	r0, 0
>>>> +	bne	no_try_real
>>>
>>>
>>> btw is mmu on at this point? or it gets enabled by rfid at the end of
>>> guest_exit_short_path?
>>=20
>> Hash guest it's off. Radix guest it can be on or off depending on the
>> interrupt type and MSR and LPCR[AIL] values.
>=20
> What I meant was - what do we expect here on p9? mmu on? ^w^w^w^w^w^w^w^w=
^w

P9 radix can be on or off. If the guest had MSR[IR] or MSR[DR] clear, or=20
if the guest is running AIL=3D0 mode, or if this is a machine check,=20
system reset, or HMI interrupt then the MMU will be off here.

> I just realized - it is radix so there is no problem with vmalloc=20
> addresses in real mode as these do not use top 2 bits as on hash and the=20
> exact mmu state is less important here. Cheers.

We still can't use vmalloc addresses in real mode on radix because they=20
don't translate with the page tables.

Thanks,
Nick
