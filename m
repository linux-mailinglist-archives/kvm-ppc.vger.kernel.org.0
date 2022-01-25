Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641449ABC6
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 06:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiAYF3Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 00:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiAYF0x (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Jan 2022 00:26:53 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64CEC0680B7
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:46:48 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i8so17164909pgt.13
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=hdfuq5orHfQ7Meh7Q+w/wb92K0T1OSmlneesQnOCGLw=;
        b=Nnsomh0nAkQP2afbcT4BDzbs69ufgf7PlcxZxx4g02klymZtXja/L+QpVUofugbEQp
         gBOx8DpCL79kV+sR5WzmbtV4epgUl7o8E50Kc4Di4dH+P4yG7P1CNZ9lw9SIWDeBk63l
         Qf5rioNCGCvGN+ZKwUWHoac3tWXkXQTc24//QpGwN0VDr9i6NG8TadMs5pl7XeG6z/z0
         8Iax/ASBBNqSQRKKvD12yOjQNnCPpUplRV8MaTnRSi2A0g67pmpOClOox42JBvu4zCR1
         zEZcoq0/V6Qodq8vm+OPf1Upy7vIiWae4lRm/8Q7nsxLzrhGG2+ZKgqPG81ZV7Fg12fO
         bpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=hdfuq5orHfQ7Meh7Q+w/wb92K0T1OSmlneesQnOCGLw=;
        b=LicnuuXsXrFv+up8BXN1AuHKv9fMjhwm499WYcNIn6bAifkxWz63UMFxAMmCmshJCP
         ko37WZwSgJQLbi7tmcxNQZo5/d+pVzycVHoKsXe4WqcUe//1QE2yz3bY9XdKaBpBzfuZ
         XlOR1LRwsCPFprPdWDR05mexw0/jNaIVsL9KsAxbXWdRcz1g0XJOtPliDoqtNcAtP6I8
         uRIe/i0OxQoWjXQnj/U4E1dywVaMdc2WDY2Vtpg6689NJYuqep/8SZzHKpCp1lx/asZr
         +jWOIIOeMzPtKLQICFhCeihR0i0nV64r/iaQK8fzfBBqH/hwjo335jUcz7D8ylbsX2y4
         w8Kw==
X-Gm-Message-State: AOAM532nUvDuupjYYxZwrhhUJEYhVP4aTQvkNywJxLzex5QuR32jYhdH
        441Rw+xlsQEGaWjT6DI7++U=
X-Google-Smtp-Source: ABdhPJyD0Y0j9/n4jwFWWa7IXWOdQ4QXp4GO/c7YxFddK/jdTTiCgWbG57eXMt5zGOlBJLgyJSCV0g==
X-Received: by 2002:aa7:9217:0:b0:4bd:140:626c with SMTP id 23-20020aa79217000000b004bd0140626cmr16173152pfo.7.1643082408401;
        Mon, 24 Jan 2022 19:46:48 -0800 (PST)
Received: from localhost (193-116-82-75.tpgi.com.au. [193.116.82.75])
        by smtp.gmail.com with ESMTPSA id f10sm19003263pfe.29.2022.01.24.19.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:46:48 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:46:42 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: PPC: Decrement module refcount if init_vm
 fails
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220124220803.1011673-1-farosas@linux.ibm.com>
        <20220124220803.1011673-5-farosas@linux.ibm.com>
In-Reply-To: <20220124220803.1011673-5-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1643082153.tb99kluqtm.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 25, 2022 8:08 am:
> We increment the reference count for KVM-HV/PR before the call to
> kvmppc_core_init_vm. If that function fails we need to decrement the
> refcount.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
> Caught this while testing Nick's LPID patches by looking at
> /sys/module/kvm_hv/refcnt

Nice catch. Is this the only change in the series?

You can just use kvm_ops->owner like try_module_get() does I think? Also
try_module_get works on a NULL module same as module_put by the looks,
so you could adjust that in this patch to remove the NULL check so it
is consistent with the put.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks,
Nick


> ---
>  arch/powerpc/kvm/powerpc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 2ad0ccd202d5..4285d0eac900 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -431,6 +431,8 @@ int kvm_arch_check_processor_compat(void *opaque)
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
>  	struct kvmppc_ops *kvm_ops =3D NULL;
> +	int r;
> +
>  	/*
>  	 * if we have both HV and PR enabled, default is HV
>  	 */
> @@ -456,7 +458,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long =
type)
>  		return -ENOENT;
> =20
>  	kvm->arch.kvm_ops =3D kvm_ops;
> -	return kvmppc_core_init_vm(kvm);
> +	r =3D kvmppc_core_init_vm(kvm);
> +	if (r)
> +		module_put(kvm->arch.kvm_ops->owner);
> +	return r;
>  err_out:
>  	return -EINVAL;
>  }
> --=20
> 2.34.1
>=20
>=20
