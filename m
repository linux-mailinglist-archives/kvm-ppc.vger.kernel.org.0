Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402F926BC42
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 08:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIPGK5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Sep 2020 02:10:57 -0400
Received: from verein.lst.de ([213.95.11.211]:51011 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgIPGK5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 16 Sep 2020 02:10:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE21568B05; Wed, 16 Sep 2020 08:10:54 +0200 (CEST)
Date:   Wed, 16 Sep 2020 08:10:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
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
Message-ID: <20200916061054.GC7321@lst.de>
References: <20200914224509.17699-1-rcampbell@nvidia.com> <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 14, 2020 at 04:10:38PM -0700, Dan Williams wrote:
> You also need to fix up ext4_break_layouts() and
> xfs_break_dax_layouts() to expect ->_refcount is 0 instead of 1. This
> also needs some fstests exposure.

While we're at it, can we add a wait_fsdax_unref helper macro that hides
the _refcount access from the file systems?
