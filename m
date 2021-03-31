Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD35D350A31
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhCaW0k (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 18:26:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:42091 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhCaW0I (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 18:26:08 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 12VLQ2ZF019229;
        Wed, 31 Mar 2021 16:26:02 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 12VLPpYe019220;
        Wed, 31 Mar 2021 16:25:51 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 31 Mar 2021 16:25:51 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Xiongwei Song <sxwjean@me.com>, benh@kernel.crashing.org,
        paulus@samba.org, oleg@redhat.com, npiggin@gmail.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        aneesh.kumar@linux.ibm.com, ravi.bangoria@linux.ibm.com,
        mikey@neuling.org, haren@linux.ibm.com, alistair@popple.id.au,
        jniethe5@gmail.com, peterz@infradead.org, leobras.c@gmail.com,
        akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        atrajeev@linux.vnet.ibm.com, maddy@linux.ibm.com,
        kjain@linux.ibm.com, kan.liang@linux.intel.com, aik@ozlabs.ru,
        pmladek@suse.com, john.ogness@linutronix.de,
        Xiongwei Song <sxwjean@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/traps: Enhance readability for trap types
Message-ID: <20210331212550.GD13863@gate.crashing.org>
References: <20210330150425.10145-1-sxwjean@me.com> <875z17y79i.fsf@mpe.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z17y79i.fsf@mpe.ellerman.id.au>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
> So perhaps:
> 
>   EXC_SYSTEM_RESET
>   EXC_MACHINE_CHECK
>   EXC_DATA_STORAGE
>   EXC_DATA_SEGMENT
>   EXC_INST_STORAGE
>   EXC_INST_SEGMENT
>   EXC_EXTERNAL_INTERRUPT
>   EXC_ALIGNMENT
>   EXC_PROGRAM_CHECK
>   EXC_FP_UNAVAILABLE
>   EXC_DECREMENTER
>   EXC_HV_DECREMENTER
>   EXC_SYSTEM_CALL
>   EXC_HV_DATA_STORAGE
>   EXC_PERF_MONITOR

These are interrupt (vectors), not exceptions.  It doesn't matter all
that much, but confusing things more isn't useful either!  There can be
multiple exceptions that all can trigger the same interrupt.


Segher
