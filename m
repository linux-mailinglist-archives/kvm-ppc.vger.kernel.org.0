Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B634FC67
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbhCaJQG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 05:16:06 -0400
Received: from smtpout1.mo529.mail-out.ovh.net ([178.32.125.2]:50451 "EHLO
        smtpout1.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234349AbhCaJPm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 05:15:42 -0400
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.240])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id E13979628E35;
        Wed, 31 Mar 2021 11:15:33 +0200 (CEST)
Received: from kaod.org (37.59.142.103) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 31 Mar
 2021 11:15:33 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-103G005b0bc809d-7187-44d2-90d1-46301cc8e212,
                    9D8442807461E38AC8E896D56D3346AE12FD8989) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Wed, 31 Mar 2021 11:15:31 +0200
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
Message-ID: <20210331111531.79a5bf64@bahia.lan>
In-Reply-To: <87r1jwpo3p.fsf@vajain21.in.ibm.com>
References: <20210329162259.536964-1-vaibhav@linux.ibm.com>
        <20210330161437.45872897@bahia.lan>
        <87r1jwpo3p.fsf@vajain21.in.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.103]
X-ClientProxiedBy: DAG6EX1.mxp5.local (172.16.2.51) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 1ccbc2d1-9f15-469a-b168-9e167d0aa9f0
X-Ovh-Tracer-Id: 4446460211319314875
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudeivddgudegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeekgeffheegjeegvdejueevleeiffekheeghfeijeetvedukeehudetlefhteefgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutdefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomh
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 30 Mar 2021 22:37:06 +0530
Vaibhav Jain <vaibhav@linux.ibm.com> wrote:

> 
> Thanks for looking into this patch Greg. My responses below inline.
> 
> 
> Greg Kurz <groug@kaod.org> writes:
> 
> > Hi Vaibhav,
> >
> > Great to see you around :-)
> 
> :-)
> 
> >
> > On Mon, 29 Mar 2021 21:52:59 +0530
> > Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
> >
> >> Add support for H_SCM_HEALTH hcall described at [1] for spapr
> >> nvdimms. This enables guest to detect the 'unarmed' status of a
> >> specific spapr nvdimm identified by its DRC and if its unarmed, mark
> >> the region backed by the nvdimm as read-only.
> >> 
> >
> > Any chance that you can provide the documentation of this new hcall ?
> >
> H_SCM_HEALTH specifications is already documented in linux kernel
> documentation at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
> 
> That documentation was added when kernel support for H_SCM_HEALTH hcall
> support was implemented in 5.9 kernel. 
> 

Oops I skipped that indeed. Maybe even make it:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst#n220

for faster access.

> >> The patch adds h_scm_health() to handle the H_SCM_HEALTH hcall which
> >> returns two 64-bit bitmaps (health bitmap, health bitmap mask) derived
> >> from 'struct nvdimm->unarmed' member.
> >> 
> >> Linux kernel side changes to enable handling of 'unarmed' nvdimms for
> >> ppc64 are proposed at [2].
> >> 
> >> References:
> >> [1] "Hypercall Op-codes (hcalls)"
> >>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/powerpc/papr_hcalls.rst
> >> 
> >> [2] "powerpc/papr_scm: Mark nvdimm as unarmed if needed during probe"
> >>     https://lore.kernel.org/linux-nvdimm/20210329113103.476760-1-vaibhav@linux.ibm.com/
> >> 
> >> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> >> ---
> >>  hw/ppc/spapr_nvdimm.c  | 30 ++++++++++++++++++++++++++++++
> >>  include/hw/ppc/spapr.h |  4 ++--
> >>  2 files changed, 32 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> >> index b46c36917c..e38740036d 100644
> >> --- a/hw/ppc/spapr_nvdimm.c
> >> +++ b/hw/ppc/spapr_nvdimm.c
> >> @@ -31,6 +31,13 @@
> >>  #include "qemu/range.h"
> >>  #include "hw/ppc/spapr_numa.h"
> >>  
> >> +/* DIMM health bitmap bitmap indicators */
> >> +/* SCM device is unable to persist memory contents */
> >> +#define PAPR_PMEM_UNARMED (1ULL << (63 - 0))
> >
> > This looks like PPC_BIT(0).
> >
> Yes, right. Will update the patch in v2 to use the PPC_BIT macro.
> 

Well, since this was copied from the kernel sources, I guess you can
leave it as is. Maybe just explain where this macro comes from if you
do so.

> >> +
> >> +/* Bits status indicators for health bitmap indicating unarmed dimm */
> >> +#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED)
> >> +
> >>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
> >>                             uint64_t size, Error **errp)
> >>  {
> >> @@ -467,6 +474,28 @@ static target_ulong h_scm_unbind_all(PowerPCCPU *cpu, SpaprMachineState *spapr,
> >>      return H_SUCCESS;
> >>  }
> >>  
> >> +static target_ulong h_scm_health(PowerPCCPU *cpu, SpaprMachineState *spapr,
> >> +                                 target_ulong opcode, target_ulong *args)
> >> +{
> >> +    uint32_t drc_index = args[0];
> >> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
> >> +    NVDIMMDevice *nvdimm;
> >> +
> >> +    if (drc && spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> >> +        return H_PARAMETER;
> >> +    }
> >> +
> >> +    nvdimm = NVDIMM(drc->dev);
> >
> > Yeah as already suggested by Shiva, drc->dev should be checked like
> > in h_scm_bind_mem().
> >
> Yes, will send a v2 with this case handled.
> 
> >> +
> >> +    /* Check if the nvdimm is unarmed and send its status via health bitmaps */
> >> +    args[0] = nvdimm->unarmed ? PAPR_PMEM_UNARMED_MASK : 0;
> >> +
> >
> > Shouldn't ^^ use PAPR_PMEM_UNARMED then ?
> >
> >> +    /* health bitmap mask same as the health bitmap */
> >> +    args[1] = args[0];
> >> +
> >
> > If so, it seems that PAPR_PMEM_UNARMED_MASK isn't even needed.
> 
> Definition of these defines are similar to what kernel implementation
> uses at
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/powerpc/platforms/pseries/papr_scm.c#n53
> 
> Since unarmed condition can also arise due to an unhealthy nvdimm hence
> the kernel implementation uses a mask thats composed of two bits
> PPC_BIT(0) and PPC_BIT(6) being set. Though we arent using PPC_BIT(6)
> right now in qemu, it will change in future when better nvdimm health
> reporting will be done. Hence kept the PPC_BIT(0) define as well as the
> mask to mimic the kernel definitions.
> 

After a deeper look into the kernel documentation and code, it seems that
we really don't need PAPR_PMEM_UNARMED_MASK at all on the QEMU side : it
is _just_ the mask of bits that linux does support (i.e. bit 0 and 6) and
applies to the health bitmap returned by H_SCM_HEALTH.

On the QEMU side, as you say, we just support setting bit 0 from the
time being : args[0] should thus be set to PAPR_PMEM_UNARMED if the
NVDIMM is unarmed, not PAPR_PMEM_UNARMED_MASK.

Also, it seems that the purpose of the health bitmap mask is to tell the
guest about the bits supported by the hypervisor : args[1] should thus
unconditionally be set to PAPR_PMEM_UNARMED, otherwise we'd tell the
guest none of the bits are valid when the NVDIMM isn't unarmed.

> >
> > Having access to the excerpts from the PAPR addendum that describes
> > this hcall would _really_ help in reviewing.
> >
> The kernel documentation for H_SCM_HEALTH mentioned above captures most
> if not all parts of the PAPR addendum for this hcall. I believe it
> contains enough information to review the patch. If you still need more
> info than please let me know.
> 

Sorry again for having missed the link the first time. I guess I have all
the information I need now.

> 
> >> +    return H_SUCCESS;
> >> +}
> >> +
> >>  static void spapr_scm_register_types(void)
> >>  {
> >>      /* qemu/scm specific hcalls */
> >> @@ -475,6 +504,7 @@ static void spapr_scm_register_types(void)
> >>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
> >>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
> >>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> >> +    spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> >>  }
> >>  
> >>  type_init(spapr_scm_register_types)
> >> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> >> index 47cebaf3ac..18859b9ab2 100644
> >> --- a/include/hw/ppc/spapr.h
> >> +++ b/include/hw/ppc/spapr.h
> >> @@ -538,8 +538,8 @@ struct SpaprMachineState {
> >>  #define H_SCM_BIND_MEM          0x3EC
> >>  #define H_SCM_UNBIND_MEM        0x3F0
> >>  #define H_SCM_UNBIND_ALL        0x3FC
> >> -
> >> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> >> +#define H_SCM_HEALTH            0x400
> >> +#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> >>  
> >>  /* The hcalls above are standardized in PAPR and implemented by pHyp
> >>   * as well.
> >
> 

