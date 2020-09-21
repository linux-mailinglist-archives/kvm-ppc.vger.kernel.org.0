Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1373273691
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Sep 2020 01:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgIUXTc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Sep 2020 19:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIUXTc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Sep 2020 19:19:32 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99532C061755;
        Mon, 21 Sep 2020 16:19:32 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BwL4K2tFPz9sSt; Tue, 22 Sep 2020 09:19:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600730369; bh=Gh/jGMCMQmrrfp+HhoHjE8q2QWpEvx5rxPTcdpfPEt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tLvKt6RBA7E4vUVZYVD3O0hQckC/kqu0Y6WFB8O4lOYXfgvdTXK9gsmS2BD7ls6Xr
         A1w4ELvBsIAhbgPaFFbignPhVBc1+vqX+JLVk+i4hT/EJmapByfasDbtvk9ZdIRSiY
         VVBZFvHlCGQiUgyF/mZ9yP+i3k8ThJdX+sjKTRfWPcM8mzSoNZ9quQ9ynaUbGeGfwD
         zHkAT3JewA/O4SLmM/ZXDet68DJvmz2PUC/X2oxcj8Ee8mh4Y6Ut6o1RPksx6psUXi
         nbGOfz1G8iQA3tLtlpbbVNHjCbXyoRskt/SrPz3ILNA3SiwzpqzpxiLangK6IevOV/
         epbK+jzQSZ3hw==
Date:   Tue, 22 Sep 2020 09:19:25 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     sathnaga@linux.vnet.ibm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH V2] Doc: admin-guide: Add entry for kvm_cma_resv_ratio
 kernel param
Message-ID: <20200921231925.GA348814@thinks.paulus.ozlabs.org>
References: <20200921090220.14981-1-sathnaga@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921090220.14981-1-sathnaga@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 21, 2020 at 02:32:20PM +0530, sathnaga@linux.vnet.ibm.com wrote:
> From: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> 
> Add document entry for kvm_cma_resv_ratio kernel param which
> is used to alter the KVM contiguous memory allocation percentage
> for hash pagetable allocation used by hash mode PowerPC KVM guests.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> ---
> 
> V2: 
> Addressed review comments from Randy.
> 
> V1: https://lkml.org/lkml/2020/9/16/72
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a1068742a6df..932ed45740c9 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2258,6 +2258,14 @@
>  			[KVM,ARM] Allow use of GICv4 for direct injection of
>  			LPIs.
>  
> +	kvm_cma_resv_ratio=n [PPC]
> +			Reserves given percentage from system memory area for
> +			contiguous memory allocation for KVM hash pagetable
> +			allocation.
> +			By default it reserves 5% of total system memory.

I am concerned that using the term "reserve" here could give the
impression that this memory is then not available for any other use.
It is in fact available for other uses as long as they are movable
allocations.  So this memory is available for uses such as process
anonymous memory and page cache, just not for things like kmalloc.

I'm not sure what would be a better term than "reserve", though.
Perhaps we need to add a sentence something like "The reserved memory
is available for use as process memory and page cache when it is not
being used by KVM."

Paul.
