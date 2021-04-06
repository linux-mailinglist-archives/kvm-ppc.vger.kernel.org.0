Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F25354DCF
	for <lists+kvm-ppc@lfdr.de>; Tue,  6 Apr 2021 09:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhDFH1Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 6 Apr 2021 03:27:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52569 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhDFH1Q (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 6 Apr 2021 03:27:16 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4FDzcX1Xv7z9sWQ; Tue,  6 Apr 2021 17:27:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617694028; bh=h5LepvJnn7BEH3+87DFMhDXLJgEPhf5h9r22uEAaw5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CpFe2fFTxN7MslsmU1NXt7fFhhhqdgupgch6IumirQIx0pgckvAyDmkbqbeE4Tv/Z
         4MnYs33gpLyYDsS1BVBj73KCCJaLugNIdi9kur5YYe2Rf+MUXSWX7XQ8S6X8CDqb82
         5ndZNLTgy+1gqPa/fRIrjiYO8PZVM50PkLRSF/mGIsVA3Ai4ZG7L8f9ShJMe+wT2KK
         GuUllJpCM/SH9e82e2/Hqv1dtD1e8p5Q5v+7llZbnANF4eodQ2SlLugp8324fg0UAD
         em+Nya8djCzNUj48JMjm5Zi7TooySTfLDA63vb98inS4MFu/OADS0Y+oo9DNGGvleo
         bb1raavSjgxrw==
Date:   Tue, 6 Apr 2021 17:27:01 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 30/48] KVM: PPC: Book3S HV P9: Implement the rest of
 the P9 path in C
Message-ID: <YGwNRUahuv42VZPR@thinks.paulus.ozlabs.org>
References: <20210405011948.675354-1-npiggin@gmail.com>
 <20210405011948.675354-31-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405011948.675354-31-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Apr 05, 2021 at 11:19:30AM +1000, Nicholas Piggin wrote:
> Almost all logic is moved to C, by introducing a new in_guest mode for
> the P9 path that branches very early in the KVM interrupt handler to
> P9 exit code.
> 
> The main P9 entry and exit assembly is now only about 160 lines of low
> level stack setup and register save/restore, plus a bad-interrupt
> handler.
> 
> There are two motivations for this, the first is just make the code more
> maintainable being in C. The second is to reduce the amount of code
> running in a special KVM mode, "realmode". In quotes because with radix
> it is no longer necessarily real-mode in the MMU, but it still has to be
> treated specially because it may be in real-mode, and has various
> important registers like PID, DEC, TB, etc set to guest. This is hostile
> to the rest of Linux and can't use arbitrary kernel functionality or be
> instrumented well.
> 
> This initial patch is a reasonably faithful conversion of the asm code,
> but it does lack any loop to return quickly back into the guest without
> switching out of realmode in the case of unimportant or easily handled
> interrupts. As explained in previous changes, handling HV interrupts
> in real mode is not so important for P9.
> 
> Use of Linux 64s interrupt entry code register conventions including
> paca EX_ save areas are brought into the KVM code. There is no point
> shuffling things into different paca save areas and making up a
> different calling convention for KVM.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

[snip]

> +/*
> + * Took an interrupt somewhere right before HRFID to guest, so registers are
> + * in a bad way. Return things hopefully enough to run host virtual code and
> + * run the Linux interrupt handler (SRESET or MCE) to print something useful.
> + *
> + * We could be really clever and save all host registers in known locations
> + * before setting HSTATE_IN_GUEST, then restoring them all here, and setting
> + * return address to a fixup that sets them up again. But that's a lot of
> + * effort for a small bit of code. Lots of other things to do first.
> + */
> +kvmppc_p9_bad_interrupt:
> +	/*
> +	 * Set GUEST_MODE_NONE so the handler won't branch to KVM, and clear
> +	 * MSR_RI in r12 ([H]SRR1) so the handler won't try to return.
> +	 */
> +	li	r10,KVM_GUEST_MODE_NONE
> +	stb	r10,HSTATE_IN_GUEST(r13)
> +	li	r10,MSR_RI
> +	andc	r12,r12,r10
> +
> +	/*
> +	 * Clean up guest registers to give host a chance to run.
> +	 */
> +	li	r10,0
> +	mtspr	SPRN_AMR,r10
> +	mtspr	SPRN_IAMR,r10
> +	mtspr	SPRN_CIABR,r10
> +	mtspr	SPRN_DAWRX0,r10
> +BEGIN_FTR_SECTION
> +	mtspr	SPRN_DAWRX1,r10
> +END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
> +	mtspr	SPRN_PID,r10
> +
> +	/*
> +	 * Switch to host MMU mode
> +	 */
> +	ld	r10, HSTATE_KVM_VCPU(r13)
> +	ld	r10, VCPU_KVM(r10)
> +	lwz	r10, KVM_HOST_LPID(r10)
> +	mtspr	SPRN_LPID,r10
> +
> +	ld	r10, HSTATE_KVM_VCPU(r13)
> +	ld	r10, VCPU_KVM(r10)
> +	ld	r10, KVM_HOST_LPCR(r10)
> +	mtspr	SPRN_LPCR,r10
> +
> +	/*
> +	 * Go back to interrupt handler
> +	 */
> +	ld	r10,HSTATE_SCRATCH0(r13)
> +	cmpwi	r10,BOOK3S_INTERRUPT_MACHINE_CHECK
> +	beq	machine_check_common
> +
> +	ld	r10,HSTATE_SCRATCH0(r13)
> +	cmpwi	r10,BOOK3S_INTERRUPT_SYSTEM_RESET
> +	beq	system_reset_common
> +
> +	b	.

So you only handle machine check and system reset here?  I would think
that program check would also be useful, for the cases where people
put BUG_ON in sensitive places (see below).  DSI and ISI could also be
useful for the null pointer dereference cases, I would think.

> +static inline void mtslb(unsigned int idx, u64 slbee, u64 slbev)
> +{
> +	BUG_ON((slbee & 0xfff) != idx);
> +
> +	asm volatile("slbmte %0,%1" :: "r" (slbev), "r" (slbee));
> +}

Using BUG_ON here feels dangerous, and the condition it is testing is
certainly not one where the host kernel is in such trouble that it
can't continue to run.  If the index was wrong then at worst the guest
kernel would be in trouble.  So I don't believe BUG_ON is appropriate.

> +
> +/*
> + * Malicious or buggy radix guests may have inserted SLB entries
> + * (only 0..3 because radix always runs with UPRT=1), so these must
> + * be cleared here to avoid side-channels. slbmte is used rather
> + * than slbia, as it won't clear cached translations.
> + */
> +static void radix_clear_slb(void)
> +{
> +	u64 slbee, slbev;
> +	int i;
> +
> +	for (i = 0; i < 4; i++) {
> +		mfslb(i, &slbee, &slbev);
> +		if (unlikely(slbee || slbev)) {
> +			slbee = i;
> +			slbev = 0;
> +			mtslb(i, slbee, slbev);
> +		}
> +	}

Are four slbmfee + slbmfev really faster than four slbmte?

Paul.
