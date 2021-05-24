Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC77538E6F1
	for <lists+kvm-ppc@lfdr.de>; Mon, 24 May 2021 14:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhEXMv3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 24 May 2021 08:51:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4284 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232538AbhEXMv3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 24 May 2021 08:51:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14OCjHwR079378;
        Mon, 24 May 2021 08:49:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=bwElT0fLkpFMHgKjR4eFnzcFeSaApyor+I5c7m6WJdc=;
 b=j2n1RHg9i1Jur9qoPBAT3m06rNNq3KydIsmFCwmHbRA/Zp5rpq0OfI33LiR6aEy/RJw4
 jE7RlqSEQPTmnfj0RE+KlfY5Ub8gnN8ge8A9CpfV7+741OwAkInsQPm4wAYSt90Ei956
 C7TbSymfM6n77BjVEP6dvl+LSfO03XHaVrkh1nhzwsNoFrdj2/mioVSzdItxWjhmcYO/
 g84foD2cNiEqT59zEtmGwfaU/Fr3zbkWqfg21jtgbq1yr1I3BeRvyU6h6yyUWSNVOKMm
 BeiJWAFbzHb0h8rj/iDZl8muILXeTZdi1M7dxTYK+H4X4or7Faf38mMO0+lYU9p3cWlR Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38rce0042u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 08:49:52 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14OCjLnN079518;
        Mon, 24 May 2021 08:49:51 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38rce0042b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 08:49:51 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14OClEY5022895;
        Mon, 24 May 2021 12:49:50 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 38q65s3g63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 12:49:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14OCnnaP27984336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 12:49:49 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8DFABE053;
        Mon, 24 May 2021 12:49:49 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D32D6BE051;
        Mon, 24 May 2021 12:49:48 +0000 (GMT)
Received: from localhost (unknown [9.211.108.253])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 24 May 2021 12:49:48 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Neuling <mikey@neuling.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
In-Reply-To: <20210523122101.3247232-1-npiggin@gmail.com>
References: <20210523122101.3247232-1-npiggin@gmail.com>
Date:   Mon, 24 May 2021 09:49:46 -0300
Message-ID: <87fsyc1el1.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Os_C40KnRAWRHOhawvbEfQY1WSJRyEPn
X-Proofpoint-GUID: lr_9F0lIsKI9in2HR4dgDvJNshBTn1Fg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_07:2021-05-24,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=705 suspectscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240082
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
> FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
> FSCR. The logic explained in that patch actually applies there to the
> old path well: a context switch can be made before kvmppc_vcpu_run_hv
> restores the host FSCR and returns.
>
> Fixes: b005255e12a3 ("KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 5e634db4809b..2b98e710c7a1 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -44,7 +44,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
>  #define NAPPING_UNSPLIT	3
>  
>  /* Stack frame offsets for kvmppc_hv_entry */
> -#define SFS			208
> +#define SFS			216
>  #define STACK_SLOT_TRAP		(SFS-4)
>  #define STACK_SLOT_SHORT_PATH	(SFS-8)
>  #define STACK_SLOT_TID		(SFS-16)
> @@ -59,8 +59,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
>  #define STACK_SLOT_UAMOR	(SFS-88)
>  #define STACK_SLOT_DAWR1	(SFS-96)
>  #define STACK_SLOT_DAWRX1	(SFS-104)
> +#define STACK_SLOT_FSCR		(SFS-112)
>  /* the following is used by the P9 short path */
> -#define STACK_SLOT_NVGPRS	(SFS-152)	/* 18 gprs */
> +#define STACK_SLOT_NVGPRS	(SFS-160)	/* 18 gprs */
>  
>  /*
>   * Call kvmppc_hv_entry in real mode.
> @@ -686,6 +687,8 @@ BEGIN_FTR_SECTION
>  	std	r6, STACK_SLOT_DAWR0(r1)
>  	std	r7, STACK_SLOT_DAWRX0(r1)
>  	std	r8, STACK_SLOT_IAMR(r1)
> +	mfspr	r5, SPRN_FSCR
> +	std	r5, STACK_SLOT_FSCR(r1)
>  END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
>  BEGIN_FTR_SECTION
>  	mfspr	r6, SPRN_DAWR1
> @@ -1663,6 +1666,10 @@ FTR_SECTION_ELSE
>  	ld	r7, STACK_SLOT_HFSCR(r1)
>  	mtspr	SPRN_HFSCR, r7
>  ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
> +BEGIN_FTR_SECTION
> +	ld	r5, STACK_SLOT_FSCR(r1)
> +	mtspr	SPRN_FSCR, r5
> +END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
>  	/*
>  	 * Restore various registers to 0, where non-zero values
>  	 * set by the guest could disrupt the host.

So it seems this line in kvmppc_vcpu_run_hv loses its purpose now?

        do{
        (...)
	} while (is_kvmppc_resume_guest(r));

        /* Restore userspace EBB and other register values */
        if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
                mtspr(SPRN_EBBHR, ebb_regs[0]);
                mtspr(SPRN_EBBRR, ebb_regs[1]);
                mtspr(SPRN_BESCR, ebb_regs[2]);
                mtspr(SPRN_TAR, user_tar);
--->            mtspr(SPRN_FSCR, current->thread.fscr);
        }
