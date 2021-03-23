Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF1C345564
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 03:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCWCNq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 22:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhCWCNk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 22:13:40 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07CDC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 19:13:39 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F4FKD3GnTz9sRf; Tue, 23 Mar 2021 13:13:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1616465616;
        bh=OA5ZAsCs5+L71lR4bQzy7HQX2Ve6DCQaBayBcwXORi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSWVowc5LNdQsgwuw68YycyiPTww+qIjxeia8571z9zNSmTur6cCr6wm2K7+XJ55z
         88F0Rqb7TKPlPuXls6Ha90XNBFi1Yf4G2IpZy/essNOyWv9D4DH32T3cYSXHI4Ju/5
         JbgJlh6fl3QAhzgoBFClVmZGGErJ7pLq1m+OaI6Y=
Date:   Tue, 23 Mar 2021 12:19:28 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au, farosas@linux.ibm.com
Subject: Re: [PATCH v6 1/6] KVM: PPC: Book3S HV: Fix comments of
 H_RPT_INVALIDATE arguments
Message-ID: <YFlCICYsADa+OrG/@yekko.fritz.box>
References: <20210311083939.595568-1-bharata@linux.ibm.com>
 <20210311083939.595568-2-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2cpqFItxP4BNoyVD"
Content-Disposition: inline
In-Reply-To: <20210311083939.595568-2-bharata@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--2cpqFItxP4BNoyVD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2021 at 02:09:34PM +0530, Bharata B Rao wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
>=20
> The type values H_RPTI_TYPE_PRT and H_RPTI_TYPE_PAT indicate
> invalidating the caching of process and partition scoped entries
> respectively.
>=20
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Not sure the change really clarifies that much, but whatever

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  arch/powerpc/include/asm/hvcall.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm=
/hvcall.h
> index ed6086d57b22..6af7bb3c9121 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -411,9 +411,9 @@
>  #define H_RPTI_TYPE_NESTED	0x0001	/* Invalidate nested guest partition-s=
cope */
>  #define H_RPTI_TYPE_TLB		0x0002	/* Invalidate TLB */
>  #define H_RPTI_TYPE_PWC		0x0004	/* Invalidate Page Walk Cache */
> -/* Invalidate Process Table Entries if H_RPTI_TYPE_NESTED is clear */
> +/* Invalidate caching of Process Table Entries if H_RPTI_TYPE_NESTED is =
clear */
>  #define H_RPTI_TYPE_PRT		0x0008
> -/* Invalidate Partition Table Entries if H_RPTI_TYPE_NESTED is set */
> +/* Invalidate caching of Partition Table Entries if H_RPTI_TYPE_NESTED i=
s set */
>  #define H_RPTI_TYPE_PAT		0x0008
>  #define H_RPTI_TYPE_ALL		(H_RPTI_TYPE_TLB | H_RPTI_TYPE_PWC | \
>  				 H_RPTI_TYPE_PRT)

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--2cpqFItxP4BNoyVD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBZQiAACgkQbDjKyiDZ
s5IDrxAAshdC1SOjx3acRTuepXPgDDgKNDXdt6CjzNwC1fdPHB1i+S5SOC/YyJWe
nmFKP/p0/Y3vZwaLIirEgxjkiseO7tTWmtI9wVzDdZcrcyDmu08OySV678aqPeJg
oucn/rzkSiLb9sqvB9JjouCEXbaJHXA4M3IMHNSD23qdKsU50zxVHZa9y557UPEN
NPN3JoUVRBawIUOBCkmHW8bNRnWWGKRczCtHCrAQPQuqHSvXBP71BYt2YzYCHvWT
1iN5DFC9W/E3r/aHGnRs3EGjugTGZW2V3TH3/AL/rwsfydSFUls/mBUJQi8O870f
+TB08tNns5pM+nMm9JP5pXAtQTVQGtWT+T41wV/vZRVN7yMSfwPQAYDjWIdTf+nr
DJWjxZPdAhuVDY//aGnbVs0XCUkf3x+eIrBE1+zJ1SU19d8e9B/p1PDsmQ/G3q46
3+nlwBPtJjWovZ6X+A5HCHX24Q/JNiHSZbiJ1I/EYr6eBLU+usDZhbKI1fY86NcP
NpB4eF30iymHkkavRNoc6nGcPE6DULXQnTiVEGzUTcsxTvDimWeN2c2NVncg86Tc
dB5QL0GdpJu2HJRZmhmtOcCc8nyiL96pNVQdQiwlZem6NXz4XErFRA52Hj4NKEnS
y380f8Y0uNuK0sU1pGeCDuibXYTZ3RVTJxDCXCxSgsfSFYCJ7CA=
=ZQjV
-----END PGP SIGNATURE-----

--2cpqFItxP4BNoyVD--
