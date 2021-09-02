Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50183FE723
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Sep 2021 03:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhIBB3n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Sep 2021 21:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhIBB3l (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 1 Sep 2021 21:29:41 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE2C061575
        for <kvm-ppc@vger.kernel.org>; Wed,  1 Sep 2021 18:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1630546121;
        bh=RgHzcOwuQ4CV3C8nRK9MP+jkRJA9XMcQ4G0XWUSnVqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjRQwr5HFxCxQ3UBbSghNd/K8t48ExXeSfoU7c0p3543VcJj2if/4kttbR9tsgeTX
         A+SY27wLEWlxKieHJKenBdoSEnJMdIm3A37fzibYUmrrKaifLDNNEVEcrLsGLRbG3b
         d3AAXhaRnk3zzwvHPX5l590Pc/d5qthpkTEPJ5IY=
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4H0Nc96rTJz9sVw; Thu,  2 Sep 2021 11:28:41 +1000 (AEST)
Date:   Thu, 2 Sep 2021 11:28:34 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject: Re: [PATCH 0/5] KVM: PPC: Book3S: Modules cleanup and unification
Message-ID: <YTAownlTy46X4jGV@yekko>
References: <20210901173357.3183658-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cTM27LM3Y9l15LL2"
Content-Disposition: inline
In-Reply-To: <20210901173357.3183658-1-farosas@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--cTM27LM3Y9l15LL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 01, 2021 at 02:33:52PM -0300, Fabiano Rosas wrote:
> This series merges our three kvm modules kvm.ko, kvm-hv.ko and
> kvm-pr.ko into one kvm.ko module.

That doesn't sound like a good idea to me.  People who aren't on BookS
servers don't want - and can't use - kvm-hv.  Almost nobody wants
kvm-pr.  It's also kind of inconsistent with x86, which has the
separate AMD and Intel modules.

> The main reason for this is to deal with the issue that kvm.ko can be
> loaded on its own without any of the other modules present. This can
> happen if one or both of the modules fail to init or if the user loads
> kvm.ko only.
>=20
> With only kvm.ko loaded, the userspace can call any of the KVM ioctls
> which will fail more or less gracefully depending on what kind of
> verification we do in powerpc.c.

I see that that's awkward, but I'm not sure it justifies compromising
the actual natural structure of the dependencies.

> Instead of adding a check to every entry point or finding a hack to
> link the modules so that when one fails (hv/pr), the other (kvm)
> exits, I think it is cleaner to just make them all a single module.
>=20
> The two KVM implementations are already selected by Kconfig options,
> so the only thing that changes is that they are now in the same
> module. I also kept kvm-hv and kvm-pr as aliases to kvm, so that
> people don't get too surprised with the change.
>=20
> There is a possible issue with the larger module size for kernel
> builds that should support both HV-only and PR-only environments, but
> PR is usually not used in production so I'm not sure if that is a real
> issue.
>=20
> Patches 1,2,3 are standalone cleanups.
> Patches 4,5 are the unification work.
>=20
> Fabiano Rosas (5):
>   KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
>   KVM: PPC: Book3S HV: Delay setting of kvm ops
>   KVM: PPC: Book3S HV: Free allocated memory if module init fails
>   KVM: PPC: Book3S: Unify kvm-hv and kvm-pr modules
>   KVM: PPC: Book3S: Stop exporting non-builtin symbols
>=20
>  arch/powerpc/configs/powernv_defconfig |  2 +-
>  arch/powerpc/configs/ppc64_defconfig   |  2 +-
>  arch/powerpc/configs/pseries_defconfig |  2 +-
>  arch/powerpc/kvm/Kconfig               | 72 ++++++++++++--------------
>  arch/powerpc/kvm/Makefile              | 11 ++--
>  arch/powerpc/kvm/book3s.c              | 61 ++++++++++++++--------
>  arch/powerpc/kvm/book3s.h              | 19 +++++++
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  3 --
>  arch/powerpc/kvm/book3s_64_vio.c       |  3 --
>  arch/powerpc/kvm/book3s_hv.c           | 38 ++++++++------
>  arch/powerpc/kvm/book3s_pr.c           | 13 -----
>  arch/powerpc/kvm/book3s_rtas.c         |  1 -
>  arch/powerpc/kvm/book3s_xics.c         |  4 --
>  arch/powerpc/kvm/book3s_xive.c         |  6 ---
>  arch/powerpc/kvm/emulate.c             |  1 -
>  arch/powerpc/kvm/powerpc.c             | 14 -----
>  kernel/irq/irqdesc.c                   |  2 +-
>  17 files changed, 125 insertions(+), 129 deletions(-)
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--cTM27LM3Y9l15LL2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmEwKMAACgkQbDjKyiDZ
s5IJ8hAAxoqpnAeYoAekbeRGGod/ln+VczLwlefJzgGS2y9ZHs1nxpuP11S7VsfH
oyM8xZZJHQK5r3FIXpRHmhnYoUT5OZDdsCiZkPHZBqda4/AsZB93nGjtTtXOk34G
r48+0TWL35f3lAyPQhdK7WgU+DD0RxoDW4Vn1HGK7e+PXIak4UT4sM6j5oMjWTtL
hHw+ScgZNHa3/i4MHBcgfyYk5gbnV3n0AzkW1nVNu17uaowKommJ2tvNMBCEtuE+
4wUXaQ8vP21/LSj6TMA6rIX6/PhQrOOinfYbWsaOuuiW6j/0Qcrh/Ho9vyoIK9q7
kJSmCtrelqe55OMTA0BwBELv40bbxy9nbw1gS1rcb4ykDQsfQ51JVQZGzomal4vj
zih9VUJiE27mQAmqN3mEYWYVsMFuBtcIPb+GEhWId4EkMBFTChTqeiiznRzHLhal
QRIZ2+9iNDf+c9SVYbu8xXK4IUMaRQvXrzxFBE7NEZFWlFXNyUgCa8V2svPo8P5u
O24dKNB019FyUZ/6ynv0+a9wC4ce5/uCBg3xfhW/2V5Ncw1fApOiV/4eYoOuSD1h
wmld4S9LRJ6ElO8KCWiRRdUxl4yM4VWdN7GIcHXX8EPUti3CY8re2ehqNxqMaJpQ
4djK+MbZ6tRxgQEUqyX6cg7dpr/CVk1QbnysUt6pNysn0DIS29M=
=TeXO
-----END PGP SIGNATURE-----

--cTM27LM3Y9l15LL2--
