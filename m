Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EFB1873D3
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 21:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbgCPUJb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 16:09:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35009 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732467AbgCPUJb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 16:09:31 -0400
Received: by mail-qt1-f194.google.com with SMTP id v15so15448360qto.2
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Mar 2020 13:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PDNAD6S4KTd0gVi/XavugH3SkseCvoY3JtPvtDkTohU=;
        b=nsCUT+96D3VjNsrl2Pj9woIM6G1+L/e49spoRATL4fYjDKCmMd79hBVnO7MFyaCD1E
         H69sQ7R6uU7FU1kcv0npVCqHpzMBtsvzDK28Pfw8oN0s3CNOZ7+TbImmjH8HhEb/Yvdx
         ZG3uBlKT8XbAsY+s/pCfiSC3PXRh+bHBVMDz5a3bPc3ch47yOIAYnLcRAYKXiXB3N6I2
         jKc2tog/kKDGW+zuxi6eIrzxrsWorBN3cVgs8d7fBlFPY8tOruUkf6N4YQJhaUkJ8eHZ
         Memms57s9EmDz1lMImGj4va9n96e8vXoFpeBuA+HvVvzgW9e98ej1R2E3nBP0qv2Md/p
         Yt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PDNAD6S4KTd0gVi/XavugH3SkseCvoY3JtPvtDkTohU=;
        b=XHMJ76FYvaYuT9koRBy7RJkFFZOyv+3jrtjo2+dq9J9dzNLEhw8zmE3u133DtZF7T5
         D09ukrku/FgiWx2dQUf79kokmIJ15+g+8Kf9bekvYKCNKyJswGQB/RIaCqmR1lYWLkzh
         PeZMVhu6kPUECbpqpiJ6eE51YTzQiEEtpg9JCqv9nLouX0G+LhSe9YJ5l5xtwhOSkXJf
         LdlbJbcCl4kV9RQC25Up1bAVoO9GaXcPt3ILOWq2U/2R4NBDgJIQ4H0LenMQUw+i8LOd
         t58MLVSbt7M1V8LTwXvPp28jJS9Lw71u6WGfNtJms2nVcVZhzD/ySG2kArC/rHKTpBYT
         K0tA==
X-Gm-Message-State: ANhLgQ0ykyQSgiW0bSCMTrjWAjcLInU+KmzqKmEm+BbrryL+P+83CFAT
        9iP8wUSIAXSStO0plPEbI/t9cA==
X-Google-Smtp-Source: ADFU+vvdX8KgG8/0KMMaE8Eeq2N9rxxz03kyvkaJo4ff8RQccEfxQBSqW5ZD+n9+Mwx3iLq3b9YiFA==
X-Received: by 2002:ac8:5193:: with SMTP id c19mr1934353qtn.204.1584389370366;
        Mon, 16 Mar 2020 13:09:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t7sm516565qtr.88.2020.03.16.13.09.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Mar 2020 13:09:29 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jDw3F-0007G3-BI; Mon, 16 Mar 2020 17:09:29 -0300
Date:   Mon, 16 Mar 2020 17:09:29 -0300
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
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
Message-ID: <20200316200929.GB20010@ziepe.ca>
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-3-hch@lst.de>
 <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
 <20200316184935.GA25322@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316184935.GA25322@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 07:49:35PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 16, 2020 at 11:42:19AM -0700, Ralph Campbell wrote:
> >
> > On 3/16/20 10:52 AM, Christoph Hellwig wrote:
> >> No driver has actually used properly wire up and support this feature.
> >> There is various code related to it in nouveau, but as far as I can tell
> >> it never actually got turned on, and the only changes since the initial
> >> commit are global cleanups.
> >
> > This is not actually true. OpenCL 2.x does support SVM with nouveau and
> > device private memory via clEnqueueSVMMigrateMem().
> > Also, Ben Skeggs has accepted a set of patches to map GPU memory after being
> > migrated and this change would conflict with that.
> 
> Can you explain me how we actually invoke this code?
> 
> For that we'd need HMM_PFN_DEVICE_PRIVATE NVIF_VMM_PFNMAP_V0_VRAM
> set in ->pfns before calling hmm_range_fault, which isn't happening.

Oh, I got tripped on this too

The logic is backwards from what you'd think.. If you *set*
HMM_PFN_DEVICE_PRIVATE then this triggers:

hmm_pte_need_fault():
	if ((cpu_flags & range->flags[HMM_PFN_DEVICE_PRIVATE])) {
		/* Do we fault on device memory ? */
		if (pfns & range->flags[HMM_PFN_DEVICE_PRIVATE]) {
			*write_fault = pfns & range->flags[HMM_PFN_WRITE];
			*fault = true;
		}
		return;
	}

Ie if the cpu page is a DEVICE_PRIVATE and the caller sets
HMM_PFN_DEVICE_PRIVATE in the input flags (pfns) then it always faults
it and never sets HMM_PFN_DEVICE_PRIVATE in the output flags.

So setting 0 enabled device_private support, and nouveau is Ok.

AMDGPU is broken because it can't handle device private and can't set
the flag to supress it.

I was going to try and sort this out as part of getting rid of range->flags

Jason
