Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C34351C98
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhDASSv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhDASLl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:11:41 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565B8C00F7C2
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:16 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so1681626pga.11
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQDbowmVW+WFqxQHg++Y56ZpE0uZWvGrEASD2f3Fwp8=;
        b=rSH1AtN+Y8w1rZ/xwn6Q3t4qQlwt8/O7z5fxWxcmRMN9Ccy32H044IVSwInsyCix8d
         jlqDAbBzfIUVtZNRrnxEs3MhW8Ftv1JNZgf8PUPnrAT5MXx/xaL+FEXKzHp8U5R02oUu
         Lq7wsVQjm82DwJ/BTVJKwq+cc48hq6UgVCwbKQos72vZGJBIscMkdfk/oUa7xvVcG3b2
         szSyK1IWtOY1M2vrMWzXmuQcf9OOPSqeKcFFd0XIOXOi/kzXlUenq+n4Z+h41unf4/w/
         TRhAR+c/1YenVFjaKUqmyPqHsX5lJG433FAJfpB4KPLj3rjQFHdA6Tv5c/i5yIhx8oos
         VMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQDbowmVW+WFqxQHg++Y56ZpE0uZWvGrEASD2f3Fwp8=;
        b=lyJNTGaeIVQ1FoXZasw03GE1iDFlgbK7NRH0Krdvqo4qQZTZHVgJpTrEUi/XPONSeD
         KPIHQyFB/rF3sR7RkqBQ8Cu0KL+BfBFTI8XE/iFwulT6iSCiucxauOQLbcc/UqOkRutH
         j5FNt6cfkMqNx7U5ySggaGqP4WqX9B7olexqZXelvmyiND5kqWJwB+Hyv6IllqWHkd1O
         gKFCUeme5dv0Hg64v6UMt9asN4lg+iJ3bgU33gE7w+gqYAST4upb6kO0hVwO71lMfDZG
         m/4t7SL7Xjp+2dOj8OSZK8HhmZbjX1NQnGTy6Jqy4i73iJMCrascNqjmroOh+RlD65DV
         S9Iw==
X-Gm-Message-State: AOAM532OMioun/fmoQRfWuz8FFURES24KeVLWJMqS2KC7Jl759GkJ4rL
        D0EhCcT5Ar4KAs1kXDO//xZKfBQJzds=
X-Google-Smtp-Source: ABdhPJwtZYj3gl5Yil0EKjgOJyoI4OlCKkze3bpp5fa7RRf8rT9md5InGzKCea4ouDdcr+j/p1iD8g==
X-Received: by 2002:a62:33c6:0:b029:225:5266:28df with SMTP id z189-20020a6233c60000b0290225526628dfmr7867260pfz.7.1617289515721;
        Thu, 01 Apr 2021 08:05:15 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:15 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 32/48] KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is 0
Date:   Fri,  2 Apr 2021 01:03:09 +1000
Message-Id: <20210401150325.442125-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

SRR0/1, DAR, DSISR must all be protected from machine check which can
clobber them. Ensure MSR[RI] is clear while they are live.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c           | 11 +++++++--
 arch/powerpc/kvm/book3s_hv_interrupt.c | 33 +++++++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv_ras.c       |  2 ++
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index af0eedcaab8b..5953d1d72f2e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3561,11 +3561,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -3608,6 +3613,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			hvregs.vcpu_token = vcpu->vcpu_id;
 		}
 		hvregs.hdec_expiry = time_limit;
+		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
 					  __pa(&vcpu->arch.regs));
 		kvmhv_restore_hv_return_state(vcpu, &hvregs);
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 15f1b78c5c90..e419b23faa16 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -132,6 +132,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	s64 hdec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
+	bool ri_set;
 	unsigned long msr = mfmsr();
 	int trap;
 	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
@@ -203,9 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
 	vcpu->arch.ceded = 0;
@@ -231,6 +229,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
@@ -248,7 +253,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
@@ -258,6 +269,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6..8d8a4d5f0b55 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -199,6 +199,8 @@ static void kvmppc_tb_resync_done(void)
  * know about the exact state of the TB value. Resync TB call will
  * restore TB to host timebase.
  *
+ * This could use the new OPAL_HANDLE_HMI2 to avoid resyncing TB every time.
+ *
  * Things to consider:
  * - On TB error, HMI interrupt is reported on all the threads of the core
  *   that has encountered TB error irrespective of split-core mode.
-- 
2.23.0

