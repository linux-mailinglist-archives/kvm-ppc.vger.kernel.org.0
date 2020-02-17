Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1A3160BB5
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Feb 2020 08:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgBQHh6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Feb 2020 02:37:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:54131 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgBQHh4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Feb 2020 02:37:56 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 01H7bigW011077;
        Mon, 17 Feb 2020 01:37:44 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 01H7bhPL011072;
        Mon, 17 Feb 2020 01:37:43 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 17 Feb 2020 01:37:43 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Michael Neuling <mikey@neuling.org>
Cc:     Gustavo Romero <gromero@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        paulus@ozlabs.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Treat unrecognized TM instructions as illegal
Message-ID: <20200217073743.GT22482@gate.crashing.org>
References: <20200213151532.12559-1-gromero@linux.ibm.com> <29b136e15c2f04f783b54ec98552d1a6009234db.camel@neuling.org> <20200217055712.GS22482@gate.crashing.org> <1752a0c735a455c5d3ca09209f5a52748c8f7116.camel@neuling.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1752a0c735a455c5d3ca09209f5a52748c8f7116.camel@neuling.org>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Feb 17, 2020 at 05:23:07PM +1100, Michael Neuling wrote:
> > > Hence, we should NOP this, not generate an illegal.
> > 
> > It is not a reserved bit.
> > 
> > The IMC entry for it matches op1=011111 op2=1////01110 presumably, which
> > catches all TM instructions and nothing else (bits 0..5 and bits 21..30).
> > That does not look at bit 31, the softpatch handler has to deal with this.
> > 
> > Some TM insns have bit 31 as 1 and some have it as /.  All instructions
> > with a "." in the mnemonic have bit 31 is 1, all other have it reserved.
> > The tables in appendices D, E, F show tend. and tsr. as having it
> > reserved, which contradicts the individual instruction description (and
> > does not make much sense).  (Only tcheck has /, everything else has 1;
> > everything else has a mnemonic with a dot, and does write CR0 always).
> 
> Wow, interesting. 
> 
> P8 seems to be treating 31 as a reserved bit (with the table definition rather
> than the individual instruction description). I'm inclined to match P8 even
> though it's inconsistent with the dot mnemonic as you say.

"The POWER8 core ignores the state of reserved bits in the instructions
(denoted by “///” in the instruction definition) and executes the
instruction normally. Software should set these bits to ‘0’ per the
Power ISA." (p8 UM, 3.1.1.3; same in the p9 UM).


Segher
