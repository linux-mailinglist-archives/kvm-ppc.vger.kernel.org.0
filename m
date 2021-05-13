Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92937F1F0
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 06:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhEMEYE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 00:24:04 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45437 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhEMEYD (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 13 May 2021 00:24:03 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fgdms1Ksxz9sj1; Thu, 13 May 2021 14:22:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620879773;
        bh=37GQ28aLGudnNvfy3pHEuLeTlBeXdQ09NFhYoM05F0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mjkRAZZCxPbhLToBMbLqHuRzvG4715cshDSIpJ5IfbCtuKjQFf2EoHuyG0taFpquV
         9B/0gdLQfDhiuOnaDH109arXguLHZK/XempIEmrd9mzeWn5jsoecld9qvtUUAvWXSO
         fAdGTdT9lePkW7N3cfuz0RGmfsjAL5qWFzGVsccM=
Date:   Thu, 13 May 2021 13:41:35 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: Re: [RFC PATCH v2] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
Message-ID: <YJyf71+xbdi3Iptf@yekko>
References: <20210506024924.85526-1-vaibhav@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CVC0c5XsJF0gwAch"
Content-Disposition: inline
In-Reply-To: <20210506024924.85526-1-vaibhav@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--CVC0c5XsJF0gwAch
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 06, 2021 at 08:19:24AM +0530, Vaibhav Jain wrote:
> Add support for H_SCM_PERFORMANCE_STATS described at [1] for
> spapr nvdimms. This enables guest to fetch performance stats[2] like
> expected life of an nvdimm ('MemLife ') etc and display them to the
> user. Linux kernel support for fetching these performance stats and
> exposing them to the user-space was done via [3].
>=20
> The hcall semantics mandate that each nvdimm performance stats is
> uniquely identied by a 8-byte ascii string encoded as an unsigned
> integer (e.g 'MemLife ' =3D=3D 0x4D656D4C69666520) and its value be a
> 8-byte unsigned integer. These performance-stats are exchanged with
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
> Changelog
>=20
> RFC-v1:
> * Removed empty lines from code [ David ]
> * Updated struct papr_scm_perf_stat to use uint64_t for
>   statistic_id.
> * Added a hard limit on max number of stats requested to 255 [ David ]
> * Updated scm_perf_check_rr_buffer() to check for rr-buffer header
>   size [ David ]
> * Removed a redundant check from nvdimm_stat_getval() [ David ]
> * Removed a redundant call to address_space_access_valid() in
>   scm_perf_check_rr_buffer() [ David ]
> * Instead of allocating a minimum size local buffer, allocate a max
>   possible size local rr-buffer. [ David ]
> * Updated nvdimm_stat_getval() to set 'val' to '0' on error. [ David ]
> * Updated h_scm_performance_stats() to use a canned-response method
>   for simplifying num_stats=3D=3D0 case [ David ].
> ---
>  hw/ppc/spapr_nvdimm.c  | 230 +++++++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  19 +++-
>  2 files changed, 248 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 252204e25f..b0c2b55a5b 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -35,6 +35,14 @@
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
> +/* Maximum number of stats that we can return back in a single stat requ=
est */
> +#define SCM_STATS_MAX_STATS 255
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -502,6 +510,227 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, S=
paprMachineState *spapr,
>      return H_SUCCESS;
>  }
> =20
> +static int perf_stat_noop(SpaprDrc *drc, uint64_t unused, uint64_t *val)
> +{
> +    *val =3D 0;
> +    return H_SUCCESS;
> +}
> +
> +static int perf_stat_memlife(SpaprDrc *drc, uint64_t unused, uint64_t *v=
al)
> +{
> +    /* Assume full life available of an NVDIMM right now */
> +    *val =3D 100;
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
> +    int  (*stat_getval)(SpaprDrc *drc, uint64_t id, uint64_t *val);
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
> +static int nvdimm_stat_getval(SpaprDrc *drc, uint64_t id, uint64_t *val)
> +{
> +    int index;
> +    char stat_id[8];
> +
> +    /* since comparision is done */
> +    memcpy(&stat_id[0], &id, 8);
> +    *val =3D 0;
> +
> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
> +        if (memcmp(nvdimm_perf_stats[index].stat_id, &stat_id[0], 8) =3D=
=3D 0) {
> +            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
> +        }
> +    }
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
> +    /* verify size is enough to hold rr-buffer header */
> +    if (*size < sizeof(struct papr_scm_perf_stats)) {
> +        return H_BAD_DATA;
> +    }

You have already checked this in the caller, so strictly speaking you
don't need to do so again.

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

I don't think this is right.  MAX_OUTPUT_BUFFER is based on 255 stats
being returned, but num_stats=3D=3D0 only returns 2 at present.

> +    } else if (*num_stats > SCM_STATS_MAX_STATS) {
> +        /* Too many stats requested */
> +        return H_P3;
> +    } else { /* Return a subset of stats */
> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
> +    }
> +
> +    if (*size < expected_buffsize) {
> +        return H_P3;
> +    }
> +    *size =3D expected_buffsize;
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
> +    SpaprDrc *drc =3D spapr_drc_by_index(args[0]);
> +    const hwaddr addr =3D args[1];
> +    size_t size =3D args[2];
> +    struct papr_scm_perf_stats perfstats;
> +    struct papr_scm_perf_stat *stats;
> +    uint64_t invalid_stat =3D 0, stat_val;
> +    MemTxResult result;
> +    uint32_t num_stats;
> +    unsigned long rc;
> +    int index;
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
> +    /* verify size is enough to hold rr-buffer header */
> +    if (size < sizeof(struct papr_scm_perf_stats)) {
> +        return H_BAD_DATA;
> +    }
> +
> +    /* Read and verify rr-buffer header */
> +    result =3D address_space_read(&address_space_memory, addr,
> +                                MEMTXATTRS_UNSPECIFIED, &perfstats,
> +                                sizeof(perfstats));
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
> +    /* allocate enough buffer space locally for holding max stats */
> +    stats =3D g_try_malloc0(SCM_STATS_MAX_STATS *
> +                          sizeof(struct papr_scm_perf_stat));

I think you can simplify the allocation and mem read/write logic even
further.  You're given the expected buffer size in a register.  So you
can fail out early if that value is too large (> MAX_OUTPUT_BUFFER) or
too small (< header size).

Then you can make a single allocation of (size) bytes and copy in both
the header and the body as one unit.  Validate and fill it, then write
it back as a single unit as well.

> +    if (!stats) {
> +        return H_NO_MEM;
> +    }
> +
> +    /* when returning all stats generate a canned response first */
> +    if (num_stats =3D=3D 0) {
> +        for (index =3D 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++index=
) {
> +            memcpy(&stats[index - 1].statistic_id,
> +                   &nvdimm_perf_stats[index].stat_id, 8);
> +        }
> +        num_stats =3D ARRAY_SIZE(nvdimm_perf_stats) - 1;
> +    } else {
> +        /* copy the rr-buffer from the guest memory */
> +        result =3D address_space_read(&address_space_memory,
> +                                    addr + sizeof(struct papr_scm_perf_s=
tats),
> +                                    MEMTXATTRS_UNSPECIFIED, stats,
> +                                    size - sizeof(struct papr_scm_perf_s=
tats));
> +        if (result !=3D MEMTX_OK) {
> +            g_free(stats);
> +            return H_PRIVILEGE;
> +        }
> +    }
> +
> +    for (index =3D 0; index < num_stats; ++index) {
> +        rc =3D nvdimm_stat_getval(drc, stats[index].statistic_id, &stat_=
val);
> +
> +        /* On error add noop stat to rr buffer & save last inval stat-id=
 */
> +        if (rc !=3D H_SUCCESS) {
> +            if (!invalid_stat) {
> +                invalid_stat =3D stats[index].statistic_id;
> +            }
> +            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].stat=
_id, 8);
> +        }
> +        /* Caller expects stat values in BE encoding */
> +        stats[index].statistic_value =3D cpu_to_be64(stat_val);
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
> +    /* Cleanup the stats buffer */
> +    g_free(stats);
> +    if (result) {
> +        return H_PRIVILEGE;
> +    }
> +    /* Check if there was a failure in fetching any stat */
> +    args[0] =3D invalid_stat;
> +    return invalid_stat ? H_PARTIAL : H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -511,6 +740,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance_=
stats);
>  }
> =20
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index d2b5a9bdf9..6f3353b4ea 100644
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
> +    uint64_t statistic_id;
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

--CVC0c5XsJF0gwAch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCcn+0ACgkQbDjKyiDZ
s5I0Sg//QruBAyJENjYLpmeSNhn433VVlkH01gYYJluEJ8VGjd8NdhPx8Qfm9+hm
4lKNfuebr5rOYAZuXK9vASgUtkRxScy2ZxLEQ789yTh4yGWjGQvtSAzvCassN25e
yk9vb5aUh0Q7RPLttTXqOHgjJ3fIhO9VWD6YADwaB64GpGOxWup/BPAJUW8G6QC8
CruJRfL+QFyGcaZkB+I8KM7JoBQUfopaI5F/3tVCQ1yb+W73jM7WPzJQh+pJj6Wz
XvmYDjk/G9ARvO/vFMY9bJJQCketGNPR0KyYhg/Qr/qlLqNOg+rVGiC6D9lYCzpI
KQn8CyRNqdIBigFOLpYgjko8ZqtnMYTvE3Guo5oS60rXpl1ns8pZHNiO3QY2ptzp
sMwKIII8I2SKos4o449D4G7NkiszKm6I/8PXU3+9RKVVYQBmpIHuAQFsFHdpIFiq
VoLykyhBhTyA5HFcTEqqVYG/cJUz+s6xYr4kRVgR/AJV9VKiQoCHv7HY+LxKu+Ae
DCFy5BslGGTl3IHTrWKt+kaW4VUOvw9xM5MPw935Xpc7N/0QTm2tCGikJbMqVi+C
lXRNOGUsBg3EEFfr0thuUewNg6e6YfEPZdVL/ootFg4e66miC/SO3r6WvT/UFQnU
E6CAjmePmJaenHJRaXYDb0OEdXMfqUtTvv5w4BM8BHxowpO4VAU=
=mOUd
-----END PGP SIGNATURE-----

--CVC0c5XsJF0gwAch--
