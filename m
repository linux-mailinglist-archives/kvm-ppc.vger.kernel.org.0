Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E435E038
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344661AbhDMNid (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 13 Apr 2021 09:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhDMNic (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 13 Apr 2021 09:38:32 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593D7C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:38:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id z16so11940158pga.1
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L3zviddbu4FywH3tQoKCEQUjQPPIAzmC3fAfOKoQjFA=;
        b=ZDeoC+Y0JLX7bPSKxVFW0YyXw/Mp0DkHYYuy9uVP2MrS6HwCqKFJirTYwlQ2t+e0tZ
         gj8buA/xjd8UZ8r7SE6S15FeIwyPQ4wG4iyujy7fEU9fvQU2FV2BKACEsjZBL8Idvy5I
         mXF7rv1wC4z992x2BQlPS5JxDDmjFC9JShQVVj49pcB4A2S6Gz1ppXp0OoqPbH9ci5k1
         /+N7O2y4lpE420TDIu/ibx3NRK/zD26ndRwBK26AQRVaID2LtMtA8vnAx3TIsV5Lz2rl
         Ne614cOoUwALCUvuYj4TO41Py96p3sL1QG0Ro/G6D41Nu7BU9tnADb5Bxk62dC72nvSd
         N9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L3zviddbu4FywH3tQoKCEQUjQPPIAzmC3fAfOKoQjFA=;
        b=n13NJPpn5/SSphbi2QC/CiWBt9ZlU4vrij8gP4bDROpRqZBW9h222wJUxO4LmqD/wq
         IQYnvFVFAlzmfk+io6jNYVMM/qUv0VWPEJoOJrnYCrH63vhQF+W5DxCjWCgxcydr9rg1
         t6nyexBD1GNZcXAT2lOd1Ib2QI52wU4WhjRYVJXscScoiw06wZ8sZUJ9T6KQm8ogU+cQ
         Z83IuvyPJG38RoTHplpzsCfZzKPHuuSIZuM8Soa3fYRRomeB4eHxR6maA+xKnCIA2oEb
         LQcrKAujBEd8vmybWvmSSeCAVhjDaQ3QCZ2s9y5QCpVP4qS5S6PeR2Ztv8YsssBnZFTc
         78uw==
X-Gm-Message-State: AOAM5309lcWf8ck96vPaRJCyZLcUdOYjAw6RXTvH+8q4z3LSH3O3ERdY
        FTRV7xTth5daCjFLEPoo7s1XworhShs=
X-Google-Smtp-Source: ABdhPJy41gB5ttRaa/37YrBy3uHBItjiUYbJAj8D83EqGrt34H4aaj5PKGhIXVqPpiGklIDfxwT9aw==
X-Received: by 2002:a63:1d41:: with SMTP id d1mr31119332pgm.135.1618321092698;
        Tue, 13 Apr 2021 06:38:12 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id k21sm12630090pfi.28.2021.04.13.06.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:38:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1] KVM: PPC: Book3S HV P9: implement kvmppc_xive_pull_vcpu in C
Date:   Tue, 13 Apr 2021 23:38:02 +1000
Message-Id: <20210413133802.1691660-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is more symmetric with kvmppc_xive_push_vcpu, and has the advantage
that it runs with the MMU on.

The extra test added to the asm will go away with a future change.

Reviewed-by: Cédric Le Goater <clg@kaod.org>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Another bit that came from the KVM Cify series.

Thanks,
Nick

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
index 4a532410e128..981bcaf787a8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3570,6 +3570,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

