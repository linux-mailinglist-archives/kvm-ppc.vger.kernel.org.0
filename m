Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B82FBA1F
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Jan 2021 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbhASOny (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Jan 2021 09:43:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388288AbhASJqg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 19 Jan 2021 04:46:36 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10J9XAMf062465
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Jan 2021 04:45:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=4cwID94Gqba/MvPYVrvZd7e1TByxDBqlrxJT4jKkTa4=;
 b=ZlWBAyinKI0SulKzrkXMiWs3iaApvM5hSYs1Yv/eta7yiDtpb1WUI/udvB5tQRuaXhYl
 pS/3h5QtW+wCbNlBoWAjSktNw4BTum1rEgh5/cGtIWB0KGwOwHYuYnLOYD4oosvVFVNA
 AA2PaLt6dVpTzlIw5FAIa9w7rC1bon7HPaPYQYaQJEaJlYmAm/kjxZa6hEZhfaKbR9x/
 Ew+lNFVp8ekwPaHdmlv6vTtD9o6jJZ/zS7MhlqaCShO9KNSnubi5XAzXHlDdzNcs4MwU
 DP9fdCOZ3jIttQXU/gekE8ZvJuITUtGctIVPuiTkDD59kq2RkR6OYcdlaAA7v1TF+IRX dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365v6v9gqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Jan 2021 04:45:54 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10J9ZK5W072843
        for <kvm-ppc@vger.kernel.org>; Tue, 19 Jan 2021 04:45:53 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365v6v9gqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 04:45:53 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10J9WQgL018640;
        Tue, 19 Jan 2021 09:45:52 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 363qs9jgg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 09:45:52 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10J9jpPx17695162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 09:45:52 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4AF02805C;
        Tue, 19 Jan 2021 09:45:51 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B81E2805A;
        Tue, 19 Jan 2021 09:45:50 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.199.47.52])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 09:45:50 +0000 (GMT)
X-Mailer: emacs 27.1 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a
 vcpu moves between threads in a core
In-Reply-To: <20210118122609.1447366-2-npiggin@gmail.com>
References: <20210118122609.1447366-1-npiggin@gmail.com>
 <20210118122609.1447366-2-npiggin@gmail.com>
Date:   Tue, 19 Jan 2021 15:15:47 +0530
Message-ID: <87sg6x5kfo.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> As explained in the comment, there is no need to flush TLBs on all
> threads in a core when a vcpu moves between threads in the same core.
>
> Thread migrations can be a significant proportion of vcpu migrations,
> so this can help reduce the TLB flushing and IPI traffic.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> I believe we can do this and have the TLB coherency correct as per
> the architecture, but would appreciate someone else verifying my
> thinking.
>
> Thanks,
> Nick
>
>  arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 752daf43f780..53d0cbfe5933 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2584,7 +2584,7 @@ static void kvmppc_release_hwthread(int cpu)
>  	tpaca->kvm_hstate.kvm_split_mode = NULL;
>  }
>  
> -static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
> +static void radix_flush_cpu(struct kvm *kvm, int cpu, bool core, struct kvm_vcpu *vcpu)
>  {

Can we rename 'core' to something like 'core_sched'  or 'within_core' 

>  	struct kvm_nested_guest *nested = vcpu->arch.nested;
>  	cpumask_t *cpu_in_guest;
> @@ -2599,6 +2599,14 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
>  		cpu_in_guest = &kvm->arch.cpu_in_guest;
>  	}
>

and do
      if (core_sched) {

> +	if (!core) {
> +		cpumask_set_cpu(cpu, need_tlb_flush);
> +		smp_mb();
> +		if (cpumask_test_cpu(cpu, cpu_in_guest))
> +			smp_call_function_single(cpu, do_nothing, NULL, 1);
> +		return;
> +	}
> +
>  	cpu = cpu_first_thread_sibling(cpu);
>  	for (i = 0; i < threads_per_core; ++i)
>  		cpumask_set_cpu(cpu + i, need_tlb_flush);
> @@ -2655,7 +2663,23 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
>  		if (prev_cpu < 0)
>  			return; /* first run */
>  
> -		radix_flush_cpu(kvm, prev_cpu, vcpu);
> +		/*
> +		 * If changing cores, all threads on the old core should
> +		 * flush, because TLBs can be shared between threads. More
> +		 * precisely, the thread we previously ran on should be
> +		 * flushed, and the thread to first run a vcpu on the old
> +		 * core should flush, but we don't keep enough information
> +		 * around to track that, so we flush all.
> +		 *
> +		 * If changing threads in the same core, only the old thread
> +		 * need be flushed.
> +		 */
> +		if (cpu_first_thread_sibling(prev_cpu) !=
> +		    cpu_first_thread_sibling(pcpu))
> +			radix_flush_cpu(kvm, prev_cpu, true, vcpu);
> +		else
> +			radix_flush_cpu(kvm, prev_cpu, false, vcpu);
> +
>  	}
>  }
>  
> -- 
> 2.23.0
