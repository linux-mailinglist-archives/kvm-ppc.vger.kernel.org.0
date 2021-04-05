Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D6C353AA9
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhDEBWA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhDEBV7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:59 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308FFC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:53 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id q5so7186346pfh.10
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7CRYSeLbLSFKCpaARUVAd/gYhdLsjf/87RHZe+ieXjk=;
        b=a4+R02ghC5IGcnLFxjva5NOWLMSCHlJhKR/N39h0/8CN7svlkQLAkcLFC34tHvOLab
         Jl0uEBf0zWLTPiazifbX75Zpyj2JTZNtJ7fJwBPBT78lq3aa9KkBQg9m9O0aJ5CQjumc
         UHx/1n4tHX/5Q+kdrDB2asKhqwr4P3kgKJwz6cGlWtGV87pjrf4biX0bfTfDIJGMGM99
         MNXuf0oyEPSbGLUe4cQqEzFVREgwBThgIWvPuxlbb+ytNhaDBDoas7OlqFZewIFLb/TZ
         oedBjSLklKMUb4T7AslqG5KaKPO+Zi6nuQ0IYGk3FMq9mCxKcHdBZGtctY6NNwHlFReP
         Larg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7CRYSeLbLSFKCpaARUVAd/gYhdLsjf/87RHZe+ieXjk=;
        b=UBLfNXsdd2NHrWOOkPSq4ZAvWCPSoDGlzUuH+ql8gLvm8rHEz7/P19KWMl+yyqoJtL
         /rgIMW5BHROC81cH1jpKEoqWE9gqZfR92TGAMmygZ127UoSrShDLhq+31rzM3MN1MFLM
         3oB+Cj2/yYmf+JfKuvRpVEuU279Iw5StkX/nZEQ3bZ0bbOK7HOqSRmc2M5xUw2Skq/wt
         FAIoOQRkgZ/xaDLNrVIff8/UuznVm77bW17yTlp+6LwYisOn2116WBGSr0WQeYbRJPYj
         X7y+SOPxj+9wa7Zx0Vx9Hw7UYl1rWMip20bES3ZV0AMdDmMHK4qDN6bUaVr6Qm6hDPod
         zTmQ==
X-Gm-Message-State: AOAM5335TM1ysnnxZkaRGF7DL08F4Qi2rghwMpUuGvoA/Swt1N3zBDoE
        XsTCv66NaGAG1hpCttitCsaeiPwFjD9Vuw==
X-Google-Smtp-Source: ABdhPJxqlZK8B9g43oq/0t2e1NVJIauqhsnsLNNk+8vld7hfWKA+uOT3ZaxvFEFX9owcVZ9FRTDY9Q==
X-Received: by 2002:aa7:8702:0:b029:200:50a8:2354 with SMTP id b2-20020aa787020000b029020050a82354mr21726128pfo.72.1617585712609;
        Sun, 04 Apr 2021 18:21:52 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 32/48] KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is 0
Date:   Mon,  5 Apr 2021 11:19:32 +1000
Message-Id: <20210405011948.675354-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

SRR0/1, DAR, DSISR must all be protected from machine check which can
clobber them. Ensure MSR[RI] is clear while they are live.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c           | 11 +++++++--
 arch/powerpc/kvm/book3s_hv_interrupt.c | 33 +++++++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv_ras.c       |  2 ++
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d6eecedaa5a5..5f0ac6567a06 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3567,11 +3567,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
 	mtspr(SPRN_WORT, vcpu->arch.wort);
 	mtspr(SPRN_TIDR, vcpu->arch.tid);
-	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
 
+	/*
+	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
+	 * clear (or hstate set appropriately to catch those registers
+	 * being clobbered if we take a MCE or SRESET), so those are done
+	 * later.
+	 */
+
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
@@ -3614,6 +3619,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			hvregs.vcpu_token = vcpu->vcpu_id;
 		}
 		hvregs.hdec_expiry = time_limit;
+		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
 					  __pa(&vcpu->arch.regs));
 		kvmhv_restore_hv_return_state(vcpu, &hvregs);
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 6fdd93936e16..e93d2a6456ff 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -132,6 +132,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	s64 hdec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
+	bool ri_set;
 	unsigned long msr = mfmsr();
 	int trap;
 	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
@@ -203,9 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
 	vcpu->arch.ceded = 0;
@@ -231,6 +229,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
+	__mtmsrd(0, 1); /* clear RI */
+
+	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
+	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
+	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
+
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
@@ -248,7 +253,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	/* 0x2 bit for HSRR is only used by PR and P7/8 HV paths, clear it */
 	trap = local_paca->kvm_hstate.scratch0 & ~0x2;
+
+	/* HSRR interrupts leave MSR[RI] unchanged, SRR interrupts clear it. */
+	ri_set = false;
 	if (likely(trap > BOOK3S_INTERRUPT_MACHINE_CHECK)) {
+		if (trap != BOOK3S_INTERRUPT_SYSCALL &&
+				(vcpu->arch.shregs.msr & MSR_RI))
+			ri_set = true;
 		exsave = local_paca->exgen;
 	} else if (trap == BOOK3S_INTERRUPT_SYSTEM_RESET) {
 		exsave = local_paca->exnmi;
@@ -258,6 +269,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.regs.gpr[1] = local_paca->kvm_hstate.scratch1;
 	vcpu->arch.regs.gpr[3] = local_paca->kvm_hstate.scratch2;
+
+	/*
+	 * Only set RI after reading machine check regs (DAR, DSISR, SRR0/1)
+	 * and hstate scratch (which we need to move into exsave to make
+	 * re-entrant vs SRESET/MCE)
+	 */
+	if (ri_set) {
+		if (unlikely(!(mfmsr() & MSR_RI))) {
+			__mtmsrd(MSR_RI, 1);
+			WARN_ON_ONCE(1);
+		}
+	} else {
+		WARN_ON_ONCE(mfmsr() & MSR_RI);
+		__mtmsrd(MSR_RI, 1);
+	}
+
 	vcpu->arch.regs.gpr[9] = exsave[EX_R9/sizeof(u64)];
 	vcpu->arch.regs.gpr[10] = exsave[EX_R10/sizeof(u64)];
 	vcpu->arch.regs.gpr[11] = exsave[EX_R11/sizeof(u64)];
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6..8d8a4d5f0b55 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -199,6 +199,8 @@ static void kvmppc_tb_resync_done(void)
  * know about the exact state of the TB value. Resync TB call will
  * restore TB to host timebase.
  *
+ * This could use the new OPAL_HANDLE_HMI2 to avoid resyncing TB every time.
+ *
  * Things to consider:
  * - On TB error, HMI interrupt is reported on all the threads of the core
  *   that has encountered TB error irrespective of split-core mode.
-- 
2.23.0

