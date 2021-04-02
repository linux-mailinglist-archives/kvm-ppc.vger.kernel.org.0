Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338B135247F
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 02:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhDBAgw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 20:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhDBAgw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 20:36:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08408C0613E6;
        Thu,  1 Apr 2021 17:36:52 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id i6so2648086pgs.1;
        Thu, 01 Apr 2021 17:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=mHTyduBV8QUncoW717T6beBC22w2IZVY/ijF4hpWxGA=;
        b=HjxdSQ7Em1sGaJLSqIRFvOZc1jv3Oi4ZrUw/yKg63yuR7RoFq/k1PM14qEQ0KEogo9
         fp+5ClfYUlMHEff7uYKEy2p+WZ4YJjDzq3uMvNUT9eMU4cjWwnFb6WMUtxIL7fWRZ/kO
         KpwKjsAX6Z/sYGxUdDJk/o90TDCH2dZR8zNeqhPC6QpV+jkZMhwTse7QoTS3i0FgTo8v
         FXfIKyzJSANQM5ZZaZzqb3ofD9MNuRkgiF1Eb9aj8N/D4fvsprzgVZlqbLbiL3HW5rU5
         XAggGW6Sk66ett192EbU3F/X17FsG8H/Kxfnf55dXhD4/no31Djvx7jelJb9jqjBZe1e
         6IrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=mHTyduBV8QUncoW717T6beBC22w2IZVY/ijF4hpWxGA=;
        b=QTANmAso8IfmpqEAbkWfdCK2KB/MgHE1A96Dyl6PqzOMpjOjOpW9Kww5yTvZim/828
         dZ0sPQEB0r/OjCxDcHAgLHXtO+sjzYTqKOVMXFx4TsZfjM5NSn3beh6yTzTZyTEE1szA
         PrNqRAtlVQ0RyN9EafEdkmVG2pike6cByQzyRD5AZhIJZBI0fm5Vv9n/SgB4heaF9wL8
         FLdD7YJ7CXwRPas1B5ZH1WB0CHBCwPo49MSU8O57WjNIAwhCjFl3IXVMPZeQLkng0FD9
         iB8nThCA2shEK8F8EoF+PBLBkwZp4qdSoMm2Bt7unyIdNCZTRQ32h/Kzwls2fm6tZCXt
         dlUg==
X-Gm-Message-State: AOAM533VdTdrCV5uWav4MrXh+zZkXlA+w4ltf89Lz25783D9CT1fUCVh
        M4tub6JHZ99oaCa7Uhr643A=
X-Google-Smtp-Source: ABdhPJzbvBbwx7VuBDpNxt3r39dNZxIn24MT44kQ2ysEs5seZxJ8UK6xP577pFsYiVsxPTaEfw0ZnQ==
X-Received: by 2002:a63:4502:: with SMTP id s2mr10219216pga.94.1617323811574;
        Thu, 01 Apr 2021 17:36:51 -0700 (PDT)
Received: from localhost ([1.128.157.222])
        by smtp.gmail.com with ESMTPSA id w18sm6196736pjh.19.2021.04.01.17.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 17:36:51 -0700 (PDT)
Date:   Fri, 02 Apr 2021 10:36:45 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
To:     Segher Boessenkool <segher@kernel.crashing.org>,
        Xiongwei Song <sxwjean@gmail.com>
Cc:     aik@ozlabs.ru, akpm@linux-foundation.org, alistair@popple.id.au,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        haren@linux.ibm.com, jniethe5@gmail.com, john.ogness@linutronix.de,
        kan.liang@linux.intel.com, kjain@linux.ibm.com,
        kvm-ppc@vger.kernel.org, leobras.c@gmail.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        maddy@linux.ibm.com, mikey@neuling.org,
        Michael Ellerman <mpe@ellerman.id.au>, msuchanek@suse.de,
        oleg@redhat.com, paulus@samba.org, peterx@redhat.com,
        peterz@infradead.org, pmladek@suse.com,
        ravi.bangoria@linux.ibm.com, rppt@kernel.org,
        Xiongwei Song <sxwjean@me.com>
References: <20210330150425.10145-1-sxwjean@me.com>
        <875z17y79i.fsf@mpe.ellerman.id.au>
        <20210331212550.GD13863@gate.crashing.org>
        <CAEVVKH8XDiEGHjXj6sJAHynhwqKWpNqj_Ws03AqwNjR8OmHf5w@mail.gmail.com>
        <20210401161131.GE13863@gate.crashing.org>
In-Reply-To: <20210401161131.GE13863@gate.crashing.org>
MIME-Version: 1.0
Message-Id: <1617322416.z3cicnpfxy.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Segher Boessenkool's message of April 2, 2021 2:11 am:
> On Thu, Apr 01, 2021 at 10:55:58AM +0800, Xiongwei Song wrote:
>> Segher Boessenkool <segher@kernel.crashing.org> =E4=BA=8E2021=E5=B9=B44=
=E6=9C=881=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=886:15=E5=86=99=E9=81=
=93=EF=BC=9A
>>=20
>> > On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>> > > So perhaps:
>> > >
>> > >   EXC_SYSTEM_RESET
>> > >   EXC_MACHINE_CHECK
>> > >   EXC_DATA_STORAGE
>> > >   EXC_DATA_SEGMENT
>> > >   EXC_INST_STORAGE
>> > >   EXC_INST_SEGMENT
>> > >   EXC_EXTERNAL_INTERRUPT
>> > >   EXC_ALIGNMENT
>> > >   EXC_PROGRAM_CHECK
>> > >   EXC_FP_UNAVAILABLE
>> > >   EXC_DECREMENTER
>> > >   EXC_HV_DECREMENTER
>> > >   EXC_SYSTEM_CALL
>> > >   EXC_HV_DATA_STORAGE
>> > >   EXC_PERF_MONITOR
>> >
>> > These are interrupt (vectors), not exceptions.  It doesn't matter all
>> > that much, but confusing things more isn't useful either!  There can b=
e
>> > multiple exceptions that all can trigger the same interrupt.
>> >
>> >  When looking at the reference manual of e500 and e600 from NXP
>>  official, they call them as interrupts.While looking at the "The
>> Programming Environments"
>>  that is also from NXP, they call them exceptions. Looks like there is
>>  no explicit distinction between interrupts and exceptions.
>=20
> The architecture documents have always called it interrupts.  The PEM
> says it calls them exceptions instead, but they are called interrupts in
> the architecture (and the PEM says that, too).
>=20
>> Here is the "The Programming Environments" link:
>> https://www.nxp.com.cn/docs/en/user-guide/MPCFPE_AD_R1.pdf
>=20
> That document is 24 years old.  The architecture is still published,
> new versions regularly.
>=20
>> As far as I know, the values of interrupts or exceptions above are defin=
ed
>> explicitly in reference manual or the programming environments.
>=20
> They are defined in the architecture.
>=20
>> Could
>> you please provide more details about multiple exceptions with the same
>> interrupts?
>=20
> The simplest example is 700, program interrupt.  There are many causes
> for it, including all the exceptions in FPSCR: VX, ZX, OX, UX, XX, and
> VX is actually divided into nine separate cases itself.  There also are
> the various causes of privileged instruction type program interrupts,
> and  the trap type program interrupt, but the FEX ones are most obvious
> here.

Also:

* Some interrupts have no corresponding exception (system call and=20
system call vectored). This is not just semantics or a bug in the ISA
because it is different from other synchronous interrupts: instructions=20
which cause exceptions (e.g., a page fault) do not complete before=20
taking the interrupt whereas sc does.

* It's quite usual for an exception to not cause an interrupt=20
immediately (MSR[EE]=3D0, HMEER) or never cause one and be cleared by=20
other means (msgclr, mtDEC, mtHMER, etc).

* It's possible for an exception to cause different interrupts!
A decrementer exception usually causes a decrementer interrupt, but it
can cause a system reset interrupt if the processor was in a power
saving mode. A data storage exception can cause a DSI or HDSI interrupt
depending on LPCR settings, and many other examples.

So I agree with Segher on this. We should use interrupt for interrupts,=20
reduce exception except where we really mean it, and move away from vec=20
and trap (I've got this wrong in the past too I admit). We don't have to=20
do it all immediately, but new code should go in this direction.

Thanks,
Nick
