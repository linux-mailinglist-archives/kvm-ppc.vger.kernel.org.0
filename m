Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEB742137F
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhJDQEa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJDQE3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB665C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso247760pjb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UPwQjon/JGAwP2hNwxa5hh2Gm9nZDXFP065oxigESDI=;
        b=Cp9TFuDnn9PJg4RnIi5LgHZZNizTxMSa0BnQHLvQggcgyzXhPeCRJ0NEX6C75vDAGR
         XPwnPldKswCJvCR+tYxOBiy99l9hkz+cMHSgvIPF//aI/4ccVCLr4sWwc4E+pHGxYKku
         mbgKLR/lRUtSZ2v2eKT6iZKW02RgE4LawNVIk5Oxo21A4oDXdmAOXDXpZZXk22a5JDs0
         22DIiS4E1K3si7dVvnl6kydK5l0VvCIIyQJ4Pi4Jv+1M8mwJ28Z/PoFAzE18sz07eVo4
         tuV8tnJRQE68kisDVM/6mNnYllnkB4RTBXkoT3ut8HyDB2kQCSpxkaJ/qko4j2muh+Uj
         5ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UPwQjon/JGAwP2hNwxa5hh2Gm9nZDXFP065oxigESDI=;
        b=Bb5+Lf98UKqK6ZulNSRQKvkOqSXYcmDHUsXnr0RFSMzBAHYEcQ6bsGSg3sEtpKCxu+
         Z/xFzIrDJ+0fPbM79NCUBb37zqNqdtyvj0KwaGdxq0aZPHLXixqh9rMMGh0rC1IiV8dx
         3GpOY/GSQRh3rXYDVmuWTbWpPFCfiWJQ0/fV3MW5IlTIKphmocU29wKU/fjRtMJsI3Sc
         HMf8SROojEZtNP4pq8WrY/lE4Yc8X9LQQaTtnu9T4TnT98hptGGbXV0sIhsVKjNRSh4E
         zOy0/MIMlwZM9hrS9egxmYX00ZNr+tnnwRj3nWUvsTZcowMaAj4bSIcamPuJ2fN7Ocnq
         f0Qw==
X-Gm-Message-State: AOAM530x7SnYCHNKVsPMn3rp91XgCRhRb2+eSs6QrmzX2hhxRifMt7dD
        MZFKm1iDWW4tQSNlepXwOcffi3a6ozU=
X-Google-Smtp-Source: ABdhPJy45b5shGF85tjBMKoIrwjTXQgDTjxMEs1AFFjyfkfEIb4NOz+fsiDzSekMZeuXua4qLG2Iqg==
X-Received: by 2002:a17:902:e8ce:b0:132:b140:9540 with SMTP id v14-20020a170902e8ce00b00132b1409540mr441432plg.28.1633363360045;
        Mon, 04 Oct 2021 09:02:40 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 41/52] KVM: PPC: Book3S HV P9: Don't restore PSSCR if not needed
Date:   Tue,  5 Oct 2021 02:00:38 +1000
Message-Id: <20211004160049.1338837-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This also moves the PSSCR update in nested entry to avoid a SPR
scoreboard stall.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          |  7 +++++--
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 26 +++++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f4445cc5a29a..f10cb4167549 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3876,7 +3876,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
 		msr = mfmsr(); /* TM restore can update msr */
 
-	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
@@ -3917,7 +3919,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
 	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
-	mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	store_vcpu_state(vcpu);
 
@@ -3930,6 +3931,8 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	return trap;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 0f341011816c..eae9d806d704 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -649,6 +649,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_dawr0;
 	unsigned long host_dawrx0;
 	unsigned long host_psscr;
+	unsigned long host_hpsscr;
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
@@ -666,7 +667,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_psscr = mfspr(SPRN_PSSCR);
+	host_psscr = mfspr(SPRN_PSSCR_PR);
+	if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		host_hpsscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
 
 	if (dawr_enabled()) {
@@ -750,8 +753,14 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 
-	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+
+	if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
+		      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	} else {
+		if (vcpu->arch.psscr != host_psscr)
+			mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	}
 
 	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
 
@@ -957,7 +966,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ic = mfspr(SPRN_IC);
 	vcpu->arch.pid = mfspr(SPRN_PID);
-	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
 
 	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
 	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
@@ -1003,9 +1012,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr);
 	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr);
 
-	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
-	mtspr(SPRN_PSSCR, host_psscr |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
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

