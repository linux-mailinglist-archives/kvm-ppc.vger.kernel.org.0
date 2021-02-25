Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE93250D2
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhBYNs7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBYNs6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75629C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:43 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q204so2591131pfq.10
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFaLjtbHvhG9RPsmAn2L9v8PlI/yIaIQI9IuG70b8yw=;
        b=EADf74jia1v+Dl6Sggk63dBVE/91g56OzdKAcCr7OH87ZEbwTUUsyIYSYtUebnuqut
         RYYC17/N81cipa9HgiuVssN//6TD3rDIDGN1irGlLuJ1m721pGVwnDW5wwwg1dFbp2Ol
         eWRpz6/s54aUApKSIGxi/DdNTFrEhtFzoMVWVUU4kDY4o34RAc0JhuP9BVP7TJOA88pW
         NDWGl5cSGpo8WPjtWxVGgM6/eclmiSBMj9hnAnoDD54m77l5KhxFk2yqCA2zNouz7JGW
         olbzgujULdHZzqDNwVsaXMY7UbfDDxokHWzIWz+0tKBEQGpIzzfN5HqLgUulHtuzhLKF
         wCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFaLjtbHvhG9RPsmAn2L9v8PlI/yIaIQI9IuG70b8yw=;
        b=Z3sAHvNoPs9dUHQ+uXA0wqoG86yE4Olktv9V3JF6/bYOAs5Y9ui4/ArvQQmuNb1REg
         N8IEKRTLOC5q+YkmVjXEbGbUtEVnQEe/JfegElbytgW/uLVzT4NVc0r/vAovzt4D7qVM
         P5Q4URUXZRVSrpcxAyMyVFx7TNsCaPGi3c3bu68c2ncJ3DNquduWhUhf5wtYsK/1H5cl
         hiwFFgg5Rdn6ltRi7MYd3maDLG4Fci6ZfrT5TNcBvhtO/tTAIwQhv/l5Nrun0QZmcBrz
         HzRpwLoHfH7AD0DBFR7W7Vr7qsysuVkax4Ln76/LVgXQgLb9kBQJ3cqX5rgSdPvgOT3L
         kqVg==
X-Gm-Message-State: AOAM530M2pewVmElCRy55VCqTMmYiwHxup6IRBUeh4IbGg+m1LN8NUBv
        qoLwPnyAL+0mODL9zsqNLhGtPJpHdRA=
X-Google-Smtp-Source: ABdhPJwUbThXbDyvaI7aS0Fet3uIuMuLbgnDOCcKp5h4bhbUy/L5JdKF4Iq5km8L76+G2R6KN4SepA==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr2929117pgc.359.1614260922556;
        Thu, 25 Feb 2021 05:48:42 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:42 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 29/37] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Thu, 25 Feb 2021 23:46:44 +1000
Message-Id: <20210225134652.2127648-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move WARN_ON traps early so they are less likely to get tangled
on CPU switching to guest. Move MMU context switch as late as
reasonably possible to minimise code running with guest context
switched in. This becomes more important when this code may run
in real-mode, with later changes.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 40 +++++++++++++-------------
 arch/powerpc/kvm/book3s_hv_nested.c    |  1 +
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index dd0a78a69f49..b93d861d8538 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -143,8 +143,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -193,26 +198,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
 
@@ -231,6 +216,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..cdf3ee2145ab 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -323,6 +323,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
 		LPCR_LPES | LPCR_MER;
+	/* XXX: set lpcr in sanitise hv regs? Why is it plumbed through? */
 	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

