Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96A13924AC
	for <lists+kvm-ppc@lfdr.de>; Thu, 27 May 2021 04:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhE0CDM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 26 May 2021 22:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhE0CDL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 26 May 2021 22:03:11 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A1DC061574
        for <kvm-ppc@vger.kernel.org>; Wed, 26 May 2021 19:01:37 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fr9zM2nCRz9sTD; Thu, 27 May 2021 12:01:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622080895;
        bh=F3DR5SqWKl93YjlPOn9qei0j/vQ1Z6+h2VNdsMA4ZdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRt84QBe5KXv+/C2lGyBJ1GMcL4r7UGQguGvReYgYayamIWSxS0UI8Na+x4LUI3FJ
         chQa0ZLhCfdM0R/9ZD97F63wQXZ40RRMkWpKX3tY8o5x+XzC3zI9Xk03iId0uPqP4G
         60UJo8ocVaz2Nj+Lal95OzLPZlKJ1IZdPvEjvd+w=
Date:   Thu, 27 May 2021 12:01:30 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: Re: [RFC PATCH v4] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
Message-ID: <YK79eipSGbzTLMlp@yekko>
References: <20210526030057.395092-1-vaibhav@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LnWaO7eUupCepdFO"
Content-Disposition: inline
In-Reply-To: <20210526030057.395092-1-vaibhav@linux.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--LnWaO7eUupCepdFO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 26, 2021 at 08:30:57AM +0530, Vaibhav Jain wrote:
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

Looking fairly good now.  A few trivial nits, one remaining bug (I
suspect) and of course the fact that you don't yet have any
non-example stats to return.

> ---
> Changelog
>=20
> Since RFC-v3:
> * Introduced consistent types 'perf_stat_id/val' for handling
>   perf-stats in code rather than switching between u64 and char[8]. [
>   David Gibson ]
> * Removed a redundant temporary variable 'stat_id' usage from
>   nvdimm_stat_getval() [ David Gibson ]
> * Move the tests for buffer sizes around to a a central place in
>   h_scm_performance_stats() [ David Gibson ]
> * Update the allocation size/type of rr-buffer in
>   h_scm_performance_stats [ David Gibson, Groug ]
> * Reworked the loop for generating canned-response in
>   h_scm_performance_stats().
> * Reworked logic for returning an unknown stat-id in h_scm_performance_st=
ats().
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
>  hw/ppc/spapr_nvdimm.c  | 219 +++++++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  22 ++++-
>  2 files changed, 240 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 252204e25f..81ab2811bc 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -35,6 +35,23 @@
>  /* SCM device is unable to persist memory contents */
>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
> =20
> +/* Maximum number of stats that we can return back in a single stat requ=
est */
> +#define SCM_STATS_MAX_STATS 255
> +
> +/* Given _numstats_ !=3D 0 calculate the size of RR buffer required */
> +#define SCM_STATS_RR_BUFFER_SIZE(_numstats_)                            \
> +    (sizeof(struct papr_scm_perf_stats) +                               \
> +     sizeof(struct papr_scm_perf_stat) *                                \
> +     (_numstats_))
> +
> +/* Maximum possible output buffer to fulfill a perf-stats request */
> +#define SCM_STATS_MAX_OUTPUT_BUFFER  \
> +    (SCM_STATS_RR_BUFFER_SIZE(SCM_STATS_MAX_STATS))
> +
> +/* Minimum output buffer size needed to return all perf_stats except noo=
pstat */
> +#define SCM_STATS_MIN_OUTPUT_BUFFER  (SCM_STATS_RR_BUFFER_SIZE\

Nit: linebreak before the macro body, like MAX_OUTPUT_BUFFER would be
more readable.

> +                                      (ARRAY_SIZE(nvdimm_perf_stats) - 1=
))
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -502,6 +519,207 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, S=
paprMachineState *spapr,
>      return H_SUCCESS;
>  }
> =20
> +static int perf_stat_noop(SpaprDrc *drc, perf_stat_id unused,
> +                          perf_stat_val *val)
> +{
> +    *val =3D 0;
> +    return H_SUCCESS;
> +}
> +
> +static int perf_stat_memlife(SpaprDrc *drc, perf_stat_id unused,
> +                             perf_stat_val *val)
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
> +    perf_stat_id stat_id;
> +    int  (*stat_getval)(SpaprDrc *drc, perf_stat_id id, perf_stat_val *v=
al);
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
> +static int nvdimm_stat_getval(SpaprDrc *drc, perf_stat_id id,
> +                              perf_stat_val *val)
> +{
> +    int index;
> +
> +    *val =3D 0;
> +
> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
> +        if (!memcmp(&nvdimm_perf_stats[index].stat_id, id,
> +                    sizeof(perf_stat_id))) {
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
> +    if (*num_stats > SCM_STATS_MAX_STATS) {
> +        /* Too many stats requested */
> +        return H_P3;
> +    }
> +
> +    expected_buffsize  =3D *num_stats ?
> +        SCM_STATS_RR_BUFFER_SIZE(*num_stats) : SCM_STATS_MIN_OUTPUT_BUFF=
ER;
> +    if (size < expected_buffsize) {
> +        return H_P3;
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
> +    g_autofree struct papr_scm_perf_stats *perfstats =3D NULL;
> +    struct papr_scm_perf_stat *stats;
> +    perf_stat_val stat_val;
> +    uint32_t num_stats;
> +    int index;
> +    long rc;
> +
> +    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged =
in */
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    /* Guest requested max buffer size for output buffer */

Nit: comment reads confusingly with the name "MIN_OUTPUT_BUFFER",
clarify please.

> +    if (size =3D=3D 0) {
> +        args[0] =3D SCM_STATS_MIN_OUTPUT_BUFFER;
> +        return H_SUCCESS;
> +    }
> +
> +    /* verify size is enough to hold rr-buffer */
> +    if (size < sizeof(struct papr_scm_perf_stats)) {
> +        return H_BAD_DATA;
> +    }
> +
> +    if (size > SCM_STATS_MAX_OUTPUT_BUFFER) {
> +        return H_P3;
> +    }
> +
> +    /* allocate enough buffer space locally for holding max stats */

Nit: comment is no longer accurate now that you allocate based on the
given size.

> +    perfstats =3D g_try_malloc0(size);
> +    if (!perfstats) {
> +        return H_NO_MEM;
> +    }
> +    stats =3D &perfstats->scm_statistics[0];
> +
> +    /* Read and verify rr-buffer */
> +    rc =3D address_space_read(&address_space_memory, addr, MEMTXATTRS_UN=
SPECIFIED,
> +                            perfstats, size);
> +    if (rc !=3D MEMTX_OK) {
> +        return H_PRIVILEGE;
> +    }
> +    rc =3D scm_perf_check_rr_buffer(perfstats, addr, size, &num_stats);
> +    if (rc !=3D H_SUCCESS) {
> +        return rc;
> +    }
> +
> +    /* when returning all stats generate a canned response first */
> +    if (num_stats =3D=3D 0) {
> +        /* Ignore 'noopstat' when generating canned response */
> +        for (num_stats =3D 0; num_stats < ARRAY_SIZE(nvdimm_perf_stats) =
- 1;
> +             ++num_stats) {
> +            memcpy(&stats[num_stats].statistic_id,
> +                   nvdimm_perf_stats[num_stats + 1].stat_id,
> +                   sizeof(perf_stat_id));
> +        }
> +    }
> +
> +    /* Populate the rr-buffer with stat values */
> +    for (args[0] =3D 0, index =3D 0; index < num_stats; ++index) {
> +        rc =3D nvdimm_stat_getval(drc, stats[index].statistic_id, &stat_=
val);
> +
> +        /* On error add noop stat to rr buffer & save last inval stat-id=
 */
> +        if (rc !=3D H_SUCCESS) {
> +            if (!args[0]) {
> +                memcpy(&args[0], stats[index].statistic_id,
> +                       sizeof(perf_stat_id));

args[0] is effectively a return register, stored in *host native*
order, so I think you need a be64_to_cpu() here, though I guess you
need to check how PAPR says you're supposed to load the stat ids into
a register.

> +            }
> +            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].stat=
_id,
> +                   sizeof(perf_stat_id));
> +        }
> +        /* Caller expects stat values in BE encoding */
> +        stats[index].statistic_value =3D cpu_to_be64(stat_val);
> +    }
> +
> +    /* Update and copy the local rr-buffer back to guest */
> +    perfstats->num_statistics =3D cpu_to_be32(num_stats);
> +    g_assert(size <=3D SCM_STATS_MAX_OUTPUT_BUFFER);
> +    rc =3D address_space_write(&address_space_memory, addr,
> +                             MEMTXATTRS_UNSPECIFIED, perfstats, size);
> +
> +    if (rc !=3D MEMTX_OK) {
> +        return H_PRIVILEGE;
> +    }
> +
> +    /* Check if there was a failure in fetching any stat */
> +    return args[0] ? H_PARTIAL : H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -511,6 +729,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance_=
stats);
>  }
> =20
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index bbf817af46..9e093b3a00 100644
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
> @@ -793,6 +795,24 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_TCE_=
TABLE)
>  DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
>                           TYPE_SPAPR_IOMMU_MEMORY_REGION)
> =20
> +/* Defs and structs exchanged with guest when reporting drc perf stats */
> +#define SCM_STATS_EYECATCHER "SCMSTATS"
> +
> +typedef char perf_stat_id[8];
> +typedef uint64_t perf_stat_val;
> +
> +struct QEMU_PACKED papr_scm_perf_stat {
> +    perf_stat_id statistic_id;
> +    perf_stat_val statistic_value;
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

--LnWaO7eUupCepdFO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCu/XgACgkQbDjKyiDZ
s5KZKRAAoy7aquZx/uuFU60wnK8KHhfbSEYJc4CtB1pZBUcckahcNpKP5JpXpYQN
K16VLg1KpXxKYrlVYgXGKuQmdopZBn9P4L40XCMcO41LMXZHXKEwVuT2NOXEHz/9
y5/kLGPQoifNGPoD2F6LebejZ+jhW9TIFggg0vc1WSF4up5AdgpZbMEDViPvXyHq
fkx5XjmKJCa2iJCSHcSpEc0XhuAvrT+c/+/n1NSWI+pWX7iviqL+as3wxBIASP8A
fbeghaTlXbWdq60ug3xqEoLnB034wVW7anv5QgzJN0rSpUYXcD1yVe9sY/PtPPPc
9SfZb8tLv9KTUsnIHeiwFvNjmVz1NrAvxujwO2qAGZUtikbJaQVa04GfVcR5uoCv
c1wOlnzXHZbuxTe5OfUMarftR+tAZQrcEfA/sE6V0rszMDwL7SFDFrcVLFpduAsp
QCbEONpGKxUJHNjq/dArZ0fYY7jtOUZWHNhCPKItLJowg93rpUCmHVJ+cCcwQP57
N5tZMAN61vIOs4Mm8Pus5WhjbqVifm1zZXWfovGt2eub8hgIvN/4C/83IUzGu08L
Xjsv4UTQ+yx+Vjhr6u2yYUFKRRd1BBNxjSuvzMBbWwlWVAj3FrzfV35+LKDdIwKM
78oCj2Th8KupjmhQVK+R8bgRUHXsS//sS+q4/2FubfgrOktXJbc=
=GbKt
-----END PGP SIGNATURE-----

--LnWaO7eUupCepdFO--
