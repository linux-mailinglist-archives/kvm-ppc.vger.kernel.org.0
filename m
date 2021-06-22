Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220D93B0201
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhFVLAz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLAy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC1BC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n12so8016593pgs.13
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ITsM8tsSlbJfZ+Ldu3+rnsEdugvf0kDy/XukEdbFsjQ=;
        b=EnTO5pATCYsvRcWdXxyJ6W7Fxo/rRQqLPIyemWuVLXBgKllP/1xL/m4xUJYnl5PJyM
         uKEvHtc9ApQ8Qtc8lrOXNFh8whU7RqcinCXLB/985370eQQVBjxnH2jV7+XvqkyKeUUm
         XKjZBLnF/mVmIfPWpKegR2sElsc19gyZKZPk11PY4gwJ3Wobjft41PK01X2P+TbX0JxY
         wCxAp73TOj6UOzJlndW6S2zc7mJW/K+XrBM1MinEYlXj0/Njze4TCwTPaZf3MVAWlu5u
         HDOq2Ubx/9SpbUqv7tk0CAmJ6Ib+kwqHDHVVlo3ArZC6zEueieDhP5DEaSVM2F0PyWx8
         MV8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ITsM8tsSlbJfZ+Ldu3+rnsEdugvf0kDy/XukEdbFsjQ=;
        b=riMc4YL8l7RWKzey2bNUdNBqSMJsmfm0qnDM0wmrqFgiWg5sb0a4DlkyMjQ/R1vQhj
         39tVJLmqj7sxhDOYN/1TW1XGbnB4eSdRaZsPlPFC4dgnc1diX9l0AmxPA2yIVeONgQRL
         BY0eZJQOZO+q2G4Oc1d7u+749HtoYNcoElbIObJlwfKnt1dsPR1pF/cIwuJGVJHwSTMD
         WlfeGIA16Mhbq/oFbqpJW54cHA+Pi1fSaiYRKmvqGQ/5AdxMnmv9bZT/9AUx/kjgUlc5
         ZSqRsN7TQNF3s+JxVZLBImyd0Agr2LnR9UPdwA/pdEqm+P61JervBjG1UVgMcPJP1Ybx
         2lkQ==
X-Gm-Message-State: AOAM531tZQ0GwUFr/xb8Ak4FhbZbuaMGid7/NjwQ531zmFWNjDhwSIsn
        k7rjdLOeVk+CnRF/Mzzeb8GD7yjGDeU=
X-Google-Smtp-Source: ABdhPJxIIZAvQmzaJTvmYW4LqZlCrYqx0NmFAljNw5JsMIzHF8VzZ/zsIoG4Y66YeAzgs1nNSwkyVg==
X-Received: by 2002:a63:1f25:: with SMTP id f37mr3206644pgf.61.1624359517599;
        Tue, 22 Jun 2021 03:58:37 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 17/43] KVM: PPC: Book3S HV P9: Reduce mtmsrd instructions required to save host SPRs
Date:   Tue, 22 Jun 2021 20:57:10 +1000
Message-Id: <20210622105736.633352-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c          | 57 ++++++++++++++++++---------
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  1 +
 3 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 89e34aa273e2..dfce089ac424 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -592,6 +592,30 @@ static void save_all(struct task_struct *tsk)
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
index 73a8b45249e8..3ac5dbdb59f8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3999,6 +3999,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
 	u64 tb, next_timer;
+	unsigned long msr;
 	int trap;
 
 	WARN_ON_ONCE(vcpu->arch.ceded);
@@ -4010,8 +4011,23 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4025,7 +4041,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
-	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	load_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	load_vr_state(&vcpu->arch.vr);
@@ -4134,7 +4149,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4663,6 +4677,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	goto done;
 }
 
+void save_user_regs_kvm(void);
+
 static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
@@ -4672,19 +4688,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
@@ -4692,12 +4713,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
 
@@ -4712,18 +4727,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
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
index a3281f0c9214..065bfd4d2c63 100644
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

