Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106436576E
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jul 2019 14:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfGKM5l (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 11 Jul 2019 08:57:41 -0400
Received: from ozlabs.org ([203.11.71.1]:55225 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfGKM5l (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 11 Jul 2019 08:57:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kx0y2l7Kz9sNk;
        Thu, 11 Jul 2019 22:57:38 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: Re: [PATCH v4 7/8] KVM: PPC: Ultravisor: Enter a secure guest
In-Reply-To: <20190628200825.31049-8-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com> <20190628200825.31049-8-cclaudio@linux.ibm.com>
Date:   Thu, 11 Jul 2019 22:57:37 +1000
Message-ID: <87ftncg24e.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> To enter a secure guest, we have to go through the ultravisor, therefore
> we do a ucall when we are entering a secure guest.
>
> This change is needed for any sort of entry to the secure guest from the
> hypervisor, whether it is a return from an hcall, a return from a
> hypervisor interrupt, or the first time that a secure guest vCPU is run.
>
> If we are returning from an hcall, the results are already in the
> appropriate registers R3:12, except for R3, R6 and R7. R3 has the status
> of the reflected hcall, therefore we move it to R0 for the ultravisor and
> set R3 to the UV_RETURN ucall number. R6,7 were used as temporary
> registers, hence we restore them.

This is another case where some documentation would help people to
review the code.

> Have fast_guest_return check the kvm_arch.secure_guest field so that a
> new CPU enters UV when started (in response to a RTAS start-cpu call).
>
> Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.
>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> [ Pass SRR1 in r11 for UV_RETURN, fix kvmppc_msr_interrupt to preserve
>   the MSR_S bit ]
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> [ Fix UV_RETURN ucall number and arch.secure_guest check ]
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Save the actual R3 in R0 for the ultravisor and use R3 for the
>   UV_RETURN ucall number. Update commit message and ret_to_ultra comment ]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h       |  1 +
>  arch/powerpc/include/asm/ultravisor-api.h |  1 +
>  arch/powerpc/kernel/asm-offsets.c         |  1 +
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 40 +++++++++++++++++++----
>  4 files changed, 37 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index cffb365d9d02..89813ca987c2 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -36,6 +36,7 @@
>  #include <asm/asm-compat.h>
>  #include <asm/feature-fixups.h>
>  #include <asm/cpuidle.h>
> +#include <asm/ultravisor-api.h>
>  
>  /* Sign-extend HDEC if not on POWER9 */
>  #define EXTEND_HDEC(reg)			\
> @@ -1092,16 +1093,12 @@ BEGIN_FTR_SECTION
>  END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>  
>  	ld	r5, VCPU_LR(r4)
> -	ld	r6, VCPU_CR(r4)
>  	mtlr	r5
> -	mtcr	r6
>  
>  	ld	r1, VCPU_GPR(R1)(r4)
>  	ld	r2, VCPU_GPR(R2)(r4)
>  	ld	r3, VCPU_GPR(R3)(r4)
>  	ld	r5, VCPU_GPR(R5)(r4)
> -	ld	r6, VCPU_GPR(R6)(r4)
> -	ld	r7, VCPU_GPR(R7)(r4)
>  	ld	r8, VCPU_GPR(R8)(r4)
>  	ld	r9, VCPU_GPR(R9)(r4)
>  	ld	r10, VCPU_GPR(R10)(r4)
> @@ -1119,10 +1116,38 @@ BEGIN_FTR_SECTION
>  	mtspr	SPRN_HDSISR, r0
>  END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
>  
> +	ld	r6, VCPU_KVM(r4)
> +	lbz	r7, KVM_SECURE_GUEST(r6)
> +	cmpdi	r7, 0

You could hoist the load of r6 and r7 to here?

> +	bne	ret_to_ultra
> +
> +	lwz	r6, VCPU_CR(r4)
> +	mtcr	r6
> +
> +	ld	r7, VCPU_GPR(R7)(r4)
> +	ld	r6, VCPU_GPR(R6)(r4)
>  	ld	r0, VCPU_GPR(R0)(r4)
>  	ld	r4, VCPU_GPR(R4)(r4)
>  	HRFI_TO_GUEST
>  	b	.
> +/*
> + * We are entering a secure guest, so we have to invoke the ultravisor to do
> + * that. If we are returning from a hcall, the results are already in the
> + * appropriate registers R3:12, except for R3, R6 and R7. R3 has the status of
> + * the reflected hcall, therefore we move it to R0 for the ultravisor and set
> + * R3 to the UV_RETURN ucall number. R6,7 were used as temporary registers
> + * above, hence we restore them.
> + */
> +ret_to_ultra:
> +	lwz	r6, VCPU_CR(r4)
> +	mtcr	r6
> +	mfspr	r11, SPRN_SRR1
> +	mr	r0, r3
> +	LOAD_REG_IMMEDIATE(r3, UV_RETURN)

Worth open coding to save three instructions?

> +	ld	r7, VCPU_GPR(R7)(r4)
> +	ld	r6, VCPU_GPR(R6)(r4)
> +	ld	r4, VCPU_GPR(R4)(r4)
> +	sc	2
>  
>  /*
>   * Enter the guest on a P9 or later system where we have exactly
> @@ -3318,13 +3343,16 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
>   *   r0 is used as a scratch register
>   */
>  kvmppc_msr_interrupt:
> +	andis.	r0, r11, MSR_S@h
>  	rldicl	r0, r11, 64 - MSR_TS_S_LG, 62
> -	cmpwi	r0, 2 /* Check if we are in transactional state..  */
> +	cmpwi	cr1, r0, 2 /* Check if we are in transactional state..  */
>  	ld	r11, VCPU_INTR_MSR(r9)
> -	bne	1f
> +	bne	cr1, 1f
>  	/* ... if transactional, change to suspended */
>  	li	r0, 1
>  1:	rldimi	r11, r0, MSR_TS_S_LG, 63 - MSR_TS_T_LG
> +	beqlr
> +	oris	r11, r11, MSR_S@h		/* preserve MSR_S bit setting */
>  	blr

I don't see this part mentioned in the change log?

It's also pretty subtle, a comment might be helpful.

cheers
