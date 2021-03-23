Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAD53454A1
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhCWBFz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhCWBFb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:31 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F16C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:27 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u19so10039326pgh.10
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rDbkWdAI83Tqu1ZH/y6wX5ISjpfuXmoalJcWaEvBc2M=;
        b=jCGImHVvrTIGhiB/iBHn+fMC+kYHXDBldx4tFGK3r7XTZZ+78C3vBCt58DTz2eIdNo
         OwE7q+I2BhmeBzv2JVyokvI15+jKQgTzCCR75h5trU8ldwkWMc5DOpwUaAK8lbbQGsrG
         JqWFmjFeq6NGiYCJ00uvUX2yiWEqPpMYFfIV/3tONQAJsKEoNR/o3gklgg4uLKPKGjzV
         j3+jLh7M19xb8+xa+MX18j5K7wrshs+vjwng6BmW9m/vTruQF3eIUYD4+rApvMeBLChs
         2dcdITuryyt+P14UsqgM/cN7Q6IcB9iLvT9oCeXugbUjCNuKla7Ukq3tk2u4hwHO36Gl
         EpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rDbkWdAI83Tqu1ZH/y6wX5ISjpfuXmoalJcWaEvBc2M=;
        b=ETEXv5oxKztLzBf3jsDXyhUOLVpW4iGm2o+TQCkcgUqkC9Irsoenu2xi60aAUAf1nP
         9ltsQ+wf8a+mcVsO1QxLwXnDfkhRzGs4vsSKu0E9VZgrjOj+WYl0isNpoqOFGKumOHdv
         QqXH4hLeiUC1LIxq1ppAslx0iCVT1Rgr//OaA7iFX7Cty1UhGHZRnWmNdrEUMxpxPYKm
         7JljdY5bsGJ/rnqtbEIe9Y2QCuPYGgs+i0z8jmvG8q5v37DC+Qr+NTrxKMwkM7ozK7AJ
         9qhgMPQ3BUndQSci49ca/RdLwo+IQ25t0add60Qb/Dbn9sTCTpV8WGyIHRUzwbEsPeve
         lR1Q==
X-Gm-Message-State: AOAM532bieDrd0q+dZA/v43Gum0+6uT5OVWAuN10/My1BqNNX0+QuhfR
        pn8apHJ+8Sj7lw26xCIuB4VwkJeYnMQ=
X-Google-Smtp-Source: ABdhPJyUlt+XUl/1cQlkARzE3TMpkt01hsaQzpibi3eUwUXgcjdiO9ARCNqRiz4rNlKGII3fab2Ivw==
X-Received: by 2002:a05:6a00:1484:b029:214:23e5:a4f3 with SMTP id v4-20020a056a001484b029021423e5a4f3mr2387018pfu.26.1616461526655;
        Mon, 22 Mar 2021 18:05:26 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 45/46] KVM: PPC: Book3S HV P9: implement hash host / hash guest support
Date:   Tue, 23 Mar 2021 11:03:04 +1000
Message-Id: <20210323010305.1045293-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This additionally has to save and restore the host SLB, and also
ensure that the MMU is off while switching into the guest SLB.

P9 and later CPUs now always go via the P9 path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S     |  6 +++++
 arch/powerpc/kvm/book3s_hv.c           |  4 ++-
 arch/powerpc/kvm/book3s_hv_interrupt.c | 35 ++++++++++++++++++++++----
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 845df5fefdbd..7cef6f5212d8 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -339,6 +339,12 @@ kvmppc_p9_exit_interrupt:
  * effort for a small bit of code. Lots of other things to do first.
  */
 kvmppc_p9_bad_interrupt:
+BEGIN_MMU_FTR_SECTION
+	/*
+	 * Hash host doesn't try to recover MMU (requires host SLB reload)
+	 */
+	b	.
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 	/*
 	 * Set GUEST_MODE_NONE so the handler won't branch to KVM, and clear
 	 * MSR_RI in r12 ([H]SRR1) so the handler won't try to return.
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c151a60c0daa..e732d65772b1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4462,7 +4462,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (radix_enabled())
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -5543,6 +5543,8 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 		return -EPERM;
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
+	if (!radix_enabled())
+		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 03fbfef708a8..bd95d05219b7 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -149,7 +149,7 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 	 */
 }
 
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
 	isync();
 	mtspr(SPRN_PID, pid);
@@ -158,6 +158,23 @@ static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
 	isync();
 	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
 	isync();
+
+	if (!radix_enabled())
+		slb_restore_bolted_realmode();
+}
+
+static void save_clear_host_mmu(struct kvm *kvm)
+{
+	if (!radix_enabled()) {
+		/*
+		 * Hash host could save and restore host SLB entries to
+		 * reduce SLB fault overheads of VM exits, but for now the
+		 * existing code clears all entries and restores just the
+		 * bolted ones when switching back to host.
+		 */
+		mtslb(0, 0, 0);
+		slb_invalidate(6);
+	}
 }
 
 static void save_clear_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
@@ -292,15 +309,23 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_AMOR, ~0UL);
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_GUEST_HV_FAST;
+
+	/*
+	 * Hash host, hash guest, or radix guest with prefetch bug, all have
+	 * to disable the MMU before switching to guest MMU state.
+	 */
+	if (!radix_enabled() || !kvm_is_radix(kvm) ||
+			cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+
+	save_clear_host_mmu(kvm);
+
 	if (kvm_is_radix(kvm)) {
-		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-			__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 		if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
 			__mtmsrd(0, 1); /* clear RI */
 
 	} else {
-		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_hpt(kvm, vcpu, lpcr);
 	}
 
@@ -486,7 +511,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host_radix(kvm, host_pidr);
+	switch_mmu_to_host(kvm, host_pidr);
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	/*
-- 
2.23.0

