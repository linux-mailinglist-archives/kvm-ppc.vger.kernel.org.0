Return-Path: <kvm-ppc+bounces-221-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B723A39549
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2025 09:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F4341899735
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2025 08:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D5822DF9D;
	Tue, 18 Feb 2025 08:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RyVSbbmF"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A4C22DF8D
	for <kvm-ppc@vger.kernel.org>; Tue, 18 Feb 2025 08:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866894; cv=none; b=HVQncIVMylbTdJTD5pqzu5S2iCB7QTYqRf+yNZX421nTRipkUXkqoms2veGeC/lTa3o8vYxZf7BxbnJ0H7G/e8F79Bp2xaa/m2ABtZpKSFKhDvMqhO+dzAF5+eIIUpH9kUrUUoeA4FT9XHHZm3hhGpmZojCQ59dTMfVKCRrPW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866894; c=relaxed/simple;
	bh=voCDXs5sfsNN2/r8K5YjXZFzpCzlHAjQEosGtDd6sd0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=drXGnwR3Zd2diV+UhlyGkDNV8cOdUo9yw7H9CrFf1aMh4iiSXJu4WGFHzZ8SwnD76tM3sIzGcX4intpIqQ8GGFe9TDoBX+OsOYeHb9G7dRjpiyGPoQTMJck3gX83a19M3DgRwUKCLj4ytZJlI1NPxv+V730emrqmahBd+0lIitQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RyVSbbmF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51I20ZZo000597;
	Tue, 18 Feb 2025 08:21:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D1I3EWcDyxpBUYW/UG8xM+PDk/+hHD
	8VXFla7sYl5TQ=; b=RyVSbbmFEZ9X1fYTicJNAl5Psy14TXLzpuFC0sCsqtElhe
	mGN1cV5RYLvGajtA1D85KIZj3j8ZOSbZqb+Us6Uvf5nyox+Z1390ck/DF/etUk70
	MAXLHSqWDTCpV+XisKVQQ08FXfNZlZtEMVQgMZRqe3yhC8urs2MNI90numzC35+2
	xLoMSiI7BhZzGxXxXKx9dqM/fnAYjgn/RjBbVLFaw19iD0Lbs7AWd/usBrG1Omre
	4skS0Cb55VGU4ldSwG2khH+sm9LFGrMdzHE6yWCmyqJKwgEeO9HPVUBbV744d0VP
	iS7iVHxRNNaEsiauDID7QTu+I68MIekHsA38EJiw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44vh201ar1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Feb 2025 08:21:24 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51I8BMCv028751;
	Tue, 18 Feb 2025 08:21:24 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44vh201aqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Feb 2025 08:21:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51I634Yd001623;
	Tue, 18 Feb 2025 08:21:23 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44u5myt56y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Feb 2025 08:21:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51I8LLqT52756948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 08:21:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5CBF20043;
	Tue, 18 Feb 2025 08:21:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 362372004D;
	Tue, 18 Feb 2025 08:21:19 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.28.10])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 18 Feb 2025 08:21:18 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Tue, 18 Feb 2025 13:51:17 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org
Cc: harshpb@linux.ibm.com, shivaprasadbhat@gmail.com
Subject: Re: [PATCH v3] spapr: nested: Add support for reporting Hostwide
 state counter
In-Reply-To: <D7OG0Z86JLDP.3JUMXAPUOD7GC@gmail.com>
References: <20250203100912.82560-1-vaibhav@linux.ibm.com>
 <D7OG0Z86JLDP.3JUMXAPUOD7GC@gmail.com>
Date: Tue, 18 Feb 2025 13:51:17 +0530
Message-ID: <87y0y3ek8y.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dqiIiWS_1Ewchr7uGw5uNemtxajSBvwD
X-Proofpoint-ORIG-GUID: JbH83gokNNEGJ5ohq1J3F8t-qIrN-RNS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_03,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502180061


Hi Nic,

Thanks for reviewing this patch. My responses to review comments inline
below:


"Nicholas Piggin" <npiggin@gmail.com> writes:

> On Mon Feb 3, 2025 at 8:09 PM AEST, Vaibhav Jain wrote:
>> Add support for reporting Hostwide state counters for nested KVM pseries
>
> I'd add a brief first paragraph that just describe the concept of
> "hostwide state counters" without going into any spec.
>
>   Hostwide state counters are statistics about the L0 hypervisor's
>   part in the operation of L2 guests, which are accessible by the
>   L1 via hcalls to the L0. These statistics don't necessarily apply
>   to any particular L2, and can be relevant even when there are no
>   L2 guests in the system at all.
>
> Something like that?
Thanks, I will add a similar preemble to the v4 patch description.

>
>> guests running with 'cap-nested-papr' on Qemu-TCG acting as
>> L0-hypervisor. sPAPR supports reporting various stats counters for
>> Guest-Management-Area(GMA) thats owned by L0-Hypervisor and are documented
>> at [1]. These stats counters are exposed via a new bit-flag named
>> 'getHostWideState' for the H_GUEST_GET_STATE hcall. Once this flag is set
>> the hcall should populate the Guest-State-Elements in the requested GSB
>> with the stat counter values. Currently following five counters are
>> supported:
>>
>> * host_heap		: The currently used bytes in the
>> 			  Hypervisor's Guest Management Space
>> 			  associated with the Host Partition.
>> * host_heap_max		: The maximum bytes available in the
>> 			  Hypervisor's Guest Management Space
>> 			  associated with the Host Partition.
>> * host_pagetable	: The currently used bytes in the
>> 			  Hypervisor's Guest Page Table Management
>> 			  Space associated with the Host Partition.
>> * host_pagetable_max	: The maximum bytes available in the
>> 			  Hypervisor's Guest Page Table Management
>> 			  Space associated with the Host Partition.
>> * host_pagetable_reclaim: The amount of space in bytes that has
>> 			  been reclaimed due to overcommit in the
>> 			  Hypervisor's Guest Page Table Management
>> 			  Space associated with the Host Partition.
>
> Rather than list these out in the changelog, could they go into a
> doc or at least code comment?
>
Yes, they are already described in the proposed kernel documentation
changes at
https://lore.kernel.org/all/20241222140247.174998-2-vaibhav@linux.ibm.com

I will also add above descriptions to new members documentation for 'struct
SpaprMachineStateNested'


>> At the moment '0' is being reported for all these counters as these
>> counters doesnt align with how L0-Qemu manages Guest memory.
>>
>> The patch implements support for these counters by adding new members to
>> the 'struct SpaprMachineStateNested'. These new members are then plugged
>> into the existing 'guest_state_element_types[]' with the help of a new
>> macro 'GSBE_NESTED_MACHINE_DW' together with a new helper
>> 'get_machine_ptr()'. guest_state_request_check() is updated to ensure
>> correctness of the requested GSB and finally h_guest_getset_state() is
>> updated to handle the newly introduced flag
>> 'GUEST_STATE_REQUEST_HOST_WIDE'.
>>
>> This patch is tested with the proposed linux-kernel implementation to
>> expose these stat-counter as perf-events at [2].
>>
>> [1]
>> https://lore.kernel.org/all/20241222140247.174998-2-vaibhav@linux.ibm.com
>>
>> [2]
>> https://lore.kernel.org/all/20241222140247.174998-1-vaibhav@linux.ibm.com
>>
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
>> ---
>> Changelog:
>>
>> v2->v1:
>> * Fixed minor nits suggested [Harsh]
>> * s/GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE/GUEST_STATE_REQUEST_HOST_WIDE/
>> in guest_state_request_check() [Harsh]
>> * MInor change in the order of comparision in h_guest_getset_state()
>> [Harsh]
>> * Added reviewed-by of Harsh
>>
>> v1->v2:
>> * Introduced new flags to correctly compare hcall flags
>>   for H_GUEST_{GET,SET}_STATE [Harsh]
>> * Fixed ordering of new GSB elements in spapr_nested.h [Harsh]
>> * s/GSBE_MACHINE_NESTED_DW/GSBE_NESTED_MACHINE_DW/
>> * Minor tweaks to patch description
>> * Updated recipients list
>> ---
>>  hw/ppc/spapr_nested.c         | 82 ++++++++++++++++++++++++++---------
>>  include/hw/ppc/spapr_nested.h | 39 ++++++++++++++---
>>  2 files changed, 96 insertions(+), 25 deletions(-)
>>
>> diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
>> index 7def8eb73b..d1aa6fc866 100644
>> --- a/hw/ppc/spapr_nested.c
>> +++ b/hw/ppc/spapr_nested.c
>> @@ -64,10 +64,9 @@ static
>>  SpaprMachineStateNestedGuest *spapr_get_nested_guest(SpaprMachineState *spapr,
>>                                                       target_ulong guestid)
>>  {
>> -    SpaprMachineStateNestedGuest *guest;
>> -
>> -    guest = g_hash_table_lookup(spapr->nested.guests, GINT_TO_POINTER(guestid));
>> -    return guest;
>> +    return spapr->nested.guests ?
>> +        g_hash_table_lookup(spapr->nested.guests,
>> +                            GINT_TO_POINTER(guestid)) : NULL;
>>  }
>
> Is this a bug-fix that should go in first? What if L1 makes hcall with
> no L2 created today?
>
Yes this is a bug fix but it got only exposed with this patch as
hostwide counters can be requested without creating any guests. Without
this change qemu emmits an assert failure when trying to lookup
NULL==spapr->nested.guests hashtable via g_hash_table_lookup(). The
hashtable spapr->nested.guests is only allocated when first guest is
created.

>>  
>>  bool spapr_get_pate_nested_papr(SpaprMachineState *spapr, PowerPCCPU *cpu,
>> @@ -613,6 +612,13 @@ static void *get_guest_ptr(SpaprMachineStateNestedGuest *guest,
>>      return guest; /* for GSBE_NESTED */
>>  }
>>  
>> +static void *get_machine_ptr(SpaprMachineStateNestedGuest *guest,
>> +                             target_ulong vcpuid)
>> +{
>> +    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
>> +    return &spapr->nested;
>> +}
>
> It would be nicer if the .location op could instead be changed to take
> SpaprMachineState * pointer as well, instead of using
> qdev_get_machine(). guest could be NULL if none exists.
>
I tried implementing this change i.e adding a 'SpaprMachineState *' but
this needs more changes to getset_state() which is relatively
extensively used outside the h_guest_get_state(). Wanted to avoid too
many changes to the existing code for this relatively small feature.

If you feel this is a must have I will comeup with a relatively large v4
with this change.

>> +
>>  /*
>>   * set=1 means the L1 is trying to set some state
>>   * set=0 means the L1 is trying to get some state
>> @@ -1012,7 +1018,12 @@ struct guest_state_element_type guest_state_element_types[] = {
>>      GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUFFER, 0x10, runbufout,   copy_state_runbuf),
>>      GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUF_MIN_SZ, 0x8, runbufout, out_buf_min_size),
>>      GSBE_NESTED_VCPU(GSB_VCPU_HDEC_EXPIRY_TB, 0x8, hdecr_expiry_tb,
>> -                     copy_state_hdecr)
>> +                     copy_state_hdecr),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP, current_guest_heap),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP_MAX, max_guest_heap),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE, current_pgtable_size),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE_MAX, max_pgtable_size),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_RECLAIM, pgtable_reclaim_size),
>>  };
>>  
>>  void spapr_nested_gsb_init(void)
>> @@ -1030,8 +1041,12 @@ void spapr_nested_gsb_init(void)
>>          else if (type->id >= GSB_VCPU_IN_BUFFER)
>>              /* 0x0c00 - 0xf000 Thread + RW */
>>              type->flags = 0;
>> +        else if (type->id >= GSB_GUEST_HEAP)
>> +            /*0x0800 - 0x0804 Hostwide Counters + RO */
>
>                  ^ put a space there
>
Will be addressed in v4
>> +            type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE |
>> +                          GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY;
>>          else if (type->id >= GSB_VCPU_LPVR)
>> -            /* 0x0003 - 0x0bff Guest + RW */
>> +            /* 0x0003 - 0x07ff Guest + RW */
>>              type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE;
>>          else if (type->id >= GSB_HV_VCPU_STATE_SIZE)
>>              /* 0x0001 - 0x0002 Guest + RO */
>> @@ -1138,18 +1153,26 @@ static bool guest_state_request_check(struct guest_state_request *gsr)
>>              return false;
>>          }
>>  
>> -        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE) {
>> +        if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE) {
>> +            /* Hostwide elements cant be clubbed with other types */
>> +            if (!(gsr->flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
>> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a host wide "
>> +                              "Element ID:%04x.\n", id);
>> +                return false;
>> +            }
>> +        } else  if (type->flags & GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE) {
>>              /* guest wide element type */
>>              if (!(gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE)) {
>> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a guest wide "
>> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a guest wide "
>>                                "Element ID:%04x.\n", id);
>>                  return false;
>>              }
>>          } else {
>>              /* thread wide element type */
>> -            if (gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE) {
>> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a thread wide "
>> -                              "Element ID:%04x.\n", id);
>> +            if (gsr->flags & (GUEST_STATE_REQUEST_GUEST_WIDE |
>> +                              GUEST_STATE_REQUEST_HOST_WIDE)) {
>> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a thread wide"
>> +                            " Element ID:%04x.\n", id);
>>                  return false;
>>              }
>>          }
>> @@ -1509,25 +1532,44 @@ static target_ulong h_guest_getset_state(PowerPCCPU *cpu,
>>      target_ulong buf = args[3];
>>      target_ulong buflen = args[4];
>>      struct guest_state_request gsr;
>> -    SpaprMachineStateNestedGuest *guest;
>> +    SpaprMachineStateNestedGuest *guest = NULL;
>>  
>> -    guest = spapr_get_nested_guest(spapr, lpid);
>> -    if (!guest) {
>> -        return H_P2;
>> -    }
>>      gsr.buf = buf;
>>      assert(buflen <= GSB_MAX_BUF_SIZE);
>>      gsr.len = buflen;
>>      gsr.flags = 0;
>> -    if (flags & H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
>> +
>> +    /* Works for both get/set state */
>> +    if ((flags & H_GUEST_GET_STATE_FLAGS_GUEST_WIDE) ||
>> +        (flags & H_GUEST_SET_STATE_FLAGS_GUEST_WIDE)) {
>>          gsr.flags |= GUEST_STATE_REQUEST_GUEST_WIDE;
>>      }
>> -    if (flags & ~H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
>> -        return H_PARAMETER; /* flag not supported yet */
>> -    }
>>  
>>      if (set) {
>> +        if (flags & ~H_GUEST_SET_STATE_FLAGS_MASK) {
>> +            return H_PARAMETER;
>> +        }
>>          gsr.flags |= GUEST_STATE_REQUEST_SET;
>> +    } else {
>> +        /*
>> +         * No reserved fields to be set in flags nor both
>> +         * GUEST/HOST wide bits
>> +         */
>> +        if ((flags & ~H_GUEST_GET_STATE_FLAGS_MASK) ||
>> +            (flags == H_GUEST_GET_STATE_FLAGS_MASK)) {
>> +            return H_PARAMETER;
>> +        }
>> +
>> +        if (flags & H_GUEST_GET_STATE_FLAGS_HOST_WIDE) {
>> +            gsr.flags |= GUEST_STATE_REQUEST_HOST_WIDE;
>> +        }
>> +    }
>> +
>> +    if (!(gsr.flags & GUEST_STATE_REQUEST_HOST_WIDE)) {
>> +        guest = spapr_get_nested_guest(spapr, lpid);
>> +        if (!guest) {
>> +            return H_P2;
>> +        }
>>      }
>>      return map_and_getset_state(cpu, guest, vcpuid, &gsr);
>>  }
>> diff --git a/include/hw/ppc/spapr_nested.h b/include/hw/ppc/spapr_nested.h
>> index e420220484..217376a979 100644
>> --- a/include/hw/ppc/spapr_nested.h
>> +++ b/include/hw/ppc/spapr_nested.h
>> @@ -11,7 +11,13 @@
>>  #define GSB_TB_OFFSET           0x0004 /* Timebase Offset */
>>  #define GSB_PART_SCOPED_PAGETBL 0x0005 /* Partition Scoped Page Table */
>>  #define GSB_PROCESS_TBL         0x0006 /* Process Table */
>> -                    /* RESERVED 0x0007 - 0x0BFF */
>> +                    /* RESERVED 0x0007 - 0x07FF */
>> +#define GSB_GUEST_HEAP          0x0800 /* Guest Management Heap Size */
>> +#define GSB_GUEST_HEAP_MAX      0x0801 /* Guest Management Heap Max Size */
>> +#define GSB_GUEST_PGTABLE_SIZE  0x0802 /* Guest Pagetable Size */
>> +#define GSB_GUEST_PGTABLE_SIZE_MAX   0x0803 /* Guest Pagetable Max Size */
>> +#define GSB_GUEST_PGTABLE_RECLAIM    0x0804 /* Pagetable Reclaim in bytes */
>
> Could these names be changed so it's a bit more obvious that they
> are "hostwide" stats? GSB_L0_GUEST_MAX, for example?
>
> Also maybe call them GSB_L0_GUEST_HEAP_INUSE, PGTABLE_SIZE_INUSE,
> and PGTABLE_RECLAIMED to be slightly clearer about them.
>
Sure and thanks for the suggestion. I have renamed them in v4
>> +                    /* RESERVED 0x0805 - 0xBFF */
>>  #define GSB_VCPU_IN_BUFFER      0x0C00 /* Run VCPU Input Buffer */
>>  #define GSB_VCPU_OUT_BUFFER     0x0C01 /* Run VCPU Out Buffer */
>>  #define GSB_VCPU_VPA            0x0C02 /* HRA to Guest VCPU VPA */
>> @@ -196,6 +202,13 @@ typedef struct SpaprMachineStateNested {
>>  #define NESTED_API_PAPR    2
>>      bool capabilities_set;
>>      uint32_t pvr_base;
>> +    /* Hostwide counters */
>> +    uint64_t current_guest_heap;
>> +    uint64_t max_guest_heap;
>> +    uint64_t current_pgtable_size;
>> +    uint64_t max_pgtable_size;
>> +    uint64_t pgtable_reclaim_size;
>
> Similar for these names, I would keep them relatively
> consistent with the #define names unless there is a
> reason to change.
>
> guest_heap_inuse, guest_heap_max, etc.
>
Sure and thanks for the suggestion. I have renamed them in v4 as well
added more extensive comments documentating these counters.

> Looks pretty good though.
Thanks

>
> Thanks,
> Nick
>
>> +
>>      GHashTable *guests;
>>  } SpaprMachineStateNested;
>>  
>> @@ -229,9 +242,15 @@ typedef struct SpaprMachineStateNestedGuest {
>>  #define HVMASK_HDEXCR                 0x00000000FFFFFFFF
>>  #define HVMASK_TB_OFFSET              0x000000FFFFFFFFFF
>>  #define GSB_MAX_BUF_SIZE              (1024 * 1024)
>> -#define H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE 0x8000000000000000
>> -#define GUEST_STATE_REQUEST_GUEST_WIDE       0x1
>> -#define GUEST_STATE_REQUEST_SET              0x2
>> +#define H_GUEST_GET_STATE_FLAGS_MASK   0xC000000000000000ULL
>> +#define H_GUEST_SET_STATE_FLAGS_MASK   0x8000000000000000ULL
>> +#define H_GUEST_SET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
>> +#define H_GUEST_GET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
>> +#define H_GUEST_GET_STATE_FLAGS_HOST_WIDE  0x4000000000000000ULL
>> +
>> +#define GUEST_STATE_REQUEST_GUEST_WIDE     0x1
>> +#define GUEST_STATE_REQUEST_HOST_WIDE      0x2
>> +#define GUEST_STATE_REQUEST_SET            0x4
>>  
>>  /*
>>   * As per ISA v3.1B, following bits are reserved:
>> @@ -251,6 +270,15 @@ typedef struct SpaprMachineStateNestedGuest {
>>      .copy = (c)                                    \
>>  }
>>  
>> +#define GSBE_NESTED_MACHINE_DW(i, f)  {                             \
>> +        .id = (i),                                                  \
>> +        .size = 8,                                                  \
>> +        .location = get_machine_ptr,                                \
>> +        .offset = offsetof(struct SpaprMachineStateNested, f),     \
>> +        .copy = copy_state_8to8,                                    \
>> +        .mask = HVMASK_DEFAULT                                      \
>> +}
>> +
>>  #define GSBE_NESTED(i, sz, f, c) {                             \
>>      .id = (i),                                                 \
>>      .size = (sz),                                              \
>> @@ -509,7 +537,8 @@ struct guest_state_element_type {
>>      uint16_t id;
>>      int size;
>>  #define GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE 0x1
>> -#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY  0x2
>> +#define GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE 0x2
>> +#define GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY 0x4
>>     uint16_t flags;
>>      void *(*location)(SpaprMachineStateNestedGuest *, target_ulong);
>>      size_t offset;
>
>

-- 
Cheers
~ Vaibhav

