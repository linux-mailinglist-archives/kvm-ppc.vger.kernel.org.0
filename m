Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF53363AA1
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Apr 2021 06:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhDSEqg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Apr 2021 00:46:36 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35359 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhDSEqf (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 19 Apr 2021 00:46:35 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FNvQj29zcz9vF3; Mon, 19 Apr 2021 14:46:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1618807565;
        bh=P77WEVrDVZ9fYwwtztDbRsCBdBZBrTD6EJEoDYCONcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crsJuaAG7NTIdlCXuK7bAvlP222NHyrUiHzbXTg+DsvdwDfL0eWrewktWdNZ2xC34
         MG10ZHYu7AuQfqF4hyncubgQ/wvDMOhOxYzM66cm2zQevZ0kozxnfbS0xOap/3i30p
         FEhD5S4XO6KAriQXaIz7EjnVi999RTEk3AUZFtX8=
Date:   Mon, 19 Apr 2021 14:45:57 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org
Subject: Re: [RFC-PATCH] ppc/spapr: Add support for H_SCM_PERFORMANCE_STATS
 hcall
Message-ID: <YH0LBR0pqUYFa49r@yekko.fritz.box>
References: <20210415075343.482855-1-vaibhav@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3BMvO7m36BMEQLRG"
Content-Disposition: inline
In-Reply-To: <20210415075343.482855-1-vaibhav@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--3BMvO7m36BMEQLRG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 15, 2021 at 01:23:43PM +0530, Vaibhav Jain wrote:
> Add support for H_SCM_PERFORMANCE_STATS described at [1] for
> spapr nvdimms. This enables guest to fetch performance stats[2] like
> expected life of an nvdimm ('MemLife ') etc and display them to the
> user. Linux kernel support for fetching these performance stats and
> exposing them to the user-space was done via [3].
>=20
> The hcall semantics mandate that each nvdimm performance stats is
> uniquely identied by a 8-byte ascii string (e.g 'MemLife ') and its
> value be a 8-byte integer. These performance-stats are exchanged with
> the guest in via a guest allocated buffer called
> 'requestAndResultBuffer' or rr-buffer for short. This buffer contains
> a header descibed by 'struct papr_scm_perf_stats' followed by an array
> of performance-stats described by 'struct papr_scm_perf_stat'. The
> hypervisor is expected to validate the rr-buffer header and then based
> on the request copy the needed performance-stats to the array of
> 'struct papr_scm_perf_stat' following the header.
>=20
> The patch proposes a new function h_scm_performance_stats() that
> services the H_SCM_PERFORMANCE_STATS hcall. After verifying the
> validity of the rr-buffer header via scm_perf_check_rr_buffer() it
> proceeds to fill the rr-buffer with requested performance-stats. The
> value of individual stats is retrived from individual accessor
> function for the stat which are indexed in the array
> 'nvdimm_perf_stats'.
>=20
> References:
> [1] "Hypercall Op-codes (hcalls)"
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/powerpc/papr_hcalls.rst#n269
> [2] Sysfs attribute documentation for papr_scm
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/ABI/testing/sysfs-bus-papr-pmem#n36
> [3] "powerpc/papr_scm: Fetch nvdimm performance stats from PHYP"
> https://lore.kernel.org/r/20200731064153.182203-2-vaibhav@linux.ibm.com
>=20
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  hw/ppc/spapr_nvdimm.c  | 243 +++++++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  19 +++-
>  2 files changed, 261 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 252204e25f..4830eae4a4 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -35,6 +35,11 @@
>  /* SCM device is unable to persist memory contents */
>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
> =20
> +/* Maximum output buffer size needed to return all nvdimm_perf_stats */
> +#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats)=
 + \
> +                                      sizeof(struct papr_scm_perf_stat) =
* \
> +                                      ARRAY_SIZE(nvdimm_perf_stats))
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -502,6 +507,243 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, S=
paprMachineState *spapr,
>      return H_SUCCESS;
>  }
> =20
> +static int perf_stat_noop(SpaprDrc *drc, uint8_t unused[8], uint64_t *va=
l)
> +{
> +    *val =3D 0;
> +    return H_SUCCESS;
> +}
> +
> +static int perf_stat_memlife(SpaprDrc *drc, uint8_t unused[8], uint64_t =
*val)
> +{
> +    /* Assume full life available of an NVDIMM right now */
> +    *val =3D 100;

AFAICT the reporting mechanism makes basically all the stats
optional.  Doesn't it make more sense to omit stats, rather than use
dummy values in this case?  Or is this just an example for the RFC?

> +    return H_SUCCESS;
> +}
> +
> +/*
> + * Holds all supported performance stats accessors. Each performance-sta=
tistic
> + * is uniquely identified by a 8-byte ascii string for example: 'MemLife=
 '
> + * which indicate in percentage how much usage life of an nvdimm is rema=
ining.
> + * 'NoopStat' which is primarily used to test support for retriving perf=
ormance
> + * stats and also to replace unknown stats present in the rr-buffer.
> + *
> + */
> +static const struct {
> +    char stat_id[8];
> +    int  (*stat_getval)(SpaprDrc *drc, uint8_t id[8],  uint64_t *val);
> +} nvdimm_perf_stats[] =3D {
> +    { "NoopStat", perf_stat_noop},
> +    { "MemLife ", perf_stat_memlife},
> +};
> +
> +/*
> + * Given a nvdimm drc and stat-name return its value. In case given stat=
-name
> + * isnt supported then return H_PARTIAL.
> + */
> +static int nvdimm_stat_getval(SpaprDrc *drc, uint8_t id[8], uint64_t *va=
l)
> +{
> +    int index;
> +
> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
> +

No blank line here.

> +        if (memcmp(nvdimm_perf_stats[index].stat_id, &id[0], 8) =3D=3D 0=
 &&
> +            nvdimm_perf_stats[index].stat_getval) {

I don't see any reason you'd want an entry in the table with a NULL
function, so I don't think you need both tests.

> +

No blank line here either.

> +            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
> +        }
> +    }
> +
> +    return H_PARTIAL;
> +}
> +
> +/*
> + * Given a request & result buffer header verify its contents. Also
> + * verify that buffer & buffer-size provided by the guest is accessible =
and
> + * large enough to hold the requested stats. The size of buffer needed to
> + * hold the requested 'num_stat' number of stats is returned in 'size'.
> + */
> +static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *header,
> +                                    hwaddr addr, size_t *size,
> +                                    uint32_t *num_stats)
> +{
> +    size_t expected_buffsize;
> +

You need to check that size is at least big enough to contain the
header before accessing the header fields.

> +    /* Verify the header eyecather and version */
> +    if (memcmp(&header->eye_catcher, SCM_STATS_EYECATCHER,
> +               sizeof(header->eye_catcher))) {
> +        return H_BAD_DATA;
> +    }
> +    if (be32_to_cpu(header->stats_version) !=3D 0x1) {
> +        return H_NOT_AVAILABLE;
> +    }
> +
> +    /* verify that rr buffer has enough space */
> +    *num_stats =3D be32_to_cpu(header->num_statistics);
> +    if (*num_stats =3D=3D 0) { /* Return all stats */
> +        expected_buffsize =3D SCM_STATS_MAX_OUTPUT_BUFFER;
> +    } else { /* Return a subset of stats */
> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
> +
> +    }

We probably want a hard cap on num_stats as well, so the guest can't
force up to make arbitrarily large allocations and memory read/writes.

> +
> +    if (*size < expected_buffsize) {
> +        return H_P3;
> +    }
> +    *size =3D expected_buffsize;
> +
> +    /* verify that rr buffer is writable */
> +    if (!address_space_access_valid(&address_space_memory, addr, *size,
> +                                    true, MEMTXATTRS_UNSPECIFIED)) {

Is there any point to this, given that you'll still have to check for
errors when you go to write back the buffer later?

> +        return H_PRIVILEGE;
> +    }
> +
> +    return H_SUCCESS;
> +}
> +
> +/*
> + * For a given DRC index (R3) return one ore more performance stats of a=
n nvdimm
> + * device in guest allocated Request-and-result buffer (rr-buffer) (R4) =
of
> + * given 'size' (R5). The rr-buffer consists of a header described by
> + * 'struct papr_scm_perf_stats' that embeds the 'stats_version' and
> + * 'num_statistics' fields. This is followed by an array of
> + * 'struct papr_scm_perf_stat'. Based on the request type the writes the
> + * performance into the array of 'struct papr_scm_perf_stat' embedded in=
side
> + * the rr-buffer provided by the guest.
> + * Special cases handled are:
> + * 'size' =3D=3D 0  : Return the maximum possible size of rr-buffer
> + * 'size' !=3D 0 && 'num_statistics =3D=3D 0' : Return all possible perf=
ormance stats
> + *
> + * In case there was an error fetching a specific stats (e.g stat-id unk=
nown or
> + * any other error) then return the stat-id in R4 and also replace its s=
tat
> + * entry in rr-buffer with 'NoopStat'
> + */
> +static target_ulong h_scm_performance_stats(PowerPCCPU *cpu,
> +                                            SpaprMachineState *spapr,
> +                                            target_ulong opcode,
> +                                            target_ulong *args)
> +{
> +    const uint32_t drc_index =3D args[0];
> +    const hwaddr addr =3D args[1];
> +    size_t size =3D args[2];
> +    int index;
> +    MemTxResult result;
> +    uint32_t num_stats;
> +    uint8_t stat_id[8];
> +    unsigned long rc;
> +    uint64_t stat_val, invalid_stat =3D 0;
> +    struct papr_scm_perf_stats perfstats;
> +    struct papr_scm_perf_stat *stats, *stat;
> +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
> +
> +    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged =
in */
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    /* Guest requested max buffer size for output buffer */
> +    if (size =3D=3D 0) {
> +        args[0] =3D SCM_STATS_MAX_OUTPUT_BUFFER;
> +        return H_SUCCESS;
> +    }
> +
> +    /* Read and verify rr-buffer header */
> +    result =3D address_space_read(&address_space_memory, addr,
> +                                MEMTXATTRS_UNSPECIFIED, &perfstats,
> +                                sizeof(perfstats));

Ah.. actually you need to check that the provided size is at least big
enough to cover the header before even reading it here.

> +    if (result !=3D MEMTX_OK) {
> +        return H_PRIVILEGE;
> +    }
> +
> +    /* Verify that the rr-buffer is valid */
> +    rc =3D scm_perf_check_rr_buffer(&perfstats, addr, &size, &num_stats);
> +    if (rc !=3D H_SUCCESS) {
> +        return rc;
> +    }
> +
> +    /* allocate enough buffer space locally for holding all stats */
> +    stats =3D g_malloc0(size  - sizeof(struct papr_scm_perf_stats));

This seems unnecessarily complicated.  Why not just allocate a max
sized temporary buffer every time - it's in the tens of bytes, not
something that is really a concern from a memory usage point of view.
You could even put it on the stack.

> +    if (num_stats =3D=3D 0) { /* Return all supported stats */
> +

No blank line here.

> +        for (index =3D 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++index=
) {

Why is the starting index 1, not 0?

> +            stat =3D &stats[index - 1];
> +            memcpy(stat_id, &nvdimm_perf_stats[index].stat_id, 8);

I don't see any point to the 'stat_id' variable here.

> +            rc =3D nvdimm_stat_getval(drc, stat_id, &stat_val);

So, you're using the nvdimm_stat_getval() here in the num_stats=3D=3D0
path, which means you're not taking advatage of the fact that you
don't actually need to search through the table for your getter
function in this case.  I think that's reasonable for its simplicity,
but in that case you can make it even simpler:

Rather than having separate paths for the num_stats =3D=3D 0 and the other
case, just have the num_stats =3D=3D 0 case fill in the buffer with a
canned request which asks for each stat in turn.  Then continue on to
the selected stats path.

> +
> +            /* On error add noop stat to rr buffer & save last inval sta=
t-id */
> +            if (rc !=3D H_SUCCESS) {
> +                if (!invalid_stat) {
> +                    memcpy(&invalid_stat, &stat_id[0], 8);
> +                }
> +                memcpy(&stat_id, nvdimm_perf_stats[0].stat_id, 8);
> +                stat_val =3D 0;
> +            }
> +
> +            memcpy(&stat->statistic_id, stat_id, 8);
> +            stat->statistic_value =3D cpu_to_be64(stat_val);
> +        }
> +        /* Number of stats returned =3D=3D perf_stats array size - noop-=
stat */
> +        num_stats =3D ARRAY_SIZE(nvdimm_perf_stats) - 1;
> +
> +    } else { /* Return a subset of requested stats */
> +

No blank line.

> +        /* copy the rr-buffer from the guest memory */
> +        result =3D address_space_read(&address_space_memory,
> +                                    addr + sizeof(struct papr_scm_perf_s=
tats),
> +                                    MEMTXATTRS_UNSPECIFIED, stats,
> +                                    size - sizeof(struct papr_scm_perf_s=
tats));
> +
> +        if (result !=3D MEMTX_OK) {
> +            g_free(stats);
> +            return H_PRIVILEGE;
> +        }
> +
> +        for (index =3D 0; index < num_stats; ++index) {
> +            stat =3D &stats[index];
> +            memcpy(&stat_id, &stats->statistic_id, 8);

What's the point of the 'stat_id' temporary?

> +            rc =3D nvdimm_stat_getval(drc, stat_id, &stat_val);
> +
> +            /* On error add noop stat to rr buffer & save last inval sta=
t-id */
> +            if (rc !=3D H_SUCCESS) {
> +                if (!invalid_stat) {
> +                    memcpy(&invalid_stat, &stat_id[0], 8);
> +                }
> +                memcpy(&stat_id, nvdimm_perf_stats[0].stat_id, 8);

Why not write back directly to (the qemu copy of) the rr buffer?

> +                stat_val =3D 0;


You can also avoid the explicit stat_val =3D 0 if you make
nvdimm_stat_getval() always zero stat_val on error.

> +            }
> +
> +            memcpy(&stat->statistic_id, stat_id, 8);

AFAICT this copy only does something in the failure case.

> +            stat->statistic_value =3D cpu_to_be64(stat_val);
> +        }
> +    }
> +
> +    /* Update and copy the local rr-buffer header and stats back to gues=
t */
> +    perfstats.num_statistics =3D cpu_to_be32(num_stats);
> +    result =3D address_space_write(&address_space_memory, addr,
> +                                 MEMTXATTRS_UNSPECIFIED, &perfstats,
> +                                 sizeof(struct papr_scm_perf_stats));
> +    if (result =3D=3D MEMTX_OK) {
> +        result =3D address_space_write(&address_space_memory,
> +                                     addr + sizeof(struct papr_scm_perf_=
stats),
> +                                     MEMTXATTRS_UNSPECIFIED, stats,
> +                                     size - sizeof(struct papr_scm_perf_=
stats));
> +    }
> +
> +    /* Cleanup the stats buffer */
> +    g_free(stats);
> +
> +    if (result) {
> +        return H_PRIVILEGE;
> +    }
> +
> +    /* Check if there was a failure in fetching any stat */
> +    args[0] =3D invalid_stat;
> +    return invalid_stat ? H_PARTIAL : H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -511,6 +753,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance_=
stats);
>  }
> =20
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index d2b5a9bdf9..4b71b58e00 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -326,6 +326,7 @@ struct SpaprMachineState {
>  #define H_P8              -61
>  #define H_P9              -62
>  #define H_OVERLAP         -68
> +#define H_BAD_DATA        -70
>  #define H_UNSUPPORTED_FLAG -256
>  #define H_MULTI_THREADS_ACTIVE -9005
> =20
> @@ -539,8 +540,9 @@ struct SpaprMachineState {
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
>  #define H_SCM_HEALTH            0x400
> +#define H_SCM_PERFORMANCE_STATS 0x418
> =20
> -#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> +#define MAX_HCALL_OPCODE        H_SCM_PERFORMANCE_STATS
> =20
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.
> @@ -787,6 +789,21 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_TCE_=
TABLE)
>  DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
>                           TYPE_SPAPR_IOMMU_MEMORY_REGION)
> =20
> +/* Defs and structs exchanged with guest when reporting drc perf stats */
> +#define SCM_STATS_EYECATCHER "SCMSTATS"
> +
> +struct QEMU_PACKED papr_scm_perf_stat {
> +    uint8_t statistic_id[8];
> +    uint64_t statistic_value;
> +};
> +
> +struct QEMU_PACKED papr_scm_perf_stats {
> +    uint8_t eye_catcher[8];    /* Should be =E2=80=9CSCMSTATS=E2=80=9D */
> +    uint32_t stats_version;  /* Should be 0x01 */
> +    uint32_t num_statistics; /* Number of stats following */
> +    struct papr_scm_perf_stat scm_statistics[]; /* Performance matrics */
> +};
> +
>  struct SpaprTceTable {
>      DeviceState parent;
>      uint32_t liobn;

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--3BMvO7m36BMEQLRG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmB9CwMACgkQbDjKyiDZ
s5IunxAAybvK0QTF1JJQL7DdLVeC0xo89tCz16cce9uL+3JKJA8Ns5IC+9URvwPj
FU49BXcqp3slBQim4hTjWlJM67/xv2+wSuNXgPX7BX014One+lkUt97+C7+9AK1w
HuRAHej6I7x6xCE+glGVjInK3ofD3fDuSX3qcKXANfTOQ7oA2iemdix+Bqx2L1rO
WoCLLh2aXcoAXY9ThpHKGKxmrVbKnjK8PvO2IZyo+n1Snr/ZMzwdqbOFKaQCNq58
jg6lG9AkwHDhOemh7qHxwyzj1t9e4ilyBpf4wo5XwOfOTmWOos2d4ZBQh15pRAg1
vufO8dHU2+/APJfIbxr5FCRBrScWQXax5PQGeLlGuKbu3AEsVtHs3r+g2KoChbNQ
lqTgsVXodfO+9Cq/nKG2UDH6s/zygMPpA+YQe7Q5HEZgGj++To3MDUiLSlPIt2IT
5MIUbFCDeHlYmge52exeei/HRAyC8tSovSqxyJWtxLTJ1Ct5+OazsCx+p5Ialn2V
bZZ+fgfXvxkon0jl6C3fFrfF4jMOtVVyBrU9pB+VZCrb1aXKNTVUsHgJ4JQdECZc
/Ze+NV6DrMj3QF3UpG/SapXvuQuyxgqWZLfMex48zao5CC7RWI6INa3GJ4X/iBQu
fjNxjl7wzyzhhgmkdrF5cGMl4YImDtJdD4M0femXJZI1P+47Qlg=
=gayA
-----END PGP SIGNATURE-----

--3BMvO7m36BMEQLRG--
