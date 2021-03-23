Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F37345481
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCWBEt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhCWBEU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E2BC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so9382743pjg.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IR3GhWt1mO5fe4fnj7KLAK+qUSflz6Bfdz855FHq+iU=;
        b=E7i78OaQx1xtwSphA1iw3B69jGPIBJXyPwRD6q660Wq9vBoLimC3y1JbHJDldfJ6UB
         A08pJsY+R1UoRzTTCGa9y6eZ9Uw5OYahFuJuukjs9vfRfIhAZAgCx2deSnDUfKzDSQes
         iAhdwAkYTmYKalOm6+9ZuUOuFRLlgmPRj53Co9rYeBiERENWWccqjC5kUuv9B881puiH
         /mvLkmveAbRjDr+oFCLMAN75u73e489+uMmbja5t6sKRDkaJHKi41MIv4mnMNK6PkJy4
         5EN0qBGpvR8uqXouJndAUkdMepnDAFP8JcBT5RDZrjhhMSRoJ7FwCuJs8RuGqYBG4sXa
         k2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IR3GhWt1mO5fe4fnj7KLAK+qUSflz6Bfdz855FHq+iU=;
        b=s5WfpOHLGJlJgma+Lb+sneXJuudx3n+FReikRTT0K0tsZ2LuCiutz0QUKWq45cJtI/
         vvVu69wP6ZHXZbrYdffoMd4O/Z7qIh+zIMv1/ngY2eIFVhFYYAYQdvbEsmcpx3mMk05F
         TZ2VERMxVgyYRArMgDXwLkPDiYQKriNyN6Dba7VMpAZgk0w19AHl9il3V2ot8HrDfhNH
         O7F2X1ANhSAjL1dyVe7svVfRY/SoTuuTms5n7PudhLRoKBvHglJBOblzVefSfaEj3Df2
         cVKHGKW6miwjVfjO/ZYwjZkPHiD7hySDF+CtcReSFPx2O3lz2fwiCWw+n0OmHROoa/VS
         eSCg==
X-Gm-Message-State: AOAM5338hQdHo3dKOF6ezOPPOMBf/1pxA+vJu8wZDDfE3Ui2pFREKVXr
        Qz7oScNAOtCYYiEydQtctGptPnKAyPc=
X-Google-Smtp-Source: ABdhPJzW0T2/GmLNd3u7e2/HQDuRUvIsB56BXkusGmMDZXDkTgX1TPCW9IQu3sz1WOABYKyzM/sCvg==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr1735510pjn.151.1616461459786;
        Mon, 22 Mar 2021 18:04:19 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 20/46] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Tue, 23 Mar 2021 11:02:39 +1000
Message-Id: <20210323010305.1045293-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index b822c573dc08..d28fb76b08e1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3599,6 +3599,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

