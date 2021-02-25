Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB68A3250D1
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhBYNs4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBYNsz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:55 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0E2C061794
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:40 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id s16so3208395plr.9
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BdUM20RYIE/jm7f4nL8DUwkMLUwopPt6d3FqQLRKZzI=;
        b=ay7Nqv9oX16z0rS/UJufxRfupXdWME1rJIFGqpqtUDVXfEr1oqBT+SoH7ICU/HbagX
         wS9MLNjSHb/zlJZ+/RHKOGNIh2xPg3EFx6iaeH8SoLt8YGHqXd8AS2rkV1Tmct5HQp7q
         /VdnrVZgRf0nk9aD2Z5jRElOm02p7/TCsNDb9zoWYUQWgrMKQZ/qHsLCCSOWDfgH5dVU
         jSFW5bhRxGPCp3w6wrKSapS4Vi2imJWEKgM+7IipkaZvPNTzj3pu8saUS+GXsYlmIgt2
         KlAYtKlxSha494el+4YcidKb+pq1nXcWQBLpMsCgdty8Pru6cYKnp77rZZCiE4p4+U13
         K07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdUM20RYIE/jm7f4nL8DUwkMLUwopPt6d3FqQLRKZzI=;
        b=Ht1GgZGBU1LXDSc19SHsW2jOXL24dLMv+PYPakfuKI3GCiUqp2InlvmoLs8nArGQvr
         PSC+bvSE30UTsqKU2c6e/KpBvRqox0Olor+rxs9K1+et4j5wJkaHNB4GADibJpP7ORgL
         ih8QibeUXGfWm2Zkahb6g0E+A39flGvIE4kTeypOz/I1V3sdoAredMOZ6VeFz0Ui74mS
         gEv1XR1i5ES5m49jkhneBRDZL6Fb/+IawX2km05NM2rUsZiPp1Ho2xohQzhFmdlzGMXH
         G45C3Jmtw+rxlRW+D54aqkD105l3UlI7w0m2KkQ0K+ApqZbyCVfbq8cS8SzafDQWaqdN
         1Y9g==
X-Gm-Message-State: AOAM533eKfzlRevEQT3eOcnJi8y8i33vkN5tWqAFeCCL6I+onRhJjV4l
        kOCTrDt3KlmhQZh/PdtfdjIYwjB0xPw=
X-Google-Smtp-Source: ABdhPJxeiXR7nziq7swxRFZBtB68BlgktFfgZM1CueNq+YO24amjZgqnd2mPjLf4elbkBeSrrgvYBw==
X-Received: by 2002:a17:902:aa8f:b029:e3:df7f:fd51 with SMTP id d15-20020a170902aa8fb02900e3df7ffd51mr3162731plr.71.1614260919412;
        Thu, 25 Feb 2021 05:48:39 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:38 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 28/37] KVM: PPC: Book3S HV P9: Add helpers for OS SPR handling
Date:   Thu, 25 Feb 2021 23:46:43 +1000
Message-Id: <20210225134652.2127648-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c | 131 ++++++++++++++++++++++-------------
 1 file changed, 84 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 94989fe2fdfe..ad16331c3370 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3442,6 +3442,84 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
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
+	/* XXX: DAR, DSISR must be set with MSR[RI] clear (or hstate as appropriate) */
+	mtspr(SPRN_AMR, vcpu->arch.amr);
+	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
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
+	mtspr(SPRN_PSPB, 0);
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
 /*
  * Virtual-mode guest entry for POWER9 and later when the host and
  * guest are both using the radix MMU.  The LPIDR has already been set.
@@ -3450,11 +3528,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3469,6 +3543,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
+	save_p9_host_os_sprs(&host_os_sprs);
+
 	kvmhv_save_host_pmu();		/* saves it to PACA kvm_hstate */
 
 	kvmppc_subcore_enter_guest();
@@ -3496,22 +3572,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
-	/* XXX: DAR, DSISR must be set with MSR[RI] clear (or hstate as appropriate) */
-	mtspr(SPRN_AMR, vcpu->arch.amr);
-	mtspr(SPRN_UAMOR, vcpu->arch.uamor);
-
-	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+	load_spr_state(vcpu);
 
 	/*
 	 * XXX: must always deal with irq_work_raise via NMI vs setting DEC.
@@ -3605,34 +3666,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
-	mtspr(SPRN_PSPB, 0);
 
-	if (host_amr != vcpu->arch.amr)
-		mtspr(SPRN_AMR, host_amr);
+	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	if (host_fscr != vcpu->arch.fscr)
-		mtspr(SPRN_FSCR, host_fscr);
+	store_spr_state(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
 	store_fp_state(&vcpu->arch.fp);
-- 
2.23.0

