Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250B6351BB8
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhDASKx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:48323 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237652AbhDASIg (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 1 Apr 2021 14:08:36 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 131GBa12032064;
        Thu, 1 Apr 2021 11:11:36 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 131GBVOu032063;
        Thu, 1 Apr 2021 11:11:31 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 1 Apr 2021 11:11:31 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Xiongwei Song <sxwjean@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Xiongwei Song <sxwjean@me.com>, benh@kernel.crashing.org,
        paulus@samba.org, oleg@redhat.com, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        aneesh.kumar@linux.ibm.com, ravi.bangoria@linux.ibm.com,
        mikey@neuling.org, haren@linux.ibm.com, alistair@popple.id.au,
        jniethe5@gmail.com, peterz@infradead.org, leobras.c@gmail.com,
        akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        atrajeev@linux.vnet.ibm.com, maddy@linux.ibm.com,
        kjain@linux.ibm.com, kan.liang@linux.intel.com, aik@ozlabs.ru,
        pmladek@suse.com, john.ogness@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
Message-ID: <20210401161131.GE13863@gate.crashing.org>
References: <20210330150425.10145-1-sxwjean@me.com> <875z17y79i.fsf@mpe.ellerman.id.au> <20210331212550.GD13863@gate.crashing.org> <CAEVVKH8XDiEGHjXj6sJAHynhwqKWpNqj_Ws03AqwNjR8OmHf5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEVVKH8XDiEGHjXj6sJAHynhwqKWpNqj_Ws03AqwNjR8OmHf5w@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Apr 01, 2021 at 10:55:58AM +0800, Xiongwei Song wrote:
> Segher Boessenkool <segher@kernel.crashing.org> 于2021年4月1日周四 上午6:15写道：
> 
> > On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
> > > So perhaps:
> > >
> > >   EXC_SYSTEM_RESET
> > >   EXC_MACHINE_CHECK
> > >   EXC_DATA_STORAGE
> > >   EXC_DATA_SEGMENT
> > >   EXC_INST_STORAGE
> > >   EXC_INST_SEGMENT
> > >   EXC_EXTERNAL_INTERRUPT
> > >   EXC_ALIGNMENT
> > >   EXC_PROGRAM_CHECK
> > >   EXC_FP_UNAVAILABLE
> > >   EXC_DECREMENTER
> > >   EXC_HV_DECREMENTER
> > >   EXC_SYSTEM_CALL
> > >   EXC_HV_DATA_STORAGE
> > >   EXC_PERF_MONITOR
> >
> > These are interrupt (vectors), not exceptions.  It doesn't matter all
> > that much, but confusing things more isn't useful either!  There can be
> > multiple exceptions that all can trigger the same interrupt.
> >
> >  When looking at the reference manual of e500 and e600 from NXP
>  official, they call them as interrupts.While looking at the "The
> Programming Environments"
>  that is also from NXP, they call them exceptions. Looks like there is
>  no explicit distinction between interrupts and exceptions.

The architecture documents have always called it interrupts.  The PEM
says it calls them exceptions instead, but they are called interrupts in
the architecture (and the PEM says that, too).

> Here is the "The Programming Environments" link:
> https://www.nxp.com.cn/docs/en/user-guide/MPCFPE_AD_R1.pdf

That document is 24 years old.  The architecture is still published,
new versions regularly.

> As far as I know, the values of interrupts or exceptions above are defined
> explicitly in reference manual or the programming environments.

They are defined in the architecture.

> Could
> you please provide more details about multiple exceptions with the same
> interrupts?

The simplest example is 700, program interrupt.  There are many causes
for it, including all the exceptions in FPSCR: VX, ZX, OX, UX, XX, and
VX is actually divided into nine separate cases itself.  There also are
the various causes of privileged instruction type program interrupts,
and  the trap type program interrupt, but the FEX ones are most obvious
here.


Segher
