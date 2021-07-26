Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B909D3D51AF
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhGZDKz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:54 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C475C061764
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so12488187pjd.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUY4DjhoVcwh8vw/6xuD0mzIiPpFrZzyIYMqsoNMJh4=;
        b=MrnqtCfOgs+2lfNq5vjfN03YUCQ80Z5XjAbdu7GXoNslUaPkTt9YcHIAEeP8u13s1q
         KicdBW6jZIbfzLI6tf00YeDcUfHAe+7n9oSPWfFDuXEhs/6jp63syOVVHgjURoS9jsFo
         f0+ASg5h2+u7ZEkK+NmLx3L6VRruJ3DRipafFdxETRAs6enf6AuLqXVg2dCXuTh+GNiH
         bWgGTnXJfESeG6VfGCizzM69vNKE9jowHfjxSF4nhdiyj3q9RI+iclc9zrcBBC615ceS
         aONS9zhY+fMP1zKcyt9ngJoEd5MLB1ka0njsyl8kNSYJvxzEis2bnGBLCEYTBq3KV2vU
         mKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUY4DjhoVcwh8vw/6xuD0mzIiPpFrZzyIYMqsoNMJh4=;
        b=H9J0mJpN6Tz0dm4kGROAmENDWW4kcuIemjuIvDyhpK/DhxABDUk2qF+AWSW1k1zeAz
         VUTGO5wbvDainddklhJj+KWsAoki0Gl1UzaWJ+4LNDY3l7niUs+vz/XlqWx5G4H+m1Qz
         0q46yaTf11p2eU/FxaaY85sftuR6FHd8kKKmrhmStMRYDZPm58OibIFEZp4VcDQD6xS8
         r1NLWpXlcEtkV02Y44+KdS8UPWeJXp8uCZDSBmQrAjjy/GAnvjnBad+EnxcPyeqVpM75
         6q/nqpq9ptN5qQtAiZVakTEdS+ftyrjjgULbBWhJaHAZxG7QO/A8zcbtnYgHWSUOsmD2
         bGKA==
X-Gm-Message-State: AOAM533NLeguqcwOYajN4hr5QK2SAa2L0EXml0/f1MY35KG+DTnIYWsV
        v6KMh/R0dHFIBGt+wqzBfHf18LbmyFM=
X-Google-Smtp-Source: ABdhPJxrwfLnqWKH2gIYKRX/ffRt6PcNWY15ekXVP+YAfRQvKiVKQGSJV9ZzXL8DItYzdaoU+5Dwhg==
X-Received: by 2002:a63:ae48:: with SMTP id e8mr16599544pgp.0.1627271481104;
        Sun, 25 Jul 2021 20:51:21 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 15/55] powerpc/64s: Always set PMU control registers to frozen/disabled when not in use
Date:   Mon, 26 Jul 2021 13:49:56 +1000
Message-Id: <20210726035036.739609-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

KVM PMU management code looks for particular frozen/disabled bits in
the PMU registers so it knows whether it must clear them when coming
out of a guest or not. Setting this up helps KVM make these optimisations
without getting confused. Longer term the better approach might be to
move guest/host PMU switching to the perf subsystem.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/cpu_setup_power.c | 4 ++--
 arch/powerpc/kernel/dt_cpu_ftrs.c     | 6 +++---
 arch/powerpc/kvm/book3s_hv.c          | 5 +++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel/cpu_setup_power.c
index a29dc8326622..3dc61e203f37 100644
--- a/arch/powerpc/kernel/cpu_setup_power.c
+++ b/arch/powerpc/kernel/cpu_setup_power.c
@@ -109,7 +109,7 @@ static void init_PMU_HV_ISA207(void)
 static void init_PMU(void)
 {
 	mtspr(SPRN_MMCRA, 0);
-	mtspr(SPRN_MMCR0, 0);
+	mtspr(SPRN_MMCR0, MMCR0_FC);
 	mtspr(SPRN_MMCR1, 0);
 	mtspr(SPRN_MMCR2, 0);
 }
@@ -123,7 +123,7 @@ static void init_PMU_ISA31(void)
 {
 	mtspr(SPRN_MMCR3, 0);
 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
-	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
+	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
 }
 
 /*
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 38ea20fadc4a..a6bb0ee179cd 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -353,7 +353,7 @@ static void init_pmu_power8(void)
 	}
 
 	mtspr(SPRN_MMCRA, 0);
-	mtspr(SPRN_MMCR0, 0);
+	mtspr(SPRN_MMCR0, MMCR0_FC);
 	mtspr(SPRN_MMCR1, 0);
 	mtspr(SPRN_MMCR2, 0);
 	mtspr(SPRN_MMCRS, 0);
@@ -392,7 +392,7 @@ static void init_pmu_power9(void)
 		mtspr(SPRN_MMCRC, 0);
 
 	mtspr(SPRN_MMCRA, 0);
-	mtspr(SPRN_MMCR0, 0);
+	mtspr(SPRN_MMCR0, MMCR0_FC);
 	mtspr(SPRN_MMCR1, 0);
 	mtspr(SPRN_MMCR2, 0);
 }
@@ -428,7 +428,7 @@ static void init_pmu_power10(void)
 
 	mtspr(SPRN_MMCR3, 0);
 	mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
-	mtspr(SPRN_MMCR0, MMCR0_PMCCEXT);
+	mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
 }
 
 static int __init feat_enable_pmu_power10(struct dt_cpu_feature *f)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ab89db561c85..2eef708c4354 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2691,6 +2691,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 #endif
 #endif
 	vcpu->arch.mmcr[0] = MMCR0_FC;
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		vcpu->arch.mmcr[0] |= MMCR0_PMCCEXT;
+		vcpu->arch.mmcra = MMCRA_BHRB_DISABLE;
+	}
+
 	vcpu->arch.ctrl = CTRL_RUNLATCH;
 	/* default to host PVR, since we can't spoof it */
 	kvmppc_set_pvr_hv(vcpu, mfspr(SPRN_PVR));
-- 
2.23.0

