Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E611925AD
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Mar 2020 11:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgCYKeW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Mar 2020 06:34:22 -0400
Received: from 20.mo6.mail-out.ovh.net ([178.32.124.17]:55803 "EHLO
        20.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCYKeW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 25 Mar 2020 06:34:22 -0400
Received: from player159.ha.ovh.net (unknown [10.110.208.62])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id DE632205BCE
        for <kvm-ppc@vger.kernel.org>; Wed, 25 Mar 2020 11:34:19 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player159.ha.ovh.net (Postfix) with ESMTPSA id 2E76410C032CE;
        Wed, 25 Mar 2020 10:34:13 +0000 (UTC)
Date:   Wed, 25 Mar 2020 11:34:12 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        paulus@samba.org, linuxram@us.ibm.com
Subject: Re: [PATCH] powerpc/prom_init: Include the termination message in
 ibm,os-term RTAS call
Message-ID: <20200325113412.1fed2d82@bahia.lan>
In-Reply-To: <87zhc4wxy9.fsf@mpe.ellerman.id.au>
References: <20200324201211.1055236-1-farosas@linux.ibm.com>
        <87zhc4wxy9.fsf@mpe.ellerman.id.au>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3723069520371227057
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudehfedgudeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuffhomhgrihhnpehqvghmuhdrohhrghdpohiilhgrsghsrdhorhhgnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhduheelrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 25 Mar 2020 21:06:22 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> Fabiano Rosas <farosas@linux.ibm.com> writes:
> 
> > QEMU can now print the ibm,os-term message[1], so let's include it in
> > the RTAS call. E.g.:
> >
> >   qemu-system-ppc64: OS terminated: Switch to secure mode failed.
> >
> > 1- https://git.qemu.org/?p=qemu.git;a=commitdiff;h=a4c3791ae0
> >
> > Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> > ---
> >  arch/powerpc/kernel/prom_init.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> I have this queued:
>   https://patchwork.ozlabs.org/patch/1253390/
> 
> Which I think does the same thing?
> 

Alexey's patch also sets os_term_args.nret as indicated in PAPR.
Even if QEMU's handler for "ibm,os-term" doesn't seem to have
a use for nret, I think it's better to stick to the spec.

Cheers,

--
Greg

> cheers
> 
> > diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
> > index 577345382b23..d543fb6d29c5 100644
> > --- a/arch/powerpc/kernel/prom_init.c
> > +++ b/arch/powerpc/kernel/prom_init.c
> > @@ -1773,6 +1773,9 @@ static void __init prom_rtas_os_term(char *str)
> >  	if (token == 0)
> >  		prom_panic("Could not get token for ibm,os-term\n");
> >  	os_term_args.token = cpu_to_be32(token);
> > +	os_term_args.nargs = cpu_to_be32(1);
> > +	os_term_args.args[0] = cpu_to_be32(__pa(str));
> > +
> >  	prom_rtas_hcall((uint64_t)&os_term_args);
> >  }
> >  #endif /* CONFIG_PPC_SVM */
> > -- 
> > 2.23.0

