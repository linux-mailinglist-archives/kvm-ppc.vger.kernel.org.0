Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB0353AB9
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhDEBWs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbhDEBWo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:44 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73102C061788
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x126so2205403pfc.13
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lT40J0V9NBeZrLgQ+b5j14kA1GasZu+lHS7oD02caS4=;
        b=jXgo5eukd93CxmPdudi1Zn0FIJaqPSsy1qHvxo75HcVhOEH7W+hEhBRb1OHItsXyyc
         bOubrUn/wR7nXIHrYfam7CHwoPG5ynGStpqzErf2svhEE64yxcL/c+cR+UntSdufwB40
         tYTNIwxkcX0/mB5p1bJXdOnF9JMk5ExupVExCl9Yl/vqyj/noUh84hSlqcp5Kro7J7Xk
         pSXgb/CidGfElyMub/GoKEau9tTnFMSDK3puqtFn5nWk0B5el4V3t85L8+B71jDcYCkF
         xmmfw9yRpdcP51VUFVUHplm3bvIRWfMkWFXLtge31hluxG0l5nasQ0W7lNPFNTzt8L0I
         g5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lT40J0V9NBeZrLgQ+b5j14kA1GasZu+lHS7oD02caS4=;
        b=CDrZNqbREEifEL5W1m0YSmuyr0mCwdVVjbeVXVOwl/if2qa4nZcRNbGwRTxSMOo/Me
         DJ7zdD+tq7jQPb3OhkA6kJ+ovkcEfDqI+Zj3rfPymlvmeJoiMV8XQIf8Tq/C+WMRsYJ2
         r9jfSxjMPw+Lp+gRByiyX/PDsMlFdy6Nfoa+LVjU1y002hLUnGV691GnY8fPMlT+Qgrq
         VsOclO7Khbutpqlx43jpOVTl1Tzt76fHTNH7Dos4GKux8LBAZ5T7FGYVlCiSd9G35KUX
         yi8RzWOQKwlATqviLJKfoMSrR5ktGADqjViC2rK/6ZTkh8ShKqFnV7IoVJshYgRkfYog
         6kjg==
X-Gm-Message-State: AOAM530Z3Hzgw93Y+7fqR9e99WzocByqDUVyrRdv3GTdbBkhFVPmYSNX
        LSD48xwgiaG9dic/+l6h6AktsM2AZwQVSw==
X-Google-Smtp-Source: ABdhPJxoA8OIPEFbQEQagSInxYL96zfWuvboWl4YHV7EzCzMQjkCQ05iYPmJk7B0/tVcy6mOAvi3lw==
X-Received: by 2002:a63:4763:: with SMTP id w35mr21011033pgk.226.1617585757754;
        Sun, 04 Apr 2021 18:22:37 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 47/48] KVM: PPC: Book3S HV P9: implement hash host / hash guest support
Date:   Mon,  5 Apr 2021 11:19:47 +1000
Message-Id: <20210405011948.675354-48-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This additionally has to save and restore the host SLB, and also
ensure that the MMU is off while switching into the guest SLB.

P9 and later CPUs now always go via the P9 path. The "fast" guest
mode is now renamed to the P9 mode, which is consistent with
functionality and naming.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_asm.h     |  2 +-
 arch/powerpc/kvm/book3s_64_entry.S     | 12 ++++++---
 arch/powerpc/kvm/book3s_hv.c           |  4 ++-
 arch/powerpc/kvm/book3s_hv_interrupt.c | 37 +++++++++++++++++++++-----
 4 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index b4f9996bd331..b996002882b1 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -146,7 +146,7 @@
 #define KVM_GUEST_MODE_GUEST	1
 #define KVM_GUEST_MODE_SKIP	2
 #define KVM_GUEST_MODE_GUEST_HV	3
-#define KVM_GUEST_MODE_GUEST_HV_FAST	4 /* ISA v3.0 with host radix mode */
+#define KVM_GUEST_MODE_GUEST_HV_P9	4 /* ISA >= v3.0 path */
 #define KVM_GUEST_MODE_HOST_HV	5
 
 #define KVM_INST_FETCH_FAILED	-1
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index d98ad580fd98..5d7eca29b471 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -35,7 +35,7 @@
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
 	lbz	r10,HSTATE_IN_GUEST(r13)
-	cmpwi	r10,KVM_GUEST_MODE_GUEST_HV_FAST
+	cmpwi	r10,KVM_GUEST_MODE_GUEST_HV_P9
 	beq	kvmppc_p9_exit_hcall
 	ld	r10,PACA_EXGEN+EX_R13(r13)
 	SET_SCRATCH0(r10)
@@ -65,7 +65,7 @@ kvmppc_hcall:
 kvmppc_interrupt:
 	std	r10,HSTATE_SCRATCH0(r13)
 	lbz	r10,HSTATE_IN_GUEST(r13)
-	cmpwi	r10,KVM_GUEST_MODE_GUEST_HV_FAST
+	cmpwi	r10,KVM_GUEST_MODE_GUEST_HV_P9
 	beq	kvmppc_p9_exit_interrupt
 	ld	r10,HSTATE_SCRATCH0(r13)
 	lbz	r11,HSTATE_IN_GUEST(r13)
@@ -280,7 +280,7 @@ kvmppc_p9_exit_hcall:
 .balign	IFETCH_ALIGN_BYTES
 kvmppc_p9_exit_interrupt:
 	/*
-	 * If set to KVM_GUEST_MODE_GUEST_HV_FAST but we're still in the
+	 * If set to KVM_GUEST_MODE_GUEST_HV_P9 but we're still in the
 	 * hypervisor, that means we can't return from the entry stack.
 	 */
 	rldicl. r10,r12,64-MSR_HV_LG,63
@@ -354,6 +354,12 @@ kvmppc_p9_exit_interrupt:
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
 	 * Set GUEST_MODE_NONE so the handler won't branch to KVM, and clear
 	 * MSR_RI in r12 ([H]SRR1) so the handler won't try to return.
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4d0bb5b31307..e8d9843a134d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4502,7 +4502,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (radix_enabled())
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -5591,6 +5591,8 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 		return -EPERM;
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
+	if (!radix_enabled())
+		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index a878cb5ec1b8..db24962f52f5 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -150,7 +150,7 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 	 */
 }
 
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
 	isync();
 	mtspr(SPRN_PID, pid);
@@ -159,6 +159,23 @@ static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
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
+		mtslb(0, 0, 0);
+		slb_invalidate(6);
+	}
 }
 
 static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
@@ -292,16 +309,24 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
+	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_P9;
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
 
@@ -487,7 +512,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host_radix(kvm, host_pidr);
+	switch_mmu_to_host(kvm, host_pidr);
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	/*
-- 
2.23.0

