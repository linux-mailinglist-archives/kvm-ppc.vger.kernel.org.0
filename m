Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAE031399E
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Feb 2021 17:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhBHQiY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Feb 2021 11:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhBHQiP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Feb 2021 11:38:15 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66F6C061786;
        Mon,  8 Feb 2021 08:37:35 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id z32so10705228qtd.8;
        Mon, 08 Feb 2021 08:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=0HGJhzf1G3q3frtQdQfHf7vZn5MRVAT2xn4qaxvZi1U=;
        b=ZCnSrK8LjbN2c5cFVRG8Y/oJxehO4A8/tz5FWWPFXPIFK20ClWGSl1ycugUiWZv96X
         gnzaSQox2p06FwUSGLgIjEcfLTyaVjRP3zWJ0jDIJ3pBkNuSYszTkRDAFNGc0Z+2vPmj
         kE5KOYOGtCJ8rO1KdQXK8f29i7lWJcft/u45IPrhagQnf+B2Iho/kXPiCy2Idhksu8Gy
         JrQo92inlAM87m/A/agpxNoW3/F2ASQXN0ZG33LgSo08ttpQpdqBGtQ7z0WFU3zPtDm8
         LGXi1Ad9ZyFxGDBwWOmAypp/fg0KxfxrToUsRIEge7jkM8qFAj7UzxuQYPn6c3ikH7Pz
         L9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=0HGJhzf1G3q3frtQdQfHf7vZn5MRVAT2xn4qaxvZi1U=;
        b=AyNMldO+d8X2/a2LlWI7k4m86XaSaDL/HuGELu1mWgxVeC2Anewq6m1cALD8yUc6oy
         mYAHH7AOmb1+6zQfwlyagYPADUn/A10vXEaMn/89wG8Gle1s1MRi6Tdxcl3rlbrIMd9Q
         WfDPvnKFRSu2PlkVXY59ok0Q5/YzSH0NA1F9MARHnPzE/LeUlPNWPy/Ocv2BCOy3OXKd
         DMQ7b06xUuCttctcEl/JkWc+/bDndQfLvJbMfo6X01ZiJbfIAlN0InsCe1uqHpkRochv
         rJFNODg6VoKWVF7xec8E0ZJC6Nf6+qgZw1cXylS3uHqE1lza5ON8319FjrvSrQUWHQpr
         5CLg==
X-Gm-Message-State: AOAM532g3pB2iB1GnewBgDYOhF9YgQYoOTLRnpIUS1Q7Gxk8JVFRecNh
        K7n8mnwc7SyUyd0tbgEZ3RM=
X-Google-Smtp-Source: ABdhPJxNBkhFgcpxYqi/I81KZzI4gTQD8gRxnBMkUmMMD7+YFyASMpNVveQ5vs6x229sbqpsjBgABw==
X-Received: by 2002:a05:622a:44d:: with SMTP id o13mr9623179qtx.378.1612802254979;
        Mon, 08 Feb 2021 08:37:34 -0800 (PST)
Received: from li-908e0a4c-2250-11b2-a85c-f027e903211b.ibm.com (186-249-147-196.dynamic.desktop.com.br. [186.249.147.196])
        by smtp.gmail.com with ESMTPSA id c17sm16409866qka.16.2021.02.08.08.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 08:37:33 -0800 (PST)
Message-ID: <5f267a8aec5b8199a580c96ab2b1a3c27de4eb09.camel@gmail.com>
Subject: Re: [PATCH v2 1/1] powerpc/kvm: Save Timebase Offset to fix
 sched_clock() while running guest code.
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Weisbecker <frederic@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 08 Feb 2021 13:37:04 -0300
In-Reply-To: <1612579579.ztbklit4un.astroid@bobo.none>
References: <20210205060643.233481-1-leobras.c@gmail.com>
         <1612506268.6rrvx34gzu.astroid@bobo.none>
         <7e231b91e41c3f3586ba2fd604c40f1716db228d.camel@gmail.com>
         <1612579579.ztbklit4un.astroid@bobo.none>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hello Nick,

On Sat, 2021-02-06 at 13:03 +1000, Nicholas Piggin wrote:
> Excerpts from Leonardo Bras's message of February 5, 2021 5:01 pm:
> > Hey Nick, thanks for reviewing :)
> > 
> > On Fri, 2021-02-05 at 16:28 +1000, Nicholas Piggin wrote:
> > > Excerpts from Leonardo Bras's message of February 5, 2021 4:06 pm:
> > > > Before guest entry, TBU40 register is changed to reflect guest timebase.
> > > > After exitting guest, the register is reverted to it's original value.
> > > > 
> > > > If one tries to get the timestamp from host between those changes, it
> > > > will present an incorrect value.
> > > > 
> > > > An example would be trying to add a tracepoint in
> > > > kvmppc_guest_entry_inject_int(), which depending on last tracepoint
> > > > acquired could actually cause the host to crash.
> > > > 
> > > > Save the Timebase Offset to PACA and use it on sched_clock() to always
> > > > get the correct timestamp.
> > > 
> > > Ouch. Not sure how reasonable it is to half switch into guest registers 
> > > and expect to call into the wider kernel, fixing things up as we go. 
> > > What if mftb is used in other places?
> > 
> > IIUC, the CPU is not supposed to call anything as host between guest
> > entry and guest exit, except guest-related cases, like
> 
> When I say "call", I'm including tracing in that. If a function is not 
> marked as no trace, then it will call into the tracing subsystem.
> 
> > kvmppc_guest_entry_inject_int(), but anyway, if something calls mftb it
> > will still get the same value as before.
> 
> Right, so it'll be out of whack again.
> 
> > This is only supposed to change stuff that depends on sched_clock, like
> > Tracepoints, that can happen in those exceptions.
> 
> If they depend on sched_clock that's one thing. Do they definitely have 
> no dependencies on mftb from other calls?

We could change that on get_tb() or mftb() @ timebase.h, which would
have a broader reach, but would not reach any mftb from asm code.

> > > Especially as it doesn't seem like there is a reason that function _has_
> > > to be called after the timebase is switched to guest, that's just how 
> > > the code is structured.
> > 
> > Correct, but if called, like in rb routines, used by tracepoints, the
> > difference between last tb and current (lower) tb may cause the CPU to
> > trap PROGRAM exception, crashing host. 
> 
> Yes, so I agree with Michael any function that is involved when we begin 
> to switch into guest context (or have not completed switching back to 
> host going the other way) should be marked as no trace (noinstr even, 
> perhaps).

Sure, that would avoid having to get paca->tb_offset for every mftb()
called, and avoid inconsistencies when different ways to get time are
used in code.

On the other hand, it would make it very hard to debug functions like
kvmppc_guest_entry_inject_int() as I am doing right now.

> 
> > > As a local hack to work out a bug okay. If you really need it upstream 
> > > could you put it under a debug config option?
> > 
> > You mean something that is automatically selected whenever those
> > configs are enabled? 
> > 
> > CONFIG_TRACEPOINT && CONFIG_KVM_BOOK3S_HANDLER && CONFIG_PPC_BOOK3S_64
> > 
> > Or something the user need to select himself in menuconfig?
> 
> Yeah I meant a default n thing under powerpc kernel debugging somewhere.

So, IIUC all we can do is split this in 2 changes:
1 - Adding notrace to those functions
2 - Introducing a kernel debug config that reverts (1) and 'fixes' mftb

If that's correct, I have some ideas we can use. 

For debug option, should we add the offset on get_tb() or mftb()?

Another option would be to adding this tb_offset only in the routines
used by tracing. But this could probably mean having to add a function
in arch-generic code, but still an option.

What do you think?

> 
> Thanks,
> Nick

Thank you!
Leonardo Bras

