Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910D739FCB6
	for <lists+kvm-ppc@lfdr.de>; Tue,  8 Jun 2021 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhFHQop (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 8 Jun 2021 12:44:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52416 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231175AbhFHQoo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 8 Jun 2021 12:44:44 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158GY0rk006920;
        Tue, 8 Jun 2021 12:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uIRneLB8M7KXaxftjlBSl+nZRsvZ9p/uH4+eSNpr6X8=;
 b=JgUHuf8TYvI9Oo0VNY83CPUoUtH1ow/Pgcvr9f0oilNkFRSAnQOlYsQ2t+tILFDnH+VK
 I33YQ72PBjXI1rW5Cmd+uH4CBlg2mtZCaPkEXQSJ54AEdzEj+NPCjeLVYreVmhmWjKEF
 /rUP+VoOl6rKLC+vn/e4YG83S6bpAaykEzh2/l+uTk55XPF5MP2fmcKAzknWZiOJKXUF
 ZcqpPYuRn2ti4ZFinvjyTv+IPUB42nNKJbNgaOOVlREVz6zJ0xfyhbgeqzjqxdWGDF/a
 oLeH0Bnt5qNcqBZ2NnW6+Ejho1t39s8kuCplm+voK218NxyQV8vL9hw2JL7pE2tUcbd5 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392bgshhan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 12:42:27 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158GZbWT012385;
        Tue, 8 Jun 2021 12:42:27 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 392bgshh9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 12:42:26 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 158GgPCL008859;
        Tue, 8 Jun 2021 16:42:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3900w89nax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 16:42:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 158GgM4j32243976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Jun 2021 16:42:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEFDC11C05C;
        Tue,  8 Jun 2021 16:42:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C922911C050;
        Tue,  8 Jun 2021 16:42:20 +0000 (GMT)
Received: from [9.79.220.127] (unknown [9.79.220.127])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Jun 2021 16:42:20 +0000 (GMT)
Subject: Re: [RFC] powerpc/pseries: Interface to represent PAPR firmware
 attributes
To:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, pratik.r.sampat@gmail.com,
        Pratik Sampat <psampat@linux.ibm.com>
References: <20210604163501.51511-1-psampat@linux.ibm.com>
From:   Pratik Sampat <psampat@linux.ibm.com>
Message-ID: <d6a949c3-73bf-7aa2-f738-a68e4130fc0b@linux.ibm.com>
Date:   Tue, 8 Jun 2021 22:12:19 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210604163501.51511-1-psampat@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DqaEFSftNI3hKLD8sCWbMdgVA0ywJC9I
X-Proofpoint-GUID: XTezsEkoPq1acwEcH2pjHdPhqucfqjhZ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_11:2021-06-04,2021-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 bulkscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106080106
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I've implemented a POC using this interface for the powerpc-utils'
ppc64_cpu --frequency command-line tool to utilize this information
in userspace.

The POC has been hosted here:
https://github.com/pratiksampat/powerpc-utils/tree/H_GET_ENERGY_SCALE_INFO
and based on comments I suggestions I can further improve the
parsing logic from this initial implementation.

Sample output from the powerpc-utils tool is as follows:

# ppc64_cpu --frequency
Power and Performance Mode: XXXX
Idle Power Saver Status   : XXXX
Processor Folding Status  : XXXX --> Printed if Idle power save status is supported

Platform reported frequencies --> Frequencies reported from the platform's H_CALL i.e PAPR interface
min        :    NNNN GHz
max        :    NNNN GHz
static     :    NNNN GHz

Tool Computed frequencies
min        :    NNNN GHz (cpu XX)
max        :    NNNN GHz (cpu XX)
avg        :    NNNN GHz


On 04/06/21 10:05 pm, Pratik R. Sampat wrote:
> Adds a generic interface to represent the energy and frequency related
> PAPR attributes on the system using the new H_CALL
> "H_GET_ENERGY_SCALE_INFO".
>
> H_GET_EM_PARMS H_CALL was previously responsible for exporting this
> information in the lparcfg, however the H_GET_EM_PARMS H_CALL
> will be deprecated P10 onwards.
>
> The H_GET_ENERGY_SCALE_INFO H_CALL is of the following call format:
> hcall(
>    uint64 H_GET_ENERGY_SCALE_INFO,  // Get energy scale info
>    uint64 flags,           // Per the flag request
>    uint64 firstAttributeId,// The attribute id
>    uint64 bufferAddress,   // The logical address of the output buffer
>    uint64 bufferSize       // The size in bytes of the output buffer
> );
>
> This H_CALL can query either all the attributes at once with
> firstAttributeId = 0, flags = 0 as well as query only one attribute
> at a time with firstAttributeId = id
>
> The output buffer consists of the following
> 1. number of attributes              - 8 bytes
> 2. array offset to the data location - 8 bytes
> 3. version info                      - 1 byte
> 4. A data array of size num attributes, which contains the following:
>    a. attribute ID              - 8 bytes
>    b. attribute value in number - 8 bytes
>    c. attribute name in string  - 64 bytes
>    d. attribute value in string - 64 bytes
>
> The new H_CALL exports information in direct string value format, hence
> a new interface has been introduced in /sys/firmware/papr to export
> this information to userspace in an extensible pass-through format.
> The H_CALL returns the name, numeric value and string value. As string
> values are in human readable format, therefore if the string value
> exists then that is given precedence over the numeric value.
>
> The format of exposing the sysfs information is as follows:
> /sys/firmware/papr/
>    |-- attr_0_name
>    |-- attr_0_val
>    |-- attr_1_name
>    |-- attr_1_val
> ...
>
> The energy information that is exported is useful for userspace tools
> such as powerpc-utils. Currently these tools infer the
> "power_mode_data" value in the lparcfg, which in turn is obtained from
> the to be deprecated H_GET_EM_PARMS H_CALL.
> On future platforms, such userspace utilities will have to look at the
> data returned from the new H_CALL being populated in this new sysfs
> interface and report this information directly without the need of
> interpretation.
>
> Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
> ---
>   Documentation/ABI/testing/sysfs-firmware-papr |  24 +++
>   arch/powerpc/include/asm/hvcall.h             |  21 +-
>   arch/powerpc/kvm/trace_hv.h                   |   1 +
>   arch/powerpc/platforms/pseries/Makefile       |   3 +-
>   .../pseries/papr_platform_attributes.c        | 203 ++++++++++++++++++
>   5 files changed, 250 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-firmware-papr
>   create mode 100644 arch/powerpc/platforms/pseries/papr_platform_attributes.c
>
> diff --git a/Documentation/ABI/testing/sysfs-firmware-papr b/Documentation/ABI/testing/sysfs-firmware-papr
> new file mode 100644
> index 000000000000..1c040b44ac3b
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-papr
> @@ -0,0 +1,24 @@
> +What:		/sys/firmware/papr
> +Date:		June 2021
> +Contact:	Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
> +Description :	Director hosting a set of platform attributes on Linux
> +		running as a PAPR guest.
> +
> +		Each file in a directory contains a platform
> +		attribute pertaining to performance/energy-savings
> +		mode and processor frequency.
> +
> +What:		/sys/firmware/papr/attr_X_name
> +		/sys/firmware/papr/attr_X_val
> +Date:		June 2021
> +Contact:	Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
> +Description:	PAPR attributes directory for POWERVM servers
> +
> +		This directory provides PAPR information. It
> +		contains below sysfs attributes:
> +
> +		- attr_X_name: File contains the name of
> +		attribute X
> +
> +		- attr_X_val: Numeric/string value of
> +		attribute X
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> index e3b29eda8074..19a2a8c77a49 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -316,7 +316,8 @@
>   #define H_SCM_PERFORMANCE_STATS 0x418
>   #define H_RPT_INVALIDATE	0x448
>   #define H_SCM_FLUSH		0x44C
> -#define MAX_HCALL_OPCODE	H_SCM_FLUSH
> +#define H_GET_ENERGY_SCALE_INFO	0x450
> +#define MAX_HCALL_OPCODE	H_GET_ENERGY_SCALE_INFO
>   
>   /* Scope args for H_SCM_UNBIND_ALL */
>   #define H_UNBIND_SCOPE_ALL (0x1)
> @@ -631,6 +632,24 @@ struct hv_gpci_request_buffer {
>   	uint8_t bytes[HGPCI_MAX_DATA_BYTES];
>   } __packed;
>   
> +#define MAX_EM_ATTRS	10
> +#define MAX_EM_DATA_BYTES \
> +	(sizeof(struct energy_scale_attributes) * MAX_EM_ATTRS)
> +struct energy_scale_attributes {
> +	__be64 attr_id;
> +	__be64 attr_value;
> +	unsigned char attr_desc[64];
> +	unsigned char attr_value_desc[64];
> +} __packed;
> +
> +struct hv_energy_scale_buffer {
> +	__be64 num_attr;
> +	__be64 array_offset;
> +	__u8 data_header_version;
> +	unsigned char data[MAX_EM_DATA_BYTES];
> +} __packed;
> +
> +
>   #endif /* __ASSEMBLY__ */
>   #endif /* __KERNEL__ */
>   #endif /* _ASM_POWERPC_HVCALL_H */
> diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
> index 830a126e095d..38cd0ed0a617 100644
> --- a/arch/powerpc/kvm/trace_hv.h
> +++ b/arch/powerpc/kvm/trace_hv.h
> @@ -115,6 +115,7 @@
>   	{H_VASI_STATE,			"H_VASI_STATE"}, \
>   	{H_ENABLE_CRQ,			"H_ENABLE_CRQ"}, \
>   	{H_GET_EM_PARMS,		"H_GET_EM_PARMS"}, \
> +	{H_GET_ENERGY_SCALE_INFO,	"H_GET_ENERGY_SCALE_INFO"}, \
>   	{H_SET_MPP,			"H_SET_MPP"}, \
>   	{H_GET_MPP,			"H_GET_MPP"}, \
>   	{H_HOME_NODE_ASSOCIATIVITY,	"H_HOME_NODE_ASSOCIATIVITY"}, \
> diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
> index c8a2b0b05ac0..d14fca89ac25 100644
> --- a/arch/powerpc/platforms/pseries/Makefile
> +++ b/arch/powerpc/platforms/pseries/Makefile
> @@ -6,7 +6,8 @@ obj-y			:= lpar.o hvCall.o nvram.o reconfig.o \
>   			   of_helpers.o \
>   			   setup.o iommu.o event_sources.o ras.o \
>   			   firmware.o power.o dlpar.o mobility.o rng.o \
> -			   pci.o pci_dlpar.o eeh_pseries.o msi.o
> +			   pci.o pci_dlpar.o eeh_pseries.o msi.o \
> +			   papr_platform_attributes.o
>   obj-$(CONFIG_SMP)	+= smp.o
>   obj-$(CONFIG_SCANLOG)	+= scanlog.o
>   obj-$(CONFIG_KEXEC_CORE)	+= kexec.o
> diff --git a/arch/powerpc/platforms/pseries/papr_platform_attributes.c b/arch/powerpc/platforms/pseries/papr_platform_attributes.c
> new file mode 100644
> index 000000000000..8818877ff47e
> --- /dev/null
> +++ b/arch/powerpc/platforms/pseries/papr_platform_attributes.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * PowerPC64 LPAR PAPR Information Driver
> + *
> + * This driver creates a sys file at /sys/firmware/papr/ which contains
> + * files keyword - value pairs that specify energy configuration of the system.
> + *
> + * Copyright 2021 IBM Corp.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/hugetlb.h>
> +#include <asm/lppaca.h>
> +#include <asm/hvcall.h>
> +#include <asm/firmware.h>
> +#include <asm/time.h>
> +#include <asm/prom.h>
> +#include <asm/vdso_datapage.h>
> +#include <asm/vio.h>
> +#include <asm/mmu.h>
> +#include <asm/machdep.h>
> +#include <asm/drmem.h>
> +
> +#include "pseries.h"
> +
> +#define MAX_KOBJ_ATTRS	2
> +
> +struct papr_attr {
> +	u64 id;
> +	struct kobj_attribute attr;
> +} *pgattrs;
> +
> +struct kobject *papr_kobj;
> +struct hv_energy_scale_buffer *em_buf;
> +struct energy_scale_attributes *ea;
> +
> +static ssize_t papr_show_name(struct kobject *kobj,
> +			       struct kobj_attribute *attr,
> +			       char *buf)
> +{
> +	struct papr_attr *pattr = container_of(attr, struct papr_attr, attr);
> +	int idx, ret = 0;
> +
> +	/*
> +	 * We do not expect the name to change, hence use the old value
> +	 * and save a HCALL
> +	 */
> +	for (idx = 0; idx < be64_to_cpu(em_buf->num_attr); idx++) {
> +		if (pattr->id == be64_to_cpu(ea[idx].attr_id)) {
> +			ret = sprintf(buf, "%s\n", ea[idx].attr_desc);
> +			if (ret < 0)
> +				ret = -EIO;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static ssize_t papr_show_val(struct kobject *kobj,
> +			      struct kobj_attribute *attr,
> +			      char *buf)
> +{
> +	struct papr_attr *pattr = container_of(attr, struct papr_attr, attr);
> +	struct hv_energy_scale_buffer *t_buf;
> +	struct energy_scale_attributes *t_ea;
> +	int data_offset, ret = 0;
> +
> +	t_buf = kmalloc(sizeof(*t_buf), GFP_KERNEL);
> +	if (t_buf == NULL)
> +		return -ENOMEM;
> +
> +	ret = plpar_hcall_norets(H_GET_ENERGY_SCALE_INFO, 0,
> +				 pattr->id, virt_to_phys(t_buf),
> +				 sizeof(*t_buf));
> +
> +	if (ret != H_SUCCESS) {
> +		pr_warn("hcall faiiled: H_GET_ENERGY_SCALE_INFO");
> +		goto out;
> +	}
> +
> +	data_offset = be64_to_cpu(t_buf->array_offset) -
> +			(sizeof(t_buf->num_attr) +
> +			sizeof(t_buf->array_offset) +
> +			sizeof(t_buf->data_header_version));
> +
> +	t_ea = (struct energy_scale_attributes *) &t_buf->data[data_offset];
> +
> +	/* Prioritize string values over numerical */
> +	if (strlen(t_ea->attr_value_desc) != 0)
> +		ret = sprintf(buf, "%s\n", t_ea->attr_value_desc);
> +	else
> +		ret = sprintf(buf, "%llu\n", be64_to_cpu(t_ea->attr_value));
> +	if (ret < 0)
> +		ret = -EIO;
> +out:
> +	kfree(t_buf);
> +	return ret;
> +}
> +
> +static struct papr_ops_info {
> +	const char *attr_name;
> +	ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
> +			char *buf);
> +} ops_info[MAX_KOBJ_ATTRS] = {
> +	{ "name", papr_show_name },
> +	{ "val", papr_show_val },
> +};
> +
> +static int __init papr_init(void)
> +{
> +	uint64_t num_attr;
> +	int ret, idx, i, data_offset;
> +
> +	em_buf = kmalloc(sizeof(*em_buf), GFP_KERNEL);
> +	if (em_buf == NULL)
> +		return -ENOMEM;
> +	/*
> +	 * hcall(
> +	 * uint64 H_GET_ENERGY_SCALE_INFO,  // Get energy scale info
> +	 * uint64 flags,            // Per the flag request
> +	 * uint64 firstAttributeId, // The attribute id
> +	 * uint64 bufferAddress,    // The logical address of the output buffer
> +	 * uint64 bufferSize);	    // The size in bytes of the output buffer
> +	 */
> +	ret = plpar_hcall_norets(H_GET_ENERGY_SCALE_INFO, 0, 0,
> +				 virt_to_phys(em_buf), sizeof(*em_buf));
> +
> +	if (!firmware_has_feature(FW_FEATURE_LPAR) || ret != H_SUCCESS ||
> +	    em_buf->data_header_version != 0x1) {
> +		pr_warn("hcall faiiled: H_GET_ENERGY_SCALE_INFO");
> +		goto out;
> +	}
> +
> +	num_attr = be64_to_cpu(em_buf->num_attr);
> +
> +	/*
> +	 * Typecast the energy buffer to the attribute structure at the offset
> +	 * specified in the buffer
> +	 */
> +	data_offset = be64_to_cpu(em_buf->array_offset) -
> +			(sizeof(em_buf->num_attr) +
> +			sizeof(em_buf->array_offset) +
> +			sizeof(em_buf->data_header_version));
> +
> +	ea = (struct energy_scale_attributes *) &em_buf->data[data_offset];
> +
> +	papr_kobj = kobject_create_and_add("papr", firmware_kobj);
> +	if (!papr_kobj) {
> +		pr_warn("kobject_create_and_add papr failed\n");
> +		goto out_kobj;
> +	}
> +
> +	for (idx = 0; idx < num_attr; idx++) {
> +		pgattrs = kcalloc(MAX_KOBJ_ATTRS,
> +				  sizeof(*pgattrs),
> +				  GFP_KERNEL);
> +		if (!pgattrs)
> +			goto out_kobj;
> +
> +		/*
> +		 * Create the sysfs attribute hierarchy for each PAPR
> +		 * property found
> +		 */
> +		for (i = 0; i < MAX_KOBJ_ATTRS; i++) {
> +			char buf[20];
> +
> +			pgattrs[i].id = be64_to_cpu(ea[idx].attr_id);
> +			sysfs_attr_init(&pgattrs[i].attr.attr);
> +			sprintf(buf, "%s_%d_%s", "attr", idx,
> +				ops_info[i].attr_name);
> +			pgattrs[i].attr.attr.name = buf;
> +			pgattrs[i].attr.attr.mode = 0444;
> +			pgattrs[i].attr.show = ops_info[i].show;
> +
> +			if (sysfs_create_file(papr_kobj, &pgattrs[i].attr.attr)) {
> +				pr_warn("Failed to create papr file %s\n",
> +					 pgattrs[i].attr.attr.name);
> +				goto out_pgattrs;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +
> +out_pgattrs:
> +	for (i = 0; i < MAX_KOBJ_ATTRS; i++)
> +		kfree(pgattrs);
> +out_kobj:
> +	kobject_put(papr_kobj);
> +out:
> +	kfree(em_buf);
> +
> +	return -ENOMEM;
> +}
> +
> +machine_device_initcall(pseries, papr_init);

