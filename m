Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDC03664E7
	for <lists+kvm-ppc@lfdr.de>; Wed, 21 Apr 2021 07:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhDUFgs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Apr 2021 01:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhDUFgr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Apr 2021 01:36:47 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01618C06174A
        for <kvm-ppc@vger.kernel.org>; Tue, 20 Apr 2021 22:36:14 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FQ8Rb6gjSz9t2G; Wed, 21 Apr 2021 15:36:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1618983371;
        bh=MdaIS+MwAmYRhCQxgGs5UXiaSYBjPu+mRLs1l522IBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Odifw8USWF4RkgjojQ8IRfLuwqG+yb2GWNOxKegYOXwb+Qo8Cda+Cf8cP7ZLnbpZX
         TEqNbspJUOELs6XPn2yu0Iqh7jb+9IGdQKLFGPKboqrDCsuWPh+f85ieeKCCcjacIq
         Rk8VnKHooHjY5xi3QNNFhHBzPDCjVUsRE1aPu/LI=
Date:   Wed, 21 Apr 2021 15:19:53 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org
Subject: Re: [RFC-PATCH] ppc/spapr: Add support for H_SCM_PERFORMANCE_STATS
 hcall
Message-ID: <YH+1+VEfeDRGqQ1k@yekko.fritz.box>
References: <20210415075343.482855-1-vaibhav@linux.ibm.com>
 <YH0LBR0pqUYFa49r@yekko.fritz.box>
 <877dkxl2lp.fsf@vajain21.in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oNcl9dxRl9VZJXiJ"
Content-Disposition: inline
In-Reply-To: <877dkxl2lp.fsf@vajain21.in.ibm.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


--oNcl9dxRl9VZJXiJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2021 at 03:06:18PM +0530, Vaibhav Jain wrote:
> Thanks for looking into this patch David,
>=20
> David Gibson <david@gibson.dropbear.id.au> writes:
>=20
> > On Thu, Apr 15, 2021 at 01:23:43PM +0530, Vaibhav Jain wrote:
> >> Add support for H_SCM_PERFORMANCE_STATS described at [1] for
> >> spapr nvdimms. This enables guest to fetch performance stats[2] like
> >> expected life of an nvdimm ('MemLife ') etc and display them to the
> >> user. Linux kernel support for fetching these performance stats and
> >> exposing them to the user-space was done via [3].
> >>=20
> >> The hcall semantics mandate that each nvdimm performance stats is
> >> uniquely identied by a 8-byte ascii string (e.g 'MemLife ') and its
> >> value be a 8-byte integer. These performance-stats are exchanged with
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
> >>  hw/ppc/spapr_nvdimm.c  | 243 +++++++++++++++++++++++++++++++++++++++++
> >>  include/hw/ppc/spapr.h |  19 +++-
> >>  2 files changed, 261 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> >> index 252204e25f..4830eae4a4 100644
> >> --- a/hw/ppc/spapr_nvdimm.c
> >> +++ b/hw/ppc/spapr_nvdimm.c
> >> @@ -35,6 +35,11 @@
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
> >>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice =
*nvdimm,
> >>                             uint64_t size, Error **errp)
> >>  {
> >> @@ -502,6 +507,243 @@ static target_ulong h_scm_health(PowerPCCPU *cpu=
, SpaprMachineState *spapr,
> >>      return H_SUCCESS;
> >>  }
> >> =20
> >> +static int perf_stat_noop(SpaprDrc *drc, uint8_t unused[8], uint64_t =
*val)
> >> +{
> >> +    *val =3D 0;
> >> +    return H_SUCCESS;
> >> +}
> >> +
> >> +static int perf_stat_memlife(SpaprDrc *drc, uint8_t unused[8], uint64=
_t *val)
> >> +{
> >> +    /* Assume full life available of an NVDIMM right now */
> >> +    *val =3D 100;
> >
> > AFAICT the reporting mechanism makes basically all the stats
> > optional.  Doesn't it make more sense to omit stats, rather than use
> > dummy values in this case?  Or is this just an example for the RFC?
> >
> Yes, this was just an RFC example to illustrate adding support for a new
> stat.

Ok.

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
> >> +    int  (*stat_getval)(SpaprDrc *drc, uint8_t id[8],  uint64_t *val);
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
> >> +static int nvdimm_stat_getval(SpaprDrc *drc, uint8_t id[8], uint64_t =
*val)
> >> +{
> >> +    int index;
> >> +
> >> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
> >> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index)=
 {
> >> +
> >
> > No blank line here.
> >
> Sure, will fix the blank line from this and other places you reported.
> >> +        if (memcmp(nvdimm_perf_stats[index].stat_id, &id[0], 8) =3D=
=3D 0 &&
> >> +            nvdimm_perf_stats[index].stat_getval) {
> >
> > I don't see any reason you'd want an entry in the table with a NULL
> > function, so I don't think you need both tests.
> >
> Right. Was being extra cautious here.
> >> +
> >
> > No blank line here either.
> >
> >> +            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
> >> +        }
> >> +    }
> >> +
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
> >
> > You need to check that size is at least big enough to contain the
> > header before accessing the header fields.
> >
> Yes, the expected_buffsize variable already calculated and checks for
> the  space needed for for header + space for stats.=20

I don't follow what you're saying.  You read both the eyecatcher and
version from the structure before you ever set expected_buffsize.

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
> >> +    } else { /* Return a subset of stats */
> >> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
> >> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
> >> +
> >> +    }
> >
> > We probably want a hard cap on num_stats as well, so the guest can't
> > force up to make arbitrarily large allocations and memory read/writes.
> >
> Agree. Though the papr spec doesnt provide any upper bound on number of
> stats that can be requested, I think a hard cap can be 255 which is the
> max number of stats that a 4K page can hold.

So, that's one possibility.  But, although it's technically permitted
for a guest to provide a big buffer asking for the same stat over and
over, is there actually any reason to support such a pointless way of
using the interface?  If not, could we just set the hard cap to the
number of different stats we support.

>=20
> >> +
> >> +    if (*size < expected_buffsize) {
> >> +        return H_P3;
> >> +    }
> >> +    *size =3D expected_buffsize;
> >> +
> >> +    /* verify that rr buffer is writable */
> >> +    if (!address_space_access_valid(&address_space_memory, addr, *siz=
e,
> >> +                                    true, MEMTXATTRS_UNSPECIFIED)) {
> >
> > Is there any point to this, given that you'll still have to check for
> > errors when you go to write back the buffer later?
> >
> Yes, agree. Will get rid of this check in next iteration.
>=20
> >> +        return H_PRIVILEGE;
> >> +    }
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
> >> +    const uint32_t drc_index =3D args[0];
> >> +    const hwaddr addr =3D args[1];
> >> +    size_t size =3D args[2];
> >> +    int index;
> >> +    MemTxResult result;
> >> +    uint32_t num_stats;
> >> +    uint8_t stat_id[8];
> >> +    unsigned long rc;
> >> +    uint64_t stat_val, invalid_stat =3D 0;
> >> +    struct papr_scm_perf_stats perfstats;
> >> +    struct papr_scm_perf_stat *stats, *stat;
> >> +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
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
> >> +    /* Read and verify rr-buffer header */
> >> +    result =3D address_space_read(&address_space_memory, addr,
> >> +                                MEMTXATTRS_UNSPECIFIED, &perfstats,
> >> +                                sizeof(perfstats));
> >
> > Ah.. actually you need to check that the provided size is at least big
> > enough to cover the header before even reading it here.
> >
> But that verification is already being done in
> scm_perf_check_rr_buffer() as part of header check. In case the provided
> buffer is less than sizeof(perfstats) than address_space_read() would
> fail or susequently  scm_perf_check_rr_buffer() would return an
> error.

So, yes, you'd probably get away with it.  I really dislike relying on
"wrong but we'll catch it later" logic.  I really prefer to perform
the bounds check *before* performing the guest memory access.
=20
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
> >> +    /* allocate enough buffer space locally for holding all stats */
> >> +    stats =3D g_malloc0(size  - sizeof(struct papr_scm_perf_stats));
> >
> > This seems unnecessarily complicated.  Why not just allocate a max
> > sized temporary buffer every time - it's in the tens of bytes, not
> > something that is really a concern from a memory usage point of view.
> > You could even put it on the stack.
> >
>=20
> 'SCM_STATS_MAX_OUTPUT_BUFFER' is the minimum size of output buffer
> needed to hold all the supported nvdimm stats. A guest can always send a
> buffer sized larger than 'SCM_STATS_MAX_OUTPUT_BUFFER' where single stat
> is requested more than once. In such a case 'bufferSizeInBytes'
> (args[2]) received from guest which is a uint64 can be large.

Ah.. yes, I forgot about that option.  Mind you if you set the max
number of requests to the max number of stats as suggested above, you
could simplify this path as well.

> review comment to self: add check for memory allocation failure

You don't need that; g_malloc() will abort() on allocation failure.

>=20
> >> +    if (num_stats =3D=3D 0) { /* Return all supported stats */
> >> +
> >
> > No blank line here.
> >
> >> +        for (index =3D 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++in=
dex) {
> >
> > Why is the starting index 1, not 0?
> >
> Dont want to return noopstat to the guest. 'nvdimm_perf_stat' will
> always start with a noopstat descriptor hence want to skip that.
>=20
> >> +            stat =3D &stats[index - 1];
> >> +            memcpy(stat_id, &nvdimm_perf_stats[index].stat_id, 8);
> >
> > I don't see any point to the 'stat_id' variable here.
> >
> Right, thanks for pointin it out. This lingered from an earlier version
> of the patch and I will get it removed.
>=20
> >> +            rc =3D nvdimm_stat_getval(drc, stat_id, &stat_val);
> >
> > So, you're using the nvdimm_stat_getval() here in the num_stats=3D=3D0
> > path, which means you're not taking advatage of the fact that you
> > don't actually need to search through the table for your getter
> > function in this case.  I think that's reasonable for its simplicity,
> > but in that case you can make it even simpler:
> >
> > Rather than having separate paths for the num_stats =3D=3D 0 and the ot=
her
> > case, just have the num_stats =3D=3D 0 case fill in the buffer with a
> > canned request which asks for each stat in turn.  Then continue on to
> > the selected stats path.
> >
> Thanks, will implement something similar in next iteration.
>=20
>=20
> >> +
> >> +            /* On error add noop stat to rr buffer & save last inval =
stat-id */
> >> +            if (rc !=3D H_SUCCESS) {
> >> +                if (!invalid_stat) {
> >> +                    memcpy(&invalid_stat, &stat_id[0], 8);
> >> +                }
> >> +                memcpy(&stat_id, nvdimm_perf_stats[0].stat_id, 8);
> >> +                stat_val =3D 0;
> >> +            }
> >> +
> >> +            memcpy(&stat->statistic_id, stat_id, 8);
> >> +            stat->statistic_value =3D cpu_to_be64(stat_val);
> >> +        }
> >> +        /* Number of stats returned =3D=3D perf_stats array size - no=
op-stat */
> >> +        num_stats =3D ARRAY_SIZE(nvdimm_perf_stats) - 1;
> >> +
> >> +    } else { /* Return a subset of requested stats */
> >> +
> >
> > No blank line.
> >
> >> +        /* copy the rr-buffer from the guest memory */
> >> +        result =3D address_space_read(&address_space_memory,
> >> +                                    addr + sizeof(struct papr_scm_per=
f_stats),
> >> +                                    MEMTXATTRS_UNSPECIFIED, stats,
> >> +                                    size - sizeof(struct papr_scm_per=
f_stats));
> >> +
> >> +        if (result !=3D MEMTX_OK) {
> >> +            g_free(stats);
> >> +            return H_PRIVILEGE;
> >> +        }
> >> +
> >> +        for (index =3D 0; index < num_stats; ++index) {
> >> +            stat =3D &stats[index];
> >> +            memcpy(&stat_id, &stats->statistic_id, 8);
> >
> > What's the point of the 'stat_id' temporary?
> >
> Agree as mentioned earlier. Will remove this in next iteration of this
> patch.
>=20
> >> +            rc =3D nvdimm_stat_getval(drc, stat_id, &stat_val);
> >> +
> >> +            /* On error add noop stat to rr buffer & save last inval =
stat-id */
> >> +            if (rc !=3D H_SUCCESS) {
> >> +                if (!invalid_stat) {
> >> +                    memcpy(&invalid_stat, &stat_id[0], 8);
> >> +                }
> >> +                memcpy(&stat_id, nvdimm_perf_stats[0].stat_id, 8);
> >
> > Why not write back directly to (the qemu copy of) the rr buffer?
> >
> Sure can do that. Was trying to update qemu rr-buffer at a single
> point rather than scattering updates to it at multiple places.
>=20
>=20
> >> +                stat_val =3D 0;
> >
> >
> > You can also avoid the explicit stat_val =3D 0 if you make
> > nvdimm_stat_getval() always zero stat_val on error.
> >
> Agree. Thanks for the suggestion. Will add this in next iteration.
>=20
> >> +            }
> >> +
> >> +            memcpy(&stat->statistic_id, stat_id, 8);
> >
> > AFAICT this copy only does something in the failure case.
> >
> Right
>=20
> >> +            stat->statistic_value =3D cpu_to_be64(stat_val);
> >> +        }
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
> >> +
> >> +    /* Cleanup the stats buffer */
> >> +    g_free(stats);
> >> +
> >> +    if (result) {
> >> +        return H_PRIVILEGE;
> >> +    }
> >> +
> >> +    /* Check if there was a failure in fetching any stat */
> >> +    args[0] =3D invalid_stat;
> >> +    return invalid_stat ? H_PARTIAL : H_SUCCESS;
> >> +}
> >> +
> >>  static void spapr_scm_register_types(void)
> >>  {
> >>      /* qemu/scm specific hcalls */
> >> @@ -511,6 +753,7 @@ static void spapr_scm_register_types(void)
> >>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
> >>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> >>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> >> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performan=
ce_stats);
> >>  }
> >> =20
> >>  type_init(spapr_scm_register_types)
> >> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> >> index d2b5a9bdf9..4b71b58e00 100644
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
> >> +    uint8_t statistic_id[8];
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

--oNcl9dxRl9VZJXiJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmB/tfkACgkQbDjKyiDZ
s5KtKw//RLZ2Ovfxnbbj6f04CI6l7tEK3bnleM/NxLO8d94akfHGpC8HMthXm9q/
1rXbQ/jtHbjs8L9esUqiBRZHilHLpPVET3W4uZVCpSZizDjJ/fMijFnrXhvJfh5Y
uaA6UCLNC5dUAAkQ/7aQP3nbVYC4kTIVWcndX8xyZUMxjBoHEL/inaG4/a9KnT2o
a3zVFH/WJPfaKqG1yU7b4Quz6nOy3EDfWF2mrVkK5KWWc1hK01IR0tI8mcmbcbuI
tUlZDoLKQ/eXY/bZcZxfeK+nb9Mk0a7MmXEBddL4wI9vu79lLXQqWhMX67dntvG1
3K6OaHKMD7LmhMvQDpeibGf1BbKwFMnjEl6tXp9C6Fhj9pCkrZINuE+P/rmdo8/M
lkz8EpXnFGDpWUrDK/ibX4lC0NAkozPCDD03zQNiR+o6hRbBjwiXKhal7KrF8BeA
wrZIQOVvDdrf/Bc8aTu2d84ldDfk5sQfcO5sMtZu0vMI0v49CTpvaWh098SSbCml
CcVIzeV4bIAqwEzqVpWyBCDKcy7JtcRVbdGlFdApyVxladeJnRIgpffaHY2ekVJM
0DAlcA56Ui2O+pjYDSodCpGCqbnBBTNntbDkb6Iz+s1mYKMTYoVZfst0L2UxVebY
kbY0rPvGyWzQt0HGYa78uq1NDbNkfjiFnZwiAheXtb9jYiXbAEc=
=LsWS
-----END PGP SIGNATURE-----

--oNcl9dxRl9VZJXiJ--
