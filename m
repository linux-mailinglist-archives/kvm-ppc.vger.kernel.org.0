Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E7434EF03
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Mar 2021 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhC3RJf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Mar 2021 13:09:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28628 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232420AbhC3RI6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Mar 2021 13:08:58 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UGpklm046509;
        Tue, 30 Mar 2021 13:07:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=uTTMdWJjSUTPpaCGFIQwP9AzM712D9b+ucU/im1WZpw=;
 b=IP0SZq5B685v/9sYDsE84pMQG9gOHqyOc799dmQmw4x1QmOid81rQbLFWRJI00oytU/D
 BBJlhc0k81M63x4UNPsl8lQliW53mxp60IQCLrpbOcp1U+lmgb+zuJ5UDuEHexLzLo6X
 EGJhe7enPBdNlgBlfHWINV7LQKZniXl9lipeO8YLUQL8X+gBjeG+0T4NG/3pFTLfQvpx
 EqbOB4a8jzZ1oW9W/slTzoi2n2jAmUch4uBykyBzlQge1levFhxUlBaXsg3gHAk2ejDu
 We4w3HiVxMkr0hiN8OwBICf7rxRnH6rpM/+YElMam3r4WNCQX8F3Xz48hVdcFPqaAgIz VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmfjv89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 13:07:16 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12UGq856048089;
        Tue, 30 Mar 2021 13:07:16 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmfjv7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 13:07:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12UH53nK007026;
        Tue, 30 Mar 2021 17:07:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyhaw2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 17:07:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12UH6qss35782916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 17:06:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68C21A4051;
        Tue, 30 Mar 2021 17:07:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86ABBA404D;
        Tue, 30 Mar 2021 17:07:07 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.85.111.7])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 30 Mar 2021 17:07:07 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Tue, 30 Mar 2021 22:37:06 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        qemu-ppc@nongnu.org, david@gibson.dropbear.id.au, mst@redhat.com,
        imammedo@redhat.com, xiaoguangrong.eric@gmail.com,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com
Subject: Re: [PATCH] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
In-Reply-To: <20210330161437.45872897@bahia.lan>
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
 <20210330161437.45872897@bahia.lan>
Date:   Tue, 30 Mar 2021 22:37:06 +0530
Message-ID: <87r1jwpo3p.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W44JBgOpQFz_v9gt6C9PaZ_tWBsAA1AE
X-Proofpoint-ORIG-GUID: NMg58oGRxVWYCNbMejL9CfQE-w0V2tQq
X-Proofpoint-UnRewURL: 6 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_08:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300115
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Thanks for looking into this patch Greg. My responses below inline.


Greg Kurz <groug@kaod.org> writes:

> Hi Vaibhav,
>
> Great to see you around :-)

:-)

>
> On Mon, 29 Mar 2021 21:52:59 +0530
> Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
>> Add support for H_SCM_HEALTH hcall described at [1] for spapr
>> nvdimms. This enables guest to detect the 'unarmed' status of a
>> specific spapr nvdimm identified by its DRC and if its unarmed, mark
>> the region backed by the nvdimm as read-only.
>> 
>
> Any chance that you can provide the documentation of this new hcall ?
>
H_SCM_HEALTH specifications is already documented in linux kernel
documentation at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst

That documentation was added when kernel support for H_SCM_HEALTH hcall
support was implemented in 5.9 kernel. 

>> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
>> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
>> from 'struct nvdimm->unarmed' member.
>> 
>> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
>> ppc64 are proposed at [2].
>> 
>> References:
>> [1] "Hypercall Op-codes (hcalls)"
>>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
>> 
>> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
>> 
>> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> ---
>>  hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
>>  include/hw/ppc/spapr.h |  4 ++--
>>  2 files changed, 32 insertions(+), 2 deletions(-)
>> 
>> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
>> index b46c36917c..e38740036d 100644
>> --- a/hw/ppc/spapr_nvdimm.c
>> +++ b/hw/ppc/spapr_nvdimm.c
>> @@ -31,6 +31,13 @@
>>  #include "qemu/range.h"
>>  #include "hw/ppc/spapr_numa.h"
>>  
>> +/* DIMM health bitmap bitmap indicators */
>> +/* SCM device is unable to persist memory contents */
>> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
>
> This looks like PPC_BIT(0).
>
Yes, right. Will update the patch in v2 to use the PPC_BIT macro.

>> +
>> +/* Bits status indicators for health bitmap indicating unarmed dimm */
>> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
>> +
>>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>>                             uint64_t size, Error **errp)
>>  {
>> @@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
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
>> +        return H_PARAMETER;
>> +    }
>> +
>> +    nvdimm = NVDIMM(drc->dev);
>
> Yeah as already suggested by Shiva, drc->dev should be checked like
> in h_scm_bind_mem().
>
Yes, will send a v2 with this case handled.

>> +
>> +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
>> +    args[0] = nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;
>> +
>
> Shouldn't ^^ use PAPR_PMEM_UNARMED then ?
>
>> +    /* health bitmap mask same as the health bitmap */
>> +    args[1] = args[0];
>> +
>
> If so, it seems that PAPR_PMEM_UNARMED_MASK isn't even needed.

Definition of these defines are similar to what kernel implementation
uses at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/powerpc/platforms/pseries/papr_scm.c#n53

Since unarmed condition can also arise due to an unhealthy nvdimm hence
the kernel implementation uses a mask thats composed of two bits
PPC_BIT(0) and PPC_BIT(6) being set. Though we arent using PPC_BIT(6)
right now in qemu, it will change in future when better nvdimm health
reporting will be done. Hence kept the PPC_BIT(0) define as well as the
mask to mimic the kernel definitions.

>
> Having access to the excerpts from the PAPR addendum that describes
> this hcall would _really_ help in reviewing.
>
The kernel documentation for H_SCM_HEALTH mentioned above captures most
if not all parts of the PAPR addendum for this hcall. I believe it
contains enough information to review the patch. If you still need more
info than please let me know.


>> +    return H_SUCCESS;
>> +}
>> +
>>  static void spapr_scm_register_types(void)
>>  {
>>      /* qemu/scm specific hcalls */
>> @@ -475,6 +504,7 @@ static void spapr_scm_register_types(void)
>>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>>  }
>>  
>>  type_init(spapr_scm_register_types)
>> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> index 47cebaf3ac..18859b9ab2 100644
>> --- a/include/hw/ppc/spapr.h
>> +++ b/include/hw/ppc/spapr.h
>> @@ -538,8 +538,8 @@ struct SpaprMachineState {
>>  #define H_SCM_BIND_MEM          0x3EC
>>  #define H_SCM_UNBIND_MEM        0x3F0
>>  #define H_SCM_UNBIND_ALL        0x3FC
>> -
>> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
>> +#define H_SCM_HEALTH            0x400
>> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>>  
>>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>>   * as well.
>

-- 
Cheers
~ Vaibhav
