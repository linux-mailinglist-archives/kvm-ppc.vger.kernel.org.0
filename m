Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3FB18847C
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 13:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgCQMr7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 08:47:59 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:33172 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgCQMr6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Mar 2020 08:47:58 -0400
Received: by mail-qv1-f68.google.com with SMTP id cz10so10727379qvb.0
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Mar 2020 05:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hGKwnunGHWWeSvJ9/XCv+nR79KkE26ubf6RE0d+GYLk=;
        b=PtubQYZSU9HgtWJjpFqwEdIYwtlB49Vs3D0G3zYORKcPGhEsIfZRIiROQOxddsRvWA
         RjAy+r9b/I8P2+0SEwcZEHsGUaxQE/qlu5dpc9kPAnznApNphxMVv4h20GpK+9p67yFs
         6hjcLG3hAAH3kBZTDZzuv6MILCdugULe8uRlXsNfw2yB//OumwIf2+qafVNvyuWJVzZk
         88vQy3I7t0nW6CNqJ8Lab2RMTtgH9hmh0oi4/hZaMDTe+VWad/wJZA4Ie452V4GsyVJG
         d7MvTYBDlTMGkbCUf2QQJe9saGpyKzd5K1BGve8IZKxbN0kyWBmlJs91ikMF2jJwlaJr
         0W8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hGKwnunGHWWeSvJ9/XCv+nR79KkE26ubf6RE0d+GYLk=;
        b=TvoqMxvDrIJASyTiWseKgNLsHU8plhRrFIcLsEnEMKMOl2pPVxR+51XqOKC9Pss+Zc
         svpqORzSakLdCJi6QN1unuivyj6nL1u8jwI1iKhDInf4KcZWMSq6UO5tbZevMeGvI45V
         j/+Fs6SrNO/iRsXOBY6gXTz9kC1TXB/PplnJ+hDCieVxPhbQDDJqj7ubDie+2dqNGYLI
         EyHBnrGQQPiPjVfETRJoZbFETPYR/Wx1CM8CFITw++ZPXkuu+AXIZJKt1NC3KUFHgUKw
         dxyTGdAH1bvAzRiApBKTxzpCx0QNplPzBB1NlVTACJOsh8OJpZ2yPLgYmuL/bxp8MJaB
         I6gA==
X-Gm-Message-State: ANhLgQ2X2vzHnKTsfOfarr+uxHIUgSdivvK/YYaUrCbq34R9k8vr/r42
        TGSnU//HWxyhfKj3oUUKTaXDBQ==
X-Google-Smtp-Source: ADFU+vvumVznBXG0A6Iq3xCvezlrI9LHYhCJTZJg7hVXuURUfk1WF2tONVQteVKlbjpHyfZ+mfUmNQ==
X-Received: by 2002:a0c:ecc3:: with SMTP id o3mr4832950qvq.163.1584449277445;
        Tue, 17 Mar 2020 05:47:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m65sm1863433qke.109.2020.03.17.05.47.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Mar 2020 05:47:56 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jEBdT-0001XI-Q8; Tue, 17 Mar 2020 09:47:55 -0300
Date:   Tue, 17 Mar 2020 09:47:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317124755.GR20941@ziepe.ca>
References: <20200316193216.920734-1-hch@lst.de>
 <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
 <20200317121536.GQ20941@ziepe.ca>
 <20200317122445.GA11662@lst.de>
 <20200317122813.GA11866@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317122813.GA11866@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 01:28:13PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 17, 2020 at 01:24:45PM +0100, Christoph Hellwig wrote:
> > On Tue, Mar 17, 2020 at 09:15:36AM -0300, Jason Gunthorpe wrote:
> > > > Getting rid of HMM_PFN_DEVICE_PRIVATE seems reasonable to me since a driver can
> > > > look at the struct page but what if a driver needs to fault in a page from
> > > > another device's private memory? Should it call handle_mm_fault()?
> > > 
> > > Isn't that what this series basically does?
> > >
> > > The dev_private_owner is set to the type of pgmap the device knows how
> > > to handle, and everything else is automatically faulted for the
> > > device.
> > > 
> > > If the device does not know how to handle device_private then it sets
> > > dev_private_owner to NULL and it never gets device_private pfns.
> > > 
> > > Since the device_private pfn cannot be dma mapped, drivers must have
> > > explicit support for them.
> > 
> > No, with this series (and all actual callers before this series)
> > we never fault in device private pages.
> 
> IFF we want to fault it in we'd need something like this.  But I'd
> really prefer to see test cases for that first.

In general I think hmm_range_fault should have a mode that is the same
as get_user_pages in terms of when it returns a hard failure, and
generates faults. AFAIK, GUP will fault in this case?

I need this for making ODP use this API. ODP is the one that is highly
likely to see other driver's device_private pages and must have them
always fault to CPU.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index b75b3750e03d..2884a3d11a1f 100644
> +++ b/mm/hmm.c
> @@ -276,7 +276,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  		if (!fault && !write_fault)
>  			return 0;
>  
> -		if (!non_swap_entry(entry))
> +		if (!non_swap_entry(entry) || is_device_private_entry(entry))
>  			goto fault;

Yes, OK,  makes sense.

I've been using v7 of Ralph's tester and it is working well - it has
DEVICE_PRIVATE support so I think it can test this flow too. Ralph are
you able?

This hunk seems trivial enough to me, can we include it now?

Thanks,
Jason
