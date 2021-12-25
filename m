Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946E47F2E0
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhLYKMb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhLYKMa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:12:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9222DC061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:12:30 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so10243019pjp.0
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=jSLMI+swcvFHPJkOVD0EgcDum0m3RTXwA5m9h03P6Qo=;
        b=bptPorC3YmKkBbB0HNIE3hk65qb3ngCvsexK96XHRSZx03YYgQ/Nlj0GlVxIT3/MjI
         PW+F25WIHfFcdpkr+M0Cb8Q4DA/GsOhPEo2CSWRoiZbGYZyGIB7QgnC0Dpc0IsHYHCAd
         2HdeFHwmaGzjzUELfXOa+QF3oBmk0iJo1Oc+r4faSK/hiVfmLn7694UkO9XQyOe7PgRb
         pSqh2teO+41Sg0fqMPXnpmc1BtwAdTlaNgSoLBfo0mpMUjQlLG25uklIgPsym2idMnXq
         bn7xlNYMUWHO2mZO1GVsxI7oKieP/frOD/wPlujELR6VKnxL5YNs8Yxf3UpiEAOk+h5S
         cFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=jSLMI+swcvFHPJkOVD0EgcDum0m3RTXwA5m9h03P6Qo=;
        b=lkhfqvNcWVMArP5F06czVfoLt6tHg/F/haE7xWNRSBHPf56r18DOLTDRo+BqggOnpQ
         buIHCYy/Fyo0ZNKnKm6jigb1GRuS1tJujBwzZhMrjNZT6Tb/v86YsQtw5F1dYPNw2UDB
         9RyPF61CJYtq3UItcbRepIOTrGyy+UVTeLqeNBSjpBqdN7UlmH/RSyjOW2MMCYOrtvuY
         LhAVxd0mgqrm7jiGOND/u6XERwvl5B3rXLFE2KJ8JbB/aPJeL5o/7UkCmmzyU94I+IEu
         sKArmCSoJG5S8k0ZGOUMwTbbgZpKP7J72WJH2oVW1lezGzXVWIV95OxqDVZ/wWHPW9eH
         cq6w==
X-Gm-Message-State: AOAM532+3rZ2f9FCxtmmwapBJxUQeK+ix7wGRIRw+tZopdRIAJjzzAZZ
        +a6swOATw/sRIL3hQx9R+HY=
X-Google-Smtp-Source: ABdhPJxFmMOXm1Fq1zCbSVfMSfhS9Nc0LvpLZy984QoCsONH9ZkF2hjHrvBDGjKcPuHqN/KN6yWZNw==
X-Received: by 2002:a17:902:ab1a:b0:148:b34f:5bee with SMTP id ik26-20020a170902ab1a00b00148b34f5beemr9727974plb.157.1640427150179;
        Sat, 25 Dec 2021 02:12:30 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id f20sm12408453pfe.166.2021.12.25.02.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:12:29 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:12:25 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/3] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
        <20211223211528.3560711-3-farosas@linux.ibm.com>
In-Reply-To: <20211223211528.3560711-3-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427087.r4g49fcnps.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
> The MMIO emulation code for vector instructions is duplicated between
> VSX and VMX. When emulating VMX we should check the VMX copy size
> instead of the VSX one.
>=20
> Fixes: acc9eb9305fe ("KVM: PPC: Reimplement LOAD_VMX/STORE_VMX instructio=
n ...")
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

Good catch. AFAIKS handle_vmx_store needs the same treatment? If you
agree then

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/kvm/powerpc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 1e130bb087c4..793d42bd6c8f 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1507,7 +1507,7 @@ int kvmppc_handle_vmx_load(struct kvm_vcpu *vcpu,
>  {
>  	enum emulation_result emulated =3D EMULATE_DONE;
> =20
> -	if (vcpu->arch.mmio_vsx_copy_nums > 2)
> +	if (vcpu->arch.mmio_vmx_copy_nums > 2)
>  		return EMULATE_FAIL;
> =20
>  	while (vcpu->arch.mmio_vmx_copy_nums) {
> --=20
> 2.33.1
>=20
>=20
