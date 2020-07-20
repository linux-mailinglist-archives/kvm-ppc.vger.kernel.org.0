Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A27226FB2
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 Jul 2020 22:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgGTUZH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 Jul 2020 16:25:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:42009 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGTUZG (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 20 Jul 2020 16:25:06 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 06KKOrG5032543;
        Mon, 20 Jul 2020 15:24:53 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 06KKOqCj032537;
        Mon, 20 Jul 2020 15:24:52 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 20 Jul 2020 15:24:52 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     aik@ozlabs.ru, Ram Pai <linuxram@us.ibm.com>,
        kvm-ppc@vger.kernel.org, bharata@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on MMIO access, in sprg0 register
Message-ID: <20200720202452.GN30544@gate.crashing.org>
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com> <18e3bcee-8a3a-bd13-c995-8e4168471f74@linux.ibm.com> <20200720201041.GM30544@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200720201041.GM30544@gate.crashing.org>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 20, 2020 at 03:10:41PM -0500, Segher Boessenkool wrote:
> On Mon, Jul 20, 2020 at 11:39:56AM +0200, Laurent Dufour wrote:
> > Le 16/07/2020 à 10:32, Ram Pai a écrit :
> > >+	if (is_secure_guest()) {					\
> > >+		__asm__ __volatile__("mfsprg0 %3;"			\
> > >+				"lnia %2;"				\
> > >+				"ld %2,12(%2);"				\
> > >+				"mtsprg0 %2;"				\
> > >+				"sync;"					\
> > >+				#insn" %0,%y1;"				\
> > >+				"twi 0,%0,0;"				\
> > >+				"isync;"				\
> > >+				"mtsprg0 %3"				\
> > >+			: "=r" (ret)					\
> > >+			: "Z" (*addr), "r" (0), "r" (0)			\
> > 
> > I'm wondering if SPRG0 is restored to its original value.
> > You're using the same register (r0) for parameters 2 and 3, so when doing 
> > lnia %2, you're overwriting the SPRG0 value you saved in r0 just earlier.
> 
> It is putting the value 0 in the registers the compiler chooses for
> operands 2 and 3.  But operand 3 is written, while the asm says it is an
> input.  It needs an earlyclobber as well.
> 
> > It may be clearer to use explicit registers for %2 and %3 and to mark them 
> > as modified for the compiler.
> 
> That is not a good idea, imnsho.

(The explicit register number part, I mean; operand 2 should be an
output as well, yes.)


Segher
