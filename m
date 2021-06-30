Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF33B880C
	for <lists+kvm-ppc@lfdr.de>; Wed, 30 Jun 2021 19:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhF3Rxw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 30 Jun 2021 13:53:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhF3Rxt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 30 Jun 2021 13:53:49 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15UHX6pM120910;
        Wed, 30 Jun 2021 13:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=KulXAAPQyyaVzsyC3ZAdvmjJRu4vu262LNdjxNoomlY=;
 b=Mh5ZktC4rQLYzgF100jeq5rXO16jx5tx/TDJCaZ6/vvrnzKO13XVPeegzGqVfFph6n2F
 5TOmjABsA6xo/QxyzUYHhSoBUK/aifzignFJORAlDAltZjI/IyP5e/UcKg++5EFnb0PF
 FF8ffxNhOc8fUxLlH1Xvuuf0My24JdHKwU7pyvQRqgKNpKac0fHTTmqYwoAHzZLLXcgu
 8jeh1xti8jZMSO5vWEixm1vQ6If0KpjMyKPmDCbczc/IfRd50qO6IdT4SKgE3doBZLI4
 dR5YeJHFfEjCL2ezVj5lVnojKWa0YQYRhPOPHKA6AKFtV+Lcp3wN9mzSqx7LkhswAf0q dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gtcyx08d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:51:18 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15UHYYGo130488;
        Wed, 30 Jun 2021 13:51:17 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39gtcyx085-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:51:17 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15UHlYpP009917;
        Wed, 30 Jun 2021 17:51:16 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 39duvd6hjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 17:51:16 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15UHpGs036110744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Jun 2021 17:51:16 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0923FAE014;
        Wed, 30 Jun 2021 17:51:16 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C899AE01D;
        Wed, 30 Jun 2021 17:51:15 +0000 (GMT)
Received: from localhost (unknown [9.211.127.242])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 30 Jun 2021 17:51:14 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 38/43] KVM: PPC: Book3S HV P9: Test dawr_enabled()
 before saving host DAWR SPRs
In-Reply-To: <20210622105736.633352-39-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
 <20210622105736.633352-39-npiggin@gmail.com>
Date:   Wed, 30 Jun 2021 14:51:12 -0300
Message-ID: <87eecj2qcv.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vi8tPx_MaTLmOYWy0QHjxKzZNbv5Gr67
X-Proofpoint-GUID: 9RAFkHmZE4ndMuz5Dvnbo_tNbD7ljEFM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-30_08:2021-06-30,2021-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300097
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Some of the DAWR SPR access is already predicated on dawr_enabled(),
> apply this to the remainder of the accesses.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_p9_entry.c | 34 ++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
> index 7aa72efcac6c..f305d1d6445c 100644
> --- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
> +++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
> @@ -638,13 +638,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>
>  	host_hfscr = mfspr(SPRN_HFSCR);
>  	host_ciabr = mfspr(SPRN_CIABR);
> -	host_dawr0 = mfspr(SPRN_DAWR0);
> -	host_dawrx0 = mfspr(SPRN_DAWRX0);
>  	host_psscr = mfspr(SPRN_PSSCR);
>  	host_pidr = mfspr(SPRN_PID);
> -	if (cpu_has_feature(CPU_FTR_DAWR1)) {
> -		host_dawr1 = mfspr(SPRN_DAWR1);
> -		host_dawrx1 = mfspr(SPRN_DAWRX1);
> +
> +	if (dawr_enabled()) {
> +		host_dawr0 = mfspr(SPRN_DAWR0);
> +		host_dawrx0 = mfspr(SPRN_DAWRX0);
> +		if (cpu_has_feature(CPU_FTR_DAWR1)) {
> +			host_dawr1 = mfspr(SPRN_DAWR1);
> +			host_dawrx1 = mfspr(SPRN_DAWRX1);

The userspace needs to enable DAWR1 via KVM_CAP_PPC_DAWR1. That cap is
not even implemented in QEMU currently, so we never allow the guest to
set vcpu->arch.dawr1. If we check for kvm->arch.dawr1_enabled instead of
the CPU feature, we could shave some more time here.

> +		}
>  	}
>
>  	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
> @@ -951,15 +954,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
>  	mtspr(SPRN_HFSCR, host_hfscr);
>  	if (vcpu->arch.ciabr != host_ciabr)
>  		mtspr(SPRN_CIABR, host_ciabr);
> -	if (vcpu->arch.dawr0 != host_dawr0)
> -		mtspr(SPRN_DAWR0, host_dawr0);
> -	if (vcpu->arch.dawrx0 != host_dawrx0)
> -		mtspr(SPRN_DAWRX0, host_dawrx0);
> -	if (cpu_has_feature(CPU_FTR_DAWR1)) {
> -		if (vcpu->arch.dawr1 != host_dawr1)
> -			mtspr(SPRN_DAWR1, host_dawr1);
> -		if (vcpu->arch.dawrx1 != host_dawrx1)
> -			mtspr(SPRN_DAWRX1, host_dawrx1);
> +
> +	if (dawr_enabled()) {
> +		if (vcpu->arch.dawr0 != host_dawr0)
> +			mtspr(SPRN_DAWR0, host_dawr0);
> +		if (vcpu->arch.dawrx0 != host_dawrx0)
> +			mtspr(SPRN_DAWRX0, host_dawrx0);
> +		if (cpu_has_feature(CPU_FTR_DAWR1)) {
> +			if (vcpu->arch.dawr1 != host_dawr1)
> +				mtspr(SPRN_DAWR1, host_dawr1);
> +			if (vcpu->arch.dawrx1 != host_dawrx1)
> +				mtspr(SPRN_DAWRX1, host_dawrx1);
> +		}
>  	}
>
>  	if (vc->dpdes)
