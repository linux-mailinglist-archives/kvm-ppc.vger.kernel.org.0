Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605BA2D9482
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Dec 2020 10:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439515AbgLNJBv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Dec 2020 04:01:51 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:57267 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439514AbgLNJBp (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 14 Dec 2020 04:01:45 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Cvb301Wxbz9sVY; Mon, 14 Dec 2020 20:01:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607936460;
        bh=E4s3yviVMjpp9iFpj/Bb5X71Y/qsElHb4YmF+/y4+1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kzl/COHvaqklUVB68Pp3wvHJkXKBGnf76uitDJh17U1TFLfYYoXwb+UL2QhoPyN7o
         OzSLnQeU+eBvnL+1nKmwe5k6CGPNCU1rgLNdaAEPxJDW86t8PRxHaaQzSSiUhHMuN0
         P2KnoB3JwgtjA5QuGZdhK8mvKAOcGck7NRfdDN/M=
Date:   Mon, 14 Dec 2020 17:05:59 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        aneesh.kumar@linux.ibm.com, npiggin@gmail.com, paulus@ozlabs.org,
        mpe@ellerman.id.au
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201214060559.GH4717@yekko.fritz.box>
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
 <20201211103336.GB775394@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
Content-Disposition: inline
In-Reply-To: <20201211103336.GB775394@in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 11, 2020 at 04:03:36PM +0530, Bharata B Rao wrote:
> On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> > Implements H_RPT_INVALIDATE hcall and supports only nested case
> > currently.
> >=20
> > A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> > support for this hcall.
>=20
> As Paul mentioned in the thread, this hcall does both process scoped
> invalidations and partition scoped invalidations for L2 guest.
> I am adding KVM_CAP_RPT_INVALIDATE capability with only partition
> scoped invalidations (nested case) implemented in the hcall as we
> don't see the need for KVM to implement process scoped invalidation
> function as KVM may never run with LPCR[GTSE]=3D0.
>=20
> I am wondering if enabling the capability with only partial
> implementation of the hcall is the correct thing to do. In future
> if we ever want process scoped invalidations support in this hcall,
> we may not be able to differentiate the availability of two functions
> cleanly from QEMU.

Yeah, it's not ideal.

> So does it make sense to implement the process scoped invalidation
> function also now itself even if it is not going to be used in
> KVM?

That might be a good idea, if it's not excessively difficult.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/XAMcACgkQbDjKyiDZ
s5LNERAAvbn39lxKegYiT0q7vfCJbBkn7+cCZOqT2aYZp8NUeHBUJyrAoqJqcYrB
HIYJDEEJ87GryOKi5fRGamQW19nvX04QbWx8miEN8HgZ8tdLu9skMDBIOoM0ieKO
FIiPujet7FW7ZQ7kvOOD+yJbRNsaBXZULM5Xn9YokA9R6EFAtjmF3CoYpZyHwM4g
LZ5KyjsRzcpPFu1m4T8boAt6p7ifj663iv07tvdVcYEFZXgpusEGqgUifQrf2Rg0
l8budyGJztZRxvd86NJHhWcmlgdFOsS1fkJwj3omVz3gtJNzsrihi7g8WPqARm0x
3hwe5345/zO2BFCieUQ7x38tmF6m4lkEg4DcoOjq2tVXEDeSbA14Ef1IlhsFtEtt
Z+Yyx+o2csLYD6YwaafZifCaof3+OFxc5Ox1VwC7R8F4X9TYEDDFW7/TmlvZVWuR
t1CfcOIndeDuuzDDTaZbNAoJVJ5BW4zT1niXxu4bSgYIEikG/gPFV4YOUAgSnTVt
J7YOmkAyOic/4Fh8PU5wVuq+6F5gqPTxBD0nsRVdVdscaiXKOrNj4rQT5TYxcJ5I
Y3nWMggiPrpYGfWb7AjLeNQ7MOQAbdVsPE1dmIHG/OAhN6HpfoqnJBcKbxTehnfv
a+LH2U9wq+VQtug+643Zx6Oa8i08BBj9fW7MGYm3IqqWmOfZrvE=
=eSeE
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
