Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2E6187304
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbgCPTIC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:08:02 -0400
Received: from verein.lst.de ([213.95.11.211]:55963 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732298AbgCPTIC (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 16 Mar 2020 15:08:02 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EB43068BFE; Mon, 16 Mar 2020 20:07:58 +0100 (CET)
Date:   Mon, 16 Mar 2020 20:07:58 +0100
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
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
Message-ID: <20200316190758.GA25536@lst.de>
References: <20200316175259.908713-1-hch@lst.de> <20200316175259.908713-3-hch@lst.de> <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com> <20200316190443.GM20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316190443.GM20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 04:04:43PM -0300, Jason Gunthorpe wrote:
> > This is not actually true. OpenCL 2.x does support SVM with nouveau and
> > device private memory via clEnqueueSVMMigrateMem().
> > Also, Ben Skeggs has accepted a set of patches to map GPU memory after being
> > migrated and this change would conflict with that.
> 
> Other than the page_to_dmem() possibly doing container_of on the wrong
> type pgmap, are there other bugs here to fix?

It fixes that bug, as well as making sure everyone gets this check
right by default.

> Something like this is probably close to the right thing to fix that
> and work with Christoph's 1/2 patch - Ralph can you check, test, etc?

I don't think we need the get_dev_pagemap.  For device private pages
we can derive the page using device_private_entry_to_page and just
use that.  Let me resend a proper series.
