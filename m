Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55F23250CF
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBYNtR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhBYNtO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:14 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCE6C06178A
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:27 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 201so3646577pfw.5
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WOBDp9+4bbeXpaMJ2aqQcKk8uET1HUF6JVdPf/T7HGY=;
        b=po96VUhV6ewN5kgH0dxIV1O0LoEsfULxB7F1Mw85RetpUF+36GjyXrXmyMlCPNI7qw
         0bpSrQBVbnlNG5fxp+Yl0WM6QFLDBTlY1NJsuMQj6GnQTgykB/yphuBM6DZVH2abTqRn
         vPX8FLtB48cboqAwc1CBtG64/PVcMA33CjHpHvoeEKSY/SQXdrr2vUo5OhLzJQrntLJ2
         5WBCDLKqqUEJ5O9vQ/9tK8OtTQqHBnKQU3Cri6RTVnJ/HgPEpQTithpmOR/CW+zftEPy
         3srHn3zwHiSnVTesjA8D0u/hCoSdkkcmJTMMIBJjySaLEm2HI1EZM7KbsP6q/inCWj9/
         rNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WOBDp9+4bbeXpaMJ2aqQcKk8uET1HUF6JVdPf/T7HGY=;
        b=MULGFWR4US0Cb3KdPqEWVIlmmhU31zvgNIzKCGkKcGqm3GpIAvPQEFXlrjZXq4K1aY
         ezCM1QXgXSpyQrN+FeOTxFqsSmc9nYn3tSiFi72sNDb6u2y6XU1SCGZY8AZr+/OFX1gF
         /Ct9SFy0vsxWev9k5X6M0sWmya56XqhU//4sogA545g4vx1YEFHJOad0fKy2gBm8b0i2
         m5Fb2k3iUt2QkYZv/teIaxzFgrLoOjccHwWIkvMpQqb630vwVuJa5a6xH6YJIfgOt5Uj
         OMVMi/I2i0mnKVMd/BVOdV73RdWW9rKvoTfYwZylYPjyDOABRCDSNq27ub11Cmi7OUVi
         kvmQ==
X-Gm-Message-State: AOAM5318L5Tj8od4wts7ym1CyNOWwoyKjmZAhlQzkHwbmjAmwHhC/cda
        /6xPcUOCq3sDmOsDdsnZ8DemByOOHnc=
X-Google-Smtp-Source: ABdhPJw0ALIgIEy19/MZdaDIg8UdWZk5Odqes6JB35w8D18J5DjyGMySMxgvQ80QfbODwMV8php7lw==
X-Received: by 2002:a05:6a00:23c5:b029:1e6:2f2e:a438 with SMTP id g5-20020a056a0023c5b02901e62f2ea438mr3426435pfc.75.1614260906630;
        Thu, 25 Feb 2021 05:48:26 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:25 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 24/37] KVM: PPC: Book3S HV P9: inline kvmhv_load_hv_regs_and_go into __kvmhv_vcpu_entry_p9
Date:   Thu, 25 Feb 2021 23:46:39 +1000
Message-Id: <20210225134652.2127648-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Now the initial C implementation is done, inline more HV code to make
rearranging things easier.

And rename __kvmhv_vcpu_entry_p9 to drop the leading underscores as it's
now C, and is now a more complete vcpu entry.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |   2 +-
 arch/powerpc/kvm/book3s_hv.c             | 181 +----------------------
 arch/powerpc/kvm/book3s_hv_interrupt.c   | 168 ++++++++++++++++++++-
 3 files changed, 169 insertions(+), 182 deletions(-)

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
index 28a2761515e3..f99503acdda5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3442,183 +3442,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
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
-	mtspr(SPRN_LPID, lpid);
-	mtspr(SPRN_LPCR, lpcr);
-	mtspr(SPRN_PID, vcpu->arch.pid);
-	isync();
-
-	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
-	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
-}
-
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
-{
-	mtspr(SPRN_PID, pid);
-	mtspr(SPRN_LPID, kvm->arch.host_lpid);
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
 /*
  * Virtual-mode guest entry for POWER9 and later when the host and
  * guest are both using the radix MMU.  The LPIDR has already been set.
@@ -3710,7 +3533,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		 * We need to save and restore the guest visible part of the
 		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
 		 * doesn't do this for us. Note only required if pseries since
-		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
+		 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
 		 */
 		unsigned long host_psscr;
 		/* call our hypervisor to load up HV regs and go */
@@ -3748,7 +3571,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
-		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr);
 		/* H_CEDE has to be handled now, not later */
 		/* XICS hcalls must be handled before xive is pulled */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL &&
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 5a7b036c447f..dea3eca3648a 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -55,6 +55,31 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
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
+	mtspr(SPRN_LPID, lpid);
+	mtspr(SPRN_LPCR, lpcr);
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	mtspr(SPRN_PID, pid);
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
+	isync();
+}
+
 static inline void mfslb(unsigned int idx, u64 *slbee, u64 *slbev)
 {
 	asm volatile("slbmfev  %0,%1" : "=r" (*slbev) : "r" (idx));
@@ -94,11 +119,86 @@ static void radix_clear_slb(void)
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
 
@@ -216,6 +316,70 @@ int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu)
 
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

