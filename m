Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22F48D2B2
	for <lists+kvm-ppc@lfdr.de>; Wed, 14 Aug 2019 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHNMEy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 14 Aug 2019 08:04:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39777 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNMEx (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 14 Aug 2019 08:04:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 467pDL4Wbvz9sDB;
        Wed, 14 Aug 2019 22:04:50 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: Re: [PATCH v5 5/7] powerpc/mm: Write to PTCR only if ultravisor disabled
In-Reply-To: <20190808040555.2371-6-cclaudio@linux.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com> <20190808040555.2371-6-cclaudio@linux.ibm.com>
Date:   Wed, 14 Aug 2019 22:04:49 +1000
Message-ID: <87wofg6jha.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> In ultravisor enabled systems, PTCR becomes ultravisor privileged only
> for writing and an attempt to write to it will cause a Hypervisor
> Emulation Assitance interrupt.
>
> This patch adds the try_set_ptcr(val) macro as an accessor to
> mtspr(SPRN_PTCR, val), which will be executed only if ultravisor
> disabled.
>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h           | 13 +++++++++++++
>  arch/powerpc/mm/book3s64/hash_utils.c    |  4 ++--
>  arch/powerpc/mm/book3s64/pgtable.c       |  2 +-
>  arch/powerpc/mm/book3s64/radix_pgtable.c |  6 +++---
>  4 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 10caa145f98b..14139b1ebdb8 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -15,6 +15,7 @@
>  #include <asm/cputable.h>
>  #include <asm/asm-const.h>
>  #include <asm/feature-fixups.h>
> +#include <asm/firmware.h>

reg.h is already too big and unwieldy.

Can you put this in ultravisor.h and include that in the appropriate places.

> @@ -1452,6 +1453,18 @@ static inline void update_power8_hid0(unsigned long hid0)
>  	 */
>  	asm volatile("sync; mtspr %0,%1; isync":: "i"(SPRN_HID0), "r"(hid0));
>  }
> +
> +/*
> + * In ultravisor enabled systems, PTCR becomes ultravisor privileged only for
> + * writing and an attempt to write to it will cause a Hypervisor Emulation
> + * Assistance interrupt.
> + */
> +#define try_set_ptcr(val)						\
> +	do {								\
> +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))	\
> +			mtspr(SPRN_PTCR, val);				\
> +	} while (0)

This should be a static inline please, not a macro.

Sorry, I don't like the name, we're not trying to set it, we know when
to set it and when not to.

It is awkward to come up with a good name because we don't have a term
for "hypervisor that's not running under an ultravisor".

Maybe set_ptcr_when_no_uv()

Which is kinda messy, someone feel free to come up with something
better.

I also see some more accesses to the PTCR in
arch/powerpc/platforms/powernv/idle.c which you haven't patched?

cheers
