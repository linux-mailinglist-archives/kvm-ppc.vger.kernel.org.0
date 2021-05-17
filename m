Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CAA382451
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 May 2021 08:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhEQGaT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 May 2021 02:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhEQGaS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 17 May 2021 02:30:18 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16552C06174A
        for <kvm-ppc@vger.kernel.org>; Sun, 16 May 2021 23:28:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fk8NQ221mz9sWp; Mon, 17 May 2021 16:28:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1621232934;
        bh=lEDgk6zmFK5BGaJXYLDfTHnnCUHv4OOMWNl4axFFGdc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJTg77YFJbXgHkhsrMO0dcMYWkRkznA8F1FJfC8oVDsQRqOI6QgL8tJMsTraLbc4Z
         Um9LTiXj2xyGUJh3T3oEr5nJ4u+7ypuEFrbMXTA5OTzpQu9qS9hiAnfYf0nVI8KnAN
         PPQnHG6P5TJoqnZtjULfu2Qe+hWHptpOtWHiXUOw=
Date:   Mon, 17 May 2021 16:24:54 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     xiaoguangrong.eric@gmail.com, mst@redhat.com,
        aneesh.kumar@linux.ibm.com, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, groug@kaod.org, shivaprasadbhat@gmail.com,
        qemu-ppc@nongnu.org, bharata@linux.vnet.ibm.com,
        imammedo@redhat.com, ehabkost@redhat.com
Subject: Re: [RFC PATCH v2] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
Message-ID: <YKIMNg9iIzmdru17@yekko>
References: <20210506024924.85526-1-vaibhav@linux.ibm.com>
 <YJyf71+xbdi3Iptf@yekko>
 <87eee8bqnf.fsf@vajain21.in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7G5YsXRJQ1uxvaQr"
Content-Disposition: inline
In-Reply-To: <87eee8bqnf.fsf@vajain21.in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--7G5YsXRJQ1uxvaQr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 15, 2021 at 09:21:48AM +0530, Vaibhav Jain wrote:
> Thanks for looking into this patch David
>=20
> David Gibson <david@gibson.dropbear.id.au> writes:
>=20
> > On Thu, May 06, 2021 at 08:19:24AM +0530, Vaibhav Jain wrote:
> >> Add support for H_SCM_PERFORMANCE_STATS described at [1] for
> >> spapr nvdimms. This enables guest to fetch performance stats[2] like
> >> expected life of an nvdimm ('MemLife ') etc and display them to the
> >> user. Linux kernel support for fetching these performance stats and
> >> exposing them to the user-space was done via [3].
> >>=20
> >> The hcall semantics mandate that each nvdimm performance stats is
> >> uniquely identied by a 8-byte ascii string encoded as an unsigned
> >> integer (e.g 'MemLife ' =3D=3D 0x4D656D4C69666520) and its value be a
> >> 8-byte unsigned integer. These performance-stats are exchanged with
> >> the guest in via a guest allocated buffer called
> >> 'requestAndResultBuffer' or rr-buffer for short. This buffer contains
> >> a header descibed by 'struct papr_scm_perf_stats' followed by an array
> >> of performance-stats described by 'struct papr_scm_perf_stat'. The
> >> hypervisor is expected to validate the rr-buffer header and then based
> >> on the request copy the needed performance-stats to the array of
> >> 'struct papr_scm_perf_stat' following the header.
> >>=20
> >> The patch proposes a new function h_scm_performance_stats() that
> >> services the H_SCM_PERFORMANCE_STATS hcall. After verifying the
> >> validity of the rr-buffer header via scm_perf_check_rr_buffer() it
> >> proceeds to fill the rr-buffer with requested performance-stats. The
> >> value of individual stats is retrived from individual accessor
> >> function for the stat which are indexed in the array
> >> 'nvdimm_perf_stats'.
> >>=20
> >> References:
> >> [1] "Hypercall Op-codes (hcalls)"
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/Documentation/powerpc/papr_hcalls.rst#n269
> >> [2] Sysfs attribute documentation for papr_scm
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/Documentation/ABI/testing/sysfs-bus-papr-pmem#n36
> >> [3] "powerpc/papr_scm: Fetch nvdimm performance stats from PHYP"
> >> https://lore.kernel.org/r/20200731064153.182203-2-vaibhav@linux.ibm.com
> >>=20
> >> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> >> ---
> >> Changelog
> >>=20
> >> RFC-v1:
> >> * Removed empty lines from code [ David ]
> >> * Updated struct papr_scm_perf_stat to use uint64_t for
> >>   statistic_id.
> >> * Added a hard limit on max number of stats requested to 255 [ David ]
> >> * Updated scm_perf_check_rr_buffer() to check for rr-buffer header
> >>   size [ David ]
> >> * Removed a redundant check from nvdimm_stat_getval() [ David ]
> >> * Removed a redundant call to address_space_access_valid() in
> >>   scm_perf_check_rr_buffer() [ David ]
> >> * Instead of allocating a minimum size local buffer, allocate a max
> >>   possible size local rr-buffer. [ David ]
> >> * Updated nvdimm_stat_getval() to set 'val' to '0' on error. [ David ]
> >> * Updated h_scm_performance_stats() to use a canned-response method
> >>   for simplifying num_stats=3D=3D0 case [ David ].
> >> ---
> >>  hw/ppc/spapr_nvdimm.c  | 230 +++++++++++++++++++++++++++++++++++++++++
> >>  include/hw/ppc/spapr.h |  19 +++-
> >>  2 files changed, 248 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> >> index 252204e25f..b0c2b55a5b 100644
> >> --- a/hw/ppc/spapr_nvdimm.c
> >> +++ b/hw/ppc/spapr_nvdimm.c
> >> @@ -35,6 +35,14 @@
> >>  /* SCM device is unable to persist memory contents */
> >>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
> >> =20
> >> +/* Maximum output buffer size needed to return all nvdimm_perf_stats =
*/
> >> +#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_sta=
ts) + \
> >> +                                      sizeof(struct papr_scm_perf_sta=
t) * \
> >> +                                      ARRAY_SIZE(nvdimm_perf_stats))
> >> +
> >> +/* Maximum number of stats that we can return back in a single stat r=
equest */
> >> +#define SCM_STATS_MAX_STATS 255
> >> +
> >>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice =
*nvdimm,
> >>                             uint64_t size, Error **errp)
> >>  {
> >> @@ -502,6 +510,227 @@ static target_ulong h_scm_health(PowerPCCPU *cpu=
, SpaprMachineState *spapr,
> >>      return H_SUCCESS;
> >>  }
> >> =20
> >> +static int perf_stat_noop(SpaprDrc *drc, uint64_t unused, uint64_t *v=
al)
> >> +{
> >> +    *val =3D 0;
> >> +    return H_SUCCESS;
> >> +}
> >> +
> >> +static int perf_stat_memlife(SpaprDrc *drc, uint64_t unused, uint64_t=
 *val)
> >> +{
> >> +    /* Assume full life available of an NVDIMM right now */
> >> +    *val =3D 100;
> >> +    return H_SUCCESS;
> >> +}
> >> +
> >> +/*
> >> + * Holds all supported performance stats accessors. Each performance-=
statistic
> >> + * is uniquely identified by a 8-byte ascii string for example: 'MemL=
ife '
> >> + * which indicate in percentage how much usage life of an nvdimm is r=
emaining.
> >> + * 'NoopStat' which is primarily used to test support for retriving p=
erformance
> >> + * stats and also to replace unknown stats present in the rr-buffer.
> >> + *
> >> + */
> >> +static const struct {
> >> +    char stat_id[8];
> >> +    int  (*stat_getval)(SpaprDrc *drc, uint64_t id, uint64_t *val);
> >> +} nvdimm_perf_stats[] =3D {
> >> +    { "NoopStat", perf_stat_noop},
> >> +    { "MemLife ", perf_stat_memlife},
> >> +};
> >> +
> >> +/*
> >> + * Given a nvdimm drc and stat-name return its value. In case given s=
tat-name
> >> + * isnt supported then return H_PARTIAL.
> >> + */
> >> +static int nvdimm_stat_getval(SpaprDrc *drc, uint64_t id, uint64_t *v=
al)
> >> +{
> >> +    int index;
> >> +    char stat_id[8];
> >> +
> >> +    /* since comparision is done */
> >> +    memcpy(&stat_id[0], &id, 8);
> >> +    *val =3D 0;
> >> +
> >> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
> >> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index)=
 {
> >> +        if (memcmp(nvdimm_perf_stats[index].stat_id, &stat_id[0], 8) =
=3D=3D 0) {
> >> +            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
> >> +        }
> >> +    }
> >> +    return H_PARTIAL;
> >> +}
> >> +
> >> +/*
> >> + * Given a request & result buffer header verify its contents. Also
> >> + * verify that buffer & buffer-size provided by the guest is accessib=
le and
> >> + * large enough to hold the requested stats. The size of buffer neede=
d to
> >> + * hold the requested 'num_stat' number of stats is returned in 'size=
'.
> >> + */
> >> +static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *heade=
r,
> >> +                                    hwaddr addr, size_t *size,
> >> +                                    uint32_t *num_stats)
> >> +{
> >> +    size_t expected_buffsize;
> >> +
> >> +    /* verify size is enough to hold rr-buffer header */
> >> +    if (*size < sizeof(struct papr_scm_perf_stats)) {
> >> +        return H_BAD_DATA;
> >> +    }
> >
> > You have already checked this in the caller, so strictly speaking you
> > don't need to do so again.
> >
> Sure, removed this check in v3.
>=20
> >> +    /* Verify the header eyecather and version */
> >> +    if (memcmp(&header->eye_catcher, SCM_STATS_EYECATCHER,
> >> +               sizeof(header->eye_catcher))) {
> >> +        return H_BAD_DATA;
> >> +    }
> >> +    if (be32_to_cpu(header->stats_version) !=3D 0x1) {
> >> +        return H_NOT_AVAILABLE;
> >> +    }
> >> +
> >> +    /* verify that rr buffer has enough space */
> >> +    *num_stats =3D be32_to_cpu(header->num_statistics);
> >> +    if (*num_stats =3D=3D 0) { /* Return all stats */
> >> +        expected_buffsize =3D SCM_STATS_MAX_OUTPUT_BUFFER;
> >
> > I don't think this is right.  MAX_OUTPUT_BUFFER is based on 255 stats
> > being returned, but num_stats=3D=3D0 only returns 2 at present.
> >
> MAX_OUTPUT_BUFFER is the size of buffer required to return all unique
> performance-stats and is dependent on the size if array
> 'nvdimm_perf_stats' and not the hard limit of 255. Since presently
> 'nvdimm_perf_stats' only holds two entries right now hence the above
> assignmen is correct.

Sorry, I misread the new definition.

> I understand that MAX_OUTPUT_BUFFER can be perhaps wrongly named hence
> have changed it to MIN_OUTPUT_BUFFER in v3.

> >> +    } else if (*num_stats > SCM_STATS_MAX_STATS) {
> >> +        /* Too many stats requested */
> >> +        return H_P3;
> >> +    } else { /* Return a subset of stats */
> >> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
> >> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
> >> +    }
> >> +
> >> +    if (*size < expected_buffsize) {
> >> +        return H_P3;
> >> +    }
> >> +    *size =3D expected_buffsize;
> >> +
> >> +    return H_SUCCESS;
> >> +}
> >> +
> >> +/*
> >> + * For a given DRC index (R3) return one ore more performance stats o=
f an nvdimm
> >> + * device in guest allocated Request-and-result buffer (rr-buffer) (R=
4) of
> >> + * given 'size' (R5). The rr-buffer consists of a header described by
> >> + * 'struct papr_scm_perf_stats' that embeds the 'stats_version' and
> >> + * 'num_statistics' fields. This is followed by an array of
> >> + * 'struct papr_scm_perf_stat'. Based on the request type the writes =
the
> >> + * performance into the array of 'struct papr_scm_perf_stat' embedded=
 inside
> >> + * the rr-buffer provided by the guest.
> >> + * Special cases handled are:
> >> + * 'size' =3D=3D 0  : Return the maximum possible size of rr-buffer
> >> + * 'size' !=3D 0 && 'num_statistics =3D=3D 0' : Return all possible p=
erformance stats
> >> + *
> >> + * In case there was an error fetching a specific stats (e.g stat-id =
unknown or
> >> + * any other error) then return the stat-id in R4 and also replace it=
s stat
> >> + * entry in rr-buffer with 'NoopStat'
> >> + */
> >> +static target_ulong h_scm_performance_stats(PowerPCCPU *cpu,
> >> +                                            SpaprMachineState *spapr,
> >> +                                            target_ulong opcode,
> >> +                                            target_ulong *args)
> >> +{
> >> +    SpaprDrc *drc =3D spapr_drc_by_index(args[0]);
> >> +    const hwaddr addr =3D args[1];
> >> +    size_t size =3D args[2];
> >> +    struct papr_scm_perf_stats perfstats;
> >> +    struct papr_scm_perf_stat *stats;
> >> +    uint64_t invalid_stat =3D 0, stat_val;
> >> +    MemTxResult result;
> >> +    uint32_t num_stats;
> >> +    unsigned long rc;
> >> +    int index;
> >> +
> >> +    /* Ensure that the drc is valid & is valid PMEM dimm and is plugg=
ed in */
> >> +    if (!drc || !drc->dev ||
> >> +        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> >> +        return H_PARAMETER;
> >> +    }
> >> +
> >> +    /* Guest requested max buffer size for output buffer */
> >> +    if (size =3D=3D 0) {
> >> +        args[0] =3D SCM_STATS_MAX_OUTPUT_BUFFER;
> >> +        return H_SUCCESS;
> >> +    }
> >> +
> >> +    /* verify size is enough to hold rr-buffer header */
> >> +    if (size < sizeof(struct papr_scm_perf_stats)) {
> >> +        return H_BAD_DATA;
> >> +    }
> >> +
> >> +    /* Read and verify rr-buffer header */
> >> +    result =3D address_space_read(&address_space_memory, addr,
> >> +                                MEMTXATTRS_UNSPECIFIED, &perfstats,
> >> +                                sizeof(perfstats));
> >> +    if (result !=3D MEMTX_OK) {
> >> +        return H_PRIVILEGE;
> >> +    }
> >> +
> >> +    /* Verify that the rr-buffer is valid */
> >> +    rc =3D scm_perf_check_rr_buffer(&perfstats, addr, &size, &num_sta=
ts);
> >> +    if (rc !=3D H_SUCCESS) {
> >> +        return rc;
> >> +    }
> >> +
> >> +    /* allocate enough buffer space locally for holding max stats */
> >> +    stats =3D g_try_malloc0(SCM_STATS_MAX_STATS *
> >> +                          sizeof(struct papr_scm_perf_stat));
> >
> > I think you can simplify the allocation and mem read/write logic even
> > further.  You're given the expected buffer size in a register.  So you
> > can fail out early if that value is too large (> MAX_OUTPUT_BUFFER) or
> > too small (< header size).
> Yes, thanks for suggesting this. I have added a check in
> scm_perf_check_rr_buffer() to check the size-bounds for rr_buffer.
> >
> > Then you can make a single allocation of (size) bytes and copy in both
> > the header and the body as one unit.  Validate and fill it, then write
> > it back as a single unit as well.
> >
> I still needed to allocate the 'perfstats' header at the beginning of
> h_scm_performance_stats().

I really don't think you need to.

> So instead of allocating 'size' bytes I am
> now allocating 'MAX_OUTPUT_BUFFER' buffer at the beginning thats also
> used to copy the rr-buffer header from guest, which is then populated
> with stats and then copied to guest memory in single shot.
>=20
> >> +    if (!stats) {
> >> +        return H_NO_MEM;
> >> +    }
> >> +
> >> +    /* when returning all stats generate a canned response first */
> >> +    if (num_stats =3D=3D 0) {
> >> +        for (index =3D 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++in=
dex) {
> >> +            memcpy(&stats[index - 1].statistic_id,
> >> +                   &nvdimm_perf_stats[index].stat_id, 8);
> >> +        }
> >> +        num_stats =3D ARRAY_SIZE(nvdimm_perf_stats) - 1;
> >> +    } else {
> >> +        /* copy the rr-buffer from the guest memory */
> >> +        result =3D address_space_read(&address_space_memory,
> >> +                                    addr + sizeof(struct papr_scm_per=
f_stats),
> >> +                                    MEMTXATTRS_UNSPECIFIED, stats,
> >> +                                    size - sizeof(struct papr_scm_per=
f_stats));
> >> +        if (result !=3D MEMTX_OK) {
> >> +            g_free(stats);
> >> +            return H_PRIVILEGE;
> >> +        }
> >> +    }
> >> +
> >> +    for (index =3D 0; index < num_stats; ++index) {
> >> +        rc =3D nvdimm_stat_getval(drc, stats[index].statistic_id, &st=
at_val);
> >> +
> >> +        /* On error add noop stat to rr buffer & save last inval stat=
-id */
> >> +        if (rc !=3D H_SUCCESS) {
> >> +            if (!invalid_stat) {
> >> +                invalid_stat =3D stats[index].statistic_id;
> >> +            }
> >> +            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].s=
tat_id, 8);
> >> +        }
> >> +        /* Caller expects stat values in BE encoding */
> >> +        stats[index].statistic_value =3D cpu_to_be64(stat_val);
> >> +    }
> >> +
> >> +    /* Update and copy the local rr-buffer header and stats back to g=
uest */
> >> +    perfstats.num_statistics =3D cpu_to_be32(num_stats);
> >> +    result =3D address_space_write(&address_space_memory, addr,
> >> +                                 MEMTXATTRS_UNSPECIFIED, &perfstats,
> >> +                                 sizeof(struct papr_scm_perf_stats));
> >> +    if (result =3D=3D MEMTX_OK) {
> >> +        result =3D address_space_write(&address_space_memory,
> >> +                                     addr + sizeof(struct papr_scm_pe=
rf_stats),
> >> +                                     MEMTXATTRS_UNSPECIFIED, stats,
> >> +                                     size - sizeof(struct papr_scm_pe=
rf_stats));
> >> +    }
> >> +    /* Cleanup the stats buffer */
> >> +    g_free(stats);
> >> +    if (result) {
> >> +        return H_PRIVILEGE;
> >> +    }
> >> +    /* Check if there was a failure in fetching any stat */
> >> +    args[0] =3D invalid_stat;
> >> +    return invalid_stat ? H_PARTIAL : H_SUCCESS;
> >> +}
> >> +
> >>  static void spapr_scm_register_types(void)
> >>  {
> >>      /* qemu/scm specific hcalls */
> >> @@ -511,6 +740,7 @@ static void spapr_scm_register_types(void)
> >>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
> >>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> >>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> >> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performan=
ce_stats);
> >>  }
> >> =20
> >>  type_init(spapr_scm_register_types)
> >> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> >> index d2b5a9bdf9..6f3353b4ea 100644
> >> --- a/include/hw/ppc/spapr.h
> >> +++ b/include/hw/ppc/spapr.h
> >> @@ -326,6 +326,7 @@ struct SpaprMachineState {
> >>  #define H_P8              -61
> >>  #define H_P9              -62
> >>  #define H_OVERLAP         -68
> >> +#define H_BAD_DATA        -70
> >>  #define H_UNSUPPORTED_FLAG -256
> >>  #define H_MULTI_THREADS_ACTIVE -9005
> >> =20
> >> @@ -539,8 +540,9 @@ struct SpaprMachineState {
> >>  #define H_SCM_UNBIND_MEM        0x3F0
> >>  #define H_SCM_UNBIND_ALL        0x3FC
> >>  #define H_SCM_HEALTH            0x400
> >> +#define H_SCM_PERFORMANCE_STATS 0x418
> >> =20
> >> -#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> >> +#define MAX_HCALL_OPCODE        H_SCM_PERFORMANCE_STATS
> >> =20
> >>  /* The hcalls above are standardized in PAPR and implemented by pHyp
> >>   * as well.
> >> @@ -787,6 +789,21 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_T=
CE_TABLE)
> >>  DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
> >>                           TYPE_SPAPR_IOMMU_MEMORY_REGION)
> >> =20
> >> +/* Defs and structs exchanged with guest when reporting drc perf stat=
s */
> >> +#define SCM_STATS_EYECATCHER "SCMSTATS"
> >> +
> >> +struct QEMU_PACKED papr_scm_perf_stat {
> >> +    uint64_t statistic_id;
> >> +    uint64_t statistic_value;
> >> +};
> >> +
> >> +struct QEMU_PACKED papr_scm_perf_stats {
> >> +    uint8_t eye_catcher[8];    /* Should be =E2=80=9CSCMSTATS=E2=80=
=9D */
> >> +    uint32_t stats_version;  /* Should be 0x01 */
> >> +    uint32_t num_statistics; /* Number of stats following */
> >> +    struct papr_scm_perf_stat scm_statistics[]; /* Performance matric=
s */
> >> +};
> >> +
> >>  struct SpaprTceTable {
> >>      DeviceState parent;
> >>      uint32_t liobn;
> >
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--7G5YsXRJQ1uxvaQr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCiDDYACgkQbDjKyiDZ
s5KE6g//YZfZP9DjgutMxgotsMr0oJrQiE9AgFPEORbTWr2aX238Nqqf4MQyOhd6
FnQuUN+G4rWyUhHSmFp4v6AfetK2GKy355XD/QbIl27rQm74agkKWef8I40PUdBH
NCMJK9uTdY7aW8QIjGWo/6wiVKJcliZjNOi+4W0ny/r5YVxhnAkyYteKqVAgUFld
GwFi+kr5lMBfEu7yFHf+IiH2VnB4MXoxE1GsSIcrW6j00mzrPdgGUZ483aKJgL24
huAdmj4UeWe6JTwX6h8FxfWdMPSUDBjET7WMzLHxNq4Hp0kYsJEx/muLQMkHZZQv
kYrUF0W1IcJY/PYzsFYR+8XL+2dOM+4RuS5pVqF6BgB+zgHJ1oYq1OhbF3OpOIpx
nI+Ai5u2yrRcmiQcPBSSCCa/RLr/1SCpB7NzXfYLQRR6HTMyJe1BRqASTmhxwaie
IqH7uSZVhLlxZ2z23DyNzP0drz8DkJF+cPzPPlEVvqim8y6v6uLARmrHxDWVHnwF
1n8BIPpgJfydRF1jJq7uEAJIWkuTLlCB6pM/trSagM+NPOwxrLEbplc+VowQSc1U
AebNmhgZqtIAiWdCsXCuN5E6oEoaTdtleHfQ4V+aqFVO61uuGVKMhOM8xcTKBJ6q
NBs9wnvUeCU8lQDJ76CLmQ8ZURTAdEbJ26hQX7NvphXWqegIO3U=
=oAB/
-----END PGP SIGNATURE-----

--7G5YsXRJQ1uxvaQr--
