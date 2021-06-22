Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC463B01FE
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFVLAr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhFVLAq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340F0C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h16so11864395pjv.2
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i1UVfyN6S800OVpUfYU6vKNR78o9Xms2uSVHdVhoOtI=;
        b=Ny6aZ/+DdDF2m2z5DW3eHPTZI7U2a4VdP6p9A0kRdI6l5senPDVmgRRZfLXi354NTK
         iRMXCco85Oy3b3PNerqG/rWdxFfXMIVg8R2A5HKvyAR8dxodDLWkqS0uEqMAxaDOmpmB
         Ao8nyxNlfrVPLKEeTXciAQrFWsfH3bmMLEm2pDelo0JLCY8UPeTVlIoPjTxp9EjLNzFD
         NtBBBmRj71CogG5B0xnbn69oEu4UEes0e8sBEUYo92YlxdXHEu6h6LD2hSsEJ2SP0xkS
         T9lDGjJVQ4CTIzZgPL7Smt3bkuWDlIVL6OKcsAwWNkr4KGBWKW+Gp7r6MyUa1nMW1GKo
         Jsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i1UVfyN6S800OVpUfYU6vKNR78o9Xms2uSVHdVhoOtI=;
        b=ac+C8WjSKI3TPae0nC5yJTDmEABHPTmjU7JJ+3xF5XmkDsWd3YaKHgWLEPT7JtP6VS
         T8JXyTn7GmDgi3wi7TehdsnchBirodK7+EBoZradSE9KReg5cXtNjho05jAuCsplxdL0
         9n7f9gshsWFdK6xad3A5XKue1v4u5o4ifmsDP/8YUP0/aPOQ7aZ+wrIn1Y7a0SiOw4KK
         Rr3a+nzX1cVVTU+AHdr09GDNs6KNg/zM8r5DBQxiHd1ZPfPYiegQ3SZUiRfRkBRhtu+P
         ghj/aXWD0xuk9i7Bj4dbdznZ6rm8Ibrygst6/mm87sU4BjF8RNK2gxsQoNzpFT15E57P
         IDbg==
X-Gm-Message-State: AOAM530RodLCweaPilUi0RiPHtFTYgFMuESMgli0mZMeYPN7U9XDoJU8
        UIQQ4gKXrmDxdjE/YVgY98ccIO6NGas=
X-Google-Smtp-Source: ABdhPJxWr5mXiXP5ywnx39fmKhSpfgF7Xr9OSj2PGWNx36nxqlz00KZNdkmcU6EDxBIOd/P502ZqYw==
X-Received: by 2002:a17:90b:4b07:: with SMTP id lx7mr3319190pjb.158.1624359510657;
        Tue, 22 Jun 2021 03:58:30 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 14/43] KVM: PPC: Book3S HV P9: Demand fault PMU SPRs when marked not inuse
Date:   Tue, 22 Jun 2021 20:57:07 +1000
Message-Id: <20210622105736.633352-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The pmcregs_in_use field in the guest VPA can not be trusted to reflect
what the guest is doing with PMU SPRs, so the PMU must always be managed
(stopped) when exiting the guest, and SPR values set when entering the
guest to ensure it can't cause a covert channel or otherwise cause other
guests or the host to misbehave.

So prevent guest access to the PMU with HFSCR[PM] if pmcregs_in_use is
clear, and avoid the PMU SPR access on every partition switch. Guests
that set pmcregs_in_use incorrectly or when first setting it and using
the PMU will take a hypervisor facility unavailable interrupt that will
bring in the PMU SPRs.

-774 cycles (7759) cycles POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h |   1 +
 arch/powerpc/kvm/book3s_hv.c        | 122 ++++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_nested.c |  12 ++-
 3 files changed, 105 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 7e4c3a741951..5c003a5ff854 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -819,6 +819,7 @@ struct kvm_vcpu_arch {
 	/* For support of nested guests */
 	struct kvm_nested_guest *nested;
 	u32 nested_vcpu_id;
+	u64 nested_hfscr;
 	gpa_t nested_io_gpr;
 #endif
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13b8389b0479..0733bb95f439 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1349,6 +1349,20 @@ static int kvmppc_emulate_doorbell_instr(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+/*
+ * If the lppaca had pmcregs_in_use clear when we exited the guest, then
+ * HFSCR_PM is cleared for next entry. If the guest then tries to access
+ * the PMU SPRs, we get this facility unavailable interrupt. Putting HFSCR_PM
+ * back in the guest HFSCR will cause the next entry to load the PMU SPRs and
+ * allow the guest access to continue.
+ */
+static int kvmppc_pmu_unavailable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hfscr |= HFSCR_PM;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1618,16 +1632,22 @@ XXX benchmark guest exits
 	 * to emulate.
 	 * Otherwise, we just generate a program interrupt to the guest.
 	 */
-	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
 		r = EMULATE_FAIL;
-		if (((vcpu->arch.hfscr >> 56) == FSCR_MSGP_LG) &&
-		    cpu_has_feature(CPU_FTR_ARCH_300))
-			r = kvmppc_emulate_doorbell_instr(vcpu);
+		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
+			unsigned long cause = vcpu->arch.hfscr >> 56;
+
+			if (cause == FSCR_MSGP_LG)
+				r = kvmppc_emulate_doorbell_instr(vcpu);
+			if (cause == FSCR_PM_LG)
+				r = kvmppc_pmu_unavailable(vcpu);
+		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
 			r = RESUME_GUEST;
 		}
 		break;
+	}
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	case BOOK3S_INTERRUPT_HV_SOFTPATCH:
@@ -1734,6 +1754,19 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 		break;
 
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
+		unsigned long cause = vcpu->arch.hfscr >> 56;
+
+		r = EMULATE_FAIL;
+		if (cause == FSCR_PM_LG && (vcpu->arch.nested_hfscr & HFSCR_PM))
+			r = kvmppc_pmu_unavailable(vcpu);
+
+		if (r == EMULATE_FAIL)
+			r = RESUME_HOST;
+
+		break;
+	}
+
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	case BOOK3S_INTERRUPT_HV_SOFTPATCH:
 		/*
@@ -3693,6 +3726,17 @@ static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
 static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
 				struct p9_host_os_sprs *host_os_sprs)
 {
+	struct lppaca *lp;
+	int load_pmu = 1;
+
+	lp = vcpu->arch.vpa.pinned_addr;
+	if (lp)
+		load_pmu = lp->pmcregs_in_use;
+
+	if (load_pmu)
+	      vcpu->arch.hfscr |= HFSCR_PM;
+
+	/* Save host */
 	if (ppc_get_pmu_inuse()) {
 		/*
 		 * It might be better to put PMU handling (at least for the
@@ -3737,29 +3781,31 @@ static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
 	}
 #endif
 
-	/* load guest */
-	mtspr(SPRN_PMC1, vcpu->arch.pmc[0]);
-	mtspr(SPRN_PMC2, vcpu->arch.pmc[1]);
-	mtspr(SPRN_PMC3, vcpu->arch.pmc[2]);
-	mtspr(SPRN_PMC4, vcpu->arch.pmc[3]);
-	mtspr(SPRN_PMC5, vcpu->arch.pmc[4]);
-	mtspr(SPRN_PMC6, vcpu->arch.pmc[5]);
-	mtspr(SPRN_MMCR1, vcpu->arch.mmcr[1]);
-	mtspr(SPRN_MMCR2, vcpu->arch.mmcr[2]);
-	mtspr(SPRN_SDAR, vcpu->arch.sdar);
-	mtspr(SPRN_SIAR, vcpu->arch.siar);
-	mtspr(SPRN_SIER, vcpu->arch.sier[0]);
+	/* Load guest */
+	if (vcpu->arch.hfscr & HFSCR_PM) {
+		mtspr(SPRN_PMC1, vcpu->arch.pmc[0]);
+		mtspr(SPRN_PMC2, vcpu->arch.pmc[1]);
+		mtspr(SPRN_PMC3, vcpu->arch.pmc[2]);
+		mtspr(SPRN_PMC4, vcpu->arch.pmc[3]);
+		mtspr(SPRN_PMC5, vcpu->arch.pmc[4]);
+		mtspr(SPRN_PMC6, vcpu->arch.pmc[5]);
+		mtspr(SPRN_MMCR1, vcpu->arch.mmcr[1]);
+		mtspr(SPRN_MMCR2, vcpu->arch.mmcr[2]);
+		mtspr(SPRN_SDAR, vcpu->arch.sdar);
+		mtspr(SPRN_SIAR, vcpu->arch.siar);
+		mtspr(SPRN_SIER, vcpu->arch.sier[0]);
 
-	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-		mtspr(SPRN_MMCR3, vcpu->arch.mmcr[4]);
-		mtspr(SPRN_SIER2, vcpu->arch.sier[1]);
-		mtspr(SPRN_SIER3, vcpu->arch.sier[2]);
-	}
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			mtspr(SPRN_MMCR3, vcpu->arch.mmcr[4]);
+			mtspr(SPRN_SIER2, vcpu->arch.sier[1]);
+			mtspr(SPRN_SIER3, vcpu->arch.sier[2]);
+		}
 
-	/* Set MMCRA then MMCR0 last */
-	mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
-	mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
-	/* No isync necessary because we're starting counters */
+		/* Set MMCRA then MMCR0 last */
+		mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
+		mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
+		/* No isync necessary because we're starting counters */
+	}
 }
 
 static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
@@ -3795,9 +3841,31 @@ static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
 			vcpu->arch.sier[1] = mfspr(SPRN_SIER2);
 			vcpu->arch.sier[2] = mfspr(SPRN_SIER3);
 		}
-	} else {
+
+	} else if (vcpu->arch.hfscr & HFSCR_PM) {
+		/*
+		 * The guest accessed PMC SPRs without specifying they should
+		 * be preserved. Stop them from counting if the guest had
+		 * started anything.
+		 */
 		freeze_pmu(mfspr(SPRN_MMCR0), mfspr(SPRN_MMCRA));
-	}
+
+		/*
+		 * Demand-fault PMU register access in the guest.
+		 *
+		 * This is used to grab the guest's VPA pmcregs_in_use value
+		 * and reflect it into the host's VPA in the case of a nested
+		 * hypervisor.
+		 *
+		 * It also avoids having to zero-out SPRs after each guest
+		 * exit to avoid side-channels when.
+		 *
+		 * This is cleared here when we exit the guest, so later HFSCR
+		 * interrupt handling can add it back to run the guest with
+		 * PM enabled next time.
+		 */
+		vcpu->arch.hfscr &= ~HFSCR_PM;
+	} /* otherwise the PMU should still be frozen from guest entry */
 
 #ifdef CONFIG_PPC_PSERIES
 	if (kvmhv_on_pseries())
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 60724f674421..6add13a22f56 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -103,7 +103,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	hr->dpdes = vc->dpdes;
-	hr->hfscr = vcpu->arch.hfscr;
+	hr->hfscr = vcpu->arch.nested_hfscr;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
 	hr->ic = vcpu->arch.ic;
@@ -126,6 +126,10 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	case BOOK3S_INTERRUPT_H_INST_STORAGE:
 		hr->asdr = vcpu->arch.fault_gpa;
 		break;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+		hr->hfscr &= ~HFSCR_INTR_CAUSE;
+		hr->hfscr |= vcpu->arch.hfscr & HFSCR_INTR_CAUSE;
+		break;
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
 		hr->heir = vcpu->arch.emul_inst;
 		break;
@@ -161,9 +165,10 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 
 	/*
 	 * Don't let L1 enable features for L2 which we've disabled for L1,
-	 * but preserve the interrupt cause field.
+	 * but preserve the interrupt cause field and facilities that might
+	 * be disabled for demand faulting in the L1.
 	 */
-	hr->hfscr &= (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
+	hr->hfscr &= (HFSCR_INTR_CAUSE | HFSCR_PM | vcpu->arch.hfscr);
 
 	/* Don't let data address watchpoint match in hypervisor state */
 	hr->dawrx0 &= ~DAWRX_HYP;
@@ -342,6 +347,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
+	vcpu->arch.nested_hfscr = l2_hv.hfscr;
 	vcpu->arch.regs = l2_regs;
 
 	/* Guest must always run with ME enabled, HV disabled. */
-- 
2.23.0

