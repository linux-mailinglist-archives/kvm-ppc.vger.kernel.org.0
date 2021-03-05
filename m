Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C0632EDD4
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCEPIN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhCEPHn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C6CC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:43 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q20so2278100pfu.8
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sLFdz/YLEOQnsrWkjcaI9mpQ2SxucOADkjSbMggLiKI=;
        b=BhTNkC8DdZn4sBFnCsJzxvU9s+y9ciUjBzmpxhNz2G1WKwl9RfolPzlXpjHsy8PQmP
         IbhL+WB+1dJHFmB0+//kN/6N8mnjtOibjhld8wwcPLjDvgl8Bs3lofip2vHJXGOBiQHc
         CaCZqYxhZ4EZMlqnMbplPpFVgtvEoJPOQuXCykN9Y6wm5C1l4NBnp2XE4fM/lGfpZ+qo
         s8yAzYtnZy/pLP8wVPYThl2F8B6jrwaYoOLDT6h9QAlaqYV6UTDHu9FUb3xso+D1b6lB
         a+CvlZgprw93sMARn4WHXVi0ZmGRalBCdotPA3W5VS5qQbxeHoa+kSfDT+o+Pw1c9+ID
         3Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sLFdz/YLEOQnsrWkjcaI9mpQ2SxucOADkjSbMggLiKI=;
        b=YAH9tiKchc5TtxwHADabpxoiU26k9BrxRNgWb6gbqTVIxYImdmwpbygwg6hqtwhf6F
         VpTTgbvwwAqlnNdmpkUGNAE1HsaktinA1WJuKJ1RujyyRQcrVkT5FeEtSe0wYSxyEhXn
         W//PCsePcY1zw+7uAjuDxCntFpzJqH06/cjPw9j4Q2DzUuD2E9LNMFbt1Hj1eIQ7I2Qq
         0dBiiP4zREQdtEy8UvI9fnfAbX5aK4qreWxGQcqOjrt958/7y1ggHM/RfDHCll/k472v
         bcjyAdretmIeFFwO6k/0wBH9ljwEbzcJLZINu+ON26HlTazk7D0wIDfYvvEiBhUXvJPe
         9eKA==
X-Gm-Message-State: AOAM533jk93tSI+jBEvPgUDLII3bZulUJx/4dZ1AzGwRMEYEpLjQ2k+L
        fFYsySH4bOPo4FWGX8ZvOHbLPuseFQo=
X-Google-Smtp-Source: ABdhPJzwQXGqSihnGtxCGtldGtdptkgWCA+msk6JLh3Ei6D0v5ROd8jNSljxeWDyOcrsZJZJ2sC+dg==
X-Received: by 2002:aa7:8c0f:0:b029:1ed:4d05:218c with SMTP id c15-20020aa78c0f0000b02901ed4d05218cmr9977640pfd.21.1614956862793;
        Fri, 05 Mar 2021 07:07:42 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:42 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 16/41] KVM: PPC: Book3S HV P9: Move radix MMU switching instructions together
Date:   Sat,  6 Mar 2021 01:06:13 +1000
Message-Id: <20210305150638.2675513-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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

(XXX: isync / hwsync synchronisation TBD)

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 55 +++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f1230f9d98ba..b9cae42b9cd5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3449,12 +3449,38 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
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
+	mtspr(SPRN_LPID, lpid);
+	mtspr(SPRN_LPCR, lpcr);
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	mtspr(SPRN_PID, pid);
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
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
@@ -3477,12 +3503,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3517,7 +3543,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 	mtspr(SPRN_IC, vcpu->arch.ic);
-	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -3531,8 +3556,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
 	kvmppc_xive_push_vcpu(vcpu);
 
@@ -3571,7 +3595,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		mtspr(SPRN_DAWR1, host_dawr1);
 		mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
-	mtspr(SPRN_PID, host_pidr);
 
 	/*
 	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
@@ -3586,9 +3609,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
-	isync();
-
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
@@ -3605,7 +3625,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 
 	mtspr(SPRN_HDEC, 0x7fffffff);
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
 
 	return trap;
 }
@@ -4138,7 +4159,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvm_run *run = vcpu->run;
 	int trap, r, pcpu;
-	int srcu_idx, lpid;
+	int srcu_idx;
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -4212,13 +4233,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4237,11 +4251,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

