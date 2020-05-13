Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3B1D05C3
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 May 2020 06:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgEMEEu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 May 2020 00:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbgEMEEt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 13 May 2020 00:04:49 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCB0C061A0C;
        Tue, 12 May 2020 21:04:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49MLfR3Tk6z9sSW;
        Wed, 13 May 2020 14:04:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1589342687;
        bh=Yjz2Wb53OWN9TUkOZ7whQvlOOqFIz+DhbA+ZZbNQp6s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RyzYhpPET7AgTJXwFj8NIqOhPbYyh6o3OcZ5C0Ew/dCgpI0i40FU1S11pAGd6EX5r
         mI+jbUAZbrlIVLwUbtCWBNtjyETSpFGLIpgGNA9Du/OVmZQq/H9zt8DznynDbPvPYj
         ZFXGgiEWc/xkvcL84DHJzGpLDe6eo8K8w+fICRzyfoU7JZ+ttOXXP0oOGup3D02Lng
         DirKtgmgMm2FXmOv0RxAvsmFWrDNFKm06D/zJ3QUzZfP3x1xkRlswDfo/eVBePiBAP
         hBgLAgDgVMktz0mAHVgtMopvVyTDpcpJqwjYwqza9DJExq63uLIu/CR+sjar/3OwEK
         pFE/FPWhAkW/g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Qian Cai <cai@lca.pw>
Cc:     paulus@ozlabs.org, benh@kernel.crashing.org,
        catalin.marinas@arm.com, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] powerpc/kvm: silence kmemleak false positives
In-Reply-To: <20200509015538.3183-1-cai@lca.pw>
References: <20200509015538.3183-1-cai@lca.pw>
Date:   Wed, 13 May 2020 14:05:07 +1000
Message-ID: <87h7wkbhu4.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Qian Cai <cai@lca.pw> writes:
> kvmppc_pmd_alloc() and kvmppc_pte_alloc() allocate some memory but then
> pud_populate() and pmd_populate() will use __pa() to reference the newly
> allocated memory. The same is in xive_native_provision_pages().

Can you please split this into two patches, one for the KVM cases and
one for xive.

That way the KVM patch can go via the kvm-ppc tree, and I'll take the
xive one via powerpc.

> Since kmemleak is unable to track the physical memory resulting in false
> positives, silence those by using kmemleak_ignore().
>
> unreferenced object 0xc000201c382a1000 (size 4096):
>   comm "qemu-kvm", pid 124828, jiffies 4295733767 (age 341.250s)
>   hex dump (first 32 bytes):
>     c0 00 20 09 f4 60 03 87 c0 00 20 10 72 a0 03 87  .. ..`.... .r...
>     c0 00 20 0e 13 a0 03 87 c0 00 20 1b dc c0 03 87  .. ....... .....
>   backtrace:
>     [<000000004cc2790f>] kvmppc_create_pte+0x838/0xd20 [kvm_hv]
>     kvmppc_pmd_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:366
>     (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:590
>     [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
>     [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
>     [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
>     [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
>     [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
>     [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
>     [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
>     [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
>     [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
>     [<000000004afc4310>] system_call_exception+0x114/0x1e0
>     [<00000000fb70a873>] system_call_common+0xf0/0x278
> unreferenced object 0xc0002001f0c03900 (size 256):
>   comm "qemu-kvm", pid 124830, jiffies 4295735235 (age 326.570s)
>   hex dump (first 32 bytes):
>     c0 00 20 10 fa a0 03 87 c0 00 20 10 fa a1 03 87  .. ....... .....
>     c0 00 20 10 fa a2 03 87 c0 00 20 10 fa a3 03 87  .. ....... .....
>   backtrace:
>     [<0000000023f675b8>] kvmppc_create_pte+0x854/0xd20 [kvm_hv]
>     kvmppc_pte_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:356
>     (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:593
>     [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
>     [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
>     [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
>     [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
>     [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
>     [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
>     [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
>     [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
>     [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
>     [<000000004afc4310>] system_call_exception+0x114/0x1e0
>     [<00000000fb70a873>] system_call_common+0xf0/0x278
> unreferenced object 0xc000201b53e90000 (size 65536):
>   comm "qemu-kvm", pid 124557, jiffies 4295650285 (age 364.370s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000acc2fb77>] xive_native_alloc_vp_block+0x168/0x210
>     xive_native_provision_pages at arch/powerpc/sysdev/xive/native.c:645
>     (inlined by) xive_native_alloc_vp_block at arch/powerpc/sysdev/xive/native.c:674
>     [<000000004d5c7964>] kvmppc_xive_compute_vp_id+0x20c/0x3b0 [kvm]
>     [<0000000055317cd2>] kvmppc_xive_connect_vcpu+0xa4/0x4a0 [kvm]
>     [<0000000093dfc014>] kvm_arch_vcpu_ioctl+0x388/0x508 [kvm]
>     [<00000000d25aea0f>] kvm_vcpu_ioctl+0x15c/0x950 [kvm]
>     [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
>     [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
>     [<000000004afc4310>] system_call_exception+0x114/0x1e0
>     [<00000000fb70a873>] system_call_common+0xf0/0x278
>
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 16 ++++++++++++++--
>  arch/powerpc/sysdev/xive/native.c      |  4 ++++
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> index aa12cd4078b3..bc6c1aa3d0e9 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> @@ -353,7 +353,13 @@ static struct kmem_cache *kvm_pmd_cache;

This should probably also have an include of <linux/kmemleak.h> ?

>  static pte_t *kvmppc_pte_alloc(void)
>  {
> -	return kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
> +	pte_t *pte;
> +
> +	pte = kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
> +	/* pmd_populate() will only reference _pa(pte). */
> +	kmemleak_ignore(pte);
> +
> +	return pte;
>  }
>  
>  static void kvmppc_pte_free(pte_t *ptep)


cheers
