Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E138DBCC
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 May 2021 18:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEWQH7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm-ppc@lfdr.de>); Sun, 23 May 2021 12:07:59 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:53968 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhEWQH7 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 23 May 2021 12:07:59 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4Fp4w710KqzB6nY;
        Sun, 23 May 2021 18:06:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Skq_akrOTQYD; Sun, 23 May 2021 18:06:31 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4Fp4w705qFzB6nW;
        Sun, 23 May 2021 18:06:31 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id C62A359; Sun, 23 May 2021 18:10:54 +0200 (CEST)
Received: from 37-164-13-85.coucou-networks.fr
 (37-164-13-85.coucou-networks.fr [37.164.13.85]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sun, 23 May 2021 18:10:54 +0200
Date:   Sun, 23 May 2021 18:10:54 +0200
Message-ID: <20210523181054.Horde.1K8Ldhm0aj339_vHlUQCkQ1@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix reverse map real-mode address
 lookup with huge vmalloc
In-Reply-To: <20210523155338.3254465-1-npiggin@gmail.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> a écrit :

> real_vmalloc_addr() does not currently work for huge vmalloc, which is
> what the reverse map can be allocated with for radix host, hash guest.
>
> Add huge page awareness to the function.
>
> Fixes: 8abddd968a30 ("powerpc/64s/radix: Enable huge vmalloc mappings")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c  
> b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> index 7af7c70f1468..5f68cb5cc009 100644
> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> @@ -26,16 +26,23 @@
>  static void *real_vmalloc_addr(void *x)
>  {
>  	unsigned long addr = (unsigned long) x;
> +	unsigned long mask;
> +	int shift;
>  	pte_t *p;
> +
>  	/*
> -	 * assume we don't have huge pages in vmalloc space...
> -	 * So don't worry about THP collapse/split. Called
> -	 * Only in realmode with MSR_EE = 0, hence won't need irq_save/restore.
> +	 * This is called only in realmode with MSR_EE = 0, hence won't need
> +	 * irq_save/restore around find_init_mm_pte.
>  	 */
> -	p = find_init_mm_pte(addr, NULL);
> +	p = find_init_mm_pte(addr, &shift);
>  	if (!p || !pte_present(*p))
>  		return NULL;
> -	addr = (pte_pfn(*p) << PAGE_SHIFT) | (addr & ~PAGE_MASK);
> +	if (!shift)
> +		shift = PAGE_SHIFT;
> +
> +	mask = (1UL << shift) - 1;
> +	addr = (pte_pfn(*p) << PAGE_SHIFT) | (addr & mask);

Looks strange, before we have ~MASK now we have mask without the ~

Also use PFN_PHYS() instead of open coding ?




> +
>  	return __va(addr);
>  }
>
> --
> 2.23.0


