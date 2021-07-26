Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330B63D51DA
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhGZDMA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhGZDMA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:00 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB26C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m1so11126158pjv.2
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i9H2zE5BQgIqgQefqlymemI2qVOIx89ENHZOOC1fDxM=;
        b=Aqa31gWsRY2Tv2rhn5S8YAx+p89ZkAuMaDh3Ve6ZIrO2lz+niaGWpPFS+jrmCymdKh
         K086RDyrCHiUfqd3Bu7dEhJofHkRF2eW0bdf/BGGncM6RjlxFI+DT6IFLrXvN+6UokMx
         EJ4W44e85CU/CjRHWQ7Wx3LwOeMnBzvpxaCeRLtdUHTtky2wuCam9NLbtgwWtLNuvO/A
         okx6Hllf1KbnypVjz4z3+1FocjEE1CVCYSYKP9dTUcWdcqf60F4tWdTK7xA2Pbql/Sjr
         Vc1/3CAQls/vudjKGqBWVky9kbZn4J+8OGPmwSXrJROhNGQ3nggZOo/S9ZichhWEB4yd
         GM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i9H2zE5BQgIqgQefqlymemI2qVOIx89ENHZOOC1fDxM=;
        b=S6lg1lDc7uFZHveWzKwMPSMrINq5NfdEr2Gt998rpE2OYCoSlxxrLJwkzZq6iZXeR6
         MYrQro1MnX5i0817SkcamPXVWQPwYfW+qIt4crs/sydrWMpsehlLtfMFN6K/B+U3++Ga
         XByHSDq/NHFY3V6/fL2qHlHCxGnNNYnx0rwNBPXbngRuQKon93lKaAWxRqQMfQQguuN1
         Spj4EkMdJZdw2r91+hWPzABSSssGG7rMgkjUegeUVbTgNDTGZspw2rO4hn/BwgzkOuE5
         D+jdWqILFiSkoKfAOebmmi9KOU710Qxx2NK8i9Qi1L7P6dZYd7Dk35Y/LRhzejAxxtHw
         vURQ==
X-Gm-Message-State: AOAM531xjXbexxYgZ3WLTuynP6qUgdyQxukMqQt5xlI43Ao0IOHeitnR
        9b6KO/tDokAOSwDv06PVmvXdDV3ecAg=
X-Google-Smtp-Source: ABdhPJyqTWQXw0SLueB8qxriflkAzv8/ErHOIbGjBB7w86lwMqlhPg+N0AQKEv5gjyqZyNMnPWfqjg==
X-Received: by 2002:a62:3852:0:b029:32e:50d4:6ee5 with SMTP id f79-20020a6238520000b029032e50d46ee5mr15751754pfa.3.1627271548855;
        Sun, 25 Jul 2021 20:52:28 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 45/55] KVM: PPC: Book3S HV P9: Don't restore PSSCR if not needed
Date:   Mon, 26 Jul 2021 13:50:26 +1000
Message-Id: <20210726035036.739609-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index c0a04ce39e00..a37ab798eb7c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3856,7 +3856,9 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
 		msr = mfmsr(); /* TM restore can update msr */
 
-	mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, vcpu->arch.psscr);
+
 	kvmhv_save_hv_regs(vcpu, &hvregs);
 	hvregs.lpcr = lpcr;
 	vcpu->arch.regs.msr = vcpu->arch.shregs.msr;
@@ -3897,7 +3899,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
 	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
-	mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	store_vcpu_state(vcpu);
 
@@ -3910,6 +3911,8 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	timer_rearm_host_dec(*tb);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+	if (vcpu->arch.psscr != host_psscr)
+		mtspr(SPRN_PSSCR_PR, host_psscr);
 
 	return trap;
 }
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 976687c3709a..52690af66ca9 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -639,6 +639,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	unsigned long host_dawr0;
 	unsigned long host_dawrx0;
 	unsigned long host_psscr;
+	unsigned long host_hpsscr;
 	unsigned long host_pidr;
 	unsigned long host_dawr1;
 	unsigned long host_dawrx1;
@@ -656,7 +657,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_psscr = mfspr(SPRN_PSSCR);
+	host_psscr = mfspr(SPRN_PSSCR_PR);
+	if (cpu_has_feature(CPU_FTRS_POWER9_DD2_2))
+		host_hpsscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
 
 	if (dawr_enabled()) {
@@ -740,8 +743,14 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
 
@@ -947,7 +956,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ic = mfspr(SPRN_IC);
 	vcpu->arch.pid = mfspr(SPRN_PID);
-	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
 
 	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
 	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
@@ -993,9 +1002,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

