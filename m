Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAD31197E
	for <lists+kvm-ppc@lfdr.de>; Sat,  6 Feb 2021 04:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhBFDIU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Feb 2021 22:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhBFDD4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Feb 2021 22:03:56 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6182C061788;
        Fri,  5 Feb 2021 19:03:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id lw17so7404027pjb.0;
        Fri, 05 Feb 2021 19:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=P8M5D06zGz+PP013NXW7T63SHqKN6IjGe2PJ8tjT/2M=;
        b=XHE7VzBeJ2VyZCPQMDaisRZpClsmtX217Q8Cgdwx9ko69Fi5QbynKNqxgLWUpM2bky
         WPB7UTigD2ob9uxRdLQykZwyfhwJgAjCoCHwLgn8UvkvjpcrEipfcVa7z+7g5jwlz6eP
         UFyncS8wiBBC6pYf+M7/FizQjhrofvnnvaUHHS/y7wuK99w9cc6VpTw4tvXDCQNjlGW1
         vn8FTnp7Wd790YaVImg3dSIDExL/78UXbmBlYk5KNeuvkd8B0stdiMpxneFbaqkr1xsi
         F/vxjHdZHXsnp2p7RpsaObZBaLeu1mbnXDqcFR2XGqCNXDMpcZoy5rhqQvUW2qy7mmuc
         eW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=P8M5D06zGz+PP013NXW7T63SHqKN6IjGe2PJ8tjT/2M=;
        b=YQ3eihPsCKKGFXgwxsIzhPkK4HXwhK81LiTup034omVWkCGxNRWZaEP9U3A/DP+TKM
         LwK2R1qEU77oPJ9kPVacGTPvkhRGnor5M4/VFQbLnXzqZmLv1lP+DLGzqNXBQusn+nEv
         ETOMIJqIg5IRkZIjk81iU2KKIOZE1yvjFLBpCmCryQmsFY6YyQkYNhsl97Fz1PffVo47
         33oObJchVt7/5biIA98ORvFAlnpNfyFs4DIrS7PlQpAcF7WzwdOFaFheOvtvdPz/UkOb
         D/sSwDRLhTHDuZGsveQJvAHs1P2gBMT2yPb1ToTsh9cqQ6p7SemKoTysxnwtJmkH1mTI
         bo1g==
X-Gm-Message-State: AOAM531KHzKYaMs1rlBCpigJvSINJ1+Ej/6UOgLmbxNLuWwnmX5ay5bm
        w87nZsJaaQw+1nGMMuNNVp4=
X-Google-Smtp-Source: ABdhPJxJDmx9MXlvGvNPHaf7pRRBEVl8C9+Widbx/vQIGpAMgg0BZtVlJlGx3r9B0aHF0Ng4b2qBIQ==
X-Received: by 2002:a17:90a:4a84:: with SMTP id f4mr7094787pjh.231.1612580595381;
        Fri, 05 Feb 2021 19:03:15 -0800 (PST)
Received: from localhost (60-242-11-44.static.tpgi.com.au. [60.242.11.44])
        by smtp.gmail.com with ESMTPSA id x4sm3135012pfm.64.2021.02.05.19.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 19:03:14 -0800 (PST)
Date:   Sat, 06 Feb 2021 13:03:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 1/1] powerpc/kvm: Save Timebase Offset to fix
 sched_clock() while running guest code.
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Weisbecker <frederic@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jordan Niethe <jniethe5@gmail.com>,
        Leonardo Bras <leobras.c@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20210205060643.233481-1-leobras.c@gmail.com>
        <1612506268.6rrvx34gzu.astroid@bobo.none>
        <7e231b91e41c3f3586ba2fd604c40f1716db228d.camel@gmail.com>
In-Reply-To: <7e231b91e41c3f3586ba2fd604c40f1716db228d.camel@gmail.com>
MIME-Version: 1.0
Message-Id: <1612579579.ztbklit4un.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Leonardo Bras's message of February 5, 2021 5:01 pm:
> Hey Nick, thanks for reviewing :)
>=20
> On Fri, 2021-02-05 at 16:28 +1000, Nicholas Piggin wrote:
>> Excerpts from Leonardo Bras's message of February 5, 2021 4:06 pm:
>> > Before guest entry, TBU40 register is changed to reflect guest timebas=
e.
>> > After exitting guest, the register is reverted to it's original value.
>> >=20
>> > If one tries to get the timestamp from host between those changes, it
>> > will present an incorrect value.
>> >=20
>> > An example would be trying to add a tracepoint in
>> > kvmppc_guest_entry_inject_int(), which depending on last tracepoint
>> > acquired could actually cause the host to crash.
>> >=20
>> > Save the Timebase Offset to PACA and use it on sched_clock() to always
>> > get the correct timestamp.
>>=20
>> Ouch. Not sure how reasonable it is to half switch into guest registers=20
>> and expect to call into the wider kernel, fixing things up as we go.=20
>> What if mftb is used in other places?
>=20
> IIUC, the CPU is not supposed to call anything as host between guest
> entry and guest exit, except guest-related cases, like

When I say "call", I'm including tracing in that. If a function is not=20
marked as no trace, then it will call into the tracing subsystem.

> kvmppc_guest_entry_inject_int(), but anyway, if something calls mftb it
> will still get the same value as before.

Right, so it'll be out of whack again.

> This is only supposed to change stuff that depends on sched_clock, like
> Tracepoints, that can happen in those exceptions.

If they depend on sched_clock that's one thing. Do they definitely have=20
no dependencies on mftb from other calls?

>> Especially as it doesn't seem like there is a reason that function _has_
>> to be called after the timebase is switched to guest, that's just how=20
>> the code is structured.
>=20
> Correct, but if called, like in rb routines, used by tracepoints, the
> difference between last tb and current (lower) tb may cause the CPU to
> trap PROGRAM exception, crashing host.=20

Yes, so I agree with Michael any function that is involved when we begin=20
to switch into guest context (or have not completed switching back to=20
host going the other way) should be marked as no trace (noinstr even,=20
perhaps).

>> As a local hack to work out a bug okay. If you really need it upstream=20
>> could you put it under a debug config option?
>=20
> You mean something that is automatically selected whenever those
> configs are enabled?=20
>=20
> CONFIG_TRACEPOINT && CONFIG_KVM_BOOK3S_HANDLER && CONFIG_PPC_BOOK3S_64
>=20
> Or something the user need to select himself in menuconfig?

Yeah I meant a default n thing under powerpc kernel debugging somewhere.

Thanks,
Nick
