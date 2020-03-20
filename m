Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8018CE3E
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCTM64 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 08:58:56 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34881 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCTM6Q (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 08:58:16 -0400
Received: by mail-qv1-f68.google.com with SMTP id q73so2865947qvq.2
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 05:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7tshdo6c8ufpkvS21qNDq3o1JI++3fGdgC9NNzUitoU=;
        b=IvTQLQxfTudOZo6mQWXcw0MoAViFLghOoPbxW/9yZkUMgOiZ4Pv9Z04Csj2TJq5vca
         qb/NOPGNHtZJ6s24cM+QRSb5JuK21NJyav0y6/cJqE7vqjvLZeiPQwWPggHqBJHigTLB
         ymmND/5GQ89u7BiyP07RYIjAcCIa+vFjUpz4zOgJSTVCkcudYccK0vOVEQgM0fc99dpd
         Vs62xPG18t0GhZadO3Oap9mTCctOwTr0CiUfvnOTXVINl2qtmYv1/+hwvSX1r+r/EA1v
         Ke5XvA9K39riwOsICVFnrILW1mFcLwADDE6udlfAI2AZmQRk3mQ4NBUc46ebi+QLcJNF
         7/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7tshdo6c8ufpkvS21qNDq3o1JI++3fGdgC9NNzUitoU=;
        b=PNUsqVSUqwgBPv2afALW7/AffhSss3exL3o2ZPUW0k7JP9TsxJhtw06JPiRw9zvS45
         QKv0JCMEtoAfmgJATsY2XU3iDyD6Ja2EOk/erEoqvtS4ups1XA6lS3FkAMZ+P2QfNXry
         VP/jsKA+WVDvOuG9Vs2Q0JC5r5vEZcXQY/cYU04pzFGvjh9mWOfJIpL0P9ROgNgebLUW
         Umpt6/6tmjVvQtMI5KePNuoE1rn0+upzQv2G9gsjBQ+0OjyqwUR+xZ/XJ2Qlw+n92o27
         FHuNHZHo3TwDdAhBBx7lEZZGy2vnUXwAwmnK1edE3pru3zPk2yoU1kB90/rrzaeW78OJ
         +8Bg==
X-Gm-Message-State: ANhLgQ1pSuZU15LuDjVTt1zwxWJFCh/YnN/nJ7kJ91qvYobkjA5cYWdh
        4o9X02enUGZnRR5FJFBYUMAJMA==
X-Google-Smtp-Source: ADFU+vvR+3vAV1p7d+fDNfmTEDRX1I6s0r0r+8MeuA2PAqUC3MBTAsQJGe+LIm8TG0FJxBXCYdsOGw==
X-Received: by 2002:a0c:ec02:: with SMTP id y2mr7683694qvo.171.1584709095500;
        Fri, 20 Mar 2020 05:58:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id y15sm4157894qky.33.2020.03.20.05.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 05:58:14 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jFHE5-0007Cq-2w; Fri, 20 Mar 2020 09:58:13 -0300
Date:   Fri, 20 Mar 2020 09:58:13 -0300
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
Message-ID: <20200320125813.GQ20941@ziepe.ca>
References: <20200316193216.920734-4-hch@lst.de>
 <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
 <20200317121536.GQ20941@ziepe.ca>
 <20200317122445.GA11662@lst.de>
 <20200317122813.GA11866@lst.de>
 <20200317124755.GR20941@ziepe.ca>
 <20200317125955.GA12847@lst.de>
 <24fca825-3b0f-188f-bcf2-fadcf3a9f05a@nvidia.com>
 <20200320001428.GA9199@ziepe.ca>
 <8d549ef6-14ae-7055-58c8-d56de8bf4ba6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d549ef6-14ae-7055-58c8-d56de8bf4ba6@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Mar 19, 2020 at 06:33:04PM -0700, Ralph Campbell wrote:

> > > +		.default_flags = dmirror_hmm_flags[HMM_PFN_VALID] |
> > > +				(write ? dmirror_hmm_flags[HMM_PFN_WRITE] : 0),
> > > +		.dev_private_owner = dmirror->mdevice,
> > > +	};
> > > +	int ret = 0;
> > 
> > > +static int dmirror_snapshot(struct dmirror *dmirror,
> > > +			    struct hmm_dmirror_cmd *cmd)
> > > +{
> > > +	struct mm_struct *mm = dmirror->mm;
> > > +	unsigned long start, end;
> > > +	unsigned long size = cmd->npages << PAGE_SHIFT;
> > > +	unsigned long addr;
> > > +	unsigned long next;
> > > +	uint64_t pfns[64];
> > > +	unsigned char perm[64];
> > > +	char __user *uptr;
> > > +	struct hmm_range range = {
> > > +		.pfns = pfns,
> > > +		.flags = dmirror_hmm_flags,
> > > +		.values = dmirror_hmm_values,
> > > +		.pfn_shift = DPT_SHIFT,
> > > +		.pfn_flags_mask = ~0ULL,
> > 
> > Same here, especially since this is snapshot
> > 
> > Jason
> 
> Actually, snapshot ignores pfn_flags_mask and default_flags.

Yes, so no reason to set them to not 0..

Jason
