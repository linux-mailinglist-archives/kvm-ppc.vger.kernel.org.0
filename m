Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFA526BBDB
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 07:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgIPFhB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Sep 2020 01:37:01 -0400
Received: from verein.lst.de ([213.95.11.211]:50829 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPFhB (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 16 Sep 2020 01:37:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C02568BFE; Wed, 16 Sep 2020 07:36:54 +0200 (CEST)
Date:   Wed, 16 Sep 2020 07:36:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
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
Message-ID: <20200916053653.GA7321@lst.de>
References: <20200914224509.17699-1-rcampbell@nvidia.com> <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com> <10b4b85c-f1e9-b6b5-74cd-6190ee0aca5d@nvidia.com> <20200915162956.GA21990@infradead.org> <6dff5231-26d5-1aec-0c05-6880cf747642@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dff5231-26d5-1aec-0c05-6880cf747642@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Sep 15, 2020 at 09:39:47AM -0700, Ralph Campbell wrote:
>> I don't think any of the three ->page_free instances even cares about
>> the page refcount.
>>
> Not true. The page_free() callback records the page is free by setting
> a bit or putting the page on a free list but when it allocates a free
> device private struct page to be used with migrate_vma_setup(), it needs to
> increment the refcount.
>
> For the ZONE_DEVICE MEMORY_DEVICE_GENERIC and MEMORY_DEVICE_PCI_P2PDMA
> struct pages, I think you are correct because they don't define page_free()
> and from what I can see, don't decrement the page refcount to zero.

Umm, the whole point of ZONE_DEVICE is to have a struct page for
something that is not system memory.  For both the ppc kvm case (magic
hypervisor pool) and Noveau (device internal) memory that clear is the
case.  But looks like test_hmm uses normal pages to fake this up, so
I was wrong about the third caller.  But I think we can just call
set_page_count just before freeing the page there with a comment
explaining what is goin on.
