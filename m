Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436C747F2F1
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhLYKTw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhLYKTw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:19:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14562C061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:19:52 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso10223162pjb.1
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Mmel+tedTB5YoX4P4ksLym5gFTM6R7kIIMKU3ZsytT4=;
        b=EViq9QyF5bkZ8SrPmK7akPsIuSMFVLwkKPcwN8h3cwazrkHAl4sWkYCw6+kOz4HVzK
         k9mtU3FFEye/DehlYSZaBhCmYxKotH4hsjUb6QFBTsdjwGRYCMri2AKIqqj7MMmfqN1L
         ETNBgVlCWpc7l4HTbYv8tc+RZLnFTcviGyYyndDKI5UVUQK57/vIlyfFxHud+gFAwrYL
         ACQMkuIahakpTeCj9mSugkxlcyhen70N0YApZxPw3w/HO/y0gtoiCR+UKo6dtRMdxEOa
         ofjwUVH877G+4OST3nxmcKRJCj3UxBEVF5FOa1Gfqs4uRh4Ip7Unj2T1UJq0GsVeJa5G
         kQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Mmel+tedTB5YoX4P4ksLym5gFTM6R7kIIMKU3ZsytT4=;
        b=r0ZtetHX5EWymoJKxGqyRmepmExi4Iv4IilJ8RMhSsp/4YMMyP4OuQOQDpi341jImU
         whmuL7ndn0GWLKtSLSPJullpC/LrRXpZLCL75bqrr/kQ01ZSAa/bNWumAIOD+IYIIuSe
         8PGyjBUlnNZPHfiaViUdUZSK8WuAWJdQzZtlOLGgZpbTWIQ0YPEtCXGOZ+jZt/GO/JPq
         dCUY7o6SxgOEl6hKI0XnMiSEIPOj3XJV7b+AjNRuXwY8obazyAH6aRPmf/dsk41Xh4Zu
         8qKqVQM5Z3J7ptTJxxKzAXNH96I/oey6l1O6cp2o32HVwsJmk2hnZJ6osHedWqbtu0fS
         ZIow==
X-Gm-Message-State: AOAM532OkkqfKj/O9TQHaV+t0glNv4cHMLBk9EsLn3fSr2XQ+IjMsI7e
        tiW5upRI/m4JPHC4EovttiE=
X-Google-Smtp-Source: ABdhPJzsyc1mrnzfjOO4+nvy5y65RBO5OAbaQDrHXl6t4XfaFHAQtA3Nqvsmt3Kc3pe08E85BqMqIQ==
X-Received: by 2002:a17:90b:3b83:: with SMTP id pc3mr668375pjb.3.1640427591720;
        Sat, 25 Dec 2021 02:19:51 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id u5sm12119210pfk.67.2021.12.25.02.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:19:51 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:19:46 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] KVM: PPC: Book3S HV: Delay setting of kvm ops
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au
References: <20211223211931.3560887-1-farosas@linux.ibm.com>
        <20211223211931.3560887-3-farosas@linux.ibm.com>
In-Reply-To: <20211223211931.3560887-3-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427464.ji8lnut0io.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:19 am:
> Delay the setting of kvm_hv_ops until after all init code has
> completed. This avoids leaving the ops still accessible if the init
> fails.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

Also looks okay to me but KVM init has lots of details. IIRC Alexey may=20
have run into a related issue with ops being set too early (or was it=20
cleared too late?)

Thanks,
Nick

> ---
>  arch/powerpc/kvm/book3s_hv.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 9f4765951733..53400932f5d8 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -6087,9 +6087,6 @@ static int kvmppc_book3s_init_hv(void)
>  	}
>  #endif
> =20
> -	kvm_ops_hv.owner =3D THIS_MODULE;
> -	kvmppc_hv_ops =3D &kvm_ops_hv;
> -
>  	init_default_hcalls();
> =20
>  	init_vcore_lists();
> @@ -6105,10 +6102,15 @@ static int kvmppc_book3s_init_hv(void)
>  	}
> =20
>  	r =3D kvmppc_uvmem_init();
> -	if (r < 0)
> +	if (r < 0) {
>  		pr_err("KVM-HV: kvmppc_uvmem_init failed %d\n", r);
> +		return r;
> +	}
> =20
> -	return r;
> +	kvm_ops_hv.owner =3D THIS_MODULE;
> +	kvmppc_hv_ops =3D &kvm_ops_hv;
> +
> +	return 0;
>  }
> =20
>  static void kvmppc_book3s_exit_hv(void)
> --=20
> 2.33.1
>=20
>=20
