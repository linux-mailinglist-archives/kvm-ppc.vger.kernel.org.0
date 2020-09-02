Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2025A576
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Sep 2020 08:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIBGSk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Sep 2020 02:18:40 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50023 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIBGSg (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 2 Sep 2020 02:18:36 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4BhDK65dhWz9sSJ; Wed,  2 Sep 2020 16:18:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1599027514; bh=92OiPKNwGzvI92aBDZKrl9ja+G+TFCy0aCOwfiebq1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sOvM+oWr+E6AxOGH5S4kSqMjRLhG/3AI5+MldMl6wLi+xcjohCQcgq2Z+WqW+MCFa
         lmm6FGnVUUkf3tmf3QO0UgdQmyRpIMsGNktzV23GQXwB74q9s6gCYU705hmpqXXwej
         Z9JMtLx4LCGbJCVIKKvXMaIdaPasq1oDGu8ED/xf+fpRKsikvk+iqwPB3gCaRz4qNr
         aM9ja/ABQMowYWaZcvLWAWr1Tyj0IhdOPeWS1wR9xP68KhU+lNOogCKNvt3klGE2nT
         qOzHv2qg2+p0YOkrSZOJTdfCISwkU/jhy4W20DwLVGO+qhc54P7BwywCnvb7n4XGU/
         C4g6F4gsHXpQA==
Date:   Wed, 2 Sep 2020 16:13:18 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] KVM: PPC: Use the ppc_inst type
Message-ID: <20200902061318.GE272502@thinks.paulus.ozlabs.org>
References: <20200820033922.32311-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820033922.32311-1-jniethe5@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 20, 2020 at 01:39:21PM +1000, Jordan Niethe wrote:
> The ppc_inst type was added to help cope with the addition of prefixed
> instructions to the ISA. Convert KVM to use this new type for dealing
> wiht instructions. For now do not try to add further support for
> prefixed instructions.

This change does seem to splatter itself across a lot of code that
mostly or exclusively runs on machines which are not POWER10 and will
never need to handle prefixed instructions, unfortunately.  I wonder
if there is a less invasive way to approach this.

In particular we are inflicting this 64-bit struct on 32-bit platforms
unnecessarily (I assume, correct me if I am wrong here).

How would it be to do something like:

typedef unsigned long ppc_inst_t;

so it is 32 bits on 32-bit platforms and 64 bits on 64-bit platforms,
and then use that instead of 'struct ppc_inst'?  You would still need
to change the function declarations but I think most of the function
bodies would not need to be changed.  In particular you would avoid a
lot of the churn related to having to add ppc_inst_val() and suchlike.

> -static inline unsigned make_dsisr(unsigned instr)
> +static inline unsigned make_dsisr(struct ppc_inst instr)
>  {
>  	unsigned dsisr;
> +	u32 word = ppc_inst_val(instr);
>  
>  
>  	/* bits  6:15 --> 22:31 */
> -	dsisr = (instr & 0x03ff0000) >> 16;
> +	dsisr = (word & 0x03ff0000) >> 16;
>  
>  	if (IS_XFORM(instr)) {
>  		/* bits 29:30 --> 15:16 */
> -		dsisr |= (instr & 0x00000006) << 14;
> +		dsisr |= (word & 0x00000006) << 14;
>  		/* bit     25 -->    17 */
> -		dsisr |= (instr & 0x00000040) << 8;
> +		dsisr |= (word & 0x00000040) << 8;
>  		/* bits 21:24 --> 18:21 */
> -		dsisr |= (instr & 0x00000780) << 3;
> +		dsisr |= (word & 0x00000780) << 3;
>  	} else {
>  		/* bit      5 -->    17 */
> -		dsisr |= (instr & 0x04000000) >> 12;
> +		dsisr |= (word & 0x04000000) >> 12;
>  		/* bits  1: 4 --> 18:21 */
> -		dsisr |= (instr & 0x78000000) >> 17;
> +		dsisr |= (word & 0x78000000) >> 17;
>  		/* bits 30:31 --> 12:13 */
>  		if (IS_DSFORM(instr))
> -			dsisr |= (instr & 0x00000003) << 18;
> +			dsisr |= (word & 0x00000003) << 18;

Here I would have done something like:

> -static inline unsigned make_dsisr(unsigned instr)
> +static inline unsigned make_dsisr(struct ppc_inst pi)
>  {
>  	unsigned dsisr;
> +	u32 instr = ppc_inst_val(pi);

and left the rest of the function unchanged.

At first I wondered why we still had that function, since IBM Power
CPUs have not set DSISR on an alignment interrupt since POWER3 days.
It turns out it this function is used by PR KVM when it is emulating
one of the old 32-bit PowerPC CPUs (601, 603, 604, 750, 7450 etc.).

> diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c

Despite the file name, this code is not used on IBM Power servers.
It is for platforms which run under an ePAPR (not server PAPR)
hypervisor (which would be a KVM variant, but generally book E KVM not
book 3S).

Paul.
