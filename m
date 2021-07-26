Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A483D51B8
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhGZDLL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBE0C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b6so11101105pji.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yrQqMqJQy0pD69345VC9XUGRd5IuhvhW0vV2AuIPX00=;
        b=S6/W3WJS8IFExRdExqTAvDDz6z0UTUOsILfUtj+NLBTHO/LV3RWAyVHeK2HZJ008/U
         zLkS19ZdH4MF2L55rd5X4oAVDSBqCYBjg8T+7BJ8U8utfoegtEHdjRXonYpCkGkkYzYr
         7RBm9lSC6Lpmy9TzULKFViXqEMWbKNgOhTiS6g3WPqsEM1U1zAPFK1GGZN2mKrmBX3xd
         cebU/hVXh/u4ISsvtlgPXa/Wl8Y+xeefHABFXYrm9Cwiaq/7FYG2/GRqi15I30oqmgo9
         oEq2FuXu0of0g+B+wg01+bUPX/tuRmvt52PajX2DZHSHDaNNV3k+zmbQ3DwosEjjCX8G
         MCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yrQqMqJQy0pD69345VC9XUGRd5IuhvhW0vV2AuIPX00=;
        b=kMeQCGOx5kXaQpT/5h1O9u6Pdq3NZDxsy/odnqKntswtyoKadYlaKGDPwQgt2yBbN9
         o1wubBRn3yfp3QZgjhtlgKoNi95x5SrHDqZu94Boaj1s2v8A5qUIYZ0+mArPqJa+hufo
         gLj9I/UUAyvRoKlGHdWDoXnCSY/daALv33kXDOuaAEDE1fAFSGl3rwKhCI6o/XfSEwEy
         RpD9c+hJYNDO0UPqE+4oFUnuyJllPb+i0D7a+GlmFFEkp6mhbeQwHOJYyVq6ejXP7IPi
         LC6Xzm65DAVGNA06eJVfACOFJhK+OL07o7+4bAmZWViiYoHEzK5YnX9L4aD8B+4VArjK
         4Yuw==
X-Gm-Message-State: AOAM533XCQ89G3almU8lcisi3hoprJHVLXM2no6jEaGOfIyQWgx8mrSP
        xzBosrqgROSGvrD2CgFdedEyCEPJObw=
X-Google-Smtp-Source: ABdhPJyvmfU7zAJVedynlPUw2XNSDPiMja3RDY2SXQXjITzUPKoZrA/HjwMtqnySk+q1TQa1GiahNQ==
X-Received: by 2002:a17:90a:7884:: with SMTP id x4mr25345156pjk.53.1627271499434;
        Sun, 25 Jul 2021 20:51:39 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 23/55] KVM: PPC: Book3S HV P9: Reduce mtmsrd instructions required to save host SPRs
Date:   Mon, 26 Jul 2021 13:50:04 +1000
Message-Id: <20210726035036.739609-24-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This reduces the number of mtmsrd required to enable facility bits when
saving/restoring registers, by having the KVM code set all bits up front
rather than using individual facility functions that set their particular
MSR bits.

-42 cycles (7803) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/process.c         | 24 +++++++++++
 arch/powerpc/kvm/book3s_hv.c          | 61 ++++++++++++++++++---------
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  1 +
 3 files changed, 67 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 185beb290580..00b55b38a460 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -593,6 +593,30 @@ static void save_all(struct task_struct *tsk)
 	msr_check_and_clear(msr_all_available);
 }
 
+void save_user_regs_kvm(void)
+{
+	unsigned long usermsr;
+
+	if (!current->thread.regs)
+		return;
+
+	usermsr = current->thread.regs->msr;
+
+	if (usermsr & MSR_FP)
+		save_fpu(current);
+
+	if (usermsr & MSR_VEC)
+		save_altivec(current);
+
+	if (usermsr & MSR_TM) {
+                current->thread.tm_tfhar = mfspr(SPRN_TFHAR);
+                current->thread.tm_tfiar = mfspr(SPRN_TFIAR);
+                current->thread.tm_texasr = mfspr(SPRN_TEXASR);
+                current->thread.regs->msr &= ~MSR_TM;
+	}
+}
+EXPORT_SYMBOL_GPL(save_user_regs_kvm);
+
 void flush_all_to_thread(struct task_struct *tsk)
 {
 	if (tsk->thread.regs) {
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2e966d62a583..dedcf3ddba3b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4103,6 +4103,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
 	u64 tb, next_timer;
+	unsigned long msr;
 	int trap;
 
 	WARN_ON_ONCE(vcpu->arch.ceded);
@@ -4114,8 +4115,23 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (next_timer < time_limit)
 		time_limit = next_timer;
 
+	vcpu->arch.ceded = 0;
+
 	save_p9_host_os_sprs(&host_os_sprs);
 
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
 	kvmppc_subcore_enter_guest();
 
 	vc->entry_exit_map = 1;
@@ -4124,12 +4140,13 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+		msr = mfmsr(); /* TM restore can update msr */
+	}
 
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
-	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	load_vr_state(&vcpu->arch.vr);
@@ -4238,7 +4255,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4767,6 +4783,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	goto done;
 }
 
+void save_user_regs_kvm(void);
+
 static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
@@ -4776,19 +4794,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	unsigned long user_tar = 0;
 	unsigned int user_vrsave;
 	struct kvm *kvm;
+	unsigned long msr;
 
 	if (!vcpu->arch.sane) {
 		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return -EINVAL;
 	}
 
+	/* No need to go into the guest when all we'll do is come back out */
+	if (signal_pending(current)) {
+		run->exit_reason = KVM_EXIT_INTR;
+		return -EINTR;
+	}
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	/*
 	 * Don't allow entry with a suspended transaction, because
 	 * the guest entry/exit code will lose it.
-	 * If the guest has TM enabled, save away their TM-related SPRs
-	 * (they will get restored by the TM unavailable interrupt).
 	 */
-#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (cpu_has_feature(CPU_FTR_TM) && current->thread.regs &&
 	    (current->thread.regs->msr & MSR_TM)) {
 		if (MSR_TM_ACTIVE(current->thread.regs->msr)) {
@@ -4796,12 +4819,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 			run->fail_entry.hardware_entry_failure_reason = 0;
 			return -EINVAL;
 		}
-		/* Enable TM so we can read the TM SPRs */
-		mtmsr(mfmsr() | MSR_TM);
-		current->thread.tm_tfhar = mfspr(SPRN_TFHAR);
-		current->thread.tm_tfiar = mfspr(SPRN_TFIAR);
-		current->thread.tm_texasr = mfspr(SPRN_TEXASR);
-		current->thread.regs->msr &= ~MSR_TM;
 	}
 #endif
 
@@ -4816,18 +4833,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	kvmppc_core_prepare_to_enter(vcpu);
 
-	/* No need to go into the guest when all we'll do is come back out */
-	if (signal_pending(current)) {
-		run->exit_reason = KVM_EXIT_INTR;
-		return -EINTR;
-	}
-
 	kvm = vcpu->kvm;
 	atomic_inc(&kvm->arch.vcpus_running);
 	/* Order vcpus_running vs. mmu_ready, see kvmppc_alloc_reset_hpt */
 	smp_mb();
 
-	flush_all_to_thread(current);
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
+	save_user_regs_kvm();
 
 	/* Save userspace EBB and other register values */
 	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a7f63082b4e3..fb9cb34445ea 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -224,6 +224,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = vc->tb_offset;
 	}
 
+	/* Could avoid mfmsr by passing around, but probably no big deal */
 	msr = mfmsr();
 
 	host_hfscr = mfspr(SPRN_HFSCR);
-- 
2.23.0

