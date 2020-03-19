Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E279518AD3B
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 08:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgCSHQh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 03:16:37 -0400
Received: from verein.lst.de ([213.95.11.211]:40474 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSHQh (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Mar 2020 03:16:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5507E68C65; Thu, 19 Mar 2020 08:16:33 +0100 (CET)
Date:   Thu, 19 Mar 2020 08:16:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: ensure device private pages have an owner v2
Message-ID: <20200319071633.GA32522@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200319002849.GG20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319002849.GG20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Mar 18, 2020 at 09:28:49PM -0300, Jason Gunthorpe wrote:
> > Changes since v1:
> >  - split out the pgmap->owner addition into a separate patch
> >  - check pgmap->owner is set for device private mappings
> >  - rename the dev_private_owner field in struct migrate_vma to src_owner
> >  - refuse to migrate private pages if src_owner is not set
> >  - keep the non-fault device private handling in hmm_range_fault
> 
> I'm happy enough to take this, did you have plans for a v3?

I think the only open question is if merging 3 and 4 might make sense.
It's up to you if you want it resent that way or not.
