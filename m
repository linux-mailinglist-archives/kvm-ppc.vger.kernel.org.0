Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2F5351A29
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDAR63 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbhDARzR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:55:17 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEF5C0F26EB
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j25so1685129pfe.2
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJ6ODLaZGRZoX5kuCv+hNtwVVZa1NGvMNfJW5zA4O7A=;
        b=iikpg7mDbDxjtkGTwR2l23dgVyvnP83v2npfxqSqxXxR0I030FVUCMl7AMB3m/12k3
         WY94cw/lVvfrZltNPqu5aL3ISWgQTdNkjgVqMjI+NeNmE6YqejA6lvpkQckKNOeTWwsL
         NZgzOEAXn/2fMpnXEnmeUQYpYe7ZJ/ms9OD6JakgQjyFp8tjUOzzZwXQzxH9+kwYYuec
         sD9JWhsOhaHWMAPuScwNKhfxI7nsm7gKGoTD4SQifHBOBAtN3tgawKeMmo7CFho+AatL
         TLjN/UXY4fHqbcF/r9QjY/N79t1VpGUb1Vg97yDeE5UJ1PAErAYUgdHUsgdqimIFWr2N
         OHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJ6ODLaZGRZoX5kuCv+hNtwVVZa1NGvMNfJW5zA4O7A=;
        b=Paavd5RSc4aE8KTfiuSfsrLeFNOw8jLrWCD8pNVCihzCJIEkaOGBxV4P9qrRCPd7b8
         mXxScHdJhT3Fxpn3Ab+6uzfFNeAlwXELdFuUQ9UqGaCdtzV9epeqLj2R8tO37fLFKkJt
         B9JJVrEDq70Z9i05Mc4AW6IBJqI6M00BDMyEHxDjmnGZOL9nj9jeNeZoIxcX5XXZxw3x
         6yW7X93f6zOQNuw/mL/rwpypOJqO03+AP5X8PAOpsLtR0/bTtxSR38MJE8c08rcmjmbT
         8ieMnNVj9QgVWJ70LiLTgun5RamJ8Rcyymj5d2SCBJsPrOa9mc7LyMDVJQN5WT+y6oXY
         9ncg==
X-Gm-Message-State: AOAM530EhcbR0Br0lfaOe9nV5AOXFiIL1xIMB7LLiNICgOsJ+YHcwUWs
        FUmQkqTxIEy3XNfNIwdns1M9T7AQQuM=
X-Google-Smtp-Source: ABdhPJxyg0ht3ST9gyMCzjw17TOW8pziZ1khTMC0PZNQ1+DSNlelDyUCvc/BErEmUqFpcyBPZatqIw==
X-Received: by 2002:a62:f244:0:b029:1f8:40aa:8d64 with SMTP id y4-20020a62f2440000b02901f840aa8d64mr7884644pfl.81.1617289479850;
        Thu, 01 Apr 2021 08:04:39 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 20/48] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Fri,  2 Apr 2021 01:02:57 +1000
Message-Id: <20210401150325.442125-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is more symmetric with kvmppc_xive_push_vcpu. The extra test in
the asm will go away in a later change.

Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
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
index 3424b1bfa98e..6ca47f26a397 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3605,6 +3605,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
index e7219b6f5f9a..741bf1f4387a 100644
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
+	 * Should not have been pushed if there is no tima
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

