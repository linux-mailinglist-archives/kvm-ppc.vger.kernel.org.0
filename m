Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F4F32EDD3
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCEPIN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhCEPHr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DD3C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:46 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c16so1570723ply.0
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AYuBF+67WIol7LJHmt9SQa+1tqP08ymEufpZ3xaiHjY=;
        b=dNgVLrdtMdPNgRBHWjERCZXDyWhQOsTXKJhHZcKJQGinMDkJ5Sd0ZAfEQuGFxzKO6L
         ++7O5kVOkP6zSMhujCN4V+8pGC1UTtAjbmiNUz7XuU2GNWnigTQsMK2s7D9UAtKMfoe6
         RfBAgbKfjfXVUHlQxK+fJ2HfqXJflLPLyU305lyyDmtWqH9/bMlw1J7xQ42YN5ZU+GLG
         mZAnrEFlUYPJE8pDITe4LAbZEzwt4QPlPwihdDIIz8kzt5FIHtvWSaBPc0Bj0+ZEJUhs
         pVv2g4McHJmy56/Eml39VscQ/1ynJMzhhwo0owUdeiE53R/yj2DuAQhONXYRrZiA5hFL
         Ul5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AYuBF+67WIol7LJHmt9SQa+1tqP08ymEufpZ3xaiHjY=;
        b=GPSTtaGnTxn0sg4/Knw+LVSI6Y8nRjp9OjWSVrxWdEYRJTCEoIP+v4IGvEi0gjhBfg
         750fx5hmZSrFlgiI2DwfIhXha5MauNsKkwMKO0W0keu7G5lw8e/Im6Nk07kJnG9NA+ve
         gMBx5qDpV78gM3iRErZprT0Ybxrui/rkYm3HkmY3IxqF4UAR1wcaSjIwvPl7gK+0VmyR
         FnZHY7kEAfOySrw/5fFM06ajosm3lcTlb6e4g487edX/oISoWzHeuLD2X+XRB0ey1tVp
         VG/JyPzMDiIo/Z5uW/F3RWFsmFhN6+qrSXLvEQs8kCNyzYZy29OxopJHHmMx+J/Clb1O
         J1Nw==
X-Gm-Message-State: AOAM531oZSl+lfrzaPOWTvfKFkAf4zt9oVyDkwXJ9j+T7dzle0s6UaXG
        DKs7mJnz6yXpDGWSzr3fhlKOZg0uoZI=
X-Google-Smtp-Source: ABdhPJz9yqrdJfqfv0U7PQBrnSx/rAhq5pkEY0VhxWHhrn6vkcp+U/F+Sr0lqdlw5+mIOMhPJPXjJA==
X-Received: by 2002:a17:902:8c97:b029:e2:8c58:153f with SMTP id t23-20020a1709028c97b02900e28c58153fmr8990916plo.79.1614956866030;
        Fri, 05 Mar 2021 07:07:46 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:45 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 17/41] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Sat,  6 Mar 2021 01:06:14 +1000
Message-Id: <20210305150638.2675513-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_xive.c          | 31 +++++++++++++++++++++++++
 4 files changed, 40 insertions(+)

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
index b9cae42b9cd5..b265522fc467 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3565,6 +3565,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
index e7219b6f5f9a..52cdb9e2660a 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -127,6 +127,37 @@ void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu)
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

