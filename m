Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2486761B
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Jul 2019 23:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfGLVHW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Jul 2019 17:07:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbfGLVHV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Jul 2019 17:07:21 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CL6vlK112593
        for <kvm-ppc@vger.kernel.org>; Fri, 12 Jul 2019 17:07:20 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tq1edh0av-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 12 Jul 2019 17:07:20 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Fri, 12 Jul 2019 22:07:19 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 12 Jul 2019 22:07:16 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6CL7Fup50594120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 21:07:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8604B112066;
        Fri, 12 Jul 2019 21:07:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3E2112064;
        Fri, 12 Jul 2019 21:07:13 +0000 (GMT)
Received: from [9.18.235.77] (unknown [9.18.235.77])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jul 2019 21:07:13 +0000 (GMT)
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@ozlabs.org
Cc:     Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        Bharata B Rao <bharata@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-2-cclaudio@linux.ibm.com>
 <1562892336.boqkwvamhq.astroid@bobo.none>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Fri, 12 Jul 2019 18:07:12 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <1562892336.boqkwvamhq.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19071221-0060-0000-0000-0000035DE00F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011417; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01231263; UDB=6.00648600; IPR=6.01012548;
 MB=3.00027695; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-12 21:07:18
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071221-0061-0000-0000-00004A1DDFDE
Message-Id: <de2448a0-291f-a293-6021-05d4492b3563@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120217
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 7/11/19 9:57 PM, Nicholas Piggin wrote:
> Claudio Carvalho's on June 29, 2019 6:08 am:
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>>
>> The ultravisor processor mode is introduced in POWER platforms that
>> supports the Protected Execution Facility (PEF). Ultravisor is higher
>> privileged than hypervisor mode.
>>
>> In PEF enabled platforms, the MSR_S bit is used to indicate if the
>> thread is in secure state. With the MSR_S bit, the privilege state of
>> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
>>
>> S   HV  PR
>> -----------------------
>> 0   x   1   problem
>> 1   0   1   problem
>> x   x   0   privileged
>> x   1   0   hypervisor
>> 1   1   0   ultravisor
>> 1   1   1   reserved
> What does this table mean? I thought 'x' meant either


Yes, it means either. The table was arranged that way to say that:
- hypervisor state is also a privileged state,
- ultravisor state is also a hypervisor state.


> , but in that
> case there are several states that can apply to the same
> combination of bits.
>
> Would it be clearer to rearrange the table so the columns are the HV
> and PR bits we know and love, plus the effect of S=1 on each of them?
>
>       HV  PR  S=0         S=1
>       ---------------------------------------------
>       0   0   privileged  privileged (secure guest kernel)
>       0   1   problem     problem (secure guest userspace)
>       1   0   hypervisor  ultravisor
>       1   1   problem     reserved
>
> Is that accurate?

Yes, it is. I also like this format. I will consider it.


>
>
>> The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
>> secure guest and the ultravisor firmware do.
>>
>> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> [ Update the commit message ]
>> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
>> ---
>>  arch/powerpc/include/asm/reg.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
>> index 10caa145f98b..39b4c0a519f5 100644
>> --- a/arch/powerpc/include/asm/reg.h
>> +++ b/arch/powerpc/include/asm/reg.h
>> @@ -38,6 +38,7 @@
>>  #define MSR_TM_LG	32		/* Trans Mem Available */
>>  #define MSR_VEC_LG	25	        /* Enable AltiVec */
>>  #define MSR_VSX_LG	23		/* Enable VSX */
>> +#define MSR_S_LG	22		/* Secure VM bit */
>>  #define MSR_POW_LG	18		/* Enable Power Management */
>>  #define MSR_WE_LG	18		/* Wait State Enable */
>>  #define MSR_TGPR_LG	17		/* TLB Update registers in use */
>> @@ -71,11 +72,13 @@
>>  #define MSR_SF		__MASK(MSR_SF_LG)	/* Enable 64 bit mode */
>>  #define MSR_ISF		__MASK(MSR_ISF_LG)	/* Interrupt 64b mode valid on 630 */
>>  #define MSR_HV 		__MASK(MSR_HV_LG)	/* Hypervisor state */
>> +#define MSR_S		__MASK(MSR_S_LG)	/* Secure state */
> This is a real nitpick, but why two different comments for the bit 
> number and the mask?

Fixed for the next version. Both comments will be /* Secure state */

Thanks
Claudio


