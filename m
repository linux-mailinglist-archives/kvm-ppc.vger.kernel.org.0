Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E204326B084
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Sep 2020 00:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgIOQlQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 15 Sep 2020 12:41:16 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15003 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbgIOQkD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 15 Sep 2020 12:40:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60ee470004>; Tue, 15 Sep 2020 09:39:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 09:39:48 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 09:39:48 -0700
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 16:39:47 +0000
Subject: Re: [PATCH] mm: remove extra ZONE_DEVICE struct page refcount
To:     Christoph Hellwig <hch@infradead.org>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Linux MM <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
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
References: <20200914224509.17699-1-rcampbell@nvidia.com>
 <CAPcyv4gVJuWsOtejrKvWgByq=c1niwQOZ0HHYaSo4h6vc-Xw+Q@mail.gmail.com>
 <10b4b85c-f1e9-b6b5-74cd-6190ee0aca5d@nvidia.com>
 <20200915162956.GA21990@infradead.org>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <6dff5231-26d5-1aec-0c05-6880cf747642@nvidia.com>
Date:   Tue, 15 Sep 2020 09:39:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200915162956.GA21990@infradead.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600187975; bh=C1s92L4x7f4rIF6lqQWyaq+r/2kk7tSSBG+aULp1tK0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MjyrTGfIene7vVu5hucCl8X7jJJtGy4gEfp8s9S8BvUOqlyhVR/Jr/cF4kdzJc0Sy
         LCNccr/EB6s9AbvrN0g1vzjM0eTf5Ecb0AFIePVFELVPA01dU+slLbzDLM67GL26Ek
         hRD/99TeqMFmNTw8ILvsCZqgAHPunVc0BJXMZXgbWMvQ3LinUrL1J2/FZJuuGPurhp
         l2c3JDfB5skX8McyhBI3hpbKwAXU/D1yYeLTxWXKEYDXLR2Cc+bMRYvFmtgboy2agT
         8cLHw3JEIT9+4E0SQHnvIvwomdfJGbjdgwupYbPF07ykO5rH/LOpLA8eYXXUPqITk7
         Je7vqmrwPefZQ==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 9/15/20 9:29 AM, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 04:53:25PM -0700, Ralph Campbell wrote:
>> Since set_page_refcounted() is defined in mm_interal.h I would have to
>> move the definition to someplace like page_ref.h or have the drivers
>> cal init_page_count() or set_page_count() since get_page() calls
>> VM_BUG_ON_PAGE() if refcount == 0.
>> I'll move set_page_refcounted() since that is what the page allocator
>> uses and seems named for the purpose.
> 
> I don't think any of the three ->page_free instances even cares about
> the page refcount.
> 
Not true. The page_free() callback records the page is free by setting
a bit or putting the page on a free list but when it allocates a free
device private struct page to be used with migrate_vma_setup(), it needs to
increment the refcount.

For the ZONE_DEVICE MEMORY_DEVICE_GENERIC and MEMORY_DEVICE_PCI_P2PDMA
struct pages, I think you are correct because they don't define page_free()
and from what I can see, don't decrement the page refcount to zero.
