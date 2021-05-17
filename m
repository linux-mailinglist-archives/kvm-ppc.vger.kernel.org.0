Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE239382440
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 May 2021 08:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhEQGZW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 May 2021 02:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhEQGZW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 May 2021 02:25:22 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE70C061573
        for <kvm-ppc@vger.kernel.org>; Sun, 16 May 2021 23:24:06 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fk8Gr45CQz9sV5; Mon, 17 May 2021 16:24:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1621232644;
        bh=9+5SunBcrB256TtSh80ohZe0jsTJiOIXUqnYTaz/WA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=afXVmfp2zmj0NgDe6veLFOcwxEx809ZlzDgNFUUfMAhfB19qHgp+AVyJqo4ImmEwm
         qORN074uxmhifKnkkeK6Ri5Va7ZQCq/YFNJ908Zg+49lR8sOx2y0MqT4vPZhB9S24Y
         wIcsSrx7/1FyWlNp8c7UQwmnHfIIsN0fswTsL4qg=
Date:   Mon, 17 May 2021 16:23:56 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: Re: [RFC PATCH v3] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
Message-ID: <YKIL/Gqc50GO+UTk@yekko>
References: <20210515073759.10505-1-vaibhav@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YOvTMxR7PuGe4o3b"
Content-Disposition: inline
In-Reply-To: <20210515073759.10505-1-vaibhav@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--YOvTMxR7PuGe4o3b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 15, 2021 at 01:07:59PM +0530, Vaibhav Jain wrote:
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
> Since RFC-v2:
> * s/SCM_STATS_MAX_OUTPUT_BUFFER/SCM_STATS_MIN_OUTPUT_BUFFER/ thats the
>   minimum size buffer needed to return all supported performance
>   stats. Value for this is derived from size of array 'nvdimm_perf_stats'
> * Added SCM_STATS_MAX_OUTPUT_BUFFER to indicate maximum supported
>   rr-buffer size from a guest. Value for this is derived from hard
>   limit of SCM_STATS_MAX_STATS.
> * Updated scm_perf_check_rr_buffer() to add a check for max size of
>   rr-buffer. [David]
> * Updated scm_perf_check_rr_buffer() to removed a reduntant check for
>   min size of rr-buffer [David]
> * Updated h_scm_performance_stats() to have a single allocation for
>   rr-buffer and copy it back to guest memory in a single shot. [David]
>=20
> Since RFC-v1:
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
>  hw/ppc/spapr_nvdimm.c  | 222 +++++++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  19 +++-
>  2 files changed, 240 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 252204e25f..287326b9c0 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -35,6 +35,19 @@
>  /* SCM device is unable to persist memory contents */
>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
> =20
> +/* Minimum output buffer size needed to return all nvdimm_perf_stats */
> +#define SCM_STATS_MIN_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats)=
 + \
> +                                      sizeof(struct papr_scm_perf_stat) =
* \
> +                                      ARRAY_SIZE(nvdimm_perf_stats))

MIN_OUTPUT_BUFFER is a better name, but still not great.  I think we
can get rid of this define completely in a neat way, though.  See below.


> +/* Maximum number of stats that we can return back in a single stat requ=
est */
> +#define SCM_STATS_MAX_STATS 255

Although it's technically allowed, I'm still not convinced there's
actually any reason to allow the user to request the same stat over
and over.

> +/* Maximum possible output buffer to fulfill a perf-stats request */
> +#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats)=
 + \
> +                                      sizeof(struct papr_scm_perf_stat) =
* \
> +                                      SCM_STATS_MAX_STATS)
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -502,6 +515,214 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, S=
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

So using a char[] here, but a uint64_t in the request structure makes
it pretty hard to follow if you're doing the right thing
w.r.t. endianness, especially since you effectively memcmp() directly
between u64s and char[]s.  You really want to use a consistent type
for the ids.

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

I don't see why you're making this temporary copy here.

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
> + * buffer-size and number of stats requested are within our expected
> + * sane bounds.
> + */
> +static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *header,
> +                                    hwaddr addr, size_t size,
> +                                    uint32_t *num_stats)
> +{
> +    size_t expected_buffsize;
> +
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
> +        expected_buffsize =3D SCM_STATS_MIN_OUTPUT_BUFFER;
> +    } else if (*num_stats > SCM_STATS_MAX_STATS) {
> +        /* Too many stats requested */
> +        return H_P3;

I'd recommend testing and exiting on this error case before handling
the all stats case.  Disposing of error cases early is more idiomatic.

You can then combine the all stats and n-stats cases a bit more nicely
with something like:
    actual_numstats =3D (*num_stats) ? (*num_stats) : ARRAY_SIZE(...);

Then use the same logic to compute the expected bufsize (min_bufsize
might be a better name) in both cases.
=09

> +    } else { /* Return a subset of stats */
> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
> +    }
> +
> +    if (size < expected_buffsize || size > SCM_STATS_MAX_OUTPUT_BUFFER) {
> +        return H_P3;

I think you can avoid the MAX_OUTPUT_BUFFER check here...

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
> +    SpaprDrc *drc =3D spapr_drc_by_index(args[0]);
> +    const hwaddr addr =3D args[1];
> +    size_t size =3D args[2];
> +    struct papr_scm_perf_stats *perfstats;
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


=2E. if you put it here instead, then you will have dealt with all
obviously bad buffer sizes early.

> +        return H_BAD_DATA;
> +    }
> +
> +    /* allocate enough buffer space locally for holding max stats */
> +    perfstats =3D g_try_malloc0(SCM_STATS_MAX_OUTPUT_BUFFER);

Then you can safely base this malloc on the given size, rather than
always over-allocating.

> +    if (!perfstats) {
> +        return H_NO_MEM;
> +    }
> +
> +    /* Read and verify rr-buffer header */
> +    result =3D address_space_read(&address_space_memory, addr,
> +                                MEMTXATTRS_UNSPECIFIED, perfstats,
> +                                sizeof(struct papr_scm_perf_stats));

And you can also read the entire thing with a single memory read here.

> +    rc =3D (result =3D=3D MEMTX_OK) ?
> +        scm_perf_check_rr_buffer(perfstats, addr, size, &num_stats) :
> +        H_PRIVILEGE;

This is a bit cryptic.  Just deal with the memtx error first, then run
the buffer validation.  Actually, you can unify the exit paths for
these and the success case by using a goto label near the end which
has the g_free() and return rc.

> +    if (rc !=3D H_SUCCESS) {
> +        g_free(perfstats);
> +        return rc;
> +    }
> +
> +    stats =3D &perfstats->scm_statistics[0];
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
> +            g_free(perfstats);
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
> +    /* Update and copy the local rr-buffer back to guest */
> +    perfstats->num_statistics =3D cpu_to_be32(num_stats);
> +    g_assert(size <=3D SCM_STATS_MAX_OUTPUT_BUFFER);
> +    result =3D address_space_write(&address_space_memory, addr,
> +                                 MEMTXATTRS_UNSPECIFIED, perfstats, size=
);
> +
> +    /* Cleanup the stats buffer */
> +    g_free(perfstats);
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
> @@ -511,6 +732,7 @@ static void spapr_scm_register_types(void)
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

--YOvTMxR7PuGe4o3b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCiC/kACgkQbDjKyiDZ
s5KpchAAqvyPpsPKJa6GRwH3BPC2TNNN7XUAcIiC18KkbJAwiytUv7qMzY/YwJrU
xpj/skE9DthrKZz9Z1M5Svui0WU8F5y8/+/xGmK2+Dsu5jNQj49+VNk32+z9GFdK
69F6j+vSmC4aIx6M8Q245Llzly9i/D/GCOm2xnhJ6G6xivhej1M4LECzvWuQ9cBI
MZDZjlhRZrxly/z7Q0sbpOGWUttvmODmTs3ygqlLLGeaYnsU795ZmfcoiWjYB4JG
D60gSFL0wvdT+RKw88lWb3AlJ76fcSU7YZxIgAN3SPzJY1aTNtlosaywqxAWiWCC
h/2SUdxzbP5DfBlMOVs2IHh9bsH3ZwLZZEsmQfsuU7khU3qHu3sAUYwgZ6isX0ze
OJm3EMuxGxT3TXUgGNPLgVaV4JYeoCPWpkZ65yVz5wKeaFRjmsCWqCgeHXIz0q+2
GCCQu5VwtlrFYOcmfRFYZoHYz8rRNYt93raihgpGEiUn/X+kuFmOe2hMygH7MRF7
3Gm6lcahXNaZ21LX4hUU18gMW6vz0OhfySFh32W2NAa4UwSq5+9ShGKr9m74zffT
a+3gI1kY4YCkjaPKOyIbozcRu/RI5rHJMrqOJJgCWbzF4xfuW57LuXEKGsohI9i5
EfLN6Sh22fjjgblMo4bzazB8qy/ZLQ48SYj5RoaAKzwM+fNt31Y=
=KL5e
-----END PGP SIGNATURE-----

--YOvTMxR7PuGe4o3b--
