Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2E4A13E5
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Aug 2019 10:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfH2IiP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Aug 2019 04:38:15 -0400
Received: from verein.lst.de ([213.95.11.211]:44222 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfH2IiP (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 29 Aug 2019 04:38:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5996268B20; Thu, 29 Aug 2019 10:38:10 +0200 (CEST)
Date:   Thu, 29 Aug 2019 10:38:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v7 1/7] kvmppc: Driver to manage pages of secure guest
Message-ID: <20190829083810.GA13039@lst.de>
References: <20190822102620.21897-1-bharata@linux.ibm.com> <20190822102620.21897-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822102620.21897-2-bharata@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 22, 2019 at 03:56:14PM +0530, Bharata B Rao wrote:
> +/*
> + * Bits 60:56 in the rmap entry will be used to identify the
> + * different uses/functions of rmap.
> + */
> +#define KVMPPC_RMAP_DEVM_PFN	(0x2ULL << 56)

How did you come up with this specific value?

> +
> +static inline bool kvmppc_rmap_is_devm_pfn(unsigned long pfn)
> +{
> +	return !!(pfn & KVMPPC_RMAP_DEVM_PFN);
> +}

No need for !! when returning a bool.  Also the helper seems a little
pointless, just opencoding it would make the code more readable in my
opinion.

> +#ifdef CONFIG_PPC_UV
> +extern int kvmppc_devm_init(void);
> +extern void kvmppc_devm_free(void);

There is no need for extern in a function declaration.

> +static int
> +kvmppc_devm_migrate_alloc_and_copy(struct migrate_vma *mig,
> +				   unsigned long *rmap, unsigned long gpa,
> +				   unsigned int lpid, unsigned long page_shift)
> +{
> +	struct page *spage = migrate_pfn_to_page(*mig->src);
> +	unsigned long pfn = *mig->src >> MIGRATE_PFN_SHIFT;
> +	struct page *dpage;
> +
> +	*mig->dst = 0;
> +	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
> +		return 0;
> +
> +	dpage = kvmppc_devm_get_page(rmap, gpa, lpid);
> +	if (!dpage)
> +		return -EINVAL;
> +
> +	if (spage)
> +		uv_page_in(lpid, pfn << page_shift, gpa, 0, page_shift);
> +
> +	*mig->dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
> +	return 0;
> +}

I think you can just merge this trivial helper into the only caller.

> +static int
> +kvmppc_devm_fault_migrate_alloc_and_copy(struct migrate_vma *mig,
> +					 unsigned long page_shift)
> +{
> +	struct page *dpage, *spage;
> +	struct kvmppc_devm_page_pvt *pvt;
> +	unsigned long pfn;
> +	int ret;
> +
> +	spage = migrate_pfn_to_page(*mig->src);
> +	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
> +		return 0;
> +	if (!is_zone_device_page(spage))
> +		return 0;
> +
> +	dpage = alloc_page_vma(GFP_HIGHUSER, mig->vma, mig->start);
> +	if (!dpage)
> +		return -EINVAL;
> +	lock_page(dpage);
> +	pvt = spage->zone_device_data;
> +
> +	pfn = page_to_pfn(dpage);
> +	ret = uv_page_out(pvt->lpid, pfn << page_shift, pvt->gpa, 0,
> +			  page_shift);
> +	if (ret == U_SUCCESS)
> +		*mig->dst = migrate_pfn(pfn) | MIGRATE_PFN_LOCKED;
> +	else {
> +		unlock_page(dpage);
> +		__free_page(dpage);
> +	}
> +	return ret;
> +}

Here we actually have two callers, but they have a fair amount of
duplicate code in them.  I think you want to move that common
code (including setting up the migrate_vma structure) into this
function and maybe also give it a more descriptive name.

> +static void kvmppc_devm_page_free(struct page *page)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +	unsigned long flags;
> +	struct kvmppc_devm_page_pvt *pvt;
> +
> +	spin_lock_irqsave(&kvmppc_devm_pfn_lock, flags);
> +	pvt = page->zone_device_data;
> +	page->zone_device_data = NULL;
> +
> +	bitmap_clear(kvmppc_devm_pfn_bitmap,
> +		     pfn - (kvmppc_devm_pgmap.res.start >> PAGE_SHIFT), 1);

Nit: I'd just initialize pfn to the value you want from the start.
That makes the code a little easier to read, and keeps a tiny bit more
code outside the spinlock.

	unsigned long pfn = page_to_pfn(page) -
			(kvmppc_devm_pgmap.res.start >> PAGE_SHIFT);

	..

	 bitmap_clear(kvmppc_devm_pfn_bitmap, pfn, 1);


> +	kvmppc_devm_pgmap.type = MEMORY_DEVICE_PRIVATE;
> +	kvmppc_devm_pgmap.res = *res;
> +	kvmppc_devm_pgmap.ops = &kvmppc_devm_ops;
> +	addr = memremap_pages(&kvmppc_devm_pgmap, -1);

This -1 should be NUMA_NO_NODE for clarity.
