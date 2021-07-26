Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FB03D51CD
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhGZDLw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhGZDLw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB428C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:20 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c11so9967963plg.11
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tttWjAtBQpkJ27E6dJTO6j5NLUnzZ0bw5ZHHFoKnVA0=;
        b=e8ofBwpRuix3BZnZ/sCmRdVBeUzScf3k1D1QdscTeSA1CRauJ46tQxlDoaY+vg61W4
         bwu3sltOwRzhmAUtqpYH4q9b7zd21lAQB3zWBwr35Izry7wgOLBV2PWjyEKpCnYr9jk+
         3z17gj+XN6WIs60U05ZTsaFeKpn0GlHXrxrg1YJSM74dyi3d4sMpu5IP6FqkfxN003pF
         gLdLUK5RE2PrQJELSUjs6lKp7pSFMqbzmmb2NWjra/UR4NPQ9ThoXgBhsRiov2tXZgxu
         JECRfoW28XaYnD9aoNkuMw2iNvr5bfCoVDrwjcjjtUAEd+essDE47dhXpND5v2Gccp+R
         oI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tttWjAtBQpkJ27E6dJTO6j5NLUnzZ0bw5ZHHFoKnVA0=;
        b=OgFD2A78hVRLPo/MiEXM1/RmOn0rNOzeA/9sGYX63tWM1wX5O+L5BfOxyTi8A6e412
         9fQOYG6CVIHE5afdOYETennSeOrphKQVzW5LzR6OHTF6aJisryxsYSV5fliGvjFSjUtk
         rNMlRcWnlWdNhzMqqbWc5ZDSGDyXBW0PefNjbE+HUwRPiUi2BPsezkw2uYfTr16rID4o
         BBa18Spno+gmXKsXkIwS3xQgmlzgvUYGnSOch4oy9PriSoQ/5u5z2vCpExtmb8JwuUAj
         Ti8vjf34SzjtgE0RWxDNSHk4EXSMnS5WDeF1WzSpJxPVAzrrDXlgBhm311BOeN4qcyeo
         TAwA==
X-Gm-Message-State: AOAM533ljo6WZk3dpYPLJU4tXLpWg6VaMymkVtrjNfRdhYATDflFJiO8
        1OhTDOYQiezuN4jugvUAe0gfNSCq9h0=
X-Google-Smtp-Source: ABdhPJx0wIzImavcgz6WNC2kw85/dKnC2rstlM3M6u9aU2Db3EM8upzVhqbzxz+TW2P56OtHe3NI5Q==
X-Received: by 2002:a17:902:e54f:b029:12b:55c9:3b48 with SMTP id n15-20020a170902e54fb029012b55c93b48mr13020127plf.45.1627271540148;
        Sun, 25 Jul 2021 20:52:20 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 41/55] KVM: PPC: Book3S HV P9: Demand fault TM facility registers
Date:   Mon, 26 Jul 2021 13:50:22 +1000
Message-Id: <20210726035036.739609-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h   |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 26 ++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 25 +++++++++++++++++--------
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1c00c4a565f5..74ee3a5b110e 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -581,6 +581,7 @@ struct kvm_vcpu_arch {
 	ulong ppr;
 	u32 pspb;
 	u8 load_ebb;
+	u8 load_tm;
 	ulong fscr;
 	ulong shadow_fscr;
 	ulong ebbhr;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dd8199a423cf..5b2114c00c43 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1451,6 +1451,16 @@ static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int kvmppc_tm_unavailable(struct kvm_vcpu *vcpu)
+{
+	if (!(vcpu->arch.hfscr_permitted & HFSCR_TM))
+		return EMULATE_FAIL;
+
+	vcpu->arch.hfscr |= HFSCR_TM;
+
+	return RESUME_GUEST;
+}
+
 static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				 struct task_struct *tsk)
 {
@@ -1747,6 +1757,8 @@ XXX benchmark guest exits
 				r = kvmppc_pmu_unavailable(vcpu);
 			if (cause == FSCR_EBB_LG)
 				r = kvmppc_ebb_unavailable(vcpu);
+			if (cause == FSCR_TM_LG)
+				r = kvmppc_tm_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -2763,9 +2775,9 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
 
 	/*
-	 * PM, EBB is demand-faulted so start with it clear.
+	 * PM, EBB, TM are demand-faulted so start with it clear.
 	 */
-	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB);
+	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB | HFSCR_TM);
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
@@ -3835,8 +3847,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
 
@@ -4552,8 +4565,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index f68a3d107d04..db5eb83e26d1 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -295,10 +295,11 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 {
 	bool ret = false;
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+		       (vcpu->arch.hfscr & HFSCR_TM)) {
 		unsigned long guest_msr = vcpu->arch.shregs.msr;
-		if (MSR_TM_ACTIVE(guest_msr)) {
+		if (MSR_TM_ACTIVE(guest_msr) || local_paca->kvm_hstate.fake_suspend) {
 			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
 			ret = true;
 		} else {
@@ -330,15 +331,22 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 #endif
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+	if ((cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
+		       (vcpu->arch.hfscr & HFSCR_TM)) {
 		unsigned long guest_msr = vcpu->arch.shregs.msr;
-		if (MSR_TM_ACTIVE(guest_msr)) {
+		if (MSR_TM_ACTIVE(guest_msr) || local_paca->kvm_hstate.fake_suspend) {
 			kvmppc_save_tm_hv(vcpu, guest_msr, true);
 		} else {
 			vcpu->arch.texasr = mfspr(SPRN_TEXASR);
 			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
 			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
+
+			if (!vcpu->arch.nested) {
+				vcpu->arch.load_tm++; /* see load_ebb comment */
+				if (!vcpu->arch.load_tm)
+					vcpu->arch.hfscr &= ~HFSCR_TM;
+			}
 		}
 	}
 }
@@ -629,8 +637,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

