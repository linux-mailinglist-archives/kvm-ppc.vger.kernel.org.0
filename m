Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF391874C5
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 22:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgCPVd6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 17:33:58 -0400
Received: from verein.lst.de ([213.95.11.211]:56432 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732641AbgCPVd6 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 16 Mar 2020 17:33:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EF2A268CEC; Mon, 16 Mar 2020 22:33:53 +0100 (CET)
Date:   Mon, 16 Mar 2020 22:33:53 +0100
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
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200316213353.GA28441@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-4-hch@lst.de> <20200316195923.GA26988@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316195923.GA26988@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 04:59:23PM -0300, Jason Gunthorpe wrote:
> However, between patch 3 and 4 doesn't this break amd gpu as it will
> return device_private pages now if not requested? Squash the two?

No change in behavior in this patch as long as HMM_PFN_DEVICE_PRIVATE
isn't set in ->pfns or ->default_flags, which is the case for both
nouveau and amdgpu.  The existing behavior is broken for private
pages not known to the driver, but that is fixed in the next patch.
