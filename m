Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE44ABDC2
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Sep 2019 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfIFQcq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Sep 2019 12:32:46 -0400
Received: from verein.lst.de ([213.95.11.211]:58715 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfIFQcq (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 6 Sep 2019 12:32:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7402B68B20; Fri,  6 Sep 2019 18:32:41 +0200 (CEST)
Date:   Fri, 6 Sep 2019 18:32:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com
Subject: Re: [PATCH v7 1/7] kvmppc: Driver to manage pages of secure guest
Message-ID: <20190906163241.GA12516@lst.de>
References: <20190822102620.21897-1-bharata@linux.ibm.com> <20190822102620.21897-2-bharata@linux.ibm.com> <20190829083810.GA13039@lst.de> <20190830034259.GD31913@in.ibm.com> <20190902075356.GA28967@lst.de> <20190906113639.GA8748@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906113639.GA8748@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 06, 2019 at 05:06:39PM +0530, Bharata B Rao wrote:
> > Also is bit 56+ a set of values, so is there 1 << 56 and 3 << 56 as well?  Seems
> > like even that other patch doesn't fully define these "pfn" values.
> 
> I realized that the bit numbers have changed, it is no longer bits 60:56,
> but instead top 8bits. 
> 
> #define KVMPPC_RMAP_UVMEM_PFN   0x0200000000000000
> static inline bool kvmppc_rmap_is_uvmem_pfn(unsigned long *rmap)
> {
>         return ((*rmap & 0xff00000000000000) == KVMPPC_RMAP_UVMEM_PFN);
> }

In that overall scheme I'd actually much prefer something like (names
just made up, they should vaguely match the spec this written to):

static inline unsigned long kvmppc_rmap_type(unsigned long *rmap)
{
	return (rmap & 0xff00000000000000);
}

And then where you check it you can use:

	if (kvmppc_rmap_type(*rmap) == KVMPPC_RMAP_UVMEM_PFN)

and where you set it you do:

	*rmap |= KVMPPC_RMAP_UVMEM_PFN;

as in the current patch to keep things symmetric.
