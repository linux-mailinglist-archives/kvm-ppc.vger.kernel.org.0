Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDF33D51E3
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhGZDMV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhGZDMU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6188EC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so11102246pjv.3
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TD+VXbAQkLjU1Tv9nfQp6WJQncSQ+vS8R2ucbT1q4Q=;
        b=rYqGzF2CXDcmuW2mWG/451LNfWwHC2Bh0vYkWw/oWGlPjqdmNWNI2JdYR4Ix/++TlK
         OUE/LJym/P3Gi9GZv90usVyZp7pSm6uCql39qE1G32gudX+8vkdFZ7paM3dI1SXNq2jW
         6WuULww0raOMIEYWjOscKfKwPPSAtzFdSNYIXGJb4pw9WQLTRwigqa+o312fjmypphLk
         SFV16Dgdc7b38+EF3T9SLJ40VyOeqoLAWrj1Pd9G9zqYTqtpCR/kAE11IQQpt8wqhqVZ
         VTdf6dMap6Ijb2TAFfGJWuLmLRsN+5T7hUBZz6ZLPyebvuHeqBT3R5C+iPe9ZBlJ1kRW
         ktBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TD+VXbAQkLjU1Tv9nfQp6WJQncSQ+vS8R2ucbT1q4Q=;
        b=azAHsBI/LyAmV8Q6+KYgZkCPB4hr4CePEXJJOyLVzue3DTRNxyyXl9ges5TVzMMuB6
         zh4Cm5gEi2X+uK5j3hW3j8dMEzylj9XUdhYkh7kTUFsJqFzZEIFFZNGqfdgDZw0JmbPV
         XPDB3kF6KowUDGU3HBmYd5ul3bmGOZHxrAD+K/BZAMg5iLGKpkevU5yGKmem1EYDIyEY
         /tFR121ha8dmM0EI+/VhCCtZPATLJzwPjxbXv2CB6bcLFgSD2efo+fpR/8wM0Q4o65ot
         WGqu7/Kzts+dESdCJwC+6mxoFf47wjtQ6hrj8lHOFxviZKatsa+xSsXY7b0fM+WpXlBv
         mTwQ==
X-Gm-Message-State: AOAM533/r2GnVE+ulMf3clAc6VDwaju9yUeeNqKhHL+CgZpavJXZlJNH
        ljegz4c8VRnFUA5wpP3JwUO/18vh0no=
X-Google-Smtp-Source: ABdhPJyED48ffEzufLC/jgr6X71ytepHIJcTvR+1kUU3ioulHKiztmxFXFUUA4RAdq7/870wICyq3w==
X-Received: by 2002:aa7:88d3:0:b029:32b:75d0:fa92 with SMTP id k19-20020aa788d30000b029032b75d0fa92mr15948571pff.23.1627271568854;
        Sun, 25 Jul 2021 20:52:48 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 54/55] KVM: PPC: Book3S HV P9: Stop using vc->dpdes
Date:   Mon, 26 Jul 2021 13:50:35 +1000
Message-Id: <20210726035036.739609-55-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index f233ff1c18e1..b727b2cfad98 100644
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
@@ -2166,8 +2168,10 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
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
@@ -2404,7 +2408,10 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
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
@@ -4440,11 +4447,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
index 338873f90c72..032ca6dfd83c 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -695,6 +695,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
+	unsigned long dpdes;
 
 	hdec = time_limit - *tb;
 	if (hdec < 0)
@@ -757,8 +758,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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

