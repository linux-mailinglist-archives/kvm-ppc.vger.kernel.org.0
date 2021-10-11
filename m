Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4AB42970E
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Oct 2021 20:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhJKSqy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Oct 2021 14:46:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhJKSqx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 Oct 2021 14:46:53 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BIcmvA000880;
        Mon, 11 Oct 2021 14:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=NEkVtPBMwErX2ol+yOYDoAIZX4YFJ9tTBoiCo+yLHs8=;
 b=rSg+YYF9W6+njZt32JabZoYYIq0TmIKWtohuC5pJ90jZkibgyXCrpYOvjhIXjq9zVL3J
 aTYfmT9Q4yTe9YNctRLqkoY4DoRjCUtEJ9QM5BtuozU5+lxfGMvBd0ijxl6I9Pud1mCc
 GYIiMsOiLzlNTCq/J2IT7YkxFsODp7SbksLTaAVaclmQSdfK5c3nCUyC1eBXYeLcc7Q+
 0JqRYOoRRzgtrRWorTFRrg1dH4wO8kDDb++P0NvAAB2SfH1MguxT43znhk1D/68h4C/d
 dZSWI6bobUDn0yu226+UMOIuMVZHGYbiCULjFu5DvYrQLbeWP3NwrPsABvjm0Q1Cvoqj 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmsa9t2ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:44:48 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BIdTDd004642;
        Mon, 11 Oct 2021 14:44:48 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmsa9t2g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:44:48 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BIhFiI001699;
        Mon, 11 Oct 2021 18:44:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3bk2qakf4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 18:44:47 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BIikwm35979770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 18:44:46 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57943AC065;
        Mon, 11 Oct 2021 18:44:46 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41E9FAC060;
        Mon, 11 Oct 2021 18:44:45 +0000 (GMT)
Received: from localhost (unknown [9.211.66.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Oct 2021 18:44:44 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 02/52] powerpc/64s: guard optional TIDR SPR with CPU
 ftr test
In-Reply-To: <20211004160049.1338837-3-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
 <20211004160049.1338837-3-npiggin@gmail.com>
Date:   Mon, 11 Oct 2021 15:44:41 -0300
Message-ID: <87v9235rl2.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hR5DhmJGE9FcVR6Ei6iO0cGi7LzH_8BT
X-Proofpoint-ORIG-GUID: R5CtTMJHCA2YQh6S1Myw23hnudgo1f_Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_06,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110107
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> The TIDR SPR only exists on POWER9. Avoid accessing it when the
> feature bit for it is not set.

Not related to this patch, but how does this work with compat mode? A P9
compat mode guest would get an invalid instruction when trying to access
this SPR?

> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 12 ++++++++----
>  arch/powerpc/xmon/xmon.c     | 10 ++++++++--
>  2 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2acb1c96cfaf..f4a779fffd18 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3767,7 +3767,8 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
>  	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
>  	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
>  	mtspr(SPRN_BESCR, vcpu->arch.bescr);
> -	mtspr(SPRN_TIDR, vcpu->arch.tid);
> +	if (cpu_has_feature(CPU_FTR_P9_TIDR))
> +		mtspr(SPRN_TIDR, vcpu->arch.tid);
>  	mtspr(SPRN_AMR, vcpu->arch.amr);
>  	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
>
> @@ -3793,7 +3794,8 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
>  	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
>  	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
>  	vcpu->arch.bescr = mfspr(SPRN_BESCR);
> -	vcpu->arch.tid = mfspr(SPRN_TIDR);
> +	if (cpu_has_feature(CPU_FTR_P9_TIDR))
> +		vcpu->arch.tid = mfspr(SPRN_TIDR);
>  	vcpu->arch.amr = mfspr(SPRN_AMR);
>  	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
>  	vcpu->arch.dscr = mfspr(SPRN_DSCR);
> @@ -3813,7 +3815,8 @@ struct p9_host_os_sprs {
>  static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
>  {
>  	host_os_sprs->dscr = mfspr(SPRN_DSCR);
> -	host_os_sprs->tidr = mfspr(SPRN_TIDR);
> +	if (cpu_has_feature(CPU_FTR_P9_TIDR))
> +		host_os_sprs->tidr = mfspr(SPRN_TIDR);
>  	host_os_sprs->iamr = mfspr(SPRN_IAMR);
>  	host_os_sprs->amr = mfspr(SPRN_AMR);
>  	host_os_sprs->fscr = mfspr(SPRN_FSCR);
> @@ -3827,7 +3830,8 @@ static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
>  	mtspr(SPRN_UAMOR, 0);
>
>  	mtspr(SPRN_DSCR, host_os_sprs->dscr);
> -	mtspr(SPRN_TIDR, host_os_sprs->tidr);
> +	if (cpu_has_feature(CPU_FTR_P9_TIDR))
> +		mtspr(SPRN_TIDR, host_os_sprs->tidr);
>  	mtspr(SPRN_IAMR, host_os_sprs->iamr);
>
>  	if (host_os_sprs->amr != vcpu->arch.amr)
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index dd8241c009e5..7958e5aae844 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -2107,8 +2107,14 @@ static void dump_300_sprs(void)
>  	if (!cpu_has_feature(CPU_FTR_ARCH_300))
>  		return;
>
> -	printf("pidr   = %.16lx  tidr  = %.16lx\n",
> -		mfspr(SPRN_PID), mfspr(SPRN_TIDR));
> +	if (cpu_has_feature(CPU_FTR_P9_TIDR)) {
> +		printf("pidr   = %.16lx  tidr  = %.16lx\n",
> +			mfspr(SPRN_PID), mfspr(SPRN_TIDR));
> +	} else {
> +		printf("pidr   = %.16lx\n",
> +			mfspr(SPRN_PID));
> +	}
> +
>  	printf("psscr  = %.16lx\n",
>  		hv ? mfspr(SPRN_PSSCR) : mfspr(SPRN_PSSCR_PR));
