Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88AB187A8F
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Mar 2020 08:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgCQHe5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Mar 2020 03:34:57 -0400
Received: from verein.lst.de ([213.95.11.211]:58213 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgCQHe5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 17 Mar 2020 03:34:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 46FA068BFE; Tue, 17 Mar 2020 08:34:54 +0100 (CET)
Date:   Tue, 17 Mar 2020 08:34:54 +0100
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
Subject: Re: [PATCH 3/4] mm: simplify device private page handling in
 hmm_range_fault
Message-ID: <20200317073454.GA5843@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-4-hch@lst.de> <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Mar 16, 2020 at 03:49:51PM -0700, Ralph Campbell wrote:
> On 3/16/20 12:32 PM, Christoph Hellwig wrote:
>> Remove the code to fault device private pages back into system memory
>> that has never been used by any driver.  Also replace the usage of the
>> HMM_PFN_DEVICE_PRIVATE flag in the pfns array with a simple
>> is_device_private_page check in nouveau.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Getting rid of HMM_PFN_DEVICE_PRIVATE seems reasonable to me since a driver can
> look at the struct page but what if a driver needs to fault in a page from
> another device's private memory? Should it call handle_mm_fault()?

Obviously no driver cared for that so far.  Once we have test cases
for that and thus testable code we can add code to fault it in from
hmm_vma_handle_pte.
