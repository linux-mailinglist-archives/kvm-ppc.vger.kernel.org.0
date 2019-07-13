Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23167B89
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 Jul 2019 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfGMRmY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 13 Jul 2019 13:42:24 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727818AbfGMRmY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 13 Jul 2019 13:42:24 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6DHfQkd144188
        for <kvm-ppc@vger.kernel.org>; Sat, 13 Jul 2019 13:42:23 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tqbedv7bp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sat, 13 Jul 2019 13:42:22 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Sat, 13 Jul 2019 18:42:22 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 13 Jul 2019 18:42:20 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6DHgJPw37355814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Jul 2019 17:42:19 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47F39112061;
        Sat, 13 Jul 2019 17:42:19 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E506112064;
        Sat, 13 Jul 2019 17:42:16 +0000 (GMT)
Received: from [9.85.164.240] (unknown [9.85.164.240])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 13 Jul 2019 17:42:16 +0000 (GMT)
Subject: Re: [PATCH v4 3/8] KVM: PPC: Ultravisor: Add generic ultravisor call
 handler
To:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-4-cclaudio@linux.ibm.com>
 <87lfx4g253.fsf@concordia.ellerman.id.au>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Sat, 13 Jul 2019 14:42:15 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <87lfx4g253.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19071317-0064-0000-0000-000003FB578C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011422; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01231667; UDB=6.00648845; IPR=6.01012960;
 MB=3.00027705; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-13 17:42:22
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071317-0065-0000-0000-00003E3F986C
Message-Id: <45cb74bc-442c-e1c5-6636-93e9ab7f323a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907130216
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 7/11/19 9:57 AM, Michael Ellerman wrote:
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> From: Ram Pai <linuxram@us.ibm.com>
>>
>> Add the ucall() function, which can be used to make ultravisor calls
>> with varied number of in and out arguments. Ultravisor calls can be made
>> from the host or guests.
>>
>> This copies the implementation of plpar_hcall().
> .. with quite a few changes?
>
> This is one of the things I'd like to see in a Documentation file, so
> that people can review the implementation vs the specification.

I will document this (and other things) in a file under Documentation/powerpc.


>
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> [ Change ucall.S to not save CR, rename and move headers, build ucall.S
>>   if CONFIG_PPC_POWERNV set, use R3 for the ucall number and add some
>>   comments in the code ]
> Why are we not saving CR? See previous comment about Documentation :)
>
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> ---
>>  arch/powerpc/include/asm/ultravisor-api.h | 20 +++++++++++++++
>>  arch/powerpc/include/asm/ultravisor.h     | 20 +++++++++++++++
>>  arch/powerpc/kernel/Makefile              |  2 +-
>>  arch/powerpc/kernel/ucall.S               | 30 +++++++++++++++++++++++
>>  arch/powerpc/kernel/ultravisor.c          |  4 +++
>>  5 files changed, 75 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/powerpc/include/asm/ultravisor-api.h
>>  create mode 100644 arch/powerpc/kernel/ucall.S
>>
>> diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
>> new file mode 100644
>> index 000000000000..49e766adabc7
>> --- /dev/null
>> +++ b/arch/powerpc/include/asm/ultravisor-api.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Ultravisor API.
>> + *
>> + * Copyright 2019, IBM Corporation.
>> + *
>> + */
>> +#ifndef _ASM_POWERPC_ULTRAVISOR_API_H
>> +#define _ASM_POWERPC_ULTRAVISOR_API_H
>> +
>> +#include <asm/hvcall.h>
>> +
>> +/* Return codes */
>> +#define U_NOT_AVAILABLE		H_NOT_AVAILABLE
>> +#define U_SUCCESS		H_SUCCESS
>> +#define U_FUNCTION		H_FUNCTION
>> +#define U_PARAMETER		H_PARAMETER
> Is there any benefit in redefining these?
>
>> diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
>> index e5009b0d84ea..a78a2dacfd0b 100644
>> --- a/arch/powerpc/include/asm/ultravisor.h
>> +++ b/arch/powerpc/include/asm/ultravisor.h
>> @@ -8,8 +8,28 @@
>>  #ifndef _ASM_POWERPC_ULTRAVISOR_H
>>  #define _ASM_POWERPC_ULTRAVISOR_H
>>  
>> +#include <asm/ultravisor-api.h>
>> +
>> +#if !defined(__ASSEMBLY__)
> Just #ifndef is fine.
>
>>  /* Internal functions */
> How is it internal?
>
>>  extern int early_init_dt_scan_ultravisor(unsigned long node, const char *uname,
>>  					 int depth, void *data);
>>  
>> +/* API functions */
>> +#define UCALL_BUFSIZE 4
> Please don't copy this design from the hcall code, it has led to bugs in
> the past.
>
> See my (still unmerged) attempt to fix this for the hcall case:
>   https://patchwork.ozlabs.org/patch/683577/
>
> Basically instead of asking callers nicely to define a certain sized
> buffer, and them forgetting, define a proper type that has the right size.

I will keep that in mind. For now I think we don't need that since the v5
will have ucall_norets() instead.


>
>> +/**
>> + * ucall: Make a powerpc ultravisor call.
>> + * @opcode: The ultravisor call to make.
>> + * @retbuf: Buffer to store up to 4 return arguments in.
>> + *
>> + * This call supports up to 6 arguments and 4 return arguments. Use
>> + * UCALL_BUFSIZE to size the return argument buffer.
>> + */
>> +#if defined(CONFIG_PPC_POWERNV)
> #ifdef
>
>> +long ucall(unsigned long opcode, unsigned long *retbuf, ...);
>> +#endif
>> +
>> +#endif /* !__ASSEMBLY__ */
>> +
>>  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
>> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
>> index f0caa302c8c0..f28baccc0a79 100644
>> --- a/arch/powerpc/kernel/Makefile
>> +++ b/arch/powerpc/kernel/Makefile
>> @@ -154,7 +154,7 @@ endif
>>  
>>  obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
>>  obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
>> -obj-$(CONFIG_PPC_POWERNV)	+= ultravisor.o
>> +obj-$(CONFIG_PPC_POWERNV)	+= ultravisor.o ucall.o
> Same comment about being platforms/powernv ?
>> diff --git a/arch/powerpc/kernel/ucall.S b/arch/powerpc/kernel/ucall.S
>> new file mode 100644
>> index 000000000000..1678f6eb7230
>> --- /dev/null
>> +++ b/arch/powerpc/kernel/ucall.S
>> @@ -0,0 +1,30 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Generic code to perform an ultravisor call.
>> + *
>> + * Copyright 2019, IBM Corporation.
>> + *
>> + */
>> +#include <asm/ppc_asm.h>
>> +
>> +/*
>> + * This function is based on the plpar_hcall()
> I don't think it meaningfully is any more.
>
>> + */
>> +_GLOBAL_TOC(ucall)
> You don't need the TOC setup here (unless a later patch does?).
>
>> +	std	r4,STK_PARAM(R4)(r1)	/* Save ret buffer */
>> +	mr	r4,r5
>> +	mr	r5,r6
>> +	mr	r6,r7
>> +	mr	r7,r8
>> +	mr	r8,r9
>> +	mr	r9,r10
> Below you space the arguments, here you don't. Pick one or the other please.
>
>> +
>> +	sc 2				/* Invoke the ultravisor */
>> +
>> +	ld	r12,STK_PARAM(R4)(r1)
>> +	std	r4,  0(r12)
>> +	std	r5,  8(r12)
>> +	std	r6, 16(r12)
>> +	std	r7, 24(r12)
>> +
>> +	blr				/* Return r3 = status */
>> diff --git a/arch/powerpc/kernel/ultravisor.c b/arch/powerpc/kernel/ultravisor.c
>> index dc6021f63c97..02ddf79a9522 100644
>> --- a/arch/powerpc/kernel/ultravisor.c
>> +++ b/arch/powerpc/kernel/ultravisor.c
>> @@ -8,10 +8,14 @@
>>  #include <linux/init.h>
>>  #include <linux/printk.h>
>>  #include <linux/string.h>
>> +#include <linux/export.h>
>>  
>>  #include <asm/ultravisor.h>
>>  #include <asm/firmware.h>
>>  
>> +/* in ucall.S */
>> +EXPORT_SYMBOL_GPL(ucall);
> This should be in ucall.S

Here I'm following the same way that hypercall wrapper symbols are exported.

Last time I tried to export that in ucall.S the linker complained that the
ucall
symbol will not be versioned. Something like this:
https://patchwork.kernel.org/patch/9452759/

Thanks,
Claudio


>
> cheers

