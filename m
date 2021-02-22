Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56840322247
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 23:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhBVWlx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 17:41:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231691AbhBVWlv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 17:41:51 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MMWkoX010253;
        Mon, 22 Feb 2021 17:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=mPXl1s51vI+IzPBxEkK6UTc8TmutK7bZotIZsA9kpMQ=;
 b=FC5lVuAUtB/ALnTzprhz2Z/vzm3fI2BrMke+03/qAKbEgD3kM48v9lnsfzm6H3kd4RQg
 s0whAX+H7DjapRM4reI7aTgwuvulGZKcEWM67BRPyGdhCZX8v/XIPF/PbqPE8ppHsi0F
 brMz/Ym6QgY3NsAGwHPcuynKWr1U6Gw2MJh9RizYKKp5Q1AiqtxTUa97fJVGmTdEgueM
 +wuJzC4lRJFYKxNMknXrdwYAlDENSdP7jSfoYwgDy6LLNgqUAt6Sr3J5Z4lm4ra3JkRD
 qVx7gmzvPAjZ/UnLhEP8PDKn5gYjwz4JFM/ERIS4ELaUyHggS/usWPuffB2jAz3qISva lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkf7v610-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:41:07 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MMbWhj028828;
        Mon, 22 Feb 2021 17:41:06 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkf7v5xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:41:06 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11MMWOaU013897;
        Mon, 22 Feb 2021 22:41:02 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 36tt28t9ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 22:41:02 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11MMf13Z12452182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 22:41:01 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4CD8AE071;
        Mon, 22 Feb 2021 22:41:01 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9637BAE06B;
        Mon, 22 Feb 2021 22:41:00 +0000 (GMT)
Received: from localhost (unknown [9.160.141.72])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Feb 2021 22:41:00 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 06/13] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test
 into KVM
In-Reply-To: <20210219063542.1425130-7-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
 <20210219063542.1425130-7-npiggin@gmail.com>
Date:   Mon, 22 Feb 2021 19:40:58 -0300
Message-ID: <87eeh7ybd1.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_07:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220194
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
> internal detail that has no real need to be in common handlers.
>
> Also add a comment explaining why this this thing exists.

this this

>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kernel/exceptions-64s.S | 60 --------------------------
>  arch/powerpc/kvm/book3s_64_entry.S   | 64 ++++++++++++++++++++++++----
>  2 files changed, 56 insertions(+), 68 deletions(-)
>
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index a1640d6ea65d..96f22c582213 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -133,7 +133,6 @@ name:
>  #define IBRANCH_TO_COMMON	.L_IBRANCH_TO_COMMON_\name\() /* ENTRY branch to common */
>  #define IREALMODE_COMMON	.L_IREALMODE_COMMON_\name\() /* Common runs in realmode */
>  #define IMASK		.L_IMASK_\name\()	/* IRQ soft-mask bit */
> -#define IKVM_SKIP	.L_IKVM_SKIP_\name\()	/* Generate KVM skip handler */
>  #define IKVM_REAL	.L_IKVM_REAL_\name\()	/* Real entry tests KVM */
>  #define __IKVM_REAL(name)	.L_IKVM_REAL_ ## name
>  #define IKVM_VIRT	.L_IKVM_VIRT_\name\()	/* Virt entry tests KVM */
> @@ -191,9 +190,6 @@ do_define_int n
>  	.ifndef IMASK
>  		IMASK=0
>  	.endif
> -	.ifndef IKVM_SKIP
> -		IKVM_SKIP=0
> -	.endif
>  	.ifndef IKVM_REAL
>  		IKVM_REAL=0
>  	.endif
> @@ -254,15 +250,10 @@ do_define_int n
>  	.balign IFETCH_ALIGN_BYTES
>  \name\()_kvm:
>
> -	.if IKVM_SKIP
> -	cmpwi	r10,KVM_GUEST_MODE_SKIP
> -	beq	89f
> -	.else
>  BEGIN_FTR_SECTION
>  	ld	r10,IAREA+EX_CFAR(r13)
>  	std	r10,HSTATE_CFAR(r13)
>  END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
> -	.endif
>
>  	ld	r10,IAREA+EX_CTR(r13)
>  	mtctr	r10
> @@ -289,27 +280,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
>  	ori	r12,r12,(IVEC)
>  	.endif
>  	b	kvmppc_interrupt
> -
> -	.if IKVM_SKIP
> -89:	mtocrf	0x80,r9
> -	ld	r10,IAREA+EX_CTR(r13)
> -	mtctr	r10
> -	ld	r9,IAREA+EX_R9(r13)
> -	ld	r10,IAREA+EX_R10(r13)
> -	ld	r11,IAREA+EX_R11(r13)
> -	ld	r12,IAREA+EX_R12(r13)
> -	.if IHSRR_IF_HVMODE
> -	BEGIN_FTR_SECTION
> -	b	kvmppc_skip_Hinterrupt
> -	FTR_SECTION_ELSE
> -	b	kvmppc_skip_interrupt
> -	ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
> -	.elseif IHSRR
> -	b	kvmppc_skip_Hinterrupt
> -	.else
> -	b	kvmppc_skip_interrupt
> -	.endif
> -	.endif
>  .endm
>
>  #else
> @@ -1128,7 +1098,6 @@ INT_DEFINE_BEGIN(machine_check)
>  	ISET_RI=0
>  	IDAR=1
>  	IDSISR=1
> -	IKVM_SKIP=1
>  	IKVM_REAL=1
>  INT_DEFINE_END(machine_check)
>
> @@ -1419,7 +1388,6 @@ INT_DEFINE_BEGIN(data_access)
>  	IVEC=0x300
>  	IDAR=1
>  	IDSISR=1
> -	IKVM_SKIP=1
>  	IKVM_REAL=1
>  INT_DEFINE_END(data_access)
>
> @@ -1465,7 +1433,6 @@ INT_DEFINE_BEGIN(data_access_slb)
>  	IVEC=0x380
>  	IRECONCILE=0
>  	IDAR=1
> -	IKVM_SKIP=1
>  	IKVM_REAL=1
>  INT_DEFINE_END(data_access_slb)
>
> @@ -2111,7 +2078,6 @@ INT_DEFINE_BEGIN(h_data_storage)
>  	IHSRR=1
>  	IDAR=1
>  	IDSISR=1
> -	IKVM_SKIP=1
>  	IKVM_REAL=1
>  	IKVM_VIRT=1
>  INT_DEFINE_END(h_data_storage)
> @@ -3088,32 +3054,6 @@ EXPORT_SYMBOL(do_uaccess_flush)
>  MASKED_INTERRUPT
>  MASKED_INTERRUPT hsrr=1
>
> -#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
> -kvmppc_skip_interrupt:
> -	/*
> -	 * Here all GPRs are unchanged from when the interrupt happened
> -	 * except for r13, which is saved in SPRG_SCRATCH0.
> -	 */
> -	mfspr	r13, SPRN_SRR0
> -	addi	r13, r13, 4
> -	mtspr	SPRN_SRR0, r13
> -	GET_SCRATCH0(r13)
> -	RFI_TO_KERNEL
> -	b	.
> -
> -kvmppc_skip_Hinterrupt:
> -	/*
> -	 * Here all GPRs are unchanged from when the interrupt happened
> -	 * except for r13, which is saved in SPRG_SCRATCH0.
> -	 */
> -	mfspr	r13, SPRN_HSRR0
> -	addi	r13, r13, 4
> -	mtspr	SPRN_HSRR0, r13
> -	GET_SCRATCH0(r13)
> -	HRFI_TO_KERNEL
> -	b	.
> -#endif
> -
>  	/*
>  	 * Relocation-on interrupts: A subset of the interrupts can be delivered
>  	 * with IR=1/DR=1, if AIL==2 and MSR.HV won't be changed by delivering
> diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
> index 147ebf1c3c1f..820d103e5f50 100644
> --- a/arch/powerpc/kvm/book3s_64_entry.S
> +++ b/arch/powerpc/kvm/book3s_64_entry.S
> @@ -1,9 +1,10 @@
> +#include <asm/asm-offsets.h>
>  #include <asm/cache.h>
> -#include <asm/ppc_asm.h>
> +#include <asm/exception-64s.h>
>  #include <asm/kvm_asm.h>
> -#include <asm/reg.h>
> -#include <asm/asm-offsets.h>
>  #include <asm/kvm_book3s_asm.h>
> +#include <asm/ppc_asm.h>
> +#include <asm/reg.h>
>
>  /*
>   * This is branched to from interrupt handlers in exception-64s.S which set
> @@ -19,17 +20,64 @@ kvmppc_interrupt:
>  	 * guest R12 saved in shadow VCPU SCRATCH0
>  	 * guest R13 saved in SPRN_SCRATCH0
>  	 */
> +	std	r9,HSTATE_SCRATCH2(r13)
> +	lbz	r9,HSTATE_IN_GUEST(r13)
> +	cmpwi	r9,KVM_GUEST_MODE_SKIP
> +	beq-	.Lmaybe_skip
> +.Lno_skip:
>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> -	std	r9, HSTATE_SCRATCH2(r13)
> -	lbz	r9, HSTATE_IN_GUEST(r13)
> -	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
> +	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
>  	beq	kvmppc_bad_host_intr
>  #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
> -	cmpwi	r9, KVM_GUEST_MODE_GUEST
> -	ld	r9, HSTATE_SCRATCH2(r13)
> +	cmpwi	r9,KVM_GUEST_MODE_GUEST
> +	ld	r9,HSTATE_SCRATCH2(r13)
>  	beq	kvmppc_interrupt_pr
>  #endif
>  	b	kvmppc_interrupt_hv
>  #else
>  	b	kvmppc_interrupt_pr
>  #endif
> +
> +/*
> + * KVM uses a trick where it is running in MSR[HV]=1 mode in real-mode with the
> + * guest MMU context loaded, and it sets KVM_GUEST_MODE_SKIP and enables
> + * MSR[DR]=1 while leaving MSR[IR]=0, so it continues to fetch HV instructions
> + * but loads and stores will access the guest context. This is used to load
> + * the faulting instruction without walking page tables.
> + *
> + * However the guest context may not be able to translate, or it may cause a
> + * machine check or other issue, which will result in a fault in the host
> + * (even with KVM-HV).
> + *
> + * These faults are caught here and if the fault was (or was likely) due to
> + * that load, then we just return with the PC advanced +4 and skip the load,
> + * which then goes via the slow path.
> + */
> +.Lmaybe_skip:
> +	cmpwi	r12,BOOK3S_INTERRUPT_MACHINE_CHECK
> +	beq	1f
> +	cmpwi	r12,BOOK3S_INTERRUPT_DATA_STORAGE
> +	beq	1f
> +	cmpwi	r12,BOOK3S_INTERRUPT_DATA_SEGMENT
> +	beq	1f
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	cmpwi	r12,BOOK3S_INTERRUPT_H_DATA_STORAGE | 0x2
> +	beq	2f
> +#endif
> +	b	.Lno_skip
> +1:	mfspr	r9,SPRN_SRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_SRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	RFI_TO_KERNEL
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +2:	mfspr	r9,SPRN_HSRR0
> +	addi	r9,r9,4
> +	mtspr	SPRN_HSRR0,r9
> +	ld	r12,HSTATE_SCRATCH0(r13)
> +	ld	r9,HSTATE_SCRATCH2(r13)
> +	GET_SCRATCH0(r13)
> +	HRFI_TO_KERNEL
> +#endif
