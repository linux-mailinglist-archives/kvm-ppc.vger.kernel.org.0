Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52AA506B
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Sep 2019 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfIBHyA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 2 Sep 2019 03:54:00 -0400
Received: from verein.lst.de ([213.95.11.211]:47870 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729457AbfIBHyA (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 2 Sep 2019 03:54:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3F54F227A8A; Mon,  2 Sep 2019 09:53:56 +0200 (CEST)
Date:   Mon, 2 Sep 2019 09:53:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v7 1/7] kvmppc: Driver to manage pages of secure guest
Message-ID: <20190902075356.GA28967@lst.de>
References: <20190822102620.21897-1-bharata@linux.ibm.com> <20190822102620.21897-2-bharata@linux.ibm.com> <20190829083810.GA13039@lst.de> <20190830034259.GD31913@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830034259.GD31913@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Aug 30, 2019 at 09:12:59AM +0530, Bharata B Rao wrote:
> On Thu, Aug 29, 2019 at 10:38:10AM +0200, Christoph Hellwig wrote:
> > On Thu, Aug 22, 2019 at 03:56:14PM +0530, Bharata B Rao wrote:
> > > +/*
> > > + * Bits 60:56 in the rmap entry will be used to identify the
> > > + * different uses/functions of rmap.
> > > + */
> > > +#define KVMPPC_RMAP_DEVM_PFN	(0x2ULL << 56)
> > 
> > How did you come up with this specific value?
> 
> Different usage types of RMAP array are being defined.
> https://patchwork.ozlabs.org/patch/1149791/
> 
> The above value is reserved for device pfn usage.

Shouldn't all these defintions go in together in a patch?  Also is bi
t 56+ a set of values, so is there 1 << 56 and 3 << 56 as well?  Seems
like even that other patch doesn't fully define these "pfn" values.

> > No need for !! when returning a bool.  Also the helper seems a little
> > pointless, just opencoding it would make the code more readable in my
> > opinion.
> 
> I expect similar routines for other usages of RMAP to come up.

Please drop them all.  Having to wade through a header to check for
a specific bit that also is set manually elsewhere in related code
just obsfucates it for the reader.

> > > +	*mig->dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
> > > +	return 0;
> > > +}
> > 
> > I think you can just merge this trivial helper into the only caller.
> 
> Yes I can, but felt it is nicely abstracted out to a function right now.

Not really.  It just fits the old calling conventions before I removed
the indirection.

> > Here we actually have two callers, but they have a fair amount of
> > duplicate code in them.  I think you want to move that common
> > code (including setting up the migrate_vma structure) into this
> > function and maybe also give it a more descriptive name.
> 
> Sure, I will give this a try. The name is already very descriptive, will
> come up with an appropriate name.

I don't think alloc_and_copy is very helpful.  It matches some of the
implementation, but not the intent.  Why not kvmppc_svm_page_in/out
similar to the hypervisor calls calling them?  Yes, for one case it
also gets called from the pagefault handler, but it still performs
these basic page in/out actions.

> BTW this file and the fuction prefixes in this file started out with
> kvmppc_hmm, switched to kvmppc_devm when HMM routines weren't used anymore.
> Now with the use of only non-dev versions, planning to swtich to
> kvmppc_uvmem_

That prefix sounds fine to me as well.
