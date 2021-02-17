Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0338B31D37B
	for <lists+kvm-ppc@lfdr.de>; Wed, 17 Feb 2021 01:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhBQAj3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 16 Feb 2021 19:39:29 -0500
Received: from ozlabs.org ([203.11.71.1]:34337 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhBQAj2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 16 Feb 2021 19:39:28 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DgJqT6L7bz9rx8; Wed, 17 Feb 2021 11:38:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1613522325;
        bh=b7eZN7NZjy0XVtnh0bmjT52ABW2hdIeTWdUoAGEIF7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pWqmCJ2jmNitjlmGQ3ILOHgUg/4xgNkRUTsqEY9e2HnnfFJA5Ha0abY5u28W2WkAA
         5EDZS9Ro9zep2GY10SbKkdxS283IZlTWCoxpDngUn4/O5QkB5+EA4wxlRsitNFyON0
         +DssMdbvvM9Q3g7zZSxSCLuJVNkiAuzUty3nwsGQ=
Date:   Wed, 17 Feb 2021 11:16:11 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH kernel 1/2] powerpc/iommu: Allocate it_map by vmalloc
Message-ID: <YCxgSz6JdyW7Ll9T@yekko.fritz.box>
References: <20210216033307.69863-1-aik@ozlabs.ru>
 <20210216033307.69863-2-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+KYLCqoJuglLtO2j"
Content-Disposition: inline
In-Reply-To: <20210216033307.69863-2-aik@ozlabs.ru>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--+KYLCqoJuglLtO2j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 16, 2021 at 02:33:06PM +1100, Alexey Kardashevskiy wrote:
> The IOMMU table uses the it_map bitmap to keep track of allocated DMA
> pages. This has always been a contiguous array allocated at either
> the boot time or when a passed through device is returned to the host OS.
> The it_map memory is allocated by alloc_pages() which allocates
> contiguous physical memory.
>=20
> Such allocation method occasionally creates a problem when there is
> no big chunk of memory available (no free memory or too fragmented).
> On powernv/ioda2 the default DMA window requires 16MB for it_map.
>=20
> This replaces alloc_pages_node() with vzalloc_node() which allocates
> contiguous block but in virtual memory. This should reduce changes of
> failure but should not cause other behavioral changes as it_map is only
> used by the kernel's DMA hooks/api when MMU is on.
>=20
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>

> ---
>  arch/powerpc/kernel/iommu.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index c00214a4355c..8eb6eb0afa97 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -719,7 +719,6 @@ struct iommu_table *iommu_init_table(struct iommu_tab=
le *tbl, int nid,
>  {
>  	unsigned long sz;
>  	static int welcomed =3D 0;
> -	struct page *page;
>  	unsigned int i;
>  	struct iommu_pool *p;
> =20
> @@ -728,11 +727,9 @@ struct iommu_table *iommu_init_table(struct iommu_ta=
ble *tbl, int nid,
>  	/* number of bytes needed for the bitmap */
>  	sz =3D BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
> =20
> -	page =3D alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
> -	if (!page)
> +	tbl->it_map =3D vzalloc_node(sz, nid);
> +	if (!tbl->it_map)
>  		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
> -	tbl->it_map =3D page_address(page);
> -	memset(tbl->it_map, 0, sz);
> =20
>  	iommu_table_reserve_pages(tbl, res_start, res_end);
> =20
> @@ -774,8 +771,6 @@ struct iommu_table *iommu_init_table(struct iommu_tab=
le *tbl, int nid,
> =20
>  static void iommu_table_free(struct kref *kref)
>  {
> -	unsigned long bitmap_sz;
> -	unsigned int order;
>  	struct iommu_table *tbl;
> =20
>  	tbl =3D container_of(kref, struct iommu_table, it_kref);
> @@ -796,12 +791,8 @@ static void iommu_table_free(struct kref *kref)
>  	if (!bitmap_empty(tbl->it_map, tbl->it_size))
>  		pr_warn("%s: Unexpected TCEs\n", __func__);
> =20
> -	/* calculate bitmap size in bytes */
> -	bitmap_sz =3D BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
> -
>  	/* free bitmap */
> -	order =3D get_order(bitmap_sz);
> -	free_pages((unsigned long) tbl->it_map, order);
> +	vfree(tbl->it_map);
> =20
>  	/* free table */
>  	kfree(tbl);

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--+KYLCqoJuglLtO2j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAsYEsACgkQbDjKyiDZ
s5KMNg/9GaI2PXLbH2Ff4Ua+Fmlj1iRNdBqHb1qbBNcOsGcrFMyVZeNEwn0XWCeU
xhU/uoV0ybW6bzFDSN67TjhTX8pq3MWi9MhjyzCufpLAr9x107leKMptihYfc6k7
QKPkIfoz4kdfdsjiQAl6UBbDKnT2XZxdA8oXTU+wga5qKc1gkWUdQEr64EhKObX8
GM3TeA/n2YTW445DrsuebekLZR/RqBxiGPIy4xr1F2RkWlZV4tDyDczvAdvDK2rx
KrBlh1HJpk9GGCZaOhhP0MH2nOHRQ99wqcqeQFLILq220diEo1Ea3JUDGPx6ntNZ
Ep5rsd/iwNasiI0xKwiIbgbPSFwVeGNnp9rEYlRWhnVoS3/WLeugtIKeXUKffiKU
QQJo85LmYwmBQtDtRNahb4eGLcL0WDAW0kVVd/OAuvXk1fvoMh/rvhc0AXvb3sqS
zeQvP6YDWy2fblrUnXT6nf4ha8gQb79ioYg7YvnwmFTb9OhGN6jqSo2lKb6ImM7c
X9rYGdaMAwekvyj2Rnx7IbkYaHmxWyELdTcK+Iww6okWvcfq5peh2Htx1Il3LXUv
FIhWrvfTPbHNPFv9LNSIzSq0HnO5eiEplzG4hpkf/ck1kWAiGKTH+KxLeKw9oJV3
s2BUAVB7oglilKTHWhHTME7JeVmOV6klTVyIVzySaDKIbSfRQcY=
=ruIe
-----END PGP SIGNATURE-----

--+KYLCqoJuglLtO2j--
