Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E139098901
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Aug 2019 03:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfHVBdR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Aug 2019 21:33:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728470AbfHVBdR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Aug 2019 21:33:17 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7M1Vlvq065742;
        Wed, 21 Aug 2019 21:33:13 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhgqt1a0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 21:33:12 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7M1W8tT015021;
        Thu, 22 Aug 2019 01:33:12 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2ue97780rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Aug 2019 01:33:11 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7M1XAu415139760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 01:33:11 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E51F4AE068;
        Thu, 22 Aug 2019 01:33:10 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBE4CAE05C;
        Thu, 22 Aug 2019 01:33:07 +0000 (GMT)
Received: from [9.80.203.17] (unknown [9.80.203.17])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 01:33:07 +0000 (GMT)
Subject: Re: [PATCH v5 4/7] powerpc/mm: Use UV_WRITE_PATE ucall to register a
 PATE
To:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com>
 <20190808040555.2371-5-cclaudio@linux.ibm.com>
 <871rxo7zif.fsf@concordia.ellerman.id.au>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Message-ID: <9212f3e3-e98c-5079-1d30-d07e3d0087b9@linux.ibm.com>
Date:   Wed, 21 Aug 2019 22:33:06 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <871rxo7zif.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220012
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 8/14/19 8:33 AM, Michael Ellerman wrote:
> Hi Claudio,
>
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
>> From: Michael Anderson <andmike@linux.ibm.com>
>>
>> In ultravisor enabled systems, the ultravisor creates and maintains the
>> partition table in secure memory where the hypervisor cannot access, and
>                                    ^
>                                    which?
>
>> therefore, the hypervisor have to do the UV_WRITE_PATE ucall whenever it
>                             ^          ^
>                             has        a
>> wants to set a partition table entry (PATE).
>>
>> This patch adds the UV_WRITE_PATE ucall and uses it to set a PATE if
>> ultravisor is enabled. Additionally, this also also keeps a copy of the
>> partition table because the nestMMU does not have access to secure
>> memory. Such copy has entries for nonsecure and hypervisor partition.
> I'm having trouble parsing the last sentence there.
>
> Or at least it doesn't seem to match the code, or I don't understand
> either the code or the comment. More below.
>
>> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
>> index 85bc81abd286..033731f5dbaa 100644
>> --- a/arch/powerpc/mm/book3s64/pgtable.c
>> +++ b/arch/powerpc/mm/book3s64/pgtable.c
>> @@ -213,34 +223,50 @@ void __init mmu_partition_table_init(void)
>>  	powernv_set_nmmu_ptcr(ptcr);
>>  }
>>  
>> -void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
>> -				   unsigned long dw1)
>> +/*
>> + * Global flush of TLBs and partition table caches for this lpid. The type of
>> + * flush (hash or radix) depends on what the previous use of this partition ID
>> + * was, not the new use.
>> + */
>> +static void flush_partition(unsigned int lpid, unsigned long old_patb0)
> A nicer API would be for the 2nd param to be a "bool radix", and have
> the caller worry about the fact that it comes from (patb0 & PATB_HR).

Yes, I agree. I applied that to next patchset version.


>
>>  {
>> -	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
>> -
>> -	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
>> -	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
>> -
>> -	/*
>> -	 * Global flush of TLBs and partition table caches for this lpid.
>> -	 * The type of flush (hash or radix) depends on what the previous
>> -	 * use of this partition ID was, not the new use.
>> -	 */
>>  	asm volatile("ptesync" : : : "memory");
>> -	if (old & PATB_HR) {
>> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
>> +	if (old_patb0 & PATB_HR) {
>> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
>>  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
>> -		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
>> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
> That looks like an unrelated whitespace change.
>
>>  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
>>  		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
>>  	} else {
>> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
>> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
> Ditto.

True. I dropped the two changes above in the next patchset version.

Thanks,
Claudio


>
>>  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
>>  		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
>>  	}
>>  	/* do we need fixup here ?*/
>>  	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
>>  }
>> +
>> +void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
>> +				  unsigned long dw1)
>> +{
>> +	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
>> +
>> +	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
>> +	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
> ie. here we always update the copy of the partition table, regardless of
> whether we're running under an ultravisor or not. So the copy is a
> complete copy isn't it?
>
>> +	/*
>> +	 * In ultravisor enabled systems, the ultravisor maintains the partition
>> +	 * table in secure memory where we don't have access, therefore, we have
>> +	 * to do a ucall to set an entry.
>> +	 */
>> +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
>> +		uv_register_pate(lpid, dw0, dw1);
>> +		pr_info("PATE registered by ultravisor: dw0 = 0x%lx, dw1 = 0x%lx\n",
>> +			dw0, dw1);
>> +	} else {
>> +		flush_partition(lpid, old);
>> +	}
> What is different is whether we flush or not.
>
> And don't we still need to do the flush for the nestMMU? I assume we're
> saying the ultravisor will broadcast a flush for us, which will also
> handle the nestMMU case?
>
> cheers
>
