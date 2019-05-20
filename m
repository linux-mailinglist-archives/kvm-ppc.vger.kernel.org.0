Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073F32299D
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 02:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfETA55 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 19 May 2019 20:57:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36897 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbfETA55 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 19 May 2019 20:57:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so5887480pll.4
        for <kvm-ppc@vger.kernel.org>; Sun, 19 May 2019 17:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YTelQezH8tbjq6Pc02UK1h7q/3igu/IcIAXxAd/sgJQ=;
        b=U/e1uWGo5NnsmxZAaKyKv7IwRXivDKB1xSYywblNPnaNdX4aQya2YAhZ2uKCm+Vn+O
         QPkFg7nKUUh8VTKVlHzyRP0xHN9o0FIvBspxbgLDJrjsQxlT/jgJ2uHQcEgkLRo2pEBc
         xBhuiIaUMu3EooGvnd36CgHS9x5WNa2Mesqh9pFMVq/p21/TSC8HgKoeq/aq12sXYqkU
         Y3d5lLQQN85xYWZRpTpeEB7hU3A/di6IZZ5Cnjog3kVbONvH1Fj1e+Cogm2u8rTfBm30
         HTCs/xY1Yj5RzYLO/c4+VtFrAa/4R67twcJACznk3dJqRd+SHdKqoCiogWRJtogUdr3q
         OZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YTelQezH8tbjq6Pc02UK1h7q/3igu/IcIAXxAd/sgJQ=;
        b=st7RB01TjR1GSCWw/rEhBv2Km08psgeaOrDq1yElHZ7tl3/OH3ZfJgcH88Hm8FqCCq
         pf6JkYqlhz36NpJIJoc97YhTP2tWudK0kLcTXhKclWzliYoNGzXTtiJZA4KRKGTuiYew
         8DcIJNEadVnOU7s2U5FMqXg5ubTyxZJv8OV7YtapAIDKfyRrdX+PeqUe0omELdbFUMdu
         ZsC7xxsYMs8CgaeXWZq5kYvp0IeA0Lvg3+rmDeBtfqjwm7uJbiEJ44ultajZp9TKpzdj
         pXTe3JE/XjJ+QpUe6Inmc4VjD4OeUBdENj18wd4iQLija3QDnZuVHiULGqWih8OL9y8s
         Xu5A==
X-Gm-Message-State: APjAAAVv+UDh1LFJLuSedd7v2hud40nrJb+3JCOdEWVcdcCmUVI6aPzb
        lO/oxN/F6GbAoenVXKbCHQbulen/
X-Google-Smtp-Source: APXvYqyEJUJrprvBz9KipmoYBu3YUZ1tydvF0WLpXXnwat4MRC9YJceEtdrw7O3/58hF9DeuFM6wnw==
X-Received: by 2002:a17:902:a40b:: with SMTP id p11mr44918909plq.306.1558313876287;
        Sun, 19 May 2019 17:57:56 -0700 (PDT)
Received: from bobo.local0.net (193-116-79-244.tpgi.com.au. [193.116.79.244])
        by smtp.gmail.com with ESMTPSA id q193sm22643371pfc.52.2019.05.19.17.57.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:57:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 2/5] KVM: PPC: Book3S: Replace reset_msr mmu op with inject_interrupt arch op
Date:   Mon, 20 May 2019 10:56:56 +1000
Message-Id: <20190520005659.18628-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520005659.18628-1-npiggin@gmail.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c        | 24 +++++++++++++++++
 arch/powerpc/kvm/book3s_pr.c        | 40 ++++++++++++++++++++++++++++-
 8 files changed, 65 insertions(+), 62 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 013c76a0a03e..7e27f7443801 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -395,7 +395,6 @@ struct kvmppc_mmu {
 	u32  (*mfsrin)(struct kvm_vcpu *vcpu, u32 srnum);
 	int  (*xlate)(struct kvm_vcpu *vcpu, gva_t eaddr,
 		      struct kvmppc_pte *pte, bool data, bool iswrite);
-	void (*reset_msr)(struct kvm_vcpu *vcpu);
 	void (*tlbie)(struct kvm_vcpu *vcpu, ulong addr, bool large);
 	int  (*esid_to_vsid)(struct kvm_vcpu *vcpu, ulong esid, u64 *vsid);
 	u64  (*ea_to_vp)(struct kvm_vcpu *vcpu, gva_t eaddr, bool data);
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bc892380e6cd..bd09dcd8613d 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -282,6 +282,7 @@ struct kvmppc_ops {
 			   union kvmppc_one_reg *val);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
+	void (*inject_interrupt)(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags);
 	void (*set_msr)(struct kvm_vcpu *vcpu, u64 msr);
 	int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned int id);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d59b9f666efb..e055d25b1347 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -77,27 +77,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
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
@@ -137,11 +116,7 @@ static inline bool kvmppc_critical_section(struct kvm_vcpu *vcpu)
 
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
index 6f789f674048..0173215e14c8 100644
--- a/arch/powerpc/kvm/book3s_32_mmu.c
+++ b/arch/powerpc/kvm/book3s_32_mmu.c
@@ -101,11 +101,6 @@ static u64 kvmppc_mmu_book3s_32_ea_to_vp(struct kvm_vcpu *vcpu, gva_t eaddr,
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
@@ -416,7 +411,6 @@ void kvmppc_mmu_book3s_32_init(struct kvm_vcpu *vcpu)
 	mmu->mtsrin = kvmppc_mmu_book3s_32_mtsrin;
 	mmu->mfsrin = kvmppc_mmu_book3s_32_mfsrin;
 	mmu->xlate = kvmppc_mmu_book3s_32_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_32_reset_msr;
 	mmu->tlbie = kvmppc_mmu_book3s_32_tlbie;
 	mmu->esid_to_vsid = kvmppc_mmu_book3s_32_esid_to_vsid;
 	mmu->ea_to_vp = kvmppc_mmu_book3s_32_ea_to_vp;
diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
index d4b967f0e8d4..49c7c6ec381d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu.c
+++ b/arch/powerpc/kvm/book3s_64_mmu.c
@@ -35,20 +35,6 @@
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
@@ -687,7 +673,6 @@ void kvmppc_mmu_book3s_64_init(struct kvm_vcpu *vcpu)
 	mmu->slbie = kvmppc_mmu_book3s_64_slbie;
 	mmu->slbia = kvmppc_mmu_book3s_64_slbia;
 	mmu->xlate = kvmppc_mmu_book3s_64_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_64_reset_msr;
 	mmu->tlbie = kvmppc_mmu_book3s_64_tlbie;
 	mmu->esid_to_vsid = kvmppc_mmu_book3s_64_esid_to_vsid;
 	mmu->ea_to_vp = kvmppc_mmu_book3s_64_ea_to_vp;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index ab3d484c5e2e..37530da0cd81 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -286,18 +286,6 @@ int kvmppc_mmu_hv_init(void)
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
@@ -2172,7 +2160,6 @@ void kvmppc_mmu_book3s_hv_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.slb_nr = 32;		/* POWER7/POWER8 */
 
 	mmu->xlate = kvmppc_mmu_book3s_64_hv_xlate;
-	mmu->reset_msr = kvmppc_mmu_book3s_64_hv_reset_msr;
 
 	vcpu->arch.hflags |= BOOK3S_HFLAG_SLB;
 }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d5fc624e0655..46015d2e09e0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -341,6 +341,29 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
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
+	kvmppc_set_msr(vcpu, new_msr);
+}
+
 static void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
 	/*
@@ -5355,6 +5378,7 @@ static struct kvmppc_ops kvm_ops_hv = {
 	.set_one_reg = kvmppc_set_one_reg_hv,
 	.vcpu_load   = kvmppc_core_vcpu_load_hv,
 	.vcpu_put    = kvmppc_core_vcpu_put_hv,
+	.inject_interrupt = kvmppc_inject_interrupt_hv,
 	.set_msr     = kvmppc_set_msr_hv,
 	.vcpu_run    = kvmppc_vcpu_run_hv,
 	.vcpu_create = kvmppc_core_vcpu_create_hv,
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 811a3c2fb0e9..51c1f12795f1 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -93,7 +93,43 @@ static void kvmppc_fixup_split_real(struct kvm_vcpu *vcpu)
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
+	kvmppc_set_msr(vcpu, new_msr);
+}
 
 static void kvmppc_core_vcpu_load_pr(struct kvm_vcpu *vcpu, int cpu)
 {
@@ -1764,6 +1800,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
 #else
 	/* default to book3s_32 (750) */
 	vcpu->arch.pvr = 0x84202;
+	vcpu->arch.intr_msr = 0;
 #endif
 	kvmppc_set_pvr_pr(vcpu, vcpu->arch.pvr);
 	vcpu->arch.slb_nr = 64;
@@ -2061,6 +2098,7 @@ static struct kvmppc_ops kvm_ops_pr = {
 	.set_one_reg = kvmppc_set_one_reg_pr,
 	.vcpu_load   = kvmppc_core_vcpu_load_pr,
 	.vcpu_put    = kvmppc_core_vcpu_put_pr,
+	.inject_interrupt = kvmppc_inject_interrupt_pr,
 	.set_msr     = kvmppc_set_msr_pr,
 	.vcpu_run    = kvmppc_vcpu_run_pr,
 	.vcpu_create = kvmppc_core_vcpu_create_pr,
-- 
2.20.1

