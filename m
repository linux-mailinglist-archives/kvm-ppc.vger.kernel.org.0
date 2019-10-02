Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28AC4751
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Oct 2019 08:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfJBGA5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Oct 2019 02:00:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33428 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfJBGA4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Oct 2019 02:00:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so9764122pfl.0
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Oct 2019 23:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B5GgFrZHZTu1T2sX7rlhrRAxSELLepdKkHJkIjcDvCQ=;
        b=TEdRdGef+tBZ4GyjlHFNCF9ltAJ9Pby1U6Y37DDBNIgOrW8if0PChAYd6VlOcJqBta
         ARlzNCsKHnL1GLFGkSrwEVCxpAOlBuDEx1OGYi2lNT9OsyQGBeEnX34YtNOAnhA0atrH
         buz8EPMN3x0gbthb/1dl4mibjtJCvfgGJ9ig0nqPi7ZEqWTssU5TOKPP2NxdwJPZBWFH
         Gcc0wi6a4TmhszmR6MiswF5/3QtAxvgPCIF38SKEJMpTwHi/aXjMTzsX1wCKK8UPhoxj
         Nj6ShpRhc7ChIUc6H1tVr5unDytm/Fnq5zqSEESarCS2yIEXaDG5BiV4I7FXX8WtNc4q
         Xk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B5GgFrZHZTu1T2sX7rlhrRAxSELLepdKkHJkIjcDvCQ=;
        b=JkHm/a2B/Xa/w1rWAo2GiqgYad5vK+96bnFOmuCFWXd0s+eHcC7O3Fr8teI4XTedz9
         H1TP8PUNAuEYJd1euVh0tds9plMe7W86kj4vO3sRKuM5KjmIP9qxr+sSo2UjFwjv2DXE
         vdXLeHUSQ5sJuA+lcqLr5mmcdeO4PCtuH1X5om3Fg7b52ZsdwxKxQIAhvpnnb7ZTll3B
         5qq5oYWlYaYtREBpFkjFX1SxrNNQ18jt61oimueFEkNg6WHnT3Ej/AHsvyXLdgeh/ZC0
         zAVXd3BImV7hUsYNJyn+Ytzonjz+puUMPcmfNo1R1y4X118aFXytZUGqoD9sAwGoVWtc
         eYkg==
X-Gm-Message-State: APjAAAUo9PKGSUr4TsdVPgv1rt/r7ugdcyqcDoioFhqkEFPxN/VC6y4j
        BoGE6uUPd/DaTCtIfrs40fnrtdZC
X-Google-Smtp-Source: APXvYqyBEekzpDOdjjuoZIumYX9PleQAQPlGOSBZfHg+n9sOB+M0qDcnOpb7Os4hHztQzTNLa5DRpA==
X-Received: by 2002:aa7:9358:: with SMTP id 24mr2545714pfn.241.1569996055733;
        Tue, 01 Oct 2019 23:00:55 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id v12sm18660749pgr.31.2019.10.01.23.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:00:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 2/5] KVM: PPC: Book3S: Replace reset_msr mmu op with inject_interrupt arch op
Date:   Wed,  2 Oct 2019 16:00:22 +1000
Message-Id: <20191002060025.11644-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002060025.11644-1-npiggin@gmail.com>
References: <20191002060025.11644-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

reset_msr sets the MSR for interrupt injection, but it's cleaner and
more flexible to provide a single op to set both MSR and PC for the
interrupt.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/powerpc/include/asm/kvm_ppc.h  |  1 +
 arch/powerpc/kvm/book3s.c           | 27 +------------------
 arch/powerpc/kvm/book3s_32_mmu.c    |  6 -----
 arch/powerpc/kvm/book3s_64_mmu.c    | 15 -----------
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 13 ----------
 arch/powerpc/kvm/book3s_hv.c        | 22 ++++++++++++++++
 arch/powerpc/kvm/book3s_pr.c        | 40 ++++++++++++++++++++++++++++-
 8 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6fe6ad64cba5..4273e799203d 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -401,7 +401,6 @@ struct kvmppc_mmu {
 	u32  (*mfsrin)(struct kvm_vcpu *vcpu, u32 srnum);
 	int  (*xlate)(struct kvm_vcpu *vcpu, gva_t eaddr,
 		      struct kvmppc_pte *pte, bool data, bool iswrite);
-	void (*reset_msr)(struct kvm_vcpu *vcpu);
 	void (*tlbie)(struct kvm_vcpu *vcpu, ulong addr, bool large);
 	int  (*esid_to_vsid)(struct kvm_vcpu *vcpu, ulong esid, u64 *vsid);
 	u64  (*ea_to_vp)(struct kvm_vcpu *vcpu, gva_t eaddr, bool data);
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ee62776e5433..d63f649fe713 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -271,6 +271,7 @@ struct kvmppc_ops {
 			   union kvmppc_one_reg *val);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*inject_interrupt)(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags);
 	void (*set_msr)(struct kvm_vcpu *vcpu, u64 msr);
 	int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned int id);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 38466df81d33..27050cbf609b 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -74,27 +74,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-void kvmppc_unfixup_split_real(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.hflags & BOOK3S_HFLAG_SPLIT_HACK) {
-		ulong pc = kvmppc_get_pc(vcpu);
-		ulong lr = kvmppc_get_lr(vcpu);
-		if ((pc & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
-			kvmppc_set_pc(vcpu, pc & ~SPLIT_HACK_MASK);
-		if ((lr & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
-			kvmppc_set_lr(vcpu, lr & ~SPLIT_HACK_MASK);
-		vcpu->arch.hflags &= ~BOOK3S_HFLAG_SPLIT_HACK;
-	}
-}
-EXPORT_SYMBOL_GPL(kvmppc_unfixup_split_real);
-
-static inline unsigned long kvmppc_interrupt_offset(struct kvm_vcpu *vcpu)
-{
-	if (!is_kvmppc_hv_enabled(vcpu->kvm))
-		return to_book3s(vcpu)->hior;
-	return 0;
-}
-
 static inline void kvmppc_update_int_pending(struct kvm_vcpu *vcpu,
 			unsigned long pending_now, unsigned long old_pending)
 {
@@ -134,11 +113,7 @@ static inline bool kvmppc_critical_section(struct kvm_vcpu *vcpu)
 
 void kvmppc_inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 flags)
 {
-	kvmppc_unfixup_split_real(vcpu);
-	kvmppc_set_srr0(vcpu, kvmppc_get_pc(vcpu));
-	kvmppc_set_srr1(vcpu, (kvmppc_get_msr(vcpu) & SRR1_MSR_BITS) | flags);
-	kvmppc_set_pc(vcpu, kvmppc_interrupt_offset(vcpu) + vec);
-	vcpu->arch.mmu.reset_msr(vcpu);
+	vcpu->kvm->arch.kvm_ops->inject_interrupt(vcpu, vec, flags);
 }
 
 static int kvmppc_book3s_vec2irqprio(unsigned int vec)
diff --git a/arch/powerpc/kvm/book3s_32_mmu.c b/arch/powerpc/kvm/book3s_32_mmu.c
index 18f244aad7aa..f21e73492ce3 100644
--- a/arch/powerpc/kvm/book3s_32_mmu.c
+++ b/arch/powerpc/kvm/book3s_32_mmu.c
@@ -90,11 +90,6 @@ static u64 kvmppc_mmu_book3s_32_ea_to_vp(struct kvm_vcpu *vcpu, gva_t eaddr,
 	return (((u64)eaddr >> 12) & 0xffff) | (vsid << 16);
 }
 
-static void kvmppc_mmu_book3s_32_reset_msr(struct kvm_vcpu *vcpu)
-{
-	kvmppc_set_msr(vcpu, 0);
-}
-
 static hva_t kvmppc_mmu_book3s_32_get_pteg(struct kvm_vcpu *vcpu,
 				      u32 sre, gva_t eaddr,
 				      bool primary)
@@ -406,7 +401,6 @@ void kvmppc_mmu_book3s_32_init(struct kvm_vcpu *vcpu)
 	mmu->mtsrin = kvmppc_mmu_book3s_32_mtsrin;
 	mmu->mfsrin = kvmppc_mmu_book3s_32_mfsrin;
 	mmu->xlate = kvmppc_mmu_book3s_32_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_32_reset_msr;
 	mmu->tlbie = kvmppc_mmu_book3s_32_tlbie;
 	mmu->esid_to_vsid = kvmppc_mmu_book3s_32_esid_to_vsid;
 	mmu->ea_to_vp = kvmppc_mmu_book3s_32_ea_to_vp;
diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
index 5f63a5f7f24f..599133256a95 100644
--- a/arch/powerpc/kvm/book3s_64_mmu.c
+++ b/arch/powerpc/kvm/book3s_64_mmu.c
@@ -24,20 +24,6 @@
 #define dprintk(X...) do { } while(0)
 #endif
 
-static void kvmppc_mmu_book3s_64_reset_msr(struct kvm_vcpu *vcpu)
-{
-	unsigned long msr = vcpu->arch.intr_msr;
-	unsigned long cur_msr = kvmppc_get_msr(vcpu);
-
-	/* If transactional, change to suspend mode on IRQ delivery */
-	if (MSR_TM_TRANSACTIONAL(cur_msr))
-		msr |= MSR_TS_S;
-	else
-		msr |= cur_msr & MSR_TS_MASK;
-
-	kvmppc_set_msr(vcpu, msr);
-}
-
 static struct kvmppc_slb *kvmppc_mmu_book3s_64_find_slbe(
 				struct kvm_vcpu *vcpu,
 				gva_t eaddr)
@@ -676,7 +662,6 @@ void kvmppc_mmu_book3s_64_init(struct kvm_vcpu *vcpu)
 	mmu->slbie = kvmppc_mmu_book3s_64_slbie;
 	mmu->slbia = kvmppc_mmu_book3s_64_slbia;
 	mmu->xlate = kvmppc_mmu_book3s_64_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_64_reset_msr;
 	mmu->tlbie = kvmppc_mmu_book3s_64_tlbie;
 	mmu->esid_to_vsid = kvmppc_mmu_book3s_64_esid_to_vsid;
 	mmu->ea_to_vp = kvmppc_mmu_book3s_64_ea_to_vp;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 9a75f0e1933b..7cf80567ccaf 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -275,18 +275,6 @@ int kvmppc_mmu_hv_init(void)
 	return 0;
 }
 
-static void kvmppc_mmu_book3s_64_hv_reset_msr(struct kvm_vcpu *vcpu)
-{
-	unsigned long msr = vcpu->arch.intr_msr;
-
-	/* If transactional, change to suspend mode on IRQ delivery */
-	if (MSR_TM_TRANSACTIONAL(vcpu->arch.shregs.msr))
-		msr |= MSR_TS_S;
-	else
-		msr |= vcpu->arch.shregs.msr & MSR_TS_MASK;
-	kvmppc_set_msr(vcpu, msr);
-}
-
 static long kvmppc_virtmode_do_h_enter(struct kvm *kvm, unsigned long flags,
 				long pte_index, unsigned long pteh,
 				unsigned long ptel, unsigned long *pte_idx_ret)
@@ -2161,7 +2149,6 @@ void kvmppc_mmu_book3s_hv_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.slb_nr = 32;		/* POWER7/POWER8 */
 
 	mmu->xlate = kvmppc_mmu_book3s_64_hv_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_64_hv_reset_msr;
 
 	vcpu->arch.hflags |= BOOK3S_HFLAG_SLB;
 }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 709cf1fd4cf4..94a0a9911b27 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -338,6 +338,27 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
 	spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
 }
 
+static void kvmppc_inject_interrupt_hv(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
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
+	kvmppc_set_msr(vcpu, new_msr);
+}
+
 static void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
 	/*
@@ -5401,6 +5422,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.set_one_reg = kvmppc_set_one_reg_hv,
 	.vcpu_load   = kvmppc_core_vcpu_load_hv,
 	.vcpu_put    = kvmppc_core_vcpu_put_hv,
+	.inject_interrupt = kvmppc_inject_interrupt_hv,
 	.set_msr     = kvmppc_set_msr_hv,
 	.vcpu_run    = kvmppc_vcpu_run_hv,
 	.vcpu_create = kvmppc_core_vcpu_create_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index cc65af8fe6f7..ce4fcf76e53e 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -90,7 +90,43 @@ static void kvmppc_fixup_split_real(struct kvm_vcpu *vcpu)
 	kvmppc_set_pc(vcpu, pc | SPLIT_HACK_OFFS);
 }
 
-void kvmppc_unfixup_split_real(struct kvm_vcpu *vcpu);
+static void kvmppc_unfixup_split_real(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.hflags & BOOK3S_HFLAG_SPLIT_HACK) {
+		ulong pc = kvmppc_get_pc(vcpu);
+		ulong lr = kvmppc_get_lr(vcpu);
+		if ((pc & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
+			kvmppc_set_pc(vcpu, pc & ~SPLIT_HACK_MASK);
+		if ((lr & SPLIT_HACK_MASK) == SPLIT_HACK_OFFS)
+			kvmppc_set_lr(vcpu, lr & ~SPLIT_HACK_MASK);
+		vcpu->arch.hflags &= ~BOOK3S_HFLAG_SPLIT_HACK;
+	}
+}
+
+static void kvmppc_inject_interrupt_pr(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
+{
+	unsigned long msr, pc, new_msr, new_pc;
+
+	kvmppc_unfixup_split_real(vcpu);
+
+	msr = kvmppc_get_msr(vcpu);
+	pc = kvmppc_get_pc(vcpu);
+	new_msr = vcpu->arch.intr_msr;
+	new_pc = to_book3s(vcpu)->hior + vec;
+
+#ifdef CONFIG_PPC_BOOK3S_64
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
+	kvmppc_set_msr(vcpu, new_msr);
+}
 
 static void kvmppc_core_vcpu_load_pr(struct kvm_vcpu *vcpu, int cpu)
 {
@@ -1761,6 +1797,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
 #else
 	/* default to book3s_32 (750) */
 	vcpu->arch.pvr = 0x84202;
+	vcpu->arch.intr_msr = 0;
 #endif
 	kvmppc_set_pvr_pr(vcpu, vcpu->arch.pvr);
 	vcpu->arch.slb_nr = 64;
@@ -2058,6 +2095,7 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.set_one_reg = kvmppc_set_one_reg_pr,
 	.vcpu_load   = kvmppc_core_vcpu_load_pr,
 	.vcpu_put    = kvmppc_core_vcpu_put_pr,
+	.inject_interrupt = kvmppc_inject_interrupt_pr,
 	.set_msr     = kvmppc_set_msr_pr,
 	.vcpu_run    = kvmppc_vcpu_run_pr,
 	.vcpu_create = kvmppc_core_vcpu_create_pr,
-- 
2.23.0

