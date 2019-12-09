Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32F116BCA
	for <lists+kvm-ppc@lfdr.de>; Mon,  9 Dec 2019 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfLILIj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 9 Dec 2019 06:08:39 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:48203 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbfLILIi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 9 Dec 2019 06:08:38 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47WgRQ3lb0z9sPc;
        Mon,  9 Dec 2019 22:08:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1575889716;
        bh=rYe8qrzC5Yad6k0eMTD1iKIi3I9u3ShpcDApHGCih3Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gGCrjof44OinljG4Usq9loRpcZytu5Q1MmX9DfuOjt5J0oZKbDHKViLkY1olhW6TL
         pn3HGcv7TtoOBTs89AAkcK3LZjCcC3pXDiGZYqa3idH9EFVf0ZMTzTbQy2ifdjUnXs
         WWvGJ0hDpCBUzNv0pFFMRi6eJNsdTc4VS8zXAeqBueA217DSpk+dnzLbU3IurJsDim
         NmWi5VTrIrL4NS5d96cHb6EX8oD4F2+FEVHCHxaM4N6GC2ZDLMm5fPTxG5YYbCsM4W
         l+4EgpGiwjPYyVN9avCdVDu8fRbCUD5NAiTisSShqziayscWKNDKBtEW1ypOAZP5x8
         1kdoBUkZl7b3w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Steven Price <steven.price@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc:     Steven Price <steven.price@arm.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <Mark.Rutland@arm.com>,
        "Liang\, Kan" <kan.liang@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v16 06/25] powerpc: mm: Add p?d_leaf() definitions
In-Reply-To: <20191206135316.47703-7-steven.price@arm.com>
References: <20191206135316.47703-1-steven.price@arm.com> <20191206135316.47703-7-steven.price@arm.com>
Date:   Mon, 09 Dec 2019 22:08:32 +1100
Message-ID: <875ziprc27.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Steven Price <steven.price@arm.com> writes:
> walk_page_range() is going to be allowed to walk page tables other than
> those of user space. For this it needs to know when it has reached a
> 'leaf' entry in the page tables. This information is provided by the
> p?d_leaf() functions/macros.
>
> For powerpc pmd_large() already exists and does what we want, so hoist
> it out of the CONFIG_TRANSPARENT_HUGEPAGE condition and implement the
> other levels. Macros are used to provide the generic p?d_leaf() names.
>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> CC: linuxppc-dev@lists.ozlabs.org
> CC: kvm-ppc@vger.kernel.org
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 30 ++++++++++++++------
>  1 file changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index b01624e5c467..3dd7b6f5edd0 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -923,6 +923,12 @@ static inline int pud_present(pud_t pud)
>  	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PRESENT));
>  }
>  
> +#define pud_leaf	pud_large
> +static inline int pud_large(pud_t pud)
> +{
> +	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
> +}

We already have:

#define pud_is_leaf pud_is_leaf
static inline bool pud_is_leaf(pud_t pud)
{
	return !!(pud_raw(pud) & cpu_to_be64(_PAGE_PTE));
}

And so on.

These went in relatively recently in:

  d6eacedd1f0e ("powerpc/book3s: Use config independent helpers for page table walk")


Assuming those all work for you, maybe your patch in this series should
just do:

#define pud_leaf pud_is_leaf

And so on. And then we can do a patch later to change the arch/powerpc
code to use pud_leaf() etc. directly and drop the "is" versions.

cheers


> @@ -966,6 +972,12 @@ static inline int pgd_present(pgd_t pgd)
>  	return !!(pgd_raw(pgd) & cpu_to_be64(_PAGE_PRESENT));
>  }
>  
> +#define pgd_leaf	pgd_large
> +static inline int pgd_large(pgd_t pgd)
> +{
> +	return !!(pgd_raw(pgd) & cpu_to_be64(_PAGE_PTE));
> +}
> +
>  static inline pte_t pgd_pte(pgd_t pgd)
>  {
>  	return __pte_raw(pgd_raw(pgd));
> @@ -1133,6 +1145,15 @@ static inline bool pmd_access_permitted(pmd_t pmd, bool write)
>  	return pte_access_permitted(pmd_pte(pmd), write);
>  }
>  
> +#define pmd_leaf	pmd_large
> +/*
> + * returns true for pmd migration entries, THP, devmap, hugetlb
> + */
> +static inline int pmd_large(pmd_t pmd)
> +{
> +	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
>  extern pmd_t mk_pmd(struct page *page, pgprot_t pgprot);
> @@ -1159,15 +1180,6 @@ pmd_hugepage_update(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp,
>  	return hash__pmd_hugepage_update(mm, addr, pmdp, clr, set);
>  }
>  
> -/*
> - * returns true for pmd migration entries, THP, devmap, hugetlb
> - * But compile time dependent on THP config
> - */
> -static inline int pmd_large(pmd_t pmd)
> -{
> -	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_PTE));
> -}
> -
>  static inline pmd_t pmd_mknotpresent(pmd_t pmd)
>  {
>  	return __pmd(pmd_val(pmd) & ~_PAGE_PRESENT);
> -- 
> 2.20.1
