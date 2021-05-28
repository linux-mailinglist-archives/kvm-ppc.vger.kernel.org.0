Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C073E394927
	for <lists+kvm-ppc@lfdr.de>; Sat, 29 May 2021 01:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhE1XiI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 19:38:08 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54561 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhE1XiI (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 28 May 2021 19:38:08 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FsLg33rm6z9sRf;
        Sat, 29 May 2021 09:36:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1622244991;
        bh=WfceVqG2ph1t0qIlz3+8z99n7uyRcmZUoB77cZnEtzs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MXMut9ar0XyljUv9U/i7CQirX5FkTZBO9JZ91z8jMCczG+Vgx+gGMiO3BSmvRH8d8
         oXSZGIVhpJIs0VU2bm4Z9evd/lIIUArytLQsw5EaGcGmwvOKpD1/3p8I/1AY/gr/02
         z+AHGOgl0ZjwDRC6UkJNoEKnQJN8ux7UpBpR52mfI5Mi5mDuur6pz5gF8JNII777Ry
         E53x38Vav+Z1tTNDXSqAdVO3wTSPHWmldQygU1qolonn1dwiK+O44i1xlsLvFB2Fb+
         0I/bHI3y3vgTji07mqZbMkEAr0ooycMkmAQjdTsWAMPp/sL/uL5HpfjAv21+JUjOBr
         GHZUqElT1lulg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Fix reverse map real-mode
 address lookup with huge vmalloc
In-Reply-To: <20210526120005.3432222-1-npiggin@gmail.com>
References: <20210526120005.3432222-1-npiggin@gmail.com>
Date:   Sat, 29 May 2021 09:36:29 +1000
Message-ID: <87sg26h1mq.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> real_vmalloc_addr() does not currently work for huge vmalloc, which is
> what the reverse map can be allocated with for radix host, hash guest.
>
> Extract the hugepage aware equivalent from eeh code into a helper, and
> convert existing sites including this one to use it.
>
> Fixes: 8abddd968a30 ("powerpc/64s/radix: Enable huge vmalloc mappings")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

I changed the subject to "powerpc: ..." now that it's not just a KVM patch.

...

> diff --git a/arch/powerpc/kernel/io-workarounds.c b/arch/powerpc/kernel/io-workarounds.c
> index 51bbaae94ccc..ddba8761e58c 100644
> --- a/arch/powerpc/kernel/io-workarounds.c
> +++ b/arch/powerpc/kernel/io-workarounds.c
> @@ -65,22 +65,13 @@ struct iowa_bus *iowa_mem_find_bus(const PCI_IO_ADDR addr)
>  		bus = &iowa_busses[token - 1];
>  	else {
>  		unsigned long vaddr, paddr;
> -		pte_t *ptep;
>  
>  		vaddr = (unsigned long)PCI_FIX_ADDR(addr);
>  		if (vaddr < PHB_IO_BASE || vaddr >= PHB_IO_END)
>  			return NULL;
> -		/*
> -		 * We won't find huge pages here (iomem). Also can't hit
> -		 * a page table free due to init_mm
> -		 */
> -		ptep = find_init_mm_pte(vaddr, &hugepage_shift);
> -		if (ptep == NULL)
> -			paddr = 0;
> -		else {
> -			WARN_ON(hugepage_shift);
> -			paddr = pte_pfn(*ptep) << PAGE_SHIFT;
> -		}
> +
> +		paddr = ppc_find_vmap_phys(vaddr);
> +
>  		bus = iowa_pci_find(vaddr, paddr);
>  
>  		if (bus == NULL)

This needed:

diff --git a/arch/powerpc/kernel/io-workarounds.c b/arch/powerpc/kernel/io-workarounds.c
index ddba8761e58c..c877f074d174 100644
--- a/arch/powerpc/kernel/io-workarounds.c
+++ b/arch/powerpc/kernel/io-workarounds.c
@@ -55,7 +55,6 @@ static struct iowa_bus *iowa_pci_find(unsigned long vaddr, unsigned long paddr)
 #ifdef CONFIG_PPC_INDIRECT_MMIO
 struct iowa_bus *iowa_mem_find_bus(const PCI_IO_ADDR addr)
 {
-	unsigned hugepage_shift;
 	struct iowa_bus *bus;
 	int token;
 

cheers
