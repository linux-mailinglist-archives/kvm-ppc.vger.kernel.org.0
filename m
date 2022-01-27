Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D751C49DBB8
	for <lists+kvm-ppc@lfdr.de>; Thu, 27 Jan 2022 08:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbiA0He0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 27 Jan 2022 02:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiA0He0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 27 Jan 2022 02:34:26 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65895C061714
        for <kvm-ppc@vger.kernel.org>; Wed, 26 Jan 2022 23:34:26 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x11so1772780plg.6
        for <kvm-ppc@vger.kernel.org>; Wed, 26 Jan 2022 23:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=0z6S/QM0Uvi3byPZUvWJmc24ntlSpzOJlQruqXOVpc0=;
        b=aDTBTXhQ5RZXiO1G2Ng3z2p9A30SqfEO9aRYeJLhglNFTqJKHjoIGk0Ps0efTdlsJ0
         x9BbEPCyC8svBSHV4B78BIJOepThLR/jaJ4YyhsM02/3t9qB55qwINmV/aSrBaMC5+XW
         klKheAOzwQO0Ag4DOesqw+zBSTxFjXsnTw+0mYMuqTrHUvZ6GufoZNOH1s1q1UO1gB6v
         7wiyhlSrzDD+ZTXCGw/R2NCNh5PhLopQ1nXiyGHfJEOZqTf21jBIhcr3lWKjaGE3XBZd
         luP6jflZTmJ/CruBxs4Ldv7XDt0hNG6ditdQvqUaLbUIiDSEqu6n4hEZpUi/chvijf60
         /Slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=0z6S/QM0Uvi3byPZUvWJmc24ntlSpzOJlQruqXOVpc0=;
        b=nkiGJPkesnuuDLQwVEplRHmvq+BokERb1JZvuTP9vUVyJI9m7fP+TuUgLzLqrZzonp
         AhVF9e+HYQ2jYBGamhsj4mBZ7/qkb0npV7ZmitHvNR5cBC1CNsHlgcP3o3jSYXpnt1V2
         gbZsFTrt2R8jZ2BMgsNKqjwM2sNN6ZNIMghwihkj7H/7tVkOQcGRdvQoC4PZmRBUAJal
         mq9Ev8eSAaK5FoEQbvnIwTnQd/79ooPAUf+WqEeYBgM8pbgMADOegKOIkZjWuv/q/6UQ
         g8fQ+qGEnbQwvh1Mh7do9e+i+yWhPs40lpb60ZZ5ZuhNCzjeZu1a/0msERAGM/Lzn0H9
         omOQ==
X-Gm-Message-State: AOAM533nYVB9NA5iR+Tph37Tkag+hVZdflZkuyZ5sQx8QjI2iGb/eYRs
        0DBgcEugzeG03gAkh06g72Pip1rBtVs=
X-Google-Smtp-Source: ABdhPJxlLYR/dkdYryTXXfmtY/KdmSWPkXwUUpGTZPpsw/Ji5if50Kapadwj5DU9pXgnpMtLvxwbCw==
X-Received: by 2002:a17:902:6a83:: with SMTP id n3mr2036481plk.139.1643268865738;
        Wed, 26 Jan 2022 23:34:25 -0800 (PST)
Received: from localhost (193-116-82-75.tpgi.com.au. [193.116.82.75])
        by smtp.gmail.com with ESMTPSA id b20sm4494332pfv.134.2022.01.26.23.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:34:25 -0800 (PST)
Date:   Thu, 27 Jan 2022 17:34:20 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 5/5] KVM: PPC: Book3s: mmio: Deliver DSI after
 emulation failure
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220125215655.1026224-1-farosas@linux.ibm.com>
        <20220125215655.1026224-6-farosas@linux.ibm.com>
In-Reply-To: <20220125215655.1026224-6-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1643268801.z8aez7lyue.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 26, 2022 7:56 am:
> MMIO emulation can fail if the guest uses an instruction that we are
> not prepared to emulate. Since these instructions can be and most
> likely are valid ones, this is (slightly) closer to an access fault
> than to an illegal instruction, so deliver a Data Storage interrupt
> instead of a Program interrupt.
>=20
> BookE ignores bad faults, so it will keep using a Program interrupt
> because a DSI would cause a fault loop in the guest.
>=20
> Suggested-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

Thanks this looks good to me. (And thanks for updating patch 4/5 with
the kvm debug print helper.)

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/kvm/emulate_loadstore.c | 10 +++-------
>  arch/powerpc/kvm/powerpc.c           | 22 ++++++++++++++++++++++
>  2 files changed, 25 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emul=
ate_loadstore.c
> index 48272a9b9c30..cfc9114b87d0 100644
> --- a/arch/powerpc/kvm/emulate_loadstore.c
> +++ b/arch/powerpc/kvm/emulate_loadstore.c
> @@ -73,7 +73,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>  {
>  	u32 inst;
>  	enum emulation_result emulated =3D EMULATE_FAIL;
> -	int advance =3D 1;
>  	struct instruction_op op;
> =20
>  	/* this default type might be overwritten by subcategories */
> @@ -98,6 +97,8 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>  		int type =3D op.type & INSTR_TYPE_MASK;
>  		int size =3D GETSIZE(op.type);
> =20
> +		vcpu->mmio_is_write =3D OP_IS_STORE(type);
> +
>  		switch (type) {
>  		case LOAD:  {
>  			int instr_byte_swap =3D op.type & BYTEREV;
> @@ -355,15 +356,10 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>  		}
>  	}
> =20
> -	if (emulated =3D=3D EMULATE_FAIL) {
> -		advance =3D 0;
> -		kvmppc_core_queue_program(vcpu, 0);
> -	}
> -
>  	trace_kvm_ppc_instr(inst, kvmppc_get_pc(vcpu), emulated);
> =20
>  	/* Advance past emulated instruction. */
> -	if (advance)
> +	if (emulated !=3D EMULATE_FAIL)
>  		kvmppc_set_pc(vcpu, kvmppc_get_pc(vcpu) + 4);
> =20
>  	return emulated;
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index acb0d2a4bdb9..82d889db2b6b 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -309,6 +309,28 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>  		kvm_debug_ratelimited("Guest access to device memory using unsupported=
 instruction (opcode: %#08x)\n",
>  				      last_inst);
> +
> +		/*
> +		 * Injecting a Data Storage here is a bit more
> +		 * accurate since the instruction that caused the
> +		 * access could still be a valid one.
> +		 */
> +		if (!IS_ENABLED(CONFIG_BOOKE)) {
> +			ulong dsisr =3D DSISR_BADACCESS;
> +
> +			if (vcpu->mmio_is_write)
> +				dsisr |=3D DSISR_ISSTORE;
> +
> +			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.vaddr_accessed, dsisr=
);
> +		} else {
> +			/*
> +			 * BookE does not send a SIGBUS on a bad
> +			 * fault, so use a Program interrupt instead
> +			 * to avoid a fault loop.
> +			 */
> +			kvmppc_core_queue_program(vcpu, 0);
> +		}
> +
>  		r =3D RESUME_GUEST;
>  		break;
>  	}
> --=20
> 2.34.1
>=20
>=20
