Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7010A188402
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgCQMYu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 08:24:50 -0400
Received: from verein.lst.de ([213.95.11.211]:59523 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgCQMYu (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 17 Mar 2020 08:24:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 837AF68BFE; Tue, 17 Mar 2020 13:24:45 +0100 (CET)
Date:   Tue, 17 Mar 2020 13:24:45 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317122445.GA11662@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-4-hch@lst.de> <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com> <20200317121536.GQ20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317121536.GQ20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 09:15:36AM -0300, Jason Gunthorpe wrote:
> > Getting rid of HMM_PFN_DEVICE_PRIVATE seems reasonable to me since a driver can
> > look at the struct page but what if a driver needs to fault in a page from
> > another device's private memory? Should it call handle_mm_fault()?
> 
> Isn't that what this series basically does?
>
> The dev_private_owner is set to the type of pgmap the device knows how
> to handle, and everything else is automatically faulted for the
> device.
> 
> If the device does not know how to handle device_private then it sets
> dev_private_owner to NULL and it never gets device_private pfns.
> 
> Since the device_private pfn cannot be dma mapped, drivers must have
> explicit support for them.

No, with this series (and all actual callers before this series)
we never fault in device private pages.
