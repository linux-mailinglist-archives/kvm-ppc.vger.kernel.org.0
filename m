Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A052C8DD0C
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Aug 2019 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfHNSer (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Aug 2019 14:34:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:39492 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfHNSer (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 14 Aug 2019 14:34:47 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x7EIYYlH007378;
        Wed, 14 Aug 2019 13:34:34 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x7EIYWLs007377;
        Wed, 14 Aug 2019 13:34:32 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 14 Aug 2019 13:34:32 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH v5 2/7] powerpc/kernel: Add ucall_norets() ultravisor call handler
Message-ID: <20190814183432.GG31406@gate.crashing.org>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com> <20190808040555.2371-3-cclaudio@linux.ibm.com> <87wofgqb2g.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wofgqb2g.fsf@concordia.ellerman.id.au>
User-Agent: Mutt/1.4.2.3i
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Aug 14, 2019 at 08:46:15PM +1000, Michael Ellerman wrote:
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> > +_GLOBAL(ucall_norets)
> > +EXPORT_SYMBOL_GPL(ucall_norets)
> > +	mfcr	r0
> > +	stw	r0,8(r1)
> > +
> > +	sc	2		/* Invoke the ultravisor */
> > +
> > +	lwz	r0,8(r1)
> > +	mtcrf	0xff,r0
> > +	blr			/* Return r3 = status */
> 
> Paulus points that we shouldn't need to save CR here. Our caller will
> have already saved it if it needed to, and we don't use CR in this
> function so we don't need to save it.
> 
> That's assuming the Ultravisor follows the hcall ABI in which CR2-4 are
> non-volatile (PAPR § 14.5.3).

And assuming the ultravisor already clears (or sets, or whatever) all CR
fields it does not want to leak the contents of (which it also should,
of course).

> I know plpar_hcall_norets() does save CR, but it shouldn't need to, that
> seems to be historical. aka. no one knows why it does it but it always
> has.


Segher
