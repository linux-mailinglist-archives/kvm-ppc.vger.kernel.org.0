Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F3A227884
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 08:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgGUGD2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 02:03:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgGUGD1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 02:03:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06L62xjD150943;
        Tue, 21 Jul 2020 02:03:18 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32dn0xr2pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 02:03:18 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06L5xN0s002465;
        Tue, 21 Jul 2020 06:03:17 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 32brq902ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 06:03:17 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06L63GEt48955690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 06:03:17 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5736124052;
        Tue, 21 Jul 2020 06:03:16 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23526124053;
        Tue, 21 Jul 2020 06:03:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.85.6])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 06:03:13 +0000 (GMT)
Subject: Re: [v3 13/15] tools/perf: Add perf tools support for extended
 register capability in powerpc
To:     Athira Rajeev <atrajeev@linux.vnet.ibm.com>, mpe@ellerman.id.au,
        acme@kernel.org, jolsa@kernel.org
Cc:     ego@linux.vnet.ibm.com, mikey@neuling.org,
        maddy@linux.vnet.ibm.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, svaidyan@in.ibm.com,
        linuxppc-dev@lists.ozlabs.org
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
 <1594996707-3727-14-git-send-email-atrajeev@linux.vnet.ibm.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <29874556-c8e2-bfdd-8827-e764613f8736@linux.ibm.com>
Date:   Tue, 21 Jul 2020 11:33:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594996707-3727-14-git-send-email-atrajeev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_01:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210039
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org



On 7/17/20 8:08 PM, Athira Rajeev wrote:
> From: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> 
> Add extended regs to sample_reg_mask in the tool side to use
> with `-I?` option. Perf tools side uses extended mask to display
> the platform supported register names (with -I? option) to the user
> and also send this mask to the kernel to capture the extended registers
> in each sample. Hence decide the mask value based on the processor
> version.
> 
> Currently definitions for `mfspr`, `SPRN_PVR` are part of
> `arch/powerpc/util/header.c`. Move this to a header file so that
> these definitions can be re-used in other source files as well.
> 
> Signed-off-by: Anju T Sudhakar <anju@linux.vnet.ibm.com>
> [Decide extended mask at run time based on platform]
> Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
> Reviewed-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> ---
>  tools/arch/powerpc/include/uapi/asm/perf_regs.h | 14 ++++++-
>  tools/perf/arch/powerpc/include/perf_regs.h     |  5 ++-
>  tools/perf/arch/powerpc/util/header.c           |  9 +----
>  tools/perf/arch/powerpc/util/perf_regs.c        | 49 +++++++++++++++++++++++++
>  tools/perf/arch/powerpc/util/utils_header.h     | 15 ++++++++
>  5 files changed, 82 insertions(+), 10 deletions(-)
>  create mode 100644 tools/perf/arch/powerpc/util/utils_header.h
> 


Reviewed-by: Kajol Jain <kjain@linux.ibm.com>

Thanks,
Kajol Jain

> diff --git a/tools/arch/powerpc/include/uapi/asm/perf_regs.h b/tools/arch/powerpc/include/uapi/asm/perf_regs.h
> index f599064..225c64c 100644
> --- a/tools/arch/powerpc/include/uapi/asm/perf_regs.h
> +++ b/tools/arch/powerpc/include/uapi/asm/perf_regs.h
> @@ -48,6 +48,18 @@ enum perf_event_powerpc_regs {
>  	PERF_REG_POWERPC_DSISR,
>  	PERF_REG_POWERPC_SIER,
>  	PERF_REG_POWERPC_MMCRA,
> -	PERF_REG_POWERPC_MAX,
> +	/* Extended registers */
> +	PERF_REG_POWERPC_MMCR0,
> +	PERF_REG_POWERPC_MMCR1,
> +	PERF_REG_POWERPC_MMCR2,
> +	/* Max regs without the extended regs */
> +	PERF_REG_POWERPC_MAX = PERF_REG_POWERPC_MMCRA + 1,
>  };
> +
> +#define PERF_REG_PMU_MASK	((1ULL << PERF_REG_POWERPC_MAX) - 1)
> +
> +/* PERF_REG_EXTENDED_MASK value for CPU_FTR_ARCH_300 */
> +#define PERF_REG_PMU_MASK_300   (((1ULL << (PERF_REG_POWERPC_MMCR2 + 1)) - 1) - PERF_REG_PMU_MASK)
> +
> +#define PERF_REG_MAX_ISA_300   (PERF_REG_POWERPC_MMCR2 + 1)
>  #endif /* _UAPI_ASM_POWERPC_PERF_REGS_H */
> diff --git a/tools/perf/arch/powerpc/include/perf_regs.h b/tools/perf/arch/powerpc/include/perf_regs.h
> index e18a355..46ed00d 100644
> --- a/tools/perf/arch/powerpc/include/perf_regs.h
> +++ b/tools/perf/arch/powerpc/include/perf_regs.h
> @@ -64,7 +64,10 @@
>  	[PERF_REG_POWERPC_DAR] = "dar",
>  	[PERF_REG_POWERPC_DSISR] = "dsisr",
>  	[PERF_REG_POWERPC_SIER] = "sier",
> -	[PERF_REG_POWERPC_MMCRA] = "mmcra"
> +	[PERF_REG_POWERPC_MMCRA] = "mmcra",
> +	[PERF_REG_POWERPC_MMCR0] = "mmcr0",
> +	[PERF_REG_POWERPC_MMCR1] = "mmcr1",
> +	[PERF_REG_POWERPC_MMCR2] = "mmcr2",
>  };
>  
>  static inline const char *perf_reg_name(int id)
> diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
> index d487007..1a95017 100644
> --- a/tools/perf/arch/powerpc/util/header.c
> +++ b/tools/perf/arch/powerpc/util/header.c
> @@ -7,17 +7,10 @@
>  #include <string.h>
>  #include <linux/stringify.h>
>  #include "header.h"
> +#include "utils_header.h"
>  #include "metricgroup.h"
>  #include <api/fs/fs.h>
>  
> -#define mfspr(rn)       ({unsigned long rval; \
> -			 asm volatile("mfspr %0," __stringify(rn) \
> -				      : "=r" (rval)); rval; })
> -
> -#define SPRN_PVR        0x11F	/* Processor Version Register */
> -#define PVR_VER(pvr)    (((pvr) >>  16) & 0xFFFF) /* Version field */
> -#define PVR_REV(pvr)    (((pvr) >>   0) & 0xFFFF) /* Revison field */
> -
>  int
>  get_cpuid(char *buffer, size_t sz)
>  {
> diff --git a/tools/perf/arch/powerpc/util/perf_regs.c b/tools/perf/arch/powerpc/util/perf_regs.c
> index 0a52429..d64ba0c 100644
> --- a/tools/perf/arch/powerpc/util/perf_regs.c
> +++ b/tools/perf/arch/powerpc/util/perf_regs.c
> @@ -6,9 +6,15 @@
>  
>  #include "../../../util/perf_regs.h"
>  #include "../../../util/debug.h"
> +#include "../../../util/event.h"
> +#include "../../../util/header.h"
> +#include "../../../perf-sys.h"
> +#include "utils_header.h"
>  
>  #include <linux/kernel.h>
>  
> +#define PVR_POWER9		0x004E
> +
>  const struct sample_reg sample_reg_masks[] = {
>  	SMPL_REG(r0, PERF_REG_POWERPC_R0),
>  	SMPL_REG(r1, PERF_REG_POWERPC_R1),
> @@ -55,6 +61,9 @@
>  	SMPL_REG(dsisr, PERF_REG_POWERPC_DSISR),
>  	SMPL_REG(sier, PERF_REG_POWERPC_SIER),
>  	SMPL_REG(mmcra, PERF_REG_POWERPC_MMCRA),
> +	SMPL_REG(mmcr0, PERF_REG_POWERPC_MMCR0),
> +	SMPL_REG(mmcr1, PERF_REG_POWERPC_MMCR1),
> +	SMPL_REG(mmcr2, PERF_REG_POWERPC_MMCR2),
>  	SMPL_REG_END
>  };
>  
> @@ -163,3 +172,43 @@ int arch_sdt_arg_parse_op(char *old_op, char **new_op)
>  
>  	return SDT_ARG_VALID;
>  }
> +
> +uint64_t arch__intr_reg_mask(void)
> +{
> +	struct perf_event_attr attr = {
> +		.type                   = PERF_TYPE_HARDWARE,
> +		.config                 = PERF_COUNT_HW_CPU_CYCLES,
> +		.sample_type            = PERF_SAMPLE_REGS_INTR,
> +		.precise_ip             = 1,
> +		.disabled               = 1,
> +		.exclude_kernel         = 1,
> +	};
> +	int fd;
> +	u32 version;
> +	u64 extended_mask = 0, mask = PERF_REGS_MASK;
> +
> +	/*
> +	 * Get the PVR value to set the extended
> +	 * mask specific to platform.
> +	 */
> +	version = (((mfspr(SPRN_PVR)) >>  16) & 0xFFFF);
> +	if (version == PVR_POWER9)
> +		extended_mask = PERF_REG_PMU_MASK_300;
> +	else
> +		return mask;
> +
> +	attr.sample_regs_intr = extended_mask;
> +	attr.sample_period = 1;
> +	event_attr_init(&attr);
> +
> +	/*
> +	 * check if the pmu supports perf extended regs, before
> +	 * returning the register mask to sample.
> +	 */
> +	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> +	if (fd != -1) {
> +		close(fd);
> +		mask |= extended_mask;
> +	}
> +	return mask;
> +}
> diff --git a/tools/perf/arch/powerpc/util/utils_header.h b/tools/perf/arch/powerpc/util/utils_header.h
> new file mode 100644
> index 0000000..5788eb1
> --- /dev/null
> +++ b/tools/perf/arch/powerpc/util/utils_header.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __PERF_UTIL_HEADER_H
> +#define __PERF_UTIL_HEADER_H
> +
> +#include <linux/stringify.h>
> +
> +#define mfspr(rn)       ({unsigned long rval; \
> +			asm volatile("mfspr %0," __stringify(rn) \
> +				: "=r" (rval)); rval; })
> +
> +#define SPRN_PVR        0x11F   /* Processor Version Register */
> +#define PVR_VER(pvr)    (((pvr) >>  16) & 0xFFFF) /* Version field */
> +#define PVR_REV(pvr)    (((pvr) >>   0) & 0xFFFF) /* Revison field */
> +
> +#endif /* __PERF_UTIL_HEADER_H */
> 
