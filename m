Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B810C3250CC
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBYNsl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhBYNsk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:40 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51472C06174A
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so400634plh.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lclwaLxX2NLn9E/+rl7sv8a7z7kaIpmV7064pmVpvB8=;
        b=FH2lfXzV0haQmWcjE+qg0irxB/IKAqQDAmv9zDDCskGxihsrFLZBqeIm0xd/jWOj/7
         LkbgHpQM0bAMkEYKWhS4TPsaVxEsgXVTRuWbrYX6/BJOdvdWMErBvVQVP/z5B3aJ+XMo
         4rXmyDzJKWls9fxZqN0OFROkLIjjc2ObguxyzmhHo7WtrOl/iqZSz9GPbMtdbB4O7db0
         xU1575FdbEabAqJFwPeHffxmw3ErzR3kbb5jDPmdf+hruHg22nCqyCI18FB+zfWAK431
         PEXC5h/CtAG3fkBF4IjHjFpCTcmD2MKxJ0Mt1svFCAZI9cfl1yt/huEZxejuUF1ClAR6
         BRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lclwaLxX2NLn9E/+rl7sv8a7z7kaIpmV7064pmVpvB8=;
        b=KogDB6cBYPO6mMCrFDqIKA9/Omf23ZB7r8mxXJx/8qfXEgNhisuHkUW/gXG9A5iy+Z
         qPKV60kDiTna9t6wXJvHKuDa2DDQKgPKCYKq1c4Nx4aQP1qfKzMRfi5yMHChtuzYQ/kA
         fbTI1uTlN7jYcO5XBaQ6WXJVs1kdKVSOcSRQEgXU3/ywwxwwMpUkntfSF8gvZp5/JV2y
         s8WEL47U1EU6Mx6mXICHNCMua20nMF53RkWAYlJVsLkBCkMLBMqr+wqQwhtJ9r5dh3L8
         t+uvWTsKC9l82aMyympscjQYGUtr3/8+CTDhtPq3oNjg8imC/nxsuTeuWmEWYJs2B7KZ
         y1Pg==
X-Gm-Message-State: AOAM533U1MQSPs2hMQ7HwjGpMFcFG7ARADFKRD+/BFHDaC4mu/Ga3DkC
        HnOYhW8mXzN66xy0lCVLYvl6tpwOZSY=
X-Google-Smtp-Source: ABdhPJyotqTRpIhZJOOVk4kAb+HujsJoUqRA3pV56bKCrgBWFWuguD3FK4Ps+mw7GANorVgLvl5bWg==
X-Received: by 2002:a17:90a:9909:: with SMTP id b9mr3257736pjp.46.1614260872441;
        Thu, 25 Feb 2021 05:47:52 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:51 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 14/37] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Thu, 25 Feb 2021 23:46:29 +1000
Message-Id: <20210225134652.2127648-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is more symmetric with kvmppc_xive_push_vcpu. The extra test in
the asm will go away in a later change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h      |  2 ++
 arch/powerpc/kvm/book3s_hv.c            |  2 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 ++++
 arch/powerpc/kvm/book3s_xive.c          | 34 +++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 9531b1c1b190..73b1ca5a6471 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -672,6 +672,7 @@ extern int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
 extern int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
 			       int level, bool line_status);
 extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
+extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 {
@@ -712,6 +713,7 @@ static inline int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval) { retur
 static inline int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
 				      int level, bool line_status) { return -ENODEV; }
 static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
+static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 	{ return 0; }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 23d6dc04b0e9..e3344d58537d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3556,6 +3556,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
+	kvmppc_xive_pull_vcpu(vcpu);
+
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 75405ef53238..c11597f815e4 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1442,6 +1442,11 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	bl	kvmhv_accumulate_time
 #endif
 #ifdef CONFIG_KVM_XICS
+	/* If we came in through the P9 short path, xive pull is done in C */
+	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
+	cmpwi	r0, 0
+	bne	1f
+
 	/* We are exiting, pull the VP from the XIVE */
 	lbz	r0, VCPU_XIVE_PUSHED(r9)
 	cmpwi	cr0, r0, 0
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index e7219b6f5f9a..8632fb998a55 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -127,6 +127,40 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_xive_push_vcpu);
 
+/*
+ * Pull a vcpu's context from the XIVE on guest exit.
+ * This assumes we are in virtual mode (MMU on)
+ */
+void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
+{
+	void __iomem *tima = local_paca->kvm_hstate.xive_tima_virt;
+
+	BUG_ON(!(mfmsr() & MSR_IR));
+	BUG_ON(!(mfmsr() & MSR_DR));
+
+	if (!vcpu->arch.xive_pushed)
+		return;
+
+	/*
+	 * Sould not have been pushed if there is no tima
+	 */
+	if (WARN_ON(!tima))
+		return;
+
+	eieio();
+	/* First load to pull the context, we ignore the value */
+	__raw_readl(tima + TM_SPC_PULL_OS_CTX);
+	/* Second load to recover the context state (Words 0 and 1) */
+	vcpu->arch.xive_saved_state.w01 = __raw_readq(tima + TM_QW1_OS);
+
+	/* Fixup some of the state for the next load */
+	vcpu->arch.xive_saved_state.lsmfb = 0;
+	vcpu->arch.xive_saved_state.ack = 0xff;
+	vcpu->arch.xive_pushed = 0;
+	eieio();
+}
+EXPORT_SYMBOL_GPL(kvmppc_xive_pull_vcpu);
+
 /*
  * This is a simple trigger for a generic XIVE IRQ. This must
  * only be called for interrupts that support a trigger page
-- 
2.23.0

