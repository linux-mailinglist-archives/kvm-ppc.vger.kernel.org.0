Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ECB326AB8
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Feb 2021 01:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhB0AVv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 19:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0AVv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 19:21:51 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A82BC06174A
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 16:21:11 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id g20so6163975plo.2
        for <kvm-ppc@vger.kernel.org>; Fri, 26 Feb 2021 16:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=xcdCvk++FhL5dTYPMVJw74OPQNVdGiysk10DggN/IM4=;
        b=iW4ASJaO6Kz61l6MKrtPG03YZZMzqz9GZkMK30MfMevzi0onxiLMLsDQoOTK3xS7vx
         hauu8OC9G4T1xmXpQLrGvnqiroGPrsQRxuPUGXJkNCKxcOxufupG0VLQKiX9/AZF8Xdt
         3P8oBRrMQkbX/QXG6IFXrudX9rQ31naCrCwbsb+BvCWYfmkhOGubJxisqYMlgzkirUu/
         DlQRIEz7CCtBW1iOmn9Py/0EKgSV7MCxSEsiU0vfiex5txK/PSbra/54qKQpRAqPAnDW
         uXxxFD97TlIiKzi0Tl8wAQNNHZ9XUhaFNly3lvO8PBPnk/80HRxngE22X/c521mvYT5U
         rPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=xcdCvk++FhL5dTYPMVJw74OPQNVdGiysk10DggN/IM4=;
        b=s9q+Nj6nYu3p3RJ58P1U2024cIR29ED9ZICgZXzY12iDj2DdmuCNBivXYCuabDRBbj
         2Bgp8SfqkB0Ek/u7kPvVizSXrsa6majmZHX+5NKghJPU710L984KsglQ8fb9iE1nAZB4
         suOIPMIIxVG5DedQAszU/VVjnekY3ny+oBdouBCoTV5uEFD1mFZaDzuAF8HQszziioM2
         dZsWoj5tYLEu+6UhSPh8nrj+EibLiMqiheRtCdSI6zjpG7h1SxIUAjETRd4khoAcVOGB
         b52HrgNtus/J0ZiK7jOHkLr/XyxQxPe0+eNoKfAsfYXFKEdedl2MAq08+ZUgghM6sYDV
         eTEg==
X-Gm-Message-State: AOAM531PMPdRR8YWUJriDYSiEVef/Sn/xSzPX9f9zHPHf8xcf5eBfFL4
        /eSD+B7dspQ9kwg6xwRPjVw=
X-Google-Smtp-Source: ABdhPJwTWBJEocEys2GJoa10jK/ynZ506b1WZDj7SiDXmLGmdaPwY56/ktwAzNOImlVLTfPmBN3+5Q==
X-Received: by 2002:a17:902:f781:b029:e4:419b:e891 with SMTP id q1-20020a170902f781b02900e4419be891mr5382178pln.10.1614385270436;
        Fri, 26 Feb 2021 16:21:10 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id w3sm9769033pjt.24.2021.02.26.16.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:21:09 -0800 (PST)
Date:   Sat, 27 Feb 2021 10:21:04 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 23/37] KVM: PPC: Book3S HV P9: Implement the rest of
 the P9 path in C
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210225134652.2127648-1-npiggin@gmail.com>
        <20210225134652.2127648-24-npiggin@gmail.com> <87y2fawj4n.fsf@linux.ibm.com>
In-Reply-To: <87y2fawj4n.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1614384320.mv2klmakck.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of February 27, 2021 8:37 am:
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
> Hi, thanks for this. It helped me clarify a bunch of details that I
> haven't understood while reading the asm code.

Yes, me too :)

>> +/*
>> + * void kvmppc_p9_enter_guest(struct vcpu *vcpu);
>> + *
>> + * Enter the guest on a ISAv3.0 or later system where we have exactly
>> + * one vcpu per vcore, and both the host and guest are radix, and threa=
ds
>> + * are set to "indepdent mode".
>> + */
>> +.balign	IFETCH_ALIGN_BYTES
>> +_GLOBAL(kvmppc_p9_enter_guest)
>> +EXPORT_SYMBOL_GPL(kvmppc_p9_enter_guest)
>> +	mflr	r0
>> +	std	r0,PPC_LR_STKOFF(r1)
>> +	stdu	r1,-SFS(r1)
>> +
>> +	std	r1,HSTATE_HOST_R1(r13)
>> +	std	r3,STACK_SLOT_VCPU(r1)
>=20
> The vcpu was stored on the paca previously. I don't get the change,
> could you explain?

The stack is a nicer place to keep things. We only need one place to=20
save the stack, then most things can come from there. There's actually=20
more paca stuff we could move into local variables or onto the stack
too.

It was probably done like this because PR KVM which probably can't=20
access the stack in real mode when running in an LPAR, and came across=20
to the HV code that way. New path doesn't require it.

>> +kvmppc_p9_exit_interrupt:
>> +	std     r1,HSTATE_SCRATCH1(r13)
>> +	std     r3,HSTATE_SCRATCH2(r13)
>> +	ld	r1,HSTATE_HOST_R1(r13)
>> +	ld	r3,STACK_SLOT_VCPU(r1)
>> +
>> +	std	r9,VCPU_CR(r3)
>> +
>> +1:
>> +	std	r11,VCPU_PC(r3)
>> +	std	r12,VCPU_MSR(r3)
>> +
>> +	reg =3D 14
>> +	.rept	18
>> +	std	reg,__VCPU_GPR(reg)(r3)
>> +	reg =3D reg + 1
>> +	.endr
>> +
>> +	/* r1, r3, r9-r13 are saved to vcpu by C code */
>=20
> If we just saved r1 and r3, why don't we put them in the vcpu right now?
> That would avoid having the C code knowing about scratch areas.

Putting it in C avoids having the asm code know about scratch areas.

>> @@ -4429,11 +4432,19 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *v=
cpu)
>>  		else
>>  			r =3D kvmppc_run_vcpu(vcpu);
>>
>> -		if (run->exit_reason =3D=3D KVM_EXIT_PAPR_HCALL &&
>> -		    !(vcpu->arch.shregs.msr & MSR_PR)) {
>> -			trace_kvm_hcall_enter(vcpu);
>> -			r =3D kvmppc_pseries_do_hcall(vcpu);
>> -			trace_kvm_hcall_exit(vcpu, r);
>> +		if (run->exit_reason =3D=3D KVM_EXIT_PAPR_HCALL) {
>> +			if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
>> +				/*
>> +				 * Guest userspace executed sc 1, reflect it
>> +				 * back as a privileged program check interrupt.
>> +				 */
>> +				kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
>> +				r =3D RESUME_GUEST;
>=20
> This is in conflict with this snippet in kvmppc_handle_exit_hv:
>=20
> 	case BOOK3S_INTERRUPT_SYSCALL:
> 	{
> 		/* hcall - punt to userspace */
> 		int i;
>=20
> 		/* hypercall with MSR_PR has already been handled in rmode,
> 		 * and never reaches here.
> 		 */
>=20
> That function already queues some 0x700s so maybe we could move this one
> in there as well.

I don't think it conflicts, but I think perhaps it should go in the=20
patch which removed the real mode handlers.

kvmppc_handle_exit_hv is used by both HV paths so for now it's a bit=20
neater to try get things into the same state, but we could do this in a=20
later patch perhaps.

>> +	 *
>> +	 * To work around this we put a canary value into the HDSISR before
>> +	 * returning to a guest and then check for this canary when we take a
>> +	 * HDSI. If we find the canary on a HDSI, we know the hardware didn't
>> +	 * update the HDSISR. In this case we return to the guest to retake th=
e
>> +	 * HDSI which should correctly update the HDSISR the second time HDSI
>> +	 * entry.
>> +	 *
>> +	 * Just do this on all p9 processors for now.
>> +	 */
>> +	mtspr(SPRN_HDSISR, HDSISR_CANARY);
>> +
>> +	accumulate_time(vcpu, &vcpu->arch.guest_time);
>> +
>> +	local_paca->kvm_hstate.in_guest =3D KVM_GUEST_MODE_GUEST_HV_FAST;
>> +	kvmppc_p9_enter_guest(vcpu);
>> +	// Radix host and guest means host never runs with guest MMU state
>> +	local_paca->kvm_hstate.in_guest =3D KVM_GUEST_MODE_NONE;
>> +
>> +	accumulate_time(vcpu, &vcpu->arch.rm_intr);
>> +
>> +	/* Get these from r11/12 and paca exsave */
>> +	vcpu->arch.shregs.srr0 =3D mfspr(SPRN_SRR0);
>> +	vcpu->arch.shregs.srr1 =3D mfspr(SPRN_SRR1);
>> +	vcpu->arch.shregs.dar =3D mfspr(SPRN_DAR);
>> +	vcpu->arch.shregs.dsisr =3D mfspr(SPRN_DSISR);
>> +
>> +	trap =3D local_paca->kvm_hstate.scratch0 & ~0x2;
>=20
> Couldn't we return the trap from kvmppc_p9_enter_guest? Seems like a
> nice pattern to have and avoids exposing the IVEC+0x2 magic which is hidd=
en
> in asm already.

I use the 0x2 test in C in a later patch.

The IVEC+0x2 thing might just go away entirely though for new HV path,=20
but we'd still clear it in C on the principle of minimal asm code.

>> +	radix_clear_slb();
>> +
>> +	__mtmsrd(msr, 0);
>=20
> Isn't this the same as mtmsr(msr) ?

Yes. For 64s you can use the __ variant though. We use it in other=20
places in this function with L=3D1 so it doesn't make sense to mix=20
variants.

Thanks,
Nick

>=20
>> +
>> +	accumulate_time(vcpu, &vcpu->arch.rm_exit);
>> +
>> +	end_timing(vcpu);
>> +
>> +	return trap;
>> +}
>> +EXPORT_SYMBOL_GPL(__kvmhv_vcpu_entry_p9);
>=20
> <snip>
>=20
