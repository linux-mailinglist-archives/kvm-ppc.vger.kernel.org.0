Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDAC5B35A8
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Sep 2019 09:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfIPHb1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Sep 2019 03:31:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37870 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfIPHb1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Sep 2019 03:31:27 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so19698214pfo.4
        for <kvm-ppc@vger.kernel.org>; Mon, 16 Sep 2019 00:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+hjIbMvVNpiR24rYPf4t5s8xy8oDgko+mpsefgX/OU=;
        b=II0xRlORondtrrl/EfdME2gwH/ag7I1ECLWaZOQlgX8FtrDYaehnWFXYk3jzwwjOVk
         TdLAq2hq/UJ6EQqUVfnAQrnZJMF6u6jBKKd9/qHHTq/gl3q1gpjjHqu2Z0X9j0Whq803
         5rIyRPmryZbzcaRPs5gWb+HPIvhM7DTd+9XVVUOMkbnx1qZ7QwkPw1xNUpO+RqpUPp2n
         NHSigwyFSSLg39BoCPvGW0+P9ha2qhxpnkRvZMQ/t5eItggaeYX5uVrLtEj3wil7iP23
         aXWeDrLfxcu0eH1BOhBLW6YYpTneGQx4gt13HgbylAZhtr+9Yv9mF7CuEwD7xCoa/fYP
         FWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+hjIbMvVNpiR24rYPf4t5s8xy8oDgko+mpsefgX/OU=;
        b=APXTti3xCCL+Qmi9W2ol2/i5thTm7EG4a6d0EiL/V4okNZX8gkB9p7lT/fFqUmNiic
         oIDHW2HHkE0PCXWfLayNm8syPHndiWtVgpuhvGYZCY0+Zz/Pyhi/JWM68CK/ifSTHgaM
         zbZ3l4Ac7LlTeFJI4SKENSG4c+y11e2tN3+LIp0fNffBgDDp2Opujg9wJczGvlqhszN2
         z7ws1kiZH8EuRuQAjzz2Xu8XDQOEXmbArPmCvy3XUGgmzP/O7hu2/Aq4UTOCQRVRWHE0
         TTZFqLw5TBEtXqiOCilB5wSe+JmXeeMUHz4C07U2oxOba1JXwez9FFCTe5AdjsiPy4xq
         LhkA==
X-Gm-Message-State: APjAAAXqCfs5YBNuZk0kRB9EjXxRPPEWYp6/mEzOHOd8Rzv3ejrd+bsg
        HyzYXBde2x+EHod4czRZq6LkXK7f
X-Google-Smtp-Source: APXvYqzdBsztaiAJevdKdUGaLuY+If6QCdzR0Hq+Q52D8npD6/tAh0w1reKjg01lyN80pSm/7qCHEw==
X-Received: by 2002:a65:4286:: with SMTP id j6mr13101871pgp.218.1568619086259;
        Mon, 16 Sep 2019 00:31:26 -0700 (PDT)
Received: from bobo.local0.net ([203.63.189.78])
        by smtp.gmail.com with ESMTPSA id 195sm12484964pfz.103.2019.09.16.00.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:31:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v2 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt for async guest delivery
Date:   Mon, 16 Sep 2019 17:31:06 +1000
Message-Id: <20190916073108.3256-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916073108.3256-1-npiggin@gmail.com>
References: <20190916073108.3256-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv_builtin.c | 68 ++++++++++++++++++++++------
 3 files changed, 57 insertions(+), 57 deletions(-)

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
index 0511c66d8bad..ed2eeda202b9 100644
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
@@ -2465,15 +2431,6 @@ static void kvmppc_set_timer(struct kvm_vcpu *vcpu)
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
index 7c1909657b55..47b44d9b5c1f 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -755,6 +755,57 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
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
+	kvmppc_end_cede(vcpu);
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
@@ -762,7 +813,6 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
 void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 {
 	int ext;
-	unsigned long vec = 0;
 	unsigned long lpcr;
 
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
@@ -774,26 +824,16 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 
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

