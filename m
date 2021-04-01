Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72207350E82
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 07:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhDAFmL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 01:42:11 -0400
Received: from ozlabs.org ([203.11.71.1]:42683 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhDAFlt (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 1 Apr 2021 01:41:49 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9sWH4tD8z9sWw; Thu,  1 Apr 2021 16:41:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617255707; bh=xpTr47Oj6tjUKhlk4O/qkZsmcdxnvdw69ZAkj/Dtjok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FOAfm1gxfn7uTLaiR9b6w36/PEwtILKm5qD5AV+3i35zLdWZtL9gnJlxmMNrH9Nqn
         rtMkLBiGdqONptXyG+WTu8vUkqcxkNQjHxHKHQdbc1oOZjiZEKfAa3TAyfnNDRV8HH
         Fe4hfs6yRAPsvoL5xACeeKf2k+mVjVj4YeHp2hb7PTj+93JgylV3qjQhF0guCSo5dL
         kh0ccP6q77DQbF1Sc960u8MGUq2rou5lF4m8bOLDupcMWR15lZRIAsiWaAdplnFkz5
         8pizOEwN1pA1lZfhMqZ+xj7PVIVmQYHewVLgLY5oGRAIK/QsX/44rYflE4X/BFt6jo
         mnSoIWRcmg9mw==
Date:   Thu, 1 Apr 2021 16:32:50 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v4 13/46] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test
 into KVM
Message-ID: <YGVbApPydgwAU8cP@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-14-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-14-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:32AM +1000, Nicholas Piggin wrote:
> Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
> internal detail that has no real need to be in common handlers.
> 
> Also add a comment explaining why this thing exists.

[snip]

> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index 7a039ea78f15..a5412e24cc05 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  #include <asm/asm-offsets.h>
>  #include <asm/cache.h>
> +#include <asm/exception-64s.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_book3s_asm.h>
>  #include <asm/ppc_asm.h>
> @@ -20,9 +21,12 @@ kvmppc_interrupt:
>  	 * guest R12 saved in shadow VCPU SCRATCH0
>  	 * guest R13 saved in SPRN_SCRATCH0
>  	 */
> -#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>  	std	r9,HSTATE_SCRATCH2(r13)
>  	lbz	r9,HSTATE_IN_GUEST(r13)
> +	cmpwi	r9,KVM_GUEST_MODE_SKIP
> +	beq-	.Lmaybe_skip
> +.Lno_skip:
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>  	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
>  	beq	kvmppc_bad_host_intr
>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> @@ -34,3 +38,48 @@ kvmppc_interrupt:
>  #else
>  	b	kvmppc_interrupt_pr
>  #endif

It's a bit hard to see without more context, but I think that in the
PR-only case (CONFIG_KVM_BOOK3S_HV_POSSIBLE undefined), this will
corrupt R9.  You need to restore R9 before the unconditional branch to
kvmppc_interrupt_pr.  (I realize this code gets modified further, but
I'd rather not break bisection.)

Paul.
