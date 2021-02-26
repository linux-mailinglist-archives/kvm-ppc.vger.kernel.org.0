Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948DF3265C7
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Feb 2021 17:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZQoI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 26 Feb 2021 11:44:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhBZQoE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 26 Feb 2021 11:44:04 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QGXEe4144147;
        Fri, 26 Feb 2021 11:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=tTQd8IOKfC1YlQjukCk55gM98ra90mieBbKfhPSLLrc=;
 b=lH4fdlWDuSJcSXy5Rpfa3f1ghOb6pvhjxP7PTZSuGLqEtZkJ7Ts1XShnKxt57QH/yGnQ
 KFJ9pcIBiD8udt2cAU09A8tv9hHGUw6/QbniqwDDmYNg2HMz9QrwLoTbnS7t17wvfcuJ
 u9awEysK81OvjmRJ+s+484jFILllz+ht16xMRd+2w1h+X4NxoWmIEuIntSkIrbEDAlzy
 92RqOSw3HcgBxmu4Ao5/RzpKmfmK/Nu8LrwYvLsyUdE5Qom4VYtRWwQ1d8p5QQNjVwbA
 79rTEiWQITakDisDvIW5vM5mKRjbSAo6gRewVyRJcNAVxI59Sr9Cc3yGYh0Z0ujB7TJ8 YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xn10kr7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 11:43:19 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11QGXww3147005;
        Fri, 26 Feb 2021 11:43:19 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xn10kr73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 11:43:19 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QGVvBm017106;
        Fri, 26 Feb 2021 16:38:18 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 36v5y9vf3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 16:38:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QGcHsl30343650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:38:18 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E22F1112065;
        Fri, 26 Feb 2021 16:38:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B93112063;
        Fri, 26 Feb 2021 16:38:17 +0000 (GMT)
Received: from localhost (unknown [9.65.76.206])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 26 Feb 2021 16:38:16 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 17/37] KVM: PPC: Book3S HV P9: Move setting HDEC
 after switching to guest LPCR
In-Reply-To: <20210225134652.2127648-18-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
 <20210225134652.2127648-18-npiggin@gmail.com>
Date:   Fri, 26 Feb 2021 13:38:15 -0300
Message-ID: <8735xiyebs.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_05:2021-02-26,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260123
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> LPCR[HDICE]=0 suppresses hypervisor decrementer exceptions on some
> processors, so it must be enabled before HDEC is set.
>
> Rather than set it in the host LPCR then setting HDEC, move the HDEC
> update to after the guest MMU context (including LPCR) is loaded.
> There shouldn't be much concern with delaying HDEC by some 10s or 100s
> of nanoseconds by setting it a bit later.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index d4770b222d7e..63cc92c45c5d 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3490,23 +3490,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>  		host_dawrx1 = mfspr(SPRN_DAWRX1);
>  	}
>
> -	/*
> -	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
> -	 * so set HDICE before writing HDEC.
> -	 */
> -	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
> -	isync();
> -
> -	hdec = time_limit - mftb();

Would it be possible to leave the mftb() in this patch and then replace
them all at once in patch 20/37 - "KVM: PPC: Book3S HV P9: Reduce mftb
per guest entry/exit"?

> -	if (hdec < 0) {
> -		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
> -		isync();
> +	tb = mftb();
> +	hdec = time_limit - tb;
> +	if (hdec < 0)
>  		return BOOK3S_INTERRUPT_HV_DECREMENTER;
> -	}
> -	mtspr(SPRN_HDEC, hdec);
>
>  	if (vc->tb_offset) {
> -		u64 new_tb = mftb() + vc->tb_offset;
> +		u64 new_tb = tb + vc->tb_offset;
>  		mtspr(SPRN_TBU40, new_tb);
>  		tb = mftb();
>  		if ((tb & 0xffffff) < (new_tb & 0xffffff))
> @@ -3549,6 +3539,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>
>  	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
>
> +	/*
> +	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
> +	 * so set guest LPCR (with HDICE) before writing HDEC.
> +	 */
> +	mtspr(SPRN_HDEC, hdec);
> +
>  	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
>  	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
