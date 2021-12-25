Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CBE47F2E9
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhLYKRX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhLYKRW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:17:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36058C061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:17:22 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c7so8056499plg.5
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=+Ua4M1wfcUhBq2TD1oIgn0I4RkUTfjjelNJTCFbhcA8=;
        b=XzVdxE+8JiAKiwnNyHob3JSx3aFcs8tys+NKp+JTL7vVSeMN6btZW+kyyVAEELjmm+
         9HsrCyTsWomFmsg466x69YuLkBFmEoF+DHfqAMGEq9SAGxBqMgp9IqBP5WX9Z+xCjGQW
         axop7FvhHbl56iCsmb+4vflzxH/h5oLP7ray4NolDIqgnbDx0YBgPUGiaSescvpLZ0mX
         eq16c9qi3kQyJVrSxlOW+BISTvgE2EOVefq8H53Z3EMu5wRsldGbHu2OfVEo0C5KVsl4
         DWZWi4KKoXkAATU/nVaWSHyKTQhxINERTuKrvDD/C3RL3znqGR657canOAaZUNWabaNM
         i2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=+Ua4M1wfcUhBq2TD1oIgn0I4RkUTfjjelNJTCFbhcA8=;
        b=gSTI6n0qUGjAspwzy3n7Yf2/4olxZPCE+CppyNHapGkK0ig5X16fhc9XVJTjyhj3Oh
         2quu6lFECz/PJBhS9WFhvpCv+ov59K3GgxOwdLlafbrAcBdfEzgvvdsxmZAvBHfKkwNG
         Npg6MuL2dn1L5kDRaDKuV29cyq+p9pH3Mv8DrlywGK8riAB69F0n5AcWX2Zzamz3/02M
         mVkQfJpLuaVYV1SRutiYTuNSbM+CH2XsYPTttzse95m+RAy/VMujM62QXWzJ6awXZ5MV
         0qErXHR+0sjHdid9q3nTQxv8LPm0LDDzF1qIeXSxmxpdrssMSa8qBplXZIIJqxZD7tn7
         Itag==
X-Gm-Message-State: AOAM533HEJ0K+3N4c8vtHkHOEnsKTKjb1KS0Vzx//o7DUa5vGTJHaLOM
        Wr4/nwah3Gzi8ucf5ZRC+/I=
X-Google-Smtp-Source: ABdhPJzpkbpqANhmB7dUgOLbovVw1mLVyBejti7xPBHB/aUjzpXT6jcRQ2Q1pN1KcMg4lcBTYapLoA==
X-Received: by 2002:a17:902:8c97:b0:148:ce06:eff9 with SMTP id t23-20020a1709028c9700b00148ce06eff9mr9827290plo.5.1640427441787;
        Sat, 25 Dec 2021 02:17:21 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id w7sm9758401pgo.56.2021.12.25.02.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:17:21 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:17:16 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Check return value of
 kvmppc_radix_init
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211931.3560887-1-farosas@linux.ibm.com>
        <20211223211931.3560887-2-farosas@linux.ibm.com>
In-Reply-To: <20211223211931.3560887-2-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427422.4ftxfv81m7.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:19 am:
> The return of the function is being shadowed by the call to
> kvmppc_uvmem_init.
>=20

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> Fixes: ca9f4942670c ("KVM: PPC: Book3S HV: Support for running secure gue=
sts")
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 7b74fc0a986b..9f4765951733 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -6098,8 +6098,11 @@ static int kvmppc_book3s_init_hv(void)
>  	if (r)
>  		return r;
> =20
> -	if (kvmppc_radix_possible())
> +	if (kvmppc_radix_possible()) {
>  		r =3D kvmppc_radix_init();
> +		if (r)
> +			return r;
> +	}
> =20
>  	r =3D kvmppc_uvmem_init();
>  	if (r < 0)
> --=20
> 2.33.1
>=20
>=20
