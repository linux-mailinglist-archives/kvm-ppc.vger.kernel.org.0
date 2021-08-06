Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEED13E2081
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 03:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhHFBQw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Aug 2021 21:16:52 -0400
Received: from ozlabs.org ([203.11.71.1]:55083 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233016AbhHFBQw (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 5 Aug 2021 21:16:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ggnch3SS2z9sT6;
        Fri,  6 Aug 2021 11:16:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1628212596;
        bh=qzBSBCGCdmBE2RDHJZuwYJaVGQV98VMQ96dVPfIdCe0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=j9ZGvITulsrwtJeTKf99DnnkxENKha2tUy+dsuXTw0jODq+1EUMo/CDvzWMTqQGaj
         oIldu4hZ5bdRyNAfEyjwlc0CfHl3e9iFN9eldZtiKxOAV3bxqKqCM60JCLw43Roi67
         8y0Taxy5opecPURcEemWgQ9J+xu+RBVmAxpQuTegqQ87agLPjWqKptlAjNqgH/9/nJ
         FABwqD90N2VDbuDdkkp73PNE1EoeDC4cHCryrdV7EBpy3BZXBEmSbFOLZhgFwfZkcx
         P7uYaeUisY+dUfbmMSuIDuxvgX9w0vWqe+9Glv6u3ope2NW1eiFUVTJiwbnPgLLl+7
         6mGZeFI2kzcFg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v1 02/55] KVM: PPC: Book3S HV P9: Fixes for TM softpatch
 interrupt
In-Reply-To: <20210726035036.739609-3-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
 <20210726035036.739609-3-npiggin@gmail.com>
Date:   Fri, 06 Aug 2021 11:16:32 +1000
Message-ID: <87a6lvnzin.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:
> The softpatch interrupt sets HSRR0 to the faulting instruction +4, so
> it should subtract 4 for the faulting instruction address. Also have it
> emulate and deliver HFAC interrupts correctly, which is important for
> nested HV and facility demand-faulting in future.

The nip being off by 4 sounds bad. But I guess it's not that big a deal
because it's only used for reporting the instruction address?

Would also be good to have some more explanation of why it's OK to
change from illegal to HFAC, which is a guest visible change.

> diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
> index cc90b8b82329..e4fd4a9dee08 100644
> --- a/arch/powerpc/kvm/book3s_hv_tm.c
> +++ b/arch/powerpc/kvm/book3s_hv_tm.c
> @@ -74,19 +74,23 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
>  	case PPC_INST_RFEBB:
>  		if ((msr & MSR_PR) && (vcpu->arch.vcore->pcr & PCR_ARCH_206)) {
>  			/* generate an illegal instruction interrupt */
> +			vcpu->arch.regs.nip -= 4;
>  			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
>  			return RESUME_GUEST;
>  		}
>  		/* check EBB facility is available */
>  		if (!(vcpu->arch.hfscr & HFSCR_EBB)) {
> -			/* generate an illegal instruction interrupt */
> -			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
> -			return RESUME_GUEST;
> +			vcpu->arch.regs.nip -= 4;
> +			vcpu->arch.hfscr &= ~HFSCR_INTR_CAUSE;
> +			vcpu->arch.hfscr |= (u64)FSCR_EBB_LG << 56;
> +			vcpu->arch.trap = BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
> +			return -1; /* rerun host interrupt handler */

This is EBB not TM. Probably OK to leave it in this patch as long as
it's mentioned in the change log?

>  		}
>  		if ((msr & MSR_PR) && !(vcpu->arch.fscr & FSCR_EBB)) {
>  			/* generate a facility unavailable interrupt */
> -			vcpu->arch.fscr = (vcpu->arch.fscr & ~(0xffull << 56)) |
> -				((u64)FSCR_EBB_LG << 56);
> +			vcpu->arch.regs.nip -= 4;
> +			vcpu->arch.fscr &= ~FSCR_INTR_CAUSE;
> +			vcpu->arch.fscr |= (u64)FSCR_EBB_LG << 56;

Same.


cheers
