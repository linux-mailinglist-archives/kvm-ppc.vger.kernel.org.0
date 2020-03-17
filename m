Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074391884A7
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgCQM77 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 08:59:59 -0400
Received: from verein.lst.de ([213.95.11.211]:59732 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgCQM77 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 17 Mar 2020 08:59:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B400D68BFE; Tue, 17 Mar 2020 13:59:55 +0100 (CET)
Date:   Tue, 17 Mar 2020 13:59:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317125955.GA12847@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-4-hch@lst.de> <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com> <20200317121536.GQ20941@ziepe.ca> <20200317122445.GA11662@lst.de> <20200317122813.GA11866@lst.de> <20200317124755.GR20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317124755.GR20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 09:47:55AM -0300, Jason Gunthorpe wrote:
> I've been using v7 of Ralph's tester and it is working well - it has
> DEVICE_PRIVATE support so I think it can test this flow too. Ralph are
> you able?
> 
> This hunk seems trivial enough to me, can we include it now?

I can send a separate patch for it once the tester covers it.  I don't
want to add it to the original patch as it is a significant behavior
change compared to the existing code.
