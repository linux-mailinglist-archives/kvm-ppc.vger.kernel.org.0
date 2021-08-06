Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D213E308E
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Aug 2021 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhHFUts (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 6 Aug 2021 16:49:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhHFUtr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 6 Aug 2021 16:49:47 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176KXGRa038671;
        Fri, 6 Aug 2021 16:49:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=pChskJh1JyiI6S3y9CdGw15j4LoDb1x5XA7EDg7Vorc=;
 b=VMYXyJN6kzmZeT8PBnprn9qW00NhOgL3e47XWPnIOYyR4pU4nlcdSdfUOY908mg6lV5f
 stRtp+TZU/8nclAIbJqdZWYsuJc2LRhpLvs1OJjcSM7IVJ1gBNqwJcyj+zoQGTnI/EgO
 gZbP81oUwImDXfx/Ra1psms5hE0BZeDlMlibKnFP2MrCGj9fnA1wwqacUrjEZSz2evFm
 +hzyu5bBWyn/atZL1nUH8a+yT7mv3QTI9qixuMJb7oV0OX6+3g2kcuZEWKla4+UtMkHs
 4i6hDafmihbp22oGT2IfMGfuacoQjj3xjmLRS9LayYS8sks1kc1Xn78Kx+bGfDWO1vOS EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a9bxdgt42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 16:49:28 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 176KXPCH039742;
        Fri, 6 Aug 2021 16:49:28 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a9bxdgt3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 16:49:28 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176KlsSh001628;
        Fri, 6 Aug 2021 20:49:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 3a4x5j4hy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 20:49:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176KnP6p47645178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 20:49:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4B6778064;
        Fri,  6 Aug 2021 20:49:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 062E27805E;
        Fri,  6 Aug 2021 20:49:25 +0000 (GMT)
Received: from localhost (unknown [9.211.46.8])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri,  6 Aug 2021 20:49:24 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v1 32/55] KVM: PPC: Book3S HV P9: Move vcpu register
 save/restore into functions
In-Reply-To: <20210726035036.739609-33-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
 <20210726035036.739609-33-npiggin@gmail.com>
Date:   Fri, 06 Aug 2021 17:49:22 -0300
Message-ID: <87zgtus3hp.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: B6pf_4g4yjBUjD2uAOkSm_kAZkNnPFom
X-Proofpoint-ORIG-GUID: KrU2nqxCVU-5pesZjvuYvvFwggxamz9k
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_06:2021-08-06,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 bulkscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060136
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> This should be no functional difference but makes the caller easier
> to read.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 65 +++++++++++++++++++++++-------------
>  1 file changed, 41 insertions(+), 24 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c2c72875fca9..45211458ac05 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4062,6 +4062,44 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
>  	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
>  }
>
> +/* Returns true if current MSR and/or guest MSR may have changed */
> +static bool load_vcpu_state(struct kvm_vcpu *vcpu,
> +			   struct p9_host_os_sprs *host_os_sprs)
> +{
> +	bool ret = false;
> +
> +	if (cpu_has_feature(CPU_FTR_TM) ||
> +	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
> +		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
> +		ret = true;
> +	}
> +
> +	load_spr_state(vcpu, host_os_sprs);
> +
> +	load_fp_state(&vcpu->arch.fp);
> +#ifdef CONFIG_ALTIVEC
> +	load_vr_state(&vcpu->arch.vr);
> +#endif
> +	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
> +
> +	return ret;
> +}
> +
> +static void store_vcpu_state(struct kvm_vcpu *vcpu)
> +{
> +	store_spr_state(vcpu);
> +
> +	store_fp_state(&vcpu->arch.fp);
> +#ifdef CONFIG_ALTIVEC
> +	store_vr_state(&vcpu->arch.vr);
> +#endif
> +	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
> +
> +	if (cpu_has_feature(CPU_FTR_TM) ||
> +	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
> +		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
> +}
> +
>  static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
>  {
>  	if (!cpu_has_feature(CPU_FTR_ARCH_31))
> @@ -4169,19 +4207,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>
>  	vcpu_vpa_increment_dispatch(vcpu);
>
> -	if (cpu_has_feature(CPU_FTR_TM) ||
> -	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
> -		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
> -		msr = mfmsr(); /* TM restore can update msr */
> -	}
> -
> -	load_spr_state(vcpu, &host_os_sprs);
> -
> -	load_fp_state(&vcpu->arch.fp);
> -#ifdef CONFIG_ALTIVEC
> -	load_vr_state(&vcpu->arch.vr);
> -#endif
> -	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
> +	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
> +		msr = mfmsr(); /* MSR may have been updated */
>
>  	switch_pmu_to_guest(vcpu, &host_os_sprs);
>
> @@ -4285,17 +4312,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>
>  	switch_pmu_to_host(vcpu, &host_os_sprs);
>
> -	store_spr_state(vcpu);
> -
> -	store_fp_state(&vcpu->arch.fp);
> -#ifdef CONFIG_ALTIVEC
> -	store_vr_state(&vcpu->arch.vr);
> -#endif
> -	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
> -
> -	if (cpu_has_feature(CPU_FTR_TM) ||
> -	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
> -		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
> +	store_vcpu_state(vcpu);
>
>  	vcpu_vpa_increment_dispatch(vcpu);
