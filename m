Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94EA18CF28
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 14:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCTNlM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 09:41:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46812 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNlM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 09:41:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id t13so4834358qtn.13
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 06:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rSXMnA8Bh+EyZeJfpwZeazUxxET567SafNKmRBbaqJE=;
        b=IRiBcy01pez/c8Esw6ABdeGlubYq6UBTvnqE08m54TPmYJSk0iZY8NRy4Imfi9RCkq
         pgYtuxDrHqPgjM1o0KyPLUcQQOMmsp/8AwWKrGmPWY2V2zTpecXI1Hmww1TRzifRUqv1
         DX4dzAVbSR13Fo7jjIz8YUYee5enxM6pJW/X6pJz59lxOjUg+6nvHnnEaT8pcTz55OMt
         jRul4tANsV8+/6/1gFaPw67m4l9Hc++lvsRpUhKs8JRwfn579xSKiU2xI9uEr0dnW7Fr
         mnPY+dq6nTjmuQ5ZDgFDKjScE6rkcwbkGcsH6sXXBgbbcYl+h27ZHv6LeQTB09f7WjYe
         iTaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rSXMnA8Bh+EyZeJfpwZeazUxxET567SafNKmRBbaqJE=;
        b=F3YYhu7RD5/3Wniw6bnfmcEmSbr2bK18u00dtESJhQ5iFJdgXbWV+ABrI9+g5dsIPq
         PsFy7VjAiQt4XCmSdxbasZ59uByttJ7CMKjUa3DYM74WfYiZNCtOsQ9JfZpcbpJe1OSq
         A0FOpqSUoa5xqXPwccEu60NQa4o+c8sgngYexCK+ACb28NmFXm298J6JCPmgFMxPKmH3
         1/AK4Rmv1kDJvUEE1EWqlpWW5qvIgl8aNMgBoRZ0kDfbopwk/RPFRYROp/8L85b1hPbU
         xoy8JpbbaGNCGPF7sxvy1BGPMZTrQToAj5jD1Skk5Wrob1bJZpGn2jPh0KnRs0988zgt
         SU/g==
X-Gm-Message-State: ANhLgQ3YUA2imLZkr6spJ+wHewzFK9eQCBoBfx+ziyQJF9ZaY8xEO4kA
        0JpHAZd9mL7zN6YS/YyI83olhw==
X-Google-Smtp-Source: ADFU+vuEJLxLBoH+558rgkm+/X3kgiU5w6V/n0Oh7c+Ro7Jb1c7KonYggFNpdI58VU/1xg85hzcxdQ==
X-Received: by 2002:ac8:4782:: with SMTP id k2mr8138084qtq.1.1584711670687;
        Fri, 20 Mar 2020 06:41:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p23sm4024398qkm.39.2020.03.20.06.41.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:41:10 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jFHtd-0007xE-Gf; Fri, 20 Mar 2020 10:41:09 -0300
Date:   Fri, 20 Mar 2020 10:41:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: check the device private page owner in
 hmm_range_fault
Message-ID: <20200320134109.GA30230@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316193216.920734-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 08:32:16PM +0100, Christoph Hellwig wrote:
> diff --git a/mm/hmm.c b/mm/hmm.c
> index cfad65f6a67b..b75b3750e03d 100644
> +++ b/mm/hmm.c
> @@ -216,6 +216,14 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>  		unsigned long end, uint64_t *pfns, pmd_t pmd);
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> +static inline bool hmm_is_device_private_entry(struct hmm_range *range,
> +		swp_entry_t entry)
> +{
> +	return is_device_private_entry(entry) &&
> +		device_private_entry_to_page(entry)->pgmap->owner ==
> +		range->dev_private_owner;
> +}

Thinking about this some more, does the locking work out here?

hmm_range_fault() runs with mmap_sem in read, and does not lock any of
the page table levels.

So it relies on accessing stale pte data being safe, and here we
introduce for the first time a page pointer dereference and a pgmap
dereference without any locking/refcounting.

The get_dev_pagemap() worked on the PFN and obtained a refcount, so it
created safety.

Is there some tricky reason this is safe, eg a DEVICE_PRIVATE page
cannot be removed from the vma without holding mmap_sem in write or
something?

Jason
