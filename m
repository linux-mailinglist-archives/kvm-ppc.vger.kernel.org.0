Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF49E32EDF3
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCEPJV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhCEPJO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:09:14 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A94C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:09:14 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j6so1552968plx.6
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SVlS4MYoLJyqG+eQ+uk9NSuOoV60cMlphH1iexhIotY=;
        b=HmGnYYY4itH4l8xBg8VlwCB4zi9+qz5C2tx1ecCtMYyOhJzYErXJptP4pYuz531Hze
         /W9ex7TN+/c48Gv/HODRi8YhMouqQiNhArPxrIVGt3/85e9NqY7iAj5awTb30H+znusJ
         Tg5E6QCReZRkycAy/igeoNDmyYNwKvc/mbnzf/2G2cyrNGiEs3yswfmPsIUfkPBB/7bb
         udi29NOk3jmOmsLjZwQlo2O9c1NUMhO5rB/bcB5luouIgJqeyKAVFGJLgnownQJoDDhY
         xpp5mPtQOIaXU+Fz8wVqGTJIebPSZAGAbrPdUT0vELObO7a6qKykAD8tzfIHiu8QdBW+
         pvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVlS4MYoLJyqG+eQ+uk9NSuOoV60cMlphH1iexhIotY=;
        b=PnJn4qbMxt+K9/OilfkAUPOGPPN3bHEfoe/k5wCb/CBg7vGMYVq4Tn0KvH1x6Gs0Rf
         m+khjQ0TnFFqGTKjBBjnyddReUw/D/Xh5au/tpEnJi2PTigdPPaDEA4DRk1/mJLk5r8Y
         neL3l9nrd7hwdeUxxjTY1QEN2YtgG5e9lomfI5OrwB4X2mVZUzEvwjPiBfPM7firMAW4
         6oOpMsi3Nqq3k20Gm9pxsZEJkvIg00bSNOg9uc9yUK/d7clJ1931yS7vvzsmtgkR6rQU
         gTUaMyXg1gANfOTsjBMD/PgugdQdJl5+LEzsgQkd0WxFEaUQzEw19SsXyYjfe1OZT0kF
         tPMQ==
X-Gm-Message-State: AOAM5323HrLknURfV3l1PU6kIUDYbeG41JlH0CUfN3VB453MoBec30gF
        ItArfkwEIxa0fq0+992bKvmeL3qYNpM=
X-Google-Smtp-Source: ABdhPJz6ru8Vd72ImL4x5mqB6H21D4w5NLD4YDIUtOYkFpnHS55EcrzxUGyqQYlTljrGvg3bVOn75w==
X-Received: by 2002:a17:90a:e298:: with SMTP id d24mr10721722pjz.171.1614956953585;
        Fri, 05 Mar 2021 07:09:13 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:09:12 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 40/41] KVM: PPC: Book3S HV P9: implement hash host / hash guest support
Date:   Sat,  6 Mar 2021 01:06:37 +1000
Message-Id: <20210305150638.2675513-41-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index 8cb1322cfe00..8d5b92f258ea 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -313,6 +313,12 @@ kvmppc_p9_exit_interrupt:
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
index 588ac794a90b..db3f7e0bf832 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4436,7 +4436,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (radix_enabled())
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -5516,6 +5516,8 @@ static int kvmhv_enable_nested(struct kvm *kvm)
 		return -EPERM;
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		return -ENODEV;
+	if (!radix_enabled())
+		return -ENODEV;
 
 	/* kvm == NULL means the caller is testing if the capability exists */
 	if (kvm)
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index aba3641bae4f..d29ca797cb50 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -143,12 +143,29 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 }
 
 
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
 	mtspr(SPRN_PID, pid);
 	mtspr(SPRN_LPID, kvm->arch.host_lpid);
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
@@ -283,15 +300,23 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
 
@@ -477,7 +502,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host_radix(kvm, host_pidr);
+	switch_mmu_to_host(kvm, host_pidr);
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
 	/*
-- 
2.23.0

