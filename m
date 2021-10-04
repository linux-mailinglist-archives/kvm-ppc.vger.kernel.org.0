Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694B942135F
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhJDQDj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbhJDQDh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D662C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id np13so1886668pjb.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2M5qUMpszc7y0kTAP66EoNWnoS+C/f8xv2fiQGab9VE=;
        b=CnRmKiLz1JL74iQrGl08XR3HTo747VKcYQ20r0eDBIIsPI+1Lpr+eknpdC4p6KaWDh
         CWnq+y/FYtUwOwfGNF1y3jDh+qCEWw3XC5/LUoL/INrZ71O7njvMKLVmB6yikUD0WFhp
         4wR3wSfZf4xcSWfarpxiPVCGyGSrZJM0IbhhQs4LJY4Ws0lv+tHLtnc9KD70/c3bgOBe
         aHFhXwjtv0b4JneUN1WYxmJVr+fwhmH7RLG+d/xfwgObQrq8+Ofh+z9tbhyyI7fjFwcn
         5hE26w2BGI07ihOwRs0Ly+QKnrHJ/ILrCbB5Fyv5y9aeIjY8rhP8Jz4u4be34w+taMss
         V/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2M5qUMpszc7y0kTAP66EoNWnoS+C/f8xv2fiQGab9VE=;
        b=IAy8db9VQQ59c7ihfJUJ1QXIdlR6GQ9IjLorU8XKcO7THsRBWZP/8hZ03wPxiU3E1x
         bV+kEX7Y5KCPWGgKqBNSY0KQtOBdLIamGut11rUq23mwIBidn/gawna71ZGE1ISoHSAX
         M23lUlFHHbECDIkcfpOJUszLI8ijs1Vv4lWw/t846lhvfN/EogAXSN1pkU8xO8HcGu1H
         OUXDmgEvdMZSV62SHPr4VrWRnNgkkQ/2KvWzdeQUSTIcOfjHuOGcNchEmzNoj1TCG2Mp
         Fwj5r0Wp0tIz0Aeo/OYl29cYJFEvxHKYIarBLvmStDRzocA/p0AAQY0JsbazCBnKdc0U
         Fqaw==
X-Gm-Message-State: AOAM5313RFAZ9L07BkfpiKBGTUV/utNiq9mduc+kKz8mZSANJi5eqqQl
        jTOKMnC9O0LksxsB2eKHSzPZ7UgtR3Y=
X-Google-Smtp-Source: ABdhPJzRUb46DftirO/YcVQWJy7uI+GSu/NkkbbWaPfkFPFMnhTIUgJhYF9N0XI6+rrDfjjwoLu3Kw==
X-Received: by 2002:a17:902:9b88:b0:13e:55b1:2939 with SMTP id y8-20020a1709029b8800b0013e55b12939mr424178plp.80.1633363307649;
        Mon, 04 Oct 2021 09:01:47 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:47 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 19/52] KVM: PPC: Book3S HV P9: Reduce mtmsrd instructions required to save host SPRs
Date:   Tue,  5 Oct 2021 02:00:16 +1000
Message-Id: <20211004160049.1338837-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This reduces the number of mtmsrd required to enable facility bits when
saving/restoring registers, by having the KVM code set all bits up front
rather than using individual facility functions that set their particular
MSR bits.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/switch_to.h  |  2 +
 arch/powerpc/kernel/process.c         | 28 +++++++++++++
 arch/powerpc/kvm/book3s_hv.c          | 59 ++++++++++++++++++---------
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  1 +
 4 files changed, 71 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 9d1fbd8be1c7..e8013cd6b646 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -112,6 +112,8 @@ static inline void clear_task_ebb(struct task_struct *t)
 #endif
 }
 
+void kvmppc_save_user_regs(void);
+
 extern int set_thread_tidr(struct task_struct *t);
 
 #endif /* _ASM_POWERPC_SWITCH_TO_H */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 50436b52c213..3fca321b820d 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1156,6 +1156,34 @@ static inline void save_sprs(struct thread_struct *t)
 #endif
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+void kvmppc_save_user_regs(void)
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
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	if (usermsr & MSR_TM) {
+		current->thread.tm_tfhar = mfspr(SPRN_TFHAR);
+		current->thread.tm_tfiar = mfspr(SPRN_TFIAR);
+		current->thread.tm_texasr = mfspr(SPRN_TEXASR);
+		current->thread.regs->msr &= ~MSR_TM;
+	}
+#endif
+}
+EXPORT_SYMBOL_GPL(kvmppc_save_user_regs);
+#endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
+
 static inline void restore_sprs(struct thread_struct *old_thread,
 				struct thread_struct *new_thread)
 {
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index fca89ed2244f..16365c0e9872 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4140,6 +4140,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
 	u64 tb, next_timer;
+	unsigned long msr;
 	int trap;
 
 	WARN_ON_ONCE(vcpu->arch.ceded);
@@ -4151,8 +4152,23 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4161,12 +4177,13 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4275,7 +4292,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4825,19 +4841,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
@@ -4845,12 +4866,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
 
@@ -4865,18 +4880,24 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
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
+	kvmppc_save_user_regs();
 
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

