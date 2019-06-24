Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A63850A15
	for <lists+kvm-ppc@lfdr.de>; Mon, 24 Jun 2019 13:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfFXLsQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 Jun 2019 07:48:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42915 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729365AbfFXLsQ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 24 Jun 2019 07:48:16 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45XSGh6ycXz9s6w;
        Mon, 24 Jun 2019 21:48:12 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Michael Neuling <mikey@neuling.org>
Cc:     linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        paulus@ozlabs.org, kvm-ppc@vger.kernel.org,
        sjitindarsingh@gmail.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation
In-Reply-To: <20190620060040.26945-1-mikey@neuling.org>
References: <20190620060040.26945-1-mikey@neuling.org>
Date:   Mon, 24 Jun 2019 21:48:12 +1000
Message-ID: <87tvcf8arn.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Michael Neuling <mikey@neuling.org> writes:
> When emulating tsr, treclaim and trechkpt, we incorrectly set CR0. The
> code currently sets:
>     CR0 <- 00 || MSR[TS]
> but according to the ISA it should be:
>     CR0 <-  0 || MSR[TS] || 0

Seems bad, what's the worst case impact?

Do we have a test case for this?

> This fixes the bit shift to put the bits in the correct location.

Fixes: ?

cheers

> diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
> index 888e2609e3..31cd0f327c 100644
> --- a/arch/powerpc/kvm/book3s_hv_tm.c
> +++ b/arch/powerpc/kvm/book3s_hv_tm.c
> @@ -131,7 +131,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>  		}
>  		/* Set CR0 to indicate previous transactional state */
>  		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
> -			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
> +			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
>  		/* L=1 => tresume, L=0 => tsuspend */
>  		if (instr & (1 << 21)) {
>  			if (MSR_TM_SUSPENDED(msr))
> @@ -175,7 +175,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>  
>  		/* Set CR0 to indicate previous transactional state */
>  		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
> -			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
> +			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
>  		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
>  		return RESUME_GUEST;
>  
> @@ -205,7 +205,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>  
>  		/* Set CR0 to indicate previous transactional state */
>  		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
> -			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
> +			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
>  		vcpu->arch.shregs.msr = msr | MSR_TS_S;
>  		return RESUME_GUEST;
>  	}
> -- 
> 2.21.0
