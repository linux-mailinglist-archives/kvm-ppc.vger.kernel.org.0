Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24485A13F4
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Aug 2019 10:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfH2Ija (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Aug 2019 04:39:30 -0400
Received: from verein.lst.de ([213.95.11.211]:44237 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfH2Ija (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 29 Aug 2019 04:39:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 55B6568BFE; Thu, 29 Aug 2019 10:39:27 +0200 (CEST)
Date:   Thu, 29 Aug 2019 10:39:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH v7 4/7] kvmppc: Handle memory plug/unplug to secure VM
Message-ID: <20190829083927.GB13039@lst.de>
References: <20190822102620.21897-1-bharata@linux.ibm.com> <20190822102620.21897-5-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822102620.21897-5-bharata@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 22, 2019 at 03:56:17PM +0530, Bharata B Rao wrote:
> +	/*
> +	 * TODO: Handle KVM_MR_MOVE
> +	 */
> +	if (change == KVM_MR_CREATE) {
> +		uv_register_mem_slot(kvm->arch.lpid,
> +				     new->base_gfn << PAGE_SHIFT,
> +				     new->npages * PAGE_SIZE,
> +				     0, new->id);
> +	} else if (change == KVM_MR_DELETE)
> +		uv_unregister_mem_slot(kvm->arch.lpid, old->id);
>  }

In preparation for the KVM_MR_MOVE addition just using a switch statement
here from the very beginning might make the code a little nicer to read.
