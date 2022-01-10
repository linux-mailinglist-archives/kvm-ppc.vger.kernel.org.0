Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DAB488F8C
	for <lists+kvm-ppc@lfdr.de>; Mon, 10 Jan 2022 06:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbiAJFW0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 10 Jan 2022 00:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiAJFWZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 10 Jan 2022 00:22:25 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489BFC06173F
        for <kvm-ppc@vger.kernel.org>; Sun,  9 Jan 2022 21:22:25 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x83so2790211pfc.0
        for <kvm-ppc@vger.kernel.org>; Sun, 09 Jan 2022 21:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=IG6cyA2PEBju74W6OZ9xTgqBPjnFRHCrixS8tldCOQ4=;
        b=RBIpfuVQYt1Ns6K0R7W+OiG2VdDpeM0lwzBCcykMqKjsDKaJmCX14b3I0fQutaU/FX
         eteC7JM6RcsLt2iDY+OWGyvzXFjHEBUSaN1SwabtqcyScHQu0b2yqi9x/xgrcxJZ5rrL
         1gN5gMLyWmUIM+GvQ4wkaosGerHCiBwvNi+43asslNAr23oG+1Q/bC6SYMjX0O/e7yu0
         yPipkNTWq5iyNhRK5isXQPx9KhxFwj821LJywu6rfwTCZx52asYxU/xU+j543AAOFeAC
         q1nJkLJcNku3ZR/Aqx1L7qo8hst4IR0gYGJRkSQEJlHObR9/xcwJCbpJpSoE99o2N/ge
         6Z1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=IG6cyA2PEBju74W6OZ9xTgqBPjnFRHCrixS8tldCOQ4=;
        b=136e41qfjtRI1KzRP2u3OYLYdPUnIMYoMBHgtSzNWPGIa41ZUbAvR9upNI4OP/W/uM
         otjrQKTecCzJMbbW09Z0nfsqqPugG37qASEUaZaxDjmjhng/YrLu+9cPF4oTu/CKQ0Vi
         gVxfU/PKvmEg9rCIbv2dL/9lVoFpM1AqatYZqMZea/e/z3MQceS6QFHV5h1s8Vz9Ja84
         gU03UCGOANXfpizaPnH9CM+xA9JWU5zmqnNiKvsUazIL+0SOrh0BJIkiUNorpRuXvmxE
         Ip2A61zBXKHY5Ys3qtimTgGEsVo2YaQVKSqlsDO/otEaCoSOK+tqV2/BP6LUY27+PaJv
         6SVw==
X-Gm-Message-State: AOAM533UbGnEFIRnHiIhgoh2sGfZe8x3FfinMW21GFVFFEhTU3qW1jv3
        RuoGYBK9n4Pcfap8wkT1yd4=
X-Google-Smtp-Source: ABdhPJxVpWasdjpezgcL8UqnvvI10G/t43xjTtNFk/sWDgjyjPzLN6xxlCTmj61XPa0LbqcNaTdC3g==
X-Received: by 2002:a63:b544:: with SMTP id u4mr38738300pgo.160.1641792144714;
        Sun, 09 Jan 2022 21:22:24 -0800 (PST)
Received: from localhost (124-171-74-95.tpgi.com.au. [124.171.74.95])
        by smtp.gmail.com with ESMTPSA id i11sm5167623pfq.206.2022.01.09.21.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 21:22:24 -0800 (PST)
Date:   Mon, 10 Jan 2022 15:22:19 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 3/6] KVM: PPC: Don't use pr_emerg when mmio emulation
 fails
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220107210012.4091153-1-farosas@linux.ibm.com>
        <20220107210012.4091153-4-farosas@linux.ibm.com>
In-Reply-To: <20220107210012.4091153-4-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1641791924.shozt0u4v5.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 8, 2022 7:00 am:
> If MMIO emulation fails we deliver a Program interrupt to the
> guest. This is a normal event for the host, so use pr_info.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---

Should it be rate limited to prevent guest spamming host log? In the=20
case of informational messages it's always good if it gives the=20
administrator some idea of what to do with it. If it's normal
for the host does it even need a message? If yes, then identifying which
guest and adding something like "(this might becaused by a bug in guest=20
driver)" would set the poor admin's mind at rest.

Thanks,
Nick

>  arch/powerpc/kvm/powerpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 92e552ab5a77..4d7d0d080232 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -308,7 +308,7 @@ int kvmppc_emulate_mmio(struct kvm_vcpu *vcpu)
> =20
>  		kvmppc_get_last_inst(vcpu, INST_GENERIC, &last_inst);
>  		/* XXX Deliver Program interrupt to guest. */
> -		pr_emerg("%s: emulation failed (%08x)\n", __func__, last_inst);
> +		pr_info("%s: emulation failed (%08x)\n", __func__, last_inst);
>  		r =3D RESUME_HOST;
>  		break;
>  	}
> --=20
> 2.33.1
>=20
>=20
