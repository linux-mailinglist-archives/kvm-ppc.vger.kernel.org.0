Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7838BC4752
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfJBGA7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:00:59 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:42023 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJBGA7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:00:59 -0400
Received: by mail-pl1-f181.google.com with SMTP id e5so6650343pls.9
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLrNTstP2vuMPY1gkgT7U4JkTKWsj3htw1ad+yH6Y2s=;
        b=pcEV5/FQg2oXJGDbEUMbzZLBAjJeCYvbOzrDx0EXvRGT3u5YPw5Rqf1Pi46gRqsICe
         LnMo9xEsuIUOPwEmXJZU1kSYf8dRAQ4F7Bje0iHGhEz9g1N2JWvxHsZb5/aQOkTSNfhA
         jsdnrMpXtKPtcmHbgKFDKaLknRIVyL0Gj4qiyg7pPBZLzBTg00V/LoJ+cwdaEPwIJObp
         HIYxOHkMRvw4FfXWHqSkG4ch6bnQDrVmuNMYKFWjAI7cTlDp+xXje316/qXVVZw0nRok
         mVmPVXKaLXFBwW7ims52dJacz3J0vipKWQ+4Gvf58e5OIVqhdeggDkrtdyjCRt2Am0Wd
         8Gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLrNTstP2vuMPY1gkgT7U4JkTKWsj3htw1ad+yH6Y2s=;
        b=EL1pisrhGhiBuhzYF/GPZpyFeiczbXwREwBbqNNlr3rX869OhPFDB8Xc7KPoS98PIz
         rQDJbD8gSSgELFqbhzHvJjIVBY5ceuKYYEt/E1Vw8gLL+LjsloRDukTIa1VzYVPlKihT
         0O7RnxOiCE0HpboFpqQ+NEJcljT2yx2bV/hyfjIvpVVS2+rlGUYLABlWyPtapOE/jekJ
         D9PVovkr586mkJDuR5Xr/7scJAf2vMJOXXv6ghLkxadkErROi8jW3KSICYM8uImcoATE
         0ICEKmF1O++PiU8tt+FobrfG4Fs1TUdz/MwbxuHskvrzFaTGD8YSqgkgs/505B1wuYuh
         +WHw==
X-Gm-Message-State: APjAAAW7HtTh/BEh5Q5K0Biqo955UHGUNI1faO2pzzQU5ka+doS5yeAb
        i2Y2fxnh3YavYR8z1OqowRX7SIT3
X-Google-Smtp-Source: APXvYqxelb/cjDI/iwbV1QThhJSfRVGFhd+9ccRt2HXhQatYS+4vBIoB2DKf4EC8Gn79S+belx1u2A==
X-Received: by 2002:a17:902:bc47:: with SMTP id t7mr1823637plz.269.1569996057716;
        Tue, 01 Oct 2019 23:00:57 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:00:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt for async guest delivery
Date:   Wed,  2 Oct 2019 16:00:23 +1000
Message-Id: <20191002060025.11644-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002060025.11644-1-npiggin@gmail.com>
References: <20191002060025.11644-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This consolidates the HV interrupt delivery logic into one place.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s.h            |  3 ++
 arch/powerpc/kvm/book3s_hv.c         | 43 ------------------
 arch/powerpc/kvm/book3s_hv_builtin.c | 67 ++++++++++++++++++++++------
 3 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.h b/arch/powerpc/kvm/book3s.h
index 2ef1311a2a13..3a4613985949 100644
--- a/arch/powerpc/kvm/book3s.h
+++ b/arch/powerpc/kvm/book3s.h
@@ -32,4 +32,7 @@ extern void kvmppc_emulate_tabort(struct kvm_vcpu *vcpu, int ra_val);
 static inline void kvmppc_emulate_tabort(struct kvm_vcpu *vcpu, int ra_val) {}
 #endif
 
+extern void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr);
+extern void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags);
+
 #endif
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 94a0a9911b27..c340d416dce3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -133,7 +133,6 @@ static inline bool nesting_enabled(struct kvm *kvm)
 /* If set, the threads on each CPU core have to be in the same MMU mode */
 static bool no_mixing_hpt_and_radix;
 
-static void kvmppc_end_cede(struct kvm_vcpu *vcpu);
 static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu);
 
 /*
@@ -338,39 +337,6 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
 	spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
 }
 
-static void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
-{
-	unsigned long msr, pc, new_msr, new_pc;
-
-	msr = kvmppc_get_msr(vcpu);
-	pc = kvmppc_get_pc(vcpu);
-	new_msr = vcpu->arch.intr_msr;
-	new_pc = vec;
-
-	/* If transactional, change to suspend mode on IRQ delivery */
-	if (MSR_TM_TRANSACTIONAL(msr))
-		new_msr |= MSR_TS_S;
-	else
-		new_msr |= msr & MSR_TS_MASK;
-
-	kvmppc_set_srr0(vcpu, pc);
-	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
-	kvmppc_set_pc(vcpu, new_pc);
-	kvmppc_set_msr(vcpu, new_msr);
-}
-
-static void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
-{
-	/*
-	 * Check for illegal transactional state bit combination
-	 * and if we find it, force the TS field to a safe state.
-	 */
-	if ((msr & MSR_TS_MASK) == MSR_TS_MASK)
-		msr &= ~MSR_TS_MASK;
-	vcpu->arch.shregs.msr = msr;
-	kvmppc_end_cede(vcpu);
-}
-
 static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
 {
 	vcpu->arch.pvr = pvr;
@@ -2475,15 +2441,6 @@ static void kvmppc_set_timer(struct kvm_vcpu *vcpu)
 	vcpu->arch.timer_running = 1;
 }
 
-static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.ceded = 0;
-	if (vcpu->arch.timer_running) {
-		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);
-		vcpu->arch.timer_running = 0;
-	}
-}
-
 extern int __kvmppc_vcore_entry(void);
 
 static void kvmppc_remove_runnable(struct kvmppc_vcore *vc,
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7c1909657b55..068bee941a71 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -755,6 +755,56 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
 	local_paca->kvm_hstate.kvm_split_mode = NULL;
 }
 
+static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.ceded = 0;
+	if (vcpu->arch.timer_running) {
+		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);
+		vcpu->arch.timer_running = 0;
+	}
+}
+
+void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
+{
+	/*
+	 * Check for illegal transactional state bit combination
+	 * and if we find it, force the TS field to a safe state.
+	 */
+	if ((msr & MSR_TS_MASK) == MSR_TS_MASK)
+		msr &= ~MSR_TS_MASK;
+	vcpu->arch.shregs.msr = msr;
+	kvmppc_end_cede(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvmppc_set_msr_hv);
+
+static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
+{
+	unsigned long msr, pc, new_msr, new_pc;
+
+	msr = kvmppc_get_msr(vcpu);
+	pc = kvmppc_get_pc(vcpu);
+	new_msr = vcpu->arch.intr_msr;
+	new_pc = vec;
+
+	/* If transactional, change to suspend mode on IRQ delivery */
+	if (MSR_TM_TRANSACTIONAL(msr))
+		new_msr |= MSR_TS_S;
+	else
+		new_msr |= msr & MSR_TS_MASK;
+
+	kvmppc_set_srr0(vcpu, pc);
+	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
+	kvmppc_set_pc(vcpu, new_pc);
+	vcpu->arch.shregs.msr = new_msr;
+}
+
+void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
+{
+	inject_interrupt(vcpu, vec, srr1_flags);
+	kvmppc_end_cede(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvmppc_inject_interrupt_hv);
+
 /*
  * Is there a PRIV_DOORBELL pending for the guest (on POWER9)?
  * Can we inject a Decrementer or a External interrupt?
@@ -762,7 +812,6 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
 void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 {
 	int ext;
-	unsigned long vec = 0;
 	unsigned long lpcr;
 
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
@@ -774,26 +823,16 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.shregs.msr & MSR_EE) {
 		if (ext) {
-			vec = BOOK3S_INTERRUPT_EXTERNAL;
+			inject_interrupt(vcpu, BOOK3S_INTERRUPT_EXTERNAL, 0);
 		} else {
 			long int dec = mfspr(SPRN_DEC);
 			if (!(lpcr & LPCR_LD))
 				dec = (int) dec;
 			if (dec < 0)
-				vec = BOOK3S_INTERRUPT_DECREMENTER;
+				inject_interrupt(vcpu,
+					BOOK3S_INTERRUPT_DECREMENTER, 0);
 		}
 	}
-	if (vec) {
-		unsigned long msr, old_msr = vcpu->arch.shregs.msr;
-
-		kvmppc_set_srr0(vcpu, kvmppc_get_pc(vcpu));
-		kvmppc_set_srr1(vcpu, old_msr);
-		kvmppc_set_pc(vcpu, vec);
-		msr = vcpu->arch.intr_msr;
-		if (MSR_TM_ACTIVE(old_msr))
-			msr |= MSR_TS_S;
-		vcpu->arch.shregs.msr = msr;
-	}
 
 	if (vcpu->arch.doorbell_request) {
 		mtspr(SPRN_DPDES, 1);
-- 
2.23.0

