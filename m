Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32973345492
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhCWBFZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbhCWBFB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAEAC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b184so12528685pfa.11
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yX5ypLxECFKHtHUc9s7XQ6J4Lm2dxfuiArf31xv5RbI=;
        b=lrNcOBhCaYJ51d5adbHgwlYy+wSqXR2NgtPrCfhNDmQi2rsAs5bggNwi2rIPI3aQEM
         7Oz7UYsewRsYdX6MgyKbhbZb+YU9D4/leejUMlw4/gnSy05soX/5K1Gw/0m16DHBVlaA
         xgVKUwoHu8f9aB/gAq5TumX/EMjLi3+80q5nuT304oitFZsMSsEnCPT/5LVtiSoydhdj
         HA+A1Ys6Q2IOjjuK1vEnznfqThPyOjQAz3iJ3o1o6KGHhja28NLZOU1niB4hPrwdgXib
         LUzDIemsAfiuxsnxNyzBzcNHdZ/7bH3oVx198ez80oZd61A/5jjvJUru4N3oA3jKRKvd
         rj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yX5ypLxECFKHtHUc9s7XQ6J4Lm2dxfuiArf31xv5RbI=;
        b=uEFWG2aAhvhhf3gn4a8E63+oi9tuvocFPPFgMJOiY5GYXh6cEGIZM2Faq5Q/BVW5rx
         wNJ4YD/QbHpsTyMqHXwoQVfro3xhh/A9XyRQYQ3yctjKnVYDM808JMgKL2yu2iDhmQbg
         uB2MMS7nevvBC8LIjyisBI6PEWKqxVD5IrS6kgV5qL55OF1OlLNK77svGpRtNfvGLS6D
         T+YPPMnE+RfyiK5fom+N2K3B9ZOO//TdrDyNCbStTmZ43Mk0+X4DfOK0zAMWf5Y/q9zS
         Kv/wLyM5Ry4gYhjAuqx5TmloKWB6JDgVhHAcFx8hhG9hC377JUfpnVhxJkyskYZ+8qf+
         j5CA==
X-Gm-Message-State: AOAM531gG2Qf30pA7ZnFsQfn6KaUCgWlnlQa+AnQjZhrUyXIy3AvhN92
        1UyfUc3tOcR5rHziiWbnXROvidsFOeI=
X-Google-Smtp-Source: ABdhPJwdpI4XyGefs+7hywPbND7QL8R0DeRXgB5fQzNr3veibS92lAhthgrOaunjQDBxO4lRN701dw==
X-Received: by 2002:a65:6a43:: with SMTP id o3mr1776563pgu.297.1616461500331;
        Mon, 22 Mar 2021 18:05:00 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 35/46] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Tue, 23 Mar 2021 11:02:54 +1000
Message-Id: <20210323010305.1045293-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move MMU context switch as late as reasonably possible to minimise code
running with guest context switched in. This becomes more important when
this code may run in real-mode, with later changes.

Move WARN_ON as early as possible so program check interrupts are less
likely to tangle everything up.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 40 +++++++++++++-------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index f57379e73b5c..787a7d2aed1a 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -154,8 +154,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
+	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
+
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
+	vcpu->arch.ceded = 0;
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -204,26 +209,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
 
-	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
-	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
-	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
-
-	mtspr(SPRN_AMOR, ~0UL);
-
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-
-	/*
-	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
-	 * so set guest LPCR (with HDICE) before writing HDEC.
-	 */
-	mtspr(SPRN_HDEC, hdec);
-
-	vcpu->arch.ceded = 0;
-
-	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
-	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
-
 	mtspr(SPRN_HSRR0, vcpu->arch.regs.nip);
 	mtspr(SPRN_HSRR1, (vcpu->arch.shregs.msr & ~MSR_HV) | MSR_ME);
 
@@ -242,6 +227,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
+	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
+	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
+	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
+	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
+
+	mtspr(SPRN_AMOR, ~0UL);
+
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	__mtmsrd(0, 1); /* clear RI */
 
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-- 
2.23.0

