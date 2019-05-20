Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D41722C33
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 08:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfETGhu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 May 2019 02:37:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53323 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730782AbfETGhu (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 20 May 2019 02:37:50 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 456q2g20V9z9s9y; Mon, 20 May 2019 16:37:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558334267; bh=KMvPkfmRTz792i4T4gnia0zZY7D8IlGpYuJ3hjuUXsQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tuc+fMdfRe9ei0Q/0+/guTHfXvOu47MbPR5V6VnMHzKXhjHRjx9sUvJbABvl4C2q+
         jhA3znoOvbi6FV3JlF0YE6zpJrPI86KgQeqNxwFLUNocqtt8t5S6k5pGosoEfdENDF
         OvMkF8SKE5MMjjfGFMTvaYSJBin67U52tFJcsb8wIduDc4apI2wfAfMbn59uOdFdzd
         SPjVDYUYH5t/80+IMZ6D6N3SAxnoU0ZY0Ob3e0CYdrKSX86sTGInjf4n0TYAiDjTdc
         E5K5ptQW+1yXN18aJBQ/D4pPtlN/b8Ow89LDbQEL7NQF7wyN/c/HZiBg5JUo7+5018
         hfpAjGIWIuaow==
Date:   Mon, 20 May 2019 15:43:57 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [RFC PATCH v2 07/10] KVM: PPC: Ultravisor: Restrict LDBAR access
Message-ID: <20190520054357.GB21382@blackberry>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
 <20190518142524.28528-8-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518142524.28528-8-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 18, 2019 at 11:25:21AM -0300, Claudio Carvalho wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> When the ultravisor firmware is available, it takes control over the
> LDBAR register. In this case, thread-imc updates and save/restore
> operations on the LDBAR register are handled by ultravisor.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [Restrict LDBAR access in assembly code and some in C, update the commit
>  message]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

Some of the places that you are patching below are explicitly only
executed on POWER8, which can't have an ultravisor, and therefore
the change isn't needed:

> ---
>  arch/powerpc/kvm/book3s_hv.c                 |  4 +-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S      |  2 +
>  arch/powerpc/perf/imc-pmu.c                  | 64 ++++++++++++--------
>  arch/powerpc/platforms/powernv/idle.c        |  6 +-
>  arch/powerpc/platforms/powernv/subcore-asm.S |  4 ++
>  5 files changed, 52 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 0fab0a201027..81f35f955d16 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -75,6 +75,7 @@
>  #include <asm/xics.h>
>  #include <asm/xive.h>
>  #include <asm/hw_breakpoint.h>
> +#include <asm/firmware.h>
>  
>  #include "book3s.h"
>  
> @@ -3117,7 +3118,8 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
>  			subcore_size = MAX_SMT_THREADS / split;
>  			split_info.rpr = mfspr(SPRN_RPR);
>  			split_info.pmmar = mfspr(SPRN_PMMAR);
> -			split_info.ldbar = mfspr(SPRN_LDBAR);
> +			if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +				split_info.ldbar = mfspr(SPRN_LDBAR);

This is inside an if (is_power8) statement.

> diff --git a/arch/powerpc/platforms/powernv/subcore-asm.S b/arch/powerpc/platforms/powernv/subcore-asm.S
> index 39bb24aa8f34..e4383fa5e150 100644
> --- a/arch/powerpc/platforms/powernv/subcore-asm.S
> +++ b/arch/powerpc/platforms/powernv/subcore-asm.S
> @@ -44,7 +44,9 @@ _GLOBAL(split_core_secondary_loop)
>  
>  real_mode:
>  	/* Grab values from unsplit SPRs */
> +BEGIN_FW_FTR_SECTION
>  	mfspr	r6,  SPRN_LDBAR
> +END_FW_FTR_SECTION_IFCLR(FW_FEATURE_ULTRAVISOR)
>  	mfspr	r7,  SPRN_PMMAR
>  	mfspr	r8,  SPRN_PMCR
>  	mfspr	r9,  SPRN_RPR
> @@ -77,7 +79,9 @@ real_mode:
>  	mtspr	SPRN_HDEC, r4
>  
>  	/* Restore SPR values now we are split */
> +BEGIN_FW_FTR_SECTION
>  	mtspr	SPRN_LDBAR, r6
> +END_FW_FTR_SECTION_IFCLR(FW_FEATURE_ULTRAVISOR)

Only POWER8 supports split-core mode, so we can only get here on
POWER8.

Paul.
