Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA3681EB
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Jul 2019 02:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfGOAjA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 14 Jul 2019 20:39:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728970AbfGOAi7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 14 Jul 2019 20:38:59 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6F0asDU076915
        for <kvm-ppc@vger.kernel.org>; Sun, 14 Jul 2019 20:38:58 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2trasuemm0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Sun, 14 Jul 2019 20:38:58 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Mon, 15 Jul 2019 01:38:57 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 15 Jul 2019 01:38:53 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6F0cqxJ46465418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 00:38:52 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF611AC05B;
        Mon, 15 Jul 2019 00:38:52 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9774AC059;
        Mon, 15 Jul 2019 00:38:49 +0000 (GMT)
Received: from [9.85.138.185] (unknown [9.85.138.185])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jul 2019 00:38:49 +0000 (GMT)
Subject: Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
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
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
 <87h87sg24k.fsf@concordia.ellerman.id.au>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Sun, 14 Jul 2019 21:38:48 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <87h87sg24k.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19071500-2213-0000-0000-000003AE51E5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011429; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01232277; UDB=6.00649216; IPR=6.01013578;
 MB=3.00027718; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-15 00:38:55
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071500-2214-0000-0000-00005F3BDD86
Message-Id: <f2361f73-531c-c00a-c55d-52e570ef1bed@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-14_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150006
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 7/11/19 9:57 AM, Michael Ellerman wrote:
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> When the ultravisor firmware is available, it takes control over the
>> LDBAR register. In this case, thread-imc updates and save/restore
>> operations on the LDBAR register are handled by ultravisor.
> Please roll up the replies to Alexey's question about LDBAR into the
> change log.
>
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> index f9b2620fbecd..cffb365d9d02 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -375,8 +375,10 @@ BEGIN_FTR_SECTION
>>  	mtspr	SPRN_RPR, r0
>>  	ld	r0, KVM_SPLIT_PMMAR(r6)
>>  	mtspr	SPRN_PMMAR, r0
>> +BEGIN_FW_FTR_SECTION_NESTED(70)
>>  	ld	r0, KVM_SPLIT_LDBAR(r6)
>>  	mtspr	SPRN_LDBAR, r0
>> +END_FW_FTR_SECTION_NESTED(FW_FEATURE_ULTRAVISOR, 0, 70)
> That's in Power8 code isn't it? Which will never have an ultravisor.

IIUC, it might be executed in Power9 as well, but I can double check that.


>
>> diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platforms/powernv/opal-imc.c
>> index 1b6932890a73..5fe2d4526cbc 100644
>> --- a/arch/powerpc/platforms/powernv/opal-imc.c
>> +++ b/arch/powerpc/platforms/powernv/opal-imc.c
>> @@ -254,6 +254,10 @@ static int opal_imc_counters_probe(struct platform_device *pdev)
>>  	bool core_imc_reg = false, thread_imc_reg = false;
>>  	u32 type;
>>  
>> +	/* Disable IMC devices, when Ultravisor is enabled. */
>> +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR))
>> +		return -EACCES;
> I don't mind taking this change. But at the same time should the IMC
> stuff just be omitted from the device tree when we're in ultravisor mode?

Yes. Maddy said that he will patch skiboot to remove the IMC nodes if
ultravisor is present.

I added this check just to protect the kernel in case skiboot is not in the
right level for some
reason.

Thanks,
Claudio



>
> cheers
>

