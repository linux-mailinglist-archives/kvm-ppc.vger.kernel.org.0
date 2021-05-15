Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C8738159B
	for <lists+kvm-ppc@lfdr.de>; Sat, 15 May 2021 05:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhEODxd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 14 May 2021 23:53:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32344 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229898AbhEODxc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 14 May 2021 23:53:32 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F3kBLZ079595;
        Fri, 14 May 2021 23:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wozU0QJqxplc1pgCkavbGorFQPLfFNYxyerZZ7chpKk=;
 b=H7vM6OAn+SECfuBLxFqNK7K2/xPlF+T06bBZ1/K5rVP3qiS+0gC2T86QjZSAW0lExm1p
 7y1ZvxdRW2HVORifdb/BW5+HGw43p+P9O27LN/DbzH0TDpWSGQQE6wnCHbWpMORRxSDz
 KocgMIxETA1bJygp3Danm/xqu7lJdgNxH2GRIvxliXgEq5dZW1OPwu/Gt3VTTYAA7AB7
 QNCbwfX3baJRJlYNwIfmPMWqrUL6nbCcaoeIRUIJ89uI2qvHXuouPwLLcb+h8Dk1wloC
 qHrfHGOIrCK/wMnWIZgurkwB9RRLNQ0SGhvIe9C8x0sWiArMxocOJe8qxLpOeBRWoDHY MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38j6pfg1x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 May 2021 23:51:57 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14F3mdIW088887;
        Fri, 14 May 2021 23:51:57 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38j6pfg1wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 May 2021 23:51:57 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14F3ptak024861;
        Sat, 15 May 2021 03:51:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 38j5jh0084-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 May 2021 03:51:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14F3pqf029622746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:51:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB29442049;
        Sat, 15 May 2021 03:51:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3014E42041;
        Sat, 15 May 2021 03:51:49 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.74.109])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sat, 15 May 2021 03:51:48 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Sat, 15 May 2021 09:21:48 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     xiaoguangrong.eric@gmail.com, mst@redhat.com,
        aneesh.kumar@linux.ibm.com, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, groug@kaod.org, shivaprasadbhat@gmail.com,
        qemu-ppc@nongnu.org, bharata@linux.vnet.ibm.com,
        imammedo@redhat.com, ehabkost@redhat.com
Subject: Re: [RFC PATCH v2] ppc/spapr: Add support for
 H_SCM_PERFORMANCE_STATS hcall
In-Reply-To: <YJyf71+xbdi3Iptf@yekko>
References: <20210506024924.85526-1-vaibhav@linux.ibm.com>
 <YJyf71+xbdi3Iptf@yekko>
Date:   Sat, 15 May 2021 09:21:48 +0530
Message-ID: <87eee8bqnf.fsf@vajain21.in.ibm.com>
Content-Type: text/plain; charset=utf-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iZdzTXlj1pkjNTRdUF3zpM9klssgPDpj
X-Proofpoint-GUID: 02UT30XHTEqDSli3ZW-h5rSLCq3w7Xv1
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-15_02:2021-05-12,2021-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150023
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Thanks for looking into this patch David

David Gibson <david@gibson.dropbear.id.au> writes:

> On Thu, May 06, 2021 at 08:19:24AM +0530, Vaibhav Jain wrote:
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
>> RFC-v1:
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
>>  hw/ppc/spapr_nvdimm.c  | 230 +++++++++++++++++++++++++++++++++++++++++
>>  include/hw/ppc/spapr.h |  19 +++-
>>  2 files changed, 248 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
>> index 252204e25f..b0c2b55a5b 100644
>> --- a/hw/ppc/spapr_nvdimm.c
>> +++ b/hw/ppc/spapr_nvdimm.c
>> @@ -35,6 +35,14 @@
>>  /* SCM device is unable to persist memory contents */
>>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
>>=20=20
>> +/* Maximum output buffer size needed to return all nvdimm_perf_stats */
>> +#define SCM_STATS_MAX_OUTPUT_BUFFER  (sizeof(struct papr_scm_perf_stats=
) + \
>> +                                      sizeof(struct papr_scm_perf_stat)=
 * \
>> +                                      ARRAY_SIZE(nvdimm_perf_stats))
>> +
>> +/* Maximum number of stats that we can return back in a single stat req=
uest */
>> +#define SCM_STATS_MAX_STATS 255
>> +
>>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *n=
vdimm,
>>                             uint64_t size, Error **errp)
>>  {
>> @@ -502,6 +510,227 @@ static target_ulong h_scm_health(PowerPCCPU *cpu, =
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
>> + * verify that buffer & buffer-size provided by the guest is accessible=
 and
>> + * large enough to hold the requested stats. The size of buffer needed =
to
>> + * hold the requested 'num_stat' number of stats is returned in 'size'.
>> + */
>> +static int scm_perf_check_rr_buffer(struct papr_scm_perf_stats *header,
>> +                                    hwaddr addr, size_t *size,
>> +                                    uint32_t *num_stats)
>> +{
>> +    size_t expected_buffsize;
>> +
>> +    /* verify size is enough to hold rr-buffer header */
>> +    if (*size < sizeof(struct papr_scm_perf_stats)) {
>> +        return H_BAD_DATA;
>> +    }
>
> You have already checked this in the caller, so strictly speaking you
> don't need to do so again.
>
Sure, removed this check in v3.

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
>> +        expected_buffsize =3D SCM_STATS_MAX_OUTPUT_BUFFER;
>
> I don't think this is right.  MAX_OUTPUT_BUFFER is based on 255 stats
> being returned, but num_stats=3D=3D0 only returns 2 at present.
>
MAX_OUTPUT_BUFFER is the size of buffer required to return all unique
performance-stats and is dependent on the size if array
'nvdimm_perf_stats' and not the hard limit of 255. Since presently
'nvdimm_perf_stats' only holds two entries right now hence the above
assignmen is correct.

I understand that MAX_OUTPUT_BUFFER can be perhaps wrongly named hence
have changed it to MIN_OUTPUT_BUFFER in v3.

>> +    } else if (*num_stats > SCM_STATS_MAX_STATS) {
>> +        /* Too many stats requested */
>> +        return H_P3;
>> +    } else { /* Return a subset of stats */
>> +        expected_buffsize =3D sizeof(struct papr_scm_perf_stats) +
>> +            (*num_stats) * sizeof(struct papr_scm_perf_stat);
>> +    }
>> +
>> +    if (*size < expected_buffsize) {
>> +        return H_P3;
>> +    }
>> +    *size =3D expected_buffsize;
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
>> +    struct papr_scm_perf_stats perfstats;
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
>> +        return H_BAD_DATA;
>> +    }
>> +
>> +    /* Read and verify rr-buffer header */
>> +    result =3D address_space_read(&address_space_memory, addr,
>> +                                MEMTXATTRS_UNSPECIFIED, &perfstats,
>> +                                sizeof(perfstats));
>> +    if (result !=3D MEMTX_OK) {
>> +        return H_PRIVILEGE;
>> +    }
>> +
>> +    /* Verify that the rr-buffer is valid */
>> +    rc =3D scm_perf_check_rr_buffer(&perfstats, addr, &size, &num_stats=
);
>> +    if (rc !=3D H_SUCCESS) {
>> +        return rc;
>> +    }
>> +
>> +    /* allocate enough buffer space locally for holding max stats */
>> +    stats =3D g_try_malloc0(SCM_STATS_MAX_STATS *
>> +                          sizeof(struct papr_scm_perf_stat));
>
> I think you can simplify the allocation and mem read/write logic even
> further.  You're given the expected buffer size in a register.  So you
> can fail out early if that value is too large (> MAX_OUTPUT_BUFFER) or
> too small (< header size).
Yes, thanks for suggesting this. I have added a check in
scm_perf_check_rr_buffer() to check the size-bounds for rr_buffer.
>
> Then you can make a single allocation of (size) bytes and copy in both
> the header and the body as one unit.  Validate and fill it, then write
> it back as a single unit as well.
>
I still needed to allocate the 'perfstats' header at the beginning of
h_scm_performance_stats(). So instead of allocating 'size' bytes I am
now allocating 'MAX_OUTPUT_BUFFER' buffer at the beginning thats also
used to copy the rr-buffer header from guest, which is then populated
with stats and then copied to guest memory in single shot.

>> +    if (!stats) {
>> +        return H_NO_MEM;
>> +    }
>> +
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
>> +            g_free(stats);
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
>> +    /* Update and copy the local rr-buffer header and stats back to gue=
st */
>> +    perfstats.num_statistics =3D cpu_to_be32(num_stats);
>> +    result =3D address_space_write(&address_space_memory, addr,
>> +                                 MEMTXATTRS_UNSPECIFIED, &perfstats,
>> +                                 sizeof(struct papr_scm_perf_stats));
>> +    if (result =3D=3D MEMTX_OK) {
>> +        result =3D address_space_write(&address_space_memory,
>> +                                     addr + sizeof(struct papr_scm_perf=
_stats),
>> +                                     MEMTXATTRS_UNSPECIFIED, stats,
>> +                                     size - sizeof(struct papr_scm_perf=
_stats));
>> +    }
>> +    /* Cleanup the stats buffer */
>> +    g_free(stats);
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
>> @@ -511,6 +740,7 @@ static void spapr_scm_register_types(void)
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
