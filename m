Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E00350CAD
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 04:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhDAC06 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 22:26:58 -0400
Received: from ozlabs.org ([203.11.71.1]:33811 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhDAC0h (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 22:26:37 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F9nB36Cycz9sWw; Thu,  1 Apr 2021 13:26:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1617243995;
        bh=X9CrBprZwWVOESJ7P+ulL7T8QQy92kohgBIQUmAzlTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=npAvWV6tPJGMUQPSUZqoqBagAJxTVRpy8/OweYiPHFX6LuP6OP8wVopBf5FhF+tZQ
         HuvTlY7QgSvc+A6YHUbA3WMpKOHJzw/LLx6OufxVZuTd1Y/BIJPqfBLr3wGfZ9/ARE
         l4h2Phio/79XMckG8BUtf2jbgYd4cLff4UzznoEc=
Date:   Thu, 1 Apr 2021 13:26:11 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: Re: [PATCH v2] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
Message-ID: <YGUvQ0XD+pQvWC/9@yekko.fritz.box>
References: <20210401010519.7225-1-vaibhav@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VKI89TRhZpvI/En+"
Content-Disposition: inline
In-Reply-To: <20210401010519.7225-1-vaibhav@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--VKI89TRhZpvI/En+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 01, 2021 at 06:35:19AM +0530, Vaibhav Jain wrote:
> Add support for H_SCM_HEALTH hcall described at [1] for spapr
> nvdimms. This enables guest to detect the 'unarmed' status of a
> specific spapr nvdimm identified by its DRC and if its unarmed, mark
> the region backed by the nvdimm as read-only.
>=20
> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> from 'struct nvdimm->unarmed' member.
>=20
> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> ppc64 are proposed at [2].
>=20
> References:
> [1] "Hypercall Op-codes (hcalls)"
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/Documentation/powerpc/papr_hcalls.rst#n220
> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@=
linux.ibm.com/
>=20
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

As well as the handful of comments below, this will definitely need to
wait for ppc-6.1 at this point.

> ---
> Changelog
>=20
> v2:
> * Added a check for drc->dev to ensure that the dimm is plugged in
>   when servicing H_SCM_HEALTH. [ Shiva ]
> * Instead of accessing the 'nvdimm->unarmed' member directly use the
>   object_property_get_bool accessor to fetch it. [ Shiva ]
> * Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
> * Updated patch description reference#1 to point appropriate section
>   in the documentation. [ Greg ]
> ---
>  hw/ppc/spapr_nvdimm.c  | 38 ++++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  3 ++-
>  2 files changed, 40 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..34096e4718 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,13 @@
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
> =20
> +/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c =
*/
> +/* SCM device is unable to persist memory contents */
> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))

You can use PPC_BIT() for more clarity here.

> +/* Bits status indicators for health bitmap indicating unarmed dimm */
> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)

I'm not sure why you want two equal #defines here.

> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -467,6 +474,36 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu=
, SpaprMachineState *spapr,
>      return H_SUCCESS;
>  }
> =20
> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spa=
pr,
> +                                 target_ulong opcode, target_ulong *args)
> +{
> +    uint32_t drc_index =3D args[0];
> +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
> +    NVDIMMDevice *nvdimm;
> +
> +    if (drc && spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {

This will fail badly if !drc (given index is way out of bounds).  I'm
pretty sure you want
	if (!drc || spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {


> +        return H_PARAMETER;
> +    }
> +
> +    /* Ensure that the dimm is plugged in */
> +    if (!drc->dev) {
> +        return H_HARDWARE;

H_HARDWARE doesn't seem right - it's the guest that has chosen to
attempt this on an unplugged LMB, not the (virtual) hardware's fault.

> +    }
> +
> +    nvdimm =3D NVDIMM(drc->dev);
> +
> +    args[0] =3D 0;
> +    /* Check if the nvdimm is unarmed and send its status via health bit=
maps */
> +    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NU=
LL)) {
> +        args[0] |=3D PAPR_PMEM_UNARMED;
> +    }
> +
> +    /* Update the health bitmap with the applicable mask */
> +    args[1] =3D PAPR_PMEM_UNARMED_MASK;
> +
> +    return H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -475,6 +512,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>  }
> =20
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 47cebaf3ac..6e1eafb05d 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -538,8 +538,9 @@ struct SpaprMachineState {
>  #define H_SCM_BIND_MEM          0x3EC
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
> +#define H_SCM_HEALTH            0x400
> =20
> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> =20
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--VKI89TRhZpvI/En+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBlL0EACgkQbDjKyiDZ
s5IgOQ//WY4gbDvNquxEg6CuOP88hNFDoM5E5kRyPCwPI6pnSkWxhAMhgbQObvYm
aCC8NsIldVtwszokrO9s44bA9pxXAlPZTUmyX9mtgAYTItPNXaygeu78v2M5vqsW
+dHvC58xH1Eh/XwrkxMm6GVT6PHq0o+tlF+ItATyKmKIaZF8Zv9xRaowFcSHmJ/p
vSU3Bbe2V3q6+7X4EabsXMOoCW3WNnXnD2xPghWn4yyfAhHzcq3bzzfMHtr6yzDg
w450SMSiBRT5rou2A/tDudIJ57SmiaQd5goXS7oASRMPKGACv4SikatOUtFY3pSw
MHzqxGfyE2DRH3EAMQAdHAJfRqv0i2sr1zfTNcASYFw7xTCvGM6GABxI12sWH/DV
34rMsGWEqG7ELEn5OT0hwwIIcr/g+hK/E5CfLCwMG6mUvIAE/mshYpwf1Nwk8R0G
6wODjG1JHuQCuTICK2eGyT2+KSwSdxVKtbqEKFT3RZ4dCTVY3nKmwIEZJNnuq3+U
KH3jyJAwdAUtJy+ZTdQe60GxvFW74N1J/QfRUS9hJ51ZU15M61EwQx5ONlHrIOSg
Vc5ss2aLfq/Za1GElwSTVvvF9wh5vSwz1413oYTluGgQHe+6l4SVSj22J3N27bOS
iRFXgOtKlLdNRwCch++PTvS44x2MlIRG9BtBvOdQr5yLNue9Qho=
=Xggg
-----END PGP SIGNATURE-----

--VKI89TRhZpvI/En+--
