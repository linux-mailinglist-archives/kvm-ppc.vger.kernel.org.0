Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B5F1897FA
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Mar 2020 10:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgCRJec (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Mar 2020 05:34:32 -0400
Received: from verein.lst.de ([213.95.11.211]:35853 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727355AbgCRJec (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 18 Mar 2020 05:34:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CF1E568C65; Wed, 18 Mar 2020 10:34:28 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:34:28 +0100
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
Message-ID: <20200318093428.GA6538@lst.de>
References: <20200316193216.920734-1-hch@lst.de> <20200316193216.920734-4-hch@lst.de> <7256f88d-809e-4aba-3c46-a223bd8cc521@nvidia.com> <20200317073454.GA5843@lst.de> <a8c5a33d-4c64-df74-2b98-26ddd5e6da00@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c5a33d-4c64-df74-2b98-26ddd5e6da00@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 17, 2020 at 03:43:47PM -0700, Ralph Campbell wrote:
>> Obviously no driver cared for that so far.  Once we have test cases
>> for that and thus testable code we can add code to fault it in from
>> hmm_vma_handle_pte.
>>
>
> I'm OK with the series. I think I would have been less confused if I looked at
> patch 4 then 3.

I guess I could just merge 3 and 4 if it is too confusing otherwise.
