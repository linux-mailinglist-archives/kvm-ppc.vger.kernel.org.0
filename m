Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D423E421356
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhJDQDS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbhJDQDR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:17 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3100C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x4so203328pln.5
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QsROx6YiIEUIQDZ2uLHUlrr43H/HbbJMND6qsXW3a6k=;
        b=EroHTvNRweXrSs3NEoQkGVpOvQIyS9qAwz0g8R2DoHCpgbX2Yo9G8fjDaAvzWeUtMK
         oCwF38JGja0WcLQXLUfmNDiE6ru8wDvt00zc5ICL0PKqzJY7aVvHITTuHE8gMaP/EkHJ
         UIobcXHudctG8BMLrnGqn5H/vjaB7a0X8RxiVVu47mi9fhLncAlBx7DM9/c4av1Hhhl2
         bz0OlN92hVHE4RM3yJ8KOokVjNCXRqdZDxZwH4u2NdhfY4gj8H7eRNE1GSSoiTsMIuEV
         UTlFOirEGIuBi5XxmteSd1LnCQyceZ/GE4zG2b3F8zgCbj5nbOCn2jLKbPiW6pJM6+jQ
         3Kkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QsROx6YiIEUIQDZ2uLHUlrr43H/HbbJMND6qsXW3a6k=;
        b=Nd4o3b2pvF9PVhAJOlN9Xculgi7uw51N5z3tLT0KSZEcOtBXqqLPpYJ00/maYL2MU2
         HvVVO+rcoCct4T/UPBcmpigR7hYZiuhro/6I1qi14BQ/fKn7XAsbaS6uWwdoKfvhbq1p
         FtTcd0iNxwcUJt/o8s9Wv154TTB9xr8IvotZEJt8H0VMY65RCJpdb3wkddZje4KXGc7w
         ObqyQd8/Qq/OeC6zTgk1P/rgSJsgoimhbk3uCUFNAAYUfNXPhIRrQO9e6MUTirSp9Bdq
         pkSVX4xE4NNf3MDYIym/iTSpP3sePjvXTnb5gBZxLgEiLcVrnE7zoRXCRhvpCOJzzXyy
         qerA==
X-Gm-Message-State: AOAM533aq12NvdmgA2sHDBhxNTnhlNw8b0FJfOSSWzy9WpeZxYQOK6AQ
        BR3gUYcO1zIeD958cAxl6JJBYJqOpYg=
X-Google-Smtp-Source: ABdhPJyYWReFXGeu8UbKiCNGcyIAaJrAnhE0Q+gDCG6lkDLciCHLsvFhUtrUUh1nofgVNolozRyKNw==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr5373879pjb.76.1633363288275;
        Mon, 04 Oct 2021 09:01:28 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Subject: [PATCH v3 11/52] powerpc/64s: Always set PMU control registers to frozen/disabled when not in use
Date:   Tue,  5 Oct 2021 02:00:08 +1000
Message-Id: <20211004160049.1338837-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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

Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Reviewed-by: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
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
index 945fc9a96439..b069209b49b2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2715,6 +2715,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
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

