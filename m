Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA9B3B0204
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhFVLBD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFVLBC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF11C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 13-20020a17090a08cdb029016eed209ca4so2031890pjn.1
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ISyZAXR8L38/HdOpUF0aqMyW0hEe9VFVuyGMi9EoOYo=;
        b=KSgxbwex9fnYoQse7MkJE8l7P0z2JYAibQpxl9RkbjRK317D99lexxRkECFGTvcf2v
         RUt/YmxE5L3FddXn/W3fWpbR1bQ1ulQGwRYs5ZisFW9SgwX0JaJVM8gUim3ZwUe7zsUv
         8P3oB7vwYbtQSL/sjGOcFl+D6zBr1KDf6q9uMyfkMr/kuiUp7GtbAnM29IoDIfGd7/LE
         sbdl19ZjoafVq6yHbQxxB9Yljit+9dxUXZ6rUzSk0ijhyh658PYxgdbBS+0/VXqwWx65
         tiKqiGqkgMtGi2EDdE1GkwV3ruZ3AM80NjBOXhi15JE5N7OsHLKLeslgkJDQ+eKzElfp
         TSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ISyZAXR8L38/HdOpUF0aqMyW0hEe9VFVuyGMi9EoOYo=;
        b=HP0O8JrQZTvkUg4cJ6/5BxaqeV+XM5J8nqj87jSrlI07q54jvUxl5uFEAi3u9Jn7JG
         MwZXkuHENDOEtzPmbtg+gsHArZRdG+K/NflEnOHVAODpTjI8oj7JkCoBfJ4jNAv8H7mN
         ZtHtgxtD4QZqL7Daw2VQUk/p7QDaxFfDvaBkpFWMjb5BMnD2tuvPP7MqsD6JzNFkWTy9
         0J2WgOMm0bn9lz182iGzJ1pSmHQHaVPPp3iWYvv1OOwVMxXOri59SOiA6v3JXQ+3N+I2
         dPX7T5UHznzGiaKZksOq0EHzEE9KYSoD2eapVJJuxMnUUM2l5NNC990Y1eZNm1LGL+Ub
         gybg==
X-Gm-Message-State: AOAM5335W7iAfiXV0RIBMfSi9VDYQkwOYYENlfjMTsS0SbmFaD7GxDCm
        e/LNd+Rw6eE7Rr95I7F+G36NWnFhfPU=
X-Google-Smtp-Source: ABdhPJzT8wkVe1E4f8mTqeYBWKSSlla0hOICZeI1FWYufbahyCs6craLmNjUfnmkcopeG0FqLX/BdA==
X-Received: by 2002:a17:90a:3802:: with SMTP id w2mr3229164pjb.218.1624359524437;
        Tue, 22 Jun 2021 03:58:44 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 20/43] KVM: PPC: Book3S HV: Change dec_expires to be relative to guest timebase
Date:   Tue, 22 Jun 2021 20:57:13 +1000
Message-Id: <20210622105736.633352-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Change dec_expires to be relative to the guest timebase, and allow
it to be moved into low level P9 guest entry functions, to improve
SPR access scheduling.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h   |  6 +++
 arch/powerpc/include/asm/kvm_host.h     |  2 +-
 arch/powerpc/kvm/book3s_hv.c            | 58 +++++++++++++------------
 arch/powerpc/kvm/book3s_hv_nested.c     |  3 ++
 arch/powerpc/kvm/book3s_hv_p9_entry.c   | 10 ++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 14 ------
 6 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index e6b53c6e21e3..032c597db0a9 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -403,6 +403,12 @@ static inline ulong kvmppc_get_fault_dar(struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault_dar;
 }
 
+/* Expiry time of vcpu DEC relative to host TB */
+static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.dec_expires - vcpu->arch.vcore->tb_offset;
+}
+
 static inline bool is_kvmppc_resume_guest(int r)
 {
 	return (r == RESUME_GUEST || r == RESUME_GUEST_NV);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 5c003a5ff854..118b388ea887 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -747,7 +747,7 @@ struct kvm_vcpu_arch {
 
 	struct hrtimer dec_timer;
 	u64 dec_jiffies;
-	u64 dec_expires;
+	u64 dec_expires;	/* Relative to guest timebase. */
 	unsigned long pending_exceptions;
 	u8 ceded;
 	u8 prodded;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 86c85e303a6d..218dacd78e25 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2149,8 +2149,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.vcore->arch_compat);
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		*val = get_reg_val(id, vcpu->arch.dec_expires +
-				   vcpu->arch.vcore->tb_offset);
+		*val = get_reg_val(id, vcpu->arch.dec_expires);
 		break;
 	case KVM_REG_PPC_ONLINE:
 		*val = get_reg_val(id, vcpu->arch.online);
@@ -2402,8 +2401,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		r = kvmppc_set_arch_compat(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		vcpu->arch.dec_expires = set_reg_val(id, *val) -
-			vcpu->arch.vcore->tb_offset;
+		vcpu->arch.dec_expires = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_ONLINE:
 		i = set_reg_val(id, *val);
@@ -2780,13 +2778,13 @@ static void kvmppc_set_timer(struct kvm_vcpu *vcpu)
 	unsigned long dec_nsec, now;
 
 	now = get_tb();
-	if (now > vcpu->arch.dec_expires) {
+	if (now > kvmppc_dec_expires_host_tb(vcpu)) {
 		/* decrementer has already gone negative */
 		kvmppc_core_queue_dec(vcpu);
 		kvmppc_core_prepare_to_enter(vcpu);
 		return;
 	}
-	dec_nsec = tb_to_ns(vcpu->arch.dec_expires - now);
+	dec_nsec = tb_to_ns(kvmppc_dec_expires_host_tb(vcpu) - now);
 	hrtimer_start(&vcpu->arch.dec_timer, dec_nsec, HRTIMER_MODE_REL);
 	vcpu->arch.timer_running = 1;
 }
@@ -3258,7 +3256,7 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 		 */
 		spin_unlock(&vc->lock);
 		/* cancel pending dec exception if dec is positive */
-		if (now < vcpu->arch.dec_expires &&
+		if (now < kvmppc_dec_expires_host_tb(vcpu) &&
 		    kvmppc_core_pending_dec(vcpu))
 			kvmppc_core_dequeue_dec(vcpu);
 
@@ -4068,20 +4066,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	load_spr_state(vcpu);
 
-	/*
-	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
-	 * setting DEC. The problem occurs right as we switch into guest mode
-	 * if a NMI hits and sets pending work and sets DEC, then that will
-	 * apply to the guest and not bring us back to the host.
-	 *
-	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
-	 * example) and set HDEC to 1? That wouldn't solve the nested hv
-	 * case which needs to abort the hcall or zero the time limit.
-	 *
-	 * XXX: Another day's problem.
-	 */
-	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
-
 	if (kvmhv_on_pseries()) {
 		/*
 		 * We need to save and restore the guest visible part of the
@@ -4107,6 +4091,23 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			hvregs.vcpu_token = vcpu->vcpu_id;
 		}
 		hvregs.hdec_expiry = time_limit;
+
+		/*
+		 * When setting DEC, we must always deal with irq_work_raise
+		 * via NMI vs setting DEC. The problem occurs right as we
+		 * switch into guest mode if a NMI hits and sets pending work
+		 * and sets DEC, then that will apply to the guest and not
+		 * bring us back to the host.
+		 *
+		 * irq_work_raise could check a flag (or possibly LPCR[HDICE]
+		 * for example) and set HDEC to 1? That wouldn't solve the
+		 * nested hv case which needs to abort the hcall or zero the
+		 * time limit.
+		 *
+		 * XXX: Another day's problem.
+		 */
+		mtspr(SPRN_DEC, kvmppc_dec_expires_host_tb(vcpu) - tb);
+
 		mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 		mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 		trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
@@ -4118,6 +4119,12 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		vcpu->arch.psscr = mfspr(SPRN_PSSCR_PR);
 		mtspr(SPRN_PSSCR_PR, host_psscr);
 
+		dec = mfspr(SPRN_DEC);
+		if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+			dec = (s32) dec;
+		tb = mftb();
+		vcpu->arch.dec_expires = dec + (tb + vc->tb_offset);
+
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
@@ -4125,6 +4132,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			kvmppc_set_gpr(vcpu, 3, 0);
 			trap = 0;
 		}
+
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr);
@@ -4156,12 +4164,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			vcpu->arch.slb_max = 0;
 	}
 
-	dec = mfspr(SPRN_DEC);
-	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
-		dec = (s32) dec;
-	tb = mftb();
-	vcpu->arch.dec_expires = dec + tb;
-
 	store_spr_state(vcpu);
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
@@ -4646,7 +4648,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * by L2 and the L1 decrementer is provided in hdec_expires
 	 */
 	if (kvmppc_core_pending_dec(vcpu) &&
-			((get_tb() < vcpu->arch.dec_expires) ||
+			((get_tb() < kvmppc_dec_expires_host_tb(vcpu)) ||
 			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
 			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
 		kvmppc_core_dequeue_dec(vcpu);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 6add13a22f56..024b0ce5b702 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -343,6 +343,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* convert TB values/offsets to host (L0) values */
 	hdec_exp = l2_hv.hdec_expiry - vc->tb_offset;
 	vc->tb_offset += l2_hv.tb_offset;
+	vcpu->arch.dec_expires += l2_hv.tb_offset;
 
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
@@ -384,6 +385,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	if (l2_regs.msr & MSR_TS_MASK)
 		vcpu->arch.shregs.msr |= MSR_TS_S;
 	vc->tb_offset = saved_l1_hv.tb_offset;
+	/* XXX: is this always the same delta as saved_l1_hv.tb_offset? */
+	vcpu->arch.dec_expires -= l2_hv.tb_offset;
 	restore_hv_regs(vcpu, &saved_l1_hv);
 	vcpu->arch.purr += delta_purr;
 	vcpu->arch.spurr += delta_spurr;
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 065bfd4d2c63..469dd5cbb52d 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -188,7 +188,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	s64 hdec;
+	s64 hdec, dec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
 	bool ri_set;
@@ -317,6 +317,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
+	mtspr(SPRN_DEC, vcpu->arch.dec_expires - tb);
+
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
@@ -446,6 +448,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.shregs.sprg2 = mfspr(SPRN_SPRG2);
 	vcpu->arch.shregs.sprg3 = mfspr(SPRN_SPRG3);
 
+	dec = mfspr(SPRN_DEC);
+	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
+		dec = (s32) dec;
+	tb = mftb();
+	vcpu->arch.dec_expires = dec + tb;
+
 	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
 	mtspr(SPRN_PSSCR, host_psscr |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 488a1e07958c..1c51dd704dd4 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -808,10 +808,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	 * Set the decrementer to the guest decrementer.
 	 */
 	ld	r8,VCPU_DEC_EXPIRES(r4)
-	/* r8 is a host timebase value here, convert to guest TB */
-	ld	r5,HSTATE_KVM_VCORE(r13)
-	ld	r6,VCORE_TB_OFFSET_APPL(r5)
-	add	r8,r8,r6
 	mftb	r7
 	subf	r3,r7,r8
 	mtspr	SPRN_DEC,r3
@@ -1192,9 +1188,6 @@ guest_bypass:
 	mftb	r6
 	extsw	r5,r5
 16:	add	r5,r5,r6
-	/* r5 is a guest timebase value here, convert to host TB */
-	ld	r4,VCORE_TB_OFFSET_APPL(r3)
-	subf	r5,r4,r5
 	std	r5,VCPU_DEC_EXPIRES(r9)
 
 	/* Increment exit count, poke other threads to exit */
@@ -2195,10 +2188,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 67:
 	/* save expiry time of guest decrementer */
 	add	r3, r3, r5
-	ld	r4, HSTATE_KVM_VCPU(r13)
-	ld	r5, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_TB_OFFSET_APPL(r5)
-	subf	r3, r6, r3	/* convert to host TB value */
 	std	r3, VCPU_DEC_EXPIRES(r4)
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
@@ -2295,9 +2284,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 
 	/* Restore guest decrementer */
 	ld	r3, VCPU_DEC_EXPIRES(r4)
-	ld	r5, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_TB_OFFSET_APPL(r5)
-	add	r3, r3, r6	/* convert host TB to guest TB value */
 	mftb	r7
 	subf	r3, r7, r3
 	mtspr	SPRN_DEC, r3
-- 
2.23.0

