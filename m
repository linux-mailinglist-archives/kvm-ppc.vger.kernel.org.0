Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9784E34548B
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhCWBFU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhCWBEu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20373C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so11462410pjc.2
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qz7OZxEcix2OHTZvggI/E7prcFB2O0Ezdh7dg685TR0=;
        b=I1jTQ95pGyX4OogGnGmbtF5EyqnJzqHya4k6W2jYd+/oVHyMLL4q+Vk6f5NvzjzWx0
         1kA1bR2Hlh2xKF+t2AMUsB4i4Hq66jdSUmGhQEjPVNCnXz1hIzeo0Q0tvbKcZ3X3HTBh
         F+ILOJluRFhC+mh6kPR2yzP6DfXdARqwb9WlHKjfIVArJmT3Ik2s5ENhbLuVd7g0bfG1
         dPC11zqD/mAn93NSKZJMLADZEAdTJhX30WkTjOW2xtt9XrdE+SHf4E4IGIZTI944Cf13
         KdCwIpp1N7dqJNFsP1DC/vr1JAV1WZMokTAOPbhhctv6w+7AzpJs6Ls/9HkZRgurJpXt
         pKdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qz7OZxEcix2OHTZvggI/E7prcFB2O0Ezdh7dg685TR0=;
        b=QRQR/WBTatemBFz5sUpoOKbRBfB04cm0SbKd35b0iABXsXAg5wvB2fx8/H7nQoEx/o
         Kb+VQDrdoVAmBJGhEmjxHgmeJCQREcl7eiezNiNCAQms/O12drnlAQsf7hMWdiu65jBd
         UZXFgPUXClD1ee9Y5yrvpZUHifxM7h+R0HtOC2XkG17FoeW+sSG0kDe2JZc07pi8t3PO
         NgCdnONOqvXwZXBld9psqxFAIo5lQWMoGQOvpgFWVt0cIxOeyh7ITuI7yNgDkXAUdhcm
         uhn1R3NuxyJL36a4zRG1AWI000xIDTvia6joyR/iyzUBPJjnKvVYreRoXXX25iPBQ8u4
         9+rw==
X-Gm-Message-State: AOAM5306jSVQqUUB0iZUgamaHxsGUoU+ytOzDOWACylLVGWXJiKnHeBp
        dVVvyCBhPSTDgvNP3OcZSud+PowCIIg=
X-Google-Smtp-Source: ABdhPJx4WNr7LNNV5hPHVGAFveV7OCIwQ7ktNnCffZxzlm/mwkVJnyOEkVZf7ryLkCJBg4esbwWhpg==
X-Received: by 2002:a17:90a:7847:: with SMTP id y7mr1830356pjl.65.1616461489539;
        Mon, 22 Mar 2021 18:04:49 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:49 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 31/46] KVM: PPC: Book3S HV P9: Read machine check registers while MSR[RI] is 0
Date:   Tue, 23 Mar 2021 11:02:50 +1000
Message-Id: <20210323010305.1045293-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index 52f844a06899..98e5ae897fad 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3551,11 +3551,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -3598,6 +3603,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			hvregs.vcpu_token = vcpu->vcpu_id;
 		}
 		hvregs.hdec_expiry = time_limit;
+		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
+		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
 					  __pa(&vcpu->arch.regs));
 		kvmhv_restore_hv_return_state(vcpu, &hvregs);
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index c1105a4cc9b7..a7e5628ac36c 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -137,6 +137,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	s64 hdec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
+	bool ri_set;
 	unsigned long msr = mfmsr();
 	int trap;
 	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
@@ -208,9 +209,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
 	vcpu->arch.ceded = 0;
@@ -236,6 +234,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -253,7 +258,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
@@ -263,6 +274,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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

