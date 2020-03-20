Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345A618C425
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCTAOc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Mar 2020 20:14:32 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46396 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCTAOc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 19 Mar 2020 20:14:32 -0400
Received: by mail-qk1-f196.google.com with SMTP id f28so5162039qkk.13
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Mar 2020 17:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nvP+7glb3WoLHPLLs/r0rddcIOawD21RlTqAwhDLiqM=;
        b=IBIMkWJEumvGX8nb31UJBrjYcGu0g5u0i7eHP++QpNs0mIZt6tfWswZ99ybGL71144
         TUS8HafPlyHOZVPJc34DXy4wvD2P2SicI+yjXJMAWNdhEQeqFLO9eJmeUBTXJUcPEPUa
         tkoalhdc6qC7pqcQ5A1u1vTC8HFvVmUHui1ltpN08lYr1AjQpR35p9tw2xRS8K5B8nkY
         V1i0Xwqjekp1AhehRvyzmsWboMA5Ng9TLIT6gRikdqGksXKnNuq1O8EXy/gA3DV/5RHR
         MvlcIgxxEZsh9nImsc+4Uik71V4BCHkjU2qtXBfIbaUSIg+WCA0dBI5RrRPeZIalrdlS
         Xu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nvP+7glb3WoLHPLLs/r0rddcIOawD21RlTqAwhDLiqM=;
        b=q8OKw6pBX6y/mOIUF/Z43g1Bsu9ryWL3mxz7CzVxOhr25GD7le/UIRlMbIyqo6K9TH
         xEfi1JUPoxFdMBNxZISrjmXc/V98JU0PU+4nz3vL9mhXlnQVbgTmbOWsXSGgmpvd36Xm
         mMf2Yirf2cNIptQsJkrQVuHOubnCcIGQK2ojZYPveZtovJ6iG3IzU/nfe5RS8oohcmT8
         6RfEKEiTH1vR5nKgLy7NGbXiCSOyOjxWGHXb6zwX8jO/YNrWdVXMNQSGQ60tbhuD0UZd
         Vho9mc+KDxIGQSkaKbtGzTqvrvirVVZNPKBGA3BropMdq5jebFJDyMCn1ZQc+t2YzjHt
         5JDA==
X-Gm-Message-State: ANhLgQ21KZ73dEu6rNs4kzBvPpIQD43mYEithwy2hJiTiU3flR77sMwg
        V1g1TuDgEeW8KGtSn0FQraSkSw==
X-Google-Smtp-Source: ADFU+vt3JFreUrolYf7MERgEAXyQL3oYOMgyyLIC9YmuLXfqegVKOTRl/TAqFupqfqMkpNtkljckug==
X-Received: by 2002:ae9:c011:: with SMTP id u17mr5597057qkk.92.1584663269422;
        Thu, 19 Mar 2020 17:14:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id n190sm2631840qkb.93.2020.03.19.17.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 17:14:28 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jF5Iy-0002R4-Dg; Thu, 19 Mar 2020 21:14:28 -0300
Date:   Thu, 19 Mar 2020 21:14:28 -0300
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
Message-ID: <20200320001428.GA9199@ziepe.ca>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fca825-3b0f-188f-bcf2-fadcf3a9f05a@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 04:14:31PM -0700, Ralph Campbell wrote:

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

Since pfns is not initialized pfn_flags_mask should be 0.

> +		.default_flags = dmirror_hmm_flags[HMM_PFN_VALID] |
> +				(write ? dmirror_hmm_flags[HMM_PFN_WRITE] : 0),
> +		.dev_private_owner = dmirror->mdevice,
> +	};
> +	int ret = 0;

> +static int dmirror_snapshot(struct dmirror *dmirror,
> +			    struct hmm_dmirror_cmd *cmd)
> +{
> +	struct mm_struct *mm = dmirror->mm;
> +	unsigned long start, end;
> +	unsigned long size = cmd->npages << PAGE_SHIFT;
> +	unsigned long addr;
> +	unsigned long next;
> +	uint64_t pfns[64];
> +	unsigned char perm[64];
> +	char __user *uptr;
> +	struct hmm_range range = {
> +		.pfns = pfns,
> +		.flags = dmirror_hmm_flags,
> +		.values = dmirror_hmm_values,
> +		.pfn_shift = DPT_SHIFT,
> +		.pfn_flags_mask = ~0ULL,

Same here, especially since this is snapshot

Jason
