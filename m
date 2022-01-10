Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AC8488FCC
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jan 2022 06:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiAJF3v (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 00:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbiAJF3u (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 00:29:50 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD4CC06173F
        for <kvm-ppc@vger.kernel.org>; Sun,  9 Jan 2022 21:29:50 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id i8so10202425pgt.13
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Jan 2022 21:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=T63j2oXophFqNBBjU9MLKfxqlttgIeTwiU8z9Cj214g=;
        b=YEoNUb6QHF+pu0VTfmVF33nQwcZ7Gd2miJ1ufC1wGf337foRXS4Ryh/HYkfvvRVYuu
         yWHgGQHlUn1wDZx5M+upSYsyf9H+0+jPAw8KmMwl8vd/vHoFIsi2RUO3U7hyO3fFLZec
         eAsRAqJRViIIpY/SKBJef9ArAtpPmGXkHL2LlspXkQ+Vy4eyvyFmfgfVpyZiPkkApr1t
         17PR9kTI6J7zN/PFmWZ6GWaRSbbQ9oBWg8cq6yB13kPGy4wIpfeAMUOR4lnDlJJRqsAP
         /Bn5S70UqRCvOsPSLCmPhuLaVBe0Mv4KXGBMXRE4zmIchl4iEkc6JmuvS5IKkImSRbxl
         hnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=T63j2oXophFqNBBjU9MLKfxqlttgIeTwiU8z9Cj214g=;
        b=mboK8zgyK0HS6x5ya0HfYYNdZUsMOzQ/xk5cWnJMNXyJbo4gi5ZcJ3sEyM3ccEfhJf
         4jZvXoX2s/OftnYDQY8EVwYOiqzvICzP2s56yQ4tla9cMLpLI91H4AytXEJnBfwLKKEj
         sPNmBb+omnHvkiXmY0QZgUNGkvcp+ZXgMnuY6sAI2X1mWs5/oDV8XSYtn5PJNWleKjv9
         GH2QYlg3NOpOKamOpjNUAX6BiAw/qGIgLLpzKlbvdEFL1eKsxaHDxm/yDeADDLgrphqd
         lwcdqJn+a/vO5rmQA/UFFGbBZ7t+s88gRFQDTdIQTjiraxY9V9pHYJDVybQo0dUz/I5g
         8/pg==
X-Gm-Message-State: AOAM532ljhJrls8yobs2Fu9bGUmo2S4EJZlH6ncO/03XrxxjkaKRr0cj
        +xoHpO8dSB7xL45OFq/tKu+P+Yx6JP4=
X-Google-Smtp-Source: ABdhPJyZJmtV6L00QPqpSwBJr/VlJx4xkSwOU80cXDSPMr/EwmA5FPqnJyxnm9v72ZFh8Z4RJos9mg==
X-Received: by 2002:aa7:8592:0:b0:4be:2691:bb88 with SMTP id w18-20020aa78592000000b004be2691bb88mr5055939pfn.20.1641792590003;
        Sun, 09 Jan 2022 21:29:50 -0800 (PST)
Received: from localhost (124-171-74-95.tpgi.com.au. [124.171.74.95])
        by smtp.gmail.com with ESMTPSA id oa9sm7632398pjb.31.2022.01.09.21.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 21:29:49 -0800 (PST)
Date:   Mon, 10 Jan 2022 15:29:44 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: PPC: mmio: Queue interrupt at
 kvmppc_emulate_mmio
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
        <20220107210012.4091153-5-farosas@linux.ibm.com>
In-Reply-To: <20220107210012.4091153-5-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1641792561.xpvi87mg71.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
> If MMIO emulation fails, we queue a Program interrupt to the
> guest. Move that line up into kvmppc_emulate_mmio, which is where we
> set RESUME_GUEST/HOST. This allows the removal of the 'advance'
> variable.
>=20
> No functional change, just separation of responsibilities.

Looks cleaner.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/emulate_loadstore.c | 8 +-------
>  arch/powerpc/kvm/powerpc.c           | 2 +-
>  2 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emul=
ate_loadstore.c
> index 48272a9b9c30..4dec920fe4c9 100644
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
> @@ -355,15 +354,10 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
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
> index 4d7d0d080232..6daeea4a7de1 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -307,7 +307,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>  		u32 last_inst;
> =20
>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
> -		/* XXX Deliver Program interrupt to guest. */
> +		kvmppc_core_queue_program(vcpu, 0);
>  		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
>  		r =3D RESUME_HOST;
>  		break;
> --=20
> 2.33.1
>=20
>=20
