Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E159E49ABC2
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 06:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353513AbiAYF0J (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 00:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S254267AbiAYFOF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 00:14:05 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99007C068096
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:39:37 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p125so17233322pga.2
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=UBA8z/bOgfhnh3ywRbRPFODSNWNBKI4aRyNJ66c+wJI=;
        b=R9MqRHeKd4vo5eGVo5fwUeP0ix7pjwB8eqAs050jw7+n9uL4s5yQiXS04NnnM+HBv5
         UpdaHN38ByRqCGs/ZB8bxClqjzLvHdaFe42EZ/poRjHCiA4JunEQMUtTVXpmsz7qoGbx
         hxOvow/eDVMeG7LNyzi/BXt38bfbH+37YMQPDsMqx81/Ud62CS/D62/8/Ii7EhTG2/4W
         b+H5quzAusCiTYVPFSPRHfpsIqJ/87PjqpJr5+FVO/QXvSQbiybA3lTbHFDiPAE8N0Oq
         kHLQLbNU9Fw/Pug19wDquJVFkD9z/zR0PgA+clgPzKqwKDRIc1pHkyojXFPutn8GS8Kq
         XtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=UBA8z/bOgfhnh3ywRbRPFODSNWNBKI4aRyNJ66c+wJI=;
        b=MSlyhTxy57jNytBPp15W9b6l1ka5TsZEXD65Lnk5vnn0UTc/GdsnfvvjCkn5spoeyT
         3G5+8iifpAVhXelFIxMfDIKbA0vN405i/HgLjTOUNVkfc0JfA8BWDE9xDQtBI59G2hrP
         dPQIGh61FIwDEojBFvvCs49SNmqdrSYwuetC1ptnTeZRu9RVpvuTXkLuKJB9o6yuJKGE
         YXDRWU1JKPk5FeqcIQSOdP89KYN7bJ5Gj3VM89JvrqyCDMQpW74vYZRxkNuZZAKPWG71
         gvnM7ZaDGL8GLx/S4j4Q7zCoMjh/gtvSk+zdQFCCe1GFIYs6zolBpghbQXtefyfcqZy7
         jZqA==
X-Gm-Message-State: AOAM531pODyngV7fHj+8YxcIhQK2GjUWi0S7W1sNX9QGNVZWhqMZ24hW
        97r6fr8Z/Jwd5dJkw7C1RvY=
X-Google-Smtp-Source: ABdhPJwUSwxkaB8hV8BEh5JdNbB1N+v9gwbfxwGKiElWYV709gE3IbC/YbYEGrqJYZ6RFYEoBmfT/g==
X-Received: by 2002:a05:6a00:1da8:b0:4c9:d21a:3aa7 with SMTP id z40-20020a056a001da800b004c9d21a3aa7mr5860548pfw.16.1643081977174;
        Mon, 24 Jan 2022 19:39:37 -0800 (PST)
Received: from localhost (193-116-82-75.tpgi.com.au. [193.116.82.75])
        by smtp.gmail.com with ESMTPSA id 17sm17875203pfl.175.2022.01.24.19.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:39:36 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:39:31 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 5/5] KVM: PPC: mmio: Deliver DSI after emulation
 failure
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220121222626.972495-1-farosas@linux.ibm.com>
        <20220121222626.972495-6-farosas@linux.ibm.com>
In-Reply-To: <20220121222626.972495-6-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1643081198.0ztqz9tgw0.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 22, 2022 8:26 am:
> MMIO emulation can fail if the guest uses an instruction that we are
> not prepared to emulate. Since these instructions can be and most
> likely are valid ones, this is (slightly) closer to an access fault
> than to an illegal instruction, so deliver a Data Storage interrupt
> instead of a Program interrupt.
>=20
> Suggested-by: Nicholas Piggin <npiggin@gmail.com>
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/emulate_loadstore.c | 10 +++-------
>  arch/powerpc/kvm/powerpc.c           | 12 ++++++++++++
>  2 files changed, 15 insertions(+), 7 deletions(-)
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
> index 214602c58f13..9befb121dddb 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -305,10 +305,22 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>  	case EMULATE_FAIL:
>  	{
>  		u32 last_inst;
> +		ulong store_bit =3D DSISR_ISSTORE;
> +		ulong cause =3D DSISR_BADACCESS;
> =20
> +#ifdef CONFIG_BOOKE
> +		store_bit =3D ESR_ST;
> +		cause =3D 0;
> +#endif

BookE can not cause a bad page fault in the guest with ESR bits AFAIKS,=20
so it would cause an infinite fault loop here. Maybe stick with the=20
program interrupt for BookE with a comment about that here.

And if it could use if (IS_ENABLED()) would be good?

Otherwise looks good, it should do the right thing on BookS.

Thanks,
Nick

>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>  		pr_info_ratelimited("KVM: guest access to device memory using unsuppor=
ted instruction (PID: %d opcode: %#08x)\n",
>  				    current->pid, last_inst);
> +
> +		if (vcpu->mmio_is_write)
> +			cause |=3D store_bit;
> +
> +		kvmppc_core_queue_data_storage(vcpu, vcpu->arch.vaddr_accessed,
> +					       cause);
>  		r =3D RESUME_GUEST;
>  		break;
>  	}
> --=20
> 2.34.1
>=20
>=20
