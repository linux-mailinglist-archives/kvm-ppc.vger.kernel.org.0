Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378D6280D3F
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Oct 2020 07:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgJBF7f (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Oct 2020 01:59:35 -0400
Received: from verein.lst.de ([213.95.11.211]:51084 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgJBF7e (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 2 Oct 2020 01:59:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C3CBB68BEB; Fri,  2 Oct 2020 07:59:30 +0200 (CEST)
Date:   Fri, 2 Oct 2020 07:59:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [RFC PATCH v3 2/2] mm: remove extra ZONE_DEVICE struct page
 refcount
Message-ID: <20201002055930.GB8891@lst.de>
References: <20201001181715.17416-1-rcampbell@nvidia.com> <20201001181715.17416-3-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001181715.17416-3-rcampbell@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 01, 2020 at 11:17:15AM -0700, Ralph Campbell wrote:
> ZONE_DEVICE struct pages have an extra reference count that complicates the
> code for put_page() and several places in the kernel that need to check the
> reference count to see that a page is not being used (gup, compaction,
> migration, etc.). Clean up the code so the reference count doesn't need to
> be treated specially for ZONE_DEVICE.
> 
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
