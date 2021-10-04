Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8905421382
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhJDQEh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJDQEg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99053C061746
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so4286048pjw.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RII5FvLpORli3bjpPpeJOyKoOvf8B8BgGYRmW8rRY0=;
        b=ogBhi8K7JWbFOHugXDNIy0mCsX74QETMzkHtBAU4TS5z/WBBp7AEOtgCWeBXb/FuD4
         t/4SoXWsIj7b/Ot9OFQsW/vwSTzuXULp62CLORRj0ztmfGeClINdPt5pO5bgWnLj95rd
         1Q6Zjs9JHuIiy5VlE9Or9EdGGu2KkhJnOtXFXmZY1lS7U/9gjjKW5BSi2TN7d3DtMVCc
         c1a/5S+rPl10iLJQBAfIwl/tlg29j8y4Pdv6lyYvQwhn7k8lV0k+xVRHdtKUamHcKLkL
         GaFKD0Enrefa/1SdaW2j5Xa5KxiU7RoGh8AnznvzBGA1XH6qmxpecvyfRSCzoudkqCZc
         XQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RII5FvLpORli3bjpPpeJOyKoOvf8B8BgGYRmW8rRY0=;
        b=Cuq3f5F2fpsEQIB2DqqNDHB7Uq1jEZKowmgBeA4OGoWWTtLbAUOCLTSBhBXkUVUnun
         zsotiS6LKCNKsqQy7oWb35FIykgc4AJtoL3CB6/5/yRRG+zRTydOQc4dqUQI4JAuYusL
         bqpQIvQo+qpHVirQI1APrSBmGQAIU60T4SdI7Qv2RfnWD5/iVvs0ivgZgm7HHPUGReSI
         Aw8pXt5778Dq1H4yHch/4Moe+tk1qxQueqMqt8SHPlzHd+c2iOU5Y8ETEeF7Ami5A3F4
         fHZt52vew4tTmRH0jBUlRZDXGVWi6cWf0qrCa5YiCMEIEdefWpHPYFhnZQDrvdxcqqif
         k5Mw==
X-Gm-Message-State: AOAM533O2Nix+1gjNE+bN8apv0ROGoBcThyh6hvMY0foDPot5fJOkW7K
        so/DpCrzAykV5AedvjYIrRzsM5cYW+s=
X-Google-Smtp-Source: ABdhPJyZr4aLAllbcw3R0EGHzxDozwzPPqgm9xoViRYfVq+Epl71H80xIAMWDGyykTi+rPnpzUd1KQ==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr30080478pjb.200.1633363366959;
        Mon, 04 Oct 2021 09:02:46 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 44/52] KVM: PPC: Book3S HV P9: Improve mfmsr performance on entry
Date:   Tue,  5 Oct 2021 02:00:41 +1000
Message-Id: <20211004160049.1338837-45-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rearrange the MSR saving on entry so it does not follow the mtmsrd to
disable interrupts, avoiding a possible RAW scoreboard stall.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |  2 +
 arch/powerpc/kvm/book3s_hv.c             | 18 ++-----
 arch/powerpc/kvm/book3s_hv_p9_entry.c    | 66 +++++++++++++++---------
 3 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 0a319ed9c2fd..96f0fda50a07 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -154,6 +154,8 @@ static inline bool kvmhv_vcpu_is_radix(struct kvm_vcpu *vcpu)
 	return radix;
 }
 
+unsigned long kvmppc_msr_hard_disable_set_facilities(struct kvm_vcpu *vcpu, unsigned long msr);
+
 int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb);
 
 #define KVM_DEFAULT_HPT_ORDER	24	/* 16MB HPT by default */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 342b4f125d03..0bbef4587f41 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3878,6 +3878,8 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	s64 dec;
 	int trap;
 
+	msr = mfmsr();
+
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -3888,24 +3890,10 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	 */
 	host_psscr = mfspr(SPRN_PSSCR_PR);
 
-	hard_irq_disable();
+	kvmppc_msr_hard_disable_set_facilities(vcpu, msr);
 	if (lazy_irq_pending())
 		return 0;
 
-	/* MSR bits may have been cleared by context switch */
-	msr = 0;
-	if (IS_ENABLED(CONFIG_PPC_FPU))
-		msr |= MSR_FP;
-	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		msr |= MSR_VEC;
-	if (cpu_has_feature(CPU_FTR_VSX))
-		msr |= MSR_VSX;
-	if ((cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
-			(vcpu->arch.hfscr & HFSCR_TM))
-		msr |= MSR_TM;
-	msr = msr_check_and_set(msr);
-
 	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
 		msr = mfmsr(); /* TM restore can update msr */
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a45ba584c734..646f487ebf97 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -632,6 +632,44 @@ static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
 	}
 }
 
+unsigned long kvmppc_msr_hard_disable_set_facilities(struct kvm_vcpu *vcpu, unsigned long msr)
+{
+	unsigned long msr_needed = 0;
+
+	msr &= ~MSR_EE;
+
+	/* MSR bits may have been cleared by context switch so must recheck */
+	if (IS_ENABLED(CONFIG_PPC_FPU))
+		msr_needed |= MSR_FP;
+	if (cpu_has_feature(CPU_FTR_ALTIVEC))
+		msr_needed |= MSR_VEC;
+	if (cpu_has_feature(CPU_FTR_VSX))
+		msr_needed |= MSR_VSX;
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+			(vcpu->arch.hfscr & HFSCR_TM))
+		msr_needed |= MSR_TM;
+
+	/*
+	 * This could be combined with MSR[RI] clearing, but that expands
+	 * the unrecoverable window. It would be better to cover unrecoverable
+	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
+	 *
+	 * Much more difficult and less worthwhile to combine with IR/DR
+	 * disable.
+	 */
+	if ((msr & msr_needed) != msr_needed) {
+		msr |= msr_needed;
+		__mtmsrd(msr, 0);
+	} else {
+		__hard_irq_disable();
+	}
+	local_paca->irq_happened |= PACA_IRQ_HARD_DIS;
+
+	return msr;
+}
+EXPORT_SYMBOL_GPL(kvmppc_msr_hard_disable_set_facilities);
+
 int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr, u64 *tb)
 {
 	struct p9_host_os_sprs host_os_sprs;
@@ -665,6 +703,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ceded = 0;
 
+	/* Save MSR for restore, with EE clear. */
+	msr = mfmsr() & ~MSR_EE;
+
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
 	host_psscr = mfspr(SPRN_PSSCR_PR);
@@ -686,35 +727,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
-	/*
-	 * This could be combined with MSR[RI] clearing, but that expands
-	 * the unrecoverable window. It would be better to cover unrecoverable
-	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
-	 *
-	 * Much more difficult and less worthwhile to combine with IR/DR
-	 * disable.
-	 */
-	hard_irq_disable();
+	msr = kvmppc_msr_hard_disable_set_facilities(vcpu, msr);
 	if (lazy_irq_pending()) {
 		trap = 0;
 		goto out;
 	}
 
-	/* MSR bits may have been cleared by context switch */
-	msr = 0;
-	if (IS_ENABLED(CONFIG_PPC_FPU))
-		msr |= MSR_FP;
-	if (cpu_has_feature(CPU_FTR_ALTIVEC))
-		msr |= MSR_VEC;
-	if (cpu_has_feature(CPU_FTR_VSX))
-		msr |= MSR_VSX;
-	if ((cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
-			(vcpu->arch.hfscr & HFSCR_TM))
-		msr |= MSR_TM;
-	msr = msr_check_and_set(msr);
-	/* Save MSR for restore. This is after hard disable, so EE is clear. */
-
 	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
 		msr = mfmsr(); /* MSR may have been updated */
 
-- 
2.23.0

