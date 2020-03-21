Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5A118DEBE
	for <lists+kvm-ppc@lfdr.de>; Sat, 21 Mar 2020 09:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgCUIWk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 21 Mar 2020 04:22:40 -0400
Received: from verein.lst.de ([213.95.11.211]:51201 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbgCUIWk (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 21 Mar 2020 04:22:40 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D1BDB68AFE; Sat, 21 Mar 2020 09:22:36 +0100 (CET)
Date:   Sat, 21 Mar 2020 09:22:36 +0100
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
Subject: Re: [PATCH 4/4] mm: check the device private page owner in
 hmm_range_fault
Message-ID: <20200321082236.GB28613@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-5-hch@lst.de> <20200320134109.GA30230@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320134109.GA30230@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 20, 2020 at 10:41:09AM -0300, Jason Gunthorpe wrote:
> Thinking about this some more, does the locking work out here?
> 
> hmm_range_fault() runs with mmap_sem in read, and does not lock any of
> the page table levels.
> 
> So it relies on accessing stale pte data being safe, and here we
> introduce for the first time a page pointer dereference and a pgmap
> dereference without any locking/refcounting.
> 
> The get_dev_pagemap() worked on the PFN and obtained a refcount, so it
> created safety.
> 
> Is there some tricky reason this is safe, eg a DEVICE_PRIVATE page
> cannot be removed from the vma without holding mmap_sem in write or
> something?

I don't think there is any specific protection.  Let me see if we
can throw in a get_dev_pagemap here - note that current mainline doesn't
even use it for this path..
