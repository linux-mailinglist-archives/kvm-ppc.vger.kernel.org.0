Return-Path: <kvm-ppc+bounces-216-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2569A256AE
	for <lists+kvm-ppc@lfdr.de>; Mon,  3 Feb 2025 11:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3415C165F95
	for <lists+kvm-ppc@lfdr.de>; Mon,  3 Feb 2025 10:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED85200118;
	Mon,  3 Feb 2025 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AJI5jQI5"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2556F3594B
	for <kvm-ppc@vger.kernel.org>; Mon,  3 Feb 2025 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738577501; cv=none; b=E/OnXGGymXv02kdDjZWM5bauZY8IwI95p/HfUv5PyTxjkIo2v72KE6rS7Pz10v8AU0p0kUxFNiBGYDX+UZ6xGZFtwWdSgzb8ok8nQxeXf8ATzlT3f+dvEbFap50ksi9G7O/wYOEDGio8vi6nNXG0SVKoD8DNAML1rYKfF0/rkbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738577501; c=relaxed/simple;
	bh=+mZVCXL0TFq/mqff9ME46329ork1Vekxu6VDm3jZHa8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RnQL7P/SM3WNAuGyLGlc/j0vA5lQKoqkYbTwL6PolK46LDZUFBB6iQ/KU7GDaWpViq2HU89LitQYr1NUwtjC7MHdseVThxlUfxG/tKG7osERlrE8IymIaToFOvQj6oFnRKTksT2gTMGYADb+T+sityrWCJGjVMFOevmLmvjaRVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AJI5jQI5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5131912p027580;
	Mon, 3 Feb 2025 10:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Zop3bfX574f2ZgxeRBn8OI1uEUjFpm
	sIvehIjDwiN3M=; b=AJI5jQI5apq15HzPfzNtD0ORtfJaDrO7JfK1hDs4H1iW0J
	IJtZ/kaqB9xbDNtVOIrBfUgv7UXsOS4nJt8wtCVVGaMsJN2h85xeUQV6qxd25yxU
	1OhrzbO5RJZnQsLrww8ts3le0t1DcCHp5bmrq7cUq60PCdPL/ri2SR/uG8QKCMHX
	MUiXD4oFKFpCPaPO7tglIMJmbgrgPrMfRQsLJd3brQmlFQU+JNe+qReWpA5688HT
	qz9JxHVZ2KLHlb4EMTTa6Ev5TkuiBrKkp5Vcw8A89ssmeb7h6bqt9Y1NChGb2iTa
	2+BFgExYT4nUyhGcrjaCmpogikMxIOCa6Cdj1OKQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jkv92424-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 10:11:34 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 513ABYix020374;
	Mon, 3 Feb 2025 10:11:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jkv9241y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 10:11:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 513747F0007139;
	Mon, 3 Feb 2025 10:11:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxaydvyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 10:11:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 513ABVvw54985036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 10:11:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2BF52005A;
	Mon,  3 Feb 2025 10:11:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30CE52004F;
	Mon,  3 Feb 2025 10:11:28 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.18.190])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  3 Feb 2025 10:11:27 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 03 Feb 2025 15:41:27 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Harsh Prateek Bora <harshpb@linux.ibm.com>, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org
Cc: npiggin@gmail.com, shivaprasadbhat@gmail.com
Subject: Re: [PATCH v2] spapr: nested: Add support for reporting Hostwide
 state counter
In-Reply-To: <a6694f39-895e-4b7e-b0fe-2fce054451b7@linux.ibm.com>
References: <20250123115538.86821-1-vaibhav@linux.ibm.com>
 <a6694f39-895e-4b7e-b0fe-2fce054451b7@linux.ibm.com>
Date: Mon, 03 Feb 2025 15:41:26 +0530
Message-ID: <87jza7xrqp.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QPKekz4yAFv-FjLRDPzu6SKnTCYxPyOd
X-Proofpoint-ORIG-GUID: w2Ju0SiZDrACeYN9mP9nPbSf4Wh19FyY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030078

Harsh Prateek Bora <harshpb@linux.ibm.com> writes:

> On 1/23/25 17:25, Vaibhav Jain wrote:
>> Add support for reporting Hostwide state counters for nested KVM pseries
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
>> 
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
>> ---
>> Changelog:
>> 
>> v1->v2:
>> * Introduced new flags to correctly compare hcall flags
>>    for H_GUEST_{GET,SET}_STATE [Harsh]
>> * Fixed ordering of new GSB elements in spapr_nested.h [Harsh]
>> * s/GSBE_MACHINE_NESTED_DW/GSBE_NESTED_MACHINE_DW/
>> * Minor tweaks to patch description
>> * Updated recipients list
>> ---
>>   hw/ppc/spapr_nested.c         | 82 ++++++++++++++++++++++++++---------
>>   include/hw/ppc/spapr_nested.h | 39 ++++++++++++++---
>>   2 files changed, 96 insertions(+), 25 deletions(-)
>> 
>> diff --git a/hw/ppc/spapr_nested.c b/hw/ppc/spapr_nested.c
>> index 7def8eb73b..7f484bb3e7 100644
>> --- a/hw/ppc/spapr_nested.c
>> +++ b/hw/ppc/spapr_nested.c
>> @@ -64,10 +64,9 @@ static
>>   SpaprMachineStateNestedGuest *spapr_get_nested_guest(SpaprMachineState *spapr,
>>                                                        target_ulong guestid)
>>   {
>> -    SpaprMachineStateNestedGuest *guest;
>> -
>> -    guest = g_hash_table_lookup(spapr->nested.guests, GINT_TO_POINTER(guestid));
>> -    return guest;
>> +    return spapr->nested.guests ?
>> +        g_hash_table_lookup(spapr->nested.guests,
>> +                            GINT_TO_POINTER(guestid)) : NULL;
>>   }
>>   
>>   bool spapr_get_pate_nested_papr(SpaprMachineState *spapr, PowerPCCPU *cpu,
>> @@ -613,6 +612,13 @@ static void *get_guest_ptr(SpaprMachineStateNestedGuest *guest,
>>       return guest; /* for GSBE_NESTED */
>>   }
>>   
>> +static void *get_machine_ptr(SpaprMachineStateNestedGuest *guest,
>> +                             target_ulong vcpuid)
>> +{
>> +    SpaprMachineState *spapr = SPAPR_MACHINE(qdev_get_machine());
>> +    return &spapr->nested;
>> +}
>> +
>>   /*
>>    * set=1 means the L1 is trying to set some state
>>    * set=0 means the L1 is trying to get some state
>> @@ -1012,7 +1018,12 @@ struct guest_state_element_type guest_state_element_types[] = {
>>       GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUFFER, 0x10, runbufout,   copy_state_runbuf),
>>       GSBE_NESTED_VCPU(GSB_VCPU_OUT_BUF_MIN_SZ, 0x8, runbufout, out_buf_min_size),
>>       GSBE_NESTED_VCPU(GSB_VCPU_HDEC_EXPIRY_TB, 0x8, hdecr_expiry_tb,
>> -                     copy_state_hdecr)
>> +                     copy_state_hdecr),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP, current_guest_heap),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_HEAP_MAX, max_guest_heap),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE, current_pgtable_size),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_SIZE_MAX, max_pgtable_size),
>> +    GSBE_NESTED_MACHINE_DW(GSB_GUEST_PGTABLE_RECLAIM, pgtable_reclaim_size),
>>   };
>>   
>>   void spapr_nested_gsb_init(void)
>> @@ -1030,8 +1041,12 @@ void spapr_nested_gsb_init(void)
>>           else if (type->id >= GSB_VCPU_IN_BUFFER)
>>               /* 0x0c00 - 0xf000 Thread + RW */
>>               type->flags = 0;
>> +        else if (type->id >= GSB_GUEST_HEAP)
>> +            /*0x0800 - 0x0804 Hostwide Counters + RO */
>> +            type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE |
>> +                          GUEST_STATE_ELEMENT_TYPE_FLAG_READ_ONLY;
>>           else if (type->id >= GSB_VCPU_LPVR)
>> -            /* 0x0003 - 0x0bff Guest + RW */
>> +            /* 0x0003 - 0x07ff Guest + RW */
>>               type->flags = GUEST_STATE_ELEMENT_TYPE_FLAG_GUEST_WIDE;
>>           else if (type->id >= GSB_HV_VCPU_STATE_SIZE)
>>               /* 0x0001 - 0x0002 Guest + RO */
>> @@ -1138,18 +1153,26 @@ static bool guest_state_request_check(struct guest_state_request *gsr)
>>               return false;
>>           }
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
>>               /* guest wide element type */
>>               if (!(gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE)) {
>> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a guest wide "
>> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a guest wide "
>>                                 "Element ID:%04x.\n", id);
>>                   return false;
>>               }
>>           } else {
>>               /* thread wide element type */
>> -            if (gsr->flags & GUEST_STATE_REQUEST_GUEST_WIDE) {
>> -                qemu_log_mask(LOG_GUEST_ERROR, "trying to set a thread wide "
>> -                              "Element ID:%04x.\n", id);
>> +            if (gsr->flags & (GUEST_STATE_REQUEST_GUEST_WIDE |
>> +                              GUEST_STATE_ELEMENT_TYPE_FLAG_HOST_WIDE)) {
>
> Although translate to same value 0x2, I guess we want to use 
> GUEST_STATE_REQUEST_HOST_WIDE here.
>
>> +                qemu_log_mask(LOG_GUEST_ERROR, "trying to get/set a thread wide"
>> +                            " Element ID:%04x.\n", id);
>>                   return false;
>>               }
>>           }
>> @@ -1509,25 +1532,44 @@ static target_ulong h_guest_getset_state(PowerPCCPU *cpu,
>>       target_ulong buf = args[3];
>>       target_ulong buflen = args[4];
>>       struct guest_state_request gsr;
>> -    SpaprMachineStateNestedGuest *guest;
>> +    SpaprMachineStateNestedGuest *guest = NULL;
>>   
>> -    guest = spapr_get_nested_guest(spapr, lpid);
>> -    if (!guest) {
>> -        return H_P2;
>> -    }
>>       gsr.buf = buf;
>>       assert(buflen <= GSB_MAX_BUF_SIZE);
>>       gsr.len = buflen;
>>       gsr.flags = 0;
>> -    if (flags & H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
>> +
>> +    /* Works for both get/set state */
>> +    if ((flags & H_GUEST_GET_STATE_FLAGS_GUEST_WIDE) ||
>> +        (flags & H_GUEST_SET_STATE_FLAGS_GUEST_WIDE)) {
>>           gsr.flags |= GUEST_STATE_REQUEST_GUEST_WIDE;
>>       }
>> -    if (flags & ~H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE) {
>> -        return H_PARAMETER; /* flag not supported yet */
>> -    }
>>   
>>       if (set) {
>> +        if (flags & ~H_GUEST_SET_STATE_FLAGS_MASK) {
>> +            return H_PARAMETER;
>> +        }
>>           gsr.flags |= GUEST_STATE_REQUEST_SET;
>> +    } else {
>> +        /*
>> +         * No reserved fields to be set in flags nor both
>> +         * GUEST/HOST wide bits
>
> Nit: Can the comment be updated to mention checks in the same order as 
> being performed i.e.
> - Neither both G/H wide bits be set, nor any reserved field.
>
>> +         */
>> +        if ((flags == H_GUEST_GET_STATE_FLAGS_MASK) ||
>> +            (flags & ~H_GUEST_GET_STATE_FLAGS_MASK)) {
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
>>       }
>>       return map_and_getset_state(cpu, guest, vcpuid, &gsr);
>>   }
>> diff --git a/include/hw/ppc/spapr_nested.h b/include/hw/ppc/spapr_nested.h
>> index e420220484..a6d10a1fba 100644
>> --- a/include/hw/ppc/spapr_nested.h
>> +++ b/include/hw/ppc/spapr_nested.h
>> @@ -11,7 +11,13 @@
>>   #define GSB_TB_OFFSET           0x0004 /* Timebase Offset */
>>   #define GSB_PART_SCOPED_PAGETBL 0x0005 /* Partition Scoped Page Table */
>>   #define GSB_PROCESS_TBL         0x0006 /* Process Table */
>> -                    /* RESERVED 0x0007 - 0x0BFF */
>> +                   /* RESERVED 0x0007 - 0x07FF */
>
> Indentation may be corrected for all macro values above and below.
>
>> +#define GSB_GUEST_HEAP          0x0800 /* Guest Management Heap Size */
>> +#define GSB_GUEST_HEAP_MAX      0x0801 /* Guest Management Heap Max Size */
>> +#define GSB_GUEST_PGTABLE_SIZE  0x0802 /* Guest Pagetable Size */
>> +#define GSB_GUEST_PGTABLE_SIZE_MAX   0x0803 /* Guest Pagetable Max Size */
>> +#define GSB_GUEST_PGTABLE_RECLAIM    0x0804 /* Pagetable Reclaim in bytes */
>
> Can these be named GSB_GUEST_PT_* ? Will help with indentation also.
>
>> +                  /* RESERVED 0x0805 - 0xBFF */
>>   #define GSB_VCPU_IN_BUFFER      0x0C00 /* Run VCPU Input Buffer */
>>   #define GSB_VCPU_OUT_BUFFER     0x0C01 /* Run VCPU Out Buffer */
>>   #define GSB_VCPU_VPA            0x0C02 /* HRA to Guest VCPU VPA */
>> @@ -196,6 +202,13 @@ typedef struct SpaprMachineStateNested {
>>   #define NESTED_API_PAPR    2
>>       bool capabilities_set;
>>       uint32_t pvr_base;
>> +    /* Hostwide counters */
>> +    uint64_t current_guest_heap;
>> +    uint64_t max_guest_heap;
>> +    uint64_t current_pgtable_size;
>> +    uint64_t max_pgtable_size;
>> +    uint64_t pgtable_reclaim_size;
>> +
>>       GHashTable *guests;
>>   } SpaprMachineStateNested;
>>   
>> @@ -229,9 +242,15 @@ typedef struct SpaprMachineStateNestedGuest {
>>   #define HVMASK_HDEXCR                 0x00000000FFFFFFFF
>>   #define HVMASK_TB_OFFSET              0x000000FFFFFFFFFF
>>   #define GSB_MAX_BUF_SIZE              (1024 * 1024)
>> -#define H_GUEST_GETSET_STATE_FLAG_GUEST_WIDE 0x8000000000000000
>> -#define GUEST_STATE_REQUEST_GUEST_WIDE       0x1
>> -#define GUEST_STATE_REQUEST_SET              0x2
>> +#define H_GUEST_GET_STATE_FLAGS_MASK   0xC000000000000000ULL
>> +#define H_GUEST_SET_STATE_FLAGS_MASK   0x8000000000000000ULL
>> +#define H_GUEST_SET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
>> +#define H_GUEST_GET_STATE_FLAGS_GUEST_WIDE 0x8000000000000000ULL
>> +#define H_GUEST_GET_STATE_FLAGS_HOST_WIDE  0x4000000000000000ULL
>
> Can we align the macros values indentation?
> We may also use _GW/_HW instead of _GUEST_WIDE/_HOST_WIDE if helps.
>
> With suggested updates:
>
> Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

Thanks Harsh for reviewing this patch.

I have addressed most of your review comments and have sent out a v3 at 
https://lore.kernel.org/all/20250203100912.82560-1-vaibhav@linux.ibm.com


-- 
Cheers
~ Vaibhav

