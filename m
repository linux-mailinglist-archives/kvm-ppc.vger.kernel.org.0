Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9939B62757
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 19:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388867AbfGHRiM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 13:38:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49468 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729329AbfGHRiM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 13:38:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68Hc14M008361;
        Mon, 8 Jul 2019 13:38:08 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tm8gmcac0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 13:38:08 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x68HXprM023048;
        Mon, 8 Jul 2019 17:37:43 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk967pp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 17:37:43 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68HbfCa52691396
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 17:37:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8A53136055;
        Mon,  8 Jul 2019 17:37:41 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 493E2136053;
        Mon,  8 Jul 2019 17:37:41 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 17:37:41 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jul 2019 12:40:06 -0500
From:   janani <janani@linux.ibm.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: Re: [PATCH v4 2/8] powerpc: Introduce FW_FEATURE_ULTRAVISOR
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190628200825.31049-3-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-3-cclaudio@linux.ibm.com>
Message-ID: <c585a5370f578d2ce7322eebf0496265@linux.vnet.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080217
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-06-28 15:08, Claudio Carvalho wrote:
> This feature tells if the ultravisor firmware is available to handle
> ucalls.
> 
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> [ Device node name to "ibm,ultravisor" ]
> Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/firmware.h   |  5 +++--
>  arch/powerpc/include/asm/ultravisor.h | 15 +++++++++++++++
>  arch/powerpc/kernel/Makefile          |  1 +
>  arch/powerpc/kernel/prom.c            |  4 ++++
>  arch/powerpc/kernel/ultravisor.c      | 24 ++++++++++++++++++++++++
>  5 files changed, 47 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/ultravisor.h
>  create mode 100644 arch/powerpc/kernel/ultravisor.c
> 
> diff --git a/arch/powerpc/include/asm/firmware.h
> b/arch/powerpc/include/asm/firmware.h
> index 00bc42d95679..43b48c4d3ca9 100644
> --- a/arch/powerpc/include/asm/firmware.h
> +++ b/arch/powerpc/include/asm/firmware.h
> @@ -54,6 +54,7 @@
>  #define FW_FEATURE_DRC_INFO	ASM_CONST(0x0000000800000000)
>  #define FW_FEATURE_BLOCK_REMOVE ASM_CONST(0x0000001000000000)
>  #define FW_FEATURE_PAPR_SCM 	ASM_CONST(0x0000002000000000)
> +#define FW_FEATURE_ULTRAVISOR	ASM_CONST(0x0000004000000000)
> 
>  #ifndef __ASSEMBLY__
> 
> @@ -72,9 +73,9 @@ enum {
>  		FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
>  		FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
>  		FW_FEATURE_DRC_INFO | FW_FEATURE_BLOCK_REMOVE |
> -		FW_FEATURE_PAPR_SCM,
> +		FW_FEATURE_PAPR_SCM | FW_FEATURE_ULTRAVISOR,
>  	FW_FEATURE_PSERIES_ALWAYS = 0,
> -	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL,
> +	FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL | 
> FW_FEATURE_ULTRAVISOR,
>  	FW_FEATURE_POWERNV_ALWAYS = 0,
>  	FW_FEATURE_PS3_POSSIBLE = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
>  	FW_FEATURE_PS3_ALWAYS = FW_FEATURE_LPAR | FW_FEATURE_PS3_LV1,
> diff --git a/arch/powerpc/include/asm/ultravisor.h
> b/arch/powerpc/include/asm/ultravisor.h
> new file mode 100644
> index 000000000000..e5009b0d84ea
> --- /dev/null
> +++ b/arch/powerpc/include/asm/ultravisor.h
> @@ -0,0 +1,15 @@
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
> +/* Internal functions */
> +extern int early_init_dt_scan_ultravisor(unsigned long node, const 
> char *uname,
> +					 int depth, void *data);
> +
> +#endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> diff --git a/arch/powerpc/kernel/Makefile 
> b/arch/powerpc/kernel/Makefile
> index 0ea6c4aa3a20..f0caa302c8c0 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -154,6 +154,7 @@ endif
> 
>  obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
>  obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
> +obj-$(CONFIG_PPC_POWERNV)	+= ultravisor.o
> 
>  # Disable GCOV, KCOV & sanitizers in odd or sensitive code
>  GCOV_PROFILE_prom_init.o := n
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 4221527b082f..67a2c1b39252 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -59,6 +59,7 @@
>  #include <asm/firmware.h>
>  #include <asm/dt_cpu_ftrs.h>
>  #include <asm/drmem.h>
> +#include <asm/ultravisor.h>
> 
>  #include <mm/mmu_decl.h>
> 
> @@ -706,6 +707,9 @@ void __init early_init_devtree(void *params)
>  #ifdef CONFIG_PPC_POWERNV
>  	/* Some machines might need OPAL info for debugging, grab it now. */
>  	of_scan_flat_dt(early_init_dt_scan_opal, NULL);
> +
> +	/* Scan tree for ultravisor feature */
> +	of_scan_flat_dt(early_init_dt_scan_ultravisor, NULL);
>  #endif
> 
>  #ifdef CONFIG_FA_DUMP
> diff --git a/arch/powerpc/kernel/ultravisor.c 
> b/arch/powerpc/kernel/ultravisor.c
> new file mode 100644
> index 000000000000..dc6021f63c97
> --- /dev/null
> +++ b/arch/powerpc/kernel/ultravisor.c
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
> +#include <linux/string.h>
> +
> +#include <asm/ultravisor.h>
> +#include <asm/firmware.h>
> +
> +int __init early_init_dt_scan_ultravisor(unsigned long node, const 
> char *uname,
> +					 int depth, void *data)
> +{
> +	if (depth != 1 || strcmp(uname, "ibm,ultravisor") != 0)
> +		return 0;
> +
> +	powerpc_firmware_features |= FW_FEATURE_ULTRAVISOR;
> +	pr_debug("Ultravisor detected!\n");
> +	return 1;
> +}
