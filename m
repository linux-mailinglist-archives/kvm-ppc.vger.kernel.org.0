Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDFF353A93
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhDEBVB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbhDEBUz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:55 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC1FC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s11so7209237pfm.1
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QnAH6vLwG/CSAZMFY7f9tw3x1aO5kQ0YxBlmG9hsOF8=;
        b=JLNGMtIdz1cBZQKF3kU61i/A7O7kBaCf9iZd1s1l6/9fxh9NkIeOFrWbEvBCVJgAIi
         25vibYtkhiyCUeEoBd0YyfirPDzH8molWv2OvvADM8o1vLT8k7k/UNXNMKPhzyt7rP5p
         lo1qacL5QCh5SVLtMASV4QY0+B3EG27ZWVhHeTw8dUlay6KCzTDRW0SAcmI9/9VQcI50
         V8p+V4HcqG6bUIMgQ3O1qAF125JTQNIE+vvQQXSCK1UY7qpdl8Ft3m4khHxvMDYBez+f
         e48FH00+u2D4tkF2539jPDm7Ek+phpRYTKFK7c5w+IZlobDHpcKBSUcOCwDars6u0V7T
         bVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QnAH6vLwG/CSAZMFY7f9tw3x1aO5kQ0YxBlmG9hsOF8=;
        b=Q+L7YMLVzpH4AJaVaUnbpO7YHK7Of08YLZhEkYaDTvzs5ic1BNZUIy094rpxEPucX8
         dZVoSUun9MIJzy24O+Fk83SAHJDULGuBAEGH11bvwvwH6Qio+JRuTyTGACyLmTrEyFsl
         OC1HjEutEGQo7fyei6F4Ru7WhO4GjMUzin7FgLKt4y+Xp+dLLMGIxiEjvgrPUJPEaXo8
         tA6eXYsen1U8oS1NPQJrZyvn04E9tdn/GYRaDzs2Op56qF9HkoExMDmbw9cMH7MMr0h/
         DtPMHpFP5VS36EtDX0W0mEuEJocFOcKz0GeKTQh2/EQIwJtIU+ZILwh/etCgs893Hq+M
         tOcQ==
X-Gm-Message-State: AOAM530JcNaZdzIglUoGiTGwX6UHMQhmE9gnB45KFZ5X23Qr40k1wRLB
        Bt6XBXFGaRIM3eeJaLAZRXiyzCWUf/wEoA==
X-Google-Smtp-Source: ABdhPJzmbSZbgggRR++o0lMW35qtL/TIDy4xu9oRCJnUYz5/HClGyAJj1vGa2AYAekb4tkloyoss9A==
X-Received: by 2002:a65:610f:: with SMTP id z15mr20971239pgu.360.1617585649766;
        Sun, 04 Apr 2021 18:20:49 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:49 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 13/48] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
Date:   Mon,  5 Apr 2021 11:19:13 +1000
Message-Id: <20210405011948.675354-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
internal detail that has no real need to be in common handlers.

Also add a comment explaining why this thing exists.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 60 ----------------------------
 arch/powerpc/kvm/book3s_64_entry.S   | 59 ++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 162595af1ac7..16fbfde960e7 100644
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
@@ -190,9 +189,6 @@ do_define_int n
 	.ifndef IMASK
 		IMASK=0
 	.endif
-	.ifndef IKVM_SKIP
-		IKVM_SKIP=0
-	.endif
 	.ifndef IKVM_REAL
 		IKVM_REAL=0
 	.endif
@@ -250,15 +246,10 @@ do_define_int n
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
@@ -285,27 +276,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
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
@@ -1083,7 +1053,6 @@ INT_DEFINE_BEGIN(machine_check)
 	ISET_RI=0
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(machine_check)
 
@@ -1356,7 +1325,6 @@ INT_DEFINE_BEGIN(data_access)
 	IVEC=0x300
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access)
 
@@ -1410,7 +1378,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 INT_DEFINE_BEGIN(data_access_slb)
 	IVEC=0x380
 	IDAR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access_slb)
 
@@ -2080,7 +2047,6 @@ INT_DEFINE_BEGIN(h_data_storage)
 	IHSRR=1
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 	IKVM_VIRT=1
 INT_DEFINE_END(h_data_storage)
@@ -3024,32 +2990,6 @@ EXPORT_SYMBOL(do_uaccess_flush)
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
index 7a039ea78f15..bf927e7a06af 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
+#include <asm/exception-64s.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_book3s_asm.h>
 #include <asm/ppc_asm.h>
@@ -20,9 +21,12 @@ kvmppc_interrupt:
 	 * guest R12 saved in shadow VCPU SCRATCH0
 	 * guest R13 saved in SPRN_SCRATCH0
 	 */
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	std	r9,HSTATE_SCRATCH2(r13)
 	lbz	r9,HSTATE_IN_GUEST(r13)
+	cmpwi	r9,KVM_GUEST_MODE_SKIP
+	beq-	.Lmaybe_skip
+.Lno_skip:
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
 	beq	kvmppc_bad_host_intr
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
@@ -32,5 +36,58 @@ kvmppc_interrupt:
 #endif
 	b	kvmppc_interrupt_hv
 #else
+	ld	r9,HSTATE_SCRATCH2(r13)
 	b	kvmppc_interrupt_pr
 #endif
+
+/*
+ * "Skip" interrupts are part of a trick KVM uses a with hash guests to load
+ * the faulting instruction in guest memory from the the hypervisor without
+ * walking page tables.
+ *
+ * When the guest takes a fault that requires the hypervisor to load the
+ * instruction (e.g., MMIO emulation), KVM is running in real-mode with HV=1
+ * and the guest MMU context loaded. It sets KVM_GUEST_MODE_SKIP, and sets
+ * MSR[DR]=1 while leaving MSR[IR]=0, so it continues to fetch HV instructions
+ * but loads and stores will access the guest context. This is used to load
+ * the faulting instruction using the faulting guest effective address.
+ *
+ * However the guest context may not be able to translate, or it may cause a
+ * machine check or other issue, which results in a fault in the host
+ * (even with KVM-HV).
+ *
+ * These faults come here because KVM_GUEST_MODE_SKIP was set, so if they
+ * are (or are likely) caused by that load, the instruction is skipped by
+ * just returning with the PC advanced +4, where it is noticed the load did
+ * not execute and it goes to the slow path which walks the page tables to
+ * read guest memory.
+ */
+.Lmaybe_skip:
+	cmpwi	r12,BOOK3S_INTERRUPT_MACHINE_CHECK
+	beq	1f
+	cmpwi	r12,BOOK3S_INTERRUPT_DATA_STORAGE
+	beq	1f
+	cmpwi	r12,BOOK3S_INTERRUPT_DATA_SEGMENT
+	beq	1f
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	/* HSRR interrupts get 2 added to interrupt number */
+	cmpwi	r12,BOOK3S_INTERRUPT_H_DATA_STORAGE | 0x2
+	beq	2f
+#endif
+	b	.Lno_skip
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

