Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B6B345494
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCWBFZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhCWBFD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:03 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86322C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y200so12524026pfb.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q0MESomfVSJkVgPOMo60rhaWOTbJF2hDx7e4gO45wv8=;
        b=sGb40fp170JeJA/NQwKl5cy+7gmCVhOfE/4gcP/4T34Ipdg2MlM7Dobyt7Ue0MYI65
         rDXUrm2HfBDg27bHF21tM7AwkZ6GrFRrDoGtZR41gfRD5RBbmR1ACnlDw6JCpTDtPzhl
         otZ7iUOsIqOPOWR9rY+avE9Bs0vB+y1pbQ5Ops72X4vBQLmuK9zcyoJNQyyIwbuAp1v3
         sA2UgAlFUlBisKK39q+uV40S2nBdZVTQ20thrA63OI6LTlhkWFr1BxTt6FuRdVUlsWHr
         4XxpJV5IPN4IKiY3pcW6SPL8lw45oCgEWD3Cl0Lmq9VKnwXjUdprsvaCDiTXwN8f9Dlv
         V5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0MESomfVSJkVgPOMo60rhaWOTbJF2hDx7e4gO45wv8=;
        b=HkDXME5M+NDOLfywNurI25ccazAAkk4ZQHsUO1RMphrQgaMtRUQwNnHSSaCqkCRc34
         Vspa8T6ZgWEOukqepbA14afwSLCaNumHt5AGNlbl127X4qdM1zVxRjdBX1eYCddSpnPV
         wiwv5Ylz/rIHA5KmoGfQMdOi9IdsFmeKdQwHq7D+8UZFQjK6gxYUR+6FBivBAeKWc/te
         GKOyzdYnLeshj7zAM4cXNnqDQURw+Dqc7J0kxiSy8f0dnumeNCda0Gr+bsDLPgGVMwNn
         xGMzfti2prfN+6vTVD08HHc6usaHzgXfKDz3r7y1c4DCs/GGnErAuoXyb/cMuok2sUXO
         r5kA==
X-Gm-Message-State: AOAM530gs+pkbHcEiNtvGPn0kxfoktLEHIOk/66RU6kSMLT96Xn3p3jW
        q9RX7YsXTTeJcYK/3vC8+h54o8B1Yms=
X-Google-Smtp-Source: ABdhPJwIqVT7g6sfrPw61hAVC1VADCwmt6NaqTGlj/SoVFUIc0Nmcpe/0/ATEjl6fAjugH0zVxYYbw==
X-Received: by 2002:a17:902:c9c3:b029:e6:f027:b01e with SMTP id q3-20020a170902c9c3b02900e6f027b01emr825356pld.74.1616461502823;
        Mon, 22 Mar 2021 18:05:02 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 36/46] KVM: PPC: Book3S HV: Implement radix prefetch workaround by disabling MMU
Date:   Tue, 23 Mar 2021 11:02:55 +1000
Message-Id: <20210323010305.1045293-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than partition the guest PID space + flush a rogue guest PID to
work around this problem, instead fix it by always disabling the MMU when
switching in or out of guest MMU context in HV mode.

This may be a bit less efficient, but it is a lot less complicated and
allows the P9 path to trivally implement the workaround too. Newer CPUs
are not subject to this issue.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/mmu_context.h   |  6 ----
 arch/powerpc/kvm/book3s_hv.c             | 21 +++++++----
 arch/powerpc/kvm/book3s_hv_interrupt.c   | 16 ++++++---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  | 34 ------------------
 arch/powerpc/mm/book3s64/radix_pgtable.c | 27 +++++---------
 arch/powerpc/mm/book3s64/radix_tlb.c     | 46 ------------------------
 arch/powerpc/mm/mmu_context.c            |  4 +--
 7 files changed, 36 insertions(+), 118 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 652ce85f9410..bb5c7e5e142e 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -122,12 +122,6 @@ static inline bool need_extra_context(struct mm_struct *mm, unsigned long ea)
 }
 #endif
 
-#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_RADIX_MMU)
-extern void radix_kvm_prefetch_workaround(struct mm_struct *mm);
-#else
-static inline void radix_kvm_prefetch_workaround(struct mm_struct *mm) { }
-#endif
-
 extern void switch_cop(struct mm_struct *next);
 extern int use_cop(unsigned long acop, struct mm_struct *mm);
 extern void drop_cop(unsigned long acop, struct mm_struct *mm);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 74c67f713a26..8480cbe4b4fa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -809,6 +809,9 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		 */
 		if (mflags != 0 && mflags != 3)
 			return H_UNSUPPORTED_FLAG_START;
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
+				kvmhv_vcpu_is_radix(vcpu) && mflags == 3)
+			return H_UNSUPPORTED_FLAG_START;
 		return H_TOO_HARD;
 	default:
 		return H_TOO_HARD;
@@ -1665,6 +1668,14 @@ unsigned long kvmppc_filter_lpcr_hv(struct kvmppc_vcore *vc, unsigned long lpcr)
 		lpcr &= ~LPCR_AIL;
 	if ((lpcr & LPCR_AIL) != LPCR_AIL_3)
 		lpcr &= ~LPCR_AIL; /* LPCR[AIL]=1/2 is disallowed */
+	/*
+	 * On some POWER9s we force AIL off for radix guests to prevent
+	 * executing in MSR[HV]=1 mode with the MMU enabled and PIDR set to
+	 * guest, which can result in Q0 translations with LPID=0 PID=PIDR to
+	 * be cached, which the host TLB management does not expect.
+	 */
+	if (kvm_is_radix(kvm) && cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		lpcr &= ~LPCR_AIL;
 
 	/*
 	 * On POWER9, allow userspace to enable large decrementer for the
@@ -4334,12 +4345,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		/*
-		 * The TLB prefetch bug fixup is only in the kvmppc_run_vcpu
-		 * path, which also handles hash and dependent threads mode.
-		 */
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm) &&
-		    !cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		if (kvm->arch.threads_indep && kvm_is_radix(kvm))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4962,6 +4968,9 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 		if (!indep_threads_mode && !cpu_has_feature(CPU_FTR_HVMODE)) {
 			pr_warn("KVM: Ignoring indep_threads_mode=N in nested hypervisor\n");
 			kvm->arch.threads_indep = true;
+		} else if (!indep_threads_mode && cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
+			pr_warn("KVM: Ignoring indep_threads_mode=N on pre-DD2.2 POWER9\n");
+			kvm->arch.threads_indep = true;
 		} else {
 			kvm->arch.threads_indep = indep_threads_mode;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 787a7d2aed1a..cd84d2c37632 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -234,6 +234,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_AMOR, ~0UL);
 
+	if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
 	/*
@@ -242,7 +245,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	__mtmsrd(0, 1); /* clear RI */
+	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		__mtmsrd(0, 1); /* clear RI */
 
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
@@ -357,9 +361,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	radix_clear_slb();
 
-	__mtmsrd(msr, 0);
-	mtspr(SPRN_CTRLT, 1);
-
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
 	/* Advance host PURR/SPURR by the amount used by guest */
@@ -426,6 +427,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	/*
+	 * If we are in real mode, only switch MMU on after the MMU is
+	 * switched to host, to avoid the P9_RADIX_PREFETCH_BUG.
+	 */
+	__mtmsrd(msr, 0);
+	mtspr(SPRN_CTRLT, 1);
+
 	end_timing(vcpu);
 
 	return trap;
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 6118e8a97ddd..61f71a7df238 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1710,40 +1710,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	eieio
 	tlbsync
 	ptesync
-
-BEGIN_FTR_SECTION
-	/* Radix: Handle the case where the guest used an illegal PID */
-	LOAD_REG_ADDR(r4, mmu_base_pid)
-	lwz	r3, VCPU_GUEST_PID(r9)
-	lwz	r5, 0(r4)
-	cmpw	cr0,r3,r5
-	blt	2f
-
-	/*
-	 * Illegal PID, the HW might have prefetched and cached in the TLB
-	 * some translations for the  LPID 0 / guest PID combination which
-	 * Linux doesn't know about, so we need to flush that PID out of
-	 * the TLB. First we need to set LPIDR to 0 so tlbiel applies to
-	 * the right context.
-	*/
-	li	r0,0
-	mtspr	SPRN_LPID,r0
-	isync
-
-	/* Then do a congruence class local flush */
-	ld	r6,VCPU_KVM(r9)
-	lwz	r0,KVM_TLB_SETS(r6)
-	mtctr	r0
-	li	r7,0x400		/* IS field = 0b01 */
-	ptesync
-	sldi	r0,r3,32		/* RS has PID */
-1:	PPC_TLBIEL(7,0,2,1,1)		/* RIC=2, PRS=1, R=1 */
-	addi	r7,r7,0x1000
-	bdnz	1b
-	ptesync
-END_FTR_SECTION_IFSET(CPU_FTR_P9_RADIX_PREFETCH_BUG)
-
-2:
 #endif /* CONFIG_PPC_RADIX_MMU */
 
 	/*
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 98f0b243c1ab..1ea95891a79e 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -357,30 +357,19 @@ static void __init radix_init_pgtable(void)
 	}
 
 	/* Find out how many PID bits are supported */
-	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
-		if (!mmu_pid_bits)
-			mmu_pid_bits = 20;
-		mmu_base_pid = 1;
-	} else if (cpu_has_feature(CPU_FTR_HVMODE)) {
-		if (!mmu_pid_bits)
-			mmu_pid_bits = 20;
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	if (!cpu_has_feature(CPU_FTR_HVMODE) &&
+			cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
 		/*
-		 * When KVM is possible, we only use the top half of the
-		 * PID space to avoid collisions between host and guest PIDs
-		 * which can cause problems due to prefetch when exiting the
-		 * guest with AIL=3
+		 * Older versions of KVM on these machines perfer if the
+		 * guest only uses the low 19 PID bits.
 		 */
-		mmu_base_pid = 1 << (mmu_pid_bits - 1);
-#else
-		mmu_base_pid = 1;
-#endif
-	} else {
-		/* The guest uses the bottom half of the PID space */
 		if (!mmu_pid_bits)
 			mmu_pid_bits = 19;
-		mmu_base_pid = 1;
+	} else {
+		if (!mmu_pid_bits)
+			mmu_pid_bits = 20;
 	}
+	mmu_base_pid = 1;
 
 	/*
 	 * Allocate Partition table and process table for the
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 409e61210789..312236a6b085 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1336,49 +1336,3 @@ void radix__flush_tlb_all(void)
 		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(0) : "memory");
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
-
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-extern void radix_kvm_prefetch_workaround(struct mm_struct *mm)
-{
-	unsigned long pid = mm->context.id;
-
-	if (unlikely(pid == MMU_NO_CONTEXT))
-		return;
-
-	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-		return;
-
-	/*
-	 * If this context hasn't run on that CPU before and KVM is
-	 * around, there's a slim chance that the guest on another
-	 * CPU just brought in obsolete translation into the TLB of
-	 * this CPU due to a bad prefetch using the guest PID on
-	 * the way into the hypervisor.
-	 *
-	 * We work around this here. If KVM is possible, we check if
-	 * any sibling thread is in KVM. If it is, the window may exist
-	 * and thus we flush that PID from the core.
-	 *
-	 * A potential future improvement would be to mark which PIDs
-	 * have never been used on the system and avoid it if the PID
-	 * is new and the process has no other cpumask bit set.
-	 */
-	if (cpu_has_feature(CPU_FTR_HVMODE) && radix_enabled()) {
-		int cpu = smp_processor_id();
-		int sib = cpu_first_thread_sibling(cpu);
-		bool flush = false;
-
-		for (; sib <= cpu_last_thread_sibling(cpu) && !flush; sib++) {
-			if (sib == cpu)
-				continue;
-			if (!cpu_possible(sib))
-				continue;
-			if (paca_ptrs[sib]->kvm_hstate.kvm_vcpu)
-				flush = true;
-		}
-		if (flush)
-			_tlbiel_pid(pid, RIC_FLUSH_ALL);
-	}
-}
-EXPORT_SYMBOL_GPL(radix_kvm_prefetch_workaround);
-#endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
diff --git a/arch/powerpc/mm/mmu_context.c b/arch/powerpc/mm/mmu_context.c
index 18f20da0d348..7479d39976c9 100644
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -81,9 +81,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 	if (cpu_has_feature(CPU_FTR_ALTIVEC))
 		asm volatile ("dssall");
 
-	if (new_on_cpu)
-		radix_kvm_prefetch_workaround(next);
-	else
+	if (!new_on_cpu)
 		membarrier_arch_switch_mm(prev, next, tsk);
 
 	/*
-- 
2.23.0

