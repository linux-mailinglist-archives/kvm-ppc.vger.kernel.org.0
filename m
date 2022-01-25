Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F549AB77
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Jan 2022 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbiAYFPm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Jan 2022 00:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S252783AbiAYE3W (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 Jan 2022 23:29:22 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40844C061755
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:06:39 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w190so11851784pfw.7
        for <kvm-ppc@vger.kernel.org>; Mon, 24 Jan 2022 19:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=3MarfPCCwDfAVG2ZqExy3Ax3TYR2XgGtfygVHRV1F2E=;
        b=qkpWBBXkhVIfatt4l28lQipY/t3sa4euS13sDx2txHAnlEIzNPCDPWEw1IMKnvAW1S
         h8SnXCVyBZRi/r1LKkCyOvTaY0dZWKV4WsdY8T7vNetXg3DHRduVz7lzZuQhKcJHMRXo
         aEGt16VVItnTuiZ+OlV/H/gBqCKDGttgrlAFoCnYSfK7sM3Yi64kjIQ7AK940BEbmQaR
         UTWsOoCP+vfqZp0NNE3ZLw3CxQaOMJr84snmhgpiOo9OAnnPNIYt7Akve1WG+gD7r8gA
         XK0uNSkK2jgTlMxAMuIbWJynGHi41k46t4i1fuxW0T5vuq3v/qg3YIB+sc6DDgIXpi6r
         XyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=3MarfPCCwDfAVG2ZqExy3Ax3TYR2XgGtfygVHRV1F2E=;
        b=lwvLRJ7M5ducrWtMJZ4zC8G+6FPIPpTqi7lhzsE9/oXfTozwdhxdp6kfSVp/rftFlR
         qGktAAc9Hh4W3uh+fE7VQESvIyat04kvAe0DtAdis79fURLECVVWPZHNZ8WzfMrlmh76
         OfhEdly5rbkL9EynC9qV/fW2JzO2UOzUG63cS6OQGAo811iDynWWXCeKVkPXoNTXLnZk
         G9G+p7E6fvN5MBwL2J9inI3e58MsX8HdgKxHRrpDd1eRPZBEAw4k5pS3Ld3qt+X0CBfk
         WIFBKHVtZMljskaZylo1XdyMhbeQLfEWdxPrjHyQoJa8Oy6iJu9d1ymeE87GNPhvOC+N
         xcEQ==
X-Gm-Message-State: AOAM533sYGAplbFfxxQIoRnOwW1KU0AVkIbbRqAISQB9RfW7g/TaJHUy
        DEvaimNujm4N9m85zy3S/5U=
X-Google-Smtp-Source: ABdhPJxoBU+8IRslH4g6ljEVUVpcz4VUfMuCWAi9P/I29saDnqIOIb63QMY7CfB+A87pcsk9b8zdAA==
X-Received: by 2002:a05:6a00:cc2:b0:4c9:f07d:6abe with SMTP id b2-20020a056a000cc200b004c9f07d6abemr4559841pfv.17.1643079998563;
        Mon, 24 Jan 2022 19:06:38 -0800 (PST)
Received: from localhost (193-116-82-75.tpgi.com.au. [193.116.82.75])
        by smtp.gmail.com with ESMTPSA id q3sm3507213pfu.194.2022.01.24.19.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:06:38 -0800 (PST)
Date:   Tue, 25 Jan 2022 13:06:32 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v4 3/5] KVM: PPC: mmio: Reject instructions that access
 more than mmio.data size
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     aik@ozlabs.ru, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20220121222626.972495-1-farosas@linux.ibm.com>
        <20220121222626.972495-4-farosas@linux.ibm.com>
In-Reply-To: <20220121222626.972495-4-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1643079951.32ccbyeyjr.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 22, 2022 8:26 am:
> The MMIO interface between the kernel and userspace uses a structure
> that supports a maximum of 8-bytes of data. Instructions that access
> more than that need to be emulated in parts.
>=20
> We currently don't have generic support for splitting the emulation in
> parts and each set of instructions needs to be explicitly included.
>=20
> There's already an error message being printed when a load or store
> exceeds the mmio.data buffer but we don't fail the emulation until
> later at kvmppc_complete_mmio_load and even then we allow userspace to
> make a partial copy of the data, which ends up overwriting some fields
> of the mmio structure.
>=20
> This patch makes the emulation fail earlier at kvmppc_handle_load|store,
> which will send a Program interrupt to the guest. This is better than
> allowing the guest to proceed with partial data.
>=20
> Note that this was caught in a somewhat artificial scenario using
> quadword instructions (lq/stq), there's no account of an actual guest
> in the wild running instructions that are not properly emulated.
>=20
> (While here, remove the "bad MMIO" messages. The caller already has an
> error message.)
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  arch/powerpc/kvm/powerpc.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index c2bd29e90314..27fb2b70f631 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1114,10 +1114,8 @@ static void kvmppc_complete_mmio_load(struct kvm_v=
cpu *vcpu)
>  	struct kvm_run *run =3D vcpu->run;
>  	u64 gpr;
> =20
> -	if (run->mmio.len > sizeof(gpr)) {
> -		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
> +	if (run->mmio.len > sizeof(gpr))
>  		return;
> -	}
> =20
>  	if (!vcpu->arch.mmio_host_swabbed) {
>  		switch (run->mmio.len) {
> @@ -1236,10 +1234,8 @@ static int __kvmppc_handle_load(struct kvm_vcpu *v=
cpu,
>  		host_swabbed =3D !is_default_endian;
>  	}
> =20
> -	if (bytes > sizeof(run->mmio.data)) {
> -		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> -	}
> +	if (bytes > sizeof(run->mmio.data))
> +		return EMULATE_FAIL;
> =20
>  	run->mmio.phys_addr =3D vcpu->arch.paddr_accessed;
>  	run->mmio.len =3D bytes;
> @@ -1325,10 +1321,8 @@ int kvmppc_handle_store(struct kvm_vcpu *vcpu,
>  		host_swabbed =3D !is_default_endian;
>  	}
> =20
> -	if (bytes > sizeof(run->mmio.data)) {
> -		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
> -		       run->mmio.len);
> -	}
> +	if (bytes > sizeof(run->mmio.data))
> +		return EMULATE_FAIL;
> =20
>  	run->mmio.phys_addr =3D vcpu->arch.paddr_accessed;
>  	run->mmio.len =3D bytes;
> --=20
> 2.34.1
>=20
>=20
