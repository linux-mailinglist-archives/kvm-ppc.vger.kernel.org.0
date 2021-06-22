Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313753B021A
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFVLBr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:46 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1831C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:30 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x16so16076474pfa.13
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UILmVe86M04fDMdrwzekSb++5wE47RqZZpwyPrmtoao=;
        b=FRqdb3jJv5ENspLE2sJXwjeCn21tzTP6Pr1FoEd6uxzz2KGcPpirlkcWIn1/zyghi0
         dlX0qARxGK9mNjJJa6j9mwMPa1CxhEx6zP07I81Cqo5W8dy3nq9xnWkVKfXVXGH1ADaL
         RHlvbtXb/o/w1vXoGnumWYYR1ci1rTOIWzy2lf6mbVZDU2yki6VQt0Dfm2ENUnOBSJHG
         mvzlKIbIAOqLg7JmTaBveXqTiz4Ne7/PcY3LfYnpSQ1coJHVb14RTFByam8tW+NDd7OK
         hZXP/QdK35ARWellb1uFRBwc20BEuxdlnfOI9ZpO40zGECmJFU8ND37nu4RcfK92gm5n
         iWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UILmVe86M04fDMdrwzekSb++5wE47RqZZpwyPrmtoao=;
        b=AJA47pjwJ2OYMHCbEt7P7g5EtjFieXnVjmwmeU7yYmezSuXn9yckJIoOPbbW6KZOyB
         vW1DTAotG5xqpime8nFD9DQsjVsOIznQr0rxOL6k6smencmsz/wySJ1OTjCfgmW6MhP6
         FftCH3DTQdOSL4jDp+JaS0/afet++Kw20fjWmHx9xJ5qqzfAINpN2trHjA6N+EDwheUI
         ljXt2Julufc/whuoED+eg81Vf2pTXPHCsdIhzrEqOFFQtQCyhWCtfEqYUEdGJX0/pjSU
         nZcPrnq+lSWYjHO18zfmHFAAv6XXvEmNs3aRbu7GzPHdZNrE77UVPXNr88JQGvhIpJHr
         BgDQ==
X-Gm-Message-State: AOAM530QlZqHKo/JEN5Uy5GxoDS6GREibehuhD4YvS1zmbUMz0JGK0Ju
        H+Zs5np8juNVA4GSEIU8Ssf2jF9vX2w=
X-Google-Smtp-Source: ABdhPJx/65x11lxQY5FbTCr96xJiKFO5phvCG2S1fLraHwNRCG+mIe2fxpVA5XGnV2AhrgLHh6+ZGw==
X-Received: by 2002:a62:2bc6:0:b029:2e7:a7c2:201 with SMTP id r189-20020a622bc60000b02902e7a7c20201mr3126665pfr.64.1624359570258;
        Tue, 22 Jun 2021 03:59:30 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 39/43] KVM: PPC: Book3S HV P9: Don't restore PSSCR if not needed
Date:   Tue, 22 Jun 2021 20:57:32 +1000
Message-Id: <20210622105736.633352-40-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This also moves the PSSCR update in nested entry to avoid a SPR
scoreboard stall.

-45 cycles (6276) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          |  7 +++++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 26 +++++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c7cf771d3351..91bbd0a8f6b6 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3756,7 +3756,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	load_vcpu_state(vcpu, &host_os_sprs);
 
-	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
@@ -3797,7 +3799,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
 	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
-	mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	store_vcpu_state(vcpu);
 
@@ -3810,6 +3811,8 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	return trap;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index f305d1d6445c..4bab56c10254 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -621,6 +621,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_dawr0;
 	unsigned long host_dawrx0;
 	unsigned long host_psscr;
+	unsigned long host_hpsscr;
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
@@ -638,7 +639,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_psscr = mfspr(SPRN_PSSCR);
+	host_psscr = mfspr(SPRN_PSSCR_PR);
+	if (cpu_has_feature(CPU_FTRS_POWER9_DD2_2))
+		host_hpsscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
 
 	if (dawr_enabled()) {
@@ -719,8 +722,14 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 
-	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+
+	if (cpu_has_feature(CPU_FTRS_POWER9_DD2_2)) {
+		mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
+		      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	} else {
+		if (vcpu->arch.psscr != host_psscr)
+			mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	}
 
 	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
 
@@ -905,7 +914,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ic = mfspr(SPRN_IC);
 	vcpu->arch.pid = mfspr(SPRN_PID);
-	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
 
 	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
 	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
@@ -948,9 +957,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr);
 	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr);
 
-	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
-	mtspr(SPRN_PSSCR, host_psscr |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	if (cpu_has_feature(CPU_FTRS_POWER9_DD2_2)) {
+		/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
+		mtspr(SPRN_PSSCR, host_hpsscr |
+		      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	}
+
 	mtspr(SPRN_HFSCR, host_hfscr);
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, host_ciabr);
-- 
2.23.0

