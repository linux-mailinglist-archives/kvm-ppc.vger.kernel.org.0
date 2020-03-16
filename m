Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E1A187226
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732280AbgCPSUn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 14:20:43 -0400
Received: from verein.lst.de ([213.95.11.211]:55742 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732279AbgCPSUm (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 16 Mar 2020 14:20:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E7A4568BFE; Mon, 16 Mar 2020 19:20:39 +0100 (CET)
Date:   Mon, 16 Mar 2020 19:20:39 +0100
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
Subject: Re: [PATCH 1/2] mm: handle multiple owners of device private pages
 in migrate_vma
Message-ID: <20200316182039.GA24736@lst.de>
References: <20200316175259.908713-1-hch@lst.de> <20200316175259.908713-2-hch@lst.de> <20200316181707.GJ20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316181707.GJ20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 03:17:07PM -0300, Jason Gunthorpe wrote:
> On Mon, Mar 16, 2020 at 06:52:58PM +0100, Christoph Hellwig wrote:
> > Add a new opaque owner field to struct dev_pagemap, which will allow
> > the hmm and migrate_vma code to identify who owns ZONE_DEVICE memory,
> > and refuse to work on mappings not owned by the calling entity.
> 
> Using a pointer seems like a good solution to me.
> 
> Is this a bug fix? What is the downside for migrate on pages it
> doesn't work? I'm not up to speed on migrate..

migrating private pages not owned by driver simply won't work, as
the device can't access it.  Even inside the same driver say
GPU A can't just migrate CPU B's memory.  In that sense it is
a bug fix for the rather unlikely case of using the experimental
nouveau with multiple GPUs, or in a power secure VM (if that is
even possible).
