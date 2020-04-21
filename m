Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4577E1B2803
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Apr 2020 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgDUNe7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Apr 2020 09:34:59 -0400
Received: from ozlabs.org ([203.11.71.1]:35695 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbgDUNex (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 21 Apr 2020 09:34:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4964LH5jycz9sSY;
        Tue, 21 Apr 2020 23:34:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1587476088;
        bh=Y+z6/rcJIObmZtZ51xGieSwpLR256JCEweZeuezbpcY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=KGVt1GTIlQZOPxOIid++1szONXTthboUOft5u/6EE6JysRPJ8O3iv3vAb+Ihm6B41
         2cWtWSpLVTDTgAtQYInJePYFBXqa31pJ2H2LtW1YCjjhfeyYaK/1BOM/y63Ndfx61F
         +2Z05AzNnKItYukVZO6EckdQVK/oQC5HjIxrJss7+2q0YTdpRwbANP94m9qVl1fBQH
         ZxK5XTabGGImV8mfAnOERHQffGm8D4Z3DOHbFFwTqJqDf006IT8h5JTjmOh/FVjGNp
         7M4aWACvFXqgMhLc59XWbdSFubep7HPt419o68jfI5bOs3y4XRQOzUN7zajxALFiDz
         5g/ux86TtXjfA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     paulus@samba.org, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>, benh@kernel.crashing.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: read ibm,secure-memory nodes
In-Reply-To: <20200416162715.45846-1-ldufour@linux.ibm.com>
References: <20200416162715.45846-1-ldufour@linux.ibm.com>
Date:   Tue, 21 Apr 2020 23:34:59 +1000
Message-ID: <87k129gdx8.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Laurent,

Laurent Dufour <ldufour@linux.ibm.com> writes:
> The newly introduced ibm,secure-memory nodes supersede the
> ibm,uv-firmware's property secure-memory-ranges.

Is either documented in a device tree binding document anywhere?

cheers

> Firmware will no more expose the secure-memory-ranges property so first
> read the new one and if not found rollback to the older one.
>
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 53b88cae3e73..ad950f8996e0 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -735,6 +735,20 @@ static u64 kvmppc_get_secmem_size(void)
>  	const __be32 *prop;
>  	u64 size = 0;
>  
> +	/*
> +	 * First try the new ibm,secure-memory nodes which supersede the
> +	 * secure-memory-ranges property.
> +	 * If we found somes, no need to read the deprecated one.
> +	 */
> +	for_each_compatible_node(np, NULL, "ibm,secure-memory") {
> +		prop = of_get_property(np, "reg", &len);
> +		if (!prop)
> +			continue;
> +		size += of_read_number(prop + 2, 2);
> +	}
> +	if (size)
> +		return size;
> +
>  	np = of_find_compatible_node(NULL, NULL, "ibm,uv-firmware");
>  	if (!np)
>  		goto out;
> -- 
> 2.26.1
