Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0095637F875
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 15:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhEMNRJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 09:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhEMNRD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 09:17:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23421C061574;
        Thu, 13 May 2021 06:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CqhS/DjApfCwkLFCvP6kllDyz5SMs1FoNvFzUNiKyfA=; b=d8SS8qgwVEBfC/z564sa+2N9DF
        Wzl+TkORKwOMT+wsnvHLbotWjCbktxMqEnEd2QDACc1JoP6nuoT0gG+x6tSw0bH/nMZmg3vcFw6bk
        T9uVRNj0t06RnJG86r4+uzrnLHwlQSMb56hyRRPYQTBnk6U+x/MSZe3SCKnWIz/ozlPPAYy1gj+4q
        HvSfyuYYfdpXO5LS6n3ggU8Sml9RM0tpfiBgwZrFWjnivtBXZC1AjPstssMqYjg0jJRha16bVMCV1
        kn3Rz01pS2/4jQSLQY4ZUixfzSpIiGfI8UfZ528pvwk//NUchwwjGJ7iq2xlPLP94iBxGBki80CBw
        OJddTV1Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lhBB6-009RwN-5m; Thu, 13 May 2021 13:15:10 +0000
Date:   Thu, 13 May 2021 14:15:00 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
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
Subject: Re: [RFC PATCH v3 0/2] mm: remove extra ZONE_DEVICE struct page
 refcount
Message-ID: <YJ0mVAK7OjwIGnMe@casper.infradead.org>
References: <20201001181715.17416-1-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001181715.17416-1-rcampbell@nvidia.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 01, 2020 at 11:17:13AM -0700, Ralph Campbell wrote:
> This is still an RFC because after looking at the pmem/dax code some
> more, I realized that the ZONE_DEVICE struct pages are being inserted
> into the process' page tables with vmf_insert_mixed() and a zero
> refcount on the ZONE_DEVICE struct page. This is sort of OK because
> insert_pfn() increments the reference count on the pgmap which is what
> prevents memunmap_pages() from freeing the struct pages and it doesn't
> check for a non-zero struct page reference count.
> But, any calls to get_page() will hit the VM_BUG_ON_PAGE() that
> checks for a reference count == 0.

This seems to have gone quiet.  What needs to happen to resurrect this?
