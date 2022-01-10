Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B484892BF
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jan 2022 08:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242009AbiAJHsF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 02:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243832AbiAJHp6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 02:45:58 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C16C025270
        for <kvm-ppc@vger.kernel.org>; Sun,  9 Jan 2022 23:38:29 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f5so10427114pgk.12
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Jan 2022 23:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=q/dzvf8yvsnwgKw/boK35Xq8HUaXN1Q2ifLzXvICyGk=;
        b=ZJWFgCw9ctx2a/KzuYmu0+EYnCD7bgzxvDFdKWEZ9EpTOzK5x8yCUJR0sA0WZZZpco
         Un77gJ8ltdg+r5FGWJTBo3+pwZkAcE0toP4yQJRaZPDbM33W2ZhpmPb+Jumc/v2zEFhn
         QXpF6iQFu7D+GprL3PS5g8jTtKTqq0hl3gEvRpGyBk3/4ZZqUe9kqSHRY9yI6Sswn/Hf
         XWfDEQfE283YSPcUmUpfflYh2M/br6WrgVMu/jnYPGGeS3O1tSDbWQeaqjOu5U0Aie6S
         6wUxfTA1UZvtsu51fdUA+WMGQ8Xmze+a/GWsEygBLtAtdj/ALCRUh3L29v/DiEoyurHL
         3x8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=q/dzvf8yvsnwgKw/boK35Xq8HUaXN1Q2ifLzXvICyGk=;
        b=Yg+lHpmyhU/vqGCsQbONtQStBkO/2yGiI8+4/tufSmOiLSfnDTO2kHyFIBaf99yclh
         URWRzFHMiqvYHUDm2Kl1Re+ANM+tGOXoWJjV/cy5yc07DBguLSOltN22qmHqGAXtXm0z
         W6H7OWZoPr2gnSg6EmYdXxhmPznTFO5CLN39C5Y8LINv+vR/p4LsbwYzNkb9oOyY6zw2
         1Ivv8l3PGCXIxHf1BVGaZmf6dDZv1wsyktFB0/udTQUN432pbgWZoZ3I93K8TMtKfRyw
         xCoAaKikosqhLvUU54x2DG40gtrn+BxzHUls40SO8FyCZbi3wwNMyfB7TUlvP9f+6RoV
         Rq/g==
X-Gm-Message-State: AOAM5319K2Pgue/dN+gHz830rNvVvGqt1npsjMgPvoZYFDrKo7mzOCSr
        lR/4XB9OUW5tTU9xxiWb+nM=
X-Google-Smtp-Source: ABdhPJyJ2ADFojpZ85SOqBqnQ6pzRvvd6/nLgfYJrOajVgZ8p4dL+0rxhDB66VCapKQWdhUOd4lCeQ==
X-Received: by 2002:aa7:91c3:0:b0:4b0:eebe:49c0 with SMTP id z3-20020aa791c3000000b004b0eebe49c0mr74999524pfa.6.1641800309528;
        Sun, 09 Jan 2022 23:38:29 -0800 (PST)
Received: from localhost (124-171-74-95.tpgi.com.au. [124.171.74.95])
        by smtp.gmail.com with ESMTPSA id 10sm8264735pjc.6.2022.01.09.23.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 23:38:29 -0800 (PST)
Date:   Mon, 10 Jan 2022 17:38:24 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 6/6] KVM: PPC: mmio: Reject instructions that access
 more than mmio.data size
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
        <20220107210012.4091153-7-farosas@linux.ibm.com>
In-Reply-To: <20220107210012.4091153-7-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1641800177.nr6ngd1fot.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
> The MMIO interface between the kernel and userspace uses a structure
> that supports a maximum of 8-bytes of data. Instructions that access
> more than that need to be emulated in parts.
>=20
> We currently don't have generic support for splitting the emulation in
> parts and each set of instructions needs to be explicitly included.
>=20
> There's already an error message being printed when a load or store
> exceeds the mmio.data buffer but we don't fail the emulation until
> later at kvmppc_complete_mmio_load and even then we allow userspace to
> make a partial copy of the data, which ends up overwriting some fields
> of the mmio structure.
>=20
> This patch makes the emulation fail earlier at kvmppc_handle_load|store,
> which will send a Program interrupt to the guest. This is better than
> allowing the guest to proceed with partial data.
>=20
> Note that this was caught in a somewhat artificial scenario using
> quadword instructions (lq/stq), there's no account of an actual guest
> in the wild running instructions that are not properly emulated.
>=20
> (While here, fix the error message to check against 'bytes' and not
> 'run->mmio.len' which at this point has an old value.)

This looks good to me

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/kvm/powerpc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 56b0faab7a5f..a1643ca988e0 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1246,7 +1246,8 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vc=
pu,
> =20
>  	if (bytes > sizeof(run->mmio.data)) {
>  		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> +		       bytes);

I wonder though this should probably be ratelimited, informational (or=20
at least warning because it's a host message), and perhaps a bit more
explanatory that it's a guest problem (or at least lack of host support
for particular guest MMIO sizes).

Thanks,
Nick
