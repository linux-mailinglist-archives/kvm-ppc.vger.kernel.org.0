Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9284E3B020E
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhFVLBX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLBX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5430C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e33so16758849pgm.3
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ea9YXWslvYyO0atVaCUJTWFsUNZ2yqiz45hhoWfNwM8=;
        b=lIE9vIf8rr5TsM4bH7UIAwDMrK2Cc9GQJ1dTj/DmYmqoLOMv4nUH7xFc0lbg95BQKV
         p8Z2r/34M7KHsf4j63ZW5pr9De27Gm6RIhTWfQHco5N8dwFHRLNrfaeXJSwUe6N4boL4
         Q/9N/MHXwmaI5cT/YSdc6xBpMZVMuucmWD0po4v2mbfHD+4IQ4KTjyDZ2nxze+V845J9
         nNf42jNzAlyBdoDV+3lstJXqAB1vJpJyjSiHeO3H1pCnNZCDnvwxB+e7xFAQbzk507qY
         9BV3Uq6q6GU6tKQZm3E5EtKigBUQQp+Rxf45Anjp+I5q6mLuWbizZEZvoIfcCRz8DZCw
         1fyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ea9YXWslvYyO0atVaCUJTWFsUNZ2yqiz45hhoWfNwM8=;
        b=pfPgz9iSH8eOX3dXITAlM8Vt96Pgzz59rLfPKEh18iMwv9m4FeVedjxuLGYjJ+OrKy
         nN9c0Rj5eFGzrOQxkKOw8QXRW18OgZChf1MMD7iOTeeHmlixTnwmLQuarmwo82BLoeEa
         nTmjrQ4gLeKdxPi8uLUNgQlLo0iV/F3n2N2yCq+9U8RVDv/cKzKHlOGQc/mM536KaxUQ
         cbbDlCmWB/AXbUsG9m63ZWHrqaDb8x1855PLZggdiN//ReW9OHmHvlrB3QM2WYb9FDMJ
         9KP/CukVgVLeuEE31YwvLc0HrwjNB0GbGV8B/hdpm5FXgWn3ns/EYue56q8rldiVeHd3
         iwqw==
X-Gm-Message-State: AOAM533XIAdoUkeqFpqm7FDll6CY5PUT0BGAmbbaGEMMjJqQWIkij9A6
        wh9gn1Dw2F70ZEQcfSTcNEJSGIIQDeE=
X-Google-Smtp-Source: ABdhPJyFAftQHLVmQjLz3gRwVoc4mEBQ5uLWdaunCz6tAF5B4H9tlPJhFKK/7cWj3PKPutxNoJy2NQ==
X-Received: by 2002:a63:7985:: with SMTP id u127mr627916pgc.228.1624359547180;
        Tue, 22 Jun 2021 03:59:07 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 29/43] KVM: PPC: Book3S HV P9: Move remaining SPR and MSR access into low level entry
Date:   Tue, 22 Jun 2021 20:57:22 +1000
Message-Id: <20210622105736.633352-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move register saving and loading from kvmhv_p9_guest_entry() into the HV
and nested entry handlers.

Accesses are scheduled to reduce mtSPR / mfSPR interleaving which
reduces SPR scoreboard stalls.

XXX +212 cycles here somewhere (7566), investigate  POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 77 ++++++++++++--------------
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 80 ++++++++++++++++++++-------
 2 files changed, 96 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 64386fc0cd00..ee4002c33f89 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3697,9 +3697,15 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long host_psscr;
+	unsigned long msr;
 	struct hv_guest_state hvregs;
-	int trap;
+	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
+	int trap;
+
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
+
+	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
 	 * We need to save and restore the guest visible part of the
@@ -3708,6 +3714,26 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
 	 */
 	host_psscr = mfspr(SPRN_PSSCR_PR);
+
+	hard_irq_disable();
+	if (lazy_irq_pending())
+		return 0;
+
+	/* MSR bits may have been cleared by context switch */
+	msr = 0;
+	if (IS_ENABLED(CONFIG_PPC_FPU))
+		msr |= MSR_FP;
+	if (cpu_has_feature(CPU_FTR_ALTIVEC))
+		msr |= MSR_VEC;
+	if (cpu_has_feature(CPU_FTR_VSX))
+		msr |= MSR_VSX;
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		msr |= MSR_TM;
+	msr = msr_check_and_set(msr);
+
+	load_vcpu_state(vcpu, &host_os_sprs);
+
 	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
@@ -3749,12 +3775,20 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
 	mtspr(SPRN_PSSCR_PR, host_psscr);
 
+	store_vcpu_state(vcpu);
+
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
 	*tb = mftb();
 	vcpu->arch.dec_expires = dec + (*tb + vc->tb_offset);
 
+	timer_rearm_host_dec(*tb);
+
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+
+	switch_pmu_to_host(vcpu, &host_os_sprs);
+
 	return trap;
 }
 
@@ -3765,9 +3799,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr, u64 *tb)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	struct p9_host_os_sprs host_os_sprs;
 	u64 next_timer;
-	unsigned long msr;
 	int trap;
 
 	next_timer = timer_get_next_tb();
@@ -3778,33 +3810,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
-	save_p9_host_os_sprs(&host_os_sprs);
-
-	/*
-	 * This could be combined with MSR[RI] clearing, but that expands
-	 * the unrecoverable window. It would be better to cover unrecoverable
-	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
-	 *
-	 * Much more difficult and less worthwhile to combine with IR/DR
-	 * disable.
-	 */
-	hard_irq_disable();
-	if (lazy_irq_pending())
-		return 0;
-
-	/* MSR bits may have been cleared by context switch */
-	msr = 0;
-	if (IS_ENABLED(CONFIG_PPC_FPU))
-		msr |= MSR_FP;
-	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		msr |= MSR_VEC;
-	if (cpu_has_feature(CPU_FTR_VSX))
-		msr |= MSR_VSX;
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		msr |= MSR_TM;
-	msr = msr_check_and_set(msr);
-
 	kvmppc_subcore_enter_guest();
 
 	vc->entry_exit_map = 1;
@@ -3812,10 +3817,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	load_vcpu_state(vcpu, &host_os_sprs);
-
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	if (kvmhv_on_pseries()) {
 		trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
 
@@ -3858,16 +3859,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
-	store_vcpu_state(vcpu);
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	timer_rearm_host_dec(*tb);
-
-	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index cc74cd314fcf..f5098995f5cb 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -517,6 +517,7 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb)
 {
+	struct p9_host_os_sprs host_os_sprs;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -546,9 +547,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ceded = 0;
 
-	/* Could avoid mfmsr by passing around, but probably no big deal */
-	msr = mfmsr();
-
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
 	host_dawr0 = mfspr(SPRN_DAWR0);
@@ -563,6 +561,38 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
 	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
+
+	save_p9_host_os_sprs(&host_os_sprs);
+
+	/*
+	 * This could be combined with MSR[RI] clearing, but that expands
+	 * the unrecoverable window. It would be better to cover unrecoverable
+	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
+	 *
+	 * Much more difficult and less worthwhile to combine with IR/DR
+	 * disable.
+	 */
+	hard_irq_disable();
+	if (lazy_irq_pending()) {
+		trap = 0;
+		goto out;
+	}
+
+	/* MSR bits may have been cleared by context switch */
+	msr = 0;
+	if (IS_ENABLED(CONFIG_PPC_FPU))
+		msr |= MSR_FP;
+	if (cpu_has_feature(CPU_FTR_ALTIVEC))
+		msr |= MSR_VEC;
+	if (cpu_has_feature(CPU_FTR_VSX))
+		msr |= MSR_VSX;
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		msr |= MSR_TM;
+	msr = msr_check_and_set(msr);
+	/* Save MSR for restore. This is after hard disable, so EE is clear. */
+
 	if (vc->tb_offset) {
 		u64 new_tb = *tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -623,6 +653,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_P9;
 
+	load_vcpu_state(vcpu, &host_os_sprs);
+
 	/*
 	 * Hash host, hash guest, or radix guest with prefetch bug, all have
 	 * to disable the MMU before switching to guest MMU state.
@@ -783,6 +815,17 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 
+	save_clear_guest_mmu(kvm, vcpu);
+	switch_mmu_to_host(kvm, host_pidr);
+
+	/*
+	 * If we are in real mode, only switch MMU on after the MMU is
+	 * switched to host, to avoid the P9_RADIX_PREFETCH_BUG.
+	 */
+	__mtmsrd(msr, 0);
+
+	store_vcpu_state(vcpu);
+
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -815,6 +858,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
 
+	mtspr(SPRN_DPDES, 0);
+	if (vc->pcr)
+		mtspr(SPRN_PCR, PCR_MASK);
+
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
+
+	timer_rearm_host_dec(*tb);
+
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+
+	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
+
 	if (kvm_is_radix(kvm)) {
 		/*
 		 * Since this is radix, do a eieio; tlbsync; ptesync sequence
@@ -831,22 +887,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	mtspr(SPRN_DPDES, 0);
-	if (vc->pcr)
-		mtspr(SPRN_PCR, PCR_MASK);
-
-	/* HDEC must be at least as large as DEC, so decrementer_max fits */
-	mtspr(SPRN_HDEC, decrementer_max);
-
-	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host(kvm, host_pidr);
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
-
-	/*
-	 * If we are in real mode, only switch MMU on after the MMU is
-	 * switched to host, to avoid the P9_RADIX_PREFETCH_BUG.
-	 */
-	__mtmsrd(msr, 0);
+out:
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	end_timing(vcpu);
 
-- 
2.23.0

