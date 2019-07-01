Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B545B489
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Jul 2019 08:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfGAGRa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Jul 2019 02:17:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726869AbfGAGRa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Jul 2019 02:17:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x616CJBO008701
        for <kvm-ppc@vger.kernel.org>; Mon, 1 Jul 2019 02:17:29 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tfc1g9yqr-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Jul 2019 02:17:28 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <maddy@linux.vnet.ibm.com>;
        Mon, 1 Jul 2019 07:17:27 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 07:17:24 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x616HMGw37486668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 06:17:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A04D75205A;
        Mon,  1 Jul 2019 06:17:22 +0000 (GMT)
Received: from [9.126.30.145] (unknown [9.126.30.145])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F18CF5204F;
        Mon,  1 Jul 2019 06:17:18 +0000 (GMT)
Subject: Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
 <f153b6bf-4661-9dc0-c28f-076fc8fe598e@ozlabs.ru>
From:   maddy <maddy@linux.vnet.ibm.com>
Date:   Mon, 1 Jul 2019 11:47:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <f153b6bf-4661-9dc0-c28f-076fc8fe598e@ozlabs.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19070106-0008-0000-0000-000002F8AA52
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070106-0009-0000-0000-00002265ED3D
Message-Id: <1e7f702a-c0cd-393d-934e-9e1a1234fe28@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010079
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 01/07/19 11:24 AM, Alexey Kardashevskiy wrote:
>
> On 29/06/2019 06:08, Claudio Carvalho wrote:
>> When the ultravisor firmware is available, it takes control over the
>> LDBAR register. In this case, thread-imc updates and save/restore
>> operations on the LDBAR register are handled by ultravisor.
> What does LDBAR do? "Power ISA™ Version 3.0 B" or "User’s Manual POWER9
> Processor" do not tell.
LDBAR is a per-thread SPR used by thread-imc pmu to dump the counter 
data into memory.
LDBAR contains memory address along with few other configuration bits 
(it is populated
by the thread-imc pmu driver). It is populated and enabled only when any 
of the thread
imc pmu events are monitored.

Maddy
>
>
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> Reviewed-by: Ram Pai <linuxram@us.ibm.com>
>> Reviewed-by: Ryan Grimm <grimm@linux.ibm.com>
>> Acked-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
>> Acked-by: Paul Mackerras <paulus@ozlabs.org>
>> ---
>>   arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 2 ++
>>   arch/powerpc/platforms/powernv/idle.c     | 6 ++++--
>>   arch/powerpc/platforms/powernv/opal-imc.c | 4 ++++
>>   3 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> index f9b2620fbecd..cffb365d9d02 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -375,8 +375,10 @@ BEGIN_FTR_SECTION
>>   	mtspr	SPRN_RPR, r0
>>   	ld	r0, KVM_SPLIT_PMMAR(r6)
>>   	mtspr	SPRN_PMMAR, r0
>> +BEGIN_FW_FTR_SECTION_NESTED(70)
>>   	ld	r0, KVM_SPLIT_LDBAR(r6)
>>   	mtspr	SPRN_LDBAR, r0
>> +END_FW_FTR_SECTION_NESTED(FW_FEATURE_ULTRAVISOR, 0, 70)
>>   	isync
>>   FTR_SECTION_ELSE
>>   	/* On P9 we use the split_info for coordinating LPCR changes */
>> diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
>> index 77f2e0a4ee37..5593a2d55959 100644
>> --- a/arch/powerpc/platforms/powernv/idle.c
>> +++ b/arch/powerpc/platforms/powernv/idle.c
>> @@ -679,7 +679,8 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>>   		sprs.ptcr	= mfspr(SPRN_PTCR);
>>   		sprs.rpr	= mfspr(SPRN_RPR);
>>   		sprs.tscr	= mfspr(SPRN_TSCR);
>> -		sprs.ldbar	= mfspr(SPRN_LDBAR);
>> +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>> +			sprs.ldbar	= mfspr(SPRN_LDBAR);
>>   
>>   		sprs_saved = true;
>>   
>> @@ -762,7 +763,8 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
>>   	mtspr(SPRN_PTCR,	sprs.ptcr);
>>   	mtspr(SPRN_RPR,		sprs.rpr);
>>   	mtspr(SPRN_TSCR,	sprs.tscr);
>> -	mtspr(SPRN_LDBAR,	sprs.ldbar);
>> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>> +		mtspr(SPRN_LDBAR,	sprs.ldbar);
>>   
>>   	if (pls >= pnv_first_tb_loss_level) {
>>   		/* TB loss */
>> diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platforms/powernv/opal-imc.c
>> index 1b6932890a73..5fe2d4526cbc 100644
>> --- a/arch/powerpc/platforms/powernv/opal-imc.c
>> +++ b/arch/powerpc/platforms/powernv/opal-imc.c
>> @@ -254,6 +254,10 @@ static int opal_imc_counters_probe(struct platform_device *pdev)
>>   	bool core_imc_reg = false, thread_imc_reg = false;
>>   	u32 type;
>>   
>> +	/* Disable IMC devices, when Ultravisor is enabled. */
>> +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>> +		return -EACCES;
>> +
>>   	/*
>>   	 * Check whether this is kdump kernel. If yes, force the engines to
>>   	 * stop and return.
>>

