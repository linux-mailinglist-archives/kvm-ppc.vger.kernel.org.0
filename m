Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E154A42137B
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhJDQEZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbhJDQEU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBD8C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q23so14901738pfs.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QhuEbcyyjvEHV1sroWyOcCg/EId/n5w8MxW9uQ4jdko=;
        b=MNKKpyfNHLMOI8glb86UjO1gY/+U0Jk7MzNXswi9yKdef1zXYTZvaQowvcmj9V1Aqz
         ipQsjDnK9VI3wyRTCJlbkooKhN5kXAUpD7/pFFOtPolC0NSg0x93x6KAf+0L75Sd0yBX
         SpGm905Q9PUoW7QnRbxMHrFmCTgaKqFZi1Db/R1ZHXcmNu1PScSwyxcwooFJ8u78vibw
         1CX1BEs+YxV29R3OHIOEs1d83xAJJrGODVv99z5dPsdYqCCZH3KbaUtH6KGok/znW/yp
         JoWmYg8EK09GPZB/LOVsZojQOL98ayqxpwi9UyS1ZxrPvqgw+mX+sB5MCJQIKz1j9TkJ
         AFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QhuEbcyyjvEHV1sroWyOcCg/EId/n5w8MxW9uQ4jdko=;
        b=iSLbDIpjke4ICGkdP0Q6WndpC5JQDuqQZkMTvsyQLaRsZkJHYhpXN5Py3/rnI4wlU0
         MgRvsgwlUXswt/+nalERGFErKDxeWOtkZCJGCbnx7EIx1xSaiAk5jm5CECAydzqVXrvQ
         nnFa8uAvA3O71osC3mcYRZoI5b/h36m3SRr1gzBhBdGoWKiOezT/AnrEH0L/q2pYkPCA
         2KQvhXXmYZNj/dDAWt3plVBboqFMSO06z7Uzafc572vYV/alWp1sgNzHL1NUvUamwF/C
         IHy16HAFPMkR20U6Z1U5cIc1Mi1/d4jBg5jrvWj+uRUQvNriHexJGRy0xV3fFNTqn2zG
         ZOeQ==
X-Gm-Message-State: AOAM531Pbqx3oquM0aP6Jz+5Lx3ey/Kx1zMUUCitpXSnC0s95vqbtIKG
        zyuxLdFZqbDU7BjNNNEHJIkWSxgOqmY=
X-Google-Smtp-Source: ABdhPJx0xmL3OnSeN0aiB2a8LGaWnPsl/gFU0IR57UiyNJzFlWJ0pvzG2LMGL2uIs8IRVhAZp8gBbw==
X-Received: by 2002:a05:6a00:cc9:b0:44c:2305:50de with SMTP id b9-20020a056a000cc900b0044c230550demr15939524pfv.79.1633363351338;
        Mon, 04 Oct 2021 09:02:31 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:31 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 37/52] KVM: PPC: Book3S HV P9: Demand fault TM facility registers
Date:   Tue,  5 Oct 2021 02:00:34 +1000
Message-Id: <20211004160049.1338837-38-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/kvm_host.h   |  3 +++
 arch/powerpc/kvm/book3s_hv.c          | 26 ++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 15 +++++++++++----
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 9c63eff35812..92925f82a1e3 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -580,6 +580,9 @@ struct kvm_vcpu_arch {
 	ulong ppr;
 	u32 pspb;
 	u8 load_ebb;
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	u8 load_tm;
+#endif
 	ulong fscr;
 	ulong shadow_fscr;
 	ulong ebbhr;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 070469867bf5..e9037f7a3737 100644
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
@@ -1739,6 +1749,8 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 				r = kvmppc_pmu_unavailable(vcpu);
 			if (cause == FSCR_EBB_LG)
 				r = kvmppc_ebb_unavailable(vcpu);
+			if (cause == FSCR_TM_LG)
+				r = kvmppc_tm_unavailable(vcpu);
 		}
 		if (r == EMULATE_FAIL) {
 			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
@@ -2783,9 +2795,9 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
 
 	/*
-	 * PM, EBB is demand-faulted so start with it clear.
+	 * PM, EBB, TM are demand-faulted so start with it clear.
 	 */
-	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB);
+	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB | HFSCR_TM);
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
@@ -3855,8 +3867,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
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
 
@@ -4582,8 +4595,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
index 929a7c336b09..8499e8a9ca8f 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -310,7 +310,7 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 		if (MSR_TM_ACTIVE(guest_msr)) {
 			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
 			ret = true;
-		} else {
+		} else if (vcpu->arch.hfscr & HFSCR_TM) {
 			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
 			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
 			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
@@ -346,10 +346,16 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
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
 #endif
@@ -641,8 +647,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

