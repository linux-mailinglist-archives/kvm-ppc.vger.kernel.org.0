Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FBC2792A9
	for <lists+kvm-ppc@lfdr.de>; Fri, 25 Sep 2020 22:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIYUvp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 25 Sep 2020 16:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgIYUvp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 25 Sep 2020 16:51:45 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999DDC0613CE
        for <kvm-ppc@vger.kernel.org>; Fri, 25 Sep 2020 13:51:44 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n22so3905778edt.4
        for <kvm-ppc@vger.kernel.org>; Fri, 25 Sep 2020 13:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mlgRZ8EIdOR1DUsE60QDF3pdVLwyWMe5uQg0KYqZh8=;
        b=lLK1nDqkdE4kFMX940riOKRARxVPqhXy/zVsS1A2BF583+Bs6t1HB1PWpX8FT5fmMG
         kj4laN7PoFAAtTf7nKQSfmgnZthfYdYFaYc0Bz7Y4wYumWs+ZoZt7fmJ8iqWpP6o5/sH
         kFEKtwuYlk8CyIxak76lqkTU29ToFQ6l7KznxP19PVlyKf6+tAzcGhQhn+oCjZs+I/BG
         hZj0p+yuyE04b9WjaCBMYkiqC6sMzMV4Oux/HTOgLFkJAvw3LNpYth20Ega3GkDNOEsf
         zaPOXph5obEzLyOHAdc1MO70dyb/pb3ItgeObMBTO/ckPhs1YDk3R/RfTdj8iII54jF+
         B2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mlgRZ8EIdOR1DUsE60QDF3pdVLwyWMe5uQg0KYqZh8=;
        b=YSXxuDaJEZw+EWFbj7N5fHnZ/TPKG3kRvR1mEyoC+V3ZGGPIWINPIZctcwfHBOnt3C
         BOlkjZbdnKE1g5fYjlhmb3i5ZuVW6XNTCcHYI/aIXAQRIvZwCOl4Sgb/lw28hmsujoqM
         zB8M4Ii4Yp8W327sm1BeMQrT2EIkqBHhEeyWscEch9dhwb3vk+fRF4LFUU7rCLFRzUoH
         xAfOq9T4xtBoANUW9OLGP0PTmGkIZ3Gqwf8G1K/warDw2lu4CxBy+NJ3MRz8VIIpQjF8
         JwQrGFnqlCn0Qh37XZIzGRTFRNtEmheCRnc1B+C2k7/D82n6CGl5SBdyuUYwulppg9D6
         lHOg==
X-Gm-Message-State: AOAM532E4dwpwD3xNAK0Di2Llu2iwMkUMHJDnd8eDcD0RYThbb6jJ0b2
        /5JYoTzgNEw+6uyNsOCp7g8Xo+zHKfI2Jm+Cd011mA==
X-Google-Smtp-Source: ABdhPJw5Nq9khn3WBHc4y05yhciUUDN3DTtsOPc4oBfxkZyBg1L19vOrTNS0zLznVWAuuf5nyBS89YukU7GH7FAKcjI=
X-Received: by 2002:aa7:d58e:: with SMTP id r14mr3532250edq.52.1601067103227;
 Fri, 25 Sep 2020 13:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200925204442.31348-1-rcampbell@nvidia.com> <20200925204442.31348-2-rcampbell@nvidia.com>
In-Reply-To: <20200925204442.31348-2-rcampbell@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 25 Sep 2020 13:51:31 -0700
Message-ID: <CAPcyv4iOgN6nmF0N4hQGZo-DJNh3UAf1wDy1ata1Rc+RQWVH=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] ext4/xfs: add page refcount helper
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Linux MM <linux-mm@kvack.org>, kvm-ppc@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 25, 2020 at 1:45 PM Ralph Campbell <rcampbell@nvidia.com> wrote:
>
> There are several places where ZONE_DEVICE struct pages assume a reference
> count == 1 means the page is idle and free. Instead of open coding this,
> add a helper function to hide this detail.
>
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> ---
>  fs/dax.c            | 8 ++++----
>  fs/ext4/inode.c     | 2 +-
>  fs/xfs/xfs_file.c   | 2 +-
>  include/linux/dax.h | 5 +++++
>  4 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 994ab66a9907..8eddbcc0e149 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -358,7 +358,7 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>         for_each_mapped_pfn(entry, pfn) {
>                 struct page *page = pfn_to_page(pfn);
>
> -               WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> +               WARN_ON_ONCE(trunc && !dax_layout_is_idle_page(page));
>                 WARN_ON_ONCE(page->mapping && page->mapping != mapping);
>                 page->mapping = NULL;
>                 page->index = 0;
> @@ -372,7 +372,7 @@ static struct page *dax_busy_page(void *entry)
>         for_each_mapped_pfn(entry, pfn) {
>                 struct page *page = pfn_to_page(pfn);
>
> -               if (page_ref_count(page) > 1)
> +               if (!dax_layout_is_idle_page(page))
>                         return page;
>         }
>         return NULL;
> @@ -560,11 +560,11 @@ static void *grab_mapping_entry(struct xa_state *xas,
>
>  /**
>   * dax_layout_busy_page - find first pinned page in @mapping
> - * @mapping: address space to scan for a page with ref count > 1
> + * @mapping: address space to scan for a page with ref count > 0
>   *
>   * DAX requires ZONE_DEVICE mapped pages. These pages are never
>   * 'onlined' to the page allocator so they are considered idle when
> - * page->count == 1. A filesystem uses this interface to determine if
> + * page->count == 0. A filesystem uses this interface to determine if
>   * any page in the mapping is busy, i.e. for DMA, or other
>   * get_user_pages() usages.
>   *
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bf596467c234..d9f8ad55523a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3927,7 +3927,7 @@ int ext4_break_layouts(struct inode *inode)
>                         return 0;
>
>                 error = ___wait_var_event(&page->_refcount,
> -                               atomic_read(&page->_refcount) == 1,
> +                               dax_layout_is_idle_page(page),
>                                 TASK_INTERRUPTIBLE, 0, 0,
>                                 ext4_wait_dax_page(ei));
>         } while (error == 0);
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index a29f78a663ca..29ab96541bc1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -750,7 +750,7 @@ xfs_break_dax_layouts(
>
>         *retry = true;
>         return ___wait_var_event(&page->_refcount,
> -                       atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> +                       dax_layout_is_idle_page(page), TASK_INTERRUPTIBLE,
>                         0, 0, xfs_wait_dax_page(inode));
>  }
>
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 43b39ab9de1a..3f78ed78d1d6 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -238,4 +238,9 @@ static inline bool dax_mapping(struct address_space *mapping)
>         return mapping->host && IS_DAX(mapping->host);
>  }
>
> +static inline bool dax_layout_is_idle_page(struct page *page)
> +{
> +       return page_ref_count(page) <= 1;

Why convert the check from "== 1" to "<= 1" and then back to the ==
operator in the next patch? A refcount < 1 in this path before your
other change is a bug.
