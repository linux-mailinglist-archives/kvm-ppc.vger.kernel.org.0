Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450083E956B
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhHKQEH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbhHKQEH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:07 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC6FC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:43 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so5725741pjb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QS45qVH5Cx5QBJ0EQfJvzDyNJmrwCSYLhKs8WHEt8g8=;
        b=ssTJNqw5srUEVdEsF1m6NneCoE8YvHq7t49t5hK6sJZb38rdf8ISB3TN0yPgMoPevW
         6HwlL4yF2sOfEJCn+wcJkKYOHYfwBu4DFWxFDt0YgTzo6o69ABNdJTkUpMpAaOyU3D/9
         kssbHa5L83lUxA5AsRA3D3Hh8apV+4R+9Dg438sNTtgn9W/Ot6Q/t3c6co3JVFm/aSj2
         nrMWicdYERFxAkoZplNSQttPidCqPIc5QWF+Dsl3a7SuTlZxiuu4N0cc87FQ5ug/hMS2
         BZpBvhEFszzbPvNNJ4GaQ7LZHfC6Gy6OFCFtphL2+QW/DF8bJa1bSa0EKGjSL1n7yi7c
         We+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QS45qVH5Cx5QBJ0EQfJvzDyNJmrwCSYLhKs8WHEt8g8=;
        b=i/DXeB8jGB/GWG52ISxolRTALKIGmCwm2NqtA2wjOqhbDeQgdONawRV4wJWvQ/ofb5
         +5uz3Tp4Q7O0TEXCFJh3LKIQNekpZI1FtT4/w7C5qvjPnWpk0AqHjQz2s2BDA3diM6rg
         NQoX6rCDzRbB9pbsTrebQk2CkJ0R01U1SyOlN6O8wc928H5RMgVXXj0uIbiTOQM1CDNO
         le8LHCMfpPIFPnFass9l+LlzEX0OTWgmAPGNVfLa5AdXdo38OFfwmHCDzs60918miJZf
         jRYPBXbcss2UID5Si0cHN5m/D7ROAsSZ3exAVP06h4WO+C5s4E7S+niMQv/UJbNTiE4q
         2iRA==
X-Gm-Message-State: AOAM532q+I0A3lKZptLIomy9cmgBtGcyGP0KnSIJa9uMa6KxhpVf+dGY
        5/OrbE3k9ELPvxCKrkDTG87dlu5+zhs=
X-Google-Smtp-Source: ABdhPJxFDlEH9pXyjRpwdQGyZRmCCT0u19ga5wLqxsbA3mHkdsK5n+ORLKmBvrC46c3lz8b9lhYHiw==
X-Received: by 2002:a63:fd54:: with SMTP id m20mr332686pgj.104.1628697822917;
        Wed, 11 Aug 2021 09:03:42 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 45/60] KVM: PPC: Book3S HV P9: Demand fault TM facility registers
Date:   Thu, 12 Aug 2021 02:01:19 +1000
Message-Id: <20210811160134.904987-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h   |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 26 ++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 15 +++++++++++----
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index c8d8bd90bf14..ef60f5cce251 100644
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
index 99d4fd84f0b2..2254101a7760 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1446,6 +1446,16 @@ static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
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
@@ -1742,6 +1752,8 @@ XXX benchmark guest exits
 				r = kvmppc_pmu_unavailable(vcpu);
 			if (cause == FSCR_EBB_LG)
 				r = kvmppc_ebb_unavailable(vcpu);
+			if (cause == FSCR_TM_LG)
+				r = kvmppc_tm_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -2786,9 +2798,9 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
 
 	/*
-	 * PM, EBB is demand-faulted so start with it clear.
+	 * PM, EBB, TM are demand-faulted so start with it clear.
 	 */
-	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB);
+	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB | HFSCR_TM);
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
@@ -3858,8 +3870,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
 
@@ -4575,8 +4588,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
index d196642061aa..ae5832a0836f 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -309,7 +309,7 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 		if (MSR_TM_ACTIVE(guest_msr)) {
 			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
 			ret = true;
-		} else {
+		} else if (vcpu->arch.hfscr & HFSCR_TM) {
 			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
 			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
 			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
@@ -343,10 +343,16 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 		unsigned long guest_msr = vcpu->arch.shregs.msr;
 		if (MSR_TM_ACTIVE(guest_msr)) {
 			kvmppc_save_tm_hv(vcpu, guest_msr, true);
-		} else {
+		} else if (vcpu->arch.hfscr & HFSCR_TM) {
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
@@ -637,8 +643,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

