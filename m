Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF8B351C96
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhDASSv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:18:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:48323 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238933AbhDASKj (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 1 Apr 2021 14:10:39 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 131GGI0w032424;
        Thu, 1 Apr 2021 11:16:18 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 131GGGMJ032422;
        Thu, 1 Apr 2021 11:16:16 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 1 Apr 2021 11:16:16 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, aik@ozlabs.ru,
        akpm@linux-foundation.org, alistair@popple.id.au,
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
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
Message-ID: <20210401161616.GF13863@gate.crashing.org>
References: <20210330150425.10145-1-sxwjean@me.com> <875z17y79i.fsf@mpe.ellerman.id.au> <20210331212550.GD13863@gate.crashing.org> <87im5620f3.fsf@mpe.ellerman.id.au> <1617262858.ls37f2d81f.astroid@bobo.none>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617262858.ls37f2d81f.astroid@bobo.none>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Apr 01, 2021 at 06:01:29PM +1000, Nicholas Piggin wrote:
> Excerpts from Michael Ellerman's message of April 1, 2021 12:39 pm:
> > Segher Boessenkool <segher@kernel.crashing.org> writes:
> >> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
> >>> So perhaps:
> >>> 
> >>>   EXC_SYSTEM_RESET
> >>>   EXC_MACHINE_CHECK
> >>>   EXC_DATA_STORAGE
> >>>   EXC_DATA_SEGMENT
> >>>   EXC_INST_STORAGE
> >>>   EXC_INST_SEGMENT
> >>>   EXC_EXTERNAL_INTERRUPT
> >>>   EXC_ALIGNMENT
> >>>   EXC_PROGRAM_CHECK
> >>>   EXC_FP_UNAVAILABLE
> >>>   EXC_DECREMENTER
> >>>   EXC_HV_DECREMENTER
> >>>   EXC_SYSTEM_CALL
> >>>   EXC_HV_DATA_STORAGE
> >>>   EXC_PERF_MONITOR
> >>
> >> These are interrupt (vectors), not exceptions.  It doesn't matter all
> >> that much, but confusing things more isn't useful either!  There can be
> >> multiple exceptions that all can trigger the same interrupt.
> > 
> > Yeah I know, but I think that ship has already sailed as far as the
> > naming we have in the kernel.
> 
> It has, but there are also several other ships also sailing in different 
> directions. It could be worse though, at least they are not sideways in 
> the Suez.

:-)

> > We have over 250 uses of "exc", and several files called "exception"
> > something.
> > 
> > Using "interrupt" can also be confusing because Linux uses that to mean
> > "external interrupt".
> > 
> > But I dunno, maybe INT or VEC is clearer? .. or TRAP :)
> 
> We actually already have defines that follow Segher's suggestion, it's 
> just that they're hidden away in a KVM header.
> 
> #define BOOK3S_INTERRUPT_SYSTEM_RESET   0x100
> #define BOOK3S_INTERRUPT_MACHINE_CHECK  0x200
> #define BOOK3S_INTERRUPT_DATA_STORAGE   0x300
> #define BOOK3S_INTERRUPT_DATA_SEGMENT   0x380
> #define BOOK3S_INTERRUPT_INST_STORAGE   0x400
> #define BOOK3S_INTERRUPT_INST_SEGMENT   0x480
> #define BOOK3S_INTERRUPT_EXTERNAL       0x500
> #define BOOK3S_INTERRUPT_EXTERNAL_HV    0x502
> #define BOOK3S_INTERRUPT_ALIGNMENT      0x600
> 
> It would take just a small amount of work to move these to general 
> powerpc header, add #ifdefs for Book E/S where the numbers differ,
> and remove the BOOK3S_ prefix.
> 
> I don't mind INTERRUPT_ but INT_ would be okay too. VEC_ actually
> doesn't match what Book E does (which is some weirdness to map some
> of them to match Book S but not all, arguably we should clean that
> up too and just use vector numbers consistently, but the INTERRUPT_
> prefix would still be valid if we did that).

VEC also is pretty incorrect: there is code at those addresses, not
vectors pointing to code (as similar things on some other architectures
have).  Everyone understands what it means of course, except it is
confusing with a thing we *do* have on Power called VEC (the MSR bit) :-P

(And TRAP is just one cause of 700...)


Segher
