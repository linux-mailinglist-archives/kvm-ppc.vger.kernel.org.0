Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41246393F79
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhE1JKj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbhE1JKQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:16 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A64C061574
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:42 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id j12so2052935pgh.7
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t6KpH+2M2NCE7vEIU1Nz6fpHTX6XKtE5+K90w65CXFg=;
        b=UkidnPOytTHgxp+5Nrs9AOnPLENXvX9IF3QDZsU4qXb2+syQi2CK/EnVsUNXCAN2E/
         skxBMj0VG0QIpNGPr2pSUCC/IMUFWCiEK+XM0BlFsldgZcnQYU+Wwg1rocQXtfd+ZHVj
         OTVn6HxzbOdujBS7a3/5JTJDmVjcP0mEy4e9wx17xQVnQbukl8w0VmkiNbmtzSxuNmaO
         r4IOEvV9w1evC11dUdvVZZPWD3CodIDzxShwCupTjse2WL7EGnHe0ZM+j6mpszpy+kJi
         MyeW6L2yMoY/g0xg51VGWWxI//cEfds3JLcTWVYM+lbvq46WyuBdo9liCqzZAiq2TeBl
         eACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t6KpH+2M2NCE7vEIU1Nz6fpHTX6XKtE5+K90w65CXFg=;
        b=C99VaD8qjZ6vZJoZce9zrlSFLxXVJVejwDnX6KR/Vq0wRp41SemMnwWPHxXfpwarBx
         oebKlJjUpifhlWmgrQ5Fnbb5f97udIMS9dlLq4SwhQGC0ZX3PiGGx+AlZx+9mGx7k3Te
         Z9rLFBS8HsgFPsZlrRTrOnZKnZoSLklu66sR0vqNAmNYABzaquoYtIJ1qh45pI6DqVXl
         xpHApxDH0x64VWVMQ2JUUutMXeAuh0a7xLoe1pkZT7cEeZezAzMREOROPRqW95L943/C
         XHOIKhANxQAUyAMlQ9lM3y9Ib6u+NIX63Ile5ihYQCX0R52j0D3v5dKsbk2jo/YNWTHt
         B9Gg==
X-Gm-Message-State: AOAM533lWIP1I/5YPMvL2Ki15An9qa3zJaii/GHMABPN2XkYXGtGGNi5
        7Uah8swQABxsU/M9VhsStnfmsiG6pNk=
X-Google-Smtp-Source: ABdhPJydiyWJc6CxT934TuxKsrIcrLlgYoKT+GWP+wfnHbnZ9eyFSPuHRLoFYa4+TAq9/qjfaFGniA==
X-Received: by 2002:a63:ed4d:: with SMTP id m13mr7947010pgk.433.1622192921383;
        Fri, 28 May 2021 02:08:41 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v7 16/32] KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is 0
Date:   Fri, 28 May 2021 19:07:36 +1000
Message-Id: <20210528090752.3542186-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

SRR0/1, DAR, DSISR must all be protected from machine check which can
clobber them. Ensure MSR[RI] is clear while they are live.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 11 +++++++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 33 ++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 777ec786ef71..6d39e4784af6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3571,11 +3571,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_BESCR, vcpu->arch.bescr);
 	mtspr(SPRN_WORT, vcpu->arch.wort);
 	mtspr(SPRN_TIDR, vcpu->arch.tid);
-	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 	mtspr(SPRN_AMR, vcpu->arch.amr);
 	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
 
+	/*
+	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
+	 * clear (or hstate set appropriately to catch those registers
+	 * being clobbered if we take a MCE or SRESET), so those are done
+	 * later.
+	 */
+
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
@@ -3618,6 +3623,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			hvregs.vcpu_token = vcpu->vcpu_id;
 		}
 		hvregs.hdec_expiry = time_limit;
+		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
 					  __pa(&vcpu->arch.regs));
 		kvmhv_restore_hv_return_state(vcpu, &hvregs);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index d2e659940630..a6f89e30040b 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -122,6 +122,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	s64 hdec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
+	bool ri_set;
 	unsigned long msr = mfmsr();
 	int trap;
 	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
@@ -192,9 +193,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
 	vcpu->arch.ceded = 0;
@@ -220,6 +218,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
+	__mtmsrd(0, 1); /* clear RI */
+
+	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
+	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
+	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
+
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_FAST;
@@ -237,7 +242,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	/* 0x2 bit for HSRR is only used by PR and P7/8 HV paths, clear it */
 	trap = local_paca->kvm_hstate.scratch0 & ~0x2;
+
+	/* HSRR interrupts leave MSR[RI] unchanged, SRR interrupts clear it. */
+	ri_set = false;
 	if (likely(trap > BOOK3S_INTERRUPT_MACHINE_CHECK)) {
+		if (trap != BOOK3S_INTERRUPT_SYSCALL &&
+				(vcpu->arch.shregs.msr & MSR_RI))
+			ri_set = true;
 		exsave = local_paca->exgen;
 	} else if (trap == BOOK3S_INTERRUPT_SYSTEM_RESET) {
 		exsave = local_paca->exnmi;
@@ -247,6 +258,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.regs.gpr[1] = local_paca->kvm_hstate.scratch1;
 	vcpu->arch.regs.gpr[3] = local_paca->kvm_hstate.scratch2;
+
+	/*
+	 * Only set RI after reading machine check regs (DAR, DSISR, SRR0/1)
+	 * and hstate scratch (which we need to move into exsave to make
+	 * re-entrant vs SRESET/MCE)
+	 */
+	if (ri_set) {
+		if (unlikely(!(mfmsr() & MSR_RI))) {
+			__mtmsrd(MSR_RI, 1);
+			WARN_ON_ONCE(1);
+		}
+	} else {
+		WARN_ON_ONCE(mfmsr() & MSR_RI);
+		__mtmsrd(MSR_RI, 1);
+	}
+
 	vcpu->arch.regs.gpr[9] = exsave[EX_R9/sizeof(u64)];
 	vcpu->arch.regs.gpr[10] = exsave[EX_R10/sizeof(u64)];
 	vcpu->arch.regs.gpr[11] = exsave[EX_R11/sizeof(u64)];
-- 
2.23.0

