Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC27D3B01F9
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFVLAj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFVLAi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:38 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20794C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m2so16744003pgk.7
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3IbqYnc6jwDvTAVKkagWuc1eSLjZhsavaNtRfJS7oq4=;
        b=P/vsSuDZPUgS4FjBzc5tWU01c8viCiB83FONYuE5OKmnbB0zeqSrB1YPDnWzpqbv6c
         8bCE23HIXpzA411UubIO8at4ErknjI6Hbb2HuhebfjqNcyqYTvQV9vfcW8oRcRdfG+wR
         7TH0veYJrQJELn6aAfxFEmel0ezs812tekH+VrEuqQGEEKfSPgB7nBakNa6z2DwrCivP
         WisU8eTa3z9CizvIc/6iXiJ/Ct59T3FAsd7KGAInY0fxeE1VyaBqTK9vAMlyzUPRS8lf
         Uo8adtJHebIcJTEHYhynROoc3PkYY0rgVVFdBg/2HYSsBfZ3jeRj3FPs+5keg2z9yh/B
         Etjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3IbqYnc6jwDvTAVKkagWuc1eSLjZhsavaNtRfJS7oq4=;
        b=NELmB8rpEgViMhJK215VmWS/ucGHUCHPc/lK9uUsVu90KVvxtr7QsM9f2+asUOhPay
         mdFvueE6NXlEMwILQPg2PyheRm/UO+kMPfQw0aBwIaRxGiXoCvQzcvNSf42bcMt6du/h
         mQ3HlQhPhgno3yjxjOg/N6YSuiWF04cZbk6091SYdtbb1XWsJi4g7PKxgH8AtqD3JGMU
         lxMj2vMYOyhVFTffh0jUJIK6PFqd/BYxJ0mmySfpYFq4kugHAe2F526ClQuaGmoxUWi8
         ghuyJYHh7v3VUMg/NOnssfZetS+NoOmeNzTpYvgLqu+/rz0Q/GnBJNrvCjIxriI60rex
         J1Yg==
X-Gm-Message-State: AOAM531wjW11J7/4eexcav4qgTXaQcfyOIbDqt9AlWHubwt/DwRX5OUa
        gVDmejjGBA9u/V/KExWjiyhDKAUCTfs=
X-Google-Smtp-Source: ABdhPJyM1MDyYUkMPfhJf1pBkmdHVWpT4T65oSvBG5VbXutiXxy7qdE2EqeMzMpFAE2dIVIWcaKhjg==
X-Received: by 2002:a63:f20:: with SMTP id e32mr2584597pgl.235.1624359500659;
        Tue, 22 Jun 2021 03:58:20 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 10/43] powerpc/64s: Always set PMU control registers to frozen/disabled when not in use
Date:   Tue, 22 Jun 2021 20:57:03 +1000
Message-Id: <20210622105736.633352-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
 arch/powerpc/perf/core-book3s.c       | 7 +++++++
 4 files changed, 17 insertions(+), 5 deletions(-)

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
index 0a6b36b4bda8..06a089fbeaa7 100644
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
index 1f30f98b09d1..f7349d150828 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2593,6 +2593,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
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
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 51622411a7cc..e33b29ec1a65 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1361,6 +1361,13 @@ static void power_pmu_enable(struct pmu *pmu)
 		goto out;
 
 	if (cpuhw->n_events == 0) {
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			mtspr(SPRN_MMCRA, MMCRA_BHRB_DISABLE);
+			mtspr(SPRN_MMCR0, MMCR0_FC | MMCR0_PMCCEXT);
+		} else {
+			mtspr(SPRN_MMCRA, 0);
+			mtspr(SPRN_MMCR0, MMCR0_FC);
+		}
 		ppc_set_pmu_inuse(0);
 		goto out;
 	}
-- 
2.23.0

