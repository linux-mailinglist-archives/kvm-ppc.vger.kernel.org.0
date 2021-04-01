Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8F351086
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 10:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhDAICH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 04:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbhDAIBf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 04:01:35 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56500C0613E6;
        Thu,  1 Apr 2021 01:01:35 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id a12so845353pfc.7;
        Thu, 01 Apr 2021 01:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=VuqpEl+COxSpxljOZtUJakmvEG5/ezz2fhanp9Quy0o=;
        b=LYBtBnVlJSsTvZ0wDUXosTU4G1ikc07HV2CSmX5/KXHqeoms8yNKR4YVhxpyLnmnSU
         icYlO0MaTxc+8bX1TbWJX8R1j7CdaPsBtp3g4/vXCmxEnQRBXqETzhtIjfIeotXNKvBN
         RbXIRE1rjsf1TXkoyxgIewKopOSUU95bYWviCpfHzbYxKF1oHfrsde6QMGJZ7Yqn1UOH
         fSMTuMbEadDX2gOzV/54ysjQRTPhKusXv3kNwcdPajac5QdmkpwJwGiJMEwK/kSUsVST
         omsbnkLvToLZFE2BB51rQp9zTQQKsTf4JOv9WJYkIbV9hHSDzCkAEi+XX26qQQD45Bkb
         X4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=VuqpEl+COxSpxljOZtUJakmvEG5/ezz2fhanp9Quy0o=;
        b=M8FrVCwG6aeB5ryhU2th55LTJgXweKijdbwV6voVKvY81V3uCLDVbQU1BTo5J8JF4A
         TkQ09+jaKbdMZPnyKIXUjQVwmahvU/HdyTBOmpuZVLB94V92p3uRo0KCdb7Z6CXaVxSu
         SpqG/9nBtHdFVAq41OnVWEwYScHlts10rbg4jMUph1Emu5VsC3u1tzib1v+vPx5v8eHQ
         X4HjMZTE9oJR1uJrNhdSfHyRqXR+9gzRXeZqgiviS8qplMzbIQcchbzqAEdSVnU8VzGp
         WdHnlSDIgNS1IWTnki/LmGZUMnKalML08R/d6PPCWXTd3eTHUDNvrgnncbSQgCa8Bfmo
         19NA==
X-Gm-Message-State: AOAM533HFDtYbA6SqDJ8dwV6PxKwR7e6XNlT34+ooTiCfugSqcDc6Boo
        f+ryqt2gKopRh40cOeYEyf8=
X-Google-Smtp-Source: ABdhPJwMz1GwlXfgz1SdhGlLswPr5wIx2hZQ7NHtvAFR2ElNpBNVDmIG+zYj5puoQmvjP6+Tp7fPPw==
X-Received: by 2002:a63:6683:: with SMTP id a125mr6320563pgc.382.1617264094938;
        Thu, 01 Apr 2021 01:01:34 -0700 (PDT)
Received: from localhost ([1.132.249.187])
        by smtp.gmail.com with ESMTPSA id l22sm5084316pjl.14.2021.04.01.01.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 01:01:34 -0700 (PDT)
Date:   Thu, 01 Apr 2021 18:01:29 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>
Cc:     aik@ozlabs.ru, akpm@linux-foundation.org, alistair@popple.id.au,
        aneesh.kumar@linux.ibm.com, atrajeev@linux.vnet.ibm.com,
        benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        haren@linux.ibm.com, jniethe5@gmail.com, john.ogness@linutronix.de,
        kan.liang@linux.intel.com, kjain@linux.ibm.com,
        kvm-ppc@vger.kernel.org, leobras.c@gmail.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        maddy@linux.ibm.com, mikey@neuling.org, msuchanek@suse.de,
        oleg@redhat.com, paulus@samba.org, peterx@redhat.com,
        peterz@infradead.org, pmladek@suse.com,
        ravi.bangoria@linux.ibm.com, rppt@kernel.org,
        Xiongwei Song <sxwjean@gmail.com>,
        Xiongwei Song <sxwjean@me.com>
References: <20210330150425.10145-1-sxwjean@me.com>
        <875z17y79i.fsf@mpe.ellerman.id.au>
        <20210331212550.GD13863@gate.crashing.org>
        <87im5620f3.fsf@mpe.ellerman.id.au>
In-Reply-To: <87im5620f3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-Id: <1617262858.ls37f2d81f.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Michael Ellerman's message of April 1, 2021 12:39 pm:
> Segher Boessenkool <segher@kernel.crashing.org> writes:
>> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>>> So perhaps:
>>>=20
>>>   EXC_SYSTEM_RESET
>>>   EXC_MACHINE_CHECK
>>>   EXC_DATA_STORAGE
>>>   EXC_DATA_SEGMENT
>>>   EXC_INST_STORAGE
>>>   EXC_INST_SEGMENT
>>>   EXC_EXTERNAL_INTERRUPT
>>>   EXC_ALIGNMENT
>>>   EXC_PROGRAM_CHECK
>>>   EXC_FP_UNAVAILABLE
>>>   EXC_DECREMENTER
>>>   EXC_HV_DECREMENTER
>>>   EXC_SYSTEM_CALL
>>>   EXC_HV_DATA_STORAGE
>>>   EXC_PERF_MONITOR
>>
>> These are interrupt (vectors), not exceptions.  It doesn't matter all
>> that much, but confusing things more isn't useful either!  There can be
>> multiple exceptions that all can trigger the same interrupt.
>=20
> Yeah I know, but I think that ship has already sailed as far as the
> naming we have in the kernel.

It has, but there are also several other ships also sailing in different=20
directions. It could be worse though, at least they are not sideways in=20
the Suez.

> We have over 250 uses of "exc", and several files called "exception"
> something.
>=20
> Using "interrupt" can also be confusing because Linux uses that to mean
> "external interrupt".
>=20
> But I dunno, maybe INT or VEC is clearer? .. or TRAP :)

We actually already have defines that follow Segher's suggestion, it's=20
just that they're hidden away in a KVM header.

#define BOOK3S_INTERRUPT_SYSTEM_RESET   0x100
#define BOOK3S_INTERRUPT_MACHINE_CHECK  0x200
#define BOOK3S_INTERRUPT_DATA_STORAGE   0x300
#define BOOK3S_INTERRUPT_DATA_SEGMENT   0x380
#define BOOK3S_INTERRUPT_INST_STORAGE   0x400
#define BOOK3S_INTERRUPT_INST_SEGMENT   0x480
#define BOOK3S_INTERRUPT_EXTERNAL       0x500
#define BOOK3S_INTERRUPT_EXTERNAL_HV    0x502
#define BOOK3S_INTERRUPT_ALIGNMENT      0x600

It would take just a small amount of work to move these to general=20
powerpc header, add #ifdefs for Book E/S where the numbers differ,
and remove the BOOK3S_ prefix.

I don't mind INTERRUPT_ but INT_ would be okay too. VEC_ actually
doesn't match what Book E does (which is some weirdness to map some
of them to match Book S but not all, arguably we should clean that
up too and just use vector numbers consistently, but the INTERRUPT_
prefix would still be valid if we did that).

BookE KVM entry will still continue to use a different convention
there so I would leave all those KVM defines in place for now, we
might do another pass on them later.

Thanks,
Nick
