Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C751C393F78
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhE1JKj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhE1JKO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:14 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7EAC061349
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q25so2778472pfn.1
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbUHtkstldNhzTuJQSTPfLuVu1OmNZeSeC6mYnONH9A=;
        b=VxqfuL11DumsojX/L3TaNXOzx9qcq9Fe7vkn7DfRfvUh42UpRc5ecrrtfYDfXfRJM/
         VpXLZoGZDLRp2q5ZV282CDD5LSZKEBZJUYww0ShKhmOheiBUJeccXz+vHZlFqdB8468w
         2w/MZlsOkStZ/ZXNefny31yo7rkASesDP4jCxzT+w0tEQB0CcXlPkAzSzKv71zUC/GrO
         vYdz8ADdTQVHl/XmWiDWBjoJeFsKWwGRalnY7b0BE5pY/Mcvz98s9f0f9R4u3PnPkQP9
         m2PN1yNpOSX7XLae77h6X/7kIttC9lHpF7HNkY04GmqugN/U/FG+WDDUyzvDcA7PXEks
         iC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbUHtkstldNhzTuJQSTPfLuVu1OmNZeSeC6mYnONH9A=;
        b=peBeM2t557qS7z+gyAhlk7KNz5s5dPHiNsQE+CS+BusYqdcGP5qgFytF5GNPju+lX4
         Z8f03NEX633ks5ma/1f4XSCH2z3AUxzshtdzstKvVdgfjUkeIlwyd57uwVdDn4OiaZUx
         79USVaS7boOIPkvfMz62Z25Uc3BmLwQv2BDBq7N6D1aqmTz7ur3iQxquKZ+MncJOH7sK
         CsxUzHERAl7fUN0W2qOLYL9muQoec8w63RjEPJWQ/N+rANweqFr8NPMJE3a99t7zMxV5
         UIvWzMdGRkKYdScqWHsArJIQl5pLvzlFA3WmsnEsxVya890qYbIOmne1J7Hncx3ypK7f
         UdnA==
X-Gm-Message-State: AOAM530AGOldyZaxvzartYCgZvt24nSNTJ0a4Lzxog7MWyd1XBh9Nx9j
        DSBeBY9W+8bKkedDdOmsx3au3yNg2kg=
X-Google-Smtp-Source: ABdhPJz4vFdbFRIqeQlLeWGFYk/PQ2cNpWc7jz/wTEkzAd9SwM9D5gWeICi2s19roFejuHAGBJEeHw==
X-Received: by 2002:a63:f749:: with SMTP id f9mr7883215pgk.369.1622192918814;
        Fri, 28 May 2021 02:08:38 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v7 15/32] KVM: PPC: Book3S HV P9: inline kvmhv_load_hv_regs_and_go into __kvmhv_vcpu_entry_p9
Date:   Fri, 28 May 2021 19:07:35 +1000
Message-Id: <20210528090752.3542186-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Now the initial C implementation is done, inline more HV code to make
rearranging things easier.

And rename __kvmhv_vcpu_entry_p9 to drop the leading underscores as it's
now C, and is now a more complete vcpu entry.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |   2 +-
 arch/powerpc/kvm/book3s_hv.c             | 190 +----------------------
 arch/powerpc/kvm/book3s_hv_p9_entry.c    | 177 ++++++++++++++++++++-
 3 files changed, 178 insertions(+), 191 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index c214bcffb441..eaf3a562bf1e 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -153,7 +153,7 @@ static inline bool kvmhv_vcpu_is_radix(struct kvm_vcpu *vcpu)
 	return radix;
 }
 
-int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu);
+int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr);
 
 #define KVM_DEFAULT_HPT_ORDER	24	/* 16MB HPT by default */
 #endif
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 665279927437..777ec786ef71 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3501,192 +3501,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	trace_kvmppc_run_core(vc, 1);
 }
 
-static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	struct kvm_nested_guest *nested = vcpu->arch.nested;
-	u32 lpid;
-
-	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
-
-	/*
-	 * All the isync()s are overkill but trivially follow the ISA
-	 * requirements. Some can likely be replaced with justification
-	 * comment for why they are not needed.
-	 */
-	isync();
-	mtspr(SPRN_LPID, lpid);
-	isync();
-	mtspr(SPRN_LPCR, lpcr);
-	isync();
-	mtspr(SPRN_PID, vcpu->arch.pid);
-	isync();
-
-	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
-	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
-}
-
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
-{
-	isync();
-	mtspr(SPRN_PID, pid);
-	isync();
-	mtspr(SPRN_LPID, kvm->arch.host_lpid);
-	isync();
-	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-	isync();
-}
-
-/*
- * Load up hypervisor-mode registers on P9.
- */
-static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
-				     unsigned long lpcr)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	s64 hdec;
-	u64 tb, purr, spurr;
-	int trap;
-	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
-	unsigned long host_ciabr = mfspr(SPRN_CIABR);
-	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
-	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
-	unsigned long host_psscr = mfspr(SPRN_PSSCR);
-	unsigned long host_pidr = mfspr(SPRN_PID);
-	unsigned long host_dawr1 = 0;
-	unsigned long host_dawrx1 = 0;
-
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
-	}
-
-	hdec = time_limit - mftb();
-	if (hdec < 0)
-		return BOOK3S_INTERRUPT_HV_DECREMENTER;
-
-	if (vc->tb_offset) {
-		u64 new_tb = mftb() + vc->tb_offset;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = vc->tb_offset;
-	}
-
-	if (vc->pcr)
-		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
-	mtspr(SPRN_DPDES, vc->dpdes);
-	mtspr(SPRN_VTB, vc->vtb);
-
-	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
-	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, vcpu->arch.purr);
-	mtspr(SPRN_SPURR, vcpu->arch.spurr);
-
-	if (dawr_enabled()) {
-		mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
-		mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
-		if (cpu_has_feature(CPU_FTR_DAWR1)) {
-			mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
-			mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
-		}
-	}
-	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
-	mtspr(SPRN_IC, vcpu->arch.ic);
-
-	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
-
-	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
-
-	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
-	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
-	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
-
-	mtspr(SPRN_AMOR, ~0UL);
-
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-
-	/*
-	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
-	 * so set guest LPCR (with HDICE) before writing HDEC.
-	 */
-	mtspr(SPRN_HDEC, hdec);
-
-	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
-	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
-
-	trap = __kvmhv_vcpu_entry_p9(vcpu);
-
-	/* Advance host PURR/SPURR by the amount used by guest */
-	purr = mfspr(SPRN_PURR);
-	spurr = mfspr(SPRN_SPURR);
-	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
-	      purr - vcpu->arch.purr);
-	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
-	      spurr - vcpu->arch.spurr);
-	vcpu->arch.purr = purr;
-	vcpu->arch.spurr = spurr;
-
-	vcpu->arch.ic = mfspr(SPRN_IC);
-	vcpu->arch.pid = mfspr(SPRN_PID);
-	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
-
-	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
-	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
-	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
-	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
-
-	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
-	mtspr(SPRN_PSSCR, host_psscr |
-	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
-	mtspr(SPRN_HFSCR, host_hfscr);
-	mtspr(SPRN_CIABR, host_ciabr);
-	mtspr(SPRN_DAWR0, host_dawr0);
-	mtspr(SPRN_DAWRX0, host_dawrx0);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		mtspr(SPRN_DAWR1, host_dawr1);
-		mtspr(SPRN_DAWRX1, host_dawrx1);
-	}
-
-	/*
-	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
-	 * case we interrupted the guest between a tlbie and a ptesync.
-	 */
-	asm volatile("eieio; tlbsync; ptesync");
-
-	/*
-	 * cp_abort is required if the processor supports local copy-paste
-	 * to clear the copy buffer that was under control of the guest.
-	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		asm volatile(PPC_CP_ABORT);
-
-	vc->dpdes = mfspr(SPRN_DPDES);
-	vc->vtb = mfspr(SPRN_VTB);
-	mtspr(SPRN_DPDES, 0);
-	if (vc->pcr)
-		mtspr(SPRN_PCR, PCR_MASK);
-
-	if (vc->tb_offset_applied) {
-		u64 new_tb = mftb() - vc->tb_offset_applied;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = 0;
-	}
-
-	mtspr(SPRN_HDEC, 0x7fffffff);
-
-	switch_mmu_to_host_radix(kvm, host_pidr);
-
-	return trap;
-}
-
 static inline bool hcall_is_xics(unsigned long req)
 {
 	return req == H_EOI || req == H_CPPR || req == H_IPI ||
@@ -3784,7 +3598,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		 * We need to save and restore the guest visible part of the
 		 * psscr (i.e. using SPRN_PSSCR_PR) since the hypervisor
 		 * doesn't do this for us. Note only required if pseries since
-		 * this is done in kvmhv_load_hv_regs_and_go() below otherwise.
+		 * this is done in kvmhv_vcpu_entry_p9() below otherwise.
 		 */
 		unsigned long host_psscr;
 		/* call our hypervisor to load up HV regs and go */
@@ -3822,7 +3636,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
-		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr);
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    !(vcpu->arch.shregs.msr & MSR_PR)) {
 			unsigned long req = kvmppc_get_gpr(vcpu, 3);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 9db0e031a443..d2e659940630 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -79,11 +79,121 @@ static void radix_clear_slb(void)
 		clear_slb_entry(i);
 }
 
-int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu)
+static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
 {
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	u32 lpid;
+
+	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
+
+	/*
+	 * All the isync()s are overkill but trivially follow the ISA
+	 * requirements. Some can likely be replaced with justification
+	 * comment for why they are not needed.
+	 */
+	isync();
+	mtspr(SPRN_LPID, lpid);
+	isync();
+	mtspr(SPRN_LPCR, lpcr);
+	isync();
+	mtspr(SPRN_PID, vcpu->arch.pid);
+	isync();
+
+	/* TLBIEL must have LPIDR set, so set guest LPID before flushing. */
+	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
+}
+
+static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+{
+	isync();
+	mtspr(SPRN_PID, pid);
+	isync();
+	mtspr(SPRN_LPID, kvm->arch.host_lpid);
+	isync();
+	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
+	isync();
+}
+
+int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	s64 hdec;
+	u64 tb, purr, spurr;
 	u64 *exsave;
 	unsigned long msr = mfmsr();
 	int trap;
+	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
+	unsigned long host_ciabr = mfspr(SPRN_CIABR);
+	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
+	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
+	unsigned long host_psscr = mfspr(SPRN_PSSCR);
+	unsigned long host_pidr = mfspr(SPRN_PID);
+	unsigned long host_dawr1 = 0;
+	unsigned long host_dawrx1 = 0;
+
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		host_dawr1 = mfspr(SPRN_DAWR1);
+		host_dawrx1 = mfspr(SPRN_DAWRX1);
+	}
+
+	hdec = time_limit - mftb();
+	if (hdec < 0)
+		return BOOK3S_INTERRUPT_HV_DECREMENTER;
+
+	if (vc->tb_offset) {
+		u64 new_tb = mftb() + vc->tb_offset;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = vc->tb_offset;
+	}
+
+	if (vc->pcr)
+		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
+	mtspr(SPRN_DPDES, vc->dpdes);
+	mtspr(SPRN_VTB, vc->vtb);
+
+	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
+	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
+	mtspr(SPRN_PURR, vcpu->arch.purr);
+	mtspr(SPRN_SPURR, vcpu->arch.spurr);
+
+	if (dawr_enabled()) {
+		mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
+		mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
+			mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
+		}
+	}
+	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
+	mtspr(SPRN_IC, vcpu->arch.ic);
+
+	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
+	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+
+	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
+
+	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
+	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
+	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
+	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
+
+	mtspr(SPRN_AMOR, ~0UL);
+
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
+	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
+	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
@@ -202,6 +312,69 @@ int __kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu)
 
 	end_timing(vcpu);
 
+	/* Advance host PURR/SPURR by the amount used by guest */
+	purr = mfspr(SPRN_PURR);
+	spurr = mfspr(SPRN_SPURR);
+	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr +
+	      purr - vcpu->arch.purr);
+	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr +
+	      spurr - vcpu->arch.spurr);
+	vcpu->arch.purr = purr;
+	vcpu->arch.spurr = spurr;
+
+	vcpu->arch.ic = mfspr(SPRN_IC);
+	vcpu->arch.pid = mfspr(SPRN_PID);
+	vcpu->arch.psscr = mfspr(SPRN_PSSCR) & PSSCR_GUEST_VIS;
+
+	vcpu->arch.shregs.sprg0 = mfspr(SPRN_SPRG0);
+	vcpu->arch.shregs.sprg1 = mfspr(SPRN_SPRG1);
+	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
+	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
+
+	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
+	mtspr(SPRN_PSSCR, host_psscr |
+	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
+	mtspr(SPRN_HFSCR, host_hfscr);
+	mtspr(SPRN_CIABR, host_ciabr);
+	mtspr(SPRN_DAWR0, host_dawr0);
+	mtspr(SPRN_DAWRX0, host_dawrx0);
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		mtspr(SPRN_DAWR1, host_dawr1);
+		mtspr(SPRN_DAWRX1, host_dawrx1);
+	}
+
+	/*
+	 * Since this is radix, do a eieio; tlbsync; ptesync sequence in
+	 * case we interrupted the guest between a tlbie and a ptesync.
+	 */
+	asm volatile("eieio; tlbsync; ptesync");
+
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		asm volatile(PPC_CP_ABORT);
+
+	vc->dpdes = mfspr(SPRN_DPDES);
+	vc->vtb = mfspr(SPRN_VTB);
+	mtspr(SPRN_DPDES, 0);
+	if (vc->pcr)
+		mtspr(SPRN_PCR, PCR_MASK);
+
+	if (vc->tb_offset_applied) {
+		u64 new_tb = mftb() - vc->tb_offset_applied;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = 0;
+	}
+
+	mtspr(SPRN_HDEC, 0x7fffffff);
+
+	switch_mmu_to_host_radix(kvm, host_pidr);
+
 	return trap;
 }
-EXPORT_SYMBOL_GPL(__kvmhv_vcpu_entry_p9);
+EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

