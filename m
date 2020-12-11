Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64842D6D2E
	for <lists+kvm-ppc@lfdr.de>; Fri, 11 Dec 2020 02:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390390AbgLKBRp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Dec 2020 20:17:45 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:37879 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394506AbgLKBR1 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 10 Dec 2020 20:17:27 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CsXtj2dnSz9sWQ; Fri, 11 Dec 2020 12:16:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607649405;
        bh=efLMiRmQooHWAbt4QoQy7ohqNGF6475alG0b5a5z7Ko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DvCRi4LY5NMyM2FlsrQNg/cXMqiQM6CPIPfssrOsNQBfzW4IM112h5MP0WPqlCXdB
         HbddWUj5ctN4YatY3z0FU3cufDwRrFufNngP+KVPSYh8k91KCfyhGBVEPdcgsVWO9z
         Mrtq2aImHUPMzrdDm/GfwM2bNBs8wu4P3cBcGPEI=
Date:   Fri, 11 Dec 2020 12:16:39 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, aneesh.kumar@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au
Subject: Re: [PATCH v1 1/2] KVM: PPC: Book3S HV: Add support for
 H_RPT_INVALIDATE (nested case only)
Message-ID: <20201211011639.GD4874@yekko.fritz.box>
References: <20201019112642.53016-1-bharata@linux.ibm.com>
 <20201019112642.53016-2-bharata@linux.ibm.com>
 <20201209041542.GA29825@thinks.paulus.ozlabs.org>
 <20201210042418.GA775394@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <20201210042418.GA775394@in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 10, 2020 at 09:54:18AM +0530, Bharata B Rao wrote:
> On Wed, Dec 09, 2020 at 03:15:42PM +1100, Paul Mackerras wrote:
> > On Mon, Oct 19, 2020 at 04:56:41PM +0530, Bharata B Rao wrote:
> > > Implements H_RPT_INVALIDATE hcall and supports only nested case
> > > currently.
> > >=20
> > > A KVM capability KVM_CAP_RPT_INVALIDATE is added to indicate the
> > > support for this hcall.
> >=20
> > I have a couple of questions about this patch:
> >=20
> > 1. Is this something that is useful today, or is it something that may
> > become useful in the future depending on future product plans? In
> > other words, what advantage is there to forcing L2 guests to use this
> > hcall instead of doing tlbie themselves?
>=20
> H_RPT_INVALIDATE will replace the use of the existing H_TLB_INVALIDATE
> for nested partition scoped invalidations. Implementations that want to
> off-load invalidations to the host (when GTSE=3D0) would have to bother
> about only one hcall (H_RPT_INVALIDATE)
>=20
> >=20
> > 2. Why does it need to be added to the default-enabled hcall list?
> >=20
> > There is a concern that if this is enabled by default we could get the
> > situation where a guest using it gets migrated to a host that doesn't
> > support it, which would be bad.  That is the reason that all new
> > things like this are disabled by default and only enabled by userspace
> > (i.e. QEMU) in situations where we can enforce that it is available on
> > all hosts to which the VM might be migrated.
>=20
> As you suggested privately, I am thinking of falling back to
> H_TLB_INVALIDATE in case where this new hcall fails due to not being
> present. That should address the migration case that you mention
> above. With that and leaving the new hcall enabled by default
> is good okay?

No.  Assuming that guests will have some fallback is not how the qemu
migration compatibility model works.  If we specify an old machine
type, we need to provide the same environment that the older host
would have.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/SyHcACgkQbDjKyiDZ
s5LvRA/8CMgS6af/F1LJv8f2eHL7j7K+KBzKKUKWeskXMWo+yObgsmn/eP++VX1W
Whi4DjpCRUYGWtWP7gG7Gl1BOWtDm4cSPBa59KIXFJ5fRKDqJVoDf8yRBIM43EPo
7FyI3hk91/F5WngUexQUrRDqoF1VZS/eVl6RI9o1sBiCnzOX8zDutfkKpVSJKVdS
MMmwHWnqnnFPL47Fqei4xJt/oX6yMTmTUpkN8BKdVCI61Qoqn7Paga5MKTb1g6Km
7xG6tl4KYaPA5eTCdWU0bp9s6YHVV0OmBhSUUpgftQFljPw4Yq3OWGKfP4UXul8l
wdmNqAu21qv63wZtc9jtCc/KQSb0SWSAoi/mR0VMwd3cUbZD5MNrvsaEhDmX+iUk
lECBc+df4bysoU23khWTjN5ujWUXe+PLjGzeeIJ5qvPNX5fLzlm+Tqd/RxD3fZzv
ZBv/Z6Wjsiz8vUlrf/ruSpLKdeIgaqDTMO6XNndf1FFhpT80XU2o6VFt1Z2lnzWW
rO825g9WUTDp5hZEsgZhcLAglaMseHslya0yUEjX90sNDqXhXb+IrClFAm0SIGgc
ikevJk7oTgufqVG/9OcQvFxr0amw7sA3YJYVreYT1tkcJrnvhbKg1y11KiAX2r/K
25mN6yP5orHAb34Ja3CWdlqQWXL+WNEQzh2RlEibFmvJsvod3hY=
=VzCF
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
