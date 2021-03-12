Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BB1338DE6
	for <lists+kvm-ppc@lfdr.de>; Fri, 12 Mar 2021 13:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCLM4B (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Mar 2021 07:56:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30732 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231179AbhCLMzg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Mar 2021 07:55:36 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CCoVxo098940;
        Fri, 12 Mar 2021 07:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=CZraW3MLXsGZlFWIXQunR5iKvo4efs3ARmrIvH7smV0=;
 b=kdmJmnnsMKXuEmWZOuMf7s7iV6TMAecfmqZhAziTu7p6X4vp9zARCsAJF6RaqIw54sJC
 M6JfXwnR4QJXb+uK+DNNuySj/97U5tk3NZXfsgaQgHGO2DvTx/uaHoiiu/R7kZlTU00/
 zwwUrdboYiCYtvaRFNyMkn+Ffx0XjAEsDIHsCKjtULM4kOPH5NVk44ousNxzgbpJLGBf
 1rckNi0o3pypo+mokZ/AwPGCL06We013odqVZjAa3FtOrNAYooE/kPlJUxdlYKcRWP/Q
 D9QdvFF/hYlDuxslK4F1sNqYZwSBTzOvF6Vo5dCQa1AIBkPY5atEvMzQ21uy23RD2E3P pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m6s7qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 07:55:32 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CCoXfi099116;
        Fri, 12 Mar 2021 07:55:31 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m6s7qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 07:55:31 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CCh0xr005916;
        Fri, 12 Mar 2021 12:55:31 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3768swfevk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 12:55:31 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CCtPrS31916300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 12:55:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 348D978064;
        Fri, 12 Mar 2021 12:55:25 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79AA278063;
        Fri, 12 Mar 2021 12:55:24 +0000 (GMT)
Received: from localhost (unknown [9.211.65.7])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri, 12 Mar 2021 12:55:24 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 23/41] KVM: PPC: Book3S HV P9: Reduce mftb per guest
 entry/exit
In-Reply-To: <20210305150638.2675513-24-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
 <20210305150638.2675513-24-npiggin@gmail.com>
Date:   Fri, 12 Mar 2021 09:55:22 -0300
Message-ID: <87y2essf9h.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120088
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> mftb is serialising (dispatch next-to-complete) so it is heavy weight
> for a mfspr. Avoid reading it multiple times in the entry or exit paths.
> A small number of cycles delay to timers is tolerable.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index c1965a9d8d00..6f3e3aed99aa 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3505,12 +3505,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
>  		host_dawrx1 = mfspr(SPRN_DAWRX1);
>  	}
>
> -	hdec = time_limit - mftb();
> +	tb = mftb();
> +	hdec = time_limit - tb;
>  	if (hdec < 0)
>  		return BOOK3S_INTERRUPT_HV_DECREMENTER;
>
>  	if (vc->tb_offset) {
> -		u64 new_tb = mftb() + vc->tb_offset;
> +		u64 new_tb = tb + vc->tb_offset;
>  		mtspr(SPRN_TBU40, new_tb);
>  		tb = mftb();
>  		if ((tb & 0xffffff) < (new_tb & 0xffffff))
> @@ -3703,7 +3704,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	if (!(vcpu->arch.ctrl & 1))
>  		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
>
> -	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
> +	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
>
>  	if (kvmhv_on_pseries()) {
>  		/*
> @@ -3837,7 +3838,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	vc->entry_exit_map = 0x101;
>  	vc->in_guest = 0;
>
> -	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
> +	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - tb);
>  	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
>
>  	kvmhv_load_host_pmu();
