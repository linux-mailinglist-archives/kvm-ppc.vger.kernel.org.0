Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA33E955E
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhHKQDg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbhHKQDf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA0C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so5813646pjb.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PqyRTscdsTGKYKfnYwkZD3pK5phryJeQLedqJYFt8j0=;
        b=PhC1DPPWo48cbqfOKin9V+yRb719XqP2DuQleOU/qTymiiG4BB5mXjW3h2pzN3B6vu
         7RJTZeDBYmVMdyyxA19TLPdFxGd2kYqJlZOEtUOqcT4LgKG/riKxdPdWLBMA+k6/ntjl
         YCgFDFlP3RalSNaJtDjIV6tT7+B/+R1pWnsCCa4hW7CRGVZj9SEUBo+ZarWl8g8BcgJ4
         ppVw9EYO8vWpNkdnt+qKPIJ/KJUJ1TdzLQ7iin2RbPE9Bsyz5tWSlWV/zMre9LTzioPm
         VhZCljNK8nnO/MlKCP1TjtmtsieJXc4ZWage10+Xmz9dMw0IYlDnGyREH46/k4LnIZzD
         PU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PqyRTscdsTGKYKfnYwkZD3pK5phryJeQLedqJYFt8j0=;
        b=BAUz37FfNGBsHWd5lmr7zj7KCKAYupg6x/FIapc96Z4adEh5sOVjvIAp8bEJULLU4i
         Ce9qidNvL20fCVm9l2pso8BDJDbmWClq8N1jBRRu4Il7KU6f3zdIm7u27s609oT7bh5a
         zFfDBhl8KVztYgbeN3rB9PIr0fKXXx69WMgH7NEhEGzh25ZrGzbNnbvJmiq/NMFlEBzV
         tcA8+hl3ZAmmKgp2jh+j6MhUfHj/lmHOGMSezpWUVWjFN9CQizu9a8lEDXIJVoCL0/cR
         8Qf3ChNivhqlVui1aFYwL8ms2RSRGmGH54zVHSxfznQLqWF6t/9eWXNq9/Dso1C9NQCC
         b+XA==
X-Gm-Message-State: AOAM531hXG7G7q0Uv+9Y1eOvgb9cK4ii5RmKDG0lSAhGydwiJCEZb+1d
        aCY/WwaZEiHaEm3kO3NhB9pofvNjxHw=
X-Google-Smtp-Source: ABdhPJy0edYN5bugMMus7taMQ6SUWGtuhtTDc9nixUI473SX0KeZBhtYqPW/tpqpOtZ+mLKaRaA0+Q==
X-Received: by 2002:a63:4a55:: with SMTP id j21mr90731pgl.187.1628697791656;
        Wed, 11 Aug 2021 09:03:11 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 33/60] KVM: PPC: Book3S HV P9: Avoid SPR scoreboard stalls
Date:   Thu, 12 Aug 2021 02:01:07 +1000
Message-Id: <20210811160134.904987-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index a390980b42d8..823e501c5ebe 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4307,10 +4307,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	store_spr_state(vcpu);
 
-	timer_rearm_host_dec(*tb);
-
-	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
-
 	store_fp_state(&vcpu->arch.fp);
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
@@ -4325,6 +4321,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

