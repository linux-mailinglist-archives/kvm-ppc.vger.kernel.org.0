Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9F3B89A2
	for <lists+kvm-ppc@lfdr.de>; Wed, 30 Jun 2021 22:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhF3UUo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 30 Jun 2021 16:20:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233942AbhF3UUo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 30 Jun 2021 16:20:44 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UK35kJ037385;
        Wed, 30 Jun 2021 16:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=7wf03PiE1c9kqRaVvhtlBkbkPosAfroaG7+MMf3oy/0=;
 b=AaCZhNZcmdW5IlqCTMMQgVgnJmlhDEaWaBZTmj39KsCbbSBVyDpmEL8SyjHbNcmcYHMU
 Tz86nM+9RfI3y4tc/hOgcDCj11f0G8HxRRhYm2KdXf9HHGgBJIkM75TtdpHMgYl2+RBV
 EVrW1QtUOeMO0sEYKyf1ZnctIyvDAnG+rMuZ5nlINmwDGvrRWEiNlE7Kpfc0ur37bk9A
 mqaH8/zRJ1BO0o41UOa3OPA54SGOVPSyQgtyBtV3z5Wko45lM1Atpysw7Zh9mFefjPkR
 tYMHGUWw3qn+ca9MiobGpjM7k9LqlthXxvUwMV+PlL9loDTOGDdpYpII/BOF2jRleA8n DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gv00xga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 16:18:09 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15UK3BQZ037966;
        Wed, 30 Jun 2021 16:18:09 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gv00xg9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 16:18:09 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15UKHZ9a009407;
        Wed, 30 Jun 2021 20:18:08 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 39ekxdg1g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 20:18:08 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15UKI7SH37290382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 20:18:07 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1B5CAE017;
        Wed, 30 Jun 2021 20:18:07 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEB69AE012;
        Wed, 30 Jun 2021 20:18:06 +0000 (GMT)
Received: from localhost (unknown [9.211.127.242])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 30 Jun 2021 20:18:06 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 19/43] KVM: PPC: Book3S HV P9: Add
 kvmppc_stop_thread to match kvmppc_start_thread
In-Reply-To: <20210622105736.633352-20-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
 <20210622105736.633352-20-npiggin@gmail.com>
Date:   Wed, 30 Jun 2021 17:18:04 -0300
Message-ID: <875yxv2jk3.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qwAEti7QCOEKTy5GYGsF2E4tCfuTdzKe
X-Proofpoint-ORIG-GUID: A-H3EHDvlkgfVRn4mE2cSYf0bdTV6BhM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_11:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300111
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Small cleanup makes it a bit easier to match up entry and exit
> operations.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index b8b0695a9312..86c85e303a6d 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2948,6 +2948,13 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
>  		kvmppc_ipi_thread(cpu);
>  }
>
> +/* Old path does this in asm */
> +static void kvmppc_stop_thread(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->cpu = -1;
> +	vcpu->arch.thread_cpu = -1;
> +}
> +
>  static void kvmppc_wait_for_nap(int n_threads)
>  {
>  	int cpu = smp_processor_id();
> @@ -4154,8 +4161,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  		dec = (s32) dec;
>  	tb = mftb();
>  	vcpu->arch.dec_expires = dec + tb;
> -	vcpu->cpu = -1;
> -	vcpu->arch.thread_cpu = -1;
>
>  	store_spr_state(vcpu);
>
> @@ -4627,6 +4632,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>
>  	guest_exit_irqoff();
>
> +	kvmppc_stop_thread(vcpu);
> +
>  	powerpc_local_irq_pmu_restore(flags);
>
>  	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
