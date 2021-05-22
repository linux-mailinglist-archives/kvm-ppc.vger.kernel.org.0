Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F268938D34A
	for <lists+kvm-ppc@lfdr.de>; Sat, 22 May 2021 05:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhEVDdZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 21 May 2021 23:33:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231228AbhEVDdY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 21 May 2021 23:33:24 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14M34S3x192738;
        Fri, 21 May 2021 23:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1VTgvyi0H7I+Q35hTrglfulU4qkr9PCg7g0gZC8X5ro=;
 b=B+vKKdJugfUMHoTzRVKYDBUdPmAA+1tXregbWG7f0PvduwzSvm4ryvgsG3c8XihtpOOn
 3FEmVQLTsfeh9fFyNCmO85sJ92ZNjk46rO0DtAyDzwRVDmgkKMVyyvBxKp1xLLNy1ppH
 Y5FYvkdWIfO0EKdGYVZX1hiNXCyJa1gw4vDjp1Pg6BJxW9hL7rbx0WSQc8y+JCYAL48W
 THiDfqxl6sMkvKkKVoRIakwdiUUKPyVCOZamMYNUkb65P0s0Ln0aaNXSLBTc5YtZtgQ9
 usWKG+1KBrtEA7rWNSj3vYNXZBndSVCNCjcPE3+y8/aFGJ3RDNZqpeNC6vc9bzZ/kOpK JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ppnnb5pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 23:31:39 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14M353ZO000944;
        Fri, 21 May 2021 23:31:38 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ppnnb5np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 23:31:38 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14M3TsG3014020;
        Sat, 22 May 2021 03:31:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 38ps7h806e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 22 May 2021 03:31:35 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14M3VXKV25231864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 03:31:33 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45801A4053;
        Sat, 22 May 2021 03:31:33 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74505A4040;
        Sat, 22 May 2021 03:31:28 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.70.137])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat, 22 May 2021 03:31:28 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 22 May 2021 09:01:26 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     xiaoguangrong.eric@gmail.com, mst@redhat.com,
        aneesh.kumar@linux.ibm.com, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, groug@kaod.org, shivaprasadbhat@gmail.com,
        qemu-ppc@nongnu.org, marcel.apfelbaum@gmail.com,
        bharata@linux.vnet.ibm.com, imammedo@redhat.com,
        ehabkost@redhat.com
Subject: Re: [RFC PATCH v3] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
In-Reply-To: <YKIL/Gqc50GO+UTk@yekko>
References: <20210515073759.10505-1-vaibhav@linux.ibm.com>
 <YKIL/Gqc50GO+UTk@yekko>
Date:   Sat, 22 May 2021 09:01:26 +0530
Message-ID: <87sg2fjvg1.fsf@vajain21.in.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vW6y6e0hhOsi_XxBSk2LFIPiHCe95-bL
X-Proofpoint-ORIG-GUID: cz5-Gm0T_2Wdb-jECQxNmbQafYdyvbjQ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-22_01:2021-05-20,2021-05-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220018
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Thanks for looking into this patch David and Groug,

David Gibson <david@gibson.dropbear.id.au> writes:
> On Sat, May 15, 2021 at 01:07:59PM +0530, Vaibhav Jain wrote:
>> Add support for H_SCM_PERFORMANCE_STATS described at [1] for
>> spapr nvdimms. This enables guest to fetch performance stats[2] like
>> expected life of an nvdimm ('MemLife ') etc and display them to the
>> user. Linux kernel support for fetching these performance stats and
>> exposing them to the user-space was done via [3].
>>=20
>> The hcall semantics mandate that each nvdimm performance stats is
>> uniquely identied by a 8-byte ascii string encoded as an unsigned
>> integer (e.g 'MemLife ' =3D=3D 0x4D656D4C69666520) and its value be a
>> 8-byte unsigned integer. These performance-stats are exchanged with
>> the guest in via a guest allocated buffer called
>> 'requestAndResultBuffer' or rr-buffer for short. This buffer contains
>> a header descibed by 'struct papr_scm_perf_stats' followed by an array
>> of performance-stats described by 'struct papr_scm_perf_stat'. The
>> hypervisor is expected to validate the rr-buffer header and then based
>> on the request copy the needed performance-stats to the array of
>> 'struct papr_scm_perf_stat' following the header.
>>=20
>> The patch proposes a new function h_scm_performance_stats() that
>> services the H_SCM_PERFORMANCE_STATS hcall. After verifying the
>> validity of the rr-buffer header via scm_perf_check_rr_buffer() it
>> proceeds to fill the rr-buffer with requested performance-stats. The
>> value of individual stats is retrived from individual accessor
>> function for the stat which are indexed in the array
>> 'nvdimm_perf_stats'.
>>=20
>> References:
>> [1] "Hypercall Op-codes (hcalls)"
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/powerpc/papr_hcalls.rst#n269
>> [2] Sysfs attribute documentation for papr_scm
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/ABI/testing/sysfs-bus-papr-pmem#n36
>> [3] "powerpc/papr_scm: Fetch nvdimm performance stats from PHYP"
>> https://lore.kernel.org/r/20200731064153.182203-2-vaibhav@linux.ibm.com
>>=20
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>> Changelog
>>=20
>> Since RFC-v2:
>> * s/SCM_STATS_MAX_OUTPUT_BUFFER/SCM_STATS_MIN_OUTPUT_BUFFER/ thats the
>>   minimum size buffer needed to return all supported performance
>>   stats. Value for this is derived from size of array 'nvdimm_perf_stats'
>> * Added SCM_STATS_MAX_OUTPUT_BUFFER to indicate maximum supported
>>   rr-buffer size from a guest. Value for this is derived from hard
>>   limit of SCM_STATS_MAX_STATS.
>> * Updated scm_perf_check_rr_buffer() to add a check for max size of
>>   rr-buffer. [David]
>> * Updated scm_perf_check_rr_buffer() to removed a reduntant check for
>>   min size of rr-buffer [David]
>> * Updated h_scm_performance_stats() to have a single allocation for
>>   rr-buffer and copy it back to guest memory in a single shot. [David]
>>=20
>> Since RFC-v1:
>> * Removed empty lines from code [ David ]
>> * Updated struct papr_scm_perf_stat to use uint64_t for
>>   statistic_id.
>> * Added a hard limit on max number of stats requested to 255 [ David ]
>> * Updated scm_perf_check_rr_buffer() to check for rr-buffer header
>>   size [ David ]
>> * Removed a redundant check from nvdimm_stat_getval() [ David ]
>> * Removed a redundant call to address_space_access_valid() in
>>   scm_perf_check_rr_buffer() [ David ]
>> * Instead of allocating a minimum size local buffer, allocate a max
>>   possible size local rr-buffer. [ David ]
>> * Updated nvdimm_stat_getval() to set 'val' to '0' on error. [ David ]
>> * Updated h_scm_performance_stats() to use a canned-response method
>>   for simplifying num_stats=3D=3D0 case [ David ].
>> ---
>>  hw/ppc/spapr_nvdimm.c  | 222 +++++++++++++++++++++++++++++++++++++++++
>>  include/hw/ppc/spapr.h |  19 +++-
>>  2 files changed, 240 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
>> index 252204e25f..287326b9c0 100644
>> --- a/hw/ppc/spapr_nvdimm.c
>> +++ b/hw/ppc/spapr_nvdimm.c
>> @@ -35,6 +35,19 @@
>>  /* SCM device is unable to persist memory contents */
>>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
>>=20=20
>> +/* Minimum output buffer size needed to return all nvdimm_perf_stats */
>> +#define SCM_STATS_MIN_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats=
) + \
>> +                                      sizeof(struct papr_scm_perf_stat)=
 * \
>> +                                      ARRAY_SIZE(nvdimm_perf_stats))
>
> MIN_OUTPUT_BUFFER is a better name, but still not great.  I think we
> can get rid of this define completely in a neat way, though.  See below.
>
>
Not sure how we can get rid of it since we still need to advertise to
the guest how much rr-buffer size we expect to return all
perf-stats. Sorry but I didnt make out of  any suggestions below that
could get rid of this define.


>> +/* Maximum number of stats that we can return back in a single stat req=
uest */
>> +#define SCM_STATS_MAX_STATS 255
>
> Although it's technically allowed, I'm still not convinced there's
> actually any reason to allow the user to request the same stat over
> and over.
>
Matching the PowerVM behaviour here which doesnt enforce any limitations
on the how many times a single perf-stat can appear in rr-buffer.

>> +/* Maximum possible output buffer to fulfill a perf-stats request */
>> +#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats=
) + \
>> +                                      sizeof(struct papr_scm_perf_stat)=
 * \
>> +                                      SCM_STATS_MAX_STATS)
>> +
>>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *n=
vdimm,
>>                             uint64_t size, Error **errp)
>>  {
>> @@ -502,6 +515,214 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, =
SpaprMachineState *spapr,
>>      return H_SUCCESS;
>>  }
>>=20=20
>> +static int perf_stat_noop(SpaprDrc *drc, uint64_t unused, uint64_t *val)
>> +{
>> +    *val =3D 0;
>> +    return H_SUCCESS;
>> +}
>> +
>> +static int perf_stat_memlife(SpaprDrc *drc, uint64_t unused, uint64_t *=
val)
>> +{
>> +    /* Assume full life available of an NVDIMM right now */
>> +    *val =3D 100;
>> +    return H_SUCCESS;
>> +}
>> +
>> +/*
>> + * Holds all supported performance stats accessors. Each performance-st=
atistic
>> + * is uniquely identified by a 8-byte ascii string for example: 'MemLif=
e '
>> + * which indicate in percentage how much usage life of an nvdimm is rem=
aining.
>> + * 'NoopStat' which is primarily used to test support for retriving per=
formance
>> + * stats and also to replace unknown stats present in the rr-buffer.
>> + *
>> + */
>> +static const struct {
>> +    char stat_id[8];
>
> So using a char[] here, but a uint64_t in the request structure makes
> it pretty hard to follow if you're doing the right thing
> w.r.t. endianness, especially since you effectively memcmp() directly
> between u64s and char[]s.  You really want to use a consistent type
> for the ids.
>
Though the PAPR-SCM defines stat-ids as u64 they are essentially 8-byte
ascii strings encoded in a u64. The guest kernel and this proposed qemu
patch doesnt do any math operations on them which might be effected by
their endianess.

The switch from u64->char[8] is done only for a more convinent
ASCII representation stats-ids in nvdimm_pref_stats[].

>> +    int  (*stat_getval)(SpaprDrc *drc, uint64_t id, uint64_t *val);
>> +} nvdimm_perf_stats[] =3D {
>> +    { "NoopStat", perf_stat_noop},
>> +    { "MemLife ", perf_stat_memlife},
>> +};
>> +
>> +/*
>> + * Given a nvdimm drc and stat-name return its value. In case given sta=
t-name
>> + * isnt supported then return H_PARTIAL.
>> + */
>> +static int nvdimm_stat_getval(SpaprDrc *drc, uint64_t id, uint64_t *val)
>> +{
>> +    int index;
>> +    char stat_id[8];
>> +
>> +    /* since comparision is done */
>> +    memcpy(&stat_id[0], &id, 8);
>
> I don't see why you're making this temporary copy here.
>
Agree, removed this in next iteration of this patch.
>> +    *val =3D 0;
>> +
>> +    /* Lookup the stats-id in the nvdimm_perf_stats table */
>> +    for (index =3D 0; index < ARRAY_SIZE(nvdimm_perf_stats); ++index) {
>> +        if (memcmp(nvdimm_perf_stats[index].stat_id, &stat_id[0], 8) =
=3D=3D 0) {
>> +            return nvdimm_perf_stats[index].stat_getval(drc, id, val);
>> +        }
>> +    }
>> +    return H_PARTIAL;
>> +}
>> +
>> +/*
>> + * Given a request & result buffer header verify its contents. Also
>> + * buffer-size and number of stats requested are within our expected
>> + * sane bounds.
>> + */
>> +static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *header,
>> +                                    hwaddr addr, size_t size,
>> +                                    uint32_t *num_stats)
>> +{
>> +    size_t expected_buffsize;
>> +
>> +    /* Verify the header eyecather and version */
>> +    if (memcmp(&header->eye_catcher, SCM_STATS_EYECATCHER,
>> +               sizeof(header->eye_catcher))) {
>> +        return H_BAD_DATA;
>> +    }
>> +    if (be32_to_cpu(header->stats_version) !=3D 0x1) {
>> +        return H_NOT_AVAILABLE;
>> +    }
>> +
>> +    /* verify that rr buffer has enough space */
>> +    *num_stats =3D be32_to_cpu(header->num_statistics);
>> +    if (*num_stats =3D=3D 0) { /* Return all stats */
>> +        expected_buffsize =3D SCM_STATS_MIN_OUTPUT_BUFFER;
>> +    } else if (*num_stats > SCM_STATS_MAX_STATS) {
>> +        /* Too many stats requested */
>> +        return H_P3;
>
> I'd recommend testing and exiting on this error case before handling
> the all stats case.  Disposing of error cases early is more idiomatic.
>
> You can then combine the all stats and n-stats cases a bit more nicely
> with something like:
>     actual_numstats =3D (*num_stats) ? (*num_stats) : ARRAY_SIZE(...);
>
> Then use the same logic to compute the expected bufsize (min_bufsize
> might be a better name) in both cases.
>=20=09
>
Agree, have done the change you suggested in next iteration.

>> +    } else { /* Return a subset of stats */
>> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
>> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
>> +    }
>> +
>> +    if (size < expected_buffsize || size > SCM_STATS_MAX_OUTPUT_BUFFER)=
 {
>> +        return H_P3;
>
> I think you can avoid the MAX_OUTPUT_BUFFER check here...
>
Yes, moved the check to h_scm_performance_stats() in next iteration.

>> +    }
>> +
>> +    return H_SUCCESS;
>> +}
>> +
>> +/*
>> + * For a given DRC index (R3) return one ore more performance stats of =
an nvdimm
>> + * device in guest allocated Request-and-result buffer (rr-buffer) (R4)=
 of
>> + * given 'size' (R5). The rr-buffer consists of a header described by
>> + * 'struct papr_scm_perf_stats' that embeds the 'stats_version' and
>> + * 'num_statistics' fields. This is followed by an array of
>> + * 'struct papr_scm_perf_stat'. Based on the request type the writes the
>> + * performance into the array of 'struct papr_scm_perf_stat' embedded i=
nside
>> + * the rr-buffer provided by the guest.
>> + * Special cases handled are:
>> + * 'size' =3D=3D 0  : Return the maximum possible size of rr-buffer
>> + * 'size' !=3D 0 && 'num_statistics =3D=3D 0' : Return all possible per=
formance stats
>> + *
>> + * In case there was an error fetching a specific stats (e.g stat-id un=
known or
>> + * any other error) then return the stat-id in R4 and also replace its =
stat
>> + * entry in rr-buffer with 'NoopStat'
>> + */
>> +static target_ulong h_scm_performance_stats(PowerPCCPU *cpu,
>> +                                            SpaprMachineState *spapr,
>> +                                            target_ulong opcode,
>> +                                            target_ulong *args)
>> +{
>> +    SpaprDrc *drc =3D spapr_drc_by_index(args[0]);
>> +    const hwaddr addr =3D args[1];
>> +    size_t size =3D args[2];
>> +    struct papr_scm_perf_stats *perfstats;
>> +    struct papr_scm_perf_stat *stats;
>> +    uint64_t invalid_stat =3D 0, stat_val;
>> +    MemTxResult result;
>> +    uint32_t num_stats;
>> +    unsigned long rc;
>> +    int index;
>> +
>> +    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged=
 in */
>> +    if (!drc || !drc->dev ||
>> +        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>> +        return H_PARAMETER;
>> +    }
>> +
>> +    /* Guest requested max buffer size for output buffer */
>> +    if (size =3D=3D 0) {
>> +        args[0] =3D SCM_STATS_MAX_OUTPUT_BUFFER;
>> +        return H_SUCCESS;
>> +    }
>> +
>> +    /* verify size is enough to hold rr-buffer header */
>> +    if (size < sizeof(struct papr_scm_perf_stats)) {
>
>
> .. if you put it here instead, then you will have dealt with all
> obviously bad buffer sizes early.
>
Agree
>> +        return H_BAD_DATA;
>> +    }
>> +
>> +    /* allocate enough buffer space locally for holding max stats */
>> +    perfstats =3D g_try_malloc0(SCM_STATS_MAX_OUTPUT_BUFFER);
>
> Then you can safely base this malloc on the given size, rather than
> always over-allocating.
>
Right, have updated this in v4
>> +    if (!perfstats) {
>> +        return H_NO_MEM;
>> +    }
>> +
>> +    /* Read and verify rr-buffer header */
>> +    result =3D address_space_read(&address_space_memory, addr,
>> +                                MEMTXATTRS_UNSPECIFIED, perfstats,
>> +                                sizeof(struct papr_scm_perf_stats));
>
> And you can also read the entire thing with a single memory read here.
>
Yes agree. Addressed this in v4.
>> +    rc =3D (result =3D=3D MEMTX_OK) ?
>> +        scm_perf_check_rr_buffer(perfstats, addr, size, &num_stats) :
>> +        H_PRIVILEGE;
>
> This is a bit cryptic.  Just deal with the memtx error first, then run
> the buffer validation.  Actually, you can unify the exit paths for
> these and the success case by using a goto label near the end which
> has the g_free() and return rc.
>
Sure, addressed this in v4 by using g_autofree
>> +    if (rc !=3D H_SUCCESS) {
>> +        g_free(perfstats);
>> +        return rc;
>> +    }
>> +
>> +    stats =3D &perfstats->scm_statistics[0];
>> +    /* when returning all stats generate a canned response first */
>> +    if (num_stats =3D=3D 0) {
>> +        for (index =3D 1; index < ARRAY_SIZE(nvdimm_perf_stats); ++inde=
x) {
>> +            memcpy(&stats[index - 1].statistic_id,
>> +                   &nvdimm_perf_stats[index].stat_id, 8);
>> +        }
>> +        num_stats =3D ARRAY_SIZE(nvdimm_perf_stats) - 1;
>> +    } else {
>> +        /* copy the rr-buffer from the guest memory */
>> +        result =3D address_space_read(&address_space_memory,
>> +                                    addr + sizeof(struct papr_scm_perf_=
stats),
>> +                                    MEMTXATTRS_UNSPECIFIED, stats,
>> +                                    size - sizeof(struct papr_scm_perf_=
stats));
>> +        if (result !=3D MEMTX_OK) {
>> +            g_free(perfstats);
>> +            return H_PRIVILEGE;
>> +        }
>> +    }
>> +
>> +    for (index =3D 0; index < num_stats; ++index) {
>> +        rc =3D nvdimm_stat_getval(drc, stats[index].statistic_id, &stat=
_val);
>> +
>> +        /* On error add noop stat to rr buffer & save last inval stat-i=
d */
>> +        if (rc !=3D H_SUCCESS) {
>> +            if (!invalid_stat) {
>> +                invalid_stat =3D stats[index].statistic_id;
>> +            }
>> +            memcpy(&stats[index].statistic_id, nvdimm_perf_stats[0].sta=
t_id, 8);
>> +        }
>> +        /* Caller expects stat values in BE encoding */
>> +        stats[index].statistic_value =3D cpu_to_be64(stat_val);
>> +    }
>> +
>> +    /* Update and copy the local rr-buffer back to guest */
>> +    perfstats->num_statistics =3D cpu_to_be32(num_stats);
>> +    g_assert(size <=3D SCM_STATS_MAX_OUTPUT_BUFFER);
>> +    result =3D address_space_write(&address_space_memory, addr,
>> +                                 MEMTXATTRS_UNSPECIFIED, perfstats, siz=
e);
>> +
>> +    /* Cleanup the stats buffer */
>> +    g_free(perfstats);
>> +    if (result) {
>> +        return H_PRIVILEGE;
>> +    }
>> +    /* Check if there was a failure in fetching any stat */
>> +    args[0] =3D invalid_stat;
>> +    return invalid_stat ? H_PARTIAL : H_SUCCESS;
>> +}
>> +
>>  static void spapr_scm_register_types(void)
>>  {
>>      /* qemu/scm specific hcalls */
>> @@ -511,6 +732,7 @@ static void spapr_scm_register_types(void)
>>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>> +    spapr_register_hypercall(H_SCM_PERFORMANCE_STATS, h_scm_performance=
_stats);
>>  }
>>=20=20
>>  type_init(spapr_scm_register_types)
>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> index d2b5a9bdf9..6f3353b4ea 100644
>> --- a/include/hw/ppc/spapr.h
>> +++ b/include/hw/ppc/spapr.h
>> @@ -326,6 +326,7 @@ struct SpaprMachineState {
>>  #define H_P8              -61
>>  #define H_P9              -62
>>  #define H_OVERLAP         -68
>> +#define H_BAD_DATA        -70
>>  #define H_UNSUPPORTED_FLAG -256
>>  #define H_MULTI_THREADS_ACTIVE -9005
>>=20=20
>> @@ -539,8 +540,9 @@ struct SpaprMachineState {
>>  #define H_SCM_UNBIND_MEM        0x3F0
>>  #define H_SCM_UNBIND_ALL        0x3FC
>>  #define H_SCM_HEALTH            0x400
>> +#define H_SCM_PERFORMANCE_STATS 0x418
>>=20=20
>> -#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>> +#define MAX_HCALL_OPCODE        H_SCM_PERFORMANCE_STATS
>>=20=20
>>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>>   * as well.
>> @@ -787,6 +789,21 @@ OBJECT_DECLARE_SIMPLE_TYPE(SpaprTceTable, SPAPR_TCE=
_TABLE)
>>  DECLARE_INSTANCE_CHECKER(IOMMUMemoryRegion, SPAPR_IOMMU_MEMORY_REGION,
>>                           TYPE_SPAPR_IOMMU_MEMORY_REGION)
>>=20=20
>> +/* Defs and structs exchanged with guest when reporting drc perf stats =
*/
>> +#define SCM_STATS_EYECATCHER "SCMSTATS"
>> +
>> +struct QEMU_PACKED papr_scm_perf_stat {
>> +    uint64_t statistic_id;
>> +    uint64_t statistic_value;
>> +};
>> +
>> +struct QEMU_PACKED papr_scm_perf_stats {
>> +    uint8_t eye_catcher[8];    /* Should be =E2=80=9CSCMSTATS=E2=80=9D =
*/
>> +    uint32_t stats_version;  /* Should be 0x01 */
>> +    uint32_t num_statistics; /* Number of stats following */
>> +    struct papr_scm_perf_stat scm_statistics[]; /* Performance matrics =
*/
>> +};
>> +
>>  struct SpaprTceTable {
>>      DeviceState parent;
>>      uint32_t liobn;
>
> --=20
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

--=20
Cheers
~ Vaibhav
