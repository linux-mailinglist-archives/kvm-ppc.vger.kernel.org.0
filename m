Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D445A324556
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Feb 2021 21:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhBXUhW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 24 Feb 2021 15:37:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60867 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234741AbhBXUhP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 24 Feb 2021 15:37:15 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11OKYUpN180549;
        Wed, 24 Feb 2021 15:36:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=7LM3hY61pSItXWosd4fxH2/CXYgi00JA9PfofwR7sEo=;
 b=NkIUmrgIsTw2JG6j1mWQ90TBWoGd54TKbAGqaazLp5soyceiqz4OA2hbe9/tbxSpYamg
 YZh4UhW4JqyWrUCAbfjPie5RRrz9MPBhPSAWsLirX83o8ZlCS+miGBpvPKq5D3QK6r8B
 yeNYxnCieVLjtVIjFbUE1SZSdVvHEMqTYCCgqib3mwY8NFm0dI8B0pvGC+K5KFUdwtLs
 lOsDE5dRxAVVwV4QTKzBdpGPmolK4FAF2RuRR2snlEes3bF6kLVW7m5DgVca3cK+jf4g
 zNNhVwFY2/U4CBawk2fE4N+6jeAKKVrkVX3aBVj7TdpJGKFYogwPZ2EuJW9/440bs0sC MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmqx4cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 15:36:22 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11OKYrG7184782;
        Wed, 24 Feb 2021 15:36:22 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmqx4cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 15:36:22 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11OKVTor023060;
        Wed, 24 Feb 2021 20:36:21 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 36tt2a1sca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Feb 2021 20:36:21 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11OKaJaH13238828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 20:36:20 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFA227805C;
        Wed, 24 Feb 2021 20:36:19 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20CAA7805E;
        Wed, 24 Feb 2021 20:36:18 +0000 (GMT)
Received: from localhost (unknown [9.77.137.15])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Wed, 24 Feb 2021 20:36:18 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 12/13] KVM: PPC: Book3S HV: Move radix MMU switching
 together in the P9 path
In-Reply-To: <20210219063542.1425130-13-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
 <20210219063542.1425130-13-npiggin@gmail.com>
Date:   Wed, 24 Feb 2021 17:36:16 -0300
Message-ID: <878s7dxkxr.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-24_09:2021-02-24,2021-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240159
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Switching the MMU from radix<->radix mode is tricky particularly as the
> MMU can remain enabled and requires a certain sequence of SPR updates.
> Move these together into their own functions.
>
> This also includes the radix TLB check / flush because it's tied in to
> MMU switching due to tlbiel getting LPID from LPIDR.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

<snip>

> @@ -4117,7 +4138,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  {
>  	struct kvm_run *run = vcpu->run;
>  	int trap, r, pcpu;
> -	int srcu_idx, lpid;
> +	int srcu_idx;
>  	struct kvmppc_vcore *vc;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_nested_guest *nested = vcpu->arch.nested;
> @@ -4191,13 +4212,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>  	vc->vcore_state = VCORE_RUNNING;
>  	trace_kvmppc_run_core(vc, 0);
>
> -	if (cpu_has_feature(CPU_FTR_HVMODE)) {
> -		lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
> -		mtspr(SPRN_LPID, lpid);
> -		isync();
> -		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
> -	}
> -

What about the counterpart to this^ down below?

	if (cpu_has_feature(CPU_FTR_HVMODE)) {
		mtspr(SPRN_LPID, kvm->arch.host_lpid);
		isync();
	}
        
>  	guest_enter_irqoff();
>
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
