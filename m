Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED9634F028
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Mar 2021 19:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhC3Ruc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Mar 2021 13:50:32 -0400
Received: from 5.mo52.mail-out.ovh.net ([188.165.45.220]:41285 "EHLO
        5.mo52.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbhC3RuB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Mar 2021 13:50:01 -0400
X-Greylist: delayed 12917 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2021 13:50:01 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.188])
        by mo52.mail-out.ovh.net (Postfix) with ESMTPS id CA2B22578A1;
        Tue, 30 Mar 2021 16:14:39 +0200 (CEST)
Received: from kaod.org (37.59.142.101) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 30 Mar
 2021 16:14:38 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G004ce38ddac-b932-4c77-ab80-7586f22d16a3,
                    ACC3036D4A0BACA70991A0E48D5F19CB1CCAE693) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 30 Mar 2021 16:14:37 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
CC:     <qemu-devel@nongnu.org>, <kvm-ppc@vger.kernel.org>,
        <qemu-ppc@nongnu.org>, <david@gibson.dropbear.id.au>,
        <mst@redhat.com>, <imammedo@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <shivaprasadbhat@gmail.com>,
        <bharata@linux.vnet.ibm.com>, <aneesh.kumar@linux.ibm.com>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH] ppc/spapr: Add support for implement support for
 H_SCM_HEALTH
Message-ID: <20210330161437.45872897@bahia.lan>
In-Reply-To: <20210329162259.536964-1-vaibhav@linux.ibm.com>
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 8eb5dc12-5bd8-458e-91ea-a889d4d30dac
X-Ovh-Tracer-Id: 3625116227933411771
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeitddgjeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeeftdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpedvhfehtefgheehudejiefhudeliedvkeduteejieelleelfedvtdeftdetfefghfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomh
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Vaibhav,

Great to see you around :-)

On Mon, 29 Mar 2021 21:52:59 +0530
Vaibhav Jain <vaibhav@linux.ibm.com> wrote:

> Add support for H_SCM_HEALTH hcall described at [1] for spapr
> nvdimms. This enables guest to detect the 'unarmed' status of a
> specific spapr nvdimm identified by its DRC and if its unarmed, mark
> the region backed by the nvdimm as read-only.
> 

Any chance that you can provide the documentation of this new hcall ?

> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> from 'struct nvdimm->unarmed' member.
> 
> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> ppc64 are proposed at [2].
> 
> References:
> [1] "Hypercall Op-codes (hcalls)"
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
> 
> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
> 
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
>  include/hw/ppc/spapr.h |  4 ++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index b46c36917c..e38740036d 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -31,6 +31,13 @@
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
>  
> +/* DIMM health bitmap bitmap indicators */
> +/* SCM device is unable to persist memory contents */
> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))

This looks like PPC_BIT(0).

> +
> +/* Bits status indicators for health bitmap indicating unarmed dimm */
> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>                             uint64_t size, Error **errp)
>  {
> @@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
>      return H_SUCCESS;
>  }
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
> +    nvdimm = NVDIMM(drc->dev);

Yeah as already suggested by Shiva, drc->dev should be checked like
in h_scm_bind_mem().

> +
> +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
> +    args[0] = nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;
> +

Shouldn't ^^ use PAPR_PMEM_UNARMED then ?

> +    /* health bitmap mask same as the health bitmap */
> +    args[1] = args[0];
> +

If so, it seems that PAPR_PMEM_UNARMED_MASK isn't even needed.

Having access to the excerpts from the PAPR addendum that describes
this hcall would _really_ help in reviewing.

> +    return H_SUCCESS;
> +}
> +
>  static void spapr_scm_register_types(void)
>  {
>      /* qemu/scm specific hcalls */
> @@ -475,6 +504,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
>  }
>  
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 47cebaf3ac..18859b9ab2 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -538,8 +538,8 @@ struct SpaprMachineState {
>  #define H_SCM_BIND_MEM          0x3EC
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
> -
> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> +#define H_SCM_HEALTH            0x400
> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
>  
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.

