Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D3E18D157
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Mar 2020 15:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCTOoE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Mar 2020 10:44:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbgCTOoE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Mar 2020 10:44:04 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KEZppB103209
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 10:44:03 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yu98vnpeb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 20 Mar 2020 10:44:02 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <ldufour@linux.ibm.com>;
        Fri, 20 Mar 2020 14:44:01 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Mar 2020 14:43:57 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02KEgtuA40829372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Mar 2020 14:42:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D29F8AE05A;
        Fri, 20 Mar 2020 14:43:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76BAEAE051;
        Fri, 20 Mar 2020 14:43:56 +0000 (GMT)
Received: from pomme.local (unknown [9.145.63.10])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Mar 2020 14:43:56 +0000 (GMT)
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S HV: check caller of H_SVM_* Hcalls
To:     Greg Kurz <groug@kaod.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20200320102643.15516-1-ldufour@linux.ibm.com>
 <20200320102643.15516-2-ldufour@linux.ibm.com>
 <20200320132248.44b81b3b@bahia.lan>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Date:   Fri, 20 Mar 2020 15:43:54 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320132248.44b81b3b@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20032014-0012-0000-0000-00000394869C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032014-0013-0000-0000-000021D17040
Message-Id: <2268d1e3-3020-91c4-90e2-d2eced6a214a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_04:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200059
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Le 20/03/2020 à 13:22, Greg Kurz a écrit :
> On Fri, 20 Mar 2020 11:26:42 +0100
> Laurent Dufour <ldufour@linux.ibm.com> wrote:
> 
>> The Hcall named H_SVM_* are reserved to the Ultravisor. However, nothing
>> prevent a malicious VM or SVM to call them. This could lead to weird result
>> and should be filtered out.
>>
>> Checking the Secure bit of the calling MSR ensure that the call is coming
>> from either the Ultravisor or a SVM. But any system call made from a SVM
>> are going through the Ultravisor, and the Ultravisor should filter out
>> these malicious call. This way, only the Ultravisor is able to make such a
>> Hcall.
> 
> "Ultravisor should filter" ? And what if it doesn't (eg. because of a bug) ?

If it doesn't, a malicious SVM would be able to call UV reserved Hcall like 
H_SVM_INIT_ABORT, etc... which is not a good idea.

> 
> Shouldn't we also check the HV bit of the calling MSR as well to
> disambiguate SVM and UV ?

That's another way to do so, but since the SVM Hcall are going through the UV, 
it seems the right place (the UV) to do the filtering.

>>
>> Cc: Bharata B Rao <bharata@linux.ibm.com>
>> Cc: Paul Mackerras <paulus@ozlabs.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
>> ---
>>   arch/powerpc/kvm/book3s_hv.c | 32 +++++++++++++++++++++-----------
>>   1 file changed, 21 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 33be4d93248a..43773182a737 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1074,25 +1074,35 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>>   					 kvmppc_get_gpr(vcpu, 6));
>>   		break;
>>   	case H_SVM_PAGE_IN:
>> -		ret = kvmppc_h_svm_page_in(vcpu->kvm,
>> -					   kvmppc_get_gpr(vcpu, 4),
>> -					   kvmppc_get_gpr(vcpu, 5),
>> -					   kvmppc_get_gpr(vcpu, 6));
>> +		ret = H_UNSUPPORTED;
>> +		if (kvmppc_get_srr1(vcpu) & MSR_S)
>> +			ret = kvmppc_h_svm_page_in(vcpu->kvm,
>> +						   kvmppc_get_gpr(vcpu, 4),
>> +						   kvmppc_get_gpr(vcpu, 5),
>> +						   kvmppc_get_gpr(vcpu, 6));
> 
> If calling kvmppc_h_svm_page_in() produces a "weird result" when
> the MSR_S bit isn't set, then I think it should do the checking
> itself, ie. pass vcpu.
> 
> This would also prevent adding that many lines in kvmppc_pseries_do_hcall()
> which is a big enough function already. The checking could be done in a
> helper in book3s_hv_uvmem.c and used by all UV specific hcalls.

I'm not convinced that would be better, and I followed the way checks for other 
Hcalls has been made (see H_TLB_INVALIDATE,..).

I agree  kvmppc_pseries_do_hcall() is long but this is just a big switch(), 
quite linear.

> 
>>   		break;
>>   	case H_SVM_PAGE_OUT:
>> -		ret = kvmppc_h_svm_page_out(vcpu->kvm,
>> -					    kvmppc_get_gpr(vcpu, 4),
>> -					    kvmppc_get_gpr(vcpu, 5),
>> -					    kvmppc_get_gpr(vcpu, 6));
>> +		ret = H_UNSUPPORTED;
>> +		if (kvmppc_get_srr1(vcpu) & MSR_S)
>> +			ret = kvmppc_h_svm_page_out(vcpu->kvm,
>> +						    kvmppc_get_gpr(vcpu, 4),
>> +						    kvmppc_get_gpr(vcpu, 5),
>> +						    kvmppc_get_gpr(vcpu, 6));
>>   		break;
>>   	case H_SVM_INIT_START:
>> -		ret = kvmppc_h_svm_init_start(vcpu->kvm);
>> +		ret = H_UNSUPPORTED;
>> +		if (kvmppc_get_srr1(vcpu) & MSR_S)
>> +			ret = kvmppc_h_svm_init_start(vcpu->kvm);
>>   		break;
>>   	case H_SVM_INIT_DONE:
>> -		ret = kvmppc_h_svm_init_done(vcpu->kvm);
>> +		ret = H_UNSUPPORTED;
>> +		if (kvmppc_get_srr1(vcpu) & MSR_S)
>> +			ret = kvmppc_h_svm_init_done(vcpu->kvm);
>>   		break;
>>   	case H_SVM_INIT_ABORT:
>> -		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
>> +		ret = H_UNSUPPORTED;
>> +		if (kvmppc_get_srr1(vcpu) & MSR_S)
>> +			ret = kvmppc_h_svm_init_abort(vcpu->kvm);
>>   		break;
>>   
>>   	default:
> 

