Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95E352988
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 12:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhDBKIL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 06:08:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65156 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234207AbhDBKIK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 06:08:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132A48KA085706;
        Fri, 2 Apr 2021 06:07:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=dfBZQZbwH63kFfNtpHbfhFDnx/mOnkv423VTL2mzO6c=;
 b=nH7oY8q3NjdMnzK1Bjifz8bzlMIFkJQx0SOwtTRoPdXOMX44mLHzbkKVSAZwad0vylpA
 NSP+dXsWVKlwsgIxfBQTStZwgJ1FouxLgx4/OrWeZDLnB13cdlVeyToNvM0iauX4aOjE
 KbriafkZsdBCZy++//Y4gHhA2jhlOihwZe5Ue8hueNo66njcL+k2Ig+NogdAG4qzzaqD
 j8G7WleCn/E76C9rlJbQhCkZYhLjd9xmipxUYnjKuYRIO7DBHQq6bubDgVCJo3R+58Uf
 crAEDh53kKx8c2++Ectm0pfAHw+oEFHtoupgzio0UuITX87it0fiTCRJNTL/YMWdcWSq KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37nxbxky74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:07:59 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 132A5KQk090558;
        Fri, 2 Apr 2021 06:07:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37nxbxky6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:07:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 132A2H6d001160;
        Fri, 2 Apr 2021 10:07:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37n28rs6jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 10:07:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 132A7YZo24052188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Apr 2021 10:07:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A298A405F;
        Fri,  2 Apr 2021 10:07:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74DBDA405B;
        Fri,  2 Apr 2021 10:07:49 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.102.3.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  2 Apr 2021 10:07:49 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 02 Apr 2021 15:37:48 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        groug@kaod.org, ehabkost@redhat.com, marcel.apfelbaum@gmail.com
Subject: Re: [PATCH v2] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
In-Reply-To: <YGUvQ0XD+pQvWC/9@yekko.fritz.box>
References: <20210401010519.7225-1-vaibhav@linux.ibm.com>
 <YGUvQ0XD+pQvWC/9@yekko.fritz.box>
Date:   Fri, 02 Apr 2021 15:37:48 +0530
Message-ID: <877dll2e4r.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8bDj3V53zwy9pFjJ29xmjoFe819og9_n
X-Proofpoint-ORIG-GUID: M-VIMb7_gdNGnmNW2kBwgCO8SrLqhMd9
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_06:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020070
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Hi David,

Thanks for looking into this patch

David Gibson <david@gibson.dropbear.id.au> writes:

> On Thu, Apr 01, 2021 at 06:35:19AM +0530, Vaibhav Jain wrote:
>> Add support for H_SCM_HEALTH hcall described at [1] for spapr
>> nvdimms. This enables guest to detect the 'unarmed' status of a
>> specific spapr nvdimm identified by its DRC and if its unarmed, mark
>> the region backed by the nvdimm as read-only.
>> 
>> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
>> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
>> from 'struct nvdimm->unarmed' member.
>> 
>> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
>> ppc64 are proposed at [2].
>> 
>> References:
>> [1] "Hypercall Op-codes (hcalls)"
>>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n220
>> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
>> 
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>
> As well as the handful of comments below, this will definitely need to
> wait for ppc-6.1 at this point.
>
Sure
>> ---
>> Changelog
>> 
>> v2:
>> * Added a check for drc->dev to ensure that the dimm is plugged in
>>   when servicing H_SCM_HEALTH. [ Shiva ]
>> * Instead of accessing the 'nvdimm->unarmed' member directly use the
>>   object_property_get_bool accessor to fetch it. [ Shiva ]
>> * Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
>> * Updated patch description reference#1 to point appropriate section
>>   in the documentation. [ Greg ]
>> ---
>>  hw/ppc/spapr_nvdimm.c  | 38 ++++++++++++++++++++++++++++++++++++++
>>  include/hw/ppc/spapr.h |  3 ++-
>>  2 files changed, 40 insertions(+), 1 deletion(-)
>> 
>> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
>> index b46c36917c..34096e4718 100644
>> --- a/hw/ppc/spapr_nvdimm.c
>> +++ b/hw/ppc/spapr_nvdimm.c
>> @@ -31,6 +31,13 @@
>>  #include "qemu/range.h"
>>  #include "hw/ppc/spapr_numa.h"
>>  
>> +/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
>> +/* SCM device is unable to persist memory contents */
>> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
>
> You can use PPC_BIT() for more clarity here.
>
Sure, will address this in v3
>> +/* Bits status indicators for health bitmap indicating unarmed dimm */
>> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
>
> I'm not sure why you want two equal #defines here.
>
Will address this in v3. Switched to a single define.
>> +
>>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>>                             uint64_t size, Error **errp)
>>  {
>> @@ -467,6 +474,36 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
>>      return H_SUCCESS;
>>  }
>>  
>> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
>> +                                 target_ulong opcode, target_ulong *args)
>> +{
>> +    uint32_t drc_index = args[0];
>> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
>> +    NVDIMMDevice *nvdimm;
>> +
>> +    if (drc && spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>
> This will fail badly if !drc (given index is way out of bounds).  I'm
> pretty sure you want
> 	if (!drc || spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>
>
Thanks for catching this. I have fixed this in v3
>> +        return H_PARAMETER;
>> +    }
>> +
>> +    /* Ensure that the dimm is plugged in */
>> +    if (!drc->dev) {
>> +        return H_HARDWARE;
>
> H_HARDWARE doesn't seem right - it's the guest that has chosen to
> attempt this on an unplugged LMB, not the (virtual) hardware's fault.
>
Agree, addressed this in v3
>> +    }
>> +
>> +    nvdimm = NVDIMM(drc->dev);
>> +
>> +    args[0] = 0;
>> +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
>> +    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NULL)) {
>> +        args[0] |= PAPR_PMEM_UNARMED;
>> +    }
>> +
>> +    /* Update the health bitmap with the applicable mask */
>> +    args[1] = PAPR_PMEM_UNARMED_MASK;
>> +
>> +    return H_SUCCESS;
>> +}
>> +
>>  static void spapr_scm_register_types(void)
>>  {
>>      /* qemu/scm specific hcalls */
>> @@ -475,6 +512,7 @@ static void spapr_scm_register_types(void)
>>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>>  }
>>  
>>  type_init(spapr_scm_register_types)
>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> index 47cebaf3ac..6e1eafb05d 100644
>> --- a/include/hw/ppc/spapr.h
>> +++ b/include/hw/ppc/spapr.h
>> @@ -538,8 +538,9 @@ struct SpaprMachineState {
>>  #define H_SCM_BIND_MEM          0x3EC
>>  #define H_SCM_UNBIND_MEM        0x3F0
>>  #define H_SCM_UNBIND_ALL        0x3FC
>> +#define H_SCM_HEALTH            0x400
>>  
>> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
>> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>>  
>>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>>   * as well.
>
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

-- 
Cheers
~ Vaibhav
