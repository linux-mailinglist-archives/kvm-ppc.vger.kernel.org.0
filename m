Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4723E954E
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhHKQC7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQC6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73409C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so10333942pjb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZjufjuNadV1tghNNfY89lJSLDdECYjetCLWMrMMZtk=;
        b=m38fx7MjF9GLTn7G7CX6ptbf2MEFMOR2BN6eFsf1rwSxK69YYE8lrvFFLtplE02onm
         IPjG29oDa7wt9QpiY+qKMVdGYBFLR33agxko6jN0LnT89z/ofi/Akpm0GYxsBJxddWZB
         9XcrTmgU8kHiX5r5UgqmGo2MqPqGm5Dzv5RtKBuI8A8L7HLn6/4P2QrkZfNjZXpBLBmW
         FNDy6iwz5wi4ffmJOLWTn6T0preI7q7ajs6L0/JGSxZnp8hXzElv4pY0pWqqfz7MglDS
         I95hg+me3j2HIJR1mANo0yWA5ubJK+euNanTae/bhAWSmz23hhBmncuTNlQepPY56PlJ
         H/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZjufjuNadV1tghNNfY89lJSLDdECYjetCLWMrMMZtk=;
        b=De6vAu1RfTqcQ/CtCV0fJKGwsopl+Y5jonGudBEbcIUeWgEIbsuedbDKHzXNA+3KIg
         6MzCEdNgjMEieZou6P2AnKM9u/C9fUyaeQqsns9ZNPynj5OPVyLGHDutmNhWn9xmZ1b7
         XmMLmBovGo1GBLLIe6qI+nBDctUNN9ToSiotWqt04T27KZCBRLMBHTC3jn+NNw8NqgMa
         jyB5f00spcA9TGnja4f6Xalkxo3khvd61zAyptKv1W+8ZKOGw4tw8qKmqGseZ3CylkTH
         74hHavRy3Fod5IPyPO4R9mKNTVTqg366k452yy7IVersoXiI71H9pXUw+7Khr6fkrOAl
         r8zg==
X-Gm-Message-State: AOAM533ZqXs8yvMsj0wEPYHmXjgrZtyZNYXXI4E5bIgpikcpTv8VitNh
        sjF6BLngTgU+pCGA5TiXBEGmzDOlbyU=
X-Google-Smtp-Source: ABdhPJwHhdLxVG/f4hmuVWZtbivuXl7M2kIpPYqbLjFGsM/0UhkIb8Xix9zFZbjXXh0r4cI7gBnAkQ==
X-Received: by 2002:a17:902:d2c8:b029:12b:84f8:d916 with SMTP id n8-20020a170902d2c8b029012b84f8d916mr1293181plc.75.1628697753915;
        Wed, 11 Aug 2021 09:02:33 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:33 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH v2 19/60] powerpc/64s: Always set PMU control registers to frozen/disabled when not in use
Date:   Thu, 12 Aug 2021 02:00:53 +1000
Message-Id: <20210811160134.904987-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
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
index 197665c1a1cd..e6cb923f91ff 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2718,6 +2718,11 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
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

