Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA26E345480
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCWBEr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhCWBES (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C71C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so9419390pjb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pR64eHRlw7s509QiNuubsLtlCqUHU8S+Tv1bWyfysfs=;
        b=plvNPtDCgX7zw5u8Th8S7GACfY7y3ZghSktRtYcW8Oh+BOcEpUFrm5StQGDXHgc4uB
         VyFXSZXJBtvlBwETD8YvmzPFiNxBWWVGmhi1r7PU6KRD5v0PO+zYYrx/eJQjyFiawvL4
         jyejJZG+PYo3ZIRZBxjA/wRPIzXgV0OPk5eYp9nx4Ug1JlnSjED5nafukL155sL6YlQx
         cPb/TADvsrjrAa4c07jzGYuJHqTJQwEu9GhFqxylBTE/oJFZ3ijHhWR1bTMPQ0e0C7Qc
         AASUFcpeJXOJicu/Q9xzR7uostx35zPCAjTBECdTE8l8Q0GWmgUhYvGwhdj0K3QcoSkT
         /ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pR64eHRlw7s509QiNuubsLtlCqUHU8S+Tv1bWyfysfs=;
        b=lTTUTxfGdc2uNfnsFnRZH/gkR1RlCZsxALUj5dE93xMqqN0bPbPscZ0UZTIB6557si
         OvfsXadaxAQtrF6nR0eMMza8PhW4RUCiKgJ8J2iw+e6YvFZm/T8KM90kh3kY+7768pZg
         KLalsb7fLtKHqSm0HP7+QoG1IDWpMkMzzwBQEQvqTSiv9O05Pz1XB0HUitF5oKBPoW1a
         e31ZLEugb3osk+MfVAT1qJEHdx27FCjjkAzJt3TKiBwWbcsfJM7PNCDk7/t0sA+SbAco
         rUA9//8jWdyGG6GMuzwZuFWUXm72TKg/+olm2cX/+1y+f5kqpfs3Oq5AXLpC/9yDbmGY
         /RvQ==
X-Gm-Message-State: AOAM532aGk8BzeXOadIOfsMrUPjruWj4LetXTK2KDZZqP9cjPV2bq6vd
        clIin9bNuWmeo0Pa4FHtmlAubHDQVas=
X-Google-Smtp-Source: ABdhPJxsg9pwwoo+U+XnDLFJXiwykl9o37m4JivS7wP6AbpvdKaTWyaIEIc/zsvvfA2ZIAyzHWGBTw==
X-Received: by 2002:a17:90a:66c2:: with SMTP id z2mr1850151pjl.139.1616461456808;
        Mon, 22 Mar 2021 18:04:16 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 19/46] KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
Date:   Tue, 23 Mar 2021 11:02:38 +1000
Message-Id: <20210323010305.1045293-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c | 66 +++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7bb4222729b0..b822c573dc08 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3472,12 +3472,49 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
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
@@ -3500,12 +3537,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
 	 * so set HDICE before writing HDEC.
 	 */
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
 	isync();
 
 	hdec = time_limit - mftb();
 	if (hdec < 0) {
-		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
 		isync();
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	}
@@ -3540,7 +3577,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 	mtspr(SPRN_IC, vcpu->arch.ic);
-	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -3554,8 +3590,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
 	kvmppc_xive_push_vcpu(vcpu);
 
@@ -3594,7 +3629,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		mtspr(SPRN_DAWR1, host_dawr1);
 		mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
-	mtspr(SPRN_PID, host_pidr);
 
 	/*
 	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
@@ -3609,9 +3643,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
-	isync();
-
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
@@ -3628,7 +3659,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 
 	mtspr(SPRN_HDEC, 0x7fffffff);
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
 
 	return trap;
 }
@@ -4161,7 +4193,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvm_run *run = vcpu->run;
 	int trap, r, pcpu;
-	int srcu_idx, lpid;
+	int srcu_idx;
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -4235,13 +4267,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4260,11 +4285,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

