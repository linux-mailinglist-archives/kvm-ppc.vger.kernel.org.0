Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC1F32B16F
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Mar 2021 04:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhCCAps (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Mar 2021 19:45:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52504 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1448542AbhCBPFh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Mar 2021 10:05:37 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122F3Krc105426;
        Tue, 2 Mar 2021 10:04:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=7WpMv3KtE7paoEclZjmENr81M1rK2Pl1F+K2QizuVsM=;
 b=rbWgZPI+Y8Q1b0mYpr+9jhQKuKFm+K1KIaoBn1RYaFyYwppeyf1kqF4TCpgW1HKIjz0D
 Wh0R+l6/OVGyOcDkazdgBSly/PQ+07tdFIJSb91EVi4eJLnBk+HTdt6aG3Q6IPzmfK+E
 kxybqqcWsDsan4ArJhiAgmfCbIIa9Y/2kpj6fDu31K8v1ewoa1fo+rBMFiwLC27Tbpxy
 tKwW6av0klz//0KOgRq8CjyvBQy06FpN9Iru38vWpzk0GbxgSGx0ppC/062K0m5GFxkI
 78qnDz2djTqQVipmtU/juCZsfiC/7GWk0RFTHD1MfUMUslGviTcJ/AqtCMPlpvebreMp UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371pxk9ukx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 10:04:50 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122F4Edh115133;
        Tue, 2 Mar 2021 10:04:49 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 371pxk9ukp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 10:04:49 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122F219F030990;
        Tue, 2 Mar 2021 15:04:49 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3712phfukc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 15:04:49 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122F4mEI40305132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 15:04:48 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9D4AAC05B;
        Tue,  2 Mar 2021 15:04:48 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 748F6AC062;
        Tue,  2 Mar 2021 15:04:47 +0000 (GMT)
Received: from localhost (unknown [9.211.36.193])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue,  2 Mar 2021 15:04:47 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 28/37] KVM: PPC: Book3S HV P9: Add helpers for OS SPR
 handling
In-Reply-To: <20210225134652.2127648-29-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
 <20210225134652.2127648-29-npiggin@gmail.com>
Date:   Tue, 02 Mar 2021 12:04:44 -0300
Message-ID: <87pn0hwq9f.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_06:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 mlxscore=0 phishscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020123
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> This is a first step to wrapping supervisor and user SPR saving and
> loading up into helpers, which will then be called independently in
> bare metal and nested HV cases in order to optimise SPR access.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

<snip>

> +/* vcpu guest regs must already be saved */
> +static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
> +				    struct p9_host_os_sprs *host_os_sprs)
> +{
> +	mtspr(SPRN_PSPB, 0);
> +	mtspr(SPRN_WORT, 0);
> +	mtspr(SPRN_UAMOR, 0);
> +	mtspr(SPRN_PSPB, 0);

Not your fault, but PSPB is set twice here.

> +
> +	mtspr(SPRN_DSCR, host_os_sprs->dscr);
> +	mtspr(SPRN_TIDR, host_os_sprs->tidr);
> +	mtspr(SPRN_IAMR, host_os_sprs->iamr);
> +
> +	if (host_os_sprs->amr != vcpu->arch.amr)
> +		mtspr(SPRN_AMR, host_os_sprs->amr);
> +
> +	if (host_os_sprs->fscr != vcpu->arch.fscr)
> +		mtspr(SPRN_FSCR, host_os_sprs->fscr);
> +}
> +

<snip>

> @@ -3605,34 +3666,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	vcpu->arch.dec_expires = dec + tb;
>  	vcpu->cpu = -1;
>  	vcpu->arch.thread_cpu = -1;
> -	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
> -
> -	vcpu->arch.iamr = mfspr(SPRN_IAMR);
> -	vcpu->arch.pspb = mfspr(SPRN_PSPB);
> -	vcpu->arch.fscr = mfspr(SPRN_FSCR);
> -	vcpu->arch.tar = mfspr(SPRN_TAR);
> -	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
> -	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
> -	vcpu->arch.bescr = mfspr(SPRN_BESCR);
> -	vcpu->arch.wort = mfspr(SPRN_WORT);
> -	vcpu->arch.tid = mfspr(SPRN_TIDR);
> -	vcpu->arch.amr = mfspr(SPRN_AMR);
> -	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
> -	vcpu->arch.dscr = mfspr(SPRN_DSCR);
> -
> -	mtspr(SPRN_PSPB, 0);
> -	mtspr(SPRN_WORT, 0);
> -	mtspr(SPRN_UAMOR, 0);
> -	mtspr(SPRN_DSCR, host_dscr);
> -	mtspr(SPRN_TIDR, host_tidr);
> -	mtspr(SPRN_IAMR, host_iamr);
> -	mtspr(SPRN_PSPB, 0);
>
> -	if (host_amr != vcpu->arch.amr)
> -		mtspr(SPRN_AMR, host_amr);
> +	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
>
> -	if (host_fscr != vcpu->arch.fscr)
> -		mtspr(SPRN_FSCR, host_fscr);
> +	store_spr_state(vcpu);

store_spr_state should come first, right? We want to save the guest
state before restoring the host state.

>
>  	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
>  	store_fp_state(&vcpu->arch.fp);
