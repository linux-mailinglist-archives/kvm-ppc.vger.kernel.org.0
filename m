Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDE356E88
	for <lists+kvm-ppc@lfdr.de>; Wed,  7 Apr 2021 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbhDGO14 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 7 Apr 2021 10:27:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233090AbhDGO1z (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 7 Apr 2021 10:27:55 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 137E3NJP083703;
        Wed, 7 Apr 2021 10:27:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=iBJseUvpqOWUCs/N6M+cGjokf0UrC258pfXa+OV4xKo=;
 b=SyEZRtd9ajAoIaeKFP61dSPF/5Baz8DJ4hPZkw5pxkmGxhiTHInrRvxfZUBhcvHCvEm1
 lzWGcaukiPdtMRRqVuy8H7NXsZ7N3Iwwz0VutQY9o5l8zCUq6L+577ScOSnu5UPjNwJ0
 UxQuceI3Us8mNm8ySaWX1Vbn74mNszyRRkLyNLWt+c9pkdKOSs5NaQvwrRdF/wMql5v+
 ILzRw3GqWz+KiJhbgtrDJ1EHPrzDE4QN6HNECi0Vkzs/0V4Mf1X/ShjwYWXr8YFU7j5e
 y8f8kkBta/FQ3hHleFlUuxs7QpQBmNhfTNgef3mZW4vhO9ODe7VwekFuS2aDWTOy8I9/ 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqm0yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:27:33 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 137E3n6a085815;
        Wed, 7 Apr 2021 10:27:32 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37rvmqm0xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 10:27:32 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 137ENpvf007989;
        Wed, 7 Apr 2021 14:27:32 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 37rvyvdwbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 14:27:31 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 137ERVsw23265562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Apr 2021 14:27:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21FC3C605A;
        Wed,  7 Apr 2021 14:27:31 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64EDCC6059;
        Wed,  7 Apr 2021 14:27:30 +0000 (GMT)
Received: from localhost (unknown [9.211.67.99])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Apr 2021 14:27:30 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        paulus@ozlabs.org
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Sanitise vcpu registers in
 nested path
In-Reply-To: <1617788184.45mdcz310i.astroid@bobo.none>
References: <20210406214645.3315819-1-farosas@linux.ibm.com>
 <1617788184.45mdcz310i.astroid@bobo.none>
Date:   Wed, 07 Apr 2021 11:27:28 -0300
Message-ID: <87blaqdvan.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DK39ARtB5lPxHBFSXOue1CswIDLknT4O
X-Proofpoint-ORIG-GUID: M3l7tL_I9AUFZkEHEYPBdzVku5Ip7e0_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-07_08:2021-04-07,2021-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 mlxlogscore=854 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070094
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

<snip>

>>  static void restore_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
>> @@ -324,9 +340,10 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>>  	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
>>  		LPCR_LPES | LPCR_MER;
>>  	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
>> -	sanitise_hv_regs(vcpu, &l2_hv);
>>  	restore_hv_regs(vcpu, &l2_hv);
>>  
>> +	sanitise_vcpu_entry_state(vcpu, &l2_hv, &saved_l1_hv);
>
> So instead of doing this, can we just have one function that does
> load_hv_regs_for_l2()?

Yes. I would go even further and fold everything into a load_l2_state()
that takes care of hv and non-hv. The top level here could easily be:

  save_l1_state();
  load_l2_state();
  
  do {
     kvmhv_run_single_vcpu();
  } while();
  
  save_l2_state();
  restore_l1_state();

I'll send a v3 with the change you suggested and then perhaps a small
refactoring on top of it. Let's see how it turns out.

>
>> +
>>  	vcpu->arch.ret = RESUME_GUEST;
>>  	vcpu->arch.trap = 0;
>>  	do {
>> @@ -338,6 +355,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>>  		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
>>  	} while (is_kvmppc_resume_guest(r));
>>  
>> +	sanitise_vcpu_return_state(vcpu, &l2_hv);
>
> And this could be done in save_hv_return_state().
>
> I think?
>
> Question about HFSCR. Is it possible for some interrupt cause bit
> reaching the nested hypervisor for a bit that we thought we had
> enabled but was secretly masked off? I.e., do we have to filter
> HFSCR causes according to the facilities we secretly disabled?

Yes, we're copying the Cause bits unmodified. Currently it makes no
difference because L1 only checks for doorbells and everything else
leads to injecting a program interrupt into L2.

What I think is the correct thing to do is to only return into L1 with
the Cause bits pertaining to the facilities it has disabled (if L1 state
has a bit set but L2 state has not).

For the facilities L0 has disabled in L1, we should handle them as if L1
had tried to use the facility and instead of returning from
H_ENTER_NESTED into L1, do whatever we currently do under
BOOK3S_INTERRUPT_H_FAC_UNAVAIL for non-nested guests. Which would
eventually mean injecting a program interrupt into L1 because we're not
L2s hypervisor - L1 is - so there is not much we'd want to do in L0 in
terms of emulating the facility.

Does that make sense?

>
> Thanks,
> Nick
