Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF173704E9
	for <lists+kvm-ppc@lfdr.de>; Sat,  1 May 2021 04:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhEACFi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 30 Apr 2021 22:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhEACFi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 30 Apr 2021 22:05:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2360AC06174A
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Apr 2021 19:04:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ge1so48126pjb.2
        for <kvm-ppc@vger.kernel.org>; Fri, 30 Apr 2021 19:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=OqlARIZFGaQEYSUN7r1N3UZjjucgcBkK/+tx6C+Zyu4=;
        b=Il8/p3uUo1d9BjKXjJz9vrAE7TpJmC4eoYx7tZ3r7iaelPrbc3PqnO4iFXsahEXU2x
         RYsUaf+kPEK6o2rv2Izl0zM73SaE55AwnA7bM7q4DegJL6AZe1dUhYQSU6ooxz8B9vZt
         luuSHN+X0Vg0dpuLeFTotZRVOyLV62KYanxZDvd33MNS6E02iFRBC+XXgH346E9GteIH
         SY7iN4IL25wTOSb8QsavA6w+ZJ5C4DRLllqRbK7JyKQ7cojTD6MSeR5qn8ZnZL4/ICDp
         7njhP6MxhNCFFeZoKLBAzPzrS147mvzGsGNOk/Bu2I6XE0rmWESlwoRBAFYoIoaV3RJG
         emLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=OqlARIZFGaQEYSUN7r1N3UZjjucgcBkK/+tx6C+Zyu4=;
        b=Jn5Zpp1LamAFwEWdUXUn+pZJoqwEn6BjBnBD1CP/jCbTVaJpc794k64vBF2vWocF6G
         6Q1W/P0/DFhE5Wy8ABO1GSa3y0PJ+0pGyCWOaDNdkWUSnDvt5kjreI8EQ3FRAZ8oHg8R
         GMPOIBZbKC3G+QTyD9U9Xwri/uTg+J/GuNjr3VX6kFA7Dm5pzIu4fI7Hw8pI0/rJiQaG
         XUthiRhbBKKELPDMcOeSLF0G0rUmI2IL94cn9cWXCo2TXtC5mLxONobv7DMPZgby26uW
         VlhOqu/k/IgTACEpbTyeHkTCoydttVDt6fCm7fBmRl6S4sKbv9M38a74xzH7KCbaqnCo
         GHOQ==
X-Gm-Message-State: AOAM533X2zOQsFtOCQ5sNRdAZDJXihN2PLOfuwNyI4W1kfEMJWxsgHu/
        F716ad8jQziA4ulRO79FNXs=
X-Google-Smtp-Source: ABdhPJxo3OsZ9dn384DmMOWfnFR5URsVUNBG17f/wxigK1KU6u2h9Je/gIqOc+vWg1qWmhTPzayGTg==
X-Received: by 2002:a17:90a:c28e:: with SMTP id f14mr8460177pjt.56.1619834688530;
        Fri, 30 Apr 2021 19:04:48 -0700 (PDT)
Received: from localhost ([61.68.127.20])
        by smtp.gmail.com with ESMTPSA id e2sm3118070pjk.31.2021.04.30.19.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 19:04:48 -0700 (PDT)
Date:   Sat, 01 May 2021 12:04:43 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 2/2] KVM: PPC: Book3S HV: Stop forwarding all HFSCR
 cause bits to L1
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
References: <20210415230948.3563415-1-farosas@linux.ibm.com>
        <20210415230948.3563415-3-farosas@linux.ibm.com>
In-Reply-To: <20210415230948.3563415-3-farosas@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1619834387.ttgzg40bpb.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Oh sorry, I didn't skim this one before replying to the first.

Excerpts from Fabiano Rosas's message of April 16, 2021 9:09 am:
> Since commit 73937deb4b2d ("KVM: PPC: Book3S HV: Sanitise hv_regs on
> nested guest entry") we have been disabling for the nested guest the
> hypervisor facility bits that its nested hypervisor don't have access
> to.
>=20
> If the nested guest tries to use one of those facilities, the hardware
> will cause a Hypervisor Facility Unavailable interrupt. The HFSCR
> register is modified by the hardware to contain information about the
> cause of the interrupt.
>=20
> We have been returning the cause bits to the nested hypervisor but
> since commit 549e29b458c5 ("KVM: PPC: Book3S HV: Sanitise vcpu
> registers in nested path") we are reducing the amount of information
> exposed to L1, so it seems like a good idea to restrict some of the
> cause bits as well.
>=20
> With this patch the L1 guest will be allowed to handle only the
> interrupts caused by facilities it has disabled for L2. The interrupts
> caused by facilities that L0 denied will cause a Program Interrupt in
> L1.

I'm not sure if this is a good solution. This would be randomly killing=20
guest processes or kernels with no way for them to understand what's going
on or deal with it.

The problem is really a nested hypervisor mismatch / configuration=20
error, so it should be handled between the L0 and L1. Returning failure
from H_ENTER_NESTED, for example (which is probe-able, but not really=20
any less probe-able than this approach).

Thanks,
Nick

>=20
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_nested.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3=
s_hv_nested.c
> index 270552dd42c5..912a2bcdf7b0 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -138,6 +138,23 @@ static void save_hv_return_state(struct kvm_vcpu *vc=
pu, int trap,
>  	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
>  		hr->heir =3D vcpu->arch.emul_inst;
>  		break;
> +	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
> +	{
> +		u8 cause =3D vcpu->arch.hfscr >> 56;
> +
> +		WARN_ON_ONCE(cause >=3D BITS_PER_LONG);
> +
> +		if (hr->hfscr & (1UL << cause)) {
> +			hr->hfscr &=3D ~HFSCR_INTR_CAUSE;
> +			/*
> +			 * We have not restored L1 state yet, so queue
> +			 * this interrupt instead of delivering it
> +			 * immediately.
> +			 */
> +			kvmppc_book3s_queue_irqprio(vcpu, BOOK3S_INTERRUPT_PROGRAM);
> +		}
> +		break;
> +	}
>  	}
>  }
> =20
> --=20
> 2.29.2
>=20
>=20
