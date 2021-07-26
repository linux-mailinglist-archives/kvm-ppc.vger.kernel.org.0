Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643443D51B4
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGZDLC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB6C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:30 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n10so10140319plf.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wdQy5WVPVHkw2p4fx6chDgQPompALYeXuTxR1zPIu0g=;
        b=oZeer18zQFuxRKlTNP/mtAFcbCybd6TpntQ97n7+QJR5+pHeL11SRljlWLY1v1/n5I
         c/5noMQ9ulEvCCE3swtFVbI++fN2Y4CoaCNbW8gBPflze6yVYZnTsrtCQ7BiBE0UtE8F
         10rN518OGFbb5N7RpeD9Nyj9q5+W9HZeMjTvkpFapuqxZXHPV+IIF5Mzbdwqrv2O/NgE
         P/rlRdZhaMpa7A/9QN0JK/RWoM6CqYTQshfWIiW8qVjQJjs3Dt58oFz5EybfUA5HE1Mc
         4lyTJK/9rvWfoWyP/IEbx1zgYWhM1nQETzLgWjykRAJTA1CJg7Oqcowlvo+YzUZBWmUr
         WrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wdQy5WVPVHkw2p4fx6chDgQPompALYeXuTxR1zPIu0g=;
        b=ODdq5rNcwLSsScEF2XRk7VUUTJ2eSDc3gckCwLJxeDRdI+EYzlZAX17ty5lUK+bVwS
         DIFegBhWMO+vZUEZg9ZFITgbRCgTALDcXReVLPWcSRusBjz+afeu+oLUjohgTc08c4+t
         9wGxBrqGiCCLjbc6sUtVDUBue5j3P/BmvB/REDOC+YT6UL8MIwulR6ZvhZm7FwfhKQnO
         0G46UkPY5JUdlmsqlLR+Ozm0b80FDFsttBkj+DZ+qt1R3zT+zvYXlqIug0noVCZqilOq
         bQIaQFpD5SUlJHRXUDjfYIBRmFMa11qMCVRI0/Jg8MwI1Ll6DSU1aJW77HBiyCaTHiBZ
         LloQ==
X-Gm-Message-State: AOAM532vi60dR8TGMuhiDt/kMyaOk/7Yeg6BhiUIQjjyV3KVc6qmBfBo
        FBLN9sjd28qnLqxmAq/2SJgqSrh34qs=
X-Google-Smtp-Source: ABdhPJyVr+zx0lsxfM8F0WR+H0hYNABFHeXFaPiU/cEkKLnxaPK1BsGkLii2okQDS1CMDBcE92d+Kg==
X-Received: by 2002:a65:64cf:: with SMTP id t15mr16109876pgv.131.1627271490277;
        Sun, 25 Jul 2021 20:51:30 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 19/55] KVM: PPC: Book3S HV P9: Demand fault PMU SPRs when marked not inuse
Date:   Mon, 26 Jul 2021 13:50:00 +1000
Message-Id: <20210726035036.739609-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/kvm_book3s_64.h |   1 +
 arch/powerpc/include/asm/kvm_host.h      |   1 +
 arch/powerpc/kvm/book3s_hv.c             | 133 +++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_nested.c      |  38 +++----
 4 files changed, 119 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index eaf3a562bf1e..df6bed4b2a46 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -39,6 +39,7 @@ struct kvm_nested_guest {
 	pgd_t *shadow_pgtable;		/* our page table for this guest */
 	u64 l1_gr_to_hr;		/* L1's addr of part'n-scoped table */
 	u64 process_table;		/* process table entry for this guest */
+	u64 hfscr;			/* L1's HFSCR */
 	long refcnt;			/* number of pointers to this struct */
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9f52f282b1aa..aee41edcfe6b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -804,6 +804,7 @@ struct kvm_vcpu_arch {
 	struct kvmppc_vpa slb_shadow;
 
 	spinlock_t tbacct_lock;
+	u64 hfscr_permitted;	/* A mask of permitted HFSCR facilities */
 	u64 busy_stolen;
 	u64 busy_preempt;
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 091b67ef6eba..7c75f63648d6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1421,6 +1421,23 @@ static int kvmppc_emulate_doorbell_instr(struct kvm_vcpu *vcpu)
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
+	if (!(vcpu->arch.hfscr_permitted & HFSCR_PM))
+		return EMULATE_FAIL;
+
+	vcpu->arch.hfscr |= HFSCR_PM;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1705,16 +1722,22 @@ XXX benchmark guest exits
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
 
 	case BOOK3S_INTERRUPT_HV_RM_HARD:
 		r = RESUME_PASSTHROUGH;
@@ -2723,6 +2746,13 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	if (cpu_has_feature(CPU_FTR_TM_COMP))
 		vcpu->arch.hfscr |= HFSCR_TM;
 
+	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
+
+	/*
+	 * PM is demand-faulted so start with it clear.
+	 */
+	vcpu->arch.hfscr &= ~HFSCR_PM;
+
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
 	vcpu->arch.state = KVMPPC_VCPU_NOTREADY;
@@ -3793,6 +3823,14 @@ static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
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
+	/* Save host */
 	if (ppc_get_pmu_inuse()) {
 		/*
 		 * It might be better to put PMU handling (at least for the
@@ -3827,41 +3865,47 @@ static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
 	}
 
 #ifdef CONFIG_PPC_PSERIES
+	/* After saving PMU, before loading guest PMU, flip pmcregs_in_use */
 	if (kvmhv_on_pseries()) {
 		barrier();
-		if (vcpu->arch.vpa.pinned_addr) {
-			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
-		} else {
-			get_lppaca()->pmcregs_in_use = 1;
-		}
+		get_lppaca()->pmcregs_in_use = load_pmu;
 		barrier();
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
+	/*
+	 * Load guest. If the VPA said the PMCs are not in use but the guest
+	 * tried to access them anyway, HFSCR[PM] will be set by the HFAC
+	 * fault so we can make forward progress.
+	 */
+	if (load_pmu || (vcpu->arch.hfscr & HFSCR_PM)) {
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
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			mtspr(SPRN_MMCR3, vcpu->arch.mmcr[3]);
+			mtspr(SPRN_SIER2, vcpu->arch.sier[1]);
+			mtspr(SPRN_SIER3, vcpu->arch.sier[2]);
+		}
 
-	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-		mtspr(SPRN_MMCR3, vcpu->arch.mmcr[3]);
-		mtspr(SPRN_SIER2, vcpu->arch.sier[1]);
-		mtspr(SPRN_SIER3, vcpu->arch.sier[2]);
-	}
+		/* Set MMCRA then MMCR0 last */
+		mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
+		mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
+		/* No isync necessary because we're starting counters */
 
-	/* Set MMCRA then MMCR0 last */
-	mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
-	mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
-	/* No isync necessary because we're starting counters */
+		if (!vcpu->arch.nested &&
+				(vcpu->arch.hfscr_permitted & HFSCR_PM))
+			vcpu->arch.hfscr |= HFSCR_PM;
+	}
 }
 
 static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
@@ -3897,9 +3941,32 @@ static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
 			vcpu->arch.sier[1] = mfspr(SPRN_SIER2);
 			vcpu->arch.sier[2] = mfspr(SPRN_SIER3);
 		}
-	} else {
+
+	} else if (vcpu->arch.hfscr & HFSCR_PM) {
+		/*
+		 * The guest accessed PMC SPRs without specifying they should
+		 * be preserved, or it cleared pmcregs_in_use after the last
+		 * access. Just ensure they are frozen.
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
+		if (!vcpu->arch.nested)
+			vcpu->arch.hfscr &= ~HFSCR_PM;
+	} /* otherwise the PMU should still be frozen */
 
 #ifdef CONFIG_PPC_PSERIES
 	if (kvmhv_on_pseries()) {
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 983628ed4376..3ffc63ffebc5 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -104,16 +104,6 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
-	/*
-	 * When loading the hypervisor-privileged registers to run L2,
-	 * we might have used bits from L1 state to restrict what the
-	 * L2 state is allowed to be. Since L1 is not allowed to read
-	 * the HV registers, do not include these modifications in the
-	 * return state.
-	 */
-	hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
-		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
-
 	hr->dpdes = vc->dpdes;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
@@ -137,14 +127,23 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu,
 	case BOOK3S_INTERRUPT_H_INST_STORAGE:
 		hr->asdr = vcpu->arch.fault_gpa;
 		break;
-	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
-	{
-		u8 cause = vcpu->arch.hfscr >> 56;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
+		u64 cause = vcpu->arch.hfscr >> 56;
 
 		WARN_ON_ONCE(cause >= BITS_PER_LONG);
 
-		if (!(hr->hfscr & (1UL << cause)))
+		/*
+		 * When loading the hypervisor-privileged registers to run L2,
+		 * we might have used bits from L1 state to restrict what the
+		 * L2 state is allowed to be. Since L1 is not allowed to read
+		 * the HV registers, do not include these modifications in the
+		 * return state.
+		 */
+		hr->hfscr &= ~HFSCR_INTR_CAUSE;
+		if (!(hr->hfscr & (1UL << cause))) {
+			hr->hfscr |= vcpu->arch.hfscr & HFSCR_INTR_CAUSE;
 			break;
+		}
 
 		/*
 		 * We have disabled this facility, so it does not
@@ -152,10 +151,6 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu,
 		 */
 		vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
 		kvmppc_load_last_inst(vcpu, INST_GENERIC, &vcpu->arch.emul_inst);
-
-		/* Don't leak the cause field */
-		hr->hfscr &= ~HFSCR_INTR_CAUSE;
-
 		fallthrough;
 	}
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
@@ -299,10 +294,10 @@ static void load_l2_hv_regs(struct kvm_vcpu *vcpu,
 				      (vc->lpcr & ~mask) | (*lpcr & mask));
 
 	/*
-	 * Don't let L1 enable features for L2 which we've disabled for L1,
-	 * but preserve the interrupt cause field.
+	 * Don't let L1 enable features for L2 which we disallow for L1.
+	 * Preserve the interrupt cause field.
 	 */
-	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | l1_hv->hfscr);
+	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | vcpu->arch.hfscr_permitted);
 
 	/* Don't let data address watchpoint match in hypervisor state */
 	vcpu->arch.dawrx0 = l2_hv->dawrx0 & ~DAWRX_HYP;
@@ -389,6 +384,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
+	l2->hfscr = l2_hv.hfscr;
 	vcpu->arch.regs = l2_regs;
 
 	/* Guest must always run with ME enabled, HV disabled. */
-- 
2.23.0

