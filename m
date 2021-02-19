Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F95131F525
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhBSGhV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSGhU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:20 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B44C0617AA
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:25 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id a4so3039423pgc.11
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bgrlWIKk/fdLPd72M+1rlw4usM9xAQm/ErTKja/l7uw=;
        b=Rtp6sLkLeiZCUyPKA2jA9Tlo7+u9CnsNXzyKo4z0/g3YvAS6JY/8V3PYDbsojnLjBL
         9s1GJS9MEjEGz2M2HmFFwmjCFHyzXHPoapuwlVkXk52T1uTj7mcVBvWkzlUx4ZUM3QH5
         U5yTbx6p492a9vb9njtZjr6K5Js7oeJ4R5dYvZXf3DuxA+crfW6N0MUsd9OuJdf927yD
         dEfU807RdiSeQtVrEyWpIUdpl2czSJGrBJeiFHjr4AkrU1rUxMvTO4v/V26Mqk+NM9Lj
         3zVRL5w/2kM6n0XHYYpeoXJvChtbXnIuYI45fUz2WCn4hvQlqyWg1cExlnOcKRskzTZu
         w1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bgrlWIKk/fdLPd72M+1rlw4usM9xAQm/ErTKja/l7uw=;
        b=CUQoMZetE993SY9lUb1bCb1OmFMoCjpF+SLmJHiZckavf23KbaCz5zP6XX1R4F4qXt
         VSxm0pFwCPFaTniyRcJzMUgbbp6xtpY1pSEKlhp4a2c757pEDBh+D4PiTyQH3sOswpBM
         XuMdzGWbGTiL9bCoZTGe499n2cFlImZSnbM+ailI03jypTsD2T5JjUE/wZTX/3uCx1YV
         7z+iHmewkL3vq3aTpTfjN43q7z+GUeYukYPdh8g80b/8oRtG54bqyoj0bJLyeMPXoYrs
         j8dlj6O1zUFWwx8Z6mHqrlGDMUkRhZbOg0YgdPJBQp3ptUMTk3WwvoQmklvMb9youwBU
         8FZw==
X-Gm-Message-State: AOAM5323FoIJ0wlJxgy1HlDiLhc+ECF10ubZ6T79RWJZ1Y06dX2fFdik
        0bI1reqn/gYsMuvB6+GnCU2K3MmzOks=
X-Google-Smtp-Source: ABdhPJxZDhvLKGe8sJa1326/Ky0eof7DuPIm8fgC+j91UZFae/n61nKPZTzUPs+o53cxdUT8iQsYAQ==
X-Received: by 2002:a05:6a00:22d1:b029:1b4:9bb5:724c with SMTP id f17-20020a056a0022d1b02901b49bb5724cmr8156558pfj.63.1613716584314;
        Thu, 18 Feb 2021 22:36:24 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:23 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 12/13] KVM: PPC: Book3S HV: Move radix MMU switching together in the P9 path
Date:   Fri, 19 Feb 2021 16:35:41 +1000
Message-Id: <20210219063542.1425130-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Switching the MMU from radix<->radix mode is tricky particularly as the
MMU can remain enabled and requires a certain sequence of SPR updates.
Move these together into their own functions.

This also includes the radix TLB check / flush because it's tied in to
MMU switching due to tlbiel getting LPID from LPIDR.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 50 +++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 53d0cbfe5933..6bf7f5ce4865 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3446,12 +3446,38 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
+static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	u32 lpid;
+
+	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
+
+	mtspr(SPRN_LPID, lpid);
+	mtspr(SPRN_LPCR, lpcr);
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	mtspr(SPRN_PID, pid);
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
+	isync();
+}
+
 /*
  * Load up hypervisor-mode registers on P9.
  */
 static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 				     unsigned long lpcr)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	s64 hdec;
 	u64 tb, purr, spurr;
@@ -3467,12 +3493,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * P8 and P9 suppress the HDEC exception when LPCR[HDICE] = 0,
 	 * so set HDICE before writing HDEC.
 	 */
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr | LPCR_HDICE);
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr | LPCR_HDICE);
 	isync();
 
 	hdec = time_limit - mftb();
 	if (hdec < 0) {
-		mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+		mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
 		isync();
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	}
@@ -3503,7 +3529,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 	mtspr(SPRN_IC, vcpu->arch.ic);
-	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -3517,8 +3542,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	mtspr(SPRN_AMOR, ~0UL);
 
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
 	kvmppc_xive_push_vcpu(vcpu);
 
@@ -3553,7 +3577,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_CIABR, host_ciabr);
 	mtspr(SPRN_DAWR0, host_dawr);
 	mtspr(SPRN_DAWRX0, host_dawrx);
-	mtspr(SPRN_PID, host_pidr);
 
 	/*
 	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
@@ -3568,9 +3591,6 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
 		asm volatile(PPC_CP_ABORT);
 
-	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
-	isync();
-
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 	mtspr(SPRN_DPDES, 0);
@@ -3587,7 +3607,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 
 	mtspr(SPRN_HDEC, 0x7fffffff);
-	mtspr(SPRN_LPCR, vcpu->kvm->arch.host_lpcr);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
 
 	return trap;
 }
@@ -4117,7 +4138,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 {
 	struct kvm_run *run = vcpu->run;
 	int trap, r, pcpu;
-	int srcu_idx, lpid;
+	int srcu_idx;
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -4191,13 +4212,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->vcore_state = VCORE_RUNNING;
 	trace_kvmppc_run_core(vc, 0);
 
-	if (cpu_has_feature(CPU_FTR_HVMODE)) {
-		lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
-		mtspr(SPRN_LPID, lpid);
-		isync();
-		kvmppc_check_need_tlb_flush(kvm, pcpu, nested);
-	}
-
 	guest_enter_irqoff();
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
-- 
2.23.0

