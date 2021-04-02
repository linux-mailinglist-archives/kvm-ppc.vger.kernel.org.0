Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924DA352CF8
	for <lists+kvm-ppc@lfdr.de>; Fri,  2 Apr 2021 18:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhDBPUO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 2 Apr 2021 11:20:14 -0400
Received: from 5.mo52.mail-out.ovh.net ([188.165.45.220]:40624 "EHLO
        5.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbhDBPUM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 2 Apr 2021 11:20:12 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.137])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id D3FBF256D31;
        Fri,  2 Apr 2021 17:12:19 +0200 (CEST)
Received: from kaod.org (37.59.142.95) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 2 Apr 2021
 17:12:19 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-95G0017aa8a2b9-02fb-4f61-8382-18e3f2b59c62,
                    CB78C42F11C12B32A09FD1B1D16988F28347D0D1) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Fri, 2 Apr 2021 17:12:17 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
CC:     <qemu-devel@nongnu.org>, <kvm-ppc@vger.kernel.org>,
        <qemu-ppc@nongnu.org>, <david@gibson.dropbear.id.au>,
        <mst@redhat.com>, <imammedo@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <shivaprasadbhat@gmail.com>,
        <bharata@linux.vnet.ibm.com>, <aneesh.kumar@linux.ibm.com>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
Message-ID: <20210402171217.711ad6b5@bahia.lan>
In-Reply-To: <20210402102128.213943-1-vaibhav@linux.ibm.com>
References: <20210402102128.213943-1-vaibhav@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.95]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 56c54b3b-684b-4f6b-821b-a618a71a243b
X-Ovh-Tracer-Id: 3770357316049148347
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeiiedgkeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeekgeffheegjeegvdejueevleeiffekheeghfeijeetvedukeehudetlefhteefgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrdelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepmhgrrhgtvghlrdgrphhfvghlsggruhhmsehgmhgrihhlrdgtohhm
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri,  2 Apr 2021 15:51:28 +0530
Vaibhav Jain <vaibhav@linux.ibm.com> wrote:

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
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n220
> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
> 
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog
> 
> v3:
> * Switched to PPC_BIT macro for definitions of the health bits. [ Greg, David ]
> * Updated h_scm_health() to use a const uint64_t to denote supported
>   bits in 'hbitmap_mask'.
> * Fixed an error check for drc->dev to return H_PARAMETER in case nvdimm
>   is not yet plugged in [ Greg ]
> * Fixed an wrong error check for ensuring drc and drc-type are correct
>   [ Greg ]
> 
> v2:
> * Added a check for drc->dev to ensure that the dimm is plugged in
>   when servicing H_SCM_HEALTH. [ Shiva ]
> * Instead of accessing the 'nvdimm->unarmed' member directly use the
>   object_property_get_bool accessor to fetch it. [ Shiva ]
> * Update the usage of PAPR_PMEM_UNARMED* macros [ Greg ]
> * Updated patch description reference#1 to point appropriate section
>   in the documentation. [ Greg ]
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  hw/ppc/spapr_nvdimm.c  | 36 ++++++++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  3 ++-
>  2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..252204e25f 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,10 @@
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
>  
> +/* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
> +/* SCM device is unable to persist memory contents */
> +#define PAPR_PMEM_UNARMED PPC_BIT(0)
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -467,6 +471,37 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
>      return H_SUCCESS;
>  }
>  
> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
> +                                 target_ulong opcode, target_ulong *args)
> +{
> +
> +    NVDIMMDevice *nvdimm;
> +    uint64_t hbitmap = 0;
> +    uint32_t drc_index = args[0];
> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
> +    const uint64_t hbitmap_mask = PAPR_PMEM_UNARMED;
> +
> +
> +    /* Ensure that the drc is valid & is valid PMEM dimm and is plugged in */
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    nvdimm = NVDIMM(drc->dev);
> +
> +    /* Update if the nvdimm is unarmed and send its status via health bitmaps */
> +    if (object_property_get_bool(OBJECT(nvdimm), NVDIMM_UNARMED_PROP, NULL)) {
> +        hbitmap |= PAPR_PMEM_UNARMED;
> +    }
> +
> +    /* Update the out args with health bitmap/mask */
> +    args[0] = hbitmap;
> +    args[1] = hbitmap_mask;
> +
> +    return H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -475,6 +510,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>  }
>  
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 47cebaf3ac..6e1eafb05d 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -538,8 +538,9 @@ struct SpaprMachineState {
>  #define H_SCM_BIND_MEM          0x3EC
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
> +#define H_SCM_HEALTH            0x400
>  
> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>  
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.

