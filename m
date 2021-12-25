Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C647F2DE
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhLYKL2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhLYKL1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:11:27 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68739C061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:11:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso10210860pjb.1
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=0YHu/2JD1es6X2xdXKLmtOf+SLMnQKDA9EbCF6bIP2M=;
        b=fCOlEI4mu4NkFmdf2hu9TCYO1HJNFLtCoxA9r+vZO+DG1SSOnwjlGHZvsRgCrvoCcv
         sWL4e25EUSEfv9bfXQH40djFCX5czSWtOWDo01D5KuQ5SntxvsAa55DED2updJlXXHlD
         8beWWFDTabFrl2rtgggKteEa1ltjWix8gRnccqXi3dLHSheFz+7kMmFDHvt88f8oFiXU
         zSL/gK5a9Qv/7aNpbsdDdIYMTyq1ow+nri5EE4FWPrDBzaeBCU1MUjA1LkihJ4KexCEw
         1PNaPWqGQG8N5LLt02RbSursavIf8k9m+5ipO70qyOCNblU2Xd+Mt1hqow24l5pEowjT
         iq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=0YHu/2JD1es6X2xdXKLmtOf+SLMnQKDA9EbCF6bIP2M=;
        b=OWxZ1rbVuuPAcq9mRJbfAfOMjp0v9K0rBsgEC6ZHrgJIE6SM2yq8XduvM0R1XzR4dN
         gsvx8jykT4xzSYFY15ruiSOGkexoEuJ+v5D9bdvhzCJDMQ7i8h1S5Et1IZPZzOALVkGq
         mtGEVBjvE8IuKu9GBFDB/KEv1sxIgrKdnYQGPd8cia637HNaNUMFFP1xaLr9e2PiRrBq
         I2T0mK+g/2xk4KjqraItGoTdu4EEYRrs+Z5xqC0d7YKdQ27JKSdgjX33tEOkl+CiVPvT
         fovrdyWX2Fxcz9EM0foX3yIYT2vEy+AuFHQAouWcn6jtrQloL5fDzERq1zu7v7Nj3bzc
         09eg==
X-Gm-Message-State: AOAM5304xbCQex5XbrpJitrwjTxE6Rt350Cgtaqn5404jzlwEUI5IXl0
        wAisHDsftslfhhFfaeuV0TcmXU0fPOw=
X-Google-Smtp-Source: ABdhPJzs50zsQcRFLgvW45AQ26iOkp3IR2DKgvclOIjicDOFtboSMD/4oGY6K2nqq+XWQfbHgOH8Xg==
X-Received: by 2002:a17:90a:9a8a:: with SMTP id e10mr11778732pjp.145.1640427086981;
        Sat, 25 Dec 2021 02:11:26 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id om3sm13632155pjb.49.2021.12.25.02.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:11:26 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:11:21 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Stop returning internal values
 to userspace
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
        <20211223211528.3560711-2-farosas@linux.ibm.com>
In-Reply-To: <20211223211528.3560711-2-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427040.a29n3heze5.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
> Our kvm_arch_vcpu_ioctl_run currently returns the RESUME_HOST values
> to userspace, against the API of the KVM_RUN ioctl which returns 0 on
> success.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
> This was noticed while enabling the kvm selftests for powerpc. There's
> an assert at the _vcpu_run function when we return a value different
> from the expected.

That's nasty. Looks like qemu never touches the return value except if
it was < 0, so hopefully should be okay.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/kvm/powerpc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index a72920f4f221..1e130bb087c4 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1849,6 +1849,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  #ifdef CONFIG_ALTIVEC
>  out:
>  #endif
> +
> +	/*
> +	 * We're already returning to userspace, don't pass the
> +	 * RESUME_HOST flags along.
> +	 */
> +	if (r > 0)
> +		r =3D 0;
> +
>  	vcpu_put(vcpu);
>  	return r;
>  }
> --=20
> 2.33.1
>=20
>=20
