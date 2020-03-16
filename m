Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE8C1872B6
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 19:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgCPStj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 14:49:39 -0400
Received: from verein.lst.de ([213.95.11.211]:55883 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732298AbgCPSti (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 16 Mar 2020 14:49:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9EC4C68BFE; Mon, 16 Mar 2020 19:49:35 +0100 (CET)
Date:   Mon, 16 Mar 2020 19:49:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
Message-ID: <20200316184935.GA25322@lst.de>
References: <20200316175259.908713-1-hch@lst.de> <20200316175259.908713-3-hch@lst.de> <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 11:42:19AM -0700, Ralph Campbell wrote:
>
> On 3/16/20 10:52 AM, Christoph Hellwig wrote:
>> No driver has actually used properly wire up and support this feature.
>> There is various code related to it in nouveau, but as far as I can tell
>> it never actually got turned on, and the only changes since the initial
>> commit are global cleanups.
>
> This is not actually true. OpenCL 2.x does support SVM with nouveau and
> device private memory via clEnqueueSVMMigrateMem().
> Also, Ben Skeggs has accepted a set of patches to map GPU memory after being
> migrated and this change would conflict with that.

Can you explain me how we actually invoke this code?

For that we'd need HMM_PFN_DEVICE_PRIVATE NVIF_VMM_PFNMAP_V0_VRAM
set in ->pfns before calling hmm_range_fault, which isn't happening.
