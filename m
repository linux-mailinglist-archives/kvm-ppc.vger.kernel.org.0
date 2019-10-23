Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980B1E10C9
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Oct 2019 06:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfJWESE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 23 Oct 2019 00:18:04 -0400
Received: from ozlabs.org ([203.11.71.1]:35075 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfJWESE (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 23 Oct 2019 00:18:04 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46ycYN5gXnz9sP3; Wed, 23 Oct 2019 15:18:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1571804280; bh=9KBRfck31AwdyB+TwBrztEMyanxvGGo1pVKm/MhKRxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IZFr69yau7J3TkkX/EPdN6DorLZjYyymG/dxZUDUlQMQ2hgbLq68mNWuu5aszpmAR
         yZ9WqfwAoEBjJPVm3QPzuaUZ+14YMt2VbRmlm82fm+j6YDWXNRwynGttB54N0e4c1z
         NdTVDiPO26rxdD5W2Lm8Jhg7EKQ4R/lpbErmUeStjw05E0MRgDZHG0ifISCKaKyp7k
         vqT5g2s7qNG35mBMPeaMGDtMoeCwqwssmstpna9kiSS0qRcbMB2RDzbelffAU8Tg1k
         osnqknWkth3PLi8Y8pJq/gCIav+Oet+Y9a1KLLh7wk6y2p65eUwLO6qsMPjOyLPI9U
         mwTi/fzpgpi9g==
Date:   Wed, 23 Oct 2019 15:17:54 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata.rao@gmail.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>, linuxram@us.ibm.com,
        cclaudio@linux.ibm.com, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, jglisse@redhat.com,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        paulus@au1.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 2/8] KVM: PPC: Move pages between normal and secure
 memory
Message-ID: <20191023041754.GA5809@oak.ozlabs.ibm.com>
References: <20190925050649.14926-1-bharata@linux.ibm.com>
 <20190925050649.14926-3-bharata@linux.ibm.com>
 <20191018030049.GA907@oak.ozlabs.ibm.com>
 <CAGZKiBqoxAvix3wrF2wuxTrikVCjY6PzD22pHsasew-F=P3KSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZKiBqoxAvix3wrF2wuxTrikVCjY6PzD22pHsasew-F=P3KSg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Oct 22, 2019 at 11:59:35AM +0530, Bharata B Rao wrote:
> On Fri, Oct 18, 2019 at 8:31 AM Paul Mackerras <paulus@ozlabs.org> wrote:
> >
> > On Wed, Sep 25, 2019 at 10:36:43AM +0530, Bharata B Rao wrote:
> > > Manage migration of pages betwen normal and secure memory of secure
> > > guest by implementing H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.
> > >
> > > H_SVM_PAGE_IN: Move the content of a normal page to secure page
> > > H_SVM_PAGE_OUT: Move the content of a secure page to normal page
> > >
> > > Private ZONE_DEVICE memory equal to the amount of secure memory
> > > available in the platform for running secure guests is created.
> > > Whenever a page belonging to the guest becomes secure, a page from
> > > this private device memory is used to represent and track that secure
> > > page on the HV side. The movement of pages between normal and secure
> > > memory is done via migrate_vma_pages() using UV_PAGE_IN and
> > > UV_PAGE_OUT ucalls.
> >
> > As we discussed privately, but mentioning it here so there is a
> > record:  I am concerned about this structure
> >
> > > +struct kvmppc_uvmem_page_pvt {
> > > +     unsigned long *rmap;
> > > +     struct kvm *kvm;
> > > +     unsigned long gpa;
> > > +};
> >
> > which keeps a reference to the rmap.  The reference could become stale
> > if the memslot is deleted or moved, and nothing in the patch series
> > ensures that the stale references are cleaned up.
> 
> I will add code to release the device PFNs when memslot goes away. In
> fact the early versions of the patchset had this, but it subsequently
> got removed.
> 
> >
> > If it is possible to do without the long-term rmap reference, and
> > instead find the rmap via the memslots (with the srcu lock held) each
> > time we need the rmap, that would be safer, I think, provided that we
> > can sort out the lock ordering issues.
> 
> All paths except fault handler access rmap[] under srcu lock. Even in
> case of fault handler, for those faults induced by us (shared page
> handling, releasing device pfns), we do hold srcu lock. The difficult
> case is when we fault due to HV accessing a device page. In this case
> we come to fault hanler with mmap_sem already held and are not in a
> position to take kvm srcu lock as that would lead to lock order
> reversal. Given that we have pages mapped in still, I assume memslot
> can't go away while we access rmap[], so think we should be ok here.

The mapping of pages in userspace memory, and the mapping of userspace
memory to guest physical space, are two distinct things.  The memslots
describe the mapping of userspace addresses to guest physical
addresses, but don't say anything about what is mapped at those
userspace addresses.  So you can indeed get a page fault on a
userspace address at the same time that a memslot is being deleted
(even a memslot that maps that particular userspace address), because
removing the memslot does not unmap anything from userspace memory,
it just breaks the association between that userspace memory and guest
physical memory.  Deleting the memslot does unmap the pages from the
guest but doesn't unmap them from the userspace process (e.g. QEMU).

It is an interesting question what the semantics should be when a
memslot is deleted and there are pages of userspace currently paged
out to the device (i.e. the ultravisor).  One approach might be to say
that all those pages have to come back to the host before we finish
the memslot deletion, but that is probably not necessary; I think we
could just say that those pages are gone and can be replaced by zero
pages if they get accessed on the host side.  If userspace then unmaps
the corresponding region of the userspace memory map, we can then just
forget all those pages with very little work.

> However if that sounds fragile, may be I can go back to my initial
> design where we weren't using rmap[] to store device PFNs. That will
> increase the memory usage but we give us an easy option to have
> per-guest mutex to protect concurrent page-ins/outs/faults.

That sounds like it would be the best option, even if only in the
short term.  At least it would give us a working solution, even if
it's not the best performing solution.

Paul.
