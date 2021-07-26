Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DEA3D51B3
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhGZDLA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDK7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F48FC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso17852605pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPqcBmWn1RQ5ScRaMQkK0PgFL0uqvjQZGq+S5mHe7GY=;
        b=LQ8LcWXESFN7E7UDjn68MfXx3Rm2glVyKpczCyDBpsllBugNqgH5unWXyTQmcdEhN/
         r/Ikvb4S/5WIjBs5EdTt/QrweUp0MF78vQaBBhzOq+kS2nrcUPoPXG8HvIqI3owQ71zN
         ZYY8jPzHJsXw/JNY4BdUIsQp9e+4JCzqdwd/Hvb8yd1wHelhN/YmkIcjs5g112l8CDx4
         ojRjeuecSE7kA2msC0notNCv3V21i5CvHubBMzABd58kK3hEfRCxuA79/XXIDpQ9yjt7
         0cDBr5XigENUfhRyJ8wizS3n+nmbsoxWfAfWQfgXoOXvtLeIhxQZboldizEXhQJ/OQD0
         VImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPqcBmWn1RQ5ScRaMQkK0PgFL0uqvjQZGq+S5mHe7GY=;
        b=PqUqoSFA7A99Hb2KkM1y/i1e3T7Nth4Ft66TapSjQ+/pUpHxCs/HX1gt4IXCGMjbv2
         q0a8AxZXsRE4cuWyXmC8tn5N9tdr1g4BkLxMKbjA2gj9ShPBieZydwDg69RKYbaMwNaP
         F1HKvUsVmtTIFvwd3lpH5qnYqLbI2v0A1elgAT8MYAj0pwdDv6Q15uAVzDgCBz8CG9oc
         suxrlWiaNBZ9iTM4fxC3omx7ix9ZfbrzJ+n3CiVb12Ks3ZcfPEa3TnomynYh3NVWWLPO
         sEbBuR68dqHxqTVfJ4CCjfSQGK0zI+rPsJf3hf63GZT2bUdAlNrx5fQr30CuYH4Drgut
         OpPw==
X-Gm-Message-State: AOAM533qxvfU1cYnD9QRpEBiQ3BeWLRCY0YPBUTOcL62x2xGbYrfCEZ9
        4UBuYrYkLIWsPD4GhRV/qOtWoMxuT4E=
X-Google-Smtp-Source: ABdhPJx9wM3iZBEIyRCfm4LJw+CiX3l99fEWgebiSSIYaGlO+n8yORHHgkzIx2S+of1qLJjr2hNhKg==
X-Received: by 2002:a63:1205:: with SMTP id h5mr16044475pgl.204.1627271487880;
        Sun, 25 Jul 2021 20:51:27 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 18/55] KVM: PPC: Book3S HV P9: Factor PMU save/load into context switch functions
Date:   Mon, 26 Jul 2021 13:49:59 +1000
Message-Id: <20210726035036.739609-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than guest/host save/retsore functions, implement context switch
functions that take care of details like the VPA update for nested.

The reason to split these kind of helpers into explicit save/load
functions is mainly to schedule SPR access nicely, but PMU is a special
case where the load requires mtSPR (to stop counters) and other
difficulties, so there's less possibility to schedule those nicely. The
SPR accesses also have side-effects if the PMU is running, and in later
changes we keep the host PMU running as long as possible so this code
can be better profiled, which also complicates scheduling.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 61 +++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index d20b579ddcdf..091b67ef6eba 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3790,7 +3790,8 @@ static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
 	isync();
 }
 
-static void save_p9_host_pmu(struct p9_host_os_sprs *host_os_sprs)
+static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
 {
 	if (ppc_get_pmu_inuse()) {
 		/*
@@ -3824,10 +3825,21 @@ static void save_p9_host_pmu(struct p9_host_os_sprs *host_os_sprs)
 			host_os_sprs->sier3 = mfspr(SPRN_SIER3);
 		}
 	}
-}
 
-static void load_p9_guest_pmu(struct kvm_vcpu *vcpu)
-{
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		if (vcpu->arch.vpa.pinned_addr) {
+			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
+		} else {
+			get_lppaca()->pmcregs_in_use = 1;
+		}
+		barrier();
+	}
+#endif
+
+	/* load guest */
 	mtspr(SPRN_PMC1, vcpu->arch.pmc[0]);
 	mtspr(SPRN_PMC2, vcpu->arch.pmc[1]);
 	mtspr(SPRN_PMC3, vcpu->arch.pmc[2]);
@@ -3852,7 +3864,8 @@ static void load_p9_guest_pmu(struct kvm_vcpu *vcpu)
 	/* No isync necessary because we're starting counters */
 }
 
-static void save_p9_guest_pmu(struct kvm_vcpu *vcpu)
+static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
 {
 	struct lppaca *lp;
 	int save_pmu = 1;
@@ -3887,10 +3900,15 @@ static void save_p9_guest_pmu(struct kvm_vcpu *vcpu)
 	} else {
 		freeze_pmu(mfspr(SPRN_MMCR0), mfspr(SPRN_MMCRA));
 	}
-}
 
-static void load_p9_host_pmu(struct p9_host_os_sprs *host_os_sprs)
-{
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
+
 	if (ppc_get_pmu_inuse()) {
 		mtspr(SPRN_PMC1, host_os_sprs->pmc1);
 		mtspr(SPRN_PMC2, host_os_sprs->pmc2);
@@ -4019,8 +4037,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
-	save_p9_host_pmu(&host_os_sprs);
-
 	kvmppc_subcore_enter_guest();
 
 	vc->entry_exit_map = 1;
@@ -4037,19 +4053,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
-#ifdef CONFIG_PPC_PSERIES
-	if (kvmhv_on_pseries()) {
-		barrier();
-		if (vcpu->arch.vpa.pinned_addr) {
-			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
-			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
-		} else {
-			get_lppaca()->pmcregs_in_use = 1;
-		}
-		barrier();
-	}
-#endif
-	load_p9_guest_pmu(vcpu);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	load_fp_state(&vcpu->arch.fp);
@@ -4178,14 +4182,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.vpa.dirty = 1;
 	}
 
-	save_p9_guest_pmu(vcpu);
-#ifdef CONFIG_PPC_PSERIES
-	if (kvmhv_on_pseries()) {
-		barrier();
-		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
-		barrier();
-	}
-#endif
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
@@ -4194,8 +4191,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
-	load_p9_host_pmu(&host_os_sprs);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

