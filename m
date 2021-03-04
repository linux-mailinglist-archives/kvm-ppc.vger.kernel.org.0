Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C9E32CD43
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 08:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhCDHBt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 02:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbhCDHB3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 02:01:29 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41730C061756
        for <kvm-ppc@vger.kernel.org>; Wed,  3 Mar 2021 23:00:49 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DrhbK20W3z9sR4; Thu,  4 Mar 2021 18:00:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1614841245;
        bh=U2gZc2Opg+F/zrldGGfkNZL5bTu3/iZrFLGq9bncXfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wccippap2uWT7QcA2DvCJTkVR90FriBXKjY5v+2Bbj/zteFF4k4/GpW2ouoXIee+M
         ZQGW5VtO7fSr9j2UjeOjCA8lYjtCETmPzwo2ZcFe1xIdxTS5LaADgqXkulfgR96pgd
         e/no2gUowDHSzS2K1BVrK8vOGRU6tmbqihSkO3+g=
Date:   Thu, 4 Mar 2021 18:00:14 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v5 1/3] powerpc/book3s64/radix: Add H_RPT_INVALIDATE
 pgsize encodings to mmu_psize_def
Message-ID: <YECFflv/P0fNyZrU@yekko.fritz.box>
References: <20210224082510.3962423-1-bharata@linux.ibm.com>
 <20210224082510.3962423-2-bharata@linux.ibm.com>
 <YD2UwhaweIpImZDv@yekko.fritz.box>
 <20210302042128.GB188607@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="doKkFUm6XtL+MBRx"
Content-Disposition: inline
In-Reply-To: <20210302042128.GB188607@in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--doKkFUm6XtL+MBRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 02, 2021 at 09:51:28AM +0530, Bharata B Rao wrote:
> On Tue, Mar 02, 2021 at 12:28:34PM +1100, David Gibson wrote:
> > On Wed, Feb 24, 2021 at 01:55:08PM +0530, Bharata B Rao wrote:
> > > Add a field to mmu_psize_def to store the page size encodings
> > > of H_RPT_INVALIDATE hcall. Initialize this while scanning the radix
> > > AP encodings. This will be used when invalidating with required
> > > page size encoding in the hcall.
> > >=20
> > > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> > > ---
> > >  arch/powerpc/include/asm/book3s/64/mmu.h | 1 +
> > >  arch/powerpc/mm/book3s64/radix_pgtable.c | 5 +++++
> > >  2 files changed, 6 insertions(+)
> > >=20
> > > diff --git a/arch/powerpc/include/asm/book3s/64/mmu.h b/arch/powerpc/=
include/asm/book3s/64/mmu.h
> > > index eace8c3f7b0a..c02f42d1031e 100644
> > > --- a/arch/powerpc/include/asm/book3s/64/mmu.h
> > > +++ b/arch/powerpc/include/asm/book3s/64/mmu.h
> > > @@ -19,6 +19,7 @@ struct mmu_psize_def {
> > >  	int		penc[MMU_PAGE_COUNT];	/* HPTE encoding */
> > >  	unsigned int	tlbiel;	/* tlbiel supported for that page size */
> > >  	unsigned long	avpnm;	/* bits to mask out in AVPN in the HPTE */
> > > +	unsigned long   h_rpt_pgsize; /* H_RPT_INVALIDATE page size encodin=
g */
> > >  	union {
> > >  		unsigned long	sllp;	/* SLB L||LP (exact mask to use in slbmte) */
> > >  		unsigned long ap;	/* Ap encoding used by PowerISA 3.0 */
> > > diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/=
mm/book3s64/radix_pgtable.c
> > > index 98f0b243c1ab..1b749899016b 100644
> > > --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> > > +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> > > @@ -486,6 +486,7 @@ static int __init radix_dt_scan_page_sizes(unsign=
ed long node,
> > >  		def =3D &mmu_psize_defs[idx];
> > >  		def->shift =3D shift;
> > >  		def->ap  =3D ap;
> > > +		def->h_rpt_pgsize =3D psize_to_rpti_pgsize(idx);
> > >  	}
> > > =20
> > >  	/* needed ? */
> > > @@ -560,9 +561,13 @@ void __init radix__early_init_devtree(void)
> > >  		 */
> > >  		mmu_psize_defs[MMU_PAGE_4K].shift =3D 12;
> > >  		mmu_psize_defs[MMU_PAGE_4K].ap =3D 0x0;
> > > +		mmu_psize_defs[MMU_PAGE_4K].h_rpt_pgsize =3D
> > > +			psize_to_rpti_pgsize(MMU_PAGE_4K);
> >=20
> > Hm.  TBH, I was thinking of this as replacing psize_to_rpti_pgsize() -
> > that is, you directly put the correct codes in there, then just have
> > psize_to_rpti_pgsize() look them up in the table.
> >=20
> > I guess that could be a followup change, though.
> >=20
> > > =20
> > >  		mmu_psize_defs[MMU_PAGE_64K].shift =3D 16;
> > >  		mmu_psize_defs[MMU_PAGE_64K].ap =3D 0x5;
> > > +		mmu_psize_defs[MMU_PAGE_64K].h_rpt_pgsize =3D
> > > +			psize_to_rpti_pgsize(MMU_PAGE_64K);
>=20
> Hmm if you see I got rid of rpti_pgsize_to_psize() by having the
> defines directly in mmu_psize_def[].

I realize that, but I'm talking about the reverse direction:
psize_to_rpti_pgsize().  You should be able to reduce it a table
lookup, so the mmu_psize_defs table is the only place this information
exists.

> There are two cases in the above code (radix__early_init_devtree)
>=20
> 1. If radix pagesize encodings are present in the DT, we walk
> the page sizes in the loop and populate the enconding for
> H_RPT_INVALIDATE. I am not sure if we can use the direct codes
> in this case.

I'm not understanding the problem.

In any case the existing implementation of psize

Why ever not?  You can just update the mmu_psize_defs when you parse
the device tree.  Plus AFAICT, the existing psize_to_rpti
implementation doesn't take into account any device tree eencodings.

> 2. If DT doesn't have the radix pagesize encodings, 4K and 64K
> sizes are assumed as fallback sizes where we can use direct
> encodings.

Right... still not seeing the problem.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--doKkFUm6XtL+MBRx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBAhX4ACgkQbDjKyiDZ
s5JkJA/+Jv2RIDj9U4HE4WL+v/vjMZ0rk494b3toiyqWRgB9xnBGfG0ikZbYhyLT
ZNQvps8WbEmZStSMghxMLDK+s7CCrApxTSM32LOWakoxTc1MKQ6weHbs+QOGFLnv
wjqlrCCwAGhqGI7ag2+Ev30W499zgKSH124yEW2V3rQi7qQxUfxxjKRk6mANUNQs
BtgPTd4EeVHjnyR69Kd5UyldAyhQTVXVQPd7G1YH7Opwlnm4pc8RXowA58GKX4LW
b7vvdXwJTwisEcfze7cGpYfYONDnybivqxv6/9+LrY1auXQKvb0AgrseGJ9mBiiB
7HRBMyoDQ2w+47bvcTxnwsybLaTw6Xjs+7bRqUxN5yCQLCncU9mw3Rfu9OBvCRAA
in3/aIKHEYyk/5kMPhQ8yVK5J5iEpYJ7bv7o8K9h88OLCMU2ZFu8s6UeKO4aR5fn
cw9K4V+c7mtNIQ3WltnLP2kHyaBqoT0asXguCJFye6b7quw/naLomsUntS1VbPCb
hlsEPbi3SxeDZTha3a3TBLuemzz6buqhUu3SyYnDClGWmaQrJ9o262hLNP0EHgcL
2ROmSQPGlEzyj2Me65r9MNMPyKeZ4jnH1btPwHO/7W+bjqf6sYThoEbctvx3jMpj
FoA5TePORgOhSDAS2WKx61EFgf+l1R4KuiivxM/TFAib9lxUlQI=
=ymww
-----END PGP SIGNATURE-----

--doKkFUm6XtL+MBRx--
