Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E30179149
	for <lists+kvm-ppc@lfdr.de>; Wed,  4 Mar 2020 14:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbgCDN1g convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Wed, 4 Mar 2020 08:27:36 -0500
Received: from 7.mo7.mail-out.ovh.net ([46.105.43.131]:55487 "EHLO
        7.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbgCDN1f (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 4 Mar 2020 08:27:35 -0500
X-Greylist: delayed 8842 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 08:27:34 EST
Received: from player791.ha.ovh.net (unknown [10.110.103.91])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 3F098156684
        for <kvm-ppc@vger.kernel.org>; Wed,  4 Mar 2020 12:00:11 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player791.ha.ovh.net (Postfix) with ESMTPSA id 61277FFD323D;
        Wed,  4 Mar 2020 10:59:54 +0000 (UTC)
Date:   Wed, 4 Mar 2020 11:59:48 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@fr.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
Message-ID: <20200304115948.7b2dfe10@bahia.home>
In-Reply-To: <20200303185645.GB5416@oc0525413822.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
        <20200302233240.GB35885@umbus.fritz.box>
        <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
        <20200303170205.GA5416@oc0525413822.ibm.com>
        <20200303184520.632be270@bahia.home>
        <20200303185645.GB5416@oc0525413822.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 9960555004736149963
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtkedgvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejledurdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 3 Mar 2020 10:56:45 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> On Tue, Mar 03, 2020 at 06:45:20PM +0100, Greg Kurz wrote:
> > On Tue, 3 Mar 2020 09:02:05 -0800
> > Ram Pai <linuxram@us.ibm.com> wrote:
> > 
> > > On Tue, Mar 03, 2020 at 07:50:08AM +0100, Cédric Le Goater wrote:
> > > > On 3/3/20 12:32 AM, David Gibson wrote:
> > > > > On Fri, Feb 28, 2020 at 11:54:04PM -0800, Ram Pai wrote:
> > > > >> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
> > > > >>
> > > > >> Hence Secure VM, must always default to XICS interrupt controller.
> > > > >>
> > > > >> If XIVE is requested through kernel command line option "xive=on",
> > > > >> override and turn it off.
> > > > >>
> > > > >> If XIVE is the only supported platform interrupt controller; specified
> > > > >> through qemu option "ic-mode=xive", simply abort. Otherwise default to
> > > > >> XICS.
> > > > > 
> > > > > Uh... the discussion thread here seems to have gotten oddly off
> > > > > track.  
> > > > 
> > > > There seem to be multiple issues. It is difficult to have a clear status.
> > > > 
> > > > > So, to try to clean up some misunderstandings on both sides:
> > > > > 
> > > > >   1) The guest is the main thing that knows that it will be in secure
> > > > >      mode, so it's reasonable for it to conditionally use XIVE based
> > > > >      on that
> > > > 
> > > > FW support is required AFAIUI.
> > > > >   2) The mechanism by which we do it here isn't quite right.  Here the
> > > > >      guest is checking itself that the host only allows XIVE, but we
> > > > >      can't do XIVE and is panic()ing.  Instead, in the SVM case we
> > > > >      should force support->xive to false, and send that in the CAS
> > > > >      request to the host.  We expect the host to just terminate
> > > > >      us because of the mismatch, but this will interact better with
> > > > >      host side options setting policy for panic states and the like.
> > > > >      Essentially an SVM kernel should behave like an old kernel with
> > > > >      no XIVE support at all, at least w.r.t. the CAS irq mode flags.
> > > > 
> > > > Yes. XIVE shouldn't be requested by the guest.
> > > 
> > > 	Ok.
> > > 
> > > > This is the last option 
> > > > I proposed but I thought there was some negotiation with the hypervisor
> > > > which is not the case. 
> > > > 
> > > > >   3) Although there are means by which the hypervisor can kind of know
> > > > >      a guest is in secure mode, there's not really an "svm=on" option
> > > > >      on the host side.  For the most part secure mode is based on
> > > > >      discussion directly between the guest and the ultravisor with
> > > > >      almost no hypervisor intervention.
> > > > 
> > > > Is there a negotiation with the ultravisor ? 
> > > 
> > > 	The VM has no negotiation with the ultravisor w.r.t CAS.
> > > 
> > > > 
> > > > >   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
> > > > >      to write to event queues in guest memory, which would have to be
> > > > >      explicitly shared for secure mode.  That's true whether it's KVM
> > > > >      or qemu accessing the guest memory, so kernel_irqchip=on/off is
> > > > >      entirely irrelevant.
> > > > 
> > > > This problem should be already fixed.
> > > > The XIVE event queues are shared 
> > >  	
> > > Yes i have a patch for the guest kernel that shares the event 
> > > queue page with the hypervisor. This is done using the
> > > UV_SHARE_PAGE ultracall. This patch is not sent out to any any mailing
> > > lists yet.
> > 
> > Why ?
> 
> At this point I am not sure if this is the only change, I need to the
> guest kernel.

Maybe but we're already sure that this change is needed. I don't really see
the point in holding this any longer.

>  I also need changes to KVM and to the ultravisor. Its bit
> premature to send the patch without having figured out everything
> to get xive working on a Secure VM.
> 

I'm a bit confused... why did you send this workaround patch in
the first place then ? I mean, this raises a concern and we're
just trying to move forward.

> > 
> > > However the patch by itself does not solve the xive problem
> > > for secure VM.
> > > 
> > 
> > This patch would allow at least to answer Cedric's question about
> > kernel_irqchip=off, since this looks like the only thing needed
> > to make it work.
> 
> hmm.. I am not sure. Are you saying
> (a) patch the guest kernel to share the event queue page
> (b) run the qemu with "kernel_irqchip=off"
> (c) and the guest kernel with "svm=on"
> 
> and it should all work?
> 

Yes.

> RP
> 

