Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FE74892CB
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jan 2022 08:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbiAJHvc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 02:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241759AbiAJHmK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 02:42:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D2BC06173F
        for <kvm-ppc@vger.kernel.org>; Sun,  9 Jan 2022 23:36:12 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i30so10466882pgl.0
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Jan 2022 23:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=6yomU4+mzGXo6Rwy8oGn/mAJJAsCmpMu41OyX2klM60=;
        b=Bt7E76FDwlkds6LdDSdQV6M5uQeTkKYu88f+topooyVx9jfG3jhW1dgNBj+hZlqFqY
         xygj19gZKG2b5WWanbAyhYDNwjw230o8zrIz8MLm8xupOj4OcH+NUDTppAxmf4oo+RPZ
         ROk42Pzq8RbHey+NPmPNTgXIItLilv5oVhpnOS7/8aEBVLWxXSpmYzISASOQgePlXMua
         Rj1D+9ADECwKLz9MJe4JwA6AC5cL509Qr7l/wXATYoMBkNXaFUxQHk9YzoV/b9MkuRTd
         FrNsmcPh+qVDBGnZStl2T8W6VzNtXyXS7XriglDQve0qMBCf61pVGDB86TzOTWxx+AxT
         k9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=6yomU4+mzGXo6Rwy8oGn/mAJJAsCmpMu41OyX2klM60=;
        b=S7oT/kSWN+fRqMM8j+BuP+CZvGtYeB0Rv2/VCFoDJCD4Nl0eVLr2ChVOnYf+M6lJvx
         qM4fjLtCsBiejCuP8KPLgxI8a7gHStiLNWh16Ef8xotSO8Q/PmuqWOXZ7olcczIHLKiM
         2dznCYnOV4DqF91NEYU8KuN7ZoYotRLYjH5bQxl8aRBLqXCUQ/4960Am/7/9rDtQ774R
         qkKlKVuUVsiXyOTvstjyVUwkxnfwgxhJLRmtaSmKaTmDncHBPgF++Tdc0QgjuiNceom9
         w3AccdImC8A9rQWErSQAKdtJa1dTWl6HnGAidV4A3klzacRHci4SDt0AXeKEoGfXVy2B
         ZImg==
X-Gm-Message-State: AOAM532+fSbjmQgQ7etw23J2lG964B4lwrAtxs2QhwXysp41viiOvVcc
        OfYfHCMGVeBSq6sRZorppD4=
X-Google-Smtp-Source: ABdhPJwk/5cHvvmIUIZObJftZ/3y5xd1JU2AnqLUOTHQHICnW/lomFDaMXgZKhpuh0eIZwX+SGI/og==
X-Received: by 2002:a63:3341:: with SMTP id z62mr56493253pgz.99.1641800172528;
        Sun, 09 Jan 2022 23:36:12 -0800 (PST)
Received: from localhost (124-171-74-95.tpgi.com.au. [124.171.74.95])
        by smtp.gmail.com with ESMTPSA id c11sm6064062pfv.85.2022.01.09.23.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 23:36:12 -0800 (PST)
Date:   Mon, 10 Jan 2022 17:36:07 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 5/6] KVM: PPC: mmio: Return to guest after emulation
 failure
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
        <20220107210012.4091153-6-farosas@linux.ibm.com>
In-Reply-To: <20220107210012.4091153-6-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1641799578.6dxlxsaaos.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
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
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/kvm/powerpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 6daeea4a7de1..56b0faab7a5f 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -309,7 +309,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>  		kvmppc_core_queue_program(vcpu, 0);
>  		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
> -		r =3D RESUME_HOST;
> +		r =3D RESUME_GUEST;

So at this point can the pr_info just go away?

I wonder if this shouldn't be a DSI rather than a program check.=20
DSI with DSISR[37] looks a bit more expected. Not that Linux
probably does much with it but at least it would give a SIGBUS
rather than SIGILL.

Thanks,
Nick
