Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15DD2DFC36
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Dec 2020 14:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgLUNIf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Dec 2020 08:08:35 -0500
Received: from smtpout1.mo804.mail-out.ovh.net ([79.137.123.220]:54109 "EHLO
        smtpout1.mo804.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgLUNIe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Dec 2020 08:08:34 -0500
Received: from mxplan5.mail.ovh.net (unknown [10.109.156.137])
        by mo804.mail-out.ovh.net (Postfix) with ESMTPS id 24CEB7C5D3BE;
        Mon, 21 Dec 2020 14:07:49 +0100 (CET)
Received: from kaod.org (37.59.142.99) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 21 Dec
 2020 14:07:48 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-99G00371c404d7-b6ff-4745-9ec9-f04cbe5bd22c,
                    0B619508FA83EFFE02DCDB9DB2C04BF8DACB1B13) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 82.253.208.248
Date:   Mon, 21 Dec 2020 14:07:47 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Shivaprasad G Bhat <sbhat@linux.ibm.com>
CC:     <xiaoguangrong.eric@gmail.com>, <mst@redhat.com>,
        <imammedo@redhat.com>, <david@gibson.dropbear.id.au>,
        <qemu-devel@nongnu.org>, <qemu-ppc@nongnu.org>,
        <linux-nvdimm@lists.01.org>, <aneesh.kumar@linux.ibm.com>,
        <kvm-ppc@vger.kernel.org>, <shivaprasadbhat@gmail.com>,
        <bharata@linux.vnet.ibm.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC Qemu PATCH v2 2/2] spapr: nvdimm: Implement async flush
 hcalls
Message-ID: <20201221140747.226430f1@bahia.lan>
In-Reply-To: <160674940727.2492771.7855399693883710135.stgit@lep8c.aus.stglabs.ibm.com>
References: <160674929554.2492771.17651548703390170573.stgit@lep8c.aus.stglabs.ibm.com>
        <160674940727.2492771.7855399693883710135.stgit@lep8c.aus.stglabs.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG6EX2.mxp5.local (172.16.2.52) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: 1669b459-b703-44e0-a245-36f6314b4799
X-Ovh-Tracer-Id: 11395514435346667963
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrvddtvddghedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtjeertdertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefuddtieejjeevheekieeltefgleetkeetheettdeifeffvefhffelffdtfeeljeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhg
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 30 Nov 2020 09:17:24 -0600
Shivaprasad G Bhat <sbhat@linux.ibm.com> wrote:

> When the persistent memory beacked by a file, a cpu cache flush instruction
> is not sufficient to ensure the stores are correctly flushed to the media.
> 
> The patch implements the async hcalls for flush operation on demand from the
> guest kernel.
> 
> The device option sync-dax is by default off and enables explicit asynchronous
> flush requests from guest. It can be disabled by setting syn-dax=on.
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/mem/nvdimm.c         |    1 +
>  hw/ppc/spapr_nvdimm.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/hw/mem/nvdimm.h |   10 ++++++
>  include/hw/ppc/spapr.h  |    3 +-
>  4 files changed, 92 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/mem/nvdimm.c b/hw/mem/nvdimm.c
> index 03c2201b56..37a4db0135 100644
> --- a/hw/mem/nvdimm.c
> +++ b/hw/mem/nvdimm.c
> @@ -220,6 +220,7 @@ static void nvdimm_write_label_data(NVDIMMDevice *nvdimm, const void *buf,
>  
>  static Property nvdimm_properties[] = {
>      DEFINE_PROP_BOOL(NVDIMM_UNARMED_PROP, NVDIMMDevice, unarmed, false),
> +    DEFINE_PROP_BOOL(NVDIMM_SYNC_DAX_PROP, NVDIMMDevice, sync_dax, false),
>      DEFINE_PROP_END_OF_LIST(),
>  };
>  
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index a833a63b5e..557e36aa98 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -22,6 +22,7 @@
>   * THE SOFTWARE.
>   */
>  #include "qemu/osdep.h"
> +#include "qemu/cutils.h"
>  #include "qapi/error.h"
>  #include "hw/ppc/spapr_drc.h"
>  #include "hw/ppc/spapr_nvdimm.h"
> @@ -155,6 +156,11 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr, void *fdt,
>                               "operating-system")));
>      _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL, 0));
>  
> +    if (!nvdimm->sync_dax) {

So this is done unconditionally for all machine types. This means that a
guest started on a newer QEMU cannot be migrated to an older QEMU. This
is annoying because people legitimately expect an existing machine type
to be migratable to any QEMU version that supports it.

This means that something like the following should be added in hw_compat_5_2[]
to fix the property for pre-6.0 machine types:

    { "nvdimm", "sync-dax", "on" },

> +        _FDT(fdt_setprop(fdt, child_offset, "ibm,async-flush-required",
> +                         NULL, 0));
> +    }
> +
>      return child_offset;
>  }
>  
> @@ -370,6 +376,78 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
>      return H_SUCCESS;
>  }
>  
> +typedef struct SCMAsyncFlushData {
> +    int fd;
> +    uint64_t token;
> +} SCMAsyncFlushData;
> +
> +static int flush_worker_cb(void *opaque)
> +{
> +    int ret = H_SUCCESS;
> +    SCMAsyncFlushData *req_data = opaque;
> +
> +    /* flush raw backing image */
> +    if (qemu_fdatasync(req_data->fd) < 0) {
> +        error_report("papr_scm: Could not sync nvdimm to backend file: %s",
> +                     strerror(errno));
> +        ret = H_HARDWARE;
> +    }
> +
> +    g_free(req_data);
> +
> +    return ret;
> +}
> +
> +static target_ulong h_scm_async_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
> +                                      target_ulong opcode, target_ulong *args)
> +{
> +    int ret;
> +    uint32_t drc_index = args[0];
> +    uint64_t continue_token = args[1];
> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
> +    PCDIMMDevice *dimm;
> +    HostMemoryBackend *backend = NULL;
> +    SCMAsyncFlushData *req_data = NULL;
> +
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    if (continue_token != 0) {
> +        ret = spapr_drc_get_async_hcall_status(drc, continue_token);
> +        if (ret == H_BUSY) {
> +            args[0] = continue_token;
> +            return H_LONG_BUSY_ORDER_1_SEC;
> +        }
> +
> +        return ret;
> +    }
> +
> +    dimm = PC_DIMM(drc->dev);
> +    backend = MEMORY_BACKEND(dimm->hostmem);
> +
> +    req_data = g_malloc0(sizeof(SCMAsyncFlushData));
> +    req_data->fd = memory_region_get_fd(&backend->mr);
> +
> +    continue_token = spapr_drc_get_new_async_hcall_token(drc);
> +    if (!continue_token) {
> +        g_free(req_data);
> +        return H_P2;
> +    }
> +    req_data->token = continue_token;
> +
> +    spapr_drc_run_async_hcall(drc, continue_token, &flush_worker_cb, req_data);
> +
> +    ret = spapr_drc_get_async_hcall_status(drc, continue_token);
> +    if (ret == H_BUSY) {
> +        args[0] = req_data->token;
> +        return ret;
> +    }
> +
> +    return ret;
> +}
> +
>  static target_ulong h_scm_unbind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
>                                       target_ulong opcode, target_ulong *args)
>  {
> @@ -486,6 +564,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_BIND_MEM, h_scm_bind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
> +    spapr_register_hypercall(H_SCM_ASYNC_FLUSH, h_scm_async_flush);
>  }
>  
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
> index c699842dd0..9e8795766e 100644
> --- a/include/hw/mem/nvdimm.h
> +++ b/include/hw/mem/nvdimm.h
> @@ -51,6 +51,7 @@ OBJECT_DECLARE_TYPE(NVDIMMDevice, NVDIMMClass, NVDIMM)
>  #define NVDIMM_LABEL_SIZE_PROP "label-size"
>  #define NVDIMM_UUID_PROP       "uuid"
>  #define NVDIMM_UNARMED_PROP    "unarmed"
> +#define NVDIMM_SYNC_DAX_PROP    "sync-dax"
>  
>  struct NVDIMMDevice {
>      /* private */
> @@ -85,6 +86,15 @@ struct NVDIMMDevice {
>       */
>      bool unarmed;
>  
> +    /*
> +     * On PPC64,
> +     * The 'off' value results in the async-flush-required property set
> +     * in the device tree for pseries machines. When 'off', the guest
> +     * initiates explicity flush requests to the backend device ensuring
> +     * write persistence.
> +     */
> +    bool sync_dax;
> +
>      /*
>       * The PPC64 - spapr requires each nvdimm device have a uuid.
>       */
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index 2e89e36cfb..6d7110b7dc 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -535,8 +535,9 @@ struct SpaprMachineState {
>  #define H_SCM_BIND_MEM          0x3EC
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
> +#define H_SCM_ASYNC_FLUSH       0x4A0
>  
> -#define MAX_HCALL_OPCODE        H_SCM_UNBIND_ALL
> +#define MAX_HCALL_OPCODE        H_SCM_ASYNC_FLUSH
>  
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.
> 
> 
> 

