Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BE3D5125
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 03:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhGZBK1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 21:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhGZBK1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 21:10:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202ACC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 18:50:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so17563897pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 18:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=TfsUknjrJxS3/K50NAkYQdZi/fyngt6PnwTm6MfOOQw=;
        b=tWW5oM8FgRxlkQ+Qoz4bkxNVkBpxJaUnYVHkWsKfwA4bTHMQ+P+8q8khbYpyt0G/Op
         97SxiG/GF+TQWD3n8z/NVkY9htHqFV3ufCaEqyoWwwJIcYxwqW0ENM01PWQhRGKMHR7+
         glW1SfuAId3JmpR5HLlil73+fE1xUBGpNME0JUamcvxrfs7EPkOeg1IciffyQ8wcGCoV
         XpFH2MLHtF45nbl6T1K9XsdJ7fxT8rE3uy2MhqAKcdmxkxM9gYxDOd5uJfPWSV9KXimR
         JuyVHNocdxgajXtSFafczVXcgCimFVVwJFtJptZN9ayn7bc1mf8eEOC5ckHHcFXpAhSe
         xlfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=TfsUknjrJxS3/K50NAkYQdZi/fyngt6PnwTm6MfOOQw=;
        b=W6zt/w3zjG/riJND6/1vJaid7nnnCWlE3FozdEaOY9dq8KS3Ymv1tfzs4nBPOVCeM3
         rt0A6Jut/UEmd/dulimL9Y39JKwnSCa6dWzoMtjdkamg61Cadi468FcKXL3w7pmYA5eo
         DmIz3trBMS+d74BFQVXihZRodCv0V1xxDD2bMqtdkMMjKiUdne59vybLh+wwjxLlrWg5
         /opzveS7Z4QJXEp9HPNzuRQjk7c4mASgHeik3HY+/jl6gVw0RRslhCVv4hQBvNQd/2oT
         TqkmBpxInsyg2GG3TaKj/xWSrKwQTovdk4fRDvGTzRoZBdAqjhZK4W6PQ+Lq5qOyCM08
         TihQ==
X-Gm-Message-State: AOAM531MKCK2eFhFFYFodve99WxDAqXR4/KEwokG3Y0RAjtr4W1di88U
        a8SlS34rLDDVY36SrCv8R+E=
X-Google-Smtp-Source: ABdhPJzbbjXo/sTEbHh6B9PN3y2Hx3DeAF1uurvBqKACVg6CKfVPOHw6Khdj0tVfLVxGA1u7haliyw==
X-Received: by 2002:a17:90a:6097:: with SMTP id z23mr14672145pji.172.1627264255561;
        Sun, 25 Jul 2021 18:50:55 -0700 (PDT)
Received: from localhost (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id a21sm11868557pjq.2.2021.07.25.18.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 18:50:55 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:50:50 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 1/2] KVM: PPC: Book3S HV: Sanitise vcpu registers in
 nested path
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210722221240.2384655-1-farosas@linux.ibm.com>
        <20210722221240.2384655-2-farosas@linux.ibm.com>
In-Reply-To: <20210722221240.2384655-2-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1627263995.i8pr0asy10.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of July 23, 2021 8:12 am:
> As one of the arguments of the H_ENTER_NESTED hypercall, the nested
> hypervisor (L1) prepares a structure containing the values of various
> hypervisor-privileged registers with which it wants the nested guest
> (L2) to run. Since the nested HV runs in supervisor mode it needs the
> host to write to these registers.
>=20
> To stop a nested HV manipulating this mechanism and using a nested
> guest as a proxy to access a facility that has been made unavailable
> to it, we have a routine that sanitises the values of the HV registers
> before copying them into the nested guest's vcpu struct.
>=20
> However, when coming out of the guest the values are copied as they
> were back into L1 memory, which means that any sanitisation we did
> during guest entry will be exposed to L1 after H_ENTER_NESTED returns.
>=20
> This patch alters this sanitisation to have effect on the vcpu->arch
> registers directly before entering and after exiting the guest,
> leaving the structure that is copied back into L1 unchanged (except
> when we really want L1 to access the value, e.g the Cause bits of
> HFSCR).

These patches look good to me. I ported my demand-faulting patches on=20
top of them and things seem to work okay.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Just one minor nit:

>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_nested.c | 100 +++++++++++++++-------------
>  1 file changed, 52 insertions(+), 48 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 8543ad538b0c..3804dc50ebe8 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -104,8 +104,17 @@ static void save_hv_return_state(struct kvm_vcpu *vc=
pu, int trap,
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
> +	/*
> +	 * When loading the hypervisor-privileged registers to run L2,
> +	 * we might have used bits from L1 state to restrict what the
> +	 * L2 state is allowed to be. Since L1 is not allowed to read
> +	 * the HV registers, do not include these modifications in the
> +	 * return state.
> +	 */
> +	hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
> +		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));

Can you change this to only update HFSCR intr cause field when we take a=20
hfac interrupt? It's possible the L0 can cause other kinds of hfacs=20
behind the back of the L1 with demand faulting, so it would be unusual
for L1 to see the register change if it didn't take an hfac interrupt.

Thanks,
Nick

> +
>  	hr->dpdes =3D vc->dpdes;
> -	hr->hfscr =3D vcpu->arch.hfscr;
>  	hr->purr =3D vcpu->arch.purr;
>  	hr->spurr =3D vcpu->arch.spurr;
>  	hr->ic =3D vcpu->arch.ic;
> @@ -134,49 +143,7 @@ static void save_hv_return_state(struct kvm_vcpu *vc=
pu, int trap,
>  	}
>  }
> =20
> -/*
> - * This can result in some L0 HV register state being leaked to an L1
> - * hypervisor when the hv_guest_state is copied back to the guest after
> - * being modified here.
> - *
> - * There is no known problem with such a leak, and in many cases these
> - * register settings could be derived by the guest by observing behaviou=
r
> - * and timing, interrupts, etc., but it is an issue to consider.
> - */
> -static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_stat=
e *hr)
> -{
> -	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> -	u64 mask;
> -
> -	/*
> -	 * Don't let L1 change LPCR bits for the L2 except these:
> -	 */
> -	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
> -		LPCR_LPES | LPCR_MER;
> -
> -	/*
> -	 * Additional filtering is required depending on hardware
> -	 * and configuration.
> -	 */
> -	hr->lpcr =3D kvmppc_filter_lpcr_hv(vcpu->kvm,
> -			(vc->lpcr & ~mask) | (hr->lpcr & mask));
> -
> -	/*
> -	 * Don't let L1 enable features for L2 which we've disabled for L1,
> -	 * but preserve the interrupt cause field.
> -	 */
> -	hr->hfscr &=3D (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
> -
> -	/* Don't let data address watchpoint match in hypervisor state */
> -	hr->dawrx0 &=3D ~DAWRX_HYP;
> -	hr->dawrx1 &=3D ~DAWRX_HYP;
> -
> -	/* Don't let completed instruction address breakpt match in HV state */
> -	if ((hr->ciabr & CIABR_PRIV) =3D=3D CIABR_PRIV_HYPER)
> -		hr->ciabr &=3D ~CIABR_PRIV;
> -}
> -
> -static void restore_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state=
 *hr)
> +static void restore_hv_regs(struct kvm_vcpu *vcpu, const struct hv_guest=
_state *hr)
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
> @@ -288,6 +255,43 @@ static int kvmhv_write_guest_state_and_regs(struct k=
vm_vcpu *vcpu,
>  				     sizeof(struct pt_regs));
>  }
> =20
> +static void load_l2_hv_regs(struct kvm_vcpu *vcpu,
> +			    const struct hv_guest_state *l2_hv,
> +			    const struct hv_guest_state *l1_hv, u64 *lpcr)
> +{
> +	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> +	u64 mask;
> +
> +	restore_hv_regs(vcpu, l2_hv);
> +
> +	/*
> +	 * Don't let L1 change LPCR bits for the L2 except these:
> +	 */
> +	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
> +		LPCR_LPES | LPCR_MER;
> +
> +	/*
> +	 * Additional filtering is required depending on hardware
> +	 * and configuration.
> +	 */
> +	*lpcr =3D kvmppc_filter_lpcr_hv(vcpu->kvm,
> +				      (vc->lpcr & ~mask) | (*lpcr & mask));
> +
> +	/*
> +	 * Don't let L1 enable features for L2 which we've disabled for L1,
> +	 * but preserve the interrupt cause field.
> +	 */
> +	vcpu->arch.hfscr =3D l2_hv->hfscr & (HFSCR_INTR_CAUSE | l1_hv->hfscr);
> +
> +	/* Don't let data address watchpoint match in hypervisor state */
> +	vcpu->arch.dawrx0 =3D l2_hv->dawrx0 & ~DAWRX_HYP;
> +	vcpu->arch.dawrx1 =3D l2_hv->dawrx1 & ~DAWRX_HYP;
> +
> +	/* Don't let completed instruction address breakpt match in HV state */
> +	if ((l2_hv->ciabr & CIABR_PRIV) =3D=3D CIABR_PRIV_HYPER)
> +		vcpu->arch.ciabr =3D l2_hv->ciabr & ~CIABR_PRIV;
> +}
> +
>  long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  {
>  	long int err, r;
> @@ -296,7 +300,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	struct hv_guest_state l2_hv =3D {0}, saved_l1_hv;
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
>  	u64 hv_ptr, regs_ptr;
> -	u64 hdec_exp;
> +	u64 hdec_exp, lpcr;
>  	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
> =20
>  	if (vcpu->kvm->arch.l1_ptcr =3D=3D 0)
> @@ -349,8 +353,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	/* Guest must always run with ME enabled, HV disabled. */
>  	vcpu->arch.shregs.msr =3D (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
> =20
> -	sanitise_hv_regs(vcpu, &l2_hv);
> -	restore_hv_regs(vcpu, &l2_hv);
> +	lpcr =3D l2_hv.lpcr;
> +	load_l2_hv_regs(vcpu, &l2_hv, &saved_l1_hv, &lpcr);
> =20
>  	vcpu->arch.ret =3D RESUME_GUEST;
>  	vcpu->arch.trap =3D 0;
> @@ -360,7 +364,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  			r =3D RESUME_HOST;
>  			break;
>  		}
> -		r =3D kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
> +		r =3D kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
>  	} while (is_kvmppc_resume_guest(r));
> =20
>  	/* save L2 state for return */
> --=20
> 2.29.2
>=20
>=20
