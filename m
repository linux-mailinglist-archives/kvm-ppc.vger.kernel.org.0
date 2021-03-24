Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC7A346FED
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Mar 2021 04:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhCXDJs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 23 Mar 2021 23:09:48 -0400
Received: from ozlabs.org ([203.11.71.1]:50765 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232306AbhCXDJm (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 23 Mar 2021 23:09:42 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4F4tWT0HLBz9sWS; Wed, 24 Mar 2021 14:09:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1616555381;
        bh=ppg2ckmbSltg90PqicV6u9zr1FQKHX/tZ91+JlMqMuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OC2UvQYwRlRaWUm19RH9AIqrhKW6z8baGEbLkqutzHnTT2ZH9RkRyUAf+dp9IgEuL
         blRNnFo4rz8JISGFr/BLZPJ2UgGjPCrdEVY2HO1kWj0xhEvEx4WJb5BWowAcYn/LZr
         /PBynTSCcxn0x0uwnkKsq58Iq3P0ipr7wfvHd+0M=
Date:   Wed, 24 Mar 2021 13:30:55 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     sbhat@linux.vnet.ibm.com, groug@kaod.org, qemu-ppc@nongnu.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
        linux-nvdimm@lists.01.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH v3 1/3] spapr: nvdimm: Forward declare and move the
 definitions
Message-ID: <YFqkX65IlbEvv6Ta@yekko.fritz.box>
References: <161650723087.2959.8703728357980727008.stgit@6532096d84d3>
 <161650723903.2959.2652600316416885453.stgit@6532096d84d3>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HWO7IIP6GuVjpqy8"
Content-Disposition: inline
In-Reply-To: <161650723903.2959.2652600316416885453.stgit@6532096d84d3>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--HWO7IIP6GuVjpqy8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 23, 2021 at 09:47:23AM -0400, Shivaprasad G Bhat wrote:
> The subsequent patches add definitions which tend to
> get the compilation to cyclic dependency. So, prepare
> with forward declarations, move the defitions and clean up.
>=20
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/ppc/spapr_nvdimm.c         |   12 ++++++++++++
>  include/hw/ppc/spapr_nvdimm.h |   21 ++++++---------------
>  2 files changed, 18 insertions(+), 15 deletions(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..8cf3fb2ffb 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,18 @@
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
> =20
> +/*
> + * The nvdimm size should be aligned to SCM block size.
> + * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> + * inorder to have SCM regions not to overlap with dimm memory regions.
> + * The SCM devices can have variable block sizes. For now, fixing the
> + * block size to the minimum value.
> + */
> +#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
> +
> +/* Have an explicit check for alignment */
> +QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE=
);
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
> index 73be250e2a..abcacda5d7 100644
> --- a/include/hw/ppc/spapr_nvdimm.h
> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -11,23 +11,14 @@
>  #define HW_SPAPR_NVDIMM_H
> =20
>  #include "hw/mem/nvdimm.h"
> -#include "hw/ppc/spapr.h"
> =20
> -/*
> - * The nvdimm size should be aligned to SCM block size.
> - * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> - * inorder to have SCM regions not to overlap with dimm memory regions.
> - * The SCM devices can have variable block sizes. For now, fixing the
> - * block size to the minimum value.
> - */
> -#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
> -
> -/* Have an explicit check for alignment */
> -QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE=
);
> +struct SpaprDrc;
> +struct SpaprMachineState;
> =20
> -int spapr_pmem_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
> -                           void *fdt, int *fdt_start_offset, Error **err=
p);
> -void spapr_dt_persistent_memory(SpaprMachineState *spapr, void *fdt);
> +int spapr_pmem_dt_populate(struct SpaprDrc *drc,

Using explicit struct tags is against qemu coding style.   You should
put a typedef on the forward decl so you don't need to do it here (see
examples in spapr_pci.c amongst other places).

> +                           struct SpaprMachineState *spapr, void *fdt,
> +                           int *fdt_start_offset, Error **errp);
> +void spapr_dt_persistent_memory(struct SpaprMachineState *spapr, void *f=
dt);
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp);
>  void spapr_add_nvdimm(DeviceState *dev, uint64_t slot);
>=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--HWO7IIP6GuVjpqy8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmBapF0ACgkQbDjKyiDZ
s5IwcQ/+P4QE5ojDn80wASGJfTSW9l9uXbiCfTxa0qeq7rPAYB5U70laqSN1mhmz
UxOymyhs5BWED2BuOWrDi+yJm1OBh4za1yKwR7pqqvBth2uyeOYsZo8V7K2jn3Kb
nvnz4M5GtOCUaE4ASYAlGYWf5GCG6sBBSuEWfySkTQvSXYZPUdvX7icOU6k09ZXO
tV5p9SxSxm9JdYniHZW5U0EJJdc9DEEMRxdhHdHRhbW34JQcOjjlOmHaEVjTXl0P
rXMiSaCj7pfV4RZbzwiGAGoBtdGfMF7mmKFN3rZLWLpsXp3TTPwIAir1DINjxWn6
wbL9bTUAv2YRSZ1eDVLEvpG0SHx79L49GxhghURsgJfe5NtxkdIWuRMAIUjgw31O
2+Q0eXMcSkv4ZlqERk+aWBC11nIgquP43iXuVM7577x1rsRSdZw4T4rFrT0RMTTw
/nUeNA79nZImZZjkjM1xv4GiVkajT+ySF17Oy38izLyiV4zBgGzRhTtgDIHOQb8d
ZiUY5zgHdMdtucGPRpgQGKPaVEdjyR6y8gOAi26iyj1bZXUl1b36E7B7KRP6udWu
W3vt4H1ZMfqTj5gL1sqgx6TILaKyYzvm9AqKEHjSeWM3b3yAYZxH9QA3Tew0QEb/
UhBm/IpHchKX+i3S5yTYrCKPx3hmDR05hnjrevMucHwsGHtZ3vY=
=fwKz
-----END PGP SIGNATURE-----

--HWO7IIP6GuVjpqy8--
