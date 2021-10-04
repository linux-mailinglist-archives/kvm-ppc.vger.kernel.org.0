Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60582421365
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhJDQDv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbhJDQDv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB07C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l6so191766plh.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xn4wh7zfveyTBFbm0dkvLMIw9n95PVL7hzWsJ1Vsmpw=;
        b=ngoqcK76pz+7dM35BoLUMaBeR48MnmkTh8kFN+yZQMQ66Dt/GylFfGGrYfKXhikCKk
         v8c7JWzTnIVFvqNEPDYdDOlgfEInb6tdn2VNVFhRILVjbTsUvPHhwYDDYCk2rvz4ixGU
         n8flP1WB9qEtrH/gXru9gCe6CQTcNk29oqJDJM1rreqQh6L1V+TY6C3Jaha/IyJlbaag
         O4UJ94Kup694AkoeTh/4MCfn9sK0JP+QB/VQNKJZ9aQO9FzMAS5cG8aVGjFtEG/ZDEIx
         XkAazQ0LF2ecPEu26O+g1XO/xt4vUPAUbs1yGHj4dxx4vHj8Fehi8zRRiBZ+PrN+DXoK
         4Fug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xn4wh7zfveyTBFbm0dkvLMIw9n95PVL7hzWsJ1Vsmpw=;
        b=Z2BySDq10Mu1Gedhum6IpjRHfj1J3IX+ihpo2DLAP4FIF1oQlDXOZwNVTxqShOFIVe
         MJVmdNEhS/T7ocNoIJq/a1M2KeTj37A8pd3P+twEc5t0elXO82ElYU/vLYd2r7aVPOSi
         zodW4YYRyjP0JKUvKz2ct5nA9jmiymTKV23UDm7fZ/W1cC7X0X5fei6VjxTTPlz4O1lb
         XEfASYW8Aup1fBrBe1lI1DBe57p8pa/oMwCJLmitKifuqJxnye6WXMxnZK65VVku1SsS
         97OaLiR+6wPdSUVUl8MR3AlLvkSic0T641xqrXnRZf7/k0+nRyGyU88ARW9yRfKC/mnd
         qALA==
X-Gm-Message-State: AOAM5311sEsFoA/jMQOdbCGF1HqqthpnkIaITkNVBSTQ4VQG2sfcRTrX
        AnXlstviNmgazF2lWfXO6iRHtlEJWN8=
X-Google-Smtp-Source: ABdhPJynBljTaDF/mKgN7BThuWj+RDiBNngwjhXttSoNOeKKtA+trSUomggos2CT3OIj0shw3DStlQ==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr33332818pjn.214.1633363321520;
        Mon, 04 Oct 2021 09:02:01 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 25/52] KVM: PPC: Book3S HV P9: Avoid SPR scoreboard stalls
Date:   Tue,  5 Oct 2021 02:00:22 +1000
Message-Id: <20211004160049.1338837-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Avoid interleaving mfSPR and mtSPR to reduce SPR scoreboard stalls.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          |  8 ++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 19 +++++++++++--------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f3c052b8b7ee..823d64047d01 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4308,10 +4308,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	store_spr_state(vcpu);
 
-	timer_rearm_host_dec(*tb);
-
-	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4326,6 +4322,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
+	timer_rearm_host_dec(*tb);
+
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
+
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 2bd96d8256d1..bd0021cd3a67 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -228,6 +228,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
+	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
+	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
+
 	if (vc->tb_offset) {
 		u64 new_tb = *tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -244,8 +247,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_DPDES, vc->dpdes);
 	mtspr(SPRN_VTB, vc->vtb);
 
-	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
-	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 	mtspr(SPRN_PURR, vcpu->arch.purr);
 	mtspr(SPRN_SPURR, vcpu->arch.spurr);
 
@@ -448,10 +449,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
-	      purr - vcpu->arch.purr);
-	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
-	      spurr - vcpu->arch.spurr);
+	local_paca->kvm_hstate.host_purr += purr - vcpu->arch.purr;
+	local_paca->kvm_hstate.host_spurr += spurr - vcpu->arch.spurr;
 	vcpu->arch.purr = purr;
 	vcpu->arch.spurr = spurr;
 
@@ -464,6 +463,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
 	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
 
+	vc->dpdes = mfspr(SPRN_DPDES);
+	vc->vtb = mfspr(SPRN_VTB);
+
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -481,6 +483,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
+	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr);
+	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr);
+
 	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
 	mtspr(SPRN_PSSCR, host_psscr |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -509,8 +514,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	vc->dpdes = mfspr(SPRN_DPDES);
-	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
-- 
2.23.0

