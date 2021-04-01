Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B3350CBE
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 04:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhDACj6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 22:39:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58649 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhDACjk (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 22:39:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F9nT03JYsz9sWw;
        Thu,  1 Apr 2021 13:39:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1617244778;
        bh=jF35UQXWV9ftup/kWbiFuhxrt8LNtzRK24u+5NfY62w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DqclO1OdkHC0HIyU55+U/3XcCUj81LZgSGICQJPeG655bzU+Kfn7sgMhOXVk588kr
         /RNXh7SMzPQg9w+ycpvXiJYPzSMsUPXgTNaq+lLam/2Hi6NoAhKyAipl8Pn9qoSLDk
         qA1j7sQL6q1sSnRcCQHQ2ml1w+YPDpUP8KsQC4MqrTP+xBcHnSr+VneuRaWCJ/c9sO
         JQS2YPJNnuIJ8CvhMpXwLplqRqcTByd40L476kgI5KDf/q3Z+7uScinxejVBJ++xxD
         l//mTD2CWZARwb1Z+kVGSfooQ/uFVb7Rj8QtZPUxt6A7Q+e87O+Jl8WQ1e29ewe7TA
         0AjEBrKse/ySA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Segher Boessenkool <segher@kernel.crashing.org>
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
In-Reply-To: <20210331212550.GD13863@gate.crashing.org>
References: <20210330150425.10145-1-sxwjean@me.com>
 <875z17y79i.fsf@mpe.ellerman.id.au>
 <20210331212550.GD13863@gate.crashing.org>
Date:   Thu, 01 Apr 2021 13:39:28 +1100
Message-ID: <87im5620f3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Segher Boessenkool <segher@kernel.crashing.org> writes:
> On Wed, Mar 31, 2021 at 08:58:17PM +1100, Michael Ellerman wrote:
>> So perhaps:
>> 
>>   EXC_SYSTEM_RESET
>>   EXC_MACHINE_CHECK
>>   EXC_DATA_STORAGE
>>   EXC_DATA_SEGMENT
>>   EXC_INST_STORAGE
>>   EXC_INST_SEGMENT
>>   EXC_EXTERNAL_INTERRUPT
>>   EXC_ALIGNMENT
>>   EXC_PROGRAM_CHECK
>>   EXC_FP_UNAVAILABLE
>>   EXC_DECREMENTER
>>   EXC_HV_DECREMENTER
>>   EXC_SYSTEM_CALL
>>   EXC_HV_DATA_STORAGE
>>   EXC_PERF_MONITOR
>
> These are interrupt (vectors), not exceptions.  It doesn't matter all
> that much, but confusing things more isn't useful either!  There can be
> multiple exceptions that all can trigger the same interrupt.

Yeah I know, but I think that ship has already sailed as far as the
naming we have in the kernel.

We have over 250 uses of "exc", and several files called "exception"
something.

Using "interrupt" can also be confusing because Linux uses that to mean
"external interrupt".

But I dunno, maybe INT or VEC is clearer? .. or TRAP :)

cheers
