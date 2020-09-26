Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2562279748
	for <lists+kvm-ppc@lfdr.de>; Sat, 26 Sep 2020 08:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIZGfo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 26 Sep 2020 02:35:44 -0400
Received: from verein.lst.de ([213.95.11.211]:58466 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIZGfn (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 26 Sep 2020 02:35:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4A4B268AFE; Sat, 26 Sep 2020 08:35:40 +0200 (CEST)
Date:   Sat, 26 Sep 2020 08:35:39 +0200
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
Subject: Re: [PATCH 1/2] ext4/xfs: add page refcount helper
Message-ID: <20200926063539.GA3540@lst.de>
References: <20200925204442.31348-1-rcampbell@nvidia.com> <20200925204442.31348-2-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925204442.31348-2-rcampbell@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 25, 2020 at 01:44:41PM -0700, Ralph Campbell wrote:
>  		error = ___wait_var_event(&page->_refcount,
> -				atomic_read(&page->_refcount) == 1,
> +				dax_layout_is_idle_page(page),
>  				TASK_INTERRUPTIBLE, 0, 0,
>  				ext4_wait_dax_page(ei));

> +++ b/fs/xfs/xfs_file.c
> @@ -750,7 +750,7 @@ xfs_break_dax_layouts(
>  
>  	*retry = true;
>  	return ___wait_var_event(&page->_refcount,
> -			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
> +			dax_layout_is_idle_page(page), TASK_INTERRUPTIBLE,
>  			0, 0, xfs_wait_dax_page(inode));
>  }

I still think a litte helper macro would be nice here:

#define dax_wait_page(_inode, _page, _wait_cb)				\
  	___wait_var_event(&(_page)->_refcount,				\
		atomic_read(&(_page)->_refcount) == 1,			\
		TASK_INTERRUPTIBLE, dax_layout_is_idle_page(_page),	\
		TASK_INTERRUPTIBLE, 0, 0, _wait_cb(_inode));
