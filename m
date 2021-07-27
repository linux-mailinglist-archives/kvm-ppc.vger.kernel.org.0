Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895A03D6C5C
	for <lists+kvm-ppc@lfdr.de>; Tue, 27 Jul 2021 05:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhG0C3T (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 26 Jul 2021 22:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbhG0C3T (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 26 Jul 2021 22:29:19 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66FDFC061757
        for <kvm-ppc@vger.kernel.org>; Mon, 26 Jul 2021 20:09:47 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k4-20020a17090a5144b02901731c776526so2062167pjm.4
        for <kvm-ppc@vger.kernel.org>; Mon, 26 Jul 2021 20:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=RfMfAd8vk9ucuSiYD8/T4BjZj1PqGA8EST1H4ubJKo4=;
        b=nZh2s2qBDDJVUSzO7FUUhXtI0fm3DMB8U1Y3b+zPd/wgmfpcMSoeLArFGe53TJVuq2
         o6o2bcQJ6guK2/gC6hFtKksdgfyvO2QaI/68wWIm93IG2RnlEpnLACgppm1Lj6nkYo4a
         xy6N+Md+kjcb1/iTWRkn6aC91ab8diPhox4gMUXyZRMyYKb2ZlTYiBKqaNTdWQzdTx0K
         SxNXhahAEfyKz2XQuEhT2ieitI0yWVGUpIw8v9Bro6pxoW6bBW0g64vBHy0Efbxbx5Ep
         lAbXCfUNWZL6Xq5oGN8fxsaTF95Xkmw41mORHRIAqgqhFIHosCU6tVe07JYpcR/iCA8s
         9/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=RfMfAd8vk9ucuSiYD8/T4BjZj1PqGA8EST1H4ubJKo4=;
        b=OLT5jVks75ldQQD9HamskoUTTPv+E4QjXojIEDc2VvlNpW7IXoKVi4Ii2V1rBzQj6a
         L4WezaWh+gXHOHNPSC/PWOnujSu744HXTlfciNsxBSq9sTLc8AHiQP9M7lqCXZs1HJYS
         J97Bi46zqLRJMF5mvlyEY1XKWZCMrYcPXKTu5o+0VUHxqofMy41NZiyNIQleyZ/9wVa5
         OofAVBTbVs2U0dLlHy76f7fByqhKLM9rp41xzAPvZ+Y+Y8ZPXxP+O5/5lKrvn/WTNuj+
         9C1j307H9FSV77m735cdshM1/YsQ+1UcVgo/DDAqUc9idt1JCCKv1442fzOUOxskZci4
         1w0w==
X-Gm-Message-State: AOAM5329j4V5cJnzrMm4zWCWmzFwKC/173RYTLKQViEM9Uw+jy77Yf+n
        pPio0t/WMiUJEGs0uI7DFjnYm1YW7MeEwg==
X-Google-Smtp-Source: ABdhPJytOkj/2jmDWUsqrHMD2un4k3BwnFkqgL8PEGXMVaiDTL9d5pdtiF9a2xEmAOfEak/MsjDeQQ==
X-Received: by 2002:a63:34a:: with SMTP id 71mr21297103pgd.289.1627355386968;
        Mon, 26 Jul 2021 20:09:46 -0700 (PDT)
Received: from localhost (60-242-181-102.static.tpgi.com.au. [60.242.181.102])
        by smtp.gmail.com with ESMTPSA id f3sm1508261pfk.206.2021.07.26.20.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 20:09:46 -0700 (PDT)
Date:   Tue, 27 Jul 2021 13:09:40 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v5 2/2] KVM: PPC: Book3S HV: Stop forwarding all HFUs to
 L1
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210726201710.2432874-1-farosas@linux.ibm.com>
        <20210726201710.2432874-3-farosas@linux.ibm.com>
In-Reply-To: <20210726201710.2432874-3-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1627355201.gqa4czyyxy.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of July 27, 2021 6:17 am:
> If the nested hypervisor has no access to a facility because it has
> been disabled by the host, it should also not be able to see the
> Hypervisor Facility Unavailable that arises from one of its guests
> trying to access the facility.
>=20
> This patch turns a HFU that happened in L2 into a Hypervisor Emulation
> Assistance interrupt and forwards it to L1 for handling. The ones that
> happened because L1 explicitly disabled the facility for L2 are still
> let through, along with the corresponding Cause bits in the HFSCR.
>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_nested.c | 32 +++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 8215dbd4be9a..d544b092b49a 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -99,7 +99,7 @@ static void byteswap_hv_regs(struct hv_guest_state *hr)
>  	hr->dawrx1 =3D swab64(hr->dawrx1);
>  }
> =20
> -static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
> +static void save_hv_return_state(struct kvm_vcpu *vcpu,
>  				 struct hv_guest_state *hr)
>  {
>  	struct kvmppc_vcore *vc =3D vcpu->arch.vcore;
> @@ -118,7 +118,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcp=
u, int trap,
>  	hr->pidr =3D vcpu->arch.pid;
>  	hr->cfar =3D vcpu->arch.cfar;
>  	hr->ppr =3D vcpu->arch.ppr;
> -	switch (trap) {
> +	switch (vcpu->arch.trap) {
>  	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
>  		hr->hdar =3D vcpu->arch.fault_dar;
>  		hr->hdsisr =3D vcpu->arch.fault_dsisr;
> @@ -128,9 +128,29 @@ static void save_hv_return_state(struct kvm_vcpu *vc=
pu, int trap,
>  		hr->asdr =3D vcpu->arch.fault_gpa;
>  		break;
>  	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
> -		hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
> -			     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
> -		break;
> +	{
> +		u8 cause =3D vcpu->arch.hfscr >> 56;

Can this be u64 just to help gcc?

> +
> +		WARN_ON_ONCE(cause >=3D BITS_PER_LONG);
> +
> +		if (!(hr->hfscr & (1UL << cause))) {
> +			hr->hfscr =3D ((~HFSCR_INTR_CAUSE & hr->hfscr) |
> +				     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
> +			break;
> +		}
> +
> +		/*
> +		 * We have disabled this facility, so it does not
> +		 * exist from L1's perspective. Turn it into a HEAI.
> +		 */
> +		vcpu->arch.trap =3D BOOK3S_INTERRUPT_H_EMUL_ASSIST;
> +		kvmppc_load_last_inst(vcpu, INST_GENERIC, &vcpu->arch.emul_inst);

Hmm, this doesn't handle kvmpc_load_last_inst failure. Other code tends=20
to just resume guest and retry in this case. Can we do that here?

> +
> +		/* Don't leak the cause field */
> +		hr->hfscr &=3D ~HFSCR_INTR_CAUSE;

This hunk also remains -- shouldn't change HFSCR for HEA, only HFAC.

Thanks,
Nick

