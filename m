Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88730B59B
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhBBDEW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhBBDEL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:11 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2564EC061756
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:31 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so13966226pga.2
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C7LM1MCfv1LkeZNgYW7pT1x/HeLkdYRbZT0oDtnedyc=;
        b=GZAppGmHRveaQg9W1eJbapYEOa4wOy+VwTIXL0YuRRXvXZkUltiUNzhf6IU4DdTGap
         8vCoBGh0xGBimc739CsI64Z+ToY5EYbnsPgaWynegj8rRXYLbCgx5+clRrkiODQSyILa
         gL4NQLe1+0GiNHr0+3CY+L2rnZMhi3hApegJ16JDB5qOripR31DguztDILSJsn4/KrmH
         cxEpva3VJcJZor3Rccpa2+0REd6thWEguHmLCQbaPTTAkvsYmqwptL0pEuulTC43s6Oh
         lozc23lj5yueS0ubS2mZUEvZa8E8m4Elu8vKL0TbULPVDVsbKh9/WuEVF4wfK+UVAMrd
         KELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C7LM1MCfv1LkeZNgYW7pT1x/HeLkdYRbZT0oDtnedyc=;
        b=OypDAAphNuMLbUCae4uTQ9dtCRexoDrb/2c01e4HjnIEqVfz0i51ZjflDwznEszbOK
         MS/ybqVhoXVfQUzTZYnjEzWK517pxeciG/EJHo4wgjgpWAZHSMci5PPp6gDtZXRVEyI0
         J4kplKmTb0z68J9OhBJhAvrMdc9qRVgC9xiWOhLL362z3ubzhBZ5dZmrudrY2dpvoELD
         pF0oNJH9evrevHrhJ3+IiDRBb/5kbm7sdLYyDOs4DiqcfhwzLOd8qahNmeD6IhDRBcJP
         FA5dRU2Du1b7zgculRXdbbme3AKio4coo+BVaNoe8zCR5gSRPkOEQfvkMw7FLsNW1gky
         k2ow==
X-Gm-Message-State: AOAM531kVvijMchTOb3bbUlD9+wsbXvcwXr0LhcnZLUA+Yf6dlYWhKxo
        gwQUB/Keq/U72T39Ggvga/tSfgDjDMM=
X-Google-Smtp-Source: ABdhPJy0fRuIDKZqpS9k06ySD9Kttrzmlrj2vKYvTkP5mZHgxFY6+GGil17KPErvhmUO899Ma4CxnQ==
X-Received: by 2002:a05:6a00:2385:b029:1b6:1603:4ea3 with SMTP id f5-20020a056a002385b02901b616034ea3mr19423080pfc.40.1612235010404;
        Mon, 01 Feb 2021 19:03:30 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:30 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 2/9] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
Date:   Tue,  2 Feb 2021 13:03:06 +1000
Message-Id: <20210202030313.3509446-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
internal detail that has no real need to be in common handlers.

(XXX: Need to confirm CBE handlers etc)

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 64 ----------------------------
 arch/powerpc/kvm/book3s_64_entry.S   | 50 ++++++++++++++++++----
 2 files changed, 42 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 65659ea3cec4..e6f7fc7c61a1 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -133,7 +133,6 @@ name:
 #define IBRANCH_TO_COMMON	.L_IBRANCH_TO_COMMON_\name\() /* ENTRY branch to common */
 #define IREALMODE_COMMON	.L_IREALMODE_COMMON_\name\() /* Common runs in realmode */
 #define IMASK		.L_IMASK_\name\()	/* IRQ soft-mask bit */
-#define IKVM_SKIP	.L_IKVM_SKIP_\name\()	/* Generate KVM skip handler */
 #define IKVM_REAL	.L_IKVM_REAL_\name\()	/* Real entry tests KVM */
 #define __IKVM_REAL(name)	.L_IKVM_REAL_ ## name
 #define IKVM_VIRT	.L_IKVM_VIRT_\name\()	/* Virt entry tests KVM */
@@ -191,9 +190,6 @@ do_define_int n
 	.ifndef IMASK
 		IMASK=0
 	.endif
-	.ifndef IKVM_SKIP
-		IKVM_SKIP=0
-	.endif
 	.ifndef IKVM_REAL
 		IKVM_REAL=0
 	.endif
@@ -254,15 +250,10 @@ do_define_int n
 	.balign IFETCH_ALIGN_BYTES
 \name\()_kvm:
 
-	.if IKVM_SKIP
-	cmpwi	r10,KVM_GUEST_MODE_SKIP
-	beq	89f
-	.else
 BEGIN_FTR_SECTION
 	ld	r10,IAREA+EX_CFAR(r13)
 	std	r10,HSTATE_CFAR(r13)
 END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
-	.endif
 
 	ld	r10,IAREA+EX_CTR(r13)
 	mtctr	r10
@@ -289,27 +280,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ori	r12,r12,(IVEC)
 	.endif
 	b	kvmppc_interrupt
-
-	.if IKVM_SKIP
-89:	mtocrf	0x80,r9
-	ld	r10,IAREA+EX_CTR(r13)
-	mtctr	r10
-	ld	r9,IAREA+EX_R9(r13)
-	ld	r10,IAREA+EX_R10(r13)
-	ld	r11,IAREA+EX_R11(r13)
-	ld	r12,IAREA+EX_R12(r13)
-	.if IHSRR_IF_HVMODE
-	BEGIN_FTR_SECTION
-	b	kvmppc_skip_Hinterrupt
-	FTR_SECTION_ELSE
-	b	kvmppc_skip_interrupt
-	ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
-	.elseif IHSRR
-	b	kvmppc_skip_Hinterrupt
-	.else
-	b	kvmppc_skip_interrupt
-	.endif
-	.endif
 .endm
 
 #else
@@ -1128,7 +1098,6 @@ INT_DEFINE_BEGIN(machine_check)
 	ISET_RI=0
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(machine_check)
 
@@ -1419,7 +1388,6 @@ INT_DEFINE_BEGIN(data_access)
 	IVEC=0x300
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access)
 
@@ -1469,7 +1437,6 @@ INT_DEFINE_BEGIN(data_access_slb)
 	IAREA=PACA_EXSLB
 	IRECONCILE=0
 	IDAR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access_slb)
 
@@ -2116,7 +2083,6 @@ INT_DEFINE_BEGIN(h_data_storage)
 	IHSRR=1
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 	IKVM_VIRT=1
 INT_DEFINE_END(h_data_storage)
@@ -2573,7 +2539,6 @@ EXC_VIRT_NONE(0x5100, 0x100)
 INT_DEFINE_BEGIN(cbe_system_error)
 	IVEC=0x1200
 	IHSRR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(cbe_system_error)
 
@@ -2598,7 +2563,6 @@ EXC_VIRT_NONE(0x5200, 0x100)
 INT_DEFINE_BEGIN(instruction_breakpoint)
 	IVEC=0x1300
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	IKVM_SKIP=1
 	IKVM_REAL=1
 #endif
 INT_DEFINE_END(instruction_breakpoint)
@@ -2744,7 +2708,6 @@ EXC_COMMON_BEGIN(denorm_exception_common)
 INT_DEFINE_BEGIN(cbe_maintenance)
 	IVEC=0x1600
 	IHSRR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(cbe_maintenance)
 
@@ -2797,7 +2760,6 @@ EXC_COMMON_BEGIN(altivec_assist_common)
 INT_DEFINE_BEGIN(cbe_thermal)
 	IVEC=0x1800
 	IHSRR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(cbe_thermal)
 
@@ -3081,32 +3043,6 @@ EXPORT_SYMBOL(do_uaccess_flush)
 MASKED_INTERRUPT
 MASKED_INTERRUPT hsrr=1
 
-#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
-kvmppc_skip_interrupt:
-	/*
-	 * Here all GPRs are unchanged from when the interrupt happened
-	 * except for r13, which is saved in SPRG_SCRATCH0.
-	 */
-	mfspr	r13, SPRN_SRR0
-	addi	r13, r13, 4
-	mtspr	SPRN_SRR0, r13
-	GET_SCRATCH0(r13)
-	RFI_TO_KERNEL
-	b	.
-
-kvmppc_skip_Hinterrupt:
-	/*
-	 * Here all GPRs are unchanged from when the interrupt happened
-	 * except for r13, which is saved in SPRG_SCRATCH0.
-	 */
-	mfspr	r13, SPRN_HSRR0
-	addi	r13, r13, 4
-	mtspr	SPRN_HSRR0, r13
-	GET_SCRATCH0(r13)
-	HRFI_TO_KERNEL
-	b	.
-#endif
-
 	/*
 	 * Relocation-on interrupts: A subset of the interrupts can be delivered
 	 * with IR=1/DR=1, if AIL==2 and MSR.HV won't be changed by delivering
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 22e34b95f478..8e7216f3c3ee 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -1,9 +1,10 @@
+#include <asm/asm-offsets.h>
 #include <asm/cache.h>
-#include <asm/ppc_asm.h>
+#include <asm/exception-64s.h>
 #include <asm/kvm_asm.h>
-#include <asm/reg.h>
-#include <asm/asm-offsets.h>
 #include <asm/kvm_book3s_asm.h>
+#include <asm/ppc_asm.h>
+#include <asm/reg.h>
 
 /*
  * We come here from the first-level interrupt handlers.
@@ -18,17 +19,50 @@ kvmppc_interrupt:
 	 * guest R12 saved in shadow VCPU SCRATCH0
 	 * guest R13 saved in SPRN_SCRATCH0
 	 */
+	std	r9,HSTATE_SCRATCH2(r13)
+	lbz	r9,HSTATE_IN_GUEST(r13)
+	cmpwi	r9,KVM_GUEST_MODE_SKIP
+	beq	maybe_skip
+no_skip:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-	std	r9, HSTATE_SCRATCH2(r13)
-	lbz	r9, HSTATE_IN_GUEST(r13)
-	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
 	beq	kvmppc_bad_host_intr
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	cmpwi	r9, KVM_GUEST_MODE_GUEST
-	ld	r9, HSTATE_SCRATCH2(r13)
+	cmpwi	r9,KVM_GUEST_MODE_GUEST
+	ld	r9,HSTATE_SCRATCH2(r13)
 	beq	kvmppc_interrupt_pr
 #endif
 	b	kvmppc_interrupt_hv
 #else
 	b	kvmppc_interrupt_pr
 #endif
+
+maybe_skip:
+	cmpwi	r12,0x200
+	beq	1f
+	cmpwi	r12,0x300
+	beq	1f
+	cmpwi	r12,0x380
+	beq	1f
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	/* XXX: cbe stuff? instruction breakpoint? */
+	cmpwi	r12,0xe02
+	beq	2f
+#endif
+	b	no_skip
+1:	mfspr	r9,SPRN_SRR0
+	addi	r9,r9,4
+	mtspr	SPRN_SRR0,r9
+	ld	r12,HSTATE_SCRATCH0(r13)
+	ld	r9,HSTATE_SCRATCH2(r13)
+	GET_SCRATCH0(r13)
+	RFI_TO_KERNEL
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+2:	mfspr	r9,SPRN_HSRR0
+	addi	r9,r9,4
+	mtspr	SPRN_HSRR0,r9
+	ld	r12,HSTATE_SCRATCH0(r13)
+	ld	r9,HSTATE_SCRATCH2(r13)
+	GET_SCRATCH0(r13)
+	HRFI_TO_KERNEL
+#endif
-- 
2.23.0

