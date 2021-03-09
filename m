Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4E93325C9
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Mar 2021 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhCIMvF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Mar 2021 07:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhCIMuj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Mar 2021 07:50:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F95CC06174A;
        Tue,  9 Mar 2021 04:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pZ/COBNbblJO+x07w0308qCGnfsww0L8iErIm0GU3pk=; b=OwbzsZ7Ekm7vjuMsGUDxy9IzZB
        aYNSzv5gJVgAdrZj4EuSbYdC1NbhsHVYWcyKD5HDML0sTHUjneU88cMrc3Usnq8uFrRYRRNCb+Hdr
        m/LqpRf/aHhyPRh4rbrxdW7Pct4tPO2kTbhNdtH+K69l6xJOlJj/z1ZgMXfV2ROYPp8npVcU+rXU2
        Dew94FhovF/W/xp164C6bDgOeS09uC5hy43MtfnWObcKL9V0I/qfat/PfktpUvW/U88XS4brjBEcF
        l9YfOHt2tK9eaWDDUj7m9uUz4lbGzPnWNMCRt191+VjJdsHevacr700C9rBOS5UCEU0HdvhMZicVp
        j5kcRFpA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJbo5-000aTt-T6; Tue, 09 Mar 2021 12:50:04 +0000
Date:   Tue, 9 Mar 2021 12:49:49 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, nouveau@lists.freedesktop.org,
        bskeggs@redhat.com, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jhubbard@nvidia.com, rcampbell@nvidia.com, jglisse@redhat.com
Subject: Re: [PATCH v5 1/8] mm: Remove special swap entry functions
Message-ID: <20210309124949.GJ3479805@casper.infradead.org>
References: <20210309121505.23608-1-apopple@nvidia.com>
 <20210309121505.23608-2-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309121505.23608-2-apopple@nvidia.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 09, 2021 at 11:14:58PM +1100, Alistair Popple wrote:
> -static inline struct page *migration_entry_to_page(swp_entry_t entry)
> -{
> -	struct page *p = pfn_to_page(swp_offset(entry));
> -	/*
> -	 * Any use of migration entries may only occur while the
> -	 * corresponding page is locked
> -	 */
> -	BUG_ON(!PageLocked(compound_head(p)));
> -	return p;
> -}

> +static inline struct page *pfn_swap_entry_to_page(swp_entry_t entry)
> +{
> +	struct page *p = pfn_to_page(swp_offset(entry));
> +
> +	/*
> +	 * Any use of migration entries may only occur while the
> +	 * corresponding page is locked
> +	 */
> +	BUG_ON(is_migration_entry(entry) && !PageLocked(compound_head(p)));
> +
> +	return p;
> +}

I appreciate you're only moving this code, but PageLocked includes an
implicit compound_head():

1. __PAGEFLAG(Locked, locked, PF_NO_TAIL)

2. #define __PAGEFLAG(uname, lname, policy)                                \
        TESTPAGEFLAG(uname, lname, policy)                              \

3. #define TESTPAGEFLAG(uname, lname, policy)                              \
static __always_inline int Page##uname(struct page *page)               \
        { return test_bit(PG_##lname, &policy(page, 0)->flags); }

4. #define PF_NO_TAIL(page, enforce) ({                                    \
                VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);     \
                PF_POISONED_CHECK(compound_head(page)); })

5. #define PF_POISONED_CHECK(page) ({                                      \
                VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);            \
                page; })


This macrology isn't easy to understand the first time you read it (nor,
indeed, the tenth time), so let me decode it:

Substitute 5 into 4 and remove irrelevancies:

6. #define PF_NO_TAIL(page, enforce) compound_head(page)

Expand 1 in 2:

7.	TESTPAGEFLAG(Locked, locked, PF_NO_TAIL)

Expand 7 in 3:

8. static __always_inline int PageLocked(struct page *page)
	{ return test_bit(PG_locked, &PF_NO_TAIL(page, 0)->flags); }

Expand 6 in 8:

9. static __always_inline int PageLocked(struct page *page)
	{ return test_bit(PG_locked, &compound_head(page)->flags); }

(in case it's not clear, compound_head() is idempotent.  that is:
	f(f(a)) == f(a))
