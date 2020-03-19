Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5F818BF2A
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Mar 2020 19:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSSRU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 14:17:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47057 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSSRU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Mar 2020 14:17:20 -0400
Received: by mail-qt1-f194.google.com with SMTP id t13so2651323qtn.13
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Mar 2020 11:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=k5kvdyWMY1o6QuKYjzO+Ges86hYeEHCBwSk9Em5z3RY=;
        b=j8pnhR3Ywal5Z1Ent5/7bTVo3Ir3yTvmYBTrp/3TgZ1En/8VgLPzeQNOQHocQ12Fbq
         +wlp/G9KV5LlvxtOL4lNeHPnUqx0JKyhI/wJx4Fe1/u5387bNzRW2EQpOBhAQpvf7O9d
         bHrajTsRgKVQHN74GEvPveGDOcgcu6xf8gjD8QKG8ib4/H8m/FI/jD2gu3QeYxi2GFVr
         odN7SjSmQJx6xMNo9Nc1TVDmMlbqZ/r5iNmpgCYw+cbn0V9fm1rrH/TBS/q4fVMGw3Q5
         mmxcWC57wzoY3QOun7fHS9uZLTrCPfClXiPtMxLHjQb8pwbO3lCwGxSmikmrAshS9R4D
         HsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=k5kvdyWMY1o6QuKYjzO+Ges86hYeEHCBwSk9Em5z3RY=;
        b=cR3Ed+JybkDOTDBDyt2n1PPNq4uQe7NNzylM7vHFRk0IvBl+8Gb+RHe+eTDr3WLnik
         EA9R4Anxv/V8g/a4WmWguXqa6mUTbQM2jf7O7zjRYAariI/+F43rpy9v9Vp50vHUzCGN
         LzU1KHtm35ldYkmzeB0OMKu69tIj2MUb38nwkS7EMsARB+m/SdYmHkELcU/7akISNmfv
         +bSZTjsY6qxmL4bkQuPw317cZYTh4j7pBYL8o6k0Y71QE0bNxOKS77HbvrqpwCb3tYI+
         r4lUGwdotM4+wOMJPq+sqyTuumGF2F9yol9yCcWvKO6qfAtYXyFjP7+LdYX3MKc2ku5q
         EwpA==
X-Gm-Message-State: ANhLgQ2r+jVt4aClQTYKVu57WmvwowPjFhUy73VAMmBEYAlwznvq+1wV
        OoZRY4OrDWcqOgHznczusQD8tw==
X-Google-Smtp-Source: ADFU+vs9n45VQ6cNCCfzK9jn/XCI43PqbzGXPuVaqhPNr6PSXuviZAOAXhocW0lnqyPDfm1FoSx9qg==
X-Received: by 2002:ac8:6b54:: with SMTP id x20mr4299882qts.41.1584641837615;
        Thu, 19 Mar 2020 11:17:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 199sm2067530qkm.7.2020.03.19.11.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 11:17:16 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEzjI-0002Wc-6t; Thu, 19 Mar 2020 15:17:16 -0300
Date:   Thu, 19 Mar 2020 15:17:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200319181716.GK20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
 <20200317121536.GQ20941@ziepe.ca>
 <20200317122445.GA11662@lst.de>
 <20200317122813.GA11866@lst.de>
 <20200317124755.GR20941@ziepe.ca>
 <20200317125955.GA12847@lst.de>
 <24fca825-3b0f-188f-bcf2-fadcf3a9f05a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24fca825-3b0f-188f-bcf2-fadcf3a9f05a@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 04:14:31PM -0700, Ralph Campbell wrote:
> 
> On 3/17/20 5:59 AM, Christoph Hellwig wrote:
> > On Tue, Mar 17, 2020 at 09:47:55AM -0300, Jason Gunthorpe wrote:
> > > I've been using v7 of Ralph's tester and it is working well - it has
> > > DEVICE_PRIVATE support so I think it can test this flow too. Ralph are
> > > you able?
> > > 
> > > This hunk seems trivial enough to me, can we include it now?
> > 
> > I can send a separate patch for it once the tester covers it.  I don't
> > want to add it to the original patch as it is a significant behavior
> > change compared to the existing code.
> > 
> 
> Attached is an updated version of my HMM tests based on linux-5.6.0-rc6.
> I ran this OK with Jason's 8+1 HMM patches, Christoph's 1-5 misc HMM clean ups,
> and Christoph's 1-4 device private page changes applied.

I'd like to get this to mergable, it looks pretty good now, but I have
no idea about selftests - and I'm struggling to even compile the tools
dir

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 69def4a9df00..4d22ce7879a7 100644
> +++ b/lib/Kconfig.debug
> @@ -2162,6 +2162,18 @@ config TEST_MEMINIT
>  
>  	  If unsure, say N.
>  
> +config TEST_HMM
> +	tristate "Test HMM (Heterogeneous Memory Management)"
> +	depends on DEVICE_PRIVATE
> +	select HMM_MIRROR
> +        select MMU_NOTIFIER

extra spaces

In general I wonder if it even makes sense that DEVICE_PRIVATE is user
selectable?

> +static int dmirror_fops_open(struct inode *inode, struct file *filp)
> +{
> +	struct cdev *cdev = inode->i_cdev;
> +	struct dmirror *dmirror;
> +	int ret;
> +
> +	/* Mirror this process address space */
> +	dmirror = kzalloc(sizeof(*dmirror), GFP_KERNEL);
> +	if (dmirror == NULL)
> +		return -ENOMEM;
> +
> +	dmirror->mdevice = container_of(cdev, struct dmirror_device, cdevice);
> +	mutex_init(&dmirror->mutex);
> +	xa_init(&dmirror->pt);
> +
> +	ret = mmu_interval_notifier_insert(&dmirror->notifier, current->mm,
> +				0, ULONG_MAX & PAGE_MASK, &dmirror_min_ops);
> +	if (ret) {
> +		kfree(dmirror);
> +		return ret;
> +	}
> +
> +	/* Pairs with the mmdrop() in dmirror_fops_release(). */
> +	mmgrab(current->mm);
> +	dmirror->mm = current->mm;

The notifier holds a mmgrab, no need for another one

> +	/* Only the first open registers the address space. */
> +	filp->private_data = dmirror;

Not sure what this comment means

> +static inline struct dmirror_device *dmirror_page_to_device(struct page *page)
> +
> +{
> +	struct dmirror_chunk *devmem;
> +
> +	devmem = container_of(page->pgmap, struct dmirror_chunk, pagemap);
> +	return devmem->mdevice;
> +}

extra devmem var is not really needed

> +
> +static bool dmirror_device_is_mine(struct dmirror_device *mdevice,
> +				   struct page *page)
> +{
> +	if (!is_zone_device_page(page))
> +		return false;
> +	return page->pgmap->ops == &dmirror_devmem_ops &&
> +		dmirror_page_to_device(page) == mdevice;
> +}

Use new owner stuff, right? Actually this is redunant now, the check
should be just WARN_ON pageowner != self owner

> +static int dmirror_do_fault(struct dmirror *dmirror, struct hmm_range *range)
> +{
> +	uint64_t *pfns = range->pfns;
> +	unsigned long pfn;
> +
> +	for (pfn = (range->start >> PAGE_SHIFT);
> +	     pfn < (range->end >> PAGE_SHIFT);
> +	     pfn++, pfns++) {
> +		struct page *page;
> +		void *entry;
> +
> +		/*
> +		 * HMM_PFN_ERROR is returned if it is accessing invalid memory
> +		 * either because of memory error (hardware detected memory
> +		 * corruption) or more likely because of truncate on mmap
> +		 * file.
> +		 */
> +		if (*pfns == range->values[HMM_PFN_ERROR])
> +			return -EFAULT;

Unless that snapshot is use hmm_range_fault() never returns success
and sets PFN_ERROR, so this should be a WARN_ON

> +		if (!(*pfns & range->flags[HMM_PFN_VALID]))
> +			return -EFAULT;

Same with valid.

> +		page = hmm_device_entry_to_page(range, *pfns);
> +		/* We asked for pages to be populated but check anyway. */
> +		if (!page)
> +			return -EFAULT;

WARN_ON

> +		if (is_zone_device_page(page)) {
> +			/*
> +			 * TODO: need a way to ask HMM to fault foreign zone
> +			 * device private pages.
> +			 */
> +			if (!dmirror_device_is_mine(dmirror->mdevice, page))
> +				continue;

Actually re

> +static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
> +				const struct mmu_notifier_range *range,
> +				unsigned long cur_seq)
> +{
> +	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
> +	struct mm_struct *mm = dmirror->mm;
> +
> +	/*
> +	 * If the process doesn't exist, we don't need to invalidate the
> +	 * device page table since the address space will be torn down.
> +	 */
> +	if (!mmget_not_zero(mm))
> +		return true;

Why? Don't the notifiers provide for this already. 

mmget_not_zero() is required before calling hmm_range_fault() though

> +static int dmirror_fault(struct dmirror *dmirror, unsigned long start,
> +			 unsigned long end, bool write)
> +{
> +	struct mm_struct *mm = dmirror->mm;
> +	unsigned long addr;
> +	uint64_t pfns[64];
> +	struct hmm_range range = {
> +		.notifier = &dmirror->notifier,
> +		.pfns = pfns,
> +		.flags = dmirror_hmm_flags,
> +		.values = dmirror_hmm_values,
> +		.pfn_shift = DPT_SHIFT,
> +		.pfn_flags_mask = ~(dmirror_hmm_flags[HMM_PFN_VALID] |
> +				    dmirror_hmm_flags[HMM_PFN_WRITE]),
> +		.default_flags = dmirror_hmm_flags[HMM_PFN_VALID] |
> +				(write ? dmirror_hmm_flags[HMM_PFN_WRITE] : 0),
> +		.dev_private_owner = dmirror->mdevice,
> +	};
> +	int ret = 0;
> +
> +	/* Since the mm is for the mirrored process, get a reference first. */
> +	if (!mmget_not_zero(mm))
> +		return 0;

Right

> +	for (addr = start; addr < end; addr = range.end) {
> +		range.start = addr;
> +		range.end = min(addr + (ARRAY_SIZE(pfns) << PAGE_SHIFT), end);
> +
> +		ret = dmirror_range_fault(dmirror, &range);
> +		if (ret)
> +			break;
> +	}
> +
> +	mmput(mm);
> +	return ret;
> +}
> +
> +static int dmirror_do_read(struct dmirror *dmirror, unsigned long start,
> +			   unsigned long end, struct dmirror_bounce *bounce)
> +{
> +	unsigned long pfn;
> +	void *ptr;
> +
> +	ptr = bounce->ptr + ((start - bounce->addr) & PAGE_MASK);
> +
> +	for (pfn = start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
> +		void *entry;
> +		struct page *page;
> +		void *tmp;
> +
> +		entry = xa_load(&dmirror->pt, pfn);
> +		page = xa_untag_pointer(entry);
> +		if (!page)
> +			return -ENOENT;
> +
> +		tmp = kmap(page);
> +		memcpy(ptr, tmp, PAGE_SIZE);
> +		kunmap(page);
> +
> +		ptr += PAGE_SIZE;
> +		bounce->cpages++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dmirror_read(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
> +{
> +	struct dmirror_bounce bounce;
> +	unsigned long start, end;
> +	unsigned long size = cmd->npages << PAGE_SHIFT;
> +	int ret;
> +
> +	start = cmd->addr;
> +	end = start + size;
> +	if (end < start)
> +		return -EINVAL;
> +
> +	ret = dmirror_bounce_init(&bounce, start, size);
> +	if (ret)
> +		return ret;
> +
> +again:
> +	mutex_lock(&dmirror->mutex);
> +	ret = dmirror_do_read(dmirror, start, end, &bounce);
> +	mutex_unlock(&dmirror->mutex);
> +	if (ret == 0)
> +		ret = copy_to_user((void __user *)cmd->ptr, bounce.ptr,
> +					bounce.size);

Use u64_to_user_ptr() instead of the cast

> +static int dmirror_write(struct dmirror *dmirror, struct hmm_dmirror_cmd *cmd)
> +{
> +	struct dmirror_bounce bounce;
> +	unsigned long start, end;
> +	unsigned long size = cmd->npages << PAGE_SHIFT;
> +	int ret;
> +
> +	start = cmd->addr;
> +	end = start + size;
> +	if (end < start)
> +		return -EINVAL;
> +
> +	ret = dmirror_bounce_init(&bounce, start, size);
> +	if (ret)
> +		return ret;
> +	ret = copy_from_user(bounce.ptr, (void __user *)cmd->ptr,
> +				bounce.size);

ditto

> +	if (ret)
> +		return ret;
> +
> +again:
> +	mutex_lock(&dmirror->mutex);
> +	ret = dmirror_do_write(dmirror, start, end, &bounce);
> +	mutex_unlock(&dmirror->mutex);
> +	if (ret == -ENOENT) {
> +		start = cmd->addr + (bounce.cpages << PAGE_SHIFT);
> +		ret = dmirror_fault(dmirror, start, end, true);
> +		if (ret == 0) {
> +			cmd->faults++;
> +			goto again;

Use a loop instead of goto?

Also I get this:

lib/test_hmm.c: In function ‘dmirror_devmem_fault_alloc_and_copy’:
lib/test_hmm.c:1041:25: warning: unused variable ‘vma’ [-Wunused-variable]
 1041 |  struct vm_area_struct *vma = args->vma;

But this is a kernel bug, due to alloc_page_vma being a #define not a
static inline and me having CONFIG_NUMA off in this .config

Jason
