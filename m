Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D537250E
	for <lists+kvm-ppc@lfdr.de>; Tue,  4 May 2021 06:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhEDE3c (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 4 May 2021 00:29:32 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47531 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhEDE32 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 4 May 2021 00:29:28 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4FZ6KY036vz9sSs; Tue,  4 May 2021 14:28:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1620102513; bh=xVV8/psp7VO/GVcj8ha7MWfLtO+PETUvfSGiwRm6sw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJvbUc8bKc2y6c6Rtv20bIxmH0TJvWf4nBLLQs40Y9yE246yoaIynN7aHStVNPQdW
         24hsf9U0BzWVSQTbtr/AiRuY/F+tP9qViPVQhgw+q8x+PzBfYQCwDXra0LfwmbduAX
         7RmiJ8GAO9RI6r+wuwIDedkpQdMUpQIEVsLZQIerQ/gGTaCZJaVkgB4nKdTYwjEtzn
         oA7JcdkEOtiMJkkoge99a2orSpRi/cq1IobiVOBUaST/NyGf8nhqj0zR++1gFB+Bps
         yM0YbcSGwODyJKTxLoaAcCvBQqAyaxnREDM2YRiX24x9LBIxBOtBZraj8TJgANmGpj
         +ma3ZAxV10OOw==
Date:   Tue, 4 May 2021 14:28:28 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
Subject: Re: [PATCH v3 1/2] KVM: PPC: Book3S HV: Sanitise vcpu registers in
 nested path
Message-ID: <YJDNbFQlB9DHnI6Z@thinks.paulus.ozlabs.org>
References: <20210415230948.3563415-1-farosas@linux.ibm.com>
 <20210415230948.3563415-2-farosas@linux.ibm.com>
 <1619833560.k4eybr40bg.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619833560.k4eybr40bg.astroid@bobo.none>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 01, 2021 at 11:58:36AM +1000, Nicholas Piggin wrote:
> Excerpts from Fabiano Rosas's message of April 16, 2021 9:09 am:
> > As one of the arguments of the H_ENTER_NESTED hypercall, the nested
> > hypervisor (L1) prepares a structure containing the values of various
> > hypervisor-privileged registers with which it wants the nested guest
> > (L2) to run. Since the nested HV runs in supervisor mode it needs the
> > host to write to these registers.
> > 
> > To stop a nested HV manipulating this mechanism and using a nested
> > guest as a proxy to access a facility that has been made unavailable
> > to it, we have a routine that sanitises the values of the HV registers
> > before copying them into the nested guest's vcpu struct.
> > 
> > However, when coming out of the guest the values are copied as they
> > were back into L1 memory, which means that any sanitisation we did
> > during guest entry will be exposed to L1 after H_ENTER_NESTED returns.
> > 
> > This patch alters this sanitisation to have effect on the vcpu->arch
> > registers directly before entering and after exiting the guest,
> > leaving the structure that is copied back into L1 unchanged (except
> > when we really want L1 to access the value, e.g the Cause bits of
> > HFSCR).
> > 
> > Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> > ---
> >  arch/powerpc/kvm/book3s_hv_nested.c | 55 ++++++++++++++++++-----------
> >  1 file changed, 34 insertions(+), 21 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> > index 0cd0e7aad588..270552dd42c5 100644
> > --- a/arch/powerpc/kvm/book3s_hv_nested.c
> > +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> > @@ -102,8 +102,17 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
> >  {
> >  	struct kvmppc_vcore *vc = vcpu->arch.vcore;
> >  
> > +	/*
> > +	 * When loading the hypervisor-privileged registers to run L2,
> > +	 * we might have used bits from L1 state to restrict what the
> > +	 * L2 state is allowed to be. Since L1 is not allowed to read
> > +	 * the HV registers, do not include these modifications in the
> > +	 * return state.
> > +	 */
> > +	hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
> > +		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
> > +
> >  	hr->dpdes = vc->dpdes;
> > -	hr->hfscr = vcpu->arch.hfscr;
> >  	hr->purr = vcpu->arch.purr;
> >  	hr->spurr = vcpu->arch.spurr;
> >  	hr->ic = vcpu->arch.ic;
> 
> Do we still have the problem here that hfac interrupts due to bits cleared
> by the hfscr sanitisation would have the cause bits returned to the L1,
> so in theory it could probe hfscr directly that way? I don't see a good
> solution to this except either have the L0 intercept these faults and do
> "something" transparent, or return error from H_ENTER_NESTED (which would
> also allow trivial probing of the facilities).

It seems to me that there are various specific reasons why L0 would
clear HFSCR bits, and if we think about the specific reasons, what we
should do becomes clear.  (I say "L0" but in fact the same reasoning
applies to any hypervisor that lets its guest do hypervisor-ish
things.)

1. Emulating a version of the architecture which doesn't have the
feature in question - in that case the bit should appear to L1 as a
reserved bit in HFSCR (i.e. always read 0), the associated facility
code should never appear in the top 8 bits of any HFSCR value that L1
sees, and any HFU interrupt received by L0 for the facility should be
changed into an illegal instruction interrupt (or HEAI) forwarded to
L1.  In this case the real HFSCR should always have the enable bit for
the facility set to 0.

2. Lazy save/restore of the state associated with a facility - in this
case, while the system is in the "lazy" state (i.e. the state is not
that of the currently running guest), the real HFSCR bit for the
facility should be 0.  On an HFU interrupt for the facility, L0 looks
at L1's HFSCR value: if it's 0, forward the HFU interrupt to L1; if
it's 1, load up the facility state, set the facility's bit in HFSCR,
and resume the guest.

3. Emulating a facility in software - in this case, the real HFSCR
bit for the facility would always be 0.  On an HFU interrupt, L0 reads
the instruction and emulates it, then resumes the guest.

One thing this all makes clear is that the IC field of the "virtual"
HFSCR value seen by L1 should only ever be changed when L0 forwards a
HFU interrupt to L1.

In fact we currently never do (1) or (2), and we only do (3) for
msgsndp etc., so this discussion is mostly theoretical.

> Returning an hfac interrupt to a hypervisor that thought it enabled the 
> bit would be strange. But so does appearing to modify the register 
> underneath it and then returning a fault.

I don't think we should ever do either of those things.  The closest
would be (1) above, but in that case the fault has to be either an
illegal instruction type program interrupt, or a HEAI.

> I think the sanest thing would actually be to return failure from the 
> hcall.

I don't think we should do that either.

Paul.
