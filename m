Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ED147F2F4
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhLYKWk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhLYKWk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:22:40 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7E3C061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:22:39 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j13so8078779plx.4
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=zABYTDkRCXD7YnSXgmckKl0di++lyiV/wtKOsAFdCOU=;
        b=dgUfnVEYoIapnOPCJtUrxkMGMD/CuvqBZMI09usIzRTm0Uc2X6cDr0VOValV3AdNbK
         suvBbVrDCtUHTO2t4a9+ttMSI11kJB40HTfM4vW9I/Bpe0eh6HdHzWnjjkikgGAlZMpK
         f35XeVHPI9E8propq0NzZFh5yRu8H8etXkfPabNH7Ih42JdhqgycZRJbwyUwHG81tRM3
         XJfm5RB4/hjU78k2gtX5rwHehKBT8gCd+LdDjmTk887h1kx9Lc9jAw/m+oy4qAllq2DM
         4QuRXrCsrW6958ATkyRvgzD9Xpy/aqjLO4cWwKJm53tYeHEzo2EMcAsNiRccZG+4fxbe
         1pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=zABYTDkRCXD7YnSXgmckKl0di++lyiV/wtKOsAFdCOU=;
        b=2hSFC8CzOD+VUD/7s/omRTTI/Gbb0NWa3M75HExXx5Hu9SKzJTEIHZ+z1FQVu9h+18
         ukxPGwsRR7ipS5D/5KT0zE3li1UHHHLKcSRAKVL8NTkSt8bplyB2viIpFijwhZmu1JaQ
         z4RE5laD60Nv7xZMkgATrhloqeDqrsd2iJZSq12AwWNQbup9GRoNr8dW3yuP4sxzDTho
         ufYh9kJcfSUiB+9YC3olAYandbBtcg9/9IngGsoSyv0RdioFjb/CvPE5sB+Zhitoijmt
         PPo3nQpM8u1XGQ4fI7Xr1zeLmVHjx8Q5pBAg/FeD3ZaHdreQeaaSVeEKgnyT+61NJRcn
         jsew==
X-Gm-Message-State: AOAM532P7JSyaPgBSCXR31g+zONIqxOAU3AAD76VWrZk7dgKlkKZw/nD
        dGIxW2meUghkbbpC+rrx8xU=
X-Google-Smtp-Source: ABdhPJxTkMdALYld74m+geG63p9dWNi1p2dnSIkU414Kd1BPqXanEBoDifWvzO2prhNFG7aFQRMNbw==
X-Received: by 2002:a17:90b:360e:: with SMTP id ml14mr12131878pjb.135.1640427759397;
        Sat, 25 Dec 2021 02:22:39 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id k8sm12766668pfu.72.2021.12.25.02.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:22:39 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:22:34 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S HV: Free allocated memory if module
 init fails
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211931.3560887-1-farosas@linux.ibm.com>
        <20211223211931.3560887-4-farosas@linux.ibm.com>
In-Reply-To: <20211223211931.3560887-4-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427594.mim1kqxpi8.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:19 am:
> The module's exit function is not called when the init fails, we need
> to do cleanup before returning.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 53400932f5d8..2d79298e7ca4 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -6065,7 +6065,7 @@ static int kvmppc_book3s_init_hv(void)
> =20
>  	r =3D kvm_init_subcore_bitmap();
>  	if (r)
> -		return r;
> +		goto err;
> =20
>  	/*
>  	 * We need a way of accessing the XICS interrupt controller,
> @@ -6080,7 +6080,8 @@ static int kvmppc_book3s_init_hv(void)
>  		np =3D of_find_compatible_node(NULL, NULL, "ibm,opal-intc");
>  		if (!np) {
>  			pr_err("KVM-HV: Cannot determine method for accessing XICS\n");
> -			return -ENODEV;
> +			r =3D -ENODEV;
> +			goto err;
>  		}
>  		/* presence of intc confirmed - node can be dropped again */
>  		of_node_put(np);
> @@ -6093,12 +6094,12 @@ static int kvmppc_book3s_init_hv(void)
> =20
>  	r =3D kvmppc_mmu_hv_init();
>  	if (r)
> -		return r;
> +		goto err;
> =20
>  	if (kvmppc_radix_possible()) {
>  		r =3D kvmppc_radix_init();
>  		if (r)
> -			return r;
> +			goto err;
>  	}
> =20
>  	r =3D kvmppc_uvmem_init();
> @@ -6111,6 +6112,12 @@ static int kvmppc_book3s_init_hv(void)
>  	kvmppc_hv_ops =3D &kvm_ops_hv;
> =20
>  	return 0;
> +
> +err:
> +	kvmhv_nested_exit();
> +	kvmppc_radix_exit();

These should both be callable without init functions succeeding
so this looks right to me.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick

> +
> +	return r;
>  }
> =20
>  static void kvmppc_book3s_exit_hv(void)
> --=20
> 2.33.1
>=20
>=20
