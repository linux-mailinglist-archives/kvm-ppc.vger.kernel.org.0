Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9109A835
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Aug 2019 09:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbfHWHH5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Aug 2019 03:07:57 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35419 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731077AbfHWHH5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 23 Aug 2019 03:07:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46FCCZ1vwCz9s7T;
        Fri, 23 Aug 2019 17:07:54 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: Re: [PATCH v6 3/7] powerpc/powernv: Introduce FW_FEATURE_ULTRAVISOR
In-Reply-To: <20190822034838.27876-4-cclaudio@linux.ibm.com>
References: <20190822034838.27876-1-cclaudio@linux.ibm.com> <20190822034838.27876-4-cclaudio@linux.ibm.com>
Date:   Fri, 23 Aug 2019 17:07:51 +1000
Message-ID: <87zhk04awo.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Claudio Carvalho <cclaudio@linux.ibm.com> writes:

> In PEF enabled systems, some of the resources which were previously
> hypervisor privileged are now ultravisor privileged and controlled by
> the ultravisor firmware.
>
> This adds FW_FEATURE_ULTRAVISOR to indicate if PEF is enabled.
>
> The host kernel can use FW_FEATURE_ULTRAVISOR, for instance, to skip
> accessing resources (e.g. PTCR and LDBAR) in case PEF is enabled.
>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> [ andmike: Device node name to "ibm,ultravisor" ]

^ I dropped this comment as it refers to a previous version of the patch
and is not accurate anymore.

cheers

> Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/firmware.h         |  5 +++--
>  arch/powerpc/include/asm/ultravisor.h       | 14 ++++++++++++
>  arch/powerpc/kernel/prom.c                  |  4 ++++
>  arch/powerpc/platforms/powernv/Makefile     |  1 +
>  arch/powerpc/platforms/powernv/ultravisor.c | 24 +++++++++++++++++++++
>  5 files changed, 46 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/ultravisor.h
>  create mode 100644 arch/powerpc/platforms/powernv/ultravisor.c
>
> diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
> index faeca8b76c8c..b3e214a97f3a 100644
> --- a/arch/powerpc/include/asm/firmware.h
> +++ b/arch/powerpc/include/asm/firmware.h
> @@ -50,6 +50,7 @@
>  #define FW_FEATURE_DRC_INFO	ASM_CONST(0x0000000800000000)
>  #define FW_FEATURE_BLOCK_REMOVE ASM_CONST(0x0000001000000000)
>  #define FW_FEATURE_PAPR_SCM 	ASM_CONST(0x0000002000000000)
> +#define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
>  
>  #ifndef __ASSEMBLY__
>  
> @@ -68,9 +69,9 @@ enum {
>  		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
>  		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
>  		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
> -		FW_FEATURE_PAPR_SCM,
> +		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR,
>  	FW_FEATURE_PSERIES_ALWAYS = 0,
> -	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL,
> +	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | FW_FEATURE_ULTRAVISOR,
>  	FW_FEATURE_POWERNV_ALWAYS = 0,
>  	FW_FEATURE_PS3_POSSIBLE = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
>  	FW_FEATURE_PS3_ALWAYS = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
> diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
> new file mode 100644
> index 000000000000..dc6e1ea198f2
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Ultravisor definitions
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +#ifndef _ASM_POWERPC_ULTRAVISOR_H
> +#define _ASM_POWERPC_ULTRAVISOR_H
> +
> +int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
> +				  int depth, void *data);
> +
> +#endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 7159e791a70d..5828f1c81dc9 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -55,6 +55,7 @@
>  #include <asm/firmware.h>
>  #include <asm/dt_cpu_ftrs.h>
>  #include <asm/drmem.h>
> +#include <asm/ultravisor.h>
>  
>  #include <mm/mmu_decl.h>
>  
> @@ -702,6 +703,9 @@ void __init early_init_devtree(void *params)
>  #ifdef CONFIG_PPC_POWERNV
>  	/* Some machines might need OPAL info for debugging, grab it now. */
>  	of_scan_flat_dt(early_init_dt_scan_opal, NULL);
> +
> +	/* Scan tree for ultravisor feature */
> +	of_scan_flat_dt(early_init_dt_scan_ultravisor, NULL);
>  #endif
>  
>  #ifdef CONFIG_FA_DUMP
> diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
> index 69a3aefa905b..49186f0985a4 100644
> --- a/arch/powerpc/platforms/powernv/Makefile
> +++ b/arch/powerpc/platforms/powernv/Makefile
> @@ -4,6 +4,7 @@ obj-y			+= idle.o opal-rtc.o opal-nvram.o opal-lpc.o opal-flash.o
>  obj-y			+= rng.o opal-elog.o opal-dump.o opal-sysparam.o opal-sensor.o
>  obj-y			+= opal-msglog.o opal-hmi.o opal-power.o opal-irqchip.o
>  obj-y			+= opal-kmsg.o opal-powercap.o opal-psr.o opal-sensor-groups.o
> +obj-y			+= ultravisor.o
>  
>  obj-$(CONFIG_SMP)	+= smp.o subcore.o subcore-asm.o
>  obj-$(CONFIG_PCI)	+= pci.o pci-ioda.o npu-dma.o pci-ioda-tce.o
> diff --git a/arch/powerpc/platforms/powernv/ultravisor.c b/arch/powerpc/platforms/powernv/ultravisor.c
> new file mode 100644
> index 000000000000..02ac57b4bded
> --- /dev/null
> +++ b/arch/powerpc/platforms/powernv/ultravisor.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Ultravisor high level interfaces
> + *
> + * Copyright 2019, IBM Corporation.
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/printk.h>
> +#include <linux/of_fdt.h>
> +
> +#include <asm/ultravisor.h>
> +#include <asm/firmware.h>
> +
> +int __init early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
> +					 int depth, void *data)
> +{
> +	if (!of_flat_dt_is_compatible(node, "ibm,ultravisor"))
> +		return 0;
> +
> +	powerpc_firmware_features |= FW_FEATURE_ULTRAVISOR;
> +	pr_debug("Ultravisor detected!\n");
> +	return 1;
> +}
> -- 
> 2.20.1
