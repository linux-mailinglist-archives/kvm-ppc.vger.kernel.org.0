Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB29479CC
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 07:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfFQF7A (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 01:59:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46727 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfFQF7A (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 01:59:00 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S0ry5D4rz9sBr; Mon, 17 Jun 2019 15:58:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560751138; bh=MTn8Fk5Ee6RLR0PcDL0tMLQdFauOW+ufxDuTrpgLloE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rwi2o8+fWbKy1LYJ0oC9Ei6b0UAYrr11QMJKzAvCEHBxwVDA+WAZ+cgT2QMic1ZUR
         +ZzttTzqFPtjMWEQ9EEkF9kdx4c2KdqJj4grMBxiq8koWDxtq+4HxsjXanlT8mSy8d
         LHjmToCzFYibNHENJqCbTa+zsmEfAir+q5pXYQtmQcfybMTeCIK8M2vnqg+fENId9L
         J87QiDsjKyoNc+74W0t4iBEtoHXE/eLPO8QYvKvufYf6M4VavM3TdWWF6DyZvvJdM6
         NoVhmfsIeaQGxora/YAdXku2NSeFKKvFaXDNuU7QAr+GTp2Hta3KIeinK74yPYC7QX
         gvt7FeASaeGJA==
Date:   Mon, 17 Jun 2019 15:58:56 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: PPC: Book3S: Define and use SRR1_MSR_BITS
Message-ID: <20190617055856.n3cuxtoizpwdwyca@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-1-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:55AM +1000, Nicholas Piggin wrote:
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/include/asm/reg.h      | 12 ++++++++++++
>  arch/powerpc/kvm/book3s.c           |  2 +-
>  arch/powerpc/kvm/book3s_hv_nested.c |  2 +-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 10caa145f98b..a79fc04acebc 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -742,6 +742,18 @@
>  #define SPRN_USPRG7	0x107	/* SPRG7 userspace read */
>  #define SPRN_SRR0	0x01A	/* Save/Restore Register 0 */
>  #define SPRN_SRR1	0x01B	/* Save/Restore Register 1 */
> +
> +#ifdef CONFIG_PPC_BOOK3S
> +/*
> + * Bits loaded from MSR upon interrupt.
> + * PPC (64-bit) bits 33-36,42-47 are interrupt dependent, the others are
> + * loaded from MSR. The exception is that SRESET and MCE do not always load
> + * bit 62 (RI) from MSR. Don't use PPC_BITMASK for this because 32-bit uses
> + * it.
> + */
> +#define   SRR1_MSR_BITS		(~0x783f0000UL)
> +#endif
> +
>  #define   SRR1_ISI_NOPT		0x40000000 /* ISI: Not found in hash */
>  #define   SRR1_ISI_N_OR_G	0x10000000 /* ISI: Access is no-exec or G */
>  #define   SRR1_ISI_PROT		0x08000000 /* ISI: Other protection fault */
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 61a212d0daf0..d59b9f666efb 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -139,7 +139,7 @@ void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
>  {
>  	kvmppc_unfixup_split_real(vcpu);
>  	kvmppc_set_srr0(vcpu, kvmppc_get_pc(vcpu));
> -	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & ~0x783f0000ul) | flags);
> +	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & SRR1_MSR_BITS) | flags);
>  	kvmppc_set_pc(vcpu, kvmppc_interrupt_offset(vcpu) + vec);
>  	vcpu->arch.mmu.reset_msr(vcpu);
>  }
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index 735e0ac6f5b2..8190cbbf4218 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -1186,7 +1186,7 @@ static int kvmhv_translate_addr_nested(struct kvm_vcpu *vcpu,
>  forward_to_l1:
>  	vcpu->arch.fault_dsisr = flags;
>  	if (vcpu->arch.trap == BOOK3S_INTERRUPT_H_INST_STORAGE) {
> -		vcpu->arch.shregs.msr &= ~0x783f0000ul;
> +		vcpu->arch.shregs.msr &= SRR1_MSR_BITS;
>  		vcpu->arch.shregs.msr |= flags;
>  	}
>  	return RESUME_HOST;
> -- 
> 2.20.1

Acked-by: Paul Mackerras <paulus@ozlabs.org>
