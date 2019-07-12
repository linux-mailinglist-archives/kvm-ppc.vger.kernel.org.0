Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3528F66FAA
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGLNJW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Jul 2019 09:09:22 -0400
Received: from ozlabs.org ([203.11.71.1]:59563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbfGLNJV (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 12 Jul 2019 09:09:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lYCz49PFz9s3l;
        Fri, 12 Jul 2019 23:09:19 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, david@gibson.dropbear.id.au,
        sjitindarsingh@gmail.com
Subject: Re: [PATCH] powerpc: mm: Limit rma_size to 1TB when running without HV mode
In-Reply-To: <20190710052018.14628-1-sjitindarsingh@gmail.com>
References: <20190710052018.14628-1-sjitindarsingh@gmail.com>
Date:   Fri, 12 Jul 2019 23:09:18 +1000
Message-ID: <87o91ze6wx.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> The virtual real mode addressing (VRMA) mechanism is used when a
> partition is using HPT (Hash Page Table) translation and performs
> real mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this
> mode effective address bits 0:23 are treated as zero (i.e. the access
> is aliased to 0) and the access is performed using an implicit 1TB SLB
> entry.
>
> The size of the RMA (Real Memory Area) is communicated to the guest as
> the size of the first memory region in the device tree. And because of
> the mechanism described above can be expected to not exceed 1TB. In the
> event that the host erroneously represents the RMA as being larger than
> 1TB, guest accesses in real mode to memory addresses above 1TB will be
> aliased down to below 1TB. This means that a memory access performed in
> real mode may differ to one performed in virtual mode for the same memory
> address, which would likely have unintended consequences.
>
> To avoid this outcome have the guest explicitly limit the size of the
> RMA to the current maximum, which is 1TB. This means that even if the
> first memory block is larger than 1TB, only the first 1TB should be
> accessed in real mode.
>
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

I added:

Fixes: c3ab300ea555 ("powerpc: Add POWER9 cputable entry")
Cc: stable@vger.kernel.org # v4.6+


Which is not exactly correct, but probably good enough?

cheers

> diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
> index 28ced26f2a00..4d0e2cce9cd5 100644
> --- a/arch/powerpc/mm/book3s64/hash_utils.c
> +++ b/arch/powerpc/mm/book3s64/hash_utils.c
> @@ -1901,11 +1901,19 @@ void hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
>  	 *
>  	 * For guests on platforms before POWER9, we clamp the it limit to 1G
>  	 * to avoid some funky things such as RTAS bugs etc...
> +	 * On POWER9 we limit to 1TB in case the host erroneously told us that
> +	 * the RMA was >1TB. Effective address bits 0:23 are treated as zero
> +	 * (meaning the access is aliased to zero i.e. addr = addr % 1TB)
> +	 * for virtual real mode addressing and so it doesn't make sense to
> +	 * have an area larger than 1TB as it can't be addressed.
>  	 */
>  	if (!early_cpu_has_feature(CPU_FTR_HVMODE)) {
>  		ppc64_rma_size = first_memblock_size;
>  		if (!early_cpu_has_feature(CPU_FTR_ARCH_300))
>  			ppc64_rma_size = min_t(u64, ppc64_rma_size, 0x40000000);
> +		else
> +			ppc64_rma_size = min_t(u64, ppc64_rma_size,
> +					       1UL << SID_SHIFT_1T);
>  
>  		/* Finally limit subsequent allocations */
>  		memblock_set_current_limit(ppc64_rma_size);
> -- 
> 2.13.6
