Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13C83C9F3B
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhGONSb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONSa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:30 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B56C06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id m83so5240654pfd.0
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=74+e3cPQA8W7A+zw6sguddhanPGUj6P7ehLyiz9gEPQ=;
        b=Ykp0pKAIEAEhtwgjfIKeSN8ZqJ7fcjMzUPSrrzugejuRzDQbU+pcn3V9RNqwXB7Wa1
         FnnWvmE8GBs87AbXpzKr2HiNLGoxnFvqKC7vDiSmq6CofwgOFaGSkvFzpJqZMThiJICS
         gpuD20FnnM0uMoxqz8NmPY6fdCgwM0hzoaLFVAojY4GraI01s4zdQ+8bxh0U9mFgboMV
         RTjCvR7xDxmLOZM/OZB2XQMjXA18+e65CSoKxQity0Su+RgoSM0jObCtVCZDlUa1JSL0
         VcG8Vozw41T0j2l3WZG4GSe9R9b1Ei07aXFNLIppAismV8Cmnj+WWVGwMC804Vz0aM8b
         01JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74+e3cPQA8W7A+zw6sguddhanPGUj6P7ehLyiz9gEPQ=;
        b=Rkx0Nu710PmBnQz9jQtDRJ48KBpPCDaeJlkOC+5JiVYzr/30B3ljw9Ioyj7Uv8kze9
         5DAxAHw2Ebym8HXlpXXffvR9acbJsQDWkel3qC2mLJv7k8ylvMDXfVtzUz523HOSpmcd
         XiN4FO0e8mvu2rmVE3rsYLv7GV5alGb4HKjN6qsFUrLasXbux4dzb2v+zkpGcOLmxwZO
         b5Pa/fCychnkaw9lSiKdLgMqbWeJVS+GEqY2ayh1RXfJPxHLPiTAWEErIVwxvfWHylgF
         QRsGCPYp1SRhtKD3hQ0nHVMmL3yvlCnFW5Ee6QFuBsa+jy4rrIWqUiZXovYcKKscsAdF
         //qQ==
X-Gm-Message-State: AOAM5311KrqDhwKXuYwhsB4W6R87/RtWejYh+xtkHmhCuQqm8YFfi3tl
        fPw5FLRCGEKTKvQtyQwB5W2Y0BoaJUs23w==
X-Google-Smtp-Source: ABdhPJxBxY5oJrblOUzwrUPxp2+HgMxZbX9pnfmMnBBiX92eyFM9PX87Ow+j3Ykxg3D7dNecIcNnug==
X-Received: by 2002:a65:41c7:: with SMTP id b7mr4633886pgq.81.1626354937290;
        Thu, 15 Jul 2021 06:15:37 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 5/6] KVM: PPC: Book3S HV P9: Stop using vc->dpdes
Date:   Thu, 15 Jul 2021 23:15:17 +1000
Message-Id: <20210715131518.146917-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210715131518.146917-1-npiggin@gmail.com>
References: <20210715131518.146917-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The P9 path uses vc->dpdes only for msgsndp / SMT emulation. This adds
an ordering requirement between vcpu->doorbell_request and vc->dpdes for
no real benefit. Use vcpu->doorbell_request directly.

XXX: verify msgsndp / DPDES emulation works properly.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 18 ++++++++++--------
 arch/powerpc/kvm/book3s_hv_builtin.c  |  2 ++
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 14 ++++++++++----
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93ecbc040529..957efde59014 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -766,6 +766,8 @@ static bool kvmppc_doorbell_pending(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.doorbell_request)
 		return true;
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		return false;
 	/*
 	 * Ensure that the read of vcore->dpdes comes after the read
 	 * of vcpu->doorbell_request.  This barrier matches the
@@ -2165,8 +2167,10 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
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
@@ -2403,7 +2407,10 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
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
@@ -4431,11 +4438,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
index be8ef1c5b1bf..9d24f4472b42 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -649,6 +649,8 @@ void kvmppc_guest_entry_inject_int(struct kvm_vcpu *vcpu)
 	int ext;
 	unsigned long lpcr;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	/* Insert EXTERNAL bit into LPCR at the MER bit position */
 	ext = (vcpu->arch.pending_exceptions >> BOOK3S_IRQPRIO_EXTERNAL) & 1;
 	lpcr = mfspr(SPRN_LPCR);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 82dac23cc678..44150a29f6e0 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -677,6 +677,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
+	unsigned long dpdes;
 
 	hdec = time_limit - *tb;
 	if (hdec < 0)
@@ -736,8 +737,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
@@ -968,7 +971,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
 	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
 
-	vc->dpdes = mfspr(SPRN_DPDES);
+	dpdes = mfspr(SPRN_DPDES);
+	if (dpdes)
+		vcpu->arch.doorbell_request = 1;
+
 	vc->vtb = mfspr(SPRN_VTB);
 
 	dec = mfspr(SPRN_DEC);
@@ -1030,7 +1036,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		}
 	}
 
-	if (vc->dpdes)
+	if (dpdes)
 		mtspr(SPRN_DPDES, 0);
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
-- 
2.23.0

