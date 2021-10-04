Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964E042136F
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhJDQEH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhJDQEH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60D3C061746
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:17 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c29so4513930pfp.2
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=beEVDL7ciCBVPGVzvAuitGlc6Wqq+k8/KKHAATblqC0=;
        b=mI9AjCzeoCedsJ1xJfDu5fsb+y6KB7EfqYAcD5imOsOUpel2i1Q0YugrFQxdLOVZin
         SBM92fx4kKSyDXWDfX1vkQXOvRi42T6NQY8G41u57hwwnEGRCwneJQiKbJnglb2+kaTN
         d3de0UcI8m+Mc4J+8Hw0AovjLtoiedVblPNet+TLIQCLJ4ixb2K4xrRAR6WNjJJO/9dP
         9Qfor5HnKbLf4j3kJVAvb5EbBHOHsnPGyLwQUF6BocEjzn72y7isbFPHtxFddK6uIn8I
         3qOtVX+n3AM6OtTzBui9ubkd35dhHxNNtadHAKSXCpuRCd4p2KsxHD9bk5PrfcgdZ/RV
         zIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=beEVDL7ciCBVPGVzvAuitGlc6Wqq+k8/KKHAATblqC0=;
        b=AkM+4oboryoUSmC2K0K00XIZpl8ss3GBnVZ9H85rslxASYJLn+xuS5yWAAmM+zoPXV
         ICdXrX47BtLYKbw5PSS5UdiOUTds/Ea2roR67RcPtNOIOfwZJc7q5Zzvqe24crQElVj8
         ue7+ijGr0GCDGDB5kpwDnqfDzJ3KGpSKCKfNWtm/i1OoDJx+61dHaZYR5YLjxF4UTVIR
         wp1s6wNoLejfPZDsmtdbIoSCRYu9/EOQbGOY9xpPhn08cUjl2taU0NNHxwte1pDqHWEC
         HzyGAVJRv4VKl3Yxm72p91/VeJDBRJE0Dfe83wsCg/TSlJglpYdb21FL313vG//havVa
         z0tw==
X-Gm-Message-State: AOAM530F0AmSCpw52OtCpRfGYw1mJTCF/wJDppvrMX3amNt3ks8dQLt6
        QP3XUY1aXsjCFNem9GK5/GIC8tPxdLE=
X-Google-Smtp-Source: ABdhPJzpM53cwZq/beanPAPaTVoH5U58elKmite+2ZU85YQ/Op1yGdXhQn4yQ42QPnONey3I0XRj3w==
X-Received: by 2002:a63:b505:: with SMTP id y5mr11550127pge.91.1633363337230;
        Mon, 04 Oct 2021 09:02:17 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:17 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 31/52] KVM: PPC: Book3S HV P9: Move remaining SPR and MSR access into low level entry
Date:   Tue,  5 Oct 2021 02:00:28 +1000
Message-Id: <20211004160049.1338837-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move register saving and loading from kvmhv_p9_guest_entry() into the HV
and nested entry handlers.

Accesses are scheduled to reduce mtSPR / mfSPR interleaving which
reduces SPR scoreboard stalls.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 79 ++++++++++------------
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 96 ++++++++++++++++++++-------
 2 files changed, 109 insertions(+), 66 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a57727463980..db42eeb27c15 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3814,9 +3814,15 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
@@ -3825,6 +3831,27 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
+	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
+		msr = mfmsr(); /* TM restore can update msr */
+
 	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
@@ -3866,12 +3893,20 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
 
@@ -3882,9 +3917,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr, u64 *tb)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	struct p9_host_os_sprs host_os_sprs;
 	u64 next_timer;
-	unsigned long msr;
 	int trap;
 
 	next_timer = timer_get_next_tb();
@@ -3895,33 +3928,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
@@ -3929,11 +3935,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
-		msr = mfmsr(); /* MSR may have been updated */
-
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	if (kvmhv_on_pseries()) {
 		trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
 
@@ -3976,16 +3977,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
index 784ff5429ebc..fa080533bd8d 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -538,6 +538,7 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
 
 int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb)
 {
+	struct p9_host_os_sprs host_os_sprs;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -567,9 +568,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ceded = 0;
 
-	/* Could avoid mfmsr by passing around, but probably no big deal */
-	msr = mfmsr();
-
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
 	host_dawr0 = mfspr(SPRN_DAWR0);
@@ -584,6 +582,41 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
+	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
+		msr = mfmsr(); /* MSR may have been updated */
+
 	if (vc->tb_offset) {
 		u64 new_tb = *tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -642,6 +675,14 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
 	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
 
+	/*
+	 * It might be preferable to load_vcpu_state here, in order to get the
+	 * GPR/FP register loads executing in parallel with the previous mtSPR
+	 * instructions, but for now that can't be done because the TM handling
+	 * in load_vcpu_state can change some SPRs and vcpu state (nip, msr).
+	 * But TM could be split out if this would be a significant benefit.
+	 */
+
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_P9;
 
 	/*
@@ -819,6 +860,20 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 
+	save_clear_guest_mmu(kvm, vcpu);
+	switch_mmu_to_host(kvm, host_pidr);
+
+	/*
+	 * If we are in real mode, only switch MMU on after the MMU is
+	 * switched to host, to avoid the P9_RADIX_PREFETCH_BUG.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
+			vcpu->arch.shregs.msr & MSR_TS_MASK)
+		msr |= MSR_TS_S;
+	__mtmsrd(msr, 0);
+
+	store_vcpu_state(vcpu);
+
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -851,6 +906,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -867,26 +935,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
-	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
-	    vcpu->arch.shregs.msr & MSR_TS_MASK)
-		msr |= MSR_TS_S;
-
-	__mtmsrd(msr, 0);
+out:
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	end_timing(vcpu);
 
-- 
2.23.0

