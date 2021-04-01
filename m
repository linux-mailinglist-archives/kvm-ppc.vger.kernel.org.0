Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0380351976
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhDARxo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhDARpe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:45:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3736C00F7C5
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x126so1653571pfc.13
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8CcN39BgTMIJ+HBCsdK36qvO/NDMvMx6boOM8ovJcxU=;
        b=nF0ftfm82LmH1SRIyCpUeb+6Z7c/SnDr9AmLYN5uRSoT0MrY96EoeMKN7L6dvCHl4N
         0iXykUBJQ0ttrv39wKH0CvPJYGxpW8RhUnEvDdHX20ypYBYwDLyIa/y8Nu7LBXkIK89y
         5bLM3e5MTRvO8I47R2tA5lQYKexwp4d7q4sNfea8ml1C/5kFyxe9RfmudRroBX1Df/Ux
         3Zgu8QJh4etNXquuYCA88NYmOc3efN1jaCzrNpx4cUu1qNDXGPmVIpBqie5qBDYsfdHQ
         KDPJETTwnQhSo2bD2KfczIxdkwR41mZQg9WRjnjsuvT0+/qyE+ymeXeQaePu1gYhV0Zs
         6cTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8CcN39BgTMIJ+HBCsdK36qvO/NDMvMx6boOM8ovJcxU=;
        b=fLdLdymKOFIOvjlPFaru7lfxrmJLj7+WXg4GE01QuLOmxeI1A4AlqlFxnhkTR9cVVe
         HNIagWBp+JxJ/EGobnvDtiATh5ulFjzIz5BURZ3yOPAKRC50P9IKprUkZcPd1TRkQ6H8
         +8pU7Qjcq2851c1ZhhO4ZKqwHvKZAbPAHywI8txtkLsFkHbZ+nZxTbnGUBG2vSJFCKcK
         oHqKYmOakyHF8sf5zQmjFOasNZ5fjgGqFPCL2v1vECiZWP/cXAexHyl1PGAlgE3emkPw
         QuG9Dx5KZBh0qN0aJTlwwv67NJOs/lwqufkJffakAsusLyuyRlqqgPjtBYXKY0zX/mGi
         70Cw==
X-Gm-Message-State: AOAM5338dXcr0Ay9Xr4mJe2p7JgaGIYB9YC+2qmcA66FnhnoMHL4aAR/
        PrGl7Fk15s2AavkXuNC2eosaB68CXUs=
X-Google-Smtp-Source: ABdhPJyWYi0kN6aSwTR5KORgZDehEMIuHmatZfYpElFlqMXXQ//yEbmueWYgsdCzv2cx4J+YnjYf9g==
X-Received: by 2002:a62:ee0c:0:b029:214:7a61:6523 with SMTP id e12-20020a62ee0c0000b02902147a616523mr7871268pfi.59.1617289524248;
        Thu, 01 Apr 2021 08:05:24 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 35/48] KVM: PPC: Book3S HV P9: Add helpers for OS SPR handling
Date:   Fri,  2 Apr 2021 01:03:12 +1000
Message-Id: <20210401150325.442125-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index 5953d1d72f2e..785925362630 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3492,6 +3492,89 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
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
 	return req == H_EOI || req == H_CPPR || req == H_IPI ||
@@ -3506,11 +3589,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3524,6 +3603,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (next_timer < time_limit)
 		time_limit = next_timer;
 
+	save_p9_host_os_sprs(&host_os_sprs);
+
 	kvmhv_save_host_pmu();		/* saves it to PACA kvm_hstate */
 
 	kvmppc_subcore_enter_guest();
@@ -3551,28 +3632,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3668,33 +3728,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

