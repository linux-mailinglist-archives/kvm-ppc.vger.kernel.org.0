Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5BE2F8CD9
	for <lists+kvm-ppc@lfdr.de>; Sat, 16 Jan 2021 11:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAPKi4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 16 Jan 2021 05:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbhAPKiz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 16 Jan 2021 05:38:55 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3245AC061757
        for <kvm-ppc@vger.kernel.org>; Sat, 16 Jan 2021 02:38:15 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id z21so7722190pgj.4
        for <kvm-ppc@vger.kernel.org>; Sat, 16 Jan 2021 02:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=Dv7ZtUGF5N76AH1yjyB/TMo+vv8bzhaMc3Fq9dVsxRE=;
        b=Osq5c9+/2WPZg3KAPAK8VrG6lV8UpWky3+vpo4bIrYuOCyc04jjrNzTkUdFJC7s+oc
         OyYpk8xvorFh51DPvrGsBaUF94I4s98FpmGXLTl8Aht5SeQ2hLaXi8Za36WNzrJXNedG
         BKBigJ7PaU8CkT7fOfDOHq99rCSFp/z2Va59PDgcB+WrevHcLyhKc2qlccUtWFK4tLUh
         5bQyO6idm7NSlck4Zk3Q/pNrmFR0iUmvPbqjmRviXJsHl0bdKGXKuxmhNFcMED+pt8N1
         bD0GcQQdTaDJYExa9VYpBqlXK3FU0uVL6nik0sArN6e0tefxMxo/lTzolufxxEyzviTn
         EvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=Dv7ZtUGF5N76AH1yjyB/TMo+vv8bzhaMc3Fq9dVsxRE=;
        b=qGsQdPZmfPlNyEyqQGIoYcnPHUUlSVgrLcWdJBPXT5Pb1wvDBtQddgGgi+8SDJj8D2
         dVGUK/+LEUsxxnp+4g2CunEFJ5In9MezTkO1WobYl0YzFzEY9WneZDF9wHK876TvgSDc
         6pjUORDYzVGIjnJ1z9+bJSRVlF9V5+vrfE2hu6djvu3hXbxlO3+Qy6iFwBFGzpqPei91
         QCNg3ekh4yFdHMQGk2PerlJbkPow4tE7kcYeSdqpCW4uSK1HkINs01Kykm6g0m2QKjLh
         Ne9je98ElPAzJMGmGiaqVDoh18DtLMxB4JFfhmKddiW/f6WWqzWmnTU7XqCY3GBpwblI
         QKfA==
X-Gm-Message-State: AOAM531tQw3i3awVyzW2JnNjfGIkZU9bd/FxkVXzR5QKS7LJfYpbmrDR
        znKhB7WsUfLdbZXp3QrujBk=
X-Google-Smtp-Source: ABdhPJw/arx1cHJ4qBao6kLXDqM4y4YOSqdKGExCN8Evh5w6/aXWgW694RePyU3ekFPBjG+Ty9JZVg==
X-Received: by 2002:a65:6450:: with SMTP id s16mr16796698pgv.71.1610793494788;
        Sat, 16 Jan 2021 02:38:14 -0800 (PST)
Received: from localhost ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id a11sm11040894pfr.198.2021.01.16.02.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 02:38:14 -0800 (PST)
Date:   Sat, 16 Jan 2021 20:38:09 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 01/39] KVM: PPC: Book3S HV: Context tracking exit guest
 context before enabling irqs
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        kvm-ppc@vger.kernel.org
References: <20210115165012.1260253-1-npiggin@gmail.com>
        <20210115165012.1260253-2-npiggin@gmail.com>
In-Reply-To: <20210115165012.1260253-2-npiggin@gmail.com>
MIME-Version: 1.0
Message-Id: <1610793296.fjhomer31g.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Nicholas Piggin's message of January 16, 2021 2:49 am:
> Interrupts that occur in kernel mode expect that context tracking
> is set to kernel. Enabling local irqs before context tracking
> switches from guest to host means interrupts can come in and trigger
> warnings about wrong context, and possibly worse.

I think this is not actually a fix per se with context as it is today
because the interrupt handlers will save and update the state. It only=20
starts throwing warnings when moving to the more precise tracking
where kernel interrupts always expect context to be in kernel mode.

The patch stands on its own just fine, but I'll reword slightly and
move it in the series to where it's needed.

Thanks,
Nick

>=20
> Cc: kvm-ppc@vger.kernel.org
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 6f612d240392..d348e77cee20 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3407,8 +3407,9 @@ static noinline void kvmppc_run_core(struct kvmppc_=
vcore *vc)
> =20
>  	kvmppc_set_host_core(pcpu);
> =20
> +	guest_exit_irqoff();
> +
>  	local_irq_enable();
> -	guest_exit();
> =20
>  	/* Let secondaries go back to the offline loop */
>  	for (i =3D 0; i < controlled_threads; ++i) {
> @@ -4217,8 +4218,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
> =20
>  	kvmppc_set_host_core(pcpu);
> =20
> +	guest_exit_irqoff();
> +
>  	local_irq_enable();
> -	guest_exit();
> =20
>  	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
> =20
> --=20
> 2.23.0
>=20
>=20
