Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142C43529A5
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhDBKUy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 06:20:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229553AbhDBKUx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 06:20:53 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 132A4HnP196287;
        Fri, 2 Apr 2021 06:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : content-type :
 mime-version; s=pp1; bh=N18DXA7RlcUuasxPvWDBjawFDujTbVzBJa5UrmPsA/k=;
 b=p6sjzXtkPZ3nSBEtaQbXwHFVH3ZHYZJ/5afER4o16FSYG90yGLBEQqLxyrwzDF0hqpa/
 6MC9jbtIMqUBkosI6HSNOdKMnJlMkJM2rulgZ74OBTCjXCC+q3nLxdgb5k6+xdoEx26s
 o+v096+Za14M4pcDYzgJP5jKCzFzl3oJAEMg/06ERwJBwlE7x06HBXQRyw7ieLRLBug2
 7muYOLSnYAmBKfVT4dKM7+wtJ5/bqXzNF+JMvIJ5F77+1VxPnBHb+nttpaco5YepIYlu
 tNZWD2McGjFpPMS6ksTg14sz6HlfMsbWyfW/hUL/jmtVWRelIeQBic5LcUP06G43JpSt LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37nbtch287-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:20:37 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 132AKbne045183;
        Fri, 2 Apr 2021 06:20:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37nbtch27n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 06:20:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 132AIMXk002713;
        Fri, 2 Apr 2021 10:20:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 37n28ts70d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Apr 2021 10:20:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 132AKXii39190832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Apr 2021 10:20:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2413BA4065;
        Fri,  2 Apr 2021 10:20:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B679AA405B;
        Fri,  2 Apr 2021 10:20:28 +0000 (GMT)
Received: from vajain21.in.ibm.com (unknown [9.102.3.66])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  2 Apr 2021 10:20:28 +0000 (GMT)
Received: by vajain21.in.ibm.com (sSMTP sendmail emulation); Fri, 02 Apr 2021 15:50:27 +0530
From:   Vaibhav Jain <vaibhav@linux.ibm.com>
To:     Greg Kurz <groug@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>
Cc:     xiaoguangrong.eric@gmail.com, mst@redhat.com,
        aneesh.kumar@linux.ibm.com, bharata@linux.vnet.ibm.com,
        qemu-devel@nongnu.org, kvm-ppc@vger.kernel.org,
        shivaprasadbhat@gmail.com, qemu-ppc@nongnu.org,
        marcel.apfelbaum@gmail.com, imammedo@redhat.com,
        ehabkost@redhat.com
Subject: Re: [PATCH v2] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
In-Reply-To: <20210401075155.44b9267d@bahia.lan>
References: <20210401010519.7225-1-vaibhav@linux.ibm.com>
 <YGUvQ0XD+pQvWC/9@yekko.fritz.box> <20210401075155.44b9267d@bahia.lan>
Date:   Fri, 02 Apr 2021 15:50:27 +0530
Message-ID: <8735w92djo.fsf@vajain21.in.ibm.com>
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3M7oveSi8zFALwhH1EzqwlVGGU52MVrW
X-Proofpoint-GUID: b94HnSDXVodkQRi1xrgQcooY84iSkQHz
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-02_06:2021-04-01,2021-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020070
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Greg,

Thanks for looking into this patch.

Greg Kurz <groug@kaod.org> writes:

> On Thu, 1 Apr 2021 13:26:11 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>
>> On Thu, Apr 01, 2021 at 06:35:19AM +0530, Vaibhav Jain wrote:
>> > Add support for H_SCM_HEALTH hcall described at [1] for spapr
>> > nvdimms. This enables guest to detect the 'unarmed' status of a
>> > specific spapr nvdimm identified by its DRC and if its unarmed, mark
>> > the region backed by the nvdimm as read-only.
>> > 
>> > The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
>> > returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
>> > from 'struct nvdimm->unarmed' member.
>> > 
>> > Linux kernel side changes to enable handling of 'unarmed' nvdimms for
>> > ppc64 are proposed at [2].
>> > 
>> > References:
>> > [1] "Hypercall Op-codes (hcalls)"
>> >     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n220
>> > [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>> >     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
>> > 
>> > Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
>> 
>> As well as the handful of comments below, this will definitely need to
>> wait for ppc-6.1 at this point.
>> 
>> > ---
>> > Changelog
>> > 
>> > v2:
>> > * Added a check for drc->dev to ensure that the dimm is plugged in
>> >   when servicing H_SCM_HEALTH. [ Shiva ]
>> > * Instead of accessing the 'nvdimm->unarmed' member directly use the
>> >   object_property_get_bool accessor to fetch it. [ Shiva ]
>> > * Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
>> > * Updated patch description reference#1 to point appropriate section
>> >   in the documentation. [ Greg ]
>> > ---
>> >  hw/ppc/spapr_nvdimm.c  | 38 ++++++++++++++++++++++++++++++++++++++
>> >  include/hw/ppc/spapr.h |  3 ++-
>> >  2 files changed, 40 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
>> > index b46c36917c..34096e4718 100644
>> > --- a/hw/ppc/spapr_nvdimm.c
>> > +++ b/hw/ppc/spapr_nvdimm.c
>> > @@ -31,6 +31,13 @@
>> >  #include "qemu/range.h"
>> >  #include "hw/ppc/spapr_numa.h"
>> >  
>> > +/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
>> > +/* SCM device is unable to persist memory contents */
>> > +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
>> 
>> You can use PPC_BIT() for more clarity here.
>> 
>
> I had already suggested PPC_BIT(0) but since this macro was copied
> from the kernel source, I've let Vaibhav decide whether to use
> PPC_BIT() or keep the macro and comment it comes from the kernel.
>
> I agree I prefer PPC_BIT(0) :-)
>
Have switched to PPC_BIT in v3
>> > +/* Bits status indicators for health bitmap indicating unarmed dimm */
>> > +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
>> 
>> I'm not sure why you want two equal #defines here.
>> 
>
> Especially, this define doesn't make sense for the hypervisor IMHO.
>
> It is _just_ the mask of bits for the "unarmed" state in the kernel.
>
Have gotten rid of this define in v3. We can revisit this In future when
support for more bits is added.

>> > +
>> >  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>> >                             uint64_t size, Error **errp)
>> >  {
>> > @@ -467,6 +474,36 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
>> >      return H_SUCCESS;
>> >  }
>> >  
>> > +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
>> > +                                 target_ulong opcode, target_ulong *args)
>> > +{
>> > +    uint32_t drc_index = args[0];
>> > +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
>> > +    NVDIMMDevice *nvdimm;
>> > +
>> > +    if (drc && spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>> 
>> This will fail badly if !drc (given index is way out of bounds).  I'm
>> pretty sure you want
>> 	if (!drc || spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>> 
>> 
>> > +        return H_PARAMETER;
>> > +    }
>> > +
>> > +    /* Ensure that the dimm is plugged in */
>> > +    if (!drc->dev) {
>> > +        return H_HARDWARE;
>> 
>> H_HARDWARE doesn't seem right - it's the guest that has chosen to
>> attempt this on an unplugged LMB, not the (virtual) hardware's fault.
>> 
>
> Yes. As already suggested, simply do the same as in other hcall
> implementations in this file, e.g. from h_scm_bind_mem() :
>
>     if (!drc || !drc->dev ||
>         spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
>         return H_PARAMETER;
>     }
>
Yes,  have used the same construct in the fixed v3

>> > +    }
>> > +
>> > +    nvdimm = NVDIMM(drc->dev);
>> > +
>> > +    args[0] = 0;
>> > +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
>
> Not sure this comment is super useful.
>
Have reworked this function in v3.

>> > +    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NULL)) {
>> > +        args[0] |= PAPR_PMEM_UNARMED;
>> > +    }
>> > +
>> > +    /* Update the health bitmap with the applicable mask */
>> > +    args[1] = PAPR_PMEM_UNARMED_MASK;
>
> I still think this is a misuse of PAPR_PMEM_UNARMED_MASK... The
> meaning of args[1] is "health-bit-valid-bitmap indicate which
> bits in health-bitmap are valid" according to the documentation.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n228
>
> Without any further detail, I tend to consider this as a hint
> to the guest on the bits supported by the hypervisor. Since
> we can only set PAPR_PMEM_UNARMED, for now, args[1] should
> be set to just that bit PAPR_PMEM_UNARMED. Other bits can
> be added later if QEMU supports more of them.
>
Agree and addressed in v3.

>> > +
>> > +    return H_SUCCESS;
>> > +}
>> > +
>> >  static void spapr_scm_register_types(void)
>> >  {
>> >      /* qemu/scm specific hcalls */
>> > @@ -475,6 +512,7 @@ static void spapr_scm_register_types(void)
>> >      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>> >      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>> >      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>> > +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>> >  }
>> >  
>> >  type_init(spapr_scm_register_types)
>> > diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
>> > index 47cebaf3ac..6e1eafb05d 100644
>> > --- a/include/hw/ppc/spapr.h
>> > +++ b/include/hw/ppc/spapr.h
>> > @@ -538,8 +538,9 @@ struct SpaprMachineState {
>> >  #define H_SCM_BIND_MEM          0x3EC
>> >  #define H_SCM_UNBIND_MEM        0x3F0
>> >  #define H_SCM_UNBIND_ALL        0x3FC
>> > +#define H_SCM_HEALTH            0x400
>> >  
>> > -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
>> > +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>> >  
>> >  /* The hcalls above are standardized in PAPR and implemented by pHyp
>> >   * as well.
>> 
>

-- 
Cheers
~ Vaibhav
