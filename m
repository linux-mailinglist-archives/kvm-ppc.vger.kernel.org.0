Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADE934549E
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhCWBFx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhCWBFZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:25 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944D1C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso9392259pjb.4
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRCuXlWO9YyMtC4QoqcXNltvOD/GiaNO2Jhz1FZt13o=;
        b=UtE0EcfH36+iOZKDGvz+CEh4aKm1I6XS7oxNndjps0Gj5u/80PkT6L2dtPxhs3ZoI4
         80cg/DK9N++Q9lynYZ1sf08HB6JgaDp/bFs4NqF/Owtihshx/ka8R6i66UUSNP+KQPZd
         oZtJKjfzm0tSK+pUQP1cgJa817g/Pr0Tawl5RAePqdjsasdzwMiBw43cv9P+iFZxjTIX
         PwSeBMt5ylJsH1fHggVhIYDZ+Zvsvp63Zy9T6NU/6CfG9FLWD6mjfibyWH4qWuZLy8vS
         MBM7ZPxtO4dAnEjGdSyFAAEnioulThuOmnxct3Bb6zh1qUcsy4aTQpjpHmX4vJSVRMM3
         Mlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRCuXlWO9YyMtC4QoqcXNltvOD/GiaNO2Jhz1FZt13o=;
        b=FCS1hpagDY1Mf4T2PgIvuZ160UfVmFbcwYZj0JvIOs62yMrbxfyNyEGCUFsijKrUkS
         KEIM1HK3mgjLEvtSplhWUamodEou7UilIUzetfad3XPqPF0/rtMfMw0GZF5mS83P5wMr
         4Bh42PiR9OIjlai9mfC/5sRquSqr5CcmbrjRL8RCPVkkeKBITozqkX6HLB/G7KDyu2h8
         bjFOr/8wmDaYGVXIArC6Qvo9/txwNdUk9GL3BkgauXV1sAe2hAikX1+MunZZUnmpMPyZ
         x1oW1y/fjSVXMj89qweNjAQZCE+CmUmX3jbSnms3PZjUuVE405Svf8vt4darNo0M1wFp
         lp3w==
X-Gm-Message-State: AOAM5301pr20+40ghdga/NEFeTIQyv3Wd8w2m+Z+DqCBLG2RgolyfdF3
        eCWo5aprrtduiMJ6wbFCJUR5bjq51cQ=
X-Google-Smtp-Source: ABdhPJwzL2vD+ejCkaNZV+0keENa6SLeLys+Gibv5dqdH3zKZd+XNShoryOBxfukq1+F+5BOx+jNSQ==
X-Received: by 2002:a17:90a:f3d7:: with SMTP id ha23mr1727574pjb.130.1616461523848;
        Mon, 22 Mar 2021 18:05:23 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 44/46] KVM: PPC: Book3S HV P9: implement hash guest support
Date:   Tue, 23 Mar 2021 11:03:03 +1000
Message-Id: <20210323010305.1045293-45-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Guest entry/exit has to restore and save/clear the SLB, plus several
other bits to accommodate hash guests in the P9 path.

Radix host, hash guest support is removed from the P7/8 path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c            |  20 ++-
 arch/powerpc/kvm/book3s_hv_interrupt.c  | 160 ++++++++++++++++--------
 arch/powerpc/kvm/book3s_hv_rm_mmu.c     |   4 +
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  14 +--
 4 files changed, 131 insertions(+), 67 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5b3b6842d6b9..c151a60c0daa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3828,7 +3828,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 		kvmppc_xive_pull_vcpu(vcpu);
 
-		vcpu->arch.slb_max = 0;
+		if (kvm_is_radix(vcpu->kvm))
+			vcpu->arch.slb_max = 0;
 	}
 
 	dec = mfspr(SPRN_DEC);
@@ -4061,7 +4062,6 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 /*
  * This never fails for a radix guest, as none of the operations it does
  * for a radix guest can fail or have a way to report failure.
- * kvmhv_run_single_vcpu() relies on this fact.
  */
 static int kvmhv_setup_mmu(struct kvm_vcpu *vcpu)
 {
@@ -4240,8 +4240,15 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
-	if (!kvm->arch.mmu_ready)
-		kvmhv_setup_mmu(vcpu);
+	if (!kvm->arch.mmu_ready) {
+		r = kvmhv_setup_mmu(vcpu);
+		if (r) {
+			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+			run->fail_entry.hardware_entry_failure_reason = 0;
+			vcpu->arch.ret = r;
+			return r;
+		}
+	}
 
 	if (need_resched())
 		cond_resched();
@@ -4254,7 +4261,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	preempt_disable();
 	pcpu = smp_processor_id();
 	vc->pcpu = pcpu;
-	kvmppc_prepare_radix_vcpu(vcpu, pcpu);
+	if (kvm_is_radix(kvm))
+		kvmppc_prepare_radix_vcpu(vcpu, pcpu);
 
 	local_irq_disable();
 	hard_irq_disable();
@@ -4454,7 +4462,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (kvm_is_radix(kvm))
+		if (radix_enabled())
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index cd84d2c37632..03fbfef708a8 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -55,6 +55,50 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 #define accumulate_time(vcpu, next) do {} while (0)
 #endif
 
+static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
+{
+	asm volatile("slbmfev  %0,%1" : "=r" (*slbev) : "r" (idx));
+	asm volatile("slbmfee  %0,%1" : "=r" (*slbee) : "r" (idx));
+}
+
+static inline void __mtslb(u64 slbee, u64 slbev)
+{
+	asm volatile("slbmte %0,%1" :: "r" (slbev), "r" (slbee));
+}
+
+static inline void mtslb(unsigned int idx, u64 slbee, u64 slbev)
+{
+	BUG_ON((slbee & 0xfff) != idx);
+
+	__mtslb(slbee, slbev);
+}
+
+static inline void slb_invalidate(unsigned int ih)
+{
+	asm volatile("slbia %0" :: "i"(ih));
+}
+
+/*
+ * Malicious or buggy radix guests may have inserted SLB entries
+ * (only 0..3 because radix always runs with UPRT=1), so these must
+ * be cleared here to avoid side-channels. slbmte is used rather
+ * than slbia, as it won't clear cached translations.
+ */
+static void radix_clear_slb(void)
+{
+	u64 slbee, slbev;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		mfslb(i, &slbee, &slbev);
+		if (unlikely(slbee || slbev)) {
+			slbee = i;
+			slbev = 0;
+			mtslb(i, slbee, slbev);
+		}
+	}
+}
+
 static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -80,6 +124,31 @@ static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u6
 	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
 }
 
+static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
+{
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	u32 lpid;
+	int i;
+
+	BUG_ON(nested);
+
+	lpid = kvm->arch.lpid;
+
+	mtspr(SPRN_LPID, lpid);
+	mtspr(SPRN_LPCR, lpcr);
+	mtspr(SPRN_PID, vcpu->arch.pid);
+
+	for (i = 0; i < vcpu->arch.slb_max; i++)
+		__mtslb(vcpu->arch.slb[i].orige, vcpu->arch.slb[i].origv);
+
+	isync();
+
+	/*
+	 * TLBIEL is not virtualised for HPT guests, so check_need_tlb_flush
+	 * is not required here.
+	 */
+}
+
 static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
 {
 	isync();
@@ -91,42 +160,30 @@ static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
 	isync();
 }
 
-static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
-{
-	asm volatile("slbmfev  %0,%1" : "=r" (*slbev) : "r" (idx));
-	asm volatile("slbmfee  %0,%1" : "=r" (*slbee) : "r" (idx));
-}
-
-static inline void mtslb(unsigned int idx, u64 slbee, u64 slbev)
-{
-	BUG_ON((slbee & 0xfff) != idx);
-
-	asm volatile("slbmte %0,%1" :: "r" (slbev), "r" (slbee));
-}
-
-static inline void slb_invalidate(unsigned int ih)
-{
-	asm volatile("slbia %0" :: "i"(ih));
-}
-
-/*
- * Malicious or buggy radix guests may have inserted SLB entries
- * (only 0..3 because radix always runs with UPRT=1), so these must
- * be cleared here to avoid side-channels. slbmte is used rather
- * than slbia, as it won't clear cached translations.
- */
-static void radix_clear_slb(void)
+static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
 {
-	u64 slbee, slbev;
-	int i;
+	if (kvm_is_radix(kvm)) {
+		radix_clear_slb();
+	} else {
+		int i;
+		int nr = 0;
 
-	for (i = 0; i < 4; i++) {
-		mfslb(i, &slbee, &slbev);
-		if (unlikely(slbee || slbev)) {
-			slbee = i;
-			slbev = 0;
-			mtslb(i, slbee, slbev);
+		/*
+		 * This must run before switching to host (radix host can't
+		 * access all SLBs).
+		 */
+		for (i = 0; i < vcpu->arch.slb_nr; i++) {
+			u64 slbee, slbev;
+			mfslb(i, &slbee, &slbev);
+			if (slbee & SLB_ESID_V) {
+				vcpu->arch.slb[nr].orige = slbee | i;
+				vcpu->arch.slb[nr].origv = slbev;
+				nr++;
+			}
 		}
+		vcpu->arch.slb_max = nr;
+		mtslb(0, 0, 0);
+		slb_invalidate(6);
 	}
 }
 
@@ -234,10 +291,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
+	if (kvm_is_radix(kvm)) {
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+			__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+		switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+		if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+			__mtmsrd(0, 1); /* clear RI */
 
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+	} else {
+		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+		switch_mmu_to_guest_hpt(kvm, vcpu, lpcr);
+	}
 
 	/*
 	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
@@ -245,9 +310,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-		__mtmsrd(0, 1); /* clear RI */
-
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
@@ -255,10 +317,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
 	kvmppc_p9_enter_guest(vcpu);
-	// Radix host and guest means host never runs with guest MMU state
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	accumulate_time(vcpu, &vcpu->arch.rm_intr);
 
@@ -359,8 +418,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 #endif
 	}
 
-	radix_clear_slb();
-
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
 	/* Advance host PURR/SPURR by the amount used by guest */
@@ -394,11 +451,14 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
 
-	/*
-	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
-	 * case we interrupted the guest between a tlbie and a ptesync.
-	 */
-	asm volatile("eieio; tlbsync; ptesync");
+	if (kvm_is_radix(kvm)) {
+		/*
+		 * Since this is radix, do a eieio; tlbsync; ptesync sequence
+		 * in case we interrupted the guest between a tlbie and a
+		 * ptesync.
+		 */
+		asm volatile("eieio; tlbsync; ptesync");
+	}
 
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
@@ -425,7 +485,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	/* HDEC must be at least as large as DEC, so decrementer_max fits */
 	mtspr(SPRN_HDEC, decrementer_max);
 
+	save_clear_guest_mmu(kvm, vcpu);
 	switch_mmu_to_host_radix(kvm, host_pidr);
+	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	/*
 	 * If we are in real mode, only switch MMU on after the MMU is
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 8cc73abbf42b..f487ebb3a70a 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -57,6 +57,10 @@ static int global_invalidates(struct kvm *kvm)
 	else
 		global = 1;
 
+	/* LPID has been switched to host if in virt mode so can't do local */
+	if (!global && (mfmsr() & (MSR_IR|MSR_DR)))
+		global = 1;
+
 	if (!global) {
 		/* any other core might now have stale TLB entries... */
 		smp_wmb();
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 564ca9feef35..5cbc26ebcf8e 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -885,14 +885,11 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	cmpdi	r3, 512		/* 1 microsecond */
 	blt	hdec_soon
 
-	/* For hash guest, clear out and reload the SLB */
-BEGIN_MMU_FTR_SECTION
-	/* Radix host won't have populated the SLB, so no need to clear */
+	/* Clear out and reload the SLB */
 	li	r6, 0
 	slbmte	r6, r6
 	PPC_SLBIA(6)
 	ptesync
-END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 
 	/* Load up guest SLB entries (N.B. slb_max will be 0 for radix) */
 	lwz	r5,VCPU_SLB_MAX(r4)
@@ -1394,9 +1391,6 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	stw	r5,VCPU_SLB_MAX(r9)
 
 	/* load host SLB entries */
-BEGIN_MMU_FTR_SECTION
-	b	guest_bypass
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 	ld	r8,PACA_SLBSHADOWPTR(r13)
 
 	.rept	SLB_NUM_BOLTED
@@ -3148,10 +3142,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 	PPC_SLBIA(6)
 	ptesync
 
-BEGIN_MMU_FTR_SECTION
-	b	4f
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
-
 	/* load host SLB entries */
 	ld	r8, PACA_SLBSHADOWPTR(r13)
 	.rept	SLB_NUM_BOLTED
@@ -3165,7 +3155,7 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 3:	addi	r8, r8, 16
 	.endr
 
-4:	lwz	r7, KVM_HOST_LPID(r10)
+	lwz	r7, KVM_HOST_LPID(r10)
 	mtspr	SPRN_LPID, r7
 	mtspr	SPRN_PID, r0
 	ld	r8, KVM_HOST_LPCR(r10)
-- 
2.23.0

