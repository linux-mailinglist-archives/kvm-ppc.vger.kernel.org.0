Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B2688AE8
	for <lists+kvm-ppc@lfdr.de>; Sat, 10 Aug 2019 12:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfHJK60 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 10 Aug 2019 06:58:26 -0400
Received: from verein.lst.de ([213.95.11.211]:33801 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfHJK6Z (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 10 Aug 2019 06:58:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D73C868BFE; Sat, 10 Aug 2019 12:58:19 +0200 (CEST)
Date:   Sat, 10 Aug 2019 12:58:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v6 1/7] kvmppc: Driver to manage pages of secure guest
Message-ID: <20190810105819.GA26030@lst.de>
References: <20190809084108.30343-1-bharata@linux.ibm.com> <20190809084108.30343-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809084108.30343-2-bharata@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

> +#ifdef CONFIG_PPC_UV
> +extern unsigned long kvmppc_h_svm_page_in(struct kvm *kvm,
> +					  unsigned long gra,
> +					  unsigned long flags,
> +					  unsigned long page_shift);
> +extern unsigned long kvmppc_h_svm_page_out(struct kvm *kvm,
> +					  unsigned long gra,
> +					  unsigned long flags,
> +					  unsigned long page_shift);

No need for externs on function declarations.

> +struct kvmppc_devm_device {
> +	struct device dev;
> +	dev_t devt;
> +	struct dev_pagemap pagemap;
> +	unsigned long pfn_first, pfn_last;
> +	unsigned long *pfn_bitmap;
> +};

We shouldn't really need this conaining structucture given that there
is only a single global instance of it anyway.

> +struct kvmppc_devm_copy_args {
> +	unsigned long *rmap;
> +	unsigned int lpid;
> +	unsigned long gpa;
> +	unsigned long page_shift;
> +};

Do we really need this args structure?  It is just used in a single
function call where passing the arguments might be cleaner.

> +static void kvmppc_devm_put_page(struct page *page)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +	unsigned long flags;
> +	struct kvmppc_devm_page_pvt *pvt;
> +
> +	spin_lock_irqsave(&kvmppc_devm_lock, flags);
> +	pvt = (struct kvmppc_devm_page_pvt *)page->zone_device_data;

No need for the cast.

> +	page->zone_device_data = 0;

This should be NULL.

> +
> +	bitmap_clear(kvmppc_devm.pfn_bitmap,
> +		     pfn - kvmppc_devm.pfn_first, 1);
> +	*(pvt->rmap) = 0;

No need for the braces.

> +	dpage = alloc_page_vma(GFP_HIGHUSER, mig->vma, mig->start);
> +	if (!dpage)
> +		return -EINVAL;
> +	lock_page(dpage);
> +	pvt = (struct kvmppc_devm_page_pvt *)spage->zone_device_data;

No need for the cast here.

> +static void kvmppc_devm_page_free(struct page *page)
> +{
> +	kvmppc_devm_put_page(page);
> +}

This seems to be the only caller of kvmppc_devm_put_page, any reason
not to just merge the two functions?

> +static int kvmppc_devm_pages_init(void)
> +{
> +	unsigned long nr_pfns = kvmppc_devm.pfn_last -
> +				kvmppc_devm.pfn_first;
> +
> +	kvmppc_devm.pfn_bitmap = kcalloc(BITS_TO_LONGS(nr_pfns),
> +				 sizeof(unsigned long), GFP_KERNEL);
> +	if (!kvmppc_devm.pfn_bitmap)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&kvmppc_devm_lock);

Just initialize the spinlock using DEFINE_SPINLOCK() at compile time.
The rest of the function is so trivial that it can be inlined into the
caller.

Also is kvmppc_devm_lock such a good name?  This mostly just protects
the allocation bitmap, so reflecting that in the name might be a good
idea.

> +int kvmppc_devm_init(void)
> +{
> +	int ret = 0;
> +	unsigned long size;
> +	struct resource *res;
> +	void *addr;
> +
> +	size = kvmppc_get_secmem_size();
> +	if (!size) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	ret = alloc_chrdev_region(&kvmppc_devm.devt, 0, 1,
> +				"kvmppc-devm");
> +	if (ret)
> +		goto out;
> +
> +	dev_set_name(&kvmppc_devm.dev, "kvmppc_devm_device%d", 0);
> +	kvmppc_devm.dev.release = kvmppc_devm_release;
> +	device_initialize(&kvmppc_devm.dev);
> +	res = devm_request_free_mem_region(&kvmppc_devm.dev,
> +		&iomem_resource, size);
> +	if (IS_ERR(res)) {
> +		ret = PTR_ERR(res);
> +		goto out_unregister;
> +	}
> +
> +	kvmppc_devm.pagemap.type = MEMORY_DEVICE_PRIVATE;
> +	kvmppc_devm.pagemap.res = *res;
> +	kvmppc_devm.pagemap.ops = &kvmppc_devm_ops;
> +	addr = devm_memremap_pages(&kvmppc_devm.dev, &kvmppc_devm.pagemap);
> +	if (IS_ERR(addr)) {
> +		ret = PTR_ERR(addr);
> +		goto out_unregister;
> +	}

It seems a little silly to allocate a struct device just so that we can
pass it to devm_request_free_mem_region and devm_memremap_pages.  I think
we should just create non-dev_ versions of those as well.

> +
> +	kvmppc_devm.pfn_first = res->start >> PAGE_SHIFT;
> +	kvmppc_devm.pfn_last = kvmppc_devm.pfn_first +
> +			(resource_size(res) >> PAGE_SHIFT);

pfn_last is only used to calculat a size.  Also I think we could
just use kvmppc_devm.pagemap.res directly instead of copying these
values out.  the ">> PAGE_SHIFT" is cheap enough.
