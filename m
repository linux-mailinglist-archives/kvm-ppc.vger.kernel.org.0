Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59BF47F2E3
	for <lists+kvm-ppc@lfdr.de>; Sat, 25 Dec 2021 11:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhLYKQj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Dec 2021 05:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhLYKQj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Dec 2021 05:16:39 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B44C061401
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:16:39 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 196so9514538pfw.10
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Dec 2021 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=AiLBuSRxPrOC9G+ecpzrT+nfcX/wNK5T9ujCVDlu8KE=;
        b=fAYdn9PyWyIqj3OH+YtDuI5yLgQDLK6FnMg/THs8eW5a8LhrRGBb0YUcyyVvfueX32
         nVJ4TdBQZ9ADwrsnHLIKxKuSs7ptFCh+XGBdwOSk0LmlIwwHfExQwSKth6WONvqi+ia6
         MYvzE9t9qoy88gqb6SoqifFV7esV++Th6xqgnm2Eyw4nttdgIq/5MwgzgDPcCQodN0Xk
         rEGV74fj/frefWqUP0g1mV1LW7acsaQpP1luQ88Vg49JvnuS7cQzA4fJuu4Fy6h+jcqW
         vSigyoARse5m+7LtOdyaPXp8F7BqfPKwoO2N++nBqwDC9MwCp0Ex81nwqqYx74J3ZHJe
         wqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=AiLBuSRxPrOC9G+ecpzrT+nfcX/wNK5T9ujCVDlu8KE=;
        b=PjvEPgU2C9erhuEu8ClIaJHCTuZYV5QIIoP9czQAr7DIt46O5kvNwcCB5AcX7K+sXh
         r5LvkRTJnx/WSJIUZm2a8cUsAWzodnE+/xR62LXS/woalQv7NQQ2Sm1k1QwNOfehHdnZ
         /mGH50MFxMa54H3KqtnvFaE98c2qsaHA4jXqlHqYJ240V9mTTt+BRhF/KmP1UAbPOs5E
         hKZf9heM/ptK88h+mIaO03Evw5+PMVeu+Ysb0qCzHITKCTgRF6wBB7v8N4l+qSh9wHwq
         doOngOtfrz78J6XRt4zKuDyEM2BTm+JfaFb7FHze78yuFc39V+p1AknsdfLx2TIbEWe7
         cMwQ==
X-Gm-Message-State: AOAM533QDdrs9f0xnongVXa2BFViczxkUrbksW6n4GEmrynXcIMq63qg
        lP9wRycbBrXiP5voUlHIxhk=
X-Google-Smtp-Source: ABdhPJyFPV+d6OnL1RxRjtWxEAE4KAyN3wF7hUCLdGI3gvZZYJ07qiGz65Cg+e/tXdpt9iWtc/ZSYg==
X-Received: by 2002:a63:6c03:: with SMTP id h3mr8943567pgc.458.1640427398948;
        Sat, 25 Dec 2021 02:16:38 -0800 (PST)
Received: from localhost (121-44-67-22.tpgi.com.au. [121.44.67.22])
        by smtp.gmail.com with ESMTPSA id c9sm11372447pfb.126.2021.12.25.02.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Dec 2021 02:16:38 -0800 (PST)
Date:   Sat, 25 Dec 2021 20:16:34 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 3/3] KVM: PPC: Fix mmio length message
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20211223211528.3560711-1-farosas@linux.ibm.com>
        <20211223211528.3560711-4-farosas@linux.ibm.com>
In-Reply-To: <20211223211528.3560711-4-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1640427230.38pm5r9iop.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of December 24, 2021 7:15 am:
> We check against 'bytes' but print 'run->mmio.len' which at that point
> has an old value.
>=20
> e.g. 16-byte load:
>=20
> before:
> __kvmppc_handle_load: bad MMIO length: 8
>=20
> now:
> __kvmppc_handle_load: bad MMIO length: 16
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>

This patch fine, but in the case of overflow we continue anyway here.
Can that overwrite some other memory in the kvm_run struct?

This is familiar, maybe something Alexey has noticed in the past too?
What was the consensus on fixing it? (at least it should have a comment
if it's not a problem IMO)

Thanks,
Nick

> ---
>  arch/powerpc/kvm/powerpc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 793d42bd6c8f..7823207eb8f1 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1246,7 +1246,7 @@ static int __kvmppc_handle_load(struct kvm_vcpu *vc=
pu,
> =20
>  	if (bytes > sizeof(run->mmio.data)) {
>  		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> +		       bytes);
>  	}
> =20
>  	run->mmio.phys_addr =3D vcpu->arch.paddr_accessed;
> @@ -1335,7 +1335,7 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
> =20
>  	if (bytes > sizeof(run->mmio.data)) {
>  		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> +		       bytes);
>  	}
> =20
>  	run->mmio.phys_addr =3D vcpu->arch.paddr_accessed;
> --=20
> 2.33.1
>=20
>=20
