Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5477B32B107
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Mar 2021 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhCCAmo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Mar 2021 19:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442329AbhCBCM0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Mar 2021 21:12:26 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26BEC061788
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Mar 2021 18:11:38 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DqLGb1p5Sz9sVt; Tue,  2 Mar 2021 13:11:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1614651095;
        bh=9cUWbWxmFz8RGUO2eFgwLm2hQP7G5/Wfu8oqpSqV5ok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c7K2sovU4+y+3Bz1BEsk4gx3HvUW/LRzMks5UdP2HNMlrTiSDu2N+FRl1zpa5Kc0W
         BQlN9qAk/f94p1xpn2x5BY0zAqd6MF8kKalV5sr2Re9O3iD9kBV8jYgAodzv0CxNsZ
         nYTRNSXIFEcZIk43oq8HLMFRUoI/JX+EPHPqJ2ME=
Date:   Tue, 2 Mar 2021 12:28:34 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v5 1/3] powerpc/book3s64/radix: Add H_RPT_INVALIDATE
 pgsize encodings to mmu_psize_def
Message-ID: <YD2UwhaweIpImZDv@yekko.fritz.box>
References: <20210224082510.3962423-1-bharata@linux.ibm.com>
 <20210224082510.3962423-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="18DvU1Ut+qwRBBx8"
Content-Disposition: inline
In-Reply-To: <20210224082510.3962423-2-bharata@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--18DvU1Ut+qwRBBx8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 24, 2021 at 01:55:08PM +0530, Bharata B Rao wrote:
> Add a field to mmu_psize_def to store the page size encodings
> of H_RPT_INVALIDATE hcall. Initialize this while scanning the radix
> AP encodings. This will be used when invalidating with required
> page size encoding in the hcall.
>=20
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
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

Hm.  TBH, I was thinking of this as replacing psize_to_rpti_pgsize() -
that is, you directly put the correct codes in there, then just have
psize_to_rpti_pgsize() look them up in the table.

I guess that could be a followup change, though.

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

--18DvU1Ut+qwRBBx8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmA9lL8ACgkQbDjKyiDZ
s5KTSRAAvHF3cyDzkOXLMOCCQFszhE6hM+X6EehG0kHdq6PF1nw1pa3l81CEzdXo
LQiPU21/Ju83fZrGukMCOTWNQ7wDxYia/BOdUHAsAGKx+vh6KRei3IO1qyq+pUUr
1jZYtU+zvoR7vm7UZ2alYbgHyZbgtWEwmuVx8Y0B2i5i3mdKzfWu74lEwDmpNuNw
6TBeS4BdUs6HKnmmF+U5XQfrHkNM+Rrhr+d+C68tJstUptwasmImd818alYDDgji
kN5BAlLjbWP0TqkdBasFpq5T6UZ5tgLMgBiuYHASs/oNXu44fjKFMikIn3NveYqX
FMfgg7H1n6RPGOs6Qoi6L8sgGSdaorHxOsfz4ZpYwU7Y3MESnwQK3OiX/oQHZnmL
0edJARtIw3iYJvm0ZyS0h82uFkIAGiEKHUaUSVjQ3QI2mCnF2/unmey7ljcr7c82
uqev21VbcbBj2YQTYjU8UVYqbfSp2JqlLcHvoG9+vhveLv86Q8koBnT/cN7Foy9U
5siQemCC2bcwXnDax+f/x9XpKBhlALRHe3yaMYBXSEOY5jh5KbXICQoCIVmuYQuk
gLnVMDpyStezFAYoyf3On+KutokhRu+/0i8hoWFdKAzYtXk0PV+QyqL71l1Uash6
SP2Ieaq8Vettmn0XObjMwty3ACGlW+5DKnFget73dazi2g/I+Ig=
=smtG
-----END PGP SIGNATURE-----

--18DvU1Ut+qwRBBx8--
