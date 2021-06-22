Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD903B0EF6
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVUtW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 16:49:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229567AbhFVUtW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 16:49:22 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MKYFBW040774
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 16:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=e0H9LtcT1SLUHo80QKR8WFbqXSXaELy9ljflqQ772w8=;
 b=EduRNmr4jDj32iKjI8KIQV1I+P0y2PQVuGWoq4luKgDNvS9yEB/NFOZYdNDA1A2pOrR1
 I7BNByzWtATKWD4Kmg7cCSa1jjPpD6hN/VkhW6Mmevh2zfQ4D6x7yUlipz+J2s2xjsss
 XH5+0jpY/4/fcSJriahK8aEWUx9sHyJSYoq11sZ/OR2HEaZ8uTwwAi9RLS3glipHoZpX
 SupcakLGlChp0sOqWXwWEGEPrQCfjibCs3kCvgkCzGduy+K8F6wCjx7t0lynzgnmH09u
 nrqAip+682bRnMntoGYtC4E+VNSt0ZeXMPJ9w1mlZZ7xBt6ATxq/We5PJXqv6ZIc6+Tl RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bngrasvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 16:47:05 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MKac25051701
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 16:47:05 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bngrasv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 16:47:05 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MKc3O4015968;
        Tue, 22 Jun 2021 20:47:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 399878tu24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 20:47:04 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MKl3mV35127554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 20:47:03 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9B86AE05C;
        Tue, 22 Jun 2021 20:47:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07D79AE05F;
        Tue, 22 Jun 2021 20:47:03 +0000 (GMT)
Received: from localhost (unknown [9.211.80.241])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Jun 2021 20:47:02 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV Nested: Reflect L2 PMU in-use to L0
 when L2 SPRs are live
In-Reply-To: <20210619133415.20016-1-npiggin@gmail.com>
References: <20210619133415.20016-1-npiggin@gmail.com>
Date:   Tue, 22 Jun 2021 17:47:00 -0300
Message-ID: <87lf71oce3.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5kN519VdRXOK3Gw-mtSApZUaXJzKwh-K
X-Proofpoint-GUID: NNaPlF0N5yVr-e5J8o6x38jGkAsANT3Q
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_12:2021-06-22,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220123
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> After the L1 saves its PMU SPRs but before loading the L2's PMU SPRs,
> switch the pmcregs_in_use field in the L1 lppaca to the value advertised
> by the L2 in its VPA. On the way out of the L2, set it back after saving
> the L2 PMU registers (if they were in-use).
>
> This transfers the PMU liveness indication between the L1 and L2 at the
> points where the registers are not live.
>
> This fixes the nested HV bug for which a workaround was added to the L0
> HV by commit 63279eeb7f93a ("KVM: PPC: Book3S HV: Always save guest pmu
> for guest capable of nesting"), which explains the problem in detail.
> That workaround is no longer required for guests that include this bug
> fix.
>
> Fixes: 360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

I don't know much about the performance monitor facility, but the patch
seems sane overall.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
> I have a later performance patch that reverts the workaround, but it
> would be good to fix the nested HV first so there is some lead time for
> the fix to percolate.
>
> Thanks,
> Nick
>
>  arch/powerpc/include/asm/pmc.h |  7 +++++++
>  arch/powerpc/kvm/book3s_hv.c   | 15 +++++++++++++++
>  2 files changed, 22 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
> index c6bbe9778d3c..3c09109e708e 100644
> --- a/arch/powerpc/include/asm/pmc.h
> +++ b/arch/powerpc/include/asm/pmc.h
> @@ -34,6 +34,13 @@ static inline void ppc_set_pmu_inuse(int inuse)
>  #endif
>  }
>
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +static inline int ppc_get_pmu_inuse(void)
> +{
> +	return get_paca()->pmcregs_in_use;
> +}
> +#endif
> +
>  extern void power4_enable_pmcs(void);
>
>  #else /* CONFIG_PPC64 */
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 0d6edb136bd4..e66f96fb6eed 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -59,6 +59,7 @@
>  #include <asm/kvm_book3s.h>
>  #include <asm/mmu_context.h>
>  #include <asm/lppaca.h>
> +#include <asm/pmc.h>
>  #include <asm/processor.h>
>  #include <asm/cputhreads.h>
>  #include <asm/page.h>
> @@ -3761,6 +3762,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
>  		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
>
> +#ifdef CONFIG_PPC_PSERIES
> +	if (kvmhv_on_pseries()) {
> +		if (vcpu->arch.vpa.pinned_addr) {
> +			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
> +			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
> +		} else {
> +			get_lppaca()->pmcregs_in_use = 1;
> +		}
> +	}
> +#endif
>  	kvmhv_load_guest_pmu(vcpu);
>
>  	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
> @@ -3895,6 +3906,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	save_pmu |= nesting_enabled(vcpu->kvm);
>
>  	kvmhv_save_guest_pmu(vcpu, save_pmu);
> +#ifdef CONFIG_PPC_PSERIES
> +	if (kvmhv_on_pseries())
> +		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
> +#endif
>
>  	vc->entry_exit_map = 0x101;
>  	vc->in_guest = 0;
