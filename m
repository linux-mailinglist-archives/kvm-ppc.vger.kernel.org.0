Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3360F3E957B
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhHKQEl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbhHKQEl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73238C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:17 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l11so3293656plk.6
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/vEG4Ho/dXWgP2kOVkY6K1MeaFf4fxSaH5Q3DcWC6fo=;
        b=lyFnjPCIWjCgcAy4FU02Pz39Xgd7UZhZMBQls7yYaJojByausWz+UWnYBVL7AW93p9
         d5QdXCVFCrfuHHj02x4NPuksDPBAOmaa8PcFrYRagJ3Wc/cgwPZnvY3lxiZP4+CpYM2s
         M4iayd2LMugrPto+I3s+GEcgRqdOy3RX2G1k0egyqDrd1gZbnuwCZMUgkvDx/+e8I5ly
         NWgJ0SN18CMDcFaYKyEEF9krE6DTbCKaq0zq36PPv0TQOSECJ+l7tvhQf6DsF/ZchVoa
         QIDrTuijE6sPsZ9YmI4LP9ylG4vrPyfl33iRZo4PNbcaYScA5Hg7+PTgkjPdCPywXmfB
         FmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/vEG4Ho/dXWgP2kOVkY6K1MeaFf4fxSaH5Q3DcWC6fo=;
        b=muxCStpv/s7vhJJTKNPf/Vf/xXyMZ9BaJCaML0Bmdi5CcFAkrAsMxFn86tZaXI2/L7
         UF8Tn0NG0RoxBkxLKR1ZYZJFMYyFECNRmEkLM/nwxNF9EQRUInG05yZq6aYgW7Hc3o8G
         jIC9jdfNv/TvJW7ed7R8PZJhSruol52862gPWXvy3p4O0i4qCoEo9Q/7BrRaGirwVJgE
         z3UqKYxT9S/yEq8bziw8QOtEs5WxuN17JKNAE9zsZuFrUhSg1cehRJSVVH1FWGZilxiJ
         obowqefxA9MMcyyaBR9rrOhFJG+lV25BMhdRez2C00GSR8keSDwgB84KmQpzWeP6Xi+1
         0PmA==
X-Gm-Message-State: AOAM533ksMyPsTIeVr91NOSdQYb5INOoQmredJc5FPbDp7rqTbuCOFic
        iuYFMCAkP8SnE8X6IK37Uns4Rk1WjWQ=
X-Google-Smtp-Source: ABdhPJyfef0O9LtmxDiXnuEztUDy3opwF7xkqm9urqSAaKsAfRJY5aApc+RC30EPYW43U4cZAKiYFA==
X-Received: by 2002:a17:90a:1d44:: with SMTP id u4mr11330552pju.119.1628697856867;
        Wed, 11 Aug 2021 09:04:16 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 59/60] KVM: PPC: Book3S HV P9: Stop using vc->dpdes
Date:   Thu, 12 Aug 2021 02:01:33 +1000
Message-Id: <20210811160134.904987-60-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The P9 path uses vc->dpdes only for msgsndp / SMT emulation. This adds
an ordering requirement between vcpu->doorbell_request and vc->dpdes for
no real benefit. Use vcpu->doorbell_request directly.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 18 ++++++++++--------
 arch/powerpc/kvm/book3s_hv_builtin.c  |  2 ++
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 14 ++++++++++----
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 1dc98e553997..e7f4525f2a74 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -761,6 +761,8 @@ static bool kvmppc_doorbell_pending(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.doorbell_request)
 		return true;
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		return false;
 	/*
 	 * Ensure that the read of vcore->dpdes comes after the read
 	 * of vcpu->doorbell_request.  This barrier matches the
@@ -2188,8 +2190,10 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		 * either vcore->dpdes or doorbell_request.
 		 * On POWER8, doorbell_request is 0.
 		 */
-		*val = get_reg_val(id, vcpu->arch.vcore->dpdes |
-				   vcpu->arch.doorbell_request);
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
+			*val = get_reg_val(id, vcpu->arch.doorbell_request);
+		else
+			*val = get_reg_val(id, vcpu->arch.vcore->dpdes);
 		break;
 	case KVM_REG_PPC_VTB:
 		*val = get_reg_val(id, vcpu->arch.vcore->vtb);
@@ -2426,7 +2430,10 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.pspb = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_DPDES:
-		vcpu->arch.vcore->dpdes = set_reg_val(id, *val);
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
+			vcpu->arch.doorbell_request = set_reg_val(id, *val) & 1;
+		else
+			vcpu->arch.vcore->dpdes = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_VTB:
 		vcpu->arch.vcore->vtb = set_reg_val(id, *val);
@@ -4463,11 +4470,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	if (!nested) {
 		kvmppc_core_prepare_to_enter(vcpu);
-		if (vcpu->arch.doorbell_request) {
-			vc->dpdes = 1;
-			smp_wmb();
-			vcpu->arch.doorbell_request = 0;
-		}
 		if (test_bit(BOOK3S_IRQPRIO_EXTERNAL,
 			     &vcpu->arch.pending_exceptions))
 			lpcr |= LPCR_MER;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index a10bf93054ca..3ed90149ed2e 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -660,6 +660,8 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 	int ext;
 	unsigned long lpcr;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
 	ext = (vcpu->arch.pending_exceptions >> BOOK3S_IRQPRIO_EXTERNAL) & 1;
 	lpcr = mfspr(SPRN_LPCR);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 5745a49021c3..1e18c089478e 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -701,6 +701,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
+	unsigned long dpdes;
 
 	hdec = time_limit - *tb;
 	if (hdec < 0)
@@ -763,8 +764,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	if (vc->pcr)
 		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
-	if (vc->dpdes)
-		mtspr(SPRN_DPDES, vc->dpdes);
+	if (vcpu->arch.doorbell_request) {
+		vcpu->arch.doorbell_request = 0;
+		mtspr(SPRN_DPDES, 1);
+	}
 
 	if (dawr_enabled()) {
 		if (vcpu->arch.dawr0 != host_dawr0)
@@ -995,7 +998,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
 	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
 
-	vc->dpdes = mfspr(SPRN_DPDES);
+	dpdes = mfspr(SPRN_DPDES);
+	if (dpdes)
+		vcpu->arch.doorbell_request = 1;
+
 	vc->vtb = mfspr(SPRN_VTB);
 
 	dec = mfspr(SPRN_DEC);
@@ -1057,7 +1063,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		}
 	}
 
-	if (vc->dpdes)
+	if (dpdes)
 		mtspr(SPRN_DPDES, 0);
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
-- 
2.23.0

