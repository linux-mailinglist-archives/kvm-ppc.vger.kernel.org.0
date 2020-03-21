Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC418E259
	for <lists+kvm-ppc@lfdr.de>; Sat, 21 Mar 2020 16:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCUPS3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 21 Mar 2020 11:18:29 -0400
Received: from verein.lst.de ([213.95.11.211]:52164 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgCUPS2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 21 Mar 2020 11:18:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 264F468BEB; Sat, 21 Mar 2020 16:18:26 +0100 (CET)
Date:   Sat, 21 Mar 2020 16:18:25 +0100
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
Message-ID: <20200321151825.GA7692@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-5-hch@lst.de> <20200320134109.GA30230@ziepe.ca> <20200321082236.GB28613@lst.de> <20200321123804.GV20941@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321123804.GV20941@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Mar 21, 2020 at 09:38:04AM -0300, Jason Gunthorpe wrote:
> > I don't think there is any specific protection.  Let me see if we
> > can throw in a get_dev_pagemap here
> 
> The page tables are RCU protected right? could we do something like
> 
>  if (is_device_private_entry()) {
>        rcu_read_lock()
>        if (READ_ONCE(*ptep) != pte)
>            return -EBUSY;
>        hmm_is_device_private_entry()
>        rcu_read_unlock()
>  }
> 
> ?

Are they everywhere?  I'd really love to hear from people that really
know this ara..

> 
> Then pgmap needs a synchronize_rcu before the struct page's are
> destroyed (possibly gup_fast already requires this?)
> 
> I've got some other patches trying to close some of these styles of
> bugs, but 
> 
> > note that current mainline doesn't even use it for this path..
> 
> Don't follow?

If you look at mainline (or any other tree), we only do a
get_dev_pagemap for devmap ptes.  But device private pages are encoded
as non-present swap ptes.
