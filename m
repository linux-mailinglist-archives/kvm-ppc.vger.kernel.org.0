Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8666D330949
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Mar 2021 09:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhCHIT0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 03:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhCHISy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 03:18:54 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC60C06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Mar 2021 00:18:54 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y13so3219628pfr.0
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Mar 2021 00:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=JC37DVM9PCdz/YFBGXJtwW8UIdwimnHNe9wlQ2DvyW0=;
        b=AMs3yswN7ZkKNd/rLfyFXJ7ipr4EQmBikwqH/WOMKxGNtM28jkElYmdYUa/yMwpMe9
         r/HueUPEZhdknJzT/O2jBBjPILchAAeftvmZ2x8Z5s8E1af3shT48hx94GnmO9DHS+4E
         cr/X+ZGHfuuOQWS748eJH+0IIuedzcT7dvvG+48RqCK4ovqBVcaT56X0Ipwd1DdL96W0
         qJhscKb//LBYCJfxcwgfGPKyERaeCPraMuvYTMRSSsLduK7xsu8FzTMlAqJm9vSW/WNp
         bQ89VFSHDYW3gWv5Spg3Svc9zDpJm+mSCT1w5gRjjByPp2Vjta0iojKF9wofTCOSVYY5
         bHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=JC37DVM9PCdz/YFBGXJtwW8UIdwimnHNe9wlQ2DvyW0=;
        b=C7p+eneGddY+bZi5zn+/XptvHsrvnh41qwzcmaokY1p6oBFuuN+naPGNiXguZxwfmp
         gtaQYZ8GFzrc+jHED5IzO8qWpxK7VYEAy4+N89BCgcXlynZEEKYti6nxYSUuw+4bvVSn
         QeQDoMbMGMkUqju/XjSa+iniPlDkwu5mo/cnU8bmm/b9IfN+dE6wp+JDd1VK2iCA+Ik1
         LGt3B7k+UmwUfilLJfr4TxsuM7sLN0/rgoowEkGF3eLovVhceavTYXZd2VNgCeKTUYzt
         JE5BC/miwGmTu36KaCbuJqTdVtGCZjHtWjXu6DcZFGyVQ6b9tna79GzqvXh9SFZCLJR+
         J30g==
X-Gm-Message-State: AOAM531X6CACQXFx2L7zLHaBpHUd2mLCRE80vpwVQPISU86Gd1z3yqyB
        7jKeLDv9FlCtU6GbqN9iIoyZaHr186s=
X-Google-Smtp-Source: ABdhPJzcptp3EU27cdYTDp47QCqYW/bW09IpJz/CEmJcICpxUL3IrMNRD71lV7a96fqLuoRc1K5bDA==
X-Received: by 2002:a63:f311:: with SMTP id l17mr19846276pgh.349.1615191534264;
        Mon, 08 Mar 2021 00:18:54 -0800 (PST)
Received: from localhost (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m10sm9563360pjn.33.2021.03.08.00.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 00:18:53 -0800 (PST)
Date:   Mon, 08 Mar 2021 18:18:47 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Do not expose HFSCR sanitisation to
 nested hypervisor
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210305231055.2913892-1-farosas@linux.ibm.com>
In-Reply-To: <20210305231055.2913892-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1615191200.1pjltfhe7o.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of March 6, 2021 9:10 am:
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
> This is not a problem by itself, but in the case of the Hypervisor
> Facility Status and Control Register (HFSCR), we use the intersection
> between L2 hfscr bits and L1 hfscr bits. That means that L1 could use
> this to indirectly read the (hv-privileged) value from its vcpu
> struct.
>=20
> This patch fixes this by making sure that L1 only gets back the bits
> that are necessary for regular functioning.

The general idea of restricting exposure of HV privileged bits, but
for the case of HFSCR a guest can probe the HFCR anyway by testing which=20
facilities are available (and presumably an HV may need some way to know
what features are available for it to advertise to its own guests), so
is this necessary? Perhaps a comment would be sufficient.

Thanks,
Nick

>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_nested.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 0cd0e7aad588..860004f46e08 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -98,12 +98,20 @@ static void byteswap_hv_regs(struct hv_guest_state *h=
r)
>  }
> =20
>  static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
> -				 struct hv_guest_state *hr)
> +				 struct hv_guest_state *hr, u64 saved_hfscr)
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> =20
> +	/*
> +	 * During sanitise_hv_regs() we used HFSCR bits from L1 state
> +	 * to restrict what the L2 state is allowed to be. Since L1 is
> +	 * not allowed to read this SPR, do not include these
> +	 * modifications in the return state.
> +	 */
> +	hr->hfscr =3D ((~HFSCR_INTR_CAUSE & saved_hfscr) |
> +		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
> +
>  	hr->dpdes =3D vc->dpdes;
> -	hr->hfscr =3D vcpu->arch.hfscr;
>  	hr->purr =3D vcpu->arch.purr;
>  	hr->spurr =3D vcpu->arch.spurr;
>  	hr->ic =3D vcpu->arch.ic;
> @@ -132,12 +140,14 @@ static void save_hv_return_state(struct kvm_vcpu *v=
cpu, int trap,
>  	}
>  }
> =20
> -static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_stat=
e *hr)
> +static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_stat=
e *hr,
> +			     u64 *saved_hfscr)
>  {
>  	/*
>  	 * Don't let L1 enable features for L2 which we've disabled for L1,
>  	 * but preserve the interrupt cause field.
>  	 */
> +	*saved_hfscr =3D hr->hfscr;
>  	hr->hfscr &=3D (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
> =20
>  	/* Don't let data address watchpoint match in hypervisor state */
> @@ -272,6 +282,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	u64 hdec_exp;
>  	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
>  	u64 mask;
> +	u64 hfscr;
>  	unsigned long lpcr;
> =20
>  	if (vcpu->kvm->arch.l1_ptcr =3D=3D 0)
> @@ -324,7 +335,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	mask =3D LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
>  		LPCR_LPES | LPCR_MER;
>  	lpcr =3D (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
> -	sanitise_hv_regs(vcpu, &l2_hv);
> +
> +	sanitise_hv_regs(vcpu, &l2_hv, &hfscr);
>  	restore_hv_regs(vcpu, &l2_hv);
> =20
>  	vcpu->arch.ret =3D RESUME_GUEST;
> @@ -345,7 +357,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	delta_spurr =3D vcpu->arch.spurr - l2_hv.spurr;
>  	delta_ic =3D vcpu->arch.ic - l2_hv.ic;
>  	delta_vtb =3D vc->vtb - l2_hv.vtb;
> -	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv);
> +	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv, hfscr);
> =20
>  	/* restore L1 state */
>  	vcpu->arch.nested =3D NULL;
> --=20
> 2.29.2
>=20
>=20
