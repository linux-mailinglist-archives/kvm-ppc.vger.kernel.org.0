Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52BE39B898
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Jun 2021 13:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDMAs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Jun 2021 08:00:48 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47885 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhFDMAr (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 4 Jun 2021 08:00:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FxLrz73Vrz9sRK;
        Fri,  4 Jun 2021 21:58:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1622807940;
        bh=2ml3klkNwus4SU0Dam/CCynYgfqie3zsgq8Z4cIjbBM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kZRX9kk+WKeElSyn1u5vFJeYbiGrdZoM1q2Y/y2FGnoDW8qGvWF0dasdmqnjov4UM
         e1m529FhfzkDQ25ykm6y2NdxtkcmCWMxgzXHEiQqqTgCfc290q2vM/JKsfsxt80cQv
         KRCD2NblXi3YlSCcP5d5j3fFDT8L8on04Tu8Q0oEKODIUf6CF2c/ofFeVhRuAggQwN
         dLb49Bj9vjS9J2+LN8XfgRA+WxOEFiqPIzKLhn9AZe2ttdWM/IJ2ROe9O1ZYhZskqQ
         3Zl7XeJ966yPbgAKLqKcDyMu5Hlfd7Tv2b/V2wBX7p83QUx+yuxm3DcQ6jhiRbWQqD
         nabS6qj/0I63A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     yangerkun <yangerkun@huawei.com>, paulus@ozlabs.org,
        benh@kernel.crashing.org
Cc:     kvm-ppc@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH] KVM: PPC: Book3S PR: remove unused define in
 kvmppc_mmu_book3s_64_xlate
In-Reply-To: <20210604081303.3701171-1-yangerkun@huawei.com>
References: <20210604081303.3701171-1-yangerkun@huawei.com>
Date:   Fri, 04 Jun 2021 21:58:58 +1000
Message-ID: <87lf7pg7st.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

yangerkun <yangerkun@huawei.com> writes:
> arch/powerpc/kvm/book3s_64_mmu.c:199:6: warning: variable =E2=80=98v=E2=
=80=99 set but
> not used [-Wunused-but-set-variable]
>   199 |  u64 v, r;
>       |      ^
>
> Fix it by remove the define.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  arch/powerpc/kvm/book3s_64_mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_6=
4_mmu.c
> index 26b8b27a3755..feee40cb2ba1 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu.c
> @@ -196,7 +196,7 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu=
 *vcpu, gva_t eaddr,
>  	hva_t ptegp;
>  	u64 pteg[16];
>  	u64 avpn =3D 0;
> -	u64 v, r;
> +	u64 r;
>  	u64 v_val, v_mask;
>  	u64 eaddr_mask;
>  	int i;
> @@ -285,7 +285,6 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu=
 *vcpu, gva_t eaddr,
>  		goto do_second;
>  	}
>=20=20
> -	v =3D be64_to_cpu(pteg[i]);
>  	r =3D be64_to_cpu(pteg[i+1]);
>  	pp =3D (r & HPTE_R_PP) | key;
>  	if (r & HPTE_R_PP0)

The obvious question being "does it not check v?!"

But we already did it further up:

	for (i=3D0; i<16; i+=3D2) {
		u64 pte0 =3D be64_to_cpu(pteg[i]);
		u64 pte1 =3D be64_to_cpu(pteg[i + 1]);

		/* Check all relevant fields of 1st dword */
		if ((pte0 & v_mask) =3D=3D v_val) {
                	...
			found =3D true;


So I guess we don't need the value of v for anything else, so this patch
is probably good.

cheers
