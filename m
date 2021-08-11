Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE013E953F
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233542AbhHKQCc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3678EC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n12so2617146plf.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZIRwNA4o4bMaBzjGFVMA8AYhuzRrj44ddH2iqzIflE=;
        b=NAkhG87wcUA8ta7y0aFfdVUVX3SdYhHQr9/iNt3ExP81clRIWk8oPiBlBdzYCFt4nT
         IBwuXy66zdIxNboGkVy5XRpeE7SPgqDGW1W89yYBVdmItBW0ULOPx/g4VH6Rd5LGF5t+
         tr7l7J68qitSQMKXDuTART27BOA4wt1ChwU7ZRGPPgfqCbmh1Kci+7V/OQtUUbQ4COil
         dOfEZS9YU1tF1CuHDRxRxSsbPVUiR/1uLyznZ80q+9lguMRtZQK2hG8Pgu5Wd71vBwPy
         IghH+UoB/XTimidGlsDntDp09uQnYEXVThXq1JpM9QoqOk9KGPaI0Ch43hc11T+tNDSS
         +xaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZIRwNA4o4bMaBzjGFVMA8AYhuzRrj44ddH2iqzIflE=;
        b=NkzKCOa2/g7njR/854/LozI8hYEDne9bxvpflf/4EYP0D0gkdCS3EqkvXnCRQc1XRG
         9e5EJMXMtYDGmnwBWAfXVmRql4E9IXBpEK9DJAEHouRYYJpiJY0mL8TnbsCdTVSnCK1a
         SmT/gL0Bx5rB/h6NGUV+1nJdW3SzA9UEqnncIuokRneUOH6WGukPhVbX+l+ymaTIXTaH
         ErgcmWqdB9JvM+DOKewF6Lk7HepcrRB7H+0iYPvw6UKCm1ypJTDuRTanJYHyc14v1rXu
         0USXV72Hgmb2o4GaK42PMw/7h7uVbmjzPTnmBfk8vLpQdEjxfa6GyOgpAl770rvNIlWg
         RC9g==
X-Gm-Message-State: AOAM532cRCfsAGdb311elyGJLAXAOUQJFj2gMBPwA8sWcice7o9wCeBT
        94pKWCf9sEBeR5MvDTHFbFWzwdaJEH0=
X-Google-Smtp-Source: ABdhPJxXfhjv6ppy9tJgNemJJcDdIqbOkE6ioo6BrgS0G55roCMvlVPTGWcmDTp2qJtr0cKvG+vy/A==
X-Received: by 2002:a17:90a:de8b:: with SMTP id n11mr11380877pjv.31.1628697727552;
        Wed, 11 Aug 2021 09:02:07 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 09/60] KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live
Date:   Thu, 12 Aug 2021 02:00:43 +1000
Message-Id: <20210811160134.904987-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

After the L1 saves its PMU SPRs but before loading the L2's PMU SPRs,
switch the pmcregs_in_use field in the L1 lppaca to the value advertised
by the L2 in its VPA. On the way out of the L2, set it back after saving
the L2 PMU registers (if they were in-use).

This transfers the PMU liveness indication between the L1 and L2 at the
points where the registers are not live.

This fixes the nested HV bug for which a workaround was added to the L0
HV by commit 63279eeb7f93a ("KVM: PPC: Book3S HV: Always save guest pmu
for guest capable of nesting"), which explains the problem in detail.
That workaround is no longer required for guests that include this bug
fix.

Fixes: 360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/pmc.h |  7 +++++++
 arch/powerpc/kvm/book3s_hv.c   | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
index c6bbe9778d3c..3c09109e708e 100644
--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -34,6 +34,13 @@ static inline void ppc_set_pmu_inuse(int inuse)
 #endif
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+static inline int ppc_get_pmu_inuse(void)
+{
+	return get_paca()->pmcregs_in_use;
+}
+#endif
+
 extern void power4_enable_pmcs(void);
 
 #else /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 7bc9d487bc1a..1a3ea0ea7514 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -59,6 +59,7 @@
 #include <asm/kvm_book3s.h>
 #include <asm/mmu_context.h>
 #include <asm/lppaca.h>
+#include <asm/pmc.h>
 #include <asm/processor.h>
 #include <asm/cputhreads.h>
 #include <asm/page.h>
@@ -3894,6 +3895,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
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
 	kvmhv_load_guest_pmu(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
@@ -4028,6 +4041,13 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
-- 
2.23.0

