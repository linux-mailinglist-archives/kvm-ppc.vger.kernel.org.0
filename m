Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25255350F10
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 08:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhDAGbA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 02:31:00 -0400
Received: from 5.mo51.mail-out.ovh.net ([188.165.49.213]:44954 "EHLO
        5.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbhDAGa2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 02:30:28 -0400
X-Greylist: delayed 2284 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2021 02:30:27 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.35])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id DF2D327A912;
        Thu,  1 Apr 2021 07:51:57 +0200 (CEST)
Received: from kaod.org (37.59.142.106) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 1 Apr 2021
 07:51:56 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-106R006286b2b47-9e79-43ca-b58f-aa332cd287af,
                    A2907451AC51A4EFF4C4D6DD6E02A54F207D12BE) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Thu, 1 Apr 2021 07:51:55 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     Vaibhav Jain <vaibhav@linux.ibm.com>, <qemu-devel@nongnu.org>,
        <kvm-ppc@vger.kernel.org>, <qemu-ppc@nongnu.org>, <mst@redhat.com>,
        <imammedo@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <shivaprasadbhat@gmail.com>, <bharata@linux.vnet.ibm.com>,
        <aneesh.kumar@linux.ibm.com>, <ehabkost@redhat.com>,
        <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v2] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
Message-ID: <20210401075155.44b9267d@bahia.lan>
In-Reply-To: <YGUvQ0XD+pQvWC/9@yekko.fritz.box>
References: <20210401010519.7225-1-vaibhav@linux.ibm.com>
        <YGUvQ0XD+pQvWC/9@yekko.fritz.box>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7qo0K+59=sl2FU82aBhc9E8";
        protocol="application/pgp-signature"; micalg=pgp-sha256
X-Originating-IP: [37.59.142.106]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: d02a1d92-91ff-4346-b061-cafd730401e7
X-Ovh-Tracer-Id: 6880655809270487483
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeifedgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtihesghdtreerredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepgfejudetffetgfekveekvefhieekheekgefgvdelleelhffggeetfeeigffhleegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

--Sig_/7qo0K+59=sl2FU82aBhc9E8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Apr 2021 13:26:11 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Thu, Apr 01, 2021 at 06:35:19AM +0530, Vaibhav Jain wrote:
> > Add support for H_SCM_HEALTH hcall described at [1] for spapr
> > nvdimms. This enables guest to detect the 'unarmed' status of a
> > specific spapr nvdimm identified by its DRC and if its unarmed, mark
> > the region backed by the nvdimm as read-only.
> >=20
> > The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> > returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> > from 'struct nvdimm->unarmed' member.
> >=20
> > Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> > ppc64 are proposed at [2].
> >=20
> > References:
> > [1] "Hypercall Op-codes (hcalls)"
> >     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/Documentation/powerpc/papr_hcalls.rst#n220
> > [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
> >     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibha=
v@linux.ibm.com/
> >=20
> > Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>=20
> As well as the handful of comments below, this will definitely need to
> wait for ppc-6.1 at this point.
>=20
> > ---
> > Changelog
> >=20
> > v2:
> > * Added a check for drc->dev to ensure that the dimm is plugged in
> >   when servicing H_SCM_HEALTH. [ Shiva ]
> > * Instead of accessing the 'nvdimm->unarmed' member directly use the
> >   object_property_get_bool accessor to fetch it. [ Shiva ]
> > * Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
> > * Updated patch description reference#1 to point appropriate section
> >   in the documentation. [ Greg ]
> > ---
> >  hw/ppc/spapr_nvdimm.c  | 38 ++++++++++++++++++++++++++++++++++++++
> >  include/hw/ppc/spapr.h |  3 ++-
> >  2 files changed, 40 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> > index b46c36917c..34096e4718 100644
> > --- a/hw/ppc/spapr_nvdimm.c
> > +++ b/hw/ppc/spapr_nvdimm.c
> > @@ -31,6 +31,13 @@
> >  #include "qemu/range.h"
> >  #include "hw/ppc/spapr_numa.h"
> > =20
> > +/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.=
c */
> > +/* SCM device is unable to persist memory contents */
> > +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
>=20
> You can use PPC_BIT() for more clarity here.
>=20

I had already suggested PPC_BIT(0) but since this macro was copied
from the kernel source, I've let Vaibhav decide whether to use
PPC_BIT() or keep the macro and comment it comes from the kernel.

I agree I prefer PPC_BIT(0) :-)

> > +/* Bits status indicators for health bitmap indicating unarmed dimm */
> > +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
>=20
> I'm not sure why you want two equal #defines here.
>=20

Especially, this define doesn't make sense for the hypervisor IMHO.

It is _just_ the mask of bits for the "unarmed" state in the kernel.

> > +
> >  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *=
nvdimm,
> >                             uint64_t size, Error **errp)
> >  {
> > @@ -467,6 +474,36 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *c=
pu, SpaprMachineState *spapr,
> >      return H_SUCCESS;
> >  }
> > =20
> > +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *s=
papr,
> > +                                 target_ulong opcode, target_ulong *ar=
gs)
> > +{
> > +    uint32_t drc_index =3D args[0];
> > +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
> > +    NVDIMMDevice *nvdimm;
> > +
> > +    if (drc && spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>=20
> This will fail badly if !drc (given index is way out of bounds).  I'm
> pretty sure you want
> 	if (!drc || spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>=20
>=20
> > +        return H_PARAMETER;
> > +    }
> > +
> > +    /* Ensure that the dimm is plugged in */
> > +    if (!drc->dev) {
> > +        return H_HARDWARE;
>=20
> H_HARDWARE doesn't seem right - it's the guest that has chosen to
> attempt this on an unplugged LMB, not the (virtual) hardware's fault.
>=20

Yes. As already suggested, simply do the same as in other hcall
implementations in this file, e.g. from h_scm_bind_mem() :

    if (!drc || !drc->dev ||
        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
        return H_PARAMETER;
    }

> > +    }
> > +
> > +    nvdimm =3D NVDIMM(drc->dev);
> > +
> > +    args[0] =3D 0;
> > +    /* Check if the nvdimm is unarmed and send its status via health b=
itmaps */

Not sure this comment is super useful.

> > +    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, =
NULL)) {
> > +        args[0] |=3D PAPR_PMEM_UNARMED;
> > +    }
> > +
> > +    /* Update the health bitmap with the applicable mask */
> > +    args[1] =3D PAPR_PMEM_UNARMED_MASK;

I still think this is a misuse of PAPR_PMEM_UNARMED_MASK... The
meaning of args[1] is "health-bit-valid-bitmap indicate which
bits in health-bitmap are valid" according to the documentation.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Doc=
umentation/powerpc/papr_hcalls.rst#n228

Without any further detail, I tend to consider this as a hint
to the guest on the bits supported by the hypervisor. Since
we can only set PAPR_PMEM_UNARMED, for now, args[1] should
be set to just that bit PAPR_PMEM_UNARMED. Other bits can
be added later if QEMU supports more of them.

> > +
> > +    return H_SUCCESS;
> > +}
> > +
> >  static void spapr_scm_register_types(void)
> >  {
> >      /* qemu/scm specific hcalls */
> > @@ -475,6 +512,7 @@ static void spapr_scm_register_types(void)
> >      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
> >      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
> >      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> > +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> >  }
> > =20
> >  type_init(spapr_scm_register_types)
> > diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> > index 47cebaf3ac..6e1eafb05d 100644
> > --- a/include/hw/ppc/spapr.h
> > +++ b/include/hw/ppc/spapr.h
> > @@ -538,8 +538,9 @@ struct SpaprMachineState {
> >  #define H_SCM_BIND_MEM          0x3EC
> >  #define H_SCM_UNBIND_MEM        0x3F0
> >  #define H_SCM_UNBIND_ALL        0x3FC
> > +#define H_SCM_HEALTH            0x400
> > =20
> > -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> > +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> > =20
> >  /* The hcalls above are standardized in PAPR and implemented by pHyp
> >   * as well.
>=20


--Sig_/7qo0K+59=sl2FU82aBhc9E8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAmBlX3sACgkQcdTV5YIv
c9YBlA//S0kZnzRddcnbSPO/BIdgPu/FpvEbVCzApps8NIrR/lNT59nRz2+B62Lq
vKwq+ueubX/Hj3ipYRMeIQouk7FsJNi+ZbDvvlO4htEeNrswm7BOMUIMZRJt2+Cz
NDNfkQwfCPIdKPWiUUGIv6ZOSESMcaHBs6VrVeqiqPG+YOmXcrhwDtjEk+fw1NCf
iX6inkhCeBcK+C7L+YcwXIypyAL28PWUwAyEHjk6M+TQGa+WXo4QiUSYyJnXr+no
um8RqSdSejrcmM4DEtEi8k+Rg9Yr3nf2fc4vGXiT1eqbkHSATg9gy6lO7fZOp0p8
nQPWY95Q7ghm7CSUpwTJv2bjL0bDVGIJ0/kD4m4+MhrBSnAapM/Hr8FtY18DvKng
5qSApuVDlY0XwUEPXtKBahIHlwT1o0O/EozsA8ybVx7TsXJBZ1gLbfqNOQn1UTDi
01QviqIKCAROXt4tBRqr2l359XoD1So/e5BoEPP71Dfi1LipOoMM9chuRB58cD+D
qI+sDH9kcxiQMUEhjUSqXo53ADHFFexK8LIYL0h51fDBT4P0/4mYT9zwlWEIXRCo
0AHdhgYWpby09pS8N8A8BQStTnQC306i5C34bPnYFbs8t25QFL4BY7B44qzb3aF+
52yfDjcBtBy85NuNPlQitbwIkG5KyQUUZ5HBu2y7UCrsx7S/L5w=
=Qqjn
-----END PGP SIGNATURE-----

--Sig_/7qo0K+59=sl2FU82aBhc9E8--
