Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487AC351827
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhDARoJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhDARi3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:38:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87474C00F7D3
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:06:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so3238673pjh.1
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PX0FPFn4cdwQiE75NftlLAgVYTFksoO5Tv5a//zkyTo=;
        b=VIoWmmOJfoZQx9HECnlzX0Ivx6JstqLfKWgdcL3wFNgF9zQ79ubHRTiIimhrDrIE8r
         E6lWcBqyqsyj4O+y1YmKDTxo2NkeU1Dgh+9C3UiqsfN4kTnKbPujdEfPNMUd9NyCWtkB
         HyoWLDpEkVY8KHSE29fZ3fDAK7lu9OgK+0Yp+vJgIrv9mWCpuJa53OL+7LbwDuO0yMz3
         wFnhkXnSj+e/dTo+6AXkvlf3opMM+SaGytIj+hjSDh+VYIK2983sLCRLeVVCDTGXyh6m
         6bb5ON+AT3zjZiLP3VnBAFjhsxAgYD8g7+ME+61Eco0sAlIsIQNv2C41sXrB4NGFLj5q
         o0UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PX0FPFn4cdwQiE75NftlLAgVYTFksoO5Tv5a//zkyTo=;
        b=Pb+cnV4CRGChFiJC1ZT75pSVGYb649grM/rI2jhq8vdciVwmynCUZpU6fvDMn+V8Kv
         MlQwWpBYQJ9uVbG0P1SypxfN984TcUGH1yomKr4fWSyG0XU5h3XvozuNp9IbLbDaUZqL
         TZUQVu/jV0RwgfjL5hTbq2bWW/ITOgYg0UntL1w3lGteTOWA2WZ9muObHRezDZ+zrZ2N
         L0jUGrDk7pJTkJG9L3HsGX3+7OQin6qfYhI340Y3cZOVxSlflv+9QjGvAYMHNa+v8Jk0
         etD8XqoneoK+B616bF7c9yqEMaUeuaL56lC8IxU5kCdMppPuJ3YVW9x+6jMuYBxa5/r9
         eF9g==
X-Gm-Message-State: AOAM533w2YLdtsbX7dY291z3rAUuVf/dwUFXC1BKhoErlHT+ZMn79cNn
        sj39ujhUi8/TBF4NpopgfKHuhKYpC6s=
X-Google-Smtp-Source: ABdhPJwCWKEuhEVGtALPQupWKVbPx0kfqxqWShvItShxq/GsY0yiSX22lv0WmgetXSdVdn0CpDBgAA==
X-Received: by 2002:a17:90b:4c87:: with SMTP id my7mr9375929pjb.162.1617289559144;
        Thu, 01 Apr 2021 08:05:59 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 48/48] KVM: PPC: Book3S HV: remove ISA v3.0 and v3.1 support from P7/8 path
Date:   Fri,  2 Apr 2021 01:03:25 +1000
Message-Id: <20210401150325.442125-49-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

POWER9 and later processors always go via the P9 guest entry path now.
Remove the remaining support from the P7/8 path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c            |  62 ++--
 arch/powerpc/kvm/book3s_hv_interrupts.S |   9 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 404 +-----------------------
 arch/powerpc/platforms/powernv/idle.c   |  52 +--
 4 files changed, 39 insertions(+), 488 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a25583204829..fb0113e31e86 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -130,9 +130,6 @@ static inline bool nesting_enabled(struct kvm *kvm)
 	return kvm->arch.nested_enable && kvm_is_radix(kvm);
 }
 
-/* If set, the threads on each CPU core have to be in the same MMU mode */
-static bool no_mixing_hpt_and_radix __read_mostly;
-
 static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu);
 
 /*
@@ -3110,9 +3107,6 @@ static void prepare_threads(struct kvmppc_vcore *vc)
 	for_each_runnable_thread(i, vcpu, vc) {
 		if (signal_pending(vcpu->arch.run_task))
 			vcpu->arch.ret = -EINTR;
-		else if (no_mixing_hpt_and_radix &&
-			 kvm_is_radix(vc->kvm) != radix_enabled())
-			vcpu->arch.ret = -EINVAL;
 		else if (vcpu->arch.vpa.update_pending ||
 			 vcpu->arch.slb_shadow.update_pending ||
 			 vcpu->arch.dtl.update_pending)
@@ -3319,6 +3313,9 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	int trap;
 	bool is_power8;
 
+	if (WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300)))
+		return;
+
 	/*
 	 * Remove from the list any threads that have a signal pending
 	 * or need a VPA update done
@@ -3346,9 +3343,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	 * Make sure we are running on primary threads, and that secondary
 	 * threads are offline.  Also check if the number of threads in this
 	 * guest are greater than the current system threads per guest.
-	 * On POWER9, we need to be not in independent-threads mode if
-	 * this is a HPT guest on a radix host machine where the
-	 * CPU threads may not be in different MMU modes.
 	 */
 	if ((controlled_threads > 1) &&
 	    ((vc->num_threads > threads_per_subcore) || !on_primary_thread())) {
@@ -3372,18 +3366,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	if (vc->num_threads < target_threads)
 		collect_piggybacks(&core_info, target_threads);
 
-	/*
-	 * On radix, arrange for TLB flushing if necessary.
-	 * This has to be done before disabling interrupts since
-	 * it uses smp_call_function().
-	 */
-	pcpu = smp_processor_id();
-	if (kvm_is_radix(vc->kvm)) {
-		for (sub = 0; sub < core_info.n_subcores; ++sub)
-			for_each_runnable_thread(i, vcpu, core_info.vc[sub])
-				kvmppc_prepare_radix_vcpu(vcpu, pcpu);
-	}
-
 	/*
 	 * Hard-disable interrupts, and check resched flag and signals.
 	 * If we need to reschedule or deliver a signal, clean up
@@ -3416,8 +3398,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	cmd_bit = stat_bit = 0;
 	split = core_info.n_subcores;
 	sip = NULL;
-	is_power8 = cpu_has_feature(CPU_FTR_ARCH_207S)
-		&& !cpu_has_feature(CPU_FTR_ARCH_300);
+	is_power8 = cpu_has_feature(CPU_FTR_ARCH_207S);
 
 	if (split > 1) {
 		sip = &split_info;
@@ -3711,8 +3692,7 @@ static inline bool hcall_is_xics(unsigned long req)
 }
 
 /*
- * Virtual-mode guest entry for POWER9 and later when the host and
- * guest are both using the radix MMU.  The LPIDR has already been set.
+ * Guest entry for POWER9 and later CPUs.
  */
 static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr)
@@ -5732,11 +5712,25 @@ static int kvmhv_enable_dawr1(struct kvm *kvm)
 
 static bool kvmppc_hash_v3_possible(void)
 {
-	if (radix_enabled() && no_mixing_hpt_and_radix)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return false;
 
-	return cpu_has_feature(CPU_FTR_ARCH_300) &&
-		cpu_has_feature(CPU_FTR_HVMODE);
+	if (!cpu_has_feature(CPU_FTR_HVMODE))
+		return false;
+
+	/*
+	 * POWER9 chips before version 2.02 can't have some threads in
+	 * HPT mode and some in radix mode on the same core.
+	 */
+	if (radix_enabled()) {
+		unsigned int pvr = mfspr(SPRN_PVR);
+		if ((pvr >> 16) == PVR_POWER9 &&
+		    (((pvr & 0xe000) == 0 && (pvr & 0xfff) < 0x202) ||
+		     ((pvr & 0xe000) == 0x2000 && (pvr & 0xfff) < 0x101)))
+			return false;
+	}
+
+	return true;
 }
 
 static struct kvmppc_ops kvm_ops_hv = {
@@ -5880,18 +5874,6 @@ static int kvmppc_book3s_init_hv(void)
 	if (kvmppc_radix_possible())
 		r = kvmppc_radix_init();
 
-	/*
-	 * POWER9 chips before version 2.02 can't have some threads in
-	 * HPT mode and some in radix mode on the same core.
-	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-		unsigned int pvr = mfspr(SPRN_PVR);
-		if ((pvr >> 16) == PVR_POWER9 &&
-		    (((pvr & 0xe000) == 0 && (pvr & 0xfff) < 0x202) ||
-		     ((pvr & 0xe000) == 0x2000 && (pvr & 0xfff) < 0x101)))
-			no_mixing_hpt_and_radix = true;
-	}
-
 	r = kvmppc_uvmem_init();
 	if (r < 0)
 		pr_err("KVM-HV: kvmppc_uvmem_init failed %d\n", r);
diff --git a/arch/powerpc/kvm/book3s_hv_interrupts.S b/arch/powerpc/kvm/book3s_hv_interrupts.S
index 327417d79eac..4444f83cb133 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupts.S
+++ b/arch/powerpc/kvm/book3s_hv_interrupts.S
@@ -58,7 +58,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	/*
 	 * Put whatever is in the decrementer into the
 	 * hypervisor decrementer.
-	 * Because of a hardware deviation in P8 and P9,
+	 * Because of a hardware deviation in P8,
 	 * we need to set LPCR[HDICE] before writing HDEC.
 	 */
 	ld	r5, HSTATE_KVM_VCORE(r13)
@@ -67,15 +67,10 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	ori	r8, r9, LPCR_HDICE
 	mtspr	SPRN_LPCR, r8
 	isync
-	andis.	r0, r9, LPCR_LD@h
 	mfspr	r8,SPRN_DEC
 	mftb	r7
-BEGIN_FTR_SECTION
-	/* On POWER9, don't sign-extend if host LPCR[LD] bit is set */
-	bne	32f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	extsw	r8,r8
-32:	mtspr	SPRN_HDEC,r8
+	mtspr	SPRN_HDEC,r8
 	add	r8,r8,r7
 	std	r8,HSTATE_DECEXP(r13)
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index acbe31d92efc..0424d62631ad 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -25,7 +25,6 @@
 #include <asm/export.h>
 #include <asm/tm.h>
 #include <asm/opal.h>
-#include <asm/xive-regs.h>
 #include <asm/thread_info.h>
 #include <asm/asm-compat.h>
 #include <asm/feature-fixups.h>
@@ -34,9 +33,7 @@
 
 /* Sign-extend HDEC if not on POWER9 */
 #define EXTEND_HDEC(reg)			\
-BEGIN_FTR_SECTION;				\
-	extsw	reg, reg;			\
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
+	extsw	reg, reg
 
 /* Values in HSTATE_NAPPING(r13) */
 #define NAPPING_CEDE	1
@@ -56,8 +53,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_HFSCR	(SFS-72)
 #define STACK_SLOT_AMR		(SFS-80)
 #define STACK_SLOT_UAMOR	(SFS-88)
-#define STACK_SLOT_DAWR1	(SFS-96)
-#define STACK_SLOT_DAWRX1	(SFS-104)
 
 /*
  * Call kvmppc_hv_entry in real mode.
@@ -333,7 +328,6 @@ kvm_secondary_got_guest:
 	LOAD_REG_ADDR(r6, decrementer_max)
 	ld	r6, 0(r6)
 	mtspr	SPRN_HDEC, r6
-BEGIN_FTR_SECTION
 	/* and set per-LPAR registers, if doing dynamic micro-threading */
 	ld	r6, HSTATE_SPLIT_MODE(r13)
 	cmpdi	r6, 0
@@ -345,7 +339,6 @@ BEGIN_FTR_SECTION
 	ld	r0, KVM_SPLIT_LDBAR(r6)
 	mtspr	SPRN_LDBAR, r0
 	isync
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 63:
 	/* Order load of vcpu after load of vcore */
 	lwsync
@@ -416,7 +409,6 @@ kvm_no_guest:
 	blr
 
 53:
-BEGIN_FTR_SECTION
 	HMT_LOW
 	ld	r5, HSTATE_KVM_VCORE(r13)
 	cmpdi	r5, 0
@@ -431,14 +423,6 @@ BEGIN_FTR_SECTION
 	b	kvm_unsplit_nap
 60:	HMT_MEDIUM
 	b	kvm_secondary_got_guest
-FTR_SECTION_ELSE
-	HMT_LOW
-	ld	r5, HSTATE_KVM_VCORE(r13)
-	cmpdi	r5, 0
-	beq	kvm_no_guest
-	HMT_MEDIUM
-	b	kvm_secondary_got_guest
-ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 
 54:	li	r0, KVM_HWTHREAD_IN_KVM
 	stb	r0, HSTATE_HWTHREAD_STATE(r13)
@@ -564,13 +548,11 @@ kvmppc_hv_entry:
 	bne	10f
 
 	lwz	r7,KVM_LPID(r9)
-BEGIN_FTR_SECTION
 	ld	r6,KVM_SDR1(r9)
 	li	r0,LPID_RSVD		/* switch to reserved LPID */
 	mtspr	SPRN_LPID,r0
 	ptesync
 	mtspr	SPRN_SDR1,r6		/* switch to partition page table */
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	mtspr	SPRN_LPID,r7
 	isync
 
@@ -650,16 +632,6 @@ kvmppc_got_guest:
 	mtspr	SPRN_SPURR,r8
 
 	/* Save host values of some registers */
-BEGIN_FTR_SECTION
-	mfspr	r5, SPRN_TIDR
-	mfspr	r6, SPRN_PSSCR
-	mfspr	r7, SPRN_PID
-	std	r5, STACK_SLOT_TID(r1)
-	std	r6, STACK_SLOT_PSSCR(r1)
-	std	r7, STACK_SLOT_PID(r1)
-	mfspr	r5, SPRN_HFSCR
-	std	r5, STACK_SLOT_HFSCR(r1)
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_CIABR
 	mfspr	r6, SPRN_DAWR0
@@ -670,12 +642,6 @@ BEGIN_FTR_SECTION
 	std	r7, STACK_SLOT_DAWRX0(r1)
 	std	r8, STACK_SLOT_IAMR(r1)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
-BEGIN_FTR_SECTION
-	mfspr	r6, SPRN_DAWR1
-	mfspr	r7, SPRN_DAWRX1
-	std	r6, STACK_SLOT_DAWR1(r1)
-	std	r7, STACK_SLOT_DAWRX1(r1)
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S | CPU_FTR_DAWR1)
 
 	mfspr	r5, SPRN_AMR
 	std	r5, STACK_SLOT_AMR(r1)
@@ -693,13 +659,9 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-/*
- * Branch around the call if both CPU_FTR_TM and
- * CPU_FTR_P9_TM_HV_ASSIST are off.
- */
 BEGIN_FTR_SECTION
 	b	91f
-END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
+END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	/*
 	 * NOTE THAT THIS TRASHES ALL NON-VOLATILE REGISTERS (but not CR)
 	 */
@@ -766,12 +728,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	ld	r6, VCPU_DAWRX0(r4)
 	mtspr	SPRN_DAWR0, r5
 	mtspr	SPRN_DAWRX0, r6
-BEGIN_FTR_SECTION
-	ld	r5, VCPU_DAWR1(r4)
-	ld	r6, VCPU_DAWRX1(r4)
-	mtspr	SPRN_DAWR1, r5
-	mtspr	SPRN_DAWRX1, r6
-END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 1:
 	ld	r7, VCPU_CIABR(r4)
 	ld	r8, VCPU_TAR(r4)
@@ -789,7 +745,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 	mtspr	SPRN_BESCR, r6
 	mtspr	SPRN_PID, r7
 	mtspr	SPRN_WORT, r8
-BEGIN_FTR_SECTION
 	/* POWER8-only registers */
 	ld	r5, VCPU_TCSCR(r4)
 	ld	r6, VCPU_ACOP(r4)
@@ -800,18 +755,6 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_CSIGR, r7
 	mtspr	SPRN_TACR, r8
 	nop
-FTR_SECTION_ELSE
-	/* POWER9-only registers */
-	ld	r5, VCPU_TID(r4)
-	ld	r6, VCPU_PSSCR(r4)
-	lbz	r8, HSTATE_FAKE_SUSPEND(r13)
-	oris	r6, r6, PSSCR_EC@h	/* This makes stop trap to HV */
-	rldimi	r6, r8, PSSCR_FAKE_SUSPEND_LG, 63 - PSSCR_FAKE_SUSPEND_LG
-	ld	r7, VCPU_HFSCR(r4)
-	mtspr	SPRN_TIDR, r5
-	mtspr	SPRN_PSSCR, r6
-	mtspr	SPRN_HFSCR, r7
-ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 8:
 
 	ld	r5, VCPU_SPRG0(r4)
@@ -904,93 +847,9 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	bdnz	1b
 9:
 
-#ifdef CONFIG_KVM_XICS
-	/* We are entering the guest on that thread, push VCPU to XIVE */
-	ld	r11, VCPU_XIVE_SAVED_STATE(r4)
-	li	r9, TM_QW1_OS
-	lwz	r8, VCPU_XIVE_CAM_WORD(r4)
-	cmpwi	r8, 0
-	beq	no_xive
-	li	r7, TM_QW1_OS + TM_WORD2
-	mfmsr	r0
-	andi.	r0, r0, MSR_DR		/* in real mode? */
-	beq	2f
-	ld	r10, HSTATE_XIVE_TIMA_VIRT(r13)
-	cmpldi	cr1, r10, 0
-	beq     cr1, no_xive
-	eieio
-	stdx	r11,r9,r10
-	stwx	r8,r7,r10
-	b	3f
-2:	ld	r10, HSTATE_XIVE_TIMA_PHYS(r13)
-	cmpldi	cr1, r10, 0
-	beq	cr1, no_xive
-	eieio
-	stdcix	r11,r9,r10
-	stwcix	r8,r7,r10
-3:	li	r9, 1
-	stb	r9, VCPU_XIVE_PUSHED(r4)
-	eieio
-
-	/*
-	 * We clear the irq_pending flag. There is a small chance of a
-	 * race vs. the escalation interrupt happening on another
-	 * processor setting it again, but the only consequence is to
-	 * cause a spurrious wakeup on the next H_CEDE which is not an
-	 * issue.
-	 */
-	li	r0,0
-	stb	r0, VCPU_IRQ_PENDING(r4)
-
-	/*
-	 * In single escalation mode, if the escalation interrupt is
-	 * on, we mask it.
-	 */
-	lbz	r0, VCPU_XIVE_ESC_ON(r4)
-	cmpwi	cr1, r0,0
-	beq	cr1, 1f
-	li	r9, XIVE_ESB_SET_PQ_01
-	beq	4f			/* in real mode? */
-	ld	r10, VCPU_XIVE_ESC_VADDR(r4)
-	ldx	r0, r10, r9
-	b	5f
-4:	ld	r10, VCPU_XIVE_ESC_RADDR(r4)
-	ldcix	r0, r10, r9
-5:	sync
-
-	/* We have a possible subtle race here: The escalation interrupt might
-	 * have fired and be on its way to the host queue while we mask it,
-	 * and if we unmask it early enough (re-cede right away), there is
-	 * a theorical possibility that it fires again, thus landing in the
-	 * target queue more than once which is a big no-no.
-	 *
-	 * Fortunately, solving this is rather easy. If the above load setting
-	 * PQ to 01 returns a previous value where P is set, then we know the
-	 * escalation interrupt is somewhere on its way to the host. In that
-	 * case we simply don't clear the xive_esc_on flag below. It will be
-	 * eventually cleared by the handler for the escalation interrupt.
-	 *
-	 * Then, when doing a cede, we check that flag again before re-enabling
-	 * the escalation interrupt, and if set, we abort the cede.
-	 */
-	andi.	r0, r0, XIVE_ESB_VAL_P
-	bne-	1f
-
-	/* Now P is 0, we can clear the flag */
-	li	r0, 0
-	stb	r0, VCPU_XIVE_ESC_ON(r4)
-1:
-no_xive:
-#endif /* CONFIG_KVM_XICS */
-
 deliver_guest_interrupt:	/* r4 = vcpu, r13 = paca */
 	/* Check if we can deliver an external or decrementer interrupt now */
 	ld	r0, VCPU_PENDING_EXC(r4)
-BEGIN_FTR_SECTION
-	/* On POWER9, also check for emulated doorbell interrupt */
-	lbz	r3, VCPU_DBELL_REQ(r4)
-	or	r0, r0, r3
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	cmpdi	r0, 0
 	beq	71f
 	mr	r3, r4
@@ -1063,12 +922,6 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_PPR, r0
 END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 
-/* Move canary into DSISR to check for later */
-BEGIN_FTR_SECTION
-	li	r0, 0x7fff
-	mtspr	SPRN_HDSISR, r0
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-
 	ld	r6, VCPU_KVM(r4)
 	lbz	r7, KVM_SECURE_GUEST(r6)
 	cmpdi	r7, 0
@@ -1284,14 +1137,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	/* Hypervisor doorbell - exit only if host IPI flag set */
 	cmpwi	r12, BOOK3S_INTERRUPT_H_DOORBELL
 	bne	3f
-BEGIN_FTR_SECTION
-	PPC_MSGSYNC
-	lwsync
-	/* always exit if we're running a nested guest */
-	ld	r0, VCPU_NESTED(r9)
-	cmpdi	r0, 0
-	bne	guest_exit_cont
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	lbz	r0, HSTATE_HOST_IPI(r13)
 	cmpwi	r0, 0
 	beq	maybe_reenter_guest
@@ -1321,43 +1166,6 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	mr	r4, r9
 	bl	kvmhv_accumulate_time
 #endif
-#ifdef CONFIG_KVM_XICS
-	/* We are exiting, pull the VP from the XIVE */
-	lbz	r0, VCPU_XIVE_PUSHED(r9)
-	cmpwi	cr0, r0, 0
-	beq	1f
-	li	r7, TM_SPC_PULL_OS_CTX
-	li	r6, TM_QW1_OS
-	mfmsr	r0
-	andi.	r0, r0, MSR_DR		/* in real mode? */
-	beq	2f
-	ld	r10, HSTATE_XIVE_TIMA_VIRT(r13)
-	cmpldi	cr0, r10, 0
-	beq	1f
-	/* First load to pull the context, we ignore the value */
-	eieio
-	lwzx	r11, r7, r10
-	/* Second load to recover the context state (Words 0 and 1) */
-	ldx	r11, r6, r10
-	b	3f
-2:	ld	r10, HSTATE_XIVE_TIMA_PHYS(r13)
-	cmpldi	cr0, r10, 0
-	beq	1f
-	/* First load to pull the context, we ignore the value */
-	eieio
-	lwzcix	r11, r7, r10
-	/* Second load to recover the context state (Words 0 and 1) */
-	ldcix	r11, r6, r10
-3:	std	r11, VCPU_XIVE_SAVED_STATE(r9)
-	/* Fixup some of the state for the next load */
-	li	r10, 0
-	li	r0, 0xff
-	stb	r10, VCPU_XIVE_PUSHED(r9)
-	stb	r10, (VCPU_XIVE_SAVED_STATE+3)(r9)
-	stb	r0, (VCPU_XIVE_SAVED_STATE+4)(r9)
-	eieio
-1:
-#endif /* CONFIG_KVM_XICS */
 
 	/*
 	 * Possibly flush the link stack here, before we do a blr in
@@ -1412,12 +1220,6 @@ guest_bypass:
 	ld	r3, HSTATE_KVM_VCORE(r13)
 	mfspr	r5,SPRN_DEC
 	mftb	r6
-	/* On P9, if the guest has large decr enabled, don't sign extend */
-BEGIN_FTR_SECTION
-	ld	r4, VCORE_LPCR(r3)
-	andis.	r4, r4, LPCR_LD@h
-	bne	16f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	extsw	r5,r5
 16:	add	r5,r5,r6
 	/* r5 is a guest timebase value here, convert to host TB */
@@ -1491,7 +1293,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	std	r6, VCPU_BESCR(r9)
 	stw	r7, VCPU_GUEST_PID(r9)
 	std	r8, VCPU_WORT(r9)
-BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_TCSCR
 	mfspr	r6, SPRN_ACOP
 	mfspr	r7, SPRN_CSIGR
@@ -1500,17 +1301,6 @@ BEGIN_FTR_SECTION
 	std	r6, VCPU_ACOP(r9)
 	std	r7, VCPU_CSIGR(r9)
 	std	r8, VCPU_TACR(r9)
-FTR_SECTION_ELSE
-	mfspr	r5, SPRN_TIDR
-	mfspr	r6, SPRN_PSSCR
-	std	r5, VCPU_TID(r9)
-	rldicl	r6, r6, 4, 50		/* r6 &= PSSCR_GUEST_VIS */
-	rotldi	r6, r6, 60
-	std	r6, VCPU_PSSCR(r9)
-	/* Restore host HFSCR value */
-	ld	r7, STACK_SLOT_HFSCR(r1)
-	mtspr	SPRN_HFSCR, r7
-ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	/*
 	 * Restore various registers to 0, where non-zero values
 	 * set by the guest could disrupt the host.
@@ -1518,13 +1308,11 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	li	r0, 0
 	mtspr	SPRN_PSPB, r0
 	mtspr	SPRN_WORT, r0
-BEGIN_FTR_SECTION
 	mtspr	SPRN_TCSCR, r0
 	/* Set MMCRS to 1<<31 to freeze and disable the SPMC counters */
 	li	r0, 1
 	sldi	r0, r0, 31
 	mtspr	SPRN_MMCRS, r0
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 
 	/* Save and restore AMR, IAMR and UAMOR before turning on the MMU */
 	ld	r8, STACK_SLOT_IAMR(r1)
@@ -1581,13 +1369,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	bl	kvmppc_save_fp
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-/*
- * Branch around the call if both CPU_FTR_TM and
- * CPU_FTR_P9_TM_HV_ASSIST are off.
- */
 BEGIN_FTR_SECTION
 	b	91f
-END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
+END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	/*
 	 * NOTE THAT THIS TRASHES ALL NON-VOLATILE REGISTERS (but not CR)
 	 */
@@ -1633,28 +1417,6 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_DAWR0, r6
 	mtspr	SPRN_DAWRX0, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
-BEGIN_FTR_SECTION
-	ld	r6, STACK_SLOT_DAWR1(r1)
-	ld	r7, STACK_SLOT_DAWRX1(r1)
-	mtspr	SPRN_DAWR1, r6
-	mtspr	SPRN_DAWRX1, r7
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S | CPU_FTR_DAWR1)
-BEGIN_FTR_SECTION
-	ld	r5, STACK_SLOT_TID(r1)
-	ld	r6, STACK_SLOT_PSSCR(r1)
-	ld	r7, STACK_SLOT_PID(r1)
-	mtspr	SPRN_TIDR, r5
-	mtspr	SPRN_PSSCR, r6
-	mtspr	SPRN_PID, r7
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-
-	/*
-	 * cp_abort is required if the processor supports local copy-paste
-	 * to clear the copy buffer that was under control of the guest.
-	 */
-BEGIN_FTR_SECTION
-	PPC_CP_ABORT
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_31)
 
 	/*
 	 * POWER7/POWER8 guest -> host partition switch code.
@@ -1691,13 +1453,11 @@ kvmhv_switch_to_host:
 
 	/* Primary thread switches back to host partition */
 	lwz	r7,KVM_HOST_LPID(r4)
-BEGIN_FTR_SECTION
 	ld	r6,KVM_HOST_SDR1(r4)
 	li	r8,LPID_RSVD		/* switch to reserved LPID */
 	mtspr	SPRN_LPID,r8
 	ptesync
 	mtspr	SPRN_SDR1,r6		/* switch to host page table */
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	mtspr	SPRN_LPID,r7
 	isync
 
@@ -1908,20 +1668,11 @@ kvmppc_tm_emul:
 kvmppc_hdsi:
 	mfspr	r4, SPRN_HDAR
 	mfspr	r6, SPRN_HDSISR
-BEGIN_FTR_SECTION
-	/* Look for DSISR canary. If we find it, retry instruction */
-	cmpdi	r6, 0x7fff
-	beq	6f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	/* HPTE not found fault or protection fault? */
 	andis.	r0, r6, (DSISR_NOHPTE | DSISR_PROTFAULT)@h
 	beq	1f			/* if not, send it to the guest */
 	andi.	r0, r11, MSR_DR		/* data relocation enabled? */
 	beq	3f
-BEGIN_FTR_SECTION
-	mfspr	r5, SPRN_ASDR		/* on POWER9, use ASDR to get VSID */
-	b	4f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	clrrdi	r0, r4, 28
 	PPC_SLBFEE_DOT(R5, R0)		/* if so, look up SLB */
 	li	r0, BOOK3S_INTERRUPT_DATA_SEGMENT
@@ -1998,10 +1749,6 @@ kvmppc_hisi:
 	beq	1f
 	andi.	r0, r11, MSR_IR		/* instruction relocation enabled? */
 	beq	3f
-BEGIN_FTR_SECTION
-	mfspr	r5, SPRN_ASDR		/* on POWER9, use ASDR to get VSID */
-	b	4f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	clrrdi	r0, r10, 28
 	PPC_SLBFEE_DOT(R5, R0)		/* if so, look up SLB */
 	li	r0, BOOK3S_INTERRUPT_INST_SEGMENT
@@ -2049,10 +1796,6 @@ hcall_try_real_mode:
 	andi.	r0,r11,MSR_PR
 	/* sc 1 from userspace - reflect to guest syscall */
 	bne	sc_1_fast_return
-	/* sc 1 from nested guest - give it to L1 to handle */
-	ld	r0, VCPU_NESTED(r9)
-	cmpdi	r0, 0
-	bne	guest_exit_cont
 	clrrdi	r3,r3,2
 	cmpldi	r3,hcall_real_table_end - hcall_real_table
 	bge	guest_exit_cont
@@ -2448,13 +2191,9 @@ _GLOBAL(kvmppc_h_cede)		/* r3 = vcpu pointer, r11 = msr, r13 = paca */
 	bl	kvmppc_save_fp
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-/*
- * Branch around the call if both CPU_FTR_TM and
- * CPU_FTR_P9_TM_HV_ASSIST are off.
- */
 BEGIN_FTR_SECTION
 	b	91f
-END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
+END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	/*
 	 * NOTE THAT THIS TRASHES ALL NON-VOLATILE REGISTERS (but not CR)
 	 */
@@ -2474,15 +2213,8 @@ END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
 	mfspr	r3, SPRN_DEC
 	mfspr	r4, SPRN_HDEC
 	mftb	r5
-BEGIN_FTR_SECTION
-	/* On P9 check whether the guest has large decrementer mode enabled */
-	ld	r6, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_LPCR(r6)
-	andis.	r6, r6, LPCR_LD@h
-	bne	68f
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	extsw	r3, r3
-68:	EXTEND_HDEC(r4)
+	EXTEND_HDEC(r4)
 	cmpd	r3, r4
 	ble	67f
 	mtspr	SPRN_DEC, r4
@@ -2527,28 +2259,14 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 
 kvm_nap_sequence:		/* desired LPCR value in r5 */
-BEGIN_FTR_SECTION
-	/*
-	 * PSSCR bits:	exit criterion = 1 (wakeup based on LPCR at sreset)
-	 *		enable state loss = 1 (allow SMT mode switch)
-	 *		requested level = 0 (just stop dispatching)
-	 */
-	lis	r3, (PSSCR_EC | PSSCR_ESL)@h
 	/* Set LPCR_PECE_HVEE bit to enable wakeup by HV interrupts */
 	li	r4, LPCR_PECE_HVEE@higher
 	sldi	r4, r4, 32
 	or	r5, r5, r4
-FTR_SECTION_ELSE
-	li	r3, PNV_THREAD_NAP
-ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
 	mtspr	SPRN_LPCR,r5
 	isync
 
-BEGIN_FTR_SECTION
-	bl	isa300_idle_stop_mayloss
-FTR_SECTION_ELSE
 	bl	isa206_idle_insn_mayloss
-ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
 
 	mfspr	r0, SPRN_CTRLF
 	ori	r0, r0, 1
@@ -2567,10 +2285,8 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_ARCH_300)
 	beq	kvm_end_cede
 	cmpwi	r0, NAPPING_NOVCPU
 	beq	kvm_novcpu_wakeup
-BEGIN_FTR_SECTION
 	cmpwi	r0, NAPPING_UNSPLIT
 	beq	kvm_unsplit_wakeup
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	twi	31,0,0 /* Nap state must not be zero */
 
 33:	mr	r4, r3
@@ -2590,13 +2306,9 @@ kvm_end_cede:
 #endif
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-/*
- * Branch around the call if both CPU_FTR_TM and
- * CPU_FTR_P9_TM_HV_ASSIST are off.
- */
 BEGIN_FTR_SECTION
 	b	91f
-END_FTR_SECTION(CPU_FTR_TM | CPU_FTR_P9_TM_HV_ASSIST, 0)
+END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	/*
 	 * NOTE THAT THIS TRASHES ALL NON-VOLATILE REGISTERS (but not CR)
 	 */
@@ -2686,47 +2398,7 @@ kvm_cede_prodded:
 	/* we've ceded but we want to give control to the host */
 kvm_cede_exit:
 	ld	r9, HSTATE_KVM_VCPU(r13)
-#ifdef CONFIG_KVM_XICS
-	/* are we using XIVE with single escalation? */
-	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
-	cmpdi	r10, 0
-	beq	3f
-	li	r6, XIVE_ESB_SET_PQ_00
-	/*
-	 * If we still have a pending escalation, abort the cede,
-	 * and we must set PQ to 10 rather than 00 so that we don't
-	 * potentially end up with two entries for the escalation
-	 * interrupt in the XIVE interrupt queue.  In that case
-	 * we also don't want to set xive_esc_on to 1 here in
-	 * case we race with xive_esc_irq().
-	 */
-	lbz	r5, VCPU_XIVE_ESC_ON(r9)
-	cmpwi	r5, 0
-	beq	4f
-	li	r0, 0
-	stb	r0, VCPU_CEDED(r9)
-	/*
-	 * The escalation interrupts are special as we don't EOI them.
-	 * There is no need to use the load-after-store ordering offset
-	 * to set PQ to 10 as we won't use StoreEOI.
-	 */
-	li	r6, XIVE_ESB_SET_PQ_10
-	b	5f
-4:	li	r0, 1
-	stb	r0, VCPU_XIVE_ESC_ON(r9)
-	/* make sure store to xive_esc_on is seen before xive_esc_irq runs */
-	sync
-5:	/* Enable XIVE escalation */
-	mfmsr	r0
-	andi.	r0, r0, MSR_DR		/* in real mode? */
-	beq	1f
-	ldx	r0, r10, r6
-	b	2f
-1:	ld	r10, VCPU_XIVE_ESC_RADDR(r9)
-	ldcix	r0, r10, r6
-2:	sync
-#endif /* CONFIG_KVM_XICS */
-3:	b	guest_exit_cont
+	b	guest_exit_cont
 
 	/* Try to do machine check recovery in real mode */
 machine_check_realmode:
@@ -2803,10 +2475,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	PPC_MSGCLR(6)
 	/* see if it's a host IPI */
 	li	r3, 1
-BEGIN_FTR_SECTION
-	PPC_MSGSYNC
-	lwsync
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	lbz	r0, HSTATE_HOST_IPI(r13)
 	cmpwi	r0, 0
 	bnelr
@@ -3115,70 +2783,12 @@ kvmppc_bad_host_intr:
 	std	r3, STACK_FRAME_OVERHEAD-16(r1)
 
 	/*
-	 * On POWER9 do a minimal restore of the MMU and call C code,
-	 * which will print a message and panic.
 	 * XXX On POWER7 and POWER8, we just spin here since we don't
 	 * know what the other threads are doing (and we don't want to
 	 * coordinate with them) - but at least we now have register state
 	 * in memory that we might be able to look at from another CPU.
 	 */
-BEGIN_FTR_SECTION
 	b	.
-END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
-	ld	r9, HSTATE_KVM_VCPU(r13)
-	ld	r10, VCPU_KVM(r9)
-
-	li	r0, 0
-	mtspr	SPRN_AMR, r0
-	mtspr	SPRN_IAMR, r0
-	mtspr	SPRN_CIABR, r0
-	mtspr	SPRN_DAWRX0, r0
-BEGIN_FTR_SECTION
-	mtspr	SPRN_DAWRX1, r0
-END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
-
-	/* Clear guest SLB. */
-	slbmte	r0, r0
-	PPC_SLBIA(6)
-	ptesync
-
-	/* load host SLB entries */
-	ld	r8, PACA_SLBSHADOWPTR(r13)
-	.rept	SLB_NUM_BOLTED
-	li	r3, SLBSHADOW_SAVEAREA
-	LDX_BE	r5, r8, r3
-	addi	r3, r3, 8
-	LDX_BE	r6, r8, r3
-	andis.	r7, r5, SLB_ESID_V@h
-	beq	3f
-	slbmte	r6, r5
-3:	addi	r8, r8, 16
-	.endr
-
-	lwz	r7, KVM_HOST_LPID(r10)
-	mtspr	SPRN_LPID, r7
-	mtspr	SPRN_PID, r0
-	ld	r8, KVM_HOST_LPCR(r10)
-	mtspr	SPRN_LPCR, r8
-	isync
-	li	r0, KVM_GUEST_MODE_NONE
-	stb	r0, HSTATE_IN_GUEST(r13)
-
-	/*
-	 * Turn on the MMU and jump to C code
-	 */
-	bcl	20, 31, .+4
-5:	mflr	r3
-	addi	r3, r3, 9f - 5b
-	li	r4, -1
-	rldimi	r3, r4, 62, 0	/* ensure 0xc000000000000000 bits are set */
-	ld	r4, PACAKMSR(r13)
-	mtspr	SPRN_SRR0, r3
-	mtspr	SPRN_SRR1, r4
-	RFI_TO_KERNEL
-9:	addi	r3, r1, STACK_FRAME_OVERHEAD
-	bl	kvmppc_bad_interrupt
-	b	9b
 
 /*
  * This mimics the MSR transition on IRQ delivery.  The new guest MSR is taken
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index 999997d9e9a9..528a7e0cf83a 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -604,7 +604,7 @@ struct p9_sprs {
 	u64 uamor;
 };
 
-static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
+static unsigned long power9_idle_stop(unsigned long psscr)
 {
 	int cpu = raw_smp_processor_id();
 	int first = cpu_first_thread_sibling(cpu);
@@ -620,8 +620,6 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
 	if (!(psscr & (PSSCR_EC|PSSCR_ESL))) {
 		/* EC=ESL=0 case */
 
-		BUG_ON(!mmu_on);
-
 		/*
 		 * Wake synchronously. SRESET via xscom may still cause
 		 * a 0x100 powersave wakeup with SRR1 reason!
@@ -803,8 +801,7 @@ static unsigned long power9_idle_stop(unsigned long psscr, bool mmu_on)
 		__slb_restore_bolted_realmode();
 
 out:
-	if (mmu_on)
-		mtmsr(MSR_KERNEL);
+	mtmsr(MSR_KERNEL);
 
 	return srr1;
 }
@@ -895,7 +892,7 @@ struct p10_sprs {
 	 */
 };
 
-static unsigned long power10_idle_stop(unsigned long psscr, bool mmu_on)
+static unsigned long power10_idle_stop(unsigned long psscr)
 {
 	int cpu = raw_smp_processor_id();
 	int first = cpu_first_thread_sibling(cpu);
@@ -909,8 +906,6 @@ static unsigned long power10_idle_stop(unsigned long psscr, bool mmu_on)
 	if (!(psscr & (PSSCR_EC|PSSCR_ESL))) {
 		/* EC=ESL=0 case */
 
-		BUG_ON(!mmu_on);
-
 		/*
 		 * Wake synchronously. SRESET via xscom may still cause
 		 * a 0x100 powersave wakeup with SRR1 reason!
@@ -991,8 +986,7 @@ static unsigned long power10_idle_stop(unsigned long psscr, bool mmu_on)
 		__slb_restore_bolted_realmode();
 
 out:
-	if (mmu_on)
-		mtmsr(MSR_KERNEL);
+	mtmsr(MSR_KERNEL);
 
 	return srr1;
 }
@@ -1002,40 +996,10 @@ static unsigned long arch300_offline_stop(unsigned long psscr)
 {
 	unsigned long srr1;
 
-#ifndef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-	__ppc64_runlatch_off();
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		srr1 = power10_idle_stop(psscr, true);
+		srr1 = power10_idle_stop(psscr);
 	else
-		srr1 = power9_idle_stop(psscr, true);
-	__ppc64_runlatch_on();
-#else
-	/*
-	 * Tell KVM we're entering idle.
-	 * This does not have to be done in real mode because the P9 MMU
-	 * is independent per-thread. Some steppings share radix/hash mode
-	 * between threads, but in that case KVM has a barrier sync in real
-	 * mode before and after switching between radix and hash.
-	 *
-	 * kvm_start_guest must still be called in real mode though, hence
-	 * the false argument.
-	 */
-	local_paca->kvm_hstate.hwthread_state = KVM_HWTHREAD_IN_IDLE;
-
-	__ppc64_runlatch_off();
-	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		srr1 = power10_idle_stop(psscr, false);
-	else
-		srr1 = power9_idle_stop(psscr, false);
-	__ppc64_runlatch_on();
-
-	local_paca->kvm_hstate.hwthread_state = KVM_HWTHREAD_IN_KERNEL;
-	/* Order setting hwthread_state vs. testing hwthread_req */
-	smp_mb();
-	if (local_paca->kvm_hstate.hwthread_req)
-		srr1 = idle_kvm_start_guest(srr1);
-	mtmsr(MSR_KERNEL);
-#endif
+		srr1 = power9_idle_stop(psscr);
 
 	return srr1;
 }
@@ -1055,9 +1019,9 @@ void arch300_idle_type(unsigned long stop_psscr_val,
 
 	__ppc64_runlatch_off();
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		srr1 = power10_idle_stop(psscr, true);
+		srr1 = power10_idle_stop(psscr);
 	else
-		srr1 = power9_idle_stop(psscr, true);
+		srr1 = power9_idle_stop(psscr);
 	__ppc64_runlatch_on();
 
 	fini_irq_for_idle_irqsoff();
-- 
2.23.0

