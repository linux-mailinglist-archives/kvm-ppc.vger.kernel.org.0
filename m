Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B1035183B
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbhDARoU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbhDARku (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:40:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F058C00F7C1
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:14 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c17so1671714pfn.6
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KbMv1FLHN3G+ay/vb1ilTgjC3J23UBOH9e/WpZMdM5M=;
        b=KlEtLdg5KOTWbb73mI7l/7n6TIxWqL+CMVbSQiLWXQDSf0le+wgn6yg4mFau5Do0Qt
         8hMUlcUI6FuFNKuXBi3imUtFj0s+i3W091Dc9ruqxTLDvK4kvvkjjgnX4xwaHncX4o3i
         L1fuzqywyXtoM57jKlVk2ipE8eT6bjQVw88q6SPXt0QqcT585hAy8nWTzUhM5SVniUjC
         Wv/VfqR9WLC0dsbverqRdxzspPiOgfTH/+nnCauZSfygIiEwOmKfwUQ55r32mgm3UuBe
         yZdNp4Y4f7b3tyeO/4XbvRLvxa57RBx83/CNNQ/w1mBDFXoYY+x0Gvcrt90O4jCzFVtd
         Zd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KbMv1FLHN3G+ay/vb1ilTgjC3J23UBOH9e/WpZMdM5M=;
        b=bjH8mTI3xhlzLpHnoYWfFRPYIVRH49n7ZvwPAUrG4mlJ9vnU/k+LYGLZo5uidzDxwU
         7Ml1aHHJ4f/47aR+ucT8nMtr4oe3KHW54Bae9HQ/t/Yx0HONEebAdQDwQ5R0rsVDkCjT
         baGyfIxruftdGeaw1HrQTxzx9SWBCVvDvjkbPvVEZ83EHeZ7enFkgxl2DDiLnU2twrix
         9864p4mqBku7/XGoWLfQ6Qae0Ay4JmVyk3+O+FylR78qoNCSBdJtNlFG+R0kxCRq/6tt
         lJXn2dTXw+Brgr8k/rBHxQUyuCSYUxQ0pOXcIXIdGBcwWHHh/d8MxZNWYOowi//POnCq
         n0Bg==
X-Gm-Message-State: AOAM530miAjXXg1KjG6tjIiGblAefkJR6mrHA42pq+prikllkoJPe/WA
        ZajvMSnJjI+yefvhTnQDYNVsRgDbQdA=
X-Google-Smtp-Source: ABdhPJzZ8LpogSt01o5R0FmXnodTWJN5ZhQVgSWlgxOquYbFN0eqin08894ZwKv+D87xUcCrHMGx/Q==
X-Received: by 2002:a63:3102:: with SMTP id x2mr7850103pgx.123.1617289513160;
        Thu, 01 Apr 2021 08:05:13 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 31/48] KVM: PPC: Book3S HV P9: inline kvmhv_load_hv_regs_and_go into __kvmhv_vcpu_entry_p9
Date:   Fri,  2 Apr 2021 01:03:08 +1000
Message-Id: <20210401150325.442125-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Now the initial C implementation is done, inline more HV code to make
rearranging things easier.

And rename __kvmhv_vcpu_entry_p9 to drop the leading underscores as it's
now C, and is now a more complete vcpu entry.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |   2 +-
 arch/powerpc/kvm/book3s_hv.c             | 192 +----------------------
 arch/powerpc/kvm/book3s_hv_interrupt.c   | 179 ++++++++++++++++++++-
 3 files changed, 180 insertions(+), 193 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index c214bcffb441..eaf3a562bf1e 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -153,7 +153,7 @@ static inline bool kvmhv_vcpu_is_radix(struct kvm_vcpu *vcpu)
 	return radix;
 }
 
-int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu);
+int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr);
 
 #define KVM_DEFAULT_HPT_ORDER	24	/* 16MB HPT by default */
 #endif
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e579b935ead0..af0eedcaab8b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3492,194 +3492,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
-static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	struct kvm_nested_guest *nested = vcpu->arch.nested;
-	u32 lpid;
-
-	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
-
-	/*
-	 * All the isync()s are overkill but trivially follow the ISA
-	 * requirements. Some can likely be replaced with justification
-	 * comment for why they are not needed.
-	 */
-	isync();
-	mtspr(SPRN_LPID, lpid);
-	isync();
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
-	mtspr(SPRN_PID, vcpu->arch.pid);
-	isync();
-
-	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
-	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
-}
-
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
-{
-	isync();
-	mtspr(SPRN_PID, pid);
-	isync();
-	mtspr(SPRN_LPID, kvm->arch.host_lpid);
-	isync();
-	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-	isync();
-}
-
-/*
- * Load up hypervisor-mode registers on P9.
- */
-static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
-				     unsigned long lpcr)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	s64 hdec;
-	u64 tb, purr, spurr;
-	int trap;
-	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
-	unsigned long host_ciabr = mfspr(SPRN_CIABR);
-	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
-	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
-	unsigned long host_psscr = mfspr(SPRN_PSSCR);
-	unsigned long host_pidr = mfspr(SPRN_PID);
-	unsigned long host_dawr1 = 0;
-	unsigned long host_dawrx1 = 0;
-
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
-	}
-
-	tb = mftb();
-	hdec = time_limit - tb;
-	if (hdec < 0)
-		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-
-	if (vc->tb_offset) {
-		u64 new_tb = tb + vc->tb_offset;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = vc->tb_offset;
-	}
-
-	if (vc->pcr)
-		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
-	mtspr(SPRN_DPDES, vc->dpdes);
-	mtspr(SPRN_VTB, vc->vtb);
-
-	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
-	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, vcpu->arch.purr);
-	mtspr(SPRN_SPURR, vcpu->arch.spurr);
-
-	if (dawr_enabled()) {
-		mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
-		mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
-		if (cpu_has_feature(CPU_FTR_DAWR1)) {
-			mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
-			mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
-		}
-	}
-	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
-	mtspr(SPRN_IC, vcpu->arch.ic);
-
-	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
-
-	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
-
-	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
-	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
-	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
-
-	mtspr(SPRN_AMOR, ~0UL);
-
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-
-	/*
-	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
-	 * so set guest LPCR (with HDICE) before writing HDEC.
-	 */
-	mtspr(SPRN_HDEC, hdec);
-
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
-	trap = __kvmhv_vcpu_entry_p9(vcpu);
-
-	/* Advance host PURR/SPURR by the amount used by guest */
-	purr = mfspr(SPRN_PURR);
-	spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
-	      purr - vcpu->arch.purr);
-	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
-	      spurr - vcpu->arch.spurr);
-	vcpu->arch.purr = purr;
-	vcpu->arch.spurr = spurr;
-
-	vcpu->arch.ic = mfspr(SPRN_IC);
-	vcpu->arch.pid = mfspr(SPRN_PID);
-	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
-
-	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
-	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
-	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
-	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
-
-	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
-	mtspr(SPRN_PSSCR, host_psscr |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
-	mtspr(SPRN_HFSCR, host_hfscr);
-	mtspr(SPRN_CIABR, host_ciabr);
-	mtspr(SPRN_DAWR0, host_dawr0);
-	mtspr(SPRN_DAWRX0, host_dawrx0);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		mtspr(SPRN_DAWR1, host_dawr1);
-		mtspr(SPRN_DAWRX1, host_dawrx1);
-	}
-
-	/*
-	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
-	 * case we interrupted the guest between a tlbie and a ptesync.
-	 */
-	asm volatile("eieio; tlbsync; ptesync");
-
-	/*
-	 * cp_abort is required if the processor supports local copy-paste
-	 * to clear the copy buffer that was under control of the guest.
-	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		asm volatile(PPC_CP_ABORT);
-
-	vc->dpdes = mfspr(SPRN_DPDES);
-	vc->vtb = mfspr(SPRN_VTB);
-	mtspr(SPRN_DPDES, 0);
-	if (vc->pcr)
-		mtspr(SPRN_PCR, PCR_MASK);
-
-	if (vc->tb_offset_applied) {
-		u64 new_tb = mftb() - vc->tb_offset_applied;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = 0;
-	}
-
-	/* HDEC must be at least as large as DEC, so decrementer_max fits */
-	mtspr(SPRN_HDEC, decrementer_max);
-
-	switch_mmu_to_host_radix(kvm, host_pidr);
-
-	return trap;
-}
-
 static inline bool hcall_is_xics(unsigned long req)
 {
 	return req == H_EOI || req == H_CPPR || req == H_IPI ||
@@ -3776,7 +3588,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		 * We need to save and restore the guest visible part of the
 		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
 		 * doesn't do this for us. Note only required if pseries since
-		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
+		 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
 		 */
 		unsigned long host_psscr;
 		/* call our hypervisor to load up HV regs and go */
@@ -3814,7 +3626,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
-		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr);
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    !(vcpu->arch.shregs.msr & MSR_PR)) {
 			unsigned long req = kvmppc_get_gpr(vcpu, 3);
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 69f861cf3b90..15f1b78c5c90 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -55,6 +55,42 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 #define accumulate_time(vcpu, next) do {} while (0)
 #endif
 
+static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	u32 lpid;
+
+	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
+
+	/*
+	 * All the isync()s are overkill but trivially follow the ISA
+	 * requirements. Some can likely be replaced with justification
+	 * comment for why they are not needed.
+	 */
+	isync();
+	mtspr(SPRN_LPID, lpid);
+	isync();
+	mtspr(SPRN_LPCR, lpcr);
+	isync();
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	isync();
+	mtspr(SPRN_PID, pid);
+	isync();
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
+	isync();
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
+	isync();
+}
+
 static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
 {
 	asm volatile("slbmfev  %0,%1" : "=r" (*slbev) : "r" (idx));
@@ -89,11 +125,86 @@ static void radix_clear_slb(void)
 	}
 }
 
-int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu)
+int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr)
 {
+	struct kvm *kvm = vcpu->kvm;
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	s64 hdec;
+	u64 tb, purr, spurr;
 	u64 *exsave;
 	unsigned long msr = mfmsr();
 	int trap;
+	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
+	unsigned long host_ciabr = mfspr(SPRN_CIABR);
+	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
+	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
+	unsigned long host_psscr = mfspr(SPRN_PSSCR);
+	unsigned long host_pidr = mfspr(SPRN_PID);
+	unsigned long host_dawr1 = 0;
+	unsigned long host_dawrx1 = 0;
+
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		host_dawr1 = mfspr(SPRN_DAWR1);
+		host_dawrx1 = mfspr(SPRN_DAWRX1);
+	}
+
+	tb = mftb();
+	hdec = time_limit - tb;
+	if (hdec < 0)
+		return BOOK3S_INTERRUPT_HV_DECREMENTER;
+
+	if (vc->tb_offset) {
+		u64 new_tb = tb + vc->tb_offset;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = vc->tb_offset;
+	}
+
+	if (vc->pcr)
+		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
+	mtspr(SPRN_DPDES, vc->dpdes);
+	mtspr(SPRN_VTB, vc->vtb);
+
+	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
+	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
+	mtspr(SPRN_PURR, vcpu->arch.purr);
+	mtspr(SPRN_SPURR, vcpu->arch.spurr);
+
+	if (dawr_enabled()) {
+		mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
+		mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
+			mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
+		}
+	}
+	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
+	mtspr(SPRN_IC, vcpu->arch.ic);
+
+	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
+	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+
+	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
+
+	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
+	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
+	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
+	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
+
+	mtspr(SPRN_AMOR, ~0UL);
+
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
+	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
+	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
@@ -213,6 +324,70 @@ int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu)
 
 	end_timing(vcpu);
 
+	/* Advance host PURR/SPURR by the amount used by guest */
+	purr = mfspr(SPRN_PURR);
+	spurr = mfspr(SPRN_SPURR);
+	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
+	      purr - vcpu->arch.purr);
+	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
+	      spurr - vcpu->arch.spurr);
+	vcpu->arch.purr = purr;
+	vcpu->arch.spurr = spurr;
+
+	vcpu->arch.ic = mfspr(SPRN_IC);
+	vcpu->arch.pid = mfspr(SPRN_PID);
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
+
+	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
+	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
+	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
+	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
+
+	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
+	mtspr(SPRN_PSSCR, host_psscr |
+	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	mtspr(SPRN_HFSCR, host_hfscr);
+	mtspr(SPRN_CIABR, host_ciabr);
+	mtspr(SPRN_DAWR0, host_dawr0);
+	mtspr(SPRN_DAWRX0, host_dawrx0);
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		mtspr(SPRN_DAWR1, host_dawr1);
+		mtspr(SPRN_DAWRX1, host_dawrx1);
+	}
+
+	/*
+	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
+	 * case we interrupted the guest between a tlbie and a ptesync.
+	 */
+	asm volatile("eieio; tlbsync; ptesync");
+
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		asm volatile(PPC_CP_ABORT);
+
+	vc->dpdes = mfspr(SPRN_DPDES);
+	vc->vtb = mfspr(SPRN_VTB);
+	mtspr(SPRN_DPDES, 0);
+	if (vc->pcr)
+		mtspr(SPRN_PCR, PCR_MASK);
+
+	if (vc->tb_offset_applied) {
+		u64 new_tb = mftb() - vc->tb_offset_applied;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = 0;
+	}
+
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
+
 	return trap;
 }
-EXPORT_SYMBOL_GPL(__kvmhv_vcpu_entry_p9);
+EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

