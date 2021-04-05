Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D11353A9B
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhDEBVT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhDEBVS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C213C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so5074397pjv.1
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJ6ODLaZGRZoX5kuCv+hNtwVVZa1NGvMNfJW5zA4O7A=;
        b=tnf57h3hsYSAPnNoIVDX0DRnOFYV1zcFOYHbsShspfQ1OXRzvw6Cx0p5hn91bFEwuL
         jQkeo79AtuCmMr5eIxTRgO5a86edi3F2rjTi/b1lsy6klNLup8OcUcVTvcjW8+eAl73Y
         Vcu3AGuVKqJqsjyI9zXvgJvjjRWRGdpVkjpGKCOn5giuqzRzO/MsAM7vUrNBIn3pTrA8
         Q350EFaEhPTWBQ2Ta5TU7B8Jx53/K4rdWhSnEIdtHxJcViIZPd26R7/d/HeWsNOmFn8r
         MvX5wjCqCqFCh25kvxdSsoervBlE5s6reuzgQNC7ER8ABBC2EpmNMxsZld2e0nfOSGx5
         C8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJ6ODLaZGRZoX5kuCv+hNtwVVZa1NGvMNfJW5zA4O7A=;
        b=Yfv6NTsgxg84HD0uttwsvzJeT07txhdu55L72kheVQ5gueJfbHwqC1HHfzw8O+jrA3
         IQgBwOGLq45tE2sJ7w+m+vpk/2Va5zz9THdJW7XQxd93QTHxSHBTpUA02083ti4zPDds
         y/CWspLx+asPBY6jjRa7KtOGlX3Jp9J2FJOJh2HXfo9OlVSQstPhah5F7oH0NMj5TYse
         NPPfx4ZPSFdpAt1KB6PYl45JufoR39FiEnXpkp21X6jv3yQ0ECbAbD5+v3W+0gDVbeE8
         mUA4KqSHqlbQaY6iTgIvIckpLoEnxuJu47BhryYVTNVshmBn56PaIT2yNMyBiOp74Yvz
         1juA==
X-Gm-Message-State: AOAM5315O7uxLzRfwT7Ou8T0vEvZeEHSn+5rziV7ducYg7Wn3rBhmDtl
        w0dXZdH4mbudoM9FcnYVgGnbXf0bWzg2MQ==
X-Google-Smtp-Source: ABdhPJwqhx+v1wv801r8ZoWRW5tqE3CVkxURxTh6TXVJm/2NlVOoco3OJeN4roQWCu0HQumw+yjBqg==
X-Received: by 2002:a17:902:9a0a:b029:e6:bf00:8a36 with SMTP id v10-20020a1709029a0ab02900e6bf008a36mr22035803plp.51.1617585672919;
        Sun, 04 Apr 2021 18:21:12 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 20/48] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Mon,  5 Apr 2021 11:19:20 +1000
Message-Id: <20210405011948.675354-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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

