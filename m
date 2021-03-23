Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1BC345490
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhCWBFY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhCWBE6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF59C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:58 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y5so12533875pfn.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u02W+1uPYr0zNoCJeEXNYnFcxtXSiID7jXsy9YKadYU=;
        b=hJAaNEUqkUaNpVYToUOi7iQXHJ4JZCmc2PkenUEVzs/rsTG2cmh6tPX1nAAHI88cXG
         7BzP+nqd6rr5LK0KxOMiFvUKRZ1WJPQqmRtUni2N49W6ZLNTZsP21oqCB0shSJpJRHbi
         mtsci8nWEV9RQUaMSNo5Y35Un0H2utxbhcmHvuc2bcra9Ms0HOCvQyIVa7t9yy8sbcem
         e7p+ViHyb/5DxTmy1DFuJuvmzX6T5fRDcoSx+njYpppyvXpM1CkAThQN+Bq7Sp5Rqs9g
         ReHL2yyNruP6IZZ1iu+kQD+tvhroMKoZEPUa/E3LwvwxD+AWYuKsiPKGhl3YN0ZpS2hb
         HcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u02W+1uPYr0zNoCJeEXNYnFcxtXSiID7jXsy9YKadYU=;
        b=eXO1Kj1SdUOemwhi8HxVJ/j+0UvuEED7wdaUIj2rtrwuEJckL7cgwENrLXoKf+slS1
         xqNAISVmqz6f2C90RC3SWlBmvLsUKEy92U2FO5ZZHSTc5EOig/FW1221dwKdA2Ix+jUZ
         OK0vSoWbcH9aJDyARo5UwADAzUcX8ENfEuVzmzU30wky3tFrQ5mw/nwTs/0J9WffuLQq
         DWK8oCkPwI6wPdvna+ommNVNPE+CN42wcSAp9RhGsdLa0LgUDCEl3b0oB8tGMUmkepyf
         McTznwBY6o/xbA0OC1Rdb6UTWa8VnGk86MgeEgJfuoJpW+FrRowxp41ldLT2JhGjEe+b
         4rWw==
X-Gm-Message-State: AOAM5335xM4Tn23IlrECQyTDDTbJo4W25bzxpV4sYlhVsu887Rl1VSvN
        Xby/8eYEZAuBwZG4dew0F3NlgHmCufU=
X-Google-Smtp-Source: ABdhPJyNeSd7pP70Btxo/+3dgXpEm14Zj4O0sbvB2ddU4SwF1nbaZr7G9S9b0XUf9w3xGHjSkiF34g==
X-Received: by 2002:a63:af05:: with SMTP id w5mr1894336pge.153.1616461497824;
        Mon, 22 Mar 2021 18:04:57 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 34/46] KVM: PPC: Book3S HV P9: Add helpers for OS SPR handling
Date:   Tue, 23 Mar 2021 11:02:53 +1000
Message-Id: <20210323010305.1045293-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is a first step to wrapping supervisor and user SPR saving and
loading up into helpers, which will then be called independently in
bare metal and nested HV cases in order to optimise SPR access.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 141 ++++++++++++++++++++++-------------
 1 file changed, 89 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 98e5ae897fad..74c67f713a26 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3481,6 +3481,89 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
+static void load_spr_state(struct kvm_vcpu *vcpu)
+{
+	mtspr(SPRN_DSCR, vcpu->arch.dscr);
+	mtspr(SPRN_IAMR, vcpu->arch.iamr);
+	mtspr(SPRN_PSPB, vcpu->arch.pspb);
+	mtspr(SPRN_FSCR, vcpu->arch.fscr);
+	mtspr(SPRN_TAR, vcpu->arch.tar);
+	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
+	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
+	mtspr(SPRN_BESCR, vcpu->arch.bescr);
+	mtspr(SPRN_WORT, vcpu->arch.wort);
+	mtspr(SPRN_TIDR, vcpu->arch.tid);
+	mtspr(SPRN_AMR, vcpu->arch.amr);
+	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
+
+	/*
+	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
+	 * clear (or hstate set appropriately to catch those registers
+	 * being clobbered if we take a MCE or SRESET), so those are done
+	 * later.
+	 */
+
+	if (!(vcpu->arch.ctrl & 1))
+		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+}
+
+static void store_spr_state(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
+
+	vcpu->arch.iamr = mfspr(SPRN_IAMR);
+	vcpu->arch.pspb = mfspr(SPRN_PSPB);
+	vcpu->arch.fscr = mfspr(SPRN_FSCR);
+	vcpu->arch.tar = mfspr(SPRN_TAR);
+	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
+	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
+	vcpu->arch.bescr = mfspr(SPRN_BESCR);
+	vcpu->arch.wort = mfspr(SPRN_WORT);
+	vcpu->arch.tid = mfspr(SPRN_TIDR);
+	vcpu->arch.amr = mfspr(SPRN_AMR);
+	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
+	vcpu->arch.dscr = mfspr(SPRN_DSCR);
+}
+
+/*
+ * Privileged (non-hypervisor) host registers to save.
+ */
+struct p9_host_os_sprs {
+	unsigned long dscr;
+	unsigned long tidr;
+	unsigned long iamr;
+	unsigned long amr;
+	unsigned long fscr;
+};
+
+static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
+{
+	host_os_sprs->dscr = mfspr(SPRN_DSCR);
+	host_os_sprs->tidr = mfspr(SPRN_TIDR);
+	host_os_sprs->iamr = mfspr(SPRN_IAMR);
+	host_os_sprs->amr = mfspr(SPRN_AMR);
+	host_os_sprs->fscr = mfspr(SPRN_FSCR);
+}
+
+/* vcpu guest regs must already be saved */
+static void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
+				    struct p9_host_os_sprs *host_os_sprs)
+{
+	mtspr(SPRN_PSPB, 0);
+	mtspr(SPRN_WORT, 0);
+	mtspr(SPRN_UAMOR, 0);
+
+	mtspr(SPRN_DSCR, host_os_sprs->dscr);
+	mtspr(SPRN_TIDR, host_os_sprs->tidr);
+	mtspr(SPRN_IAMR, host_os_sprs->iamr);
+
+	if (host_os_sprs->amr != vcpu->arch.amr)
+		mtspr(SPRN_AMR, host_os_sprs->amr);
+
+	if (host_os_sprs->fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, host_os_sprs->fscr);
+}
+
 static inline bool hcall_is_xics(unsigned long req)
 {
 	return (req == H_EOI || req == H_CPPR || req == H_IPI ||
@@ -3495,11 +3578,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	unsigned long host_dscr = mfspr(SPRN_DSCR);
-	unsigned long host_tidr = mfspr(SPRN_TIDR);
-	unsigned long host_iamr = mfspr(SPRN_IAMR);
-	unsigned long host_amr = mfspr(SPRN_AMR);
-	unsigned long host_fscr = mfspr(SPRN_FSCR);
+	struct p9_host_os_sprs host_os_sprs;
 	s64 dec;
 	u64 tb, next_timer;
 	int trap, save_pmu;
@@ -3514,6 +3593,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (next_timer < time_limit)
 		time_limit = next_timer;
 
+	save_p9_host_os_sprs(&host_os_sprs);
+
 	kvmhv_save_host_pmu();		/* saves it to PACA kvm_hstate */
 
 	kvmppc_subcore_enter_guest();
@@ -3541,28 +3622,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 #endif
 	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
-	mtspr(SPRN_DSCR, vcpu->arch.dscr);
-	mtspr(SPRN_IAMR, vcpu->arch.iamr);
-	mtspr(SPRN_PSPB, vcpu->arch.pspb);
-	mtspr(SPRN_FSCR, vcpu->arch.fscr);
-	mtspr(SPRN_TAR, vcpu->arch.tar);
-	mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
-	mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
-	mtspr(SPRN_BESCR, vcpu->arch.bescr);
-	mtspr(SPRN_WORT, vcpu->arch.wort);
-	mtspr(SPRN_TIDR, vcpu->arch.tid);
-	mtspr(SPRN_AMR, vcpu->arch.amr);
-	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
-
-	/*
-	 * DAR, DSISR, and for nested HV, SPRGs must be set with MSR[RI]
-	 * clear (or hstate set appropriately to catch those registers
-	 * being clobbered if we take a MCE or SRESET), so those are done
-	 * later.
-	 */
-
-	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+	load_spr_state(vcpu);
 
 	/*
 	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
@@ -3658,33 +3718,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;
 	vcpu->arch.thread_cpu = -1;
-	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
-
-	vcpu->arch.iamr = mfspr(SPRN_IAMR);
-	vcpu->arch.pspb = mfspr(SPRN_PSPB);
-	vcpu->arch.fscr = mfspr(SPRN_FSCR);
-	vcpu->arch.tar = mfspr(SPRN_TAR);
-	vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
-	vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
-	vcpu->arch.bescr = mfspr(SPRN_BESCR);
-	vcpu->arch.wort = mfspr(SPRN_WORT);
-	vcpu->arch.tid = mfspr(SPRN_TIDR);
-	vcpu->arch.amr = mfspr(SPRN_AMR);
-	vcpu->arch.uamor = mfspr(SPRN_UAMOR);
-	vcpu->arch.dscr = mfspr(SPRN_DSCR);
-
-	mtspr(SPRN_PSPB, 0);
-	mtspr(SPRN_WORT, 0);
-	mtspr(SPRN_UAMOR, 0);
-	mtspr(SPRN_DSCR, host_dscr);
-	mtspr(SPRN_TIDR, host_tidr);
-	mtspr(SPRN_IAMR, host_iamr);
 
-	if (host_amr != vcpu->arch.amr)
-		mtspr(SPRN_AMR, host_amr);
+	store_spr_state(vcpu);
 
-	if (host_fscr != vcpu->arch.fscr)
-		mtspr(SPRN_FSCR, host_fscr);
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
-- 
2.23.0

