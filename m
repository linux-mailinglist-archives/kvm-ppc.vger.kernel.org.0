Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C204C288FEE
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Oct 2020 19:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgJIRYd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Oct 2020 13:24:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12551 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729888AbgJIRYC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Oct 2020 13:24:02 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f809ca50002>; Fri, 09 Oct 2020 10:23:49 -0700
Received: from rcampbell-dev.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 17:23:59 +0000
Subject: Re: [PATCH] mm: make device private reference counts zero based
To:     Ira Weiny <ira.weiny@intel.com>
CC:     <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "Alistair Popple" <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20201008172544.29905-1-rcampbell@nvidia.com>
 <20201009165350.GV2046448@iweiny-DESK2.sc.intel.com>
From:   Ralph Campbell <rcampbell@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <303a9deb-1eb5-0c60-fdc3-ecc8e94fd497@nvidia.com>
Date:   Fri, 9 Oct 2020 10:23:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20201009165350.GV2046448@iweiny-DESK2.sc.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602264229; bh=jS2VEpPTGk8U+9kdmlhESzw8NCjgAgg+Yto9qCnbLrk=;
        h=Subject:To:CC:References:From:X-Nvconfidentiality:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=rqnzXg4YsnTEDT6uAfRLfMpU0XqVk693X2B/JS3CCl9WPVYFj8myfbzMDML08Wugz
         VteWSxx5UaXSd7jg35Tg/UoE605Z8Plw0vYfRuW9tdJhYjXjdOjP65pm0x2Gc4f5gW
         +JSlgx7SFtq5NPkEtRI63xt+Yc11OhBfbE8Lyp+hIj5wq4vThvufy0Ak9e0WQWr/Ol
         2sUmS5pNmOdZGIOaZOWEHw1uYg8tyTwaIdfJzuP2UN8awDTC7ysGUFHzuzTK0hcChV
         gDhecY1EFbD9biQpLPJZMIuRfewxFhvERosshZOxfWVsnxG/d4/GGiXVI4OCq43u6B
         kiU/JWgugm6Sg==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 10/9/20 9:53 AM, Ira Weiny wrote:
> On Thu, Oct 08, 2020 at 10:25:44AM -0700, Ralph Campbell wrote:
>> ZONE_DEVICE struct pages have an extra reference count that complicates the
>> code for put_page() and several places in the kernel that need to check the
>> reference count to see that a page is not being used (gup, compaction,
>> migration, etc.). Clean up the code so the reference count doesn't need to
>> be treated specially for device private pages, leaving DAX as still being
>> a special case.
> 
> What about the check in mc_handle_swap_pte()?
> 
> mm/memcontrol.c:
> 
> 5513                 /*
> 5514                  * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
> 5515                  * a refcount of 1 when free (unlike normal page)
> 5516                  */
> 5517                 if (!page_ref_add_unless(page, 1, 1))
> 5518                         return NULL;
> 
> ... does that need to change?  Perhaps just the comment?

Thanks for spotting this.

Actually, this whole bit of code is never reached because the
   if (non_swap_entry(ent))
     return NULL;
covers device private pages and returns.

The device private pages are accounted for in mem_cgroup so this
probably needs fixing. I'll probably move the code before the
non_swap_entry() check and change the refcount increment to
page_ref_add_unless(page, 1, 0).

>>
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>> ---
>>
> 
> [snip]
> 
>>   
>>   void put_devmap_managed_page(struct page *page);
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index e151a7f10519..bf92a261fa6f 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -509,10 +509,15 @@ static bool dmirror_allocate_chunk(struct dmirror_device *mdevice,
>>   		mdevice->devmem_count * (DEVMEM_CHUNK_SIZE / (1024 * 1024)),
>>   		pfn_first, pfn_last);
>>   
>> +	/*
>> +	 * Pages are created with an initial reference count of one but should
>> +	 * have a reference count of zero while in the free state.
>> +	 */
>>   	spin_lock(&mdevice->lock);
>>   	for (pfn = pfn_first; pfn < pfn_last; pfn++) {
>>   		struct page *page = pfn_to_page(pfn);
>>   
>> +		set_page_count(page, 0);
> 
> This confuses me.  How does this and init_page_count() not confuse the buddy
> allocator?  Don't you have to reset the refcount somewhere after the test?

Device private struct pages are created with memmap_pages() and destroyed with
memunmap_pages(). They are never put on the LRU and never freed to the page
allocator. The refcount is set to zero by put_page() which triggers
the call to pgmap->page_free() instead. So only the driver handles the free pages
it creates.


>>   		page->zone_device_data = mdevice->free_pages;
>>   		mdevice->free_pages = page;
>>   	}
>> @@ -561,7 +566,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
>>   	}
>>   
>>   	dpage->zone_device_data = rpage;
>> -	get_page(dpage);
>> +	init_page_count(dpage);
>>   	lock_page(dpage);
>>   	return dpage;
>>   
>> diff --git a/mm/internal.h b/mm/internal.h
>> index c43ccdddb0f6..e1443b73aa9b 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>>   
> 
> [snip]
> 
>> diff --git a/mm/swap.c b/mm/swap.c
>> index 0eb057141a04..93d880c6f73c 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -116,12 +116,11 @@ static void __put_compound_page(struct page *page)
>>   void __put_page(struct page *page)
>>   {
>>   	if (is_zone_device_page(page)) {
>> -		put_dev_pagemap(page->pgmap);
>> -
>>   		/*
>>   		 * The page belongs to the device that created pgmap. Do
>>   		 * not return it to page allocator.
>>   		 */
>> +		free_zone_device_page(page);
> 
> I really like this.
> 
> Ira
> 
