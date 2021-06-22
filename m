Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50013B0216
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhFVLBh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642CDC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l11so7528714pji.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQDf5ymbUokqKmHzn5bbmlBykivDsgLCRJlQ36KLUmc=;
        b=XJ8S7belHbzKE6HhD0jARY/4EvdE3hmuUD7FKErxhljP/jLCDT5cVvN5bNEFN/rAJy
         9mkllKNyw/6uorPfmBFvgFtTCfz1YK+VLPDfrYEu+/8BxqXdTQj7Y98BBiLS33gyASyi
         zKiSsnBKy6pc1htJUoj5+Kxa6sUYIj7cWLE8mrlUmE1a/5v7+vWsP5DqB+wnq17bOCp2
         W36G54KMnAsYtjJCAXbgyF+ph2gKZDyiw1/Qgo8GbHcjhMEVynZvfqHUWJLFPmTiYXsX
         Su1EO3u/uyiisz4+mOiIV3aTrfE4k+yRUoPM7TKol57LzKQEzU2wkp+CAo7+LmqQSIVz
         P25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQDf5ymbUokqKmHzn5bbmlBykivDsgLCRJlQ36KLUmc=;
        b=BHwc1TfTy0fykypLijSletE5BbwuVr7bK8Ywj8yqX3kkhskD4pERL+xpjMIjzNKzzZ
         X6cBmPHo5yik7uYKhc0ZOxDKu8pgvAB+CGVktqE24jKWyh6OYXj2ccl0YXCq92FLx2hT
         o1nrPFMsF09BJuT0IxqC+idsELSBbYS/yeeaobVA4B+W7wx+8kL2ABOnm/B/kzfoUdup
         DIaAGvhlr4my8MfxOQjcVNMNCtGMcakeQFAs8MPeNmJ7IpMXE/lm4Ua/n8ZZkt5zTfeO
         pbqzo1M9R4EMAIjSv6V+Tj3LPX7GedFCjJPXpvOHzifnxJYbA79xytV9K4qTT9A4/1n1
         cQ4Q==
X-Gm-Message-State: AOAM5336Er3Sw209otFtcweQd6l7PFH0QRc1qghFo5XpW1839jfxfl4k
        VAh2h3sYVhgQX+tMG7Q+GYoJQINDvBg=
X-Google-Smtp-Source: ABdhPJxRcooqquD0EPs0oZYwhh6tNDuesL+qj1fO4uhBBAkLY2SUXSYQxWx+WwXBzvo2KEm0aROG3g==
X-Received: by 2002:a17:90b:4905:: with SMTP id kr5mr3184880pjb.161.1624359560867;
        Tue, 22 Jun 2021 03:59:20 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 35/43] KVM: PPC: Book3S HV P9: Demand fault TM facility registers
Date:   Tue, 22 Jun 2021 20:57:28 +1000
Message-Id: <20210622105736.633352-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use HFSCR facility disabling to implement demand faulting for TM, with
a hysteresis counter similar to the load_fp etc counters in context
switching that implement the equivalent demand faulting for userspace
facilities.

This speeds up guest entry/exit by avoiding the register save/restore
when a guest is not frequently using them. When a guest does use them
often, there will be some additional demand fault overhead, but these
are not commonly used facilities.

-304 cycles (6681) POWER9 virt-mode NULL hcall with the previous patch

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h   |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 21 +++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_nested.c   |  2 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 18 ++++++++++++------
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index bee95106c1f2..d79f0b1b1578 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -586,6 +586,7 @@ struct kvm_vcpu_arch {
 	ulong ppr;
 	u32 pspb;
 	u8 load_ebb;
+	u8 load_tm;
 	ulong fscr;
 	ulong shadow_fscr;
 	ulong ebbhr;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 99e9da078e7d..2430725f29f7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1373,6 +1373,13 @@ static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvmppc_tm_unavailable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hfscr |= HFSCR_TM;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1654,6 +1661,8 @@ XXX benchmark guest exits
 				r = kvmppc_pmu_unavailable(vcpu);
 			if (cause == FSCR_EBB_LG)
 				r = kvmppc_ebb_unavailable(vcpu);
+			if (cause == FSCR_TM_LG)
+				r = kvmppc_tm_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -1775,6 +1784,8 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 			r = kvmppc_pmu_unavailable(vcpu);
 		if (cause == FSCR_EBB_LG && (vcpu->arch.nested_hfscr & HFSCR_EBB))
 			r = kvmppc_ebb_unavailable(vcpu);
+		if (cause == FSCR_TM_LG && (vcpu->arch.nested_hfscr & HFSCR_TM))
+			r = kvmppc_tm_unavailable(vcpu);
 
 		if (r == EMULATE_FAIL)
 			r = RESUME_HOST;
@@ -3737,8 +3748,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 		msr |= MSR_VEC;
 	if (cpu_has_feature(CPU_FTR_VSX))
 		msr |= MSR_VSX;
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+			(vcpu->arch.hfscr & HFSCR_TM))
 		msr |= MSR_TM;
 	msr = msr_check_and_set(msr);
 
@@ -4453,8 +4465,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		msr |= MSR_VEC;
 	if (cpu_has_feature(CPU_FTR_VSX))
 		msr |= MSR_VSX;
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+			(vcpu->arch.hfscr & HFSCR_TM))
 		msr |= MSR_TM;
 	msr = msr_check_and_set(msr);
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index ee8668f056f9..5a534f7924f2 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -168,7 +168,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	 * but preserve the interrupt cause field and facilities that might
 	 * be disabled for demand faulting in the L1.
 	 */
-	hr->hfscr &= (HFSCR_INTR_CAUSE | HFSCR_PM | HFSCR_EBB |
+	hr->hfscr &= (HFSCR_INTR_CAUSE | HFSCR_PM | HFSCR_TM | HFSCR_EBB |
 			vcpu->arch.hfscr);
 
 	/* Don't let data address watchpoint match in hypervisor state */
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index cf41261daa97..653f2765a399 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -284,8 +284,9 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 void load_vcpu_state(struct kvm_vcpu *vcpu,
 			   struct p9_host_os_sprs *host_os_sprs)
 {
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+		       (vcpu->arch.hfscr & HFSCR_TM)) {
 		unsigned long msr = vcpu->arch.shregs.msr;
 		if (MSR_TM_ACTIVE(msr)) {
 			kvmppc_restore_tm_hv(vcpu, msr, true);
@@ -316,8 +317,9 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 #endif
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+		       (vcpu->arch.hfscr & HFSCR_TM)) {
 		unsigned long msr = vcpu->arch.shregs.msr;
 		if (MSR_TM_ACTIVE(msr)) {
 			kvmppc_save_tm_hv(vcpu, msr, true);
@@ -326,6 +328,9 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
 			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
 		}
+		vcpu->arch.load_tm++; /* see load_ebb comment for details */
+		if (!vcpu->arch.load_tm)
+			vcpu->arch.hfscr &= ~HFSCR_TM;
 	}
 }
 EXPORT_SYMBOL_GPL(store_vcpu_state);
@@ -615,8 +620,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		msr |= MSR_VEC;
 	if (cpu_has_feature(CPU_FTR_VSX))
 		msr |= MSR_VSX;
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+			(vcpu->arch.hfscr & HFSCR_TM))
 		msr |= MSR_TM;
 	msr = msr_check_and_set(msr);
 	/* Save MSR for restore. This is after hard disable, so EE is clear. */
-- 
2.23.0

