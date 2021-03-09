Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F665331C05
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Mar 2021 02:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCIBHn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 20:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCIBHQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 20:07:16 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819E2C06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Mar 2021 17:07:16 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id e6so7622642pgk.5
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Mar 2021 17:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Wk1gFwIrxLf+tndudWrI/O2U2AkCABbC1w+8Jve6Q/I=;
        b=JaDOx7HbJudQtPEtCEs6GGJ7g7ZtzTnT6GmnmZtJQzLanHfB49LhYRkF6yQM+XDudH
         A8ZT0ef5wfUpPaACOcwcujLpSyQIkeppZQdclxxdCFNF3/cCBMbssk7EbW92Gro+rb0r
         UNndRyZXpqFWRPkaOFZK6dR8QoRBo3T/LxlwAIkoV9IxUsEaQJMz/4Nlor1tOGf6Ntjz
         /P+LSKdgj82rg9cfWODJW5Doj18oYwxgiV1mjznqQBsuhNZq2hVunZCP6ddnLfMtfbWV
         /ve76hZrBlZY9D8PU/NHxY1YGBHqY5QxbaWdLohjauYYIDeHlbvoALnoNxnNF+V4qg67
         mFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Wk1gFwIrxLf+tndudWrI/O2U2AkCABbC1w+8Jve6Q/I=;
        b=RTXmq8HVXi9Be68uVGF9OS305pH1hYJRcTs/zjHur35HfKYUZMQ3UMq1373bI0A0KD
         G1fPAZFYqFEoIYUTOcUfZ+cn4MTmqLBoyO2XZ9Y/C+DXLvIev4TIWsMsWPM/lUYuYlXs
         U+ioC8TLnCGYI1MXBCTbhJdxvQKxOa6tvaEmKUaAW/Kf9d2ht3iRn0R6mkAGMXKQzrTA
         f1kWYNfWfrA3fXcbdwUtOU/G5z9ODdx+EebBLMH8c4NgpNJIspwK+9Up0fL9FniWd7GC
         bRNwkm40jh6Fht63iQGh0j6flXsxelRv5VHoRsUeCBvwj41HHo5SMh49DRfm32bfA1fN
         A8xQ==
X-Gm-Message-State: AOAM532FwIIhLvjXXd4yoRbIDFSXEG7kfINYYzBIItHK02aov0bqKQaY
        5zp8cTPcZlZfee2mCegq1k2uB2/acO4=
X-Google-Smtp-Source: ABdhPJz8PNWozzV4nHM4WDieKH5ZfHtUk5b13eum5F6lFnMGET4J7Bl4puV8MQr/qIpGU0iCIG/VtA==
X-Received: by 2002:aa7:8ad5:0:b029:1df:5a5a:80e1 with SMTP id b21-20020aa78ad50000b02901df5a5a80e1mr23459375pfd.52.1615252036077;
        Mon, 08 Mar 2021 17:07:16 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id s27sm10687329pgk.77.2021.03.08.17.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 17:07:15 -0800 (PST)
Date:   Tue, 09 Mar 2021 11:07:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Do not expose HFSCR sanitisation to
 nested hypervisor
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210305231055.2913892-1-farosas@linux.ibm.com>
        <1615191200.1pjltfhe7o.astroid@bobo.none> <87eegpn0un.fsf@linux.ibm.com>
In-Reply-To: <87eegpn0un.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1615250895.ey7uv2nfuf.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 9, 2021 1:04 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> Excerpts from Fabiano Rosas's message of March 6, 2021 9:10 am:
>>> As one of the arguments of the H_ENTER_NESTED hypercall, the nested
>>> hypervisor (L1) prepares a structure containing the values of various
>>> hypervisor-privileged registers with which it wants the nested guest
>>> (L2) to run. Since the nested HV runs in supervisor mode it needs the
>>> host to write to these registers.
>>>=20
>>> To stop a nested HV manipulating this mechanism and using a nested
>>> guest as a proxy to access a facility that has been made unavailable
>>> to it, we have a routine that sanitises the values of the HV registers
>>> before copying them into the nested guest's vcpu struct.
>>>=20
>>> However, when coming out of the guest the values are copied as they
>>> were back into L1 memory, which means that any sanitisation we did
>>> during guest entry will be exposed to L1 after H_ENTER_NESTED returns.
>>>=20
>>> This is not a problem by itself, but in the case of the Hypervisor
>>> Facility Status and Control Register (HFSCR), we use the intersection
>>> between L2 hfscr bits and L1 hfscr bits. That means that L1 could use
>>> this to indirectly read the (hv-privileged) value from its vcpu
>>> struct.
>>>=20
>>> This patch fixes this by making sure that L1 only gets back the bits
>>> that are necessary for regular functioning.
>>
>> The general idea of restricting exposure of HV privileged bits, but
>> for the case of HFSCR a guest can probe the HFCR anyway by testing which=
=20
>> facilities are available (and presumably an HV may need some way to know
>> what features are available for it to advertise to its own guests), so
>> is this necessary? Perhaps a comment would be sufficient.
>>
>=20
> Well, I'd be happy to force them through the arduous path then =3D);

That's not a very satisifying justification.

> and
> there are features that are emulated by the HV which L1 would not be
> able to probe.

It should be able to trivially by measuring timing.

>=20
> I think we should implement a mechanism that stops all leaks now, rather
> than having to ponder about this every time we touch an hv_reg in that
> structure.

This does not follow. There is already a "leak" via a timing or faulting=20
side channel, so by definition we can't stop all leaks just by filtering=20
the register value.

So what we need to do first I think is define what the threat is. What=20
is the problem with the L1 knowing what the HFSCR is? If we can identify
a threat then we would appear to have much bigger problems. If not, then
this change can not be justified on the basis of security AFAIKS.

> I'm not too worried about HFSCR specifically.

HFSCR is pretty special because its behaviour makes it quite trivial to
extrapolate. It also has the fault cause bits in it that aren't being
sanitised either so that would have to be thought about.

> Let me think about this some more and see if I can make it more generic,
> I realise that sticking the saved_hfscr on the side is not the most
> elegant approach.

I would say returning an error from the hcall if the caller tries to=20
enable an HFSCR bit that it's not allowed to would be the easiest
approach. At least then a well meaning but optimistic guest won't try
to enable and advertise missing features to its nested guests and have
them crash strangely, rather it would just stop up front.

I don't think trying to obscure HFSCR in general will ever be possible=20
though.

Thanks,
Nick
