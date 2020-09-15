Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1539426B0BC
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 00:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgIOQav (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 15 Sep 2020 12:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgIOQaH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 15 Sep 2020 12:30:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A2AC06178A;
        Tue, 15 Sep 2020 09:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h6yEPMjFBbOeI1nHQxJaBbzOjrvp/dwKRkVIewBPplw=; b=FhtjCj8afEHB9EsdL/O1b5MO2/
        OK+N3R3WT5KgfOVCwmnc4a/n2dIKiQ+/ejDpcIeJqi74/LSP+Gxn40SlUAvdZt7qDk0x/I7C7w7Ju
        AU9ZCb42uRy0emXWZNFN8nicvRtWmp8LJ+9zQOZ9IigttQPMYeLnHrp3vIkvVEL3Ef4v5NWOC5D9U
        stSRHSZTECQC2/tBVGL+C81bj3RqCLcB51xuge5sg1Dz7j2rGWv96p2WryvB9TkexpZTDrTeU8aGE
        QoY/NV7HTkDRAwMNETwcmEuHQsF+nv10JLN9MO8biw9/i7BcL7QTtszMrTYStLcdfTttoZH/dX9Re
        pb+bIffw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDq8-0005vd-4q; Tue, 15 Sep 2020 16:29:56 +0000
Date:   Tue, 15 Sep 2020 17:29:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Linux MM <linux-mm@kvack.org>, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: remove extra ZONE_DEVICE struct page refcount
Message-ID: <20200915162956.GA21990@infradead.org>
References: <20200914224509.17699-1-rcampbell@nvidia.com>
 <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com>
 <10b4b85c-f1e9-b6b5-74cd-6190ee0aca5d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10b4b85c-f1e9-b6b5-74cd-6190ee0aca5d@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 14, 2020 at 04:53:25PM -0700, Ralph Campbell wrote:
> Since set_page_refcounted() is defined in mm_interal.h I would have to
> move the definition to someplace like page_ref.h or have the drivers
> cal init_page_count() or set_page_count() since get_page() calls
> VM_BUG_ON_PAGE() if refcount == 0.
> I'll move set_page_refcounted() since that is what the page allocator
> uses and seems named for the purpose.

I don't think any of the three ->page_free instances even cares about
the page refcount.
