Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC6434F543
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 02:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhCaAEe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Mar 2021 20:04:34 -0400
Received: from ozlabs.org ([203.11.71.1]:42797 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhCaAEK (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 30 Mar 2021 20:04:10 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F96492fX7z9shx; Wed, 31 Mar 2021 11:04:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1617149049;
        bh=KKbWb1jeZ7gWEamN12RZBI5mqQukpe0Qp9oQlldnmn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSWWjhJ+ukQXA3xz5bLB5x0QIjWDVsP0MwO9H13F3IG40dRb/BP650WHF02h71EeD
         Eu6rRE7PgthkEELUk31MlSI6FbQNo1P3s5lhRZ3xo1zl8bpbauzrtwpkmAqCSwPXoM
         HK8rM3t0kRpvDvSRK3P+G76aGSd60rmIFuUvA90s=
Date:   Wed, 31 Mar 2021 10:49:07 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     Greg Kurz <groug@kaod.org>, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com
Subject: Re: [PATCH] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
Message-ID: <YGO488mqe2RMHBiu@yekko.fritz.box>
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
 <20210330161437.45872897@bahia.lan>
 <87r1jwpo3p.fsf@vajain21.in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="f7ONA1GK+uW2NGpv"
Content-Disposition: inline
In-Reply-To: <87r1jwpo3p.fsf@vajain21.in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--f7ONA1GK+uW2NGpv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 30, 2021 at 10:37:06PM +0530, Vaibhav Jain wrote:
>=20
> Thanks for looking into this patch Greg. My responses below inline.
>=20
>=20
> Greg Kurz <groug@kaod.org> writes:
>=20
> > Hi Vaibhav,
> >
> > Great to see you around :-)
>=20
> :-)
>=20
> >
> > On Mon, 29 Mar 2021 21:52:59 +0530
> > Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
> >
> >> Add support for H_SCM_HEALTH hcall described at [1] for spapr
> >> nvdimms. This enables guest to detect the 'unarmed' status of a
> >> specific spapr nvdimm identified by its DRC and if its unarmed, mark
> >> the region backed by the nvdimm as read-only.
> >>=20
> >
> > Any chance that you can provide the documentation of this new hcall ?
> >
> H_SCM_HEALTH specifications is already documented in linux kernel
> documentation at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/powerpc/papr_hcalls.rst

Putting a reference to that in the commit message would be a good idea.

> That documentation was added when kernel support for H_SCM_HEALTH hcall
> support was implemented in 5.9 kernel.=20
>=20
> >> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> >> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> >> from 'struct nvdimm->unarmed' member.
> >>=20
> >> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> >> ppc64 are proposed at [2].
> >>=20
> >> References:
> >> [1] "Hypercall Op-codes (hcalls)"
> >>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/tree/Documentation/powerpc/papr_hcalls.rst
> >>=20
> >> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
> >>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibh=
av@linux.ibm.com/
> >>=20
> >> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> >> ---
> >>  hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
> >>  include/hw/ppc/spapr.h |  4 ++--
> >>  2 files changed, 32 insertions(+), 2 deletions(-)
> >>=20
> >> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> >> index b46c36917c..e38740036d 100644
> >> --- a/hw/ppc/spapr_nvdimm.c
> >> +++ b/hw/ppc/spapr_nvdimm.c
> >> @@ -31,6 +31,13 @@
> >>  #include "qemu/range.h"
> >>  #include "hw/ppc/spapr_numa.h"
> >> =20
> >> +/* DIMM health bitmap bitmap indicators */
> >> +/* SCM device is unable to persist memory contents */
> >> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
> >
> > This looks like PPC_BIT(0).
> >
> Yes, right. Will update the patch in v2 to use the PPC_BIT macro.
>=20
> >> +
> >> +/* Bits status indicators for health bitmap indicating unarmed dimm */
> >> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
> >> +
> >>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice =
*nvdimm,
> >>                             uint64_t size, Error **errp)
> >>  {
> >> @@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *=
cpu, SpaprMachineState *spapr,
> >>      return H_SUCCESS;
> >>  }
> >> =20
> >> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *=
spapr,
> >> +                                 target_ulong opcode, target_ulong *a=
rgs)
> >> +{
> >> +    uint32_t drc_index =3D args[0];
> >> +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
> >> +    NVDIMMDevice *nvdimm;
> >> +
> >> +    if (drc && spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM)=
 {
> >> +        return H_PARAMETER;
> >> +    }
> >> +
> >> +    nvdimm =3D NVDIMM(drc->dev);
> >
> > Yeah as already suggested by Shiva, drc->dev should be checked like
> > in h_scm_bind_mem().
> >
> Yes, will send a v2 with this case handled.
>=20
> >> +
> >> +    /* Check if the nvdimm is unarmed and send its status via health =
bitmaps */
> >> +    args[0] =3D nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;
> >> +
> >
> > Shouldn't ^^ use PAPR_PMEM_UNARMED then ?
> >
> >> +    /* health bitmap mask same as the health bitmap */
> >> +    args[1] =3D args[0];
> >> +
> >
> > If so, it seems that PAPR_PMEM_UNARMED_MASK isn't even needed.
>=20
> Definition of these defines are similar to what kernel implementation
> uses at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/a=
rch/powerpc/platforms/pseries/papr_scm.c#n53
>=20
> Since unarmed condition can also arise due to an unhealthy nvdimm hence
> the kernel implementation uses a mask thats composed of two bits
> PPC_BIT(0) and PPC_BIT(6) being set. Though we arent using PPC_BIT(6)
> right now in qemu, it will change in future when better nvdimm health
> reporting will be done. Hence kept the PPC_BIT(0) define as well as the
> mask to mimic the kernel definitions.
>=20
> >
> > Having access to the excerpts from the PAPR addendum that describes
> > this hcall would _really_ help in reviewing.
> >
> The kernel documentation for H_SCM_HEALTH mentioned above captures most
> if not all parts of the PAPR addendum for this hcall. I believe it
> contains enough information to review the patch. If you still need more
> info than please let me know.

We've missed the qemu-6.0 cutoff, so this will be 6.1 material.  I'll
await v2 for further review.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--f7ONA1GK+uW2NGpv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBjuPIACgkQbDjKyiDZ
s5JzlA//T11BtMlXSLbvRPM52bSDvooPztpoMZGvaRtj7YJPJXsAUH76v4/XcFfl
lZ2ZELMyuQc4Dms4Ylff1/srXq73eC8p/GYIt9K5iAU7NZop5hbcFiaWv5FaU7um
CzimfPN8g+sPj0+O06O6oAELVTZZvcsdLn7Tq+alVegvg2vtfHesQklH7tHqVox3
FRrxrxmEpAHsaVVfZKqyOrrjEVwtcFpeh9cnqgWGtbJuF6rFuqMoNzLeyUJ6k4Ea
Z8vA0sj9wOP2uR2yROp6+R3+YKOlUZfMRxXO2Yqt50ePVwcaIA/fWZV5hNHGFu5V
D+I53u8lBZ6oFStXlBUREp+DtUMj0RH+l8jHfMKJnYIdu1jixWa8yh6qQibQ4+A4
tOzWCn5ipL2L48kAbq9xBZisz4c3v9BxF8UlluV21QmEtZZCd6P3Sjdg7Cf4Tsg+
AtSC+jfUIKzPi8QLeGmvJDDGQocvr/4WZ7D0EkZmpa7vwnviQfN6slyYj1fSIF2h
kV8sBi5AkqZAKGexeDHTdihR/AT64EdcRNM+1EFBXc+ZSXk/guGX7efmwWfBLW81
k0zjUyCongXcMAvotY3GI9DEEepaMJW1yN1aqrc3mqUt5dx8dv2JwaOvdF3TI84J
G9m6vGW92xUU2eyLIphMqgkHLVJzixEpFeHLBrTTKupLMD9BoOY=
=jjbl
-----END PGP SIGNATURE-----

--f7ONA1GK+uW2NGpv--
