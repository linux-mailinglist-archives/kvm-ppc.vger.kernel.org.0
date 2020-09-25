Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D1D27931A
	for <lists+kvm-ppc@lfdr.de>; Fri, 25 Sep 2020 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIYVRi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 25 Sep 2020 17:17:38 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14115 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgIYVRi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 25 Sep 2020 17:17:38 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6e5e410000>; Fri, 25 Sep 2020 14:16:49 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 25 Sep
 2020 21:17:36 +0000
Subject: Re: [PATCH 1/2] ext4/xfs: add page refcount helper
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Linux MM <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        "Matthew Wilcox" <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        "John Hubbard" <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Bharata B Rao" <bharata@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
References: <20200925204442.31348-1-rcampbell@nvidia.com>
 <20200925204442.31348-2-rcampbell@nvidia.com>
 <CAPcyv4iOgN6nmF0N4hQGZo-DJNh3UAf1wDy1ata1Rc+RQWVH=Q@mail.gmail.com>
From:   Ralph Campbell <rcampbell@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <dc16b898-f392-eade-9677-88c3ce725484@nvidia.com>
Date:   Fri, 25 Sep 2020 14:17:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iOgN6nmF0N4hQGZo-DJNh3UAf1wDy1ata1Rc+RQWVH=Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601068610; bh=EgKHbA7P4sEfdcZAs8fcPF/wZN6SUEEW4m+FX39r4FY=;
        h=Subject:To:CC:References:From:X-Nvconfidentiality:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=mRFvt3JSueoEWvwICZCtnFGa+CBOawclGIrvlOOYYnVV+c9H8APX2UD5/WRg/rIpQ
         iRHtyRxzOIBQcaM1YW3U6CvXzczYwaaVzh4ZdnnHi9ZH5TBwj8G7a84q/pAhQmItgd
         jY6txErAZcfqDt2aGYSNWuU+680aNN2zQ+C9yMFoaix/5AnnoKzMacVpPtUM9SGOEm
         c26UgiTgZhherdWlA59r6hFrDcbu0Yqf4o4Rz0YdD7VECNxlbZY/sMD3KHkMTt+2OF
         RbbEbzZP2k28tHb5I9BOGFuLo3524Z0DylKGJdS3kjrUkFJsCEOHtHGEzUCBoX8Dn+
         Bsn6H7P1KF+ng==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 9/25/20 1:51 PM, Dan Williams wrote:
> On Fri, Sep 25, 2020 at 1:45 PM Ralph Campbell <rcampbell@nvidia.com> wrote:
>>
>> There are several places where ZONE_DEVICE struct pages assume a reference
>> count == 1 means the page is idle and free. Instead of open coding this,
>> add a helper function to hide this detail.
>>
>> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
>> ---
>>   fs/dax.c            | 8 ++++----
>>   fs/ext4/inode.c     | 2 +-
>>   fs/xfs/xfs_file.c   | 2 +-
>>   include/linux/dax.h | 5 +++++
>>   4 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 994ab66a9907..8eddbcc0e149 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -358,7 +358,7 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>>          for_each_mapped_pfn(entry, pfn) {
>>                  struct page *page = pfn_to_page(pfn);
>>
>> -               WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
>> +               WARN_ON_ONCE(trunc && !dax_layout_is_idle_page(page));
>>                  WARN_ON_ONCE(page->mapping && page->mapping != mapping);
>>                  page->mapping = NULL;
>>                  page->index = 0;
>> @@ -372,7 +372,7 @@ static struct page *dax_busy_page(void *entry)
>>          for_each_mapped_pfn(entry, pfn) {
>>                  struct page *page = pfn_to_page(pfn);
>>
>> -               if (page_ref_count(page) > 1)
>> +               if (!dax_layout_is_idle_page(page))
>>                          return page;
>>          }
>>          return NULL;
>> @@ -560,11 +560,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
>>
>>   /**
>>    * dax_layout_busy_page - find first pinned page in @mapping
>> - * @mapping: address space to scan for a page with ref count > 1
>> + * @mapping: address space to scan for a page with ref count > 0
>>    *
>>    * DAX requires ZONE_DEVICE mapped pages. These pages are never
>>    * 'onlined' to the page allocator so they are considered idle when
>> - * page->count == 1. A filesystem uses this interface to determine if
>> + * page->count == 0. A filesystem uses this interface to determine if
>>    * any page in the mapping is busy, i.e. for DMA, or other
>>    * get_user_pages() usages.
>>    *
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index bf596467c234..d9f8ad55523a 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3927,7 +3927,7 @@ int ext4_break_layouts(struct inode *inode)
>>                          return 0;
>>
>>                  error = ___wait_var_event(&page->_refcount,
>> -                               atomic_read(&page->_refcount) == 1,
>> +                               dax_layout_is_idle_page(page),
>>                                  TASK_INTERRUPTIBLE, 0, 0,
>>                                  ext4_wait_dax_page(ei));
>>          } while (error == 0);
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index a29f78a663ca..29ab96541bc1 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -750,7 +750,7 @@ xfs_break_dax_layouts(
>>
>>          *retry = true;
>>          return ___wait_var_event(&page->_refcount,
>> -                       atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
>> +                       dax_layout_is_idle_page(page), TASK_INTERRUPTIBLE,
>>                          0, 0, xfs_wait_dax_page(inode));
>>   }
>>
>> diff --git a/include/linux/dax.h b/include/linux/dax.h
>> index 43b39ab9de1a..3f78ed78d1d6 100644
>> --- a/include/linux/dax.h
>> +++ b/include/linux/dax.h
>> @@ -238,4 +238,9 @@ static inline bool dax_mapping(struct address_space *mapping)
>>          return mapping->host && IS_DAX(mapping->host);
>>   }
>>
>> +static inline bool dax_layout_is_idle_page(struct page *page)
>> +{
>> +       return page_ref_count(page) <= 1;
> 
> Why convert the check from "== 1" to "<= 1" and then back to the ==
> operator in the next patch? A refcount < 1 in this path before your
> other change is a bug.
> 
Mostly I was thinking > 1 was busy so <= 1 is idle. And yes, <=0 is never
supposed to happen. Checking for == 1 is probably better though.
