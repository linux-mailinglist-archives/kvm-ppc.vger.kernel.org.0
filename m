Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1596E2299E
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 02:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfETA57 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 May 2019 20:57:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44257 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfETA57 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 May 2019 20:57:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id c5so5859551pll.11
        for <kvm-ppc@vger.kernel.org>; Sun, 19 May 2019 17:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xold/ArW4eKLPf03nisTh8LtaLYD6tlkUGy17QsKnXI=;
        b=pJzr/jJR8M4grsfllQzYZbxJFeeDS2UA1YglfDpF/9SLILS3hGtE3/KkxvcV1/2iF0
         X2GzevLhGcgbJO21Ri+NYC5Q0VCj+cqLXxqwh2RrMzBeDlc4UAOjwDUszNzhHvrQ/mDI
         B6fhbIF4kqsGY5o8xdo9nSkjh0hQxE4cwertdOnkHO6yNG94Ni7fPGGAx5X/LzMzDqqx
         Uhrd0oR+4uqVXW7wgNaJyn3KPlB3eXupzRLqBZsDgICIznVJHiMMbs4AWWoKntzoHJ/v
         /eEQrN9bppIXrhtBphWz8sfcOnEUYngW4XoLQbjJcagF0YE30O0tJC4KNollGg7g+mKp
         48CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xold/ArW4eKLPf03nisTh8LtaLYD6tlkUGy17QsKnXI=;
        b=sGu1wRvLzW9tlXxhNitsHLRsJm5USWiyelmDFq74Kh9S80xUxR9CxFRQ1CIvnz62PB
         ketG+BqzXy+NLJgXXeMU3pGVxSp3WW+YzpirtgslOVvJl6yi5vNC+5OjaEGRVxfb9de6
         wm7ZLthiB9+CoeZsLgO+WdYEauw/UIg0VIot9wOn8caWVtYNq/yz+gj541ZXcI9gc+/n
         n46/r2rZyh7Cbt7EH/1RzaFQ7/8HQJD5H1wx/ddS+XAy54DUpCqylaBPADfubLyMkeZ0
         tUXPuQe0+UEwdIV0ZI9mdSUnzsT9FHQSYIN1ZbF+NTQJw+KvAK6bQd9lnEYEr7eKzqOg
         G7BQ==
X-Gm-Message-State: APjAAAUXs+ujDsdn56OeYorwnw7dfBr2vhi8kPlmr3dAslzJx1NzDjqv
        GRAdEHdL0qWByhVbPUDJ6miQxkAF
X-Google-Smtp-Source: APXvYqzvg0hZSoEuGQtAD/1uEyWtNbtjvNipx/HlrdXYde0GW07TJE3X8Zc3y4xcyHVbqo3pAoSReA==
X-Received: by 2002:a17:902:5998:: with SMTP id p24mr56385827pli.9.1558313878594;
        Sun, 19 May 2019 17:57:58 -0700 (PDT)
Received: from bobo.local0.net (193-116-79-244.tpgi.com.au. [193.116.79.244])
        by smtp.gmail.com with ESMTPSA id q193sm22643371pfc.52.2019.05.19.17.57.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:57:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt for async guest delivery
Date:   Mon, 20 May 2019 10:56:57 +1000
Message-Id: <20190520005659.18628-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520005659.18628-1-npiggin@gmail.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s.h            |  3 ++
 arch/powerpc/kvm/book3s_hv.c         | 45 -------------------
 arch/powerpc/kvm/book3s_hv_builtin.c | 65 ++++++++++++++++++++++------
 3 files changed, 54 insertions(+), 59 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.h b/arch/powerpc/kvm/book3s.h
index 14ef03501d21..ce7360f4e784 100644
--- a/arch/powerpc/kvm/book3s.h
+++ b/arch/powerpc/kvm/book3s.h
@@ -37,4 +37,7 @@ extern void kvmppc_emulate_tabort(struct kvm_vcpu *vcpu, int ra_val);
 static inline void kvmppc_emulate_tabort(struct kvm_vcpu *vcpu, int ra_val) {}
 #endif
 
+extern void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr);
+extern void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags);
+
 #endif
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 46015d2e09e0..36d16740748a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -136,7 +136,6 @@ static inline bool nesting_enabled(struct kvm *kvm)
 /* If set, the threads on each CPU core have to be in the same MMU mode */
 static bool no_mixing_hpt_and_radix;
 
-static void kvmppc_end_cede(struct kvm_vcpu *vcpu);
 static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu);
 
 /*
@@ -341,41 +340,6 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
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
-#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-	/* If transactional, change to suspend mode on IRQ delivery */
-	if (MSR_TM_TRANSACTIONAL(msr))
-		new_msr |= MSR_TS_S;
-	else
-		new_msr |= msr & MSR_TS_MASK;
-#endif
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
@@ -2471,15 +2435,6 @@ static void kvmppc_set_timer(struct kvm_vcpu *vcpu)
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
index 6035d24f1d1d..5ae7f8359368 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -758,6 +758,53 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
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
+void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
+{
+	unsigned long msr, pc, new_msr, new_pc;
+
+	msr = kvmppc_get_msr(vcpu);
+	pc = kvmppc_get_pc(vcpu);
+	new_msr = vcpu->arch.intr_msr;
+	new_pc = vec;
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	/* If transactional, change to suspend mode on IRQ delivery */
+	if (MSR_TM_TRANSACTIONAL(msr))
+		new_msr |= MSR_TS_S;
+	else
+		new_msr |= msr & MSR_TS_MASK;
+#endif
+
+	kvmppc_set_srr0(vcpu, pc);
+	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
+	kvmppc_set_pc(vcpu, new_pc);
+	vcpu->arch.shregs.msr = new_msr;
+	kvmppc_end_cede(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvmppc_inject_interrupt_hv);
+
 /*
  * Is there a PRIV_DOORBELL pending for the guest (on POWER9)?
  * Can we inject a Decrementer or a External interrupt?
@@ -765,7 +812,6 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
 void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 {
 	int ext;
-	unsigned long vec = 0;
 	unsigned long lpcr;
 
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
@@ -777,26 +823,17 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.shregs.msr & MSR_EE) {
 		if (ext) {
-			vec = BOOK3S_INTERRUPT_EXTERNAL;
+			kvmppc_inject_interrupt_hv(vcpu,
+					BOOK3S_INTERRUPT_EXTERNAL, 0);
 		} else {
 			long int dec = mfspr(SPRN_DEC);
 			if (!(lpcr & LPCR_LD))
 				dec = (int) dec;
 			if (dec < 0)
-				vec = BOOK3S_INTERRUPT_DECREMENTER;
+				kvmppc_inject_interrupt_hv(vcpu,
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
2.20.1

