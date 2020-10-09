Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F47288F34
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Oct 2020 18:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbgJIQxx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Oct 2020 12:53:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:27293 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389334AbgJIQxx (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 9 Oct 2020 12:53:53 -0400
IronPort-SDR: X2afcn6UEUQFXSLFjqmvqC7MrfpGBq9wBp9IDl4zl3bbgTO5ejvSsySkG9iymqrY492C6bdh1L
 Z9pHfzhgPHCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="153343172"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="153343172"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 09:53:51 -0700
IronPort-SDR: cZPsX0pTjYEGuD0ArdpSCuRg3di0O8Q5VtMLwajHT3ZQMVDnnXcOC/xpo+DvF5F75jcclyC3Q9
 zRwAKC+0JvpA==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="528996042"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 09:53:50 -0700
Date:   Fri, 9 Oct 2020 09:53:50 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH] mm: make device private reference counts zero based
Message-ID: <20201009165350.GV2046448@iweiny-DESK2.sc.intel.com>
References: <20201008172544.29905-1-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008172544.29905-1-rcampbell@nvidia.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 08, 2020 at 10:25:44AM -0700, Ralph Campbell wrote:
> ZONE_DEVICE struct pages have an extra reference count that complicates the
> code for put_page() and several places in the kernel that need to check the
> reference count to see that a page is not being used (gup, compaction,
> migration, etc.). Clean up the code so the reference count doesn't need to
> be treated specially for device private pages, leaving DAX as still being
> a special case.

What about the check in mc_handle_swap_pte()?

mm/memcontrol.c:

5513                 /*
5514                  * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
5515                  * a refcount of 1 when free (unlike normal page)
5516                  */
5517                 if (!page_ref_add_unless(page, 1, 1))
5518                         return NULL;

... does that need to change?  Perhaps just the comment?

> 
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> ---
> 

[snip]

>  
>  void put_devmap_managed_page(struct page *page);
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index e151a7f10519..bf92a261fa6f 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -509,10 +509,15 @@ static bool dmirror_allocate_chunk(struct dmirror_device *mdevice,
>  		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),
>  		pfn_first, pfn_last);
>  
> +	/*
> +	 * Pages are created with an initial reference count of one but should
> +	 * have a reference count of zero while in the free state.
> +	 */
>  	spin_lock(&mdevice->lock);
>  	for (pfn = pfn_first; pfn < pfn_last; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
>  
> +		set_page_count(page, 0);

This confuses me.  How does this and init_page_count() not confuse the buddy
allocator?  Don't you have to reset the refcount somewhere after the test?

>  		page->zone_device_data = mdevice->free_pages;
>  		mdevice->free_pages = page;
>  	}
> @@ -561,7 +566,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>  	}
>  
>  	dpage->zone_device_data = rpage;
> -	get_page(dpage);
> +	init_page_count(dpage);
>  	lock_page(dpage);
>  	return dpage;
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index c43ccdddb0f6..e1443b73aa9b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
>  

[snip]

> diff --git a/mm/swap.c b/mm/swap.c
> index 0eb057141a04..93d880c6f73c 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -116,12 +116,11 @@ static void __put_compound_page(struct page *page)
>  void __put_page(struct page *page)
>  {
>  	if (is_zone_device_page(page)) {
> -		put_dev_pagemap(page->pgmap);
> -
>  		/*
>  		 * The page belongs to the device that created pgmap. Do
>  		 * not return it to page allocator.
>  		 */
> +		free_zone_device_page(page);

I really like this.

Ira

