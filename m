Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636B949AB79
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 06:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346101AbiAYFPw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 00:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1319891AbiAYEwQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 23:52:16 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287D7C01D7E2
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:26:33 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id p125so17211441pga.2
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=4wBvCDwSPnNaYiptEl6hW8BISTRdTug2mLfsez5vYL0=;
        b=Ipey0nRXa+7FG2iXOvDjo82mcIPH+ChWUgS1twDf8fJDgpV/y4PSaDP5DPFcQjUygg
         M5lNOaxJlBDwuvfNfNkPlDk3y0uQB5/BMbSKO4z0cFZYe7KWFVNoRuL2tSLQCvM67c8e
         EKh9Ex2SzxpbCtsFH51K7cP2Ry7bMds8NIjuF9RyWaCFYpTnbaCdAk0qvbS9KsKmXbct
         9fpXnIwz08EIZTmAEodKYWq29SteHERKghIilxefYOK+OYGGF6mHmZUuPhj/miXmf9QS
         CESG1XcjS6fIOXSBy5P+gjMCmEmgp74HCkVIS/jP84TEmBN554LgoXdWzvn8Mv70hggR
         tWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=4wBvCDwSPnNaYiptEl6hW8BISTRdTug2mLfsez5vYL0=;
        b=LCBIkZ5/brUu7BK/2/iufKm7ze9VKT+VbzyKk52klrbZBR9iKjAohR93lpyzH4GKTp
         ea92tj5FC6UjrYkm7s8MS+Bfl8oKujIpdeLZYMCI4d205DYBqRDRQoOkDv1dpiaFyD3T
         fxrf8MrhyLvhu4QHIoRcrmUnQMFgFY9cIoikcMkio8fQQbV+tczIar/ZeYzEm5qQfn5u
         GiQd/v7Lnqzlk6wRZApFkKmr09uy7aGO6WZYBgSGXezqudMr1gsDjL4x4TYP2QyyQAc7
         83EyKUPSF0PPCv9rUD0Bd1/bIxLfRKrJuN47jIdHpGEORuTIMtTBJNZqp3ACeZ/bapjZ
         UcMg==
X-Gm-Message-State: AOAM533PPdI21Bn+5WxdpwPAVWy8PK3PWMbw1hNtoA0H48og+Oky5Tjz
        ew24IUQhx1/gUiw6NZ5dRdyMCYRBmcw=
X-Google-Smtp-Source: ABdhPJysDGHAS7KJCYLI37rnYJjzRCbW9pVwgdi85e5w7kDeBkES8UoQ3MODGurXAr5Hm+/ssgu3iw==
X-Received: by 2002:a63:f412:: with SMTP id g18mr13748168pgi.463.1643081192743;
        Mon, 24 Jan 2022 19:26:32 -0800 (PST)
Received: from localhost (193-116-82-75.tpgi.com.au. [193.116.82.75])
        by smtp.gmail.com with ESMTPSA id n22sm17165683pfu.160.2022.01.24.19.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:26:32 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:26:26 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 4/5] KVM: PPC: mmio: Return to guest after emulation
 failure
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220121222626.972495-1-farosas@linux.ibm.com>
        <20220121222626.972495-5-farosas@linux.ibm.com>
In-Reply-To: <20220121222626.972495-5-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1643080025.cz96zd90xb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 22, 2022 8:26 am:
> If MMIO emulation fails we don't want to crash the whole guest by
> returning to userspace.
>=20
> The original commit bbf45ba57eae ("KVM: ppc: PowerPC 440 KVM
> implementation") added a todo:
>=20
>   /* XXX Deliver Program interrupt to guest. */
>=20
> and later the commit d69614a295ae ("KVM: PPC: Separate loadstore
> emulation from priv emulation") added the Program interrupt injection
> but in another file, so I'm assuming it was missed that this block
> needed to be altered.
>=20
> Also change the message to a ratelimited one since we're letting the
> guest run and it could flood the host logs.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

One small thing...

> ---
>  arch/powerpc/kvm/powerpc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 27fb2b70f631..214602c58f13 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -307,9 +307,9 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>  		u32 last_inst;
> =20
>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
> -		/* XXX Deliver Program interrupt to guest. */
> -		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
> -		r =3D RESUME_HOST;
> +		pr_info_ratelimited("KVM: guest access to device memory using unsuppor=
ted instruction (PID: %d opcode: %#08x)\n",
> +				    current->pid, last_inst);

Minor thing but KVM now has some particular printing helpers so I wonder=20
if we should start moving to them in general with our messages.

vcpu_debug_ratelimited() maybe?

Thanks,
Nick
