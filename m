Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80B331549
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Mar 2021 18:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCHRxg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 12:53:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9278 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhCHRxI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 12:53:08 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128HWp87049840;
        Mon, 8 Mar 2021 12:53:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=SZU0O+S9tZ7GIaCUkKek/uE6KYTE8bt7InaKzi6e84A=;
 b=HWNCD/A6pFQb/JWnBw5zAm9kOLfoak/wnVKnUdFB+T9alDQdBWKXEEv43Rx6DxnYJ6fr
 7gdWAqwjUZlFhQALaITj8ma9wD8+obfOds9CBp05lNHN/Opbm1+M0hjswmYb3SywvmrT
 m0CKz1J2qepYcFwcS4YoIcAaOeSLnZ6+jf7/Lc799SCwn3TY3w81dmKxB6HarsaZejOz
 X2ht/Op2mPXt/ZAbeUsck8xbjrdbRiKAnh2tCt99sKLWJjwS4OpWUZLBizh209M4DHkk
 h6EayaKMVjZu4qZsrKCGC7/uH/GczOFkTHnZ6G9KWYjyBsnnJI2HroSiRHAZ/c0ApZDx 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375q3pb1cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 12:53:03 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128HaPoP066249;
        Mon, 8 Mar 2021 12:53:02 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375q3pb1cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 12:53:02 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128Hm0Gf001704;
        Mon, 8 Mar 2021 17:53:02 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3741c88d23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 17:53:02 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128Hr1LS22282506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 17:53:01 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86ADBAE060;
        Mon,  8 Mar 2021 17:53:01 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B559FAE05F;
        Mon,  8 Mar 2021 17:53:00 +0000 (GMT)
Received: from localhost (unknown [9.163.6.5])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Mar 2021 17:53:00 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 20/41] KVM: PPC: Book3S HV P9: Move setting HDEC
 after switching to guest LPCR
In-Reply-To: <20210305150638.2675513-21-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-21-npiggin@gmail.com>
Date:   Mon, 08 Mar 2021 14:52:57 -0300
Message-ID: <875z21mt1i.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_14:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080093
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

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 1f2ba8955c6a..ffde1917ab68 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3505,20 +3505,9 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
>  	hdec = time_limit - mftb();
> -	if (hdec < 0) {
> -		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
> -		isync();
> +	if (hdec < 0)
>  		return BOOK3S_INTERRUPT_HV_DECREMENTER;
> -	}
> -	mtspr(SPRN_HDEC, hdec);
>
>  	if (vc->tb_offset) {
>  		u64 new_tb = mftb() + vc->tb_offset;
> @@ -3564,6 +3553,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
