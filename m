Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16998421359
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhJDQD0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbhJDQDZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:25 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80CEC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r201so11051312pgr.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnsBS3bJmiwyDILnLMDKqMSh12LsJybZQv4a3uQmWU0=;
        b=ier9SG47V2QEjoV7udjqiJV9XQ+1xZBLqRtJLDwh1XzkoIHsW21tI910+01FCikc3g
         rSyi6JNrNdHtxnA/4VWLLHW8rJl6Zia/mRqgub+ATVNoqoo7BX7J2e7uFchZtVEG0JbF
         P/yVoIjH7hIMc9jH02JYFzLmktaxMvTJBNr9bmaz0dF6HOhWHqWyFiXzpiEDTwX93UCp
         ViPbH2Kkv6dowtP1OdE4HiJD+WCPdVLWSnSpV+nxrjl8k6xjzsT3vvmkbNXp5Zv6nNpg
         5YpFR67RrtL89km4UxMtOwEGjvvLr7uJx1DwVHILEuUc0MkgZc/jyQqzOxiIzQDyYYki
         nm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnsBS3bJmiwyDILnLMDKqMSh12LsJybZQv4a3uQmWU0=;
        b=3HeqRCCNd4KG40HNeXPZM6r/f9UshEPju9DgT7iD/iRQky6bSkaHVFIx/5hwk8Cnns
         zp+UwR3bIAAq5DW9vi5jguAw6NRlBBn+hoHXOzRllqzwk0Q1ELgzWw6q9YOKnH0FN0Ia
         y48oxwPyfGutQKWb61Ru/cEZb9g117QEt2LUo7oqaN+p3KM6lmMwW4UILhOzht2CxTnW
         2p96L5A5EeX2sg+AYIKmwiBH3zu/bgfIshSLS+DIpjPUCPmpLwbcRtXXJGw/V298Vo2s
         e2kVq2diuI5PeW5GzXAtMC/JyM0gef6715fFYbJA5C9Rk/rc7bE6UAWhPHAeGQe/x4Os
         /oSg==
X-Gm-Message-State: AOAM530+UNC7yMee1z1pp+yYJUXn2jL0ndfeF9128UGLf24FGDRw4KMD
        m2sFHHcfNQAHVj+fe1bh7Tx00SvxCAk=
X-Google-Smtp-Source: ABdhPJwqg5mhD37PJ8cnY1xrw2QpqLxWWyWjts097dXtVMP5WqFX0+tuLDMVI7LBvqag7YKvbYQQRQ==
X-Received: by 2002:a63:2a07:: with SMTP id q7mr11513121pgq.221.1633363296314;
        Mon, 04 Oct 2021 09:01:36 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:36 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Subject: [PATCH v3 14/52] KVM: PPC: Book3S HV P9: Factor PMU save/load into context switch functions
Date:   Tue,  5 Oct 2021 02:00:11 +1000
Message-Id: <20211004160049.1338837-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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

Reviewed-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 61 +++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 211184544599..29a8c770c4a6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3817,7 +3817,8 @@ static void freeze_pmu(unsigned long mmcr0, unsigned long mmcra)
 	isync();
 }
 
-static void save_p9_host_pmu(struct p9_host_os_sprs *host_os_sprs)
+static void switch_pmu_to_guest(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
 {
 	if (ppc_get_pmu_inuse()) {
 		/*
@@ -3851,10 +3852,21 @@ static void save_p9_host_pmu(struct p9_host_os_sprs *host_os_sprs)
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
@@ -3879,7 +3891,8 @@ static void load_p9_guest_pmu(struct kvm_vcpu *vcpu)
 	/* No isync necessary because we're starting counters */
 }
 
-static void save_p9_guest_pmu(struct kvm_vcpu *vcpu)
+static void switch_pmu_to_host(struct kvm_vcpu *vcpu,
+				struct p9_host_os_sprs *host_os_sprs)
 {
 	struct lppaca *lp;
 	int save_pmu = 1;
@@ -3922,10 +3935,15 @@ static void save_p9_guest_pmu(struct kvm_vcpu *vcpu)
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
@@ -4058,8 +4076,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
-	save_p9_host_pmu(&host_os_sprs);
-
 	kvmppc_subcore_enter_guest();
 
 	vc->entry_exit_map = 1;
@@ -4076,19 +4092,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4217,14 +4221,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4233,8 +4230,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
-	load_p9_host_pmu(&host_os_sprs);
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
-- 
2.23.0

