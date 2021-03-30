Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8209934E151
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Mar 2021 08:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhC3GjG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Mar 2021 02:39:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhC3Gij (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Mar 2021 02:38:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U6Xv6k164382;
        Tue, 30 Mar 2021 02:38:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4DnTYsILREm/Sbpp8IruIyNNTFYmzUEy6LVS1EX1QBE=;
 b=LowfMUjXdru8iiUpCft7gUdb9epOP6P96qDJJZCAlPXo7LXNaOMfIY+mwlboLb0BK1Nf
 2azhG5dYmmPf7lh8tczV0uHI+r9HPrBXnPcCuHmxUvY25a1Da08Z2B+R1199hcWkOMEy
 nGN6DVgehq2m+C7BIhk3ZMDVvtBwn0Cokj/DNFCYII5Mk/WnubqBsUOCNZ+TCsrMuMNW
 pZP6TLMgfCT/NgIovysp1Z9Xdn8s4WodimVJEnIFr4r54kvGairQc8XUux2fmcOXJotg
 nQAVa3qetP+a7j7bAD8YxoQUUq87L2kXam3C9FcUXYLtpIhEp9/AnwSCONMwuwahBM04 Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj7vp173-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 02:38:18 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12U6YHsU166247;
        Tue, 30 Mar 2021 02:38:18 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jj7vp16b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 02:38:18 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12U6SeWk018146;
        Tue, 30 Mar 2021 06:38:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 37hvb819je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 06:38:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12U6br9t27722048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 06:37:54 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 134884204D;
        Tue, 30 Mar 2021 06:38:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27BC24203F;
        Tue, 30 Mar 2021 06:38:10 +0000 (GMT)
Received: from [9.85.83.77] (unknown [9.85.83.77])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Mar 2021 06:38:09 +0000 (GMT)
Subject: Re: [PATCH] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
To:     Vaibhav Jain <vaibhav@linux.ibm.com>, qemu-devel@nongnu.org,
        kvm-ppc@vger.kernel.org, qemu-ppc@nongnu.org,
        david@gibson.dropbear.id.au, mst@redhat.com, imammedo@redhat.com,
        xiaoguangrong.eric@gmail.com
Cc:     ehabkost@redhat.com, aneesh.kumar@linux.ibm.com, groug@kaod.org,
        shivaprasadbhat@gmail.com, bharata@linux.vnet.ibm.com
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
From:   Shivaprasad G Bhat <sbhat@linux.ibm.com>
Message-ID: <ef44262e-907d-5200-022c-a26e16522ab0@linux.ibm.com>
Date:   Tue, 30 Mar 2021 12:08:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20210329162259.536964-1-vaibhav@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E1fE2TWC7qJC6nqE31AlAdOeGZNhKriJ
X-Proofpoint-ORIG-GUID: eHKvyr-sBruLtfzkLYsdSeEpgLAPg-9E
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_02:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103300045
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Vaibhav,

Some comments inline..

On 3/29/21 9:52 PM, Vaibhav Jain wrote:
> Add support for H_SCM_HEALTH hcall described at [1] for spapr
> nvdimms. This enables guest to detect the 'unarmed' status of a
> specific spapr nvdimm identified by its DRC and if its unarmed, mark
> the region backed by the nvdimm as read-only.
>
> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> from 'struct nvdimm->unarmed' member.
>
> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> ppc64 are proposed at [2].
>
> References:
> [1] "Hypercall Op-codes (hcalls)"
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
>
> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>      https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>   hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
>   include/hw/ppc/spapr.h |  4 ++--
>   2 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..e38740036d 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,13 @@
>   #include "qemu/range.h"
>   #include "hw/ppc/spapr_numa.h"
>   
> +/* DIMM health bitmap bitmap indicators */
> +/* SCM device is unable to persist memory contents */
> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
> +
> +/* Bits status indicators for health bitmap indicating unarmed dimm */
> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
> +
>   bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>                              uint64_t size, Error **errp)
>   {
> @@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
>       return H_SUCCESS;
>   }
>   
> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
> +                                 target_ulong opcode, target_ulong *args)
> +{
> +    uint32_t drc_index = args[0];
> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
> +    NVDIMMDevice *nvdimm;
> +
> +    if (drc && spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +


Please check if drc->dev is not NULL too. DRCs are created in advance

and drc->dev may not be assigned if the device is not plugged yet.


> +    nvdimm = NVDIMM(drc->dev);
> +
> +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
> +    args[0] = nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;


Please use object_property_get_bool to fetch the unarmed value.


> +
> +    /* health bitmap mask same as the health bitmap */
> +    args[1] = args[0];
> +
> +    return H_SUCCESS;
> +}
> +
>   static void spapr_scm_register_types(void)
>   {

...


Thanks,

Shivaprasad

