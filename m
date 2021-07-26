Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D43D51CC
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhGZDLj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhGZDLe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E28C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso11985816pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZyxOga97QK0VQyc6gPI7ZtuFN1BPOlKdb1xu1VWlvxo=;
        b=PEVQZA5VTfOAFq4QbiLjsKPumZDxnmdp/jgrjO0X6bjzUGqL6RYs9Vxo6nuKCElLiD
         XFuF1uXojC/vQ9g7CkElXVAvrGZR8Exr6pHVwpNtXjdRdYi3nubRKBCZmJqyGlGeqd0H
         VxoS3gp4yi3QwVF1gazKwTbLwtcbDqqquXkuwV3aYo7EXE68OMDSh9u4x01RDH7mbZth
         qeIPmUqqMkQOZGF5Zl+E/JjSUAoW9nGbs8JXTz81AQrQaOL9Gp0fKn7VTLq7+PG9Bv3S
         ndYUA6Xx941I+fxOpLTUH2y9g0iBLzkHRrdkDFqmV4jU5fnYqcOrNJ5mQlqjBSc33nVt
         V2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZyxOga97QK0VQyc6gPI7ZtuFN1BPOlKdb1xu1VWlvxo=;
        b=bMQQFruFTuS/b+T0sn+PT1gDHcedB+i3Lc+Cstf1JzWZxrpk+6S5jsupXMstfdVv9j
         3DwxbwtLljMHGN8yGyeRwmz06YDDrA8SXxjIZU3Qi052DErtfvcPI2xvWotQlIHlewOl
         rT/xBieABSdwxl9CHFAqxlmFYzGON1lXjBLKmLKWh74aG0eX+JfysgqaVbHrWC8MrDvg
         Meg5O42OptRrweZDa4VmrQCxTr4o740Xk2RgAvezYrCrZTO9TcB9mpTGnxR6NmtyUNBc
         8XmBBdJl06/4ihO0s9thk7GksvnJozv7Jh/nYaiZ0a1CeuOUx02yQI4Q+wrtKgoFJFve
         OwOg==
X-Gm-Message-State: AOAM531XPgJ5QUVyZwib5egHUE13sNUOdr5dYpH+ELpm/wv/e9mYBUKm
        WuztRKKw74D1/N14J5Dfv7quNfvNTbU=
X-Google-Smtp-Source: ABdhPJxDSOXALgUgPz7uIDrF1EOcG6PVyD6dHi1FLPkq+I83EDY/Y33yoibtOMdvC7tlbgHagg3qKQ==
X-Received: by 2002:aa7:8550:0:b029:32b:963f:f53b with SMTP id y16-20020aa785500000b029032b963ff53bmr16030952pfn.0.1627271521935;
        Sun, 25 Jul 2021 20:52:01 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 33/55] KVM: PPC: Book3S HV P9: Move host OS save/restore functions to built-in
Date:   Mon, 26 Jul 2021 13:50:14 +1000
Message-Id: <20210726035036.739609-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the P9 guest/host register switching functions to the built-in
P9 entry code, and export it for nested to use as well.

This allows more flexibility in scheduling these supervisor privileged
SPR accesses with the HV privileged and PR SPR accesses in the low level
entry code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 365 +-------------------------
 arch/powerpc/kvm/book3s_hv.h          |  39 +++
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 345 ++++++++++++++++++++++++
 3 files changed, 385 insertions(+), 364 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_hv.h

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 45211458ac05..977712eb74e0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -80,6 +80,7 @@
 #include <asm/plpar_wrappers.h>
 
 #include "book3s.h"
+#include "book3s_hv.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace_hv.h"
@@ -3772,370 +3773,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
-/*
- * Privileged (non-hypervisor) host registers to save.
- */
-struct p9_host_os_sprs {
-	unsigned long dscr;
-	unsigned long tidr;
-	unsigned long iamr;
-	unsigned long amr;
-	unsigned long fscr;
-
-	unsigned int pmc1;
-	unsigned int pmc2;
-	unsigned int pmc3;
-	unsigned int pmc4;
-	unsigned int pmc5;
-	unsigned int pmc6;
-	unsigned long mmcr0;
-	unsigned long mmcr1;
-	unsigned long mmcr2;
-	unsigned long mmcr3;
-	unsigned long mmcra;
-	unsigned long siar;
-	unsigned long sier1;
-	unsigned long sier2;
-	unsigned long sier3;
-	unsigned long sdar;
-};
-
-static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
-{
-	if (!(mmcr0 & MMCR0_FC))
-		goto do_freeze;
-	if (mmcra & MMCRA_SAMPLE_ENABLE)
-		goto do_freeze;
-	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-		if (!(mmcr0 & MMCR0_PMCCEXT))
-			goto do_freeze;
-		if (!(mmcra & MMCRA_BHRB_DISABLE))
-			goto do_freeze;
-	}
-	return;
-
-do_freeze:
-	mmcr0 = MMCR0_FC;
-	mmcra = 0;
-	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-		mmcr0 |= MMCR0_PMCCEXT;
-		mmcra = MMCRA_BHRB_DISABLE;
-	}
-
-	mtspr(SPRN_MMCR0, mmcr0);
-	mtspr(SPRN_MMCRA, mmcra);
-	isync();
-}
-
-static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
-				struct p9_host_os_sprs *host_os_sprs)
-{
-	struct lppaca *lp;
-	int load_pmu = 1;
-
-	lp = vcpu->arch.vpa.pinned_addr;
-	if (lp)
-		load_pmu = lp->pmcregs_in_use;
-
-	/* Save host */
-	if (ppc_get_pmu_inuse()) {
-		/*
-		 * It might be better to put PMU handling (at least for the
-		 * host) in the perf subsystem because it knows more about what
-		 * is being used.
-		 */
-
-		/* POWER9, POWER10 do not implement HPMC or SPMC */
-
-		host_os_sprs->mmcr0 = mfspr(SPRN_MMCR0);
-		host_os_sprs->mmcra = mfspr(SPRN_MMCRA);
-
-		freeze_pmu(host_os_sprs->mmcr0, host_os_sprs->mmcra);
-
-		host_os_sprs->pmc1 = mfspr(SPRN_PMC1);
-		host_os_sprs->pmc2 = mfspr(SPRN_PMC2);
-		host_os_sprs->pmc3 = mfspr(SPRN_PMC3);
-		host_os_sprs->pmc4 = mfspr(SPRN_PMC4);
-		host_os_sprs->pmc5 = mfspr(SPRN_PMC5);
-		host_os_sprs->pmc6 = mfspr(SPRN_PMC6);
-		host_os_sprs->mmcr1 = mfspr(SPRN_MMCR1);
-		host_os_sprs->mmcr2 = mfspr(SPRN_MMCR2);
-		host_os_sprs->sdar = mfspr(SPRN_SDAR);
-		host_os_sprs->siar = mfspr(SPRN_SIAR);
-		host_os_sprs->sier1 = mfspr(SPRN_SIER);
-
-		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-			host_os_sprs->mmcr3 = mfspr(SPRN_MMCR3);
-			host_os_sprs->sier2 = mfspr(SPRN_SIER2);
-			host_os_sprs->sier3 = mfspr(SPRN_SIER3);
-		}
-	}
-
-#ifdef CONFIG_PPC_PSERIES
-	/* After saving PMU, before loading guest PMU, flip pmcregs_in_use */
-	if (kvmhv_on_pseries()) {
-		barrier();
-		get_lppaca()->pmcregs_in_use = load_pmu;
-		barrier();
-	}
-#endif
-
-	/*
-	 * Load guest. If the VPA said the PMCs are not in use but the guest
-	 * tried to access them anyway, HFSCR[PM] will be set by the HFAC
-	 * fault so we can make forward progress.
-	 */
-	if (load_pmu || (vcpu->arch.hfscr & HFSCR_PM)) {
-		mtspr(SPRN_PMC1, vcpu->arch.pmc[0]);
-		mtspr(SPRN_PMC2, vcpu->arch.pmc[1]);
-		mtspr(SPRN_PMC3, vcpu->arch.pmc[2]);
-		mtspr(SPRN_PMC4, vcpu->arch.pmc[3]);
-		mtspr(SPRN_PMC5, vcpu->arch.pmc[4]);
-		mtspr(SPRN_PMC6, vcpu->arch.pmc[5]);
-		mtspr(SPRN_MMCR1, vcpu->arch.mmcr[1]);
-		mtspr(SPRN_MMCR2, vcpu->arch.mmcr[2]);
-		mtspr(SPRN_SDAR, vcpu->arch.sdar);
-		mtspr(SPRN_SIAR, vcpu->arch.siar);
-		mtspr(SPRN_SIER, vcpu->arch.sier[0]);
-
-		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-			mtspr(SPRN_MMCR3, vcpu->arch.mmcr[3]);
-			mtspr(SPRN_SIER2, vcpu->arch.sier[1]);
-			mtspr(SPRN_SIER3, vcpu->arch.sier[2]);
-		}
-
-		/* Set MMCRA then MMCR0 last */
-		mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
-		mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
-		/* No isync necessary because we're starting counters */
-
-		if (!vcpu->arch.nested &&
-				(vcpu->arch.hfscr_permitted & HFSCR_PM))
-			vcpu->arch.hfscr |= HFSCR_PM;
-	}
-}
-
-static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
-				struct p9_host_os_sprs *host_os_sprs)
-{
-	struct lppaca *lp;
-	int save_pmu = 1;
-
-	lp = vcpu->arch.vpa.pinned_addr;
-	if (lp)
-		save_pmu = lp->pmcregs_in_use;
-
-	if (save_pmu) {
-		vcpu->arch.mmcr[0] = mfspr(SPRN_MMCR0);
-		vcpu->arch.mmcra = mfspr(SPRN_MMCRA);
-
-		freeze_pmu(vcpu->arch.mmcr[0], vcpu->arch.mmcra);
-
-		vcpu->arch.pmc[0] = mfspr(SPRN_PMC1);
-		vcpu->arch.pmc[1] = mfspr(SPRN_PMC2);
-		vcpu->arch.pmc[2] = mfspr(SPRN_PMC3);
-		vcpu->arch.pmc[3] = mfspr(SPRN_PMC4);
-		vcpu->arch.pmc[4] = mfspr(SPRN_PMC5);
-		vcpu->arch.pmc[5] = mfspr(SPRN_PMC6);
-		vcpu->arch.mmcr[1] = mfspr(SPRN_MMCR1);
-		vcpu->arch.mmcr[2] = mfspr(SPRN_MMCR2);
-		vcpu->arch.sdar = mfspr(SPRN_SDAR);
-		vcpu->arch.siar = mfspr(SPRN_SIAR);
-		vcpu->arch.sier[0] = mfspr(SPRN_SIER);
-
-		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-			vcpu->arch.mmcr[3] = mfspr(SPRN_MMCR3);
-			vcpu->arch.sier[1] = mfspr(SPRN_SIER2);
-			vcpu->arch.sier[2] = mfspr(SPRN_SIER3);
-		}
-
-	} else if (vcpu->arch.hfscr & HFSCR_PM) {
-		/*
-		 * The guest accessed PMC SPRs without specifying they should
-		 * be preserved, or it cleared pmcregs_in_use after the last
-		 * access. Just ensure they are frozen.
-		 */
-		freeze_pmu(mfspr(SPRN_MMCR0), mfspr(SPRN_MMCRA));
-
-		/*
-		 * Demand-fault PMU register access in the guest.
-		 *
-		 * This is used to grab the guest's VPA pmcregs_in_use value
-		 * and reflect it into the host's VPA in the case of a nested
-		 * hypervisor.
-		 *
-		 * It also avoids having to zero-out SPRs after each guest
-		 * exit to avoid side-channels when.
-		 *
-		 * This is cleared here when we exit the guest, so later HFSCR
-		 * interrupt handling can add it back to run the guest with
-		 * PM enabled next time.
-		 */
-		if (!vcpu->arch.nested)
-			vcpu->arch.hfscr &= ~HFSCR_PM;
-	} /* otherwise the PMU should still be frozen */
-
-#ifdef CONFIG_PPC_PSERIES
-	if (kvmhv_on_pseries()) {
-		barrier();
-		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
-		barrier();
-	}
-#endif
-
-	if (ppc_get_pmu_inuse()) {
-		mtspr(SPRN_PMC1, host_os_sprs->pmc1);
-		mtspr(SPRN_PMC2, host_os_sprs->pmc2);
-		mtspr(SPRN_PMC3, host_os_sprs->pmc3);
-		mtspr(SPRN_PMC4, host_os_sprs->pmc4);
-		mtspr(SPRN_PMC5, host_os_sprs->pmc5);
-		mtspr(SPRN_PMC6, host_os_sprs->pmc6);
-		mtspr(SPRN_MMCR1, host_os_sprs->mmcr1);
-		mtspr(SPRN_MMCR2, host_os_sprs->mmcr2);
-		mtspr(SPRN_SDAR, host_os_sprs->sdar);
-		mtspr(SPRN_SIAR, host_os_sprs->siar);
-		mtspr(SPRN_SIER, host_os_sprs->sier1);
-
-		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-			mtspr(SPRN_MMCR3, host_os_sprs->mmcr3);
-			mtspr(SPRN_SIER2, host_os_sprs->sier2);
-			mtspr(SPRN_SIER3, host_os_sprs->sier3);
-		}
-
-		/* Set MMCRA then MMCR0 last */
-		mtspr(SPRN_MMCRA, host_os_sprs->mmcra);
-		mtspr(SPRN_MMCR0, host_os_sprs->mmcr0);
-		isync();
-	}
-}
-
-static void load_spr_state(struct kvm_vcpu *vcpu,
-				struct p9_host_os_sprs *host_os_sprs)
-{
-	mtspr(SPRN_TAR, vcpu->arch.tar);
-	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
-	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
-	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		mtspr(SPRN_TIDR, vcpu->arch.tid);
-	if (host_os_sprs->iamr != vcpu->arch.iamr)
-		mtspr(SPRN_IAMR, vcpu->arch.iamr);
-	if (host_os_sprs->amr != vcpu->arch.amr)
-		mtspr(SPRN_AMR, vcpu->arch.amr);
-	if (vcpu->arch.uamor != 0)
-		mtspr(SPRN_UAMOR, vcpu->arch.uamor);
-	if (host_os_sprs->fscr != vcpu->arch.fscr)
-		mtspr(SPRN_FSCR, vcpu->arch.fscr);
-	if (host_os_sprs->dscr != vcpu->arch.dscr)
-		mtspr(SPRN_DSCR, vcpu->arch.dscr);
-	if (vcpu->arch.pspb != 0)
-		mtspr(SPRN_PSPB, vcpu->arch.pspb);
-
-	/*
-	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
-	 * clear (or hstate set appropriately to catch those registers
-	 * being clobbered if we take a MCE or SRESET), so those are done
-	 * later.
-	 */
-
-	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, 0);
-}
-
-static void store_spr_state(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.tar = mfspr(SPRN_TAR);
-	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
-	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
-	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		vcpu->arch.tid = mfspr(SPRN_TIDR);
-	vcpu->arch.iamr = mfspr(SPRN_IAMR);
-	vcpu->arch.amr = mfspr(SPRN_AMR);
-	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
-	vcpu->arch.fscr = mfspr(SPRN_FSCR);
-	vcpu->arch.dscr = mfspr(SPRN_DSCR);
-	vcpu->arch.pspb = mfspr(SPRN_PSPB);
-
-	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
-}
-
-/* Returns true if current MSR and/or guest MSR may have changed */
-static bool load_vcpu_state(struct kvm_vcpu *vcpu,
-			   struct p9_host_os_sprs *host_os_sprs)
-{
-	bool ret = false;
-
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		ret = true;
-	}
-
-	load_spr_state(vcpu, host_os_sprs);
-
-	load_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	load_vr_state(&vcpu->arch.vr);
-#endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
-
-	return ret;
-}
-
-static void store_vcpu_state(struct kvm_vcpu *vcpu)
-{
-	store_spr_state(vcpu);
-
-	store_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	store_vr_state(&vcpu->arch.vr);
-#endif
-	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
-
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-}
-
-static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
-{
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		host_os_sprs->tidr = mfspr(SPRN_TIDR);
-	host_os_sprs->iamr = mfspr(SPRN_IAMR);
-	host_os_sprs->amr = mfspr(SPRN_AMR);
-	host_os_sprs->fscr = mfspr(SPRN_FSCR);
-	host_os_sprs->dscr = mfspr(SPRN_DSCR);
-}
-
-/* vcpu guest regs must already be saved */
-static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
-				    struct p9_host_os_sprs *host_os_sprs)
-{
-	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
-
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		mtspr(SPRN_TIDR, host_os_sprs->tidr);
-	if (host_os_sprs->iamr != vcpu->arch.iamr)
-		mtspr(SPRN_IAMR, host_os_sprs->iamr);
-	if (vcpu->arch.uamor != 0)
-		mtspr(SPRN_UAMOR, 0);
-	if (host_os_sprs->amr != vcpu->arch.amr)
-		mtspr(SPRN_AMR, host_os_sprs->amr);
-	if (host_os_sprs->fscr != vcpu->arch.fscr)
-		mtspr(SPRN_FSCR, host_os_sprs->fscr);
-	if (host_os_sprs->dscr != vcpu->arch.dscr)
-		mtspr(SPRN_DSCR, host_os_sprs->dscr);
-	if (vcpu->arch.pspb != 0)
-		mtspr(SPRN_PSPB, 0);
-
-	/* Save guest CTRL register, set runlatch to 1 */
-	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, 1);
-}
-
 static inline bool hcall_is_xics(unsigned long req)
 {
 	return req == H_EOI || req == H_CPPR || req == H_IPI ||
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
new file mode 100644
index 000000000000..a9065a380547
--- /dev/null
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -0,0 +1,39 @@
+
+/*
+ * Privileged (non-hypervisor) host registers to save.
+ */
+struct p9_host_os_sprs {
+	unsigned long dscr;
+	unsigned long tidr;
+	unsigned long iamr;
+	unsigned long amr;
+	unsigned long fscr;
+
+	unsigned int pmc1;
+	unsigned int pmc2;
+	unsigned int pmc3;
+	unsigned int pmc4;
+	unsigned int pmc5;
+	unsigned int pmc6;
+	unsigned long mmcr0;
+	unsigned long mmcr1;
+	unsigned long mmcr2;
+	unsigned long mmcr3;
+	unsigned long mmcra;
+	unsigned long siar;
+	unsigned long sier1;
+	unsigned long sier2;
+	unsigned long sier3;
+	unsigned long sdar;
+};
+
+bool load_vcpu_state(struct kvm_vcpu *vcpu,
+			   struct p9_host_os_sprs *host_os_sprs);
+void store_vcpu_state(struct kvm_vcpu *vcpu);
+void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs);
+void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
+				    struct p9_host_os_sprs *host_os_sprs);
+void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
+			    struct p9_host_os_sprs *host_os_sprs);
+void switch_pmu_to_host(struct kvm_vcpu *vcpu,
+			    struct p9_host_os_sprs *host_os_sprs);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index bd0021cd3a67..5a34f0199bfe 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -4,8 +4,353 @@
 #include <asm/asm-prototypes.h>
 #include <asm/dbell.h>
 #include <asm/kvm_ppc.h>
+#include <asm/pmc.h>
 #include <asm/ppc-opcode.h>
 
+#include "book3s_hv.h"
+
+static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
+{
+	if (!(mmcr0 & MMCR0_FC))
+		goto do_freeze;
+	if (mmcra & MMCRA_SAMPLE_ENABLE)
+		goto do_freeze;
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		if (!(mmcr0 & MMCR0_PMCCEXT))
+			goto do_freeze;
+		if (!(mmcra & MMCRA_BHRB_DISABLE))
+			goto do_freeze;
+	}
+	return;
+
+do_freeze:
+	mmcr0 = MMCR0_FC;
+	mmcra = 0;
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		mmcr0 |= MMCR0_PMCCEXT;
+		mmcra = MMCRA_BHRB_DISABLE;
+	}
+
+	mtspr(SPRN_MMCR0, mmcr0);
+	mtspr(SPRN_MMCRA, mmcra);
+	isync();
+}
+
+void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
+			 struct p9_host_os_sprs *host_os_sprs)
+{
+	struct lppaca *lp;
+	int load_pmu = 1;
+
+	lp = vcpu->arch.vpa.pinned_addr;
+	if (lp)
+		load_pmu = lp->pmcregs_in_use;
+
+	/* Save host */
+	if (ppc_get_pmu_inuse()) {
+		/*
+		 * It might be better to put PMU handling (at least for the
+		 * host) in the perf subsystem because it knows more about what
+		 * is being used.
+		 */
+
+		/* POWER9, POWER10 do not implement HPMC or SPMC */
+
+		host_os_sprs->mmcr0 = mfspr(SPRN_MMCR0);
+		host_os_sprs->mmcra = mfspr(SPRN_MMCRA);
+
+		freeze_pmu(host_os_sprs->mmcr0, host_os_sprs->mmcra);
+
+		host_os_sprs->pmc1 = mfspr(SPRN_PMC1);
+		host_os_sprs->pmc2 = mfspr(SPRN_PMC2);
+		host_os_sprs->pmc3 = mfspr(SPRN_PMC3);
+		host_os_sprs->pmc4 = mfspr(SPRN_PMC4);
+		host_os_sprs->pmc5 = mfspr(SPRN_PMC5);
+		host_os_sprs->pmc6 = mfspr(SPRN_PMC6);
+		host_os_sprs->mmcr1 = mfspr(SPRN_MMCR1);
+		host_os_sprs->mmcr2 = mfspr(SPRN_MMCR2);
+		host_os_sprs->sdar = mfspr(SPRN_SDAR);
+		host_os_sprs->siar = mfspr(SPRN_SIAR);
+		host_os_sprs->sier1 = mfspr(SPRN_SIER);
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			host_os_sprs->mmcr3 = mfspr(SPRN_MMCR3);
+			host_os_sprs->sier2 = mfspr(SPRN_SIER2);
+			host_os_sprs->sier3 = mfspr(SPRN_SIER3);
+		}
+	}
+
+#ifdef CONFIG_PPC_PSERIES
+	/* After saving PMU, before loading guest PMU, flip pmcregs_in_use */
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = load_pmu;
+		barrier();
+	}
+#endif
+
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
+
+		/* Set MMCRA then MMCR0 last */
+		mtspr(SPRN_MMCRA, vcpu->arch.mmcra);
+		mtspr(SPRN_MMCR0, vcpu->arch.mmcr[0]);
+		/* No isync necessary because we're starting counters */
+
+		if (!vcpu->arch.nested &&
+				(vcpu->arch.hfscr_permitted & HFSCR_PM))
+			vcpu->arch.hfscr |= HFSCR_PM;
+	}
+}
+EXPORT_SYMBOL_GPL(switch_pmu_to_guest);
+
+void switch_pmu_to_host(struct kvm_vcpu *vcpu,
+			struct p9_host_os_sprs *host_os_sprs)
+{
+	struct lppaca *lp;
+	int save_pmu = 1;
+
+	lp = vcpu->arch.vpa.pinned_addr;
+	if (lp)
+		save_pmu = lp->pmcregs_in_use;
+
+	if (save_pmu) {
+		vcpu->arch.mmcr[0] = mfspr(SPRN_MMCR0);
+		vcpu->arch.mmcra = mfspr(SPRN_MMCRA);
+
+		freeze_pmu(vcpu->arch.mmcr[0], vcpu->arch.mmcra);
+
+		vcpu->arch.pmc[0] = mfspr(SPRN_PMC1);
+		vcpu->arch.pmc[1] = mfspr(SPRN_PMC2);
+		vcpu->arch.pmc[2] = mfspr(SPRN_PMC3);
+		vcpu->arch.pmc[3] = mfspr(SPRN_PMC4);
+		vcpu->arch.pmc[4] = mfspr(SPRN_PMC5);
+		vcpu->arch.pmc[5] = mfspr(SPRN_PMC6);
+		vcpu->arch.mmcr[1] = mfspr(SPRN_MMCR1);
+		vcpu->arch.mmcr[2] = mfspr(SPRN_MMCR2);
+		vcpu->arch.sdar = mfspr(SPRN_SDAR);
+		vcpu->arch.siar = mfspr(SPRN_SIAR);
+		vcpu->arch.sier[0] = mfspr(SPRN_SIER);
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			vcpu->arch.mmcr[3] = mfspr(SPRN_MMCR3);
+			vcpu->arch.sier[1] = mfspr(SPRN_SIER2);
+			vcpu->arch.sier[2] = mfspr(SPRN_SIER3);
+		}
+
+	} else if (vcpu->arch.hfscr & HFSCR_PM) {
+		/*
+		 * The guest accessed PMC SPRs without specifying they should
+		 * be preserved, or it cleared pmcregs_in_use after the last
+		 * access. Just ensure they are frozen.
+		 */
+		freeze_pmu(mfspr(SPRN_MMCR0), mfspr(SPRN_MMCRA));
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
+
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
+
+	if (ppc_get_pmu_inuse()) {
+		mtspr(SPRN_PMC1, host_os_sprs->pmc1);
+		mtspr(SPRN_PMC2, host_os_sprs->pmc2);
+		mtspr(SPRN_PMC3, host_os_sprs->pmc3);
+		mtspr(SPRN_PMC4, host_os_sprs->pmc4);
+		mtspr(SPRN_PMC5, host_os_sprs->pmc5);
+		mtspr(SPRN_PMC6, host_os_sprs->pmc6);
+		mtspr(SPRN_MMCR1, host_os_sprs->mmcr1);
+		mtspr(SPRN_MMCR2, host_os_sprs->mmcr2);
+		mtspr(SPRN_SDAR, host_os_sprs->sdar);
+		mtspr(SPRN_SIAR, host_os_sprs->siar);
+		mtspr(SPRN_SIER, host_os_sprs->sier1);
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			mtspr(SPRN_MMCR3, host_os_sprs->mmcr3);
+			mtspr(SPRN_SIER2, host_os_sprs->sier2);
+			mtspr(SPRN_SIER3, host_os_sprs->sier3);
+		}
+
+		/* Set MMCRA then MMCR0 last */
+		mtspr(SPRN_MMCRA, host_os_sprs->mmcra);
+		mtspr(SPRN_MMCR0, host_os_sprs->mmcr0);
+		isync();
+	}
+}
+EXPORT_SYMBOL_GPL(switch_pmu_to_host);
+
+static void load_spr_state(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
+{
+	mtspr(SPRN_TAR, vcpu->arch.tar);
+	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
+	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
+	mtspr(SPRN_BESCR, vcpu->arch.bescr);
+
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		mtspr(SPRN_TIDR, vcpu->arch.tid);
+	if (host_os_sprs->iamr != vcpu->arch.iamr)
+		mtspr(SPRN_IAMR, vcpu->arch.iamr);
+	if (host_os_sprs->amr != vcpu->arch.amr)
+		mtspr(SPRN_AMR, vcpu->arch.amr);
+	if (vcpu->arch.uamor != 0)
+		mtspr(SPRN_UAMOR, vcpu->arch.uamor);
+	if (host_os_sprs->fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, vcpu->arch.fscr);
+	if (host_os_sprs->dscr != vcpu->arch.dscr)
+		mtspr(SPRN_DSCR, vcpu->arch.dscr);
+	if (vcpu->arch.pspb != 0)
+		mtspr(SPRN_PSPB, vcpu->arch.pspb);
+
+	/*
+	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
+	 * clear (or hstate set appropriately to catch those registers
+	 * being clobbered if we take a MCE or SRESET), so those are done
+	 * later.
+	 */
+
+	if (!(vcpu->arch.ctrl & 1))
+		mtspr(SPRN_CTRLT, 0);
+}
+
+static void store_spr_state(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.tar = mfspr(SPRN_TAR);
+	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
+	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
+	vcpu->arch.bescr = mfspr(SPRN_BESCR);
+
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		vcpu->arch.tid = mfspr(SPRN_TIDR);
+	vcpu->arch.iamr = mfspr(SPRN_IAMR);
+	vcpu->arch.amr = mfspr(SPRN_AMR);
+	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
+	vcpu->arch.fscr = mfspr(SPRN_FSCR);
+	vcpu->arch.dscr = mfspr(SPRN_DSCR);
+	vcpu->arch.pspb = mfspr(SPRN_PSPB);
+
+	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
+}
+
+/* Returns true if current MSR and/or guest MSR may have changed */
+bool load_vcpu_state(struct kvm_vcpu *vcpu,
+		     struct p9_host_os_sprs *host_os_sprs)
+{
+	bool ret = false;
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+		ret = true;
+	}
+
+	load_spr_state(vcpu, host_os_sprs);
+
+	load_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	load_vr_state(&vcpu->arch.vr);
+#endif
+	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(load_vcpu_state);
+
+void store_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	store_spr_state(vcpu);
+
+	store_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	store_vr_state(&vcpu->arch.vr);
+#endif
+	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+}
+EXPORT_SYMBOL_GPL(store_vcpu_state);
+
+void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
+{
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		host_os_sprs->tidr = mfspr(SPRN_TIDR);
+	host_os_sprs->iamr = mfspr(SPRN_IAMR);
+	host_os_sprs->amr = mfspr(SPRN_AMR);
+	host_os_sprs->fscr = mfspr(SPRN_FSCR);
+	host_os_sprs->dscr = mfspr(SPRN_DSCR);
+}
+EXPORT_SYMBOL_GPL(save_p9_host_os_sprs);
+
+/* vcpu guest regs must already be saved */
+void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
+			     struct p9_host_os_sprs *host_os_sprs)
+{
+	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
+
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		mtspr(SPRN_TIDR, host_os_sprs->tidr);
+	if (host_os_sprs->iamr != vcpu->arch.iamr)
+		mtspr(SPRN_IAMR, host_os_sprs->iamr);
+	if (vcpu->arch.uamor != 0)
+		mtspr(SPRN_UAMOR, 0);
+	if (host_os_sprs->amr != vcpu->arch.amr)
+		mtspr(SPRN_AMR, host_os_sprs->amr);
+	if (host_os_sprs->fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, host_os_sprs->fscr);
+	if (host_os_sprs->dscr != vcpu->arch.dscr)
+		mtspr(SPRN_DSCR, host_os_sprs->dscr);
+	if (vcpu->arch.pspb != 0)
+		mtspr(SPRN_PSPB, 0);
+
+	/* Save guest CTRL register, set runlatch to 1 */
+	if (!(vcpu->arch.ctrl & 1))
+		mtspr(SPRN_CTRLT, 1);
+}
+EXPORT_SYMBOL_GPL(restore_p9_host_os_sprs);
+
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
 static void __start_timing(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
 {
-- 
2.23.0

