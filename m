Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40B91B073
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 May 2019 08:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfEMGmN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 May 2019 02:42:13 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53789 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfEMGmM (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 13 May 2019 02:42:12 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 452WSy2tP5z9s4Y; Mon, 13 May 2019 16:42:10 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1557729730; bh=bfjxecMrdmX4OfnJ3FpAf871ZQ2GIHJ1hAkeFqBk1YI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WL8j2isZzN21WNnf6psha+YqfAlDb9btXeL3ZX/QhF50KzvyC84Y5xGTE4GlMumC/
         bVyZRfSqyYfncHBMRU15MxWuzdG3ku92gGIIXFEyMLmWeR37u8Icq/000C3E3FI3DN
         n4hNuZcbr0lC74gdqqFfON+N5H/YgkeD1VYkPYjgxXspNYtVBXvLmEiqgAnLf3XiFd
         oBC5R5m5PpM5+WcjT0F/SgTkJ50TvtvaA+EsHPZaqtg6pYL/FaB2AxO1TSBXbsTQUn
         UfJjVKHPcwfpRHnkvACt1zx3bWeuu1NEuyveUaeubY9qvLmedTGBhRnhe0KewLKN1m
         FelH6kV6zkr8Q==
Date:   Mon, 13 May 2019 16:42:07 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        "Gautham R . Shenoy" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH v10 2/2] powerpc/64s: KVM update for reimplement book3s
 idle code in C
Message-ID: <20190513064207.GA11679@blackberry>
References: <20190428114515.32683-1-npiggin@gmail.com>
 <20190428114515.32683-3-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428114515.32683-3-npiggin@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, Apr 28, 2019 at 09:45:15PM +1000, Nicholas Piggin wrote:
> This is the KVM update to the new idle code. A few improvements:
> 
> - Idle sleepers now always return to caller rather than branch out
>   to KVM first.
> - This allows optimisations like very fast return to caller when no
>   state has been lost.
> - KVM no longer requires nap_state_lost because it controls NVGPR
>   save/restore itself on the way in and out.
> - The heavy idle wakeup KVM request check can be moved out of the
>   normal host idle code and into the not-performance-critical offline
>   code.
> - KVM nap code now returns from where it is called, which makes the
>   flow a bit easier to follow.

One question below...

> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 58d0f1ba845d..f66191d8f841 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
...
> @@ -2656,6 +2662,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
>  
>  	lis	r3, LPCR_PECEDP@h	/* Do wake on privileged doorbell */
>  
> +	/* Go back to host stack */
> +	ld	r1, HSTATE_HOST_R1(r13)

At this point we are in kvmppc_h_cede, which we branched to from
hcall_try_real_mode, which came from the guest exit path, where we
have already loaded r1 from HSTATE_HOST_R1(r13).  So if there is a
path to get here with r1 not already set to HSTATE_HOST_R1(r13), then
I missed it - please point it out to me.  Otherwise this statement
seems superfluous.

Paul.
