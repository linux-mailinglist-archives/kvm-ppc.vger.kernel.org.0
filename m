Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801A3177E07
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Mar 2020 18:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbgCCRpu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Tue, 3 Mar 2020 12:45:50 -0500
Received: from 14.mo7.mail-out.ovh.net ([178.33.251.19]:43643 "EHLO
        14.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730993AbgCCRpu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Mar 2020 12:45:50 -0500
Received: from player695.ha.ovh.net (unknown [10.110.171.148])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id CB99915628F
        for <kvm-ppc@vger.kernel.org>; Tue,  3 Mar 2020 18:45:45 +0100 (CET)
Received: from kaod.org (unknown [129.41.47.1])
        (Authenticated sender: groug@kaod.org)
        by player695.ha.ovh.net (Postfix) with ESMTPSA id 82630FE6A0C6;
        Tue,  3 Mar 2020 17:45:27 +0000 (UTC)
Date:   Tue, 3 Mar 2020 18:45:20 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@fr.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        mpe@ellerman.id.au, bauerman@linux.ibm.com, andmike@linux.ibm.com,
        sukadev@linux.vnet.ibm.com, aik@ozlabs.ru, paulus@ozlabs.org
Subject: Re: [RFC PATCH v1] powerpc/prom_init: disable XIVE in Secure VM.
Message-ID: <20200303184520.632be270@bahia.home>
In-Reply-To: <20200303170205.GA5416@oc0525413822.ibm.com>
References: <1582962844-26333-1-git-send-email-linuxram@us.ibm.com>
        <20200302233240.GB35885@umbus.fritz.box>
        <8f0c3d41-d1f9-7e6d-276b-b95238715979@fr.ibm.com>
        <20200303170205.GA5416@oc0525413822.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 10937273172029577675
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddtiedguddtjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpuddvledrgedurdegjedrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileehrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhdqphhptgesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 3 Mar 2020 09:02:05 -0800
Ram Pai <linuxram@us.ibm.com> wrote:

> On Tue, Mar 03, 2020 at 07:50:08AM +0100, Cédric Le Goater wrote:
> > On 3/3/20 12:32 AM, David Gibson wrote:
> > > On Fri, Feb 28, 2020 at 11:54:04PM -0800, Ram Pai wrote:
> > >> XIVE is not correctly enabled for Secure VM in the KVM Hypervisor yet.
> > >>
> > >> Hence Secure VM, must always default to XICS interrupt controller.
> > >>
> > >> If XIVE is requested through kernel command line option "xive=on",
> > >> override and turn it off.
> > >>
> > >> If XIVE is the only supported platform interrupt controller; specified
> > >> through qemu option "ic-mode=xive", simply abort. Otherwise default to
> > >> XICS.
> > > 
> > > Uh... the discussion thread here seems to have gotten oddly off
> > > track.  
> > 
> > There seem to be multiple issues. It is difficult to have a clear status.
> > 
> > > So, to try to clean up some misunderstandings on both sides:
> > > 
> > >   1) The guest is the main thing that knows that it will be in secure
> > >      mode, so it's reasonable for it to conditionally use XIVE based
> > >      on that
> > 
> > FW support is required AFAIUI.
> > >   2) The mechanism by which we do it here isn't quite right.  Here the
> > >      guest is checking itself that the host only allows XIVE, but we
> > >      can't do XIVE and is panic()ing.  Instead, in the SVM case we
> > >      should force support->xive to false, and send that in the CAS
> > >      request to the host.  We expect the host to just terminate
> > >      us because of the mismatch, but this will interact better with
> > >      host side options setting policy for panic states and the like.
> > >      Essentially an SVM kernel should behave like an old kernel with
> > >      no XIVE support at all, at least w.r.t. the CAS irq mode flags.
> > 
> > Yes. XIVE shouldn't be requested by the guest.
> 
> 	Ok.
> 
> > This is the last option 
> > I proposed but I thought there was some negotiation with the hypervisor
> > which is not the case. 
> > 
> > >   3) Although there are means by which the hypervisor can kind of know
> > >      a guest is in secure mode, there's not really an "svm=on" option
> > >      on the host side.  For the most part secure mode is based on
> > >      discussion directly between the guest and the ultravisor with
> > >      almost no hypervisor intervention.
> > 
> > Is there a negotiation with the ultravisor ? 
> 
> 	The VM has no negotiation with the ultravisor w.r.t CAS.
> 
> > 
> > >   4) I'm guessing the problem with XIVE in SVM mode is that XIVE needs
> > >      to write to event queues in guest memory, which would have to be
> > >      explicitly shared for secure mode.  That's true whether it's KVM
> > >      or qemu accessing the guest memory, so kernel_irqchip=on/off is
> > >      entirely irrelevant.
> > 
> > This problem should be already fixed.
> > The XIVE event queues are shared 
>  	
> Yes i have a patch for the guest kernel that shares the event 
> queue page with the hypervisor. This is done using the
> UV_SHARE_PAGE ultracall. This patch is not sent out to any any mailing
> lists yet.

Why ?

> However the patch by itself does not solve the xive problem
> for secure VM.
> 

This patch would allow at least to answer Cedric's question about
kernel_irqchip=off, since this looks like the only thing needed
to make it work.

> > and the remaining problem with XIVE is the KVM page fault handler 
> > populating the TIMA and ESB pages. Ultravisor doesn't seem to support
> > this feature and this breaks interrupt management in the guest. 
> 
> Yes. This is the bigger issue that needs to be fixed. When the secure guest
> accesses the page associated with the xive memslot, a page fault is
> generated, which the ultravisor reflects to the hypervisor. Hypervisor
> seems to be mapping Hardware-page to that GPA. Unforatunately it is not
> informing the ultravisor of that map.  I am trying to understand the
> root cause. But since I am not sure what more issues I might run into
> after chasing down that issue, I figured its better to disable xive
> support in SVM in the interim.
> 
> **** BTW: I figured, I dont need this intermin patch to disable xive for
> secure VM.  Just doing "svm=on xive=off" on the kernel command line is
> sufficient for now. *****
> 

No it is not. If the hypervisor doesn't propose XIVE (ie. ic-mode=xive
on the QEMU command line), the kernel simply ignores "xive=off".

> 
> > 
> > But, kernel_irqchip=off should work out of the box. It seems it doesn't. 
> > Something to investigate.
> 
> Dont know why. 
> 
> Does this option, disable the chip from interrupting the
> guest directly; instead mediates the interrupt through the hypervisor?
> 
> > 
> > > 
> > >   5) All the above said, having to use XICS is pretty crappy.  You
> > >      should really get working on XIVE support for secure VMs.
> > 
> > Yes. 
> 
> and yes too.
> 
> 
> Summary:  I am dropping this patch for now.
> 
> > 
> > Thanks,
> > 
> > C.
> 

