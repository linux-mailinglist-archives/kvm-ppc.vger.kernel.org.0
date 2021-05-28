Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1388393F89
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhE1JKz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhE1JKw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566DFC0613CE
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 29so2036046pgu.11
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=odpgGURx+7R/s14DvMRfmE9djTm9dneqqyjT3+mISFI=;
        b=KN841DqOJiH/xnJThwxvJzFd0pT/GlYidUp24Nm6pgNYMbZAstELwFavSXl99NQ858
         L9f33GruY9fiHIrsF0HHoxylu7sSKXuQYcVgxtD1peulOBVVErHoDdx2Ec6a4EZkinzh
         +pnCZi56uMhaAZo6rwWK7uO/x7gR16XUKl6OU/wOnLw08iKz3G4Lv+t32SKzXihu5W1Q
         mi/+yf5K81qv2VCH9CVusVmPDteTsPUSLqB178Jx9ucx0QF8OKahORmxIrJ/jyjzLLiU
         IhUqf3NX+6rw6Ed8X7bQ8qxtSiiwWTNqQ1cErQRUoY1UuZWDPCia0rcMC70NSNTeU+2s
         VokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=odpgGURx+7R/s14DvMRfmE9djTm9dneqqyjT3+mISFI=;
        b=bJLh37LBbsR39pPbtndayF/bblfkUo/+WdLDIU7edip24g3gZhjCB1aqP3WQBcF4WQ
         VD6g/bXrT+mwb8+lTi0G445ZA46Y7YvfbXeTU6k9512zNYbsOE7K/lVbcbUMCt2+27Yc
         eZAqtm1Yr3a63xIlJSeVCsbNVZJV5DfGGbZelAAx0c/JS4z9y8SNlCjL7jb0PMr2NLjV
         tpHaneIoe8SHEPZJ+9rkrnbBwHM2tgHI1UW16T2IMmBr/SofVGMET8foAKJPO0dImkXP
         fDA3xPgSippAS/AcJaDfBpj6HpS02n1JG9GOo7eZpPy9znOCD1KszXoRFfm6egVMvWxa
         5dIw==
X-Gm-Message-State: AOAM532wNba2Af46KtVP2x/hTVgn8QWHlJ+Lfk8g8GIiJRRpqPGduOSw
        a9qBmccFNLm6QfAM2Ei4g7ez7Trfv0s=
X-Google-Smtp-Source: ABdhPJzZlRCZA7VNlCYYAIueTKD7jVKJgSB8Clp8xTk61pwf0O3s/fNxcQEViBP7N8hS62FTMceAIQ==
X-Received: by 2002:a62:a101:0:b029:2e8:e878:bdc0 with SMTP id b1-20020a62a1010000b02902e8e878bdc0mr2863001pff.38.1622192956718;
        Fri, 28 May 2021 02:09:16 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:09:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 31/32] KVM: PPC: Book3S HV P9: implement hash host / hash guest support
Date:   Fri, 28 May 2021 19:07:51 +1000
Message-Id: <20210528090752.3542186-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Implement support for hash guests under hash host. This has to save and
restore the host SLB, and ensure that the MMU is off while switching
into the guest SLB.

POWER9 and later CPUs now always go via the P9 path. The "fast" guest
mode is now renamed to the P9 mode, which is consistent with its
functionality and the rest of the naming.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_asm.h    |  2 +-
 arch/powerpc/kvm/book3s_64_entry.S    | 15 +++++++----
 arch/powerpc/kvm/book3s_hv.c          |  4 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 36 ++++++++++++++++++++++-----
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index e479487488f4..fbbf3cec92e9 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -147,7 +147,7 @@
 #define KVM_GUEST_MODE_SKIP	2
 #define KVM_GUEST_MODE_GUEST_HV	3
 #define KVM_GUEST_MODE_HOST_HV	4
-#define KVM_GUEST_MODE_HV_FAST	5 /* ISA >= v3.0 host radix */
+#define KVM_GUEST_MODE_HV_P9	5 /* ISA >= v3.0 path */
 
 #define KVM_INST_FETCH_FAILED	-1
 
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 7322fea971e4..983b8c18bc31 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -36,7 +36,7 @@
 kvmppc_hcall:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	lbz	r10,HSTATE_IN_GUEST(r13)
-	cmpwi	r10,KVM_GUEST_MODE_HV_FAST
+	cmpwi	r10,KVM_GUEST_MODE_HV_P9
 	beq	kvmppc_p9_exit_hcall
 #endif
 	ld	r10,PACA_EXGEN+EX_R13(r13)
@@ -68,7 +68,7 @@ kvmppc_interrupt:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	std	r10,HSTATE_SCRATCH0(r13)
 	lbz	r10,HSTATE_IN_GUEST(r13)
-	cmpwi	r10,KVM_GUEST_MODE_HV_FAST
+	cmpwi	r10,KVM_GUEST_MODE_HV_P9
 	beq	kvmppc_p9_exit_interrupt
 	ld	r10,HSTATE_SCRATCH0(r13)
 #endif
@@ -183,8 +183,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 /*
  * void kvmppc_p9_enter_guest(struct vcpu *vcpu);
  *
- * Enter the guest on a ISAv3.0 or later system where we have exactly
- * one vcpu per vcore, and the host is radix.
+ * Enter the guest on a ISAv3.0 or later system.
  */
 .balign	IFETCH_ALIGN_BYTES
 _GLOBAL(kvmppc_p9_enter_guest)
@@ -284,7 +283,7 @@ kvmppc_p9_exit_hcall:
 .balign	IFETCH_ALIGN_BYTES
 kvmppc_p9_exit_interrupt:
 	/*
-	 * If set to KVM_GUEST_MODE_HV_FAST but we're still in the
+	 * If set to KVM_GUEST_MODE_HV_P9 but we're still in the
 	 * hypervisor, that means we can't return from the entry stack.
 	 */
 	rldicl. r10,r12,64-MSR_HV_LG,63
@@ -358,6 +357,12 @@ kvmppc_p9_exit_interrupt:
  * effort for a small bit of code. Lots of other things to do first.
  */
 kvmppc_p9_bad_interrupt:
+BEGIN_MMU_FTR_SECTION
+	/*
+	 * Hash host doesn't try to recover MMU (requires host SLB reload)
+	 */
+	b	.
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 	/*
 	 * Clean up guest registers to give host a chance to run.
 	 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 662f599bdc0e..045458e7192a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4511,7 +4511,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (radix_enabled())
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -5599,6 +5599,8 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 		return -EPERM;
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
+	if (!radix_enabled())
+		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 4460f1c23a9d..83f592eadcd2 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -130,7 +130,7 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 	isync();
 }
 
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
 	isync();
 	mtspr(SPRN_PID, pid);
@@ -139,6 +139,22 @@ static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
 	isync();
 	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
 	isync();
+
+	if (!radix_enabled())
+		slb_restore_bolted_realmode();
+}
+
+static void save_clear_host_mmu(struct kvm *kvm)
+{
+	if (!radix_enabled()) {
+		/*
+		 * Hash host could save and restore host SLB entries to
+		 * reduce SLB fault overheads of VM exits, but for now the
+		 * existing code clears all entries and restores just the
+		 * bolted ones when switching back to host.
+		 */
+		slb_clear_invalidate_partition();
+	}
 }
 
 static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
@@ -271,16 +287,24 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_FAST;
+	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_P9;
+
+	/*
+	 * Hash host, hash guest, or radix guest with prefetch bug, all have
+	 * to disable the MMU before switching to guest MMU state.
+	 */
+	if (!radix_enabled() || !kvm_is_radix(kvm) ||
+			cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+
+	save_clear_host_mmu(kvm);
+
 	if (kvm_is_radix(kvm)) {
-		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-			__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 		if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
 			__mtmsrd(0, 1); /* clear RI */
 
 	} else {
-		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_hpt(kvm, vcpu, lpcr);
 	}
 
@@ -468,7 +492,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HDEC, 0x7fffffff);
 
 	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host_radix(kvm, host_pidr);
+	switch_mmu_to_host(kvm, host_pidr);
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	/*
-- 
2.23.0

