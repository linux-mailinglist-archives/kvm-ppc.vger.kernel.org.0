Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1558C2FAE61
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Jan 2021 02:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbhASBkq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 20:40:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49664 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729202AbhASBkp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 20:40:45 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10J1VDGH022172;
        Mon, 18 Jan 2021 20:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=vCnPONhsbszbjEO+eNVCR6n012BR8Inlxk4aaej4GK4=;
 b=Zo8+ZDwbkWobMpPWjsP8yhDeUYmMTGiKHIyuAVssfHwJV5AneHNuCm1NXuhTMsFqKmhQ
 7iLMGWLNk0qjX25JxvTobuH0rIK43F+/BEQOvNXMATG8SMOpDDnbqQ8AP4KGTHOLm4jz
 9AKNpirYPEEIvakkFNYA/QENbXHKTvHTA/bvI1jkhL63JSp79Lv4bzTm43LVZc1v5Q7t
 UGyg7VINuaAYeNeIBDwihgObbA0Qy1XQvSrYs9QtxqBHO0PTlfzry9nkmaKEZle1puDL
 J+0ZAPbK8sIOrggvOsqsqLonFRZ12tov5noEL9HICt6lB7UQszGNhovtFvDhucncJev0 xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365gs0eg6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 20:39:47 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10J1Xpp0031960;
        Mon, 18 Jan 2021 20:39:46 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365gs0eg62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 20:39:46 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10J1VYCx019261;
        Tue, 19 Jan 2021 01:39:46 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 363qs8twvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 01:39:45 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10J1djdU26739002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 01:39:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79A37112062;
        Tue, 19 Jan 2021 01:39:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA1C112061;
        Tue, 19 Jan 2021 01:39:44 +0000 (GMT)
Received: from localhost (unknown [9.211.51.53])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 19 Jan 2021 01:39:44 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] KVM: PPC: Book3S HV: Fix radix guest SLB side channel
In-Reply-To: <20210118062809.1430920-3-npiggin@gmail.com>
References: <20210118062809.1430920-1-npiggin@gmail.com>
 <20210118062809.1430920-3-npiggin@gmail.com>
Date:   Mon, 18 Jan 2021 22:39:41 -0300
Message-ID: <87ft2xbt7m.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_15:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190003
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> The slbmte instruction is legal in radix mode, including radix guest
> mode. This means radix guests can load the SLB with arbitrary data.
>
> KVM host does not clear the SLB when exiting a guest if it was a
> radix guest, which would allow a rogue radix guest to use the SLB as
> a side channel to communicate with other guests.
>
> Fix this by ensuring the SLB is cleared when coming out of a radix
> guest. Only the first 4 entries are a concern, because radix guests
> always run with LPCR[UPRT]=1, which limits the reach of slbmte. slbia
> is not used (except in a non-performance-critical path) because it
> can clear cached translations.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 39 ++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index d5a9b57ec129..0e1f5bf168a1 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1157,6 +1157,20 @@ EXPORT_SYMBOL_GPL(__kvmhv_vcpu_entry_p9)
>  	mr	r4, r3
>  	b	fast_guest_entry_c
>  guest_exit_short_path:
> +	/*
> +	 * Malicious or buggy radix guests may have inserted SLB entries
> +	 * (only 0..3 because radix always runs with UPRT=1), so these must
> +	 * be cleared here to avoid side-channels. slbmte is used rather
> +	 * than slbia, as it won't clear cached translations.
> +	 */
> +	li	r0,0
> +	slbmte	r0,r0
> +	li	r4,1
> +	slbmte	r0,r4
> +	li	r4,2
> +	slbmte	r0,r4
> +	li	r4,3
> +	slbmte	r0,r4
>
>  	li	r0, KVM_GUEST_MODE_NONE
>  	stb	r0, HSTATE_IN_GUEST(r13)
> @@ -1469,7 +1483,7 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
>  	lbz	r0, KVM_RADIX(r5)
>  	li	r5, 0
>  	cmpwi	r0, 0
> -	bne	3f			/* for radix, save 0 entries */
> +	bne	0f			/* for radix, save 0 entries */
>  	lwz	r0,VCPU_SLB_NR(r9)	/* number of entries in SLB */
>  	mtctr	r0
>  	li	r6,0
> @@ -1490,12 +1504,9 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
>  	slbmte	r0,r0
>  	slbia
>  	ptesync
> -3:	stw	r5,VCPU_SLB_MAX(r9)
> +	stw	r5,VCPU_SLB_MAX(r9)
>
>  	/* load host SLB entries */
> -BEGIN_MMU_FTR_SECTION
> -	b	0f
> -END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
>  	ld	r8,PACA_SLBSHADOWPTR(r13)
>
>  	.rept	SLB_NUM_BOLTED
> @@ -1508,7 +1519,17 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
>  	slbmte	r6,r5
>  1:	addi	r8,r8,16
>  	.endr
> -0:
> +	b	guest_bypass
> +
> +0:	/* Sanitise radix guest SLB, see guest_exit_short_path comment. */
> +	li	r0,0
> +	slbmte	r0,r0
> +	li	r4,1
> +	slbmte	r0,r4
> +	li	r4,2
> +	slbmte	r0,r4
> +	li	r4,3
> +	slbmte	r0,r4
>
>  guest_bypass:
>  	stw	r12, STACK_SLOT_TRAP(r1)
> @@ -3302,12 +3323,14 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
>  	mtspr	SPRN_CIABR, r0
>  	mtspr	SPRN_DAWRX0, r0
>
> +	/* Clear hash and radix guest SLB, see guest_exit_short_path comment. */
> +	slbmte	r0, r0
> +	slbia
> +
>  BEGIN_MMU_FTR_SECTION
>  	b	4f
>  END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
>
> -	slbmte	r0, r0
> -	slbia
>  	ptesync
>  	ld	r8, PACA_SLBSHADOWPTR(r13)
>  	.rept	SLB_NUM_BOLTED
