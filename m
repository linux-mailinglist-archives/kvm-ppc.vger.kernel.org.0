Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A94637F7BE
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 14:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhEMMXc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 08:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhEMMXb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 08:23:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F011EC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:21 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m124so21147564pgm.13
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQE5WmR3OFYFGmrRU5pr+0hPMcZAjyMpmhplp/ZL9j8=;
        b=DkYVcB2fPYwpaRO1+bxr0ZhrnI8JCy3HLGtSo2a/GS3DvZSnSqcs7bKPXE+eDwHcBR
         6fuOIjRifBpz4bjLCT2OzzhroKARoz3rc+fYcDQXBw6h1di5Vncxpvj/42yPmiaulCcE
         uS1bxlmYlZgXp3HHfx76mdtHDKYsUTrEJa2WtDQeOTtFw9CzInLy6nICQB0sUgWFEQfm
         3Fekzj+mIHBre4K8es3E5RZMrQiLm5cIqqMCiGYX0K4PGlxHcUb4FbGTjIL1PNwXgJtJ
         Mc6zon4C6b2GZ/6LpPbOCFhPqxOYyzaal2480mYGZt7T24QV+B1EHX+gZMZ93KrQ+/MF
         SW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQE5WmR3OFYFGmrRU5pr+0hPMcZAjyMpmhplp/ZL9j8=;
        b=g3ksoh2Rmwdzxoud6dQhMsSunVhkBJWLiWN1+jY0kvQ7BVmoMzhbZpihVn3zxc4OIM
         le0hCa9pzIHRIfhsvXUdShbikhI0EkaltPaDuNe3NZn5VvXRNQLFwXAzRsPkP9DRYPC+
         JFCMV9g7ArOpNlluDbaqjb5gEMPojPNGEf5GX4KHQ9CazhAuOb8h3Xw7yn+fZx8taNSv
         nvn/Zst72/lmWNuoCaLbbT6lFh+TZfYGpSdtbNgd7EDek/9N1KMX1IOFLV2L0uQbePzj
         DonidWFbyaYXZlCEt5xffhcPaiDZIcE6viPa0UkVcRgdFnWnhkvqcGy+XPCuCFN0KTZf
         iefQ==
X-Gm-Message-State: AOAM530rNvzvdxQfxXz6dhFei5IsfSQF5BI5P0BzIZqWuX7F38lSY1vr
        fMXZOkvsCm5Yr/fivgCo5Y9PHpoFm3sWeA==
X-Google-Smtp-Source: ABdhPJxFWdAlLMGWYokQZRuddVammvBWrsg7s81m256pg/Wjb2NbTeLReXHJ+S7GsyM6QlQFmlZkcQ==
X-Received: by 2002:a63:5910:: with SMTP id n16mr41767034pgb.351.1620908541336;
        Thu, 13 May 2021 05:22:21 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id mp21sm6892416pjb.50.2021.05.13.05.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:22:21 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 2/4] KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
Date:   Thu, 13 May 2021 22:22:05 +1000
Message-Id: <20210513122207.1897664-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210513122207.1897664-1-npiggin@gmail.com>
References: <20210513122207.1897664-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Switching the MMU from radix<->radix mode is tricky particularly as the
MMU can remain enabled and requires a certain sequence of SPR updates.
Move these together into their own functions.

This also includes the radix TLB check / flush because it's tied in to
MMU switching due to tlbiel getting LPID from LPIDR.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 62 ++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 68914b26017b..287cd3e1b918 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3478,12 +3478,49 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
+static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	u32 lpid;
+
+	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
+
+	/*
+	 * All the isync()s are overkill but trivially follow the ISA
+	 * requirements. Some can likely be replaced with justification
+	 * comment for why they are not needed.
+	 */
+	isync();
+	mtspr(SPRN_LPID, lpid);
+	isync();
+	mtspr(SPRN_LPCR, lpcr);
+	isync();
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	isync();
+	mtspr(SPRN_PID, pid);
+	isync();
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
+	isync();
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
+	isync();
+}
+
 /*
  * Load up hypervisor-mode registers on P9.
  */
 static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	s64 hdec;
 	u64 tb, purr, spurr;
@@ -3535,7 +3572,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 	mtspr(SPRN_IC, vcpu->arch.ic);
-	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -3549,8 +3585,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
 	/*
 	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
@@ -3593,7 +3628,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		mtspr(SPRN_DAWR1, host_dawr1);
 		mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
-	mtspr(SPRN_PID, host_pidr);
 
 	/*
 	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
@@ -3608,9 +3642,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
-	isync();
-
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
@@ -3627,7 +3658,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 
 	mtspr(SPRN_HDEC, 0x7fffffff);
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
 
 	return trap;
 }
@@ -4181,7 +4213,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvm_run *run = vcpu->run;
 	int trap, r, pcpu;
-	int srcu_idx, lpid;
+	int srcu_idx;
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -4255,13 +4287,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->vcore_state = VCORE_RUNNING;
 	trace_kvmppc_run_core(vc, 0);
 
-	if (cpu_has_feature(CPU_FTR_HVMODE)) {
-		lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
-		mtspr(SPRN_LPID, lpid);
-		isync();
-		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
-	}
-
 	guest_enter_irqoff();
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -4280,11 +4305,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 
-	if (cpu_has_feature(CPU_FTR_HVMODE)) {
-		mtspr(SPRN_LPID, kvm->arch.host_lpid);
-		isync();
-	}
-
 	set_irq_happened(trap);
 
 	kvmppc_set_host_core(pcpu);
-- 
2.23.0

