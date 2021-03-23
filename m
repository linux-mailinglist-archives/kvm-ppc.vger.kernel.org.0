Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F57345565
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 03:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCWCNq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 22:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhCWCNk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 22:13:40 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D754CC061756
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 19:13:39 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F4FKD3WGGz9sVS; Tue, 23 Mar 2021 13:13:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1616465616;
        bh=BOuWa8UaE7ECNbJjXx2pAKCGGhQFwDrno0GolRKA3tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gryQmbGNnM+eICmH6gcaPFrTGPObJJRRRaVwlNzbf45Qdb0e/7mdQzVVRYr+Q7pbB
         zZ8Kv2wFreSSe8C45J0qcDcU1a2TsvOtZE+UroS+qLoFuaCIy4BpCmFWSvMj4dAeHF
         8llPGXbbLioyNgO+hHvSGaXiZCG96lHcSdE60+BE=
Date:   Tue, 23 Mar 2021 12:24:36 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v6 2/6] powerpc/book3s64/radix: Add H_RPT_INVALIDATE
 pgsize encodings to mmu_psize_def
Message-ID: <YFlDVCMpMW4ofP7D@yekko.fritz.box>
References: <20210311083939.595568-1-bharata@linux.ibm.com>
 <20210311083939.595568-3-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZBgd1eIUYKsIz9Dp"
Content-Disposition: inline
In-Reply-To: <20210311083939.595568-3-bharata@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--ZBgd1eIUYKsIz9Dp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2021 at 02:09:35PM +0530, Bharata B Rao wrote:
> Add a field to mmu_psize_def to store the page size encodings
> of H_RPT_INVALIDATE hcall. Initialize this while scanning the radix
> AP encodings. This will be used when invalidating with required
> page size encoding in the hcall.
>=20
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Having the table be the source of truth and implementing
psize_to_rpti_pgsize() in terms of it would be nicer.  But... I guess
you can't really do that, because you're dynamically initializing the
table from the device tree, but the device tree doesn't include the
RPTI encodings.  Oh well.

Reveiwed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  arch/powerpc/include/asm/book3s/64/mmu.h | 1 +
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 5 +++++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/incl=
ude/asm/book3s/64/mmu.h
> index eace8c3f7b0a..c02f42d1031e 100644
> --- a/arch/powerpc/include/asm/book3s/64/mmu.h
> +++ b/arch/powerpc/include/asm/book3s/64/mmu.h
> @@ -19,6 +19,7 @@ struct mmu_psize_def {
>  	int		penc[MMU_PAGE_COUNT];	/* HPTE encoding */
>  	unsigned int	tlbiel;	/* tlbiel supported for that page size */
>  	unsigned long	avpnm;	/* bits to mask out in AVPN in the HPTE */
> +	unsigned long   h_rpt_pgsize; /* H_RPT_INVALIDATE page size encoding */
>  	union {
>  		unsigned long	sllp;	/* SLB L||LP (exact mask to use in slbmte) */
>  		unsigned long ap;	/* Ap encoding used by PowerISA 3.0 */
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/b=
ook3s64/radix_pgtable.c
> index 98f0b243c1ab..1b749899016b 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -486,6 +486,7 @@ static int __init radix_dt_scan_page_sizes(unsigned l=
ong node,
>  		def =3D &mmu_psize_defs[idx];
>  		def->shift =3D shift;
>  		def->ap  =3D ap;
> +		def->h_rpt_pgsize =3D psize_to_rpti_pgsize(idx);
>  	}
> =20
>  	/* needed ? */
> @@ -560,9 +561,13 @@ void __init radix__early_init_devtree(void)
>  		 */
>  		mmu_psize_defs[MMU_PAGE_4K].shift =3D 12;
>  		mmu_psize_defs[MMU_PAGE_4K].ap =3D 0x0;
> +		mmu_psize_defs[MMU_PAGE_4K].h_rpt_pgsize =3D
> +			psize_to_rpti_pgsize(MMU_PAGE_4K);
> =20
>  		mmu_psize_defs[MMU_PAGE_64K].shift =3D 16;
>  		mmu_psize_defs[MMU_PAGE_64K].ap =3D 0x5;
> +		mmu_psize_defs[MMU_PAGE_64K].h_rpt_pgsize =3D
> +			psize_to_rpti_pgsize(MMU_PAGE_64K);
>  	}
> =20
>  	/*

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ZBgd1eIUYKsIz9Dp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBZQ1MACgkQbDjKyiDZ
s5JFRRAA0oOFK9Q84n+MtxUJ7MAHvqkQaqSlF76S3JMuUqh2zpZJRZHmESXo2ZBL
1ZkpZUlHXbUo3yJYmVPQ9j8WPFegkyai+dvIuMFxc/DmB3WHEmHZfvfqsV5k4iy0
FceHtu1jtln45MQA1L/yqm6nCoCHMfan/rE12rt+q8wyf+3CHH0iccAFUoTZGguz
iOtw7ud4LxhpCGmSiiy2K9HsPSdhacraHXTIqrjuUw+wxfYSG0+R6DqWkByeAgK2
VQVGrEX0uzL/woRTuaFrcI8BnSVICofuyfaZH1mIDQabLYnk4eAhvNSPwY44xWUS
LpYAcMkNe/E6dnMqhbhcfn9xTzpWEAfKzLjGfoaAq8xsZCNAUIQQIqWgc+cceXX0
OWhaJPH4EvHPzdtGRvRotNsPXjyYf+qKL47y9TgHOxPYye4BSS6eGbW9Ecj2T2by
XNo+auFgR+BjtxaC1C/ewSMVAggB9NkARDhDCrpaI5D5rK/SMoSBSLm0AoFJVmID
T32cqyPh7zg69/CSMy5GLyfRclTSfVUfDmixg/yzr5z745/b84lGU9h9v7kLD0z6
f6fKWqDh/yKb7B9giM27wmW4IzI8+mwQNO4cMkyFGoafkTC4uNR/ddbFf/X9yfCu
HNZypYJpfsfIKXvtNKnkrC/MfAcLlWSUcLjCx3mCAZ66+jwMVGc=
=tCbh
-----END PGP SIGNATURE-----

--ZBgd1eIUYKsIz9Dp--
