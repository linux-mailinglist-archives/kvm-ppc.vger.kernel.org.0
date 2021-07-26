Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88D13D51BD
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhGZDLT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhGZDLS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:18 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7751C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so17809466pja.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=thTL8AGCjyxwkLctqzhVOZ7LNT4QrcA8E1+CvVxt834=;
        b=cX3KIRrcghco6dIa5CID12wYVIw5EQOJNc8OCdeE1sS6bP5IHQQK3WekLofI5dQJqs
         wbT77Reh5NGozEMcUs2Y7vvxUYSbZjO8h0iknsiVUSyx8HEOy6d+KeTJjt9q1x53lnvZ
         Vs7sdzCBKQOwxw2y0FJ2k4dw5o3laDsbHDwMbXaCgmi0zjjuXmN3BJpxWGN9zqxWAPZY
         TKKhU6b0cxKusIVaoYqoIT5GDjTnlWcoCE6NOZuEPmrEMqY88HOHI/ses76wEsp1KDgo
         emOiEcyNgaquwH+S3xlET2gvCur4h/kjYNgc1trz5xhACNpDI3dDWBsl5OGC4XQEmIND
         IJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thTL8AGCjyxwkLctqzhVOZ7LNT4QrcA8E1+CvVxt834=;
        b=McCZC2uN5pH8O4GnIiE8mn7o0fQhg19M6JEQAQxIsM9SR+GYArdOM+IwcIFrJfLHQP
         rWgb4HeYLP53idHiBx011ra8OQqe/iz7XOXysNQBH58xKExfK4IrOu8radlbeadTzIbS
         IKtFmGrI3xjKYjiwPdgzPo7CLcdN2NAQgPsubkiAIs47iZ9xCvBBieQAv3BJKI2qUA4r
         PeX11NrOOpVB+3RHD9urP0CWkyQsMqnQaB8nqC+VFkQE+Sd/3McNBpk8+4LoAya4q6eW
         RXK/pOHEMZv+Ik8JSPQgmVRbDlAq5QZVZZoltlZEheZpgy6AQoxNE8g1xY4kPCD3xNlx
         KsCA==
X-Gm-Message-State: AOAM531s3Vuw5OOD8m0jiTOaG7bHPuLwBUjKbfMLZDYwLLg9Xty502Tp
        gtGV0chZjAD1XCrL4oFht4z1lIm5dVs=
X-Google-Smtp-Source: ABdhPJzDFBOez+aII4t9yaTo+Vu40KYUPyU5+27/yhLju+ponGQo2AJuaG9W3o7DShr7R8xOzCJPmw==
X-Received: by 2002:a17:90a:f690:: with SMTP id cl16mr11567309pjb.164.1627271506392;
        Sun, 25 Jul 2021 20:51:46 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 26/55] KVM: PPC: Book3S HV: Change dec_expires to be relative to guest timebase
Date:   Mon, 26 Jul 2021 13:50:07 +1000
Message-Id: <20210726035036.739609-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index caaa0f592d8e..15b573671f99 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -406,6 +406,12 @@ static inline ulong kvmppc_get_fault_dar(struct kvm_vcpu *vcpu)
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
index aee41edcfe6b..f105eaeb4521 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -742,7 +742,7 @@ struct kvm_vcpu_arch {
 
 	struct hrtimer dec_timer;
 	u64 dec_jiffies;
-	u64 dec_expires;
+	u64 dec_expires;	/* Relative to guest timebase. */
 	unsigned long pending_exceptions;
 	u8 ceded;
 	u8 prodded;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4d757e4904c4..027ae0b60e70 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2237,8 +2237,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.vcore->arch_compat);
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		*val = get_reg_val(id, vcpu->arch.dec_expires +
-				   vcpu->arch.vcore->tb_offset);
+		*val = get_reg_val(id, vcpu->arch.dec_expires);
 		break;
 	case KVM_REG_PPC_ONLINE:
 		*val = get_reg_val(id, vcpu->arch.online);
@@ -2490,8 +2489,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		r = kvmppc_set_arch_compat(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		vcpu->arch.dec_expires = set_reg_val(id, *val) -
-			vcpu->arch.vcore->tb_offset;
+		vcpu->arch.dec_expires = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_ONLINE:
 		i = set_reg_val(id, *val);
@@ -2877,13 +2875,13 @@ static void kvmppc_set_timer(struct kvm_vcpu *vcpu)
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
@@ -3355,7 +3353,7 @@ static void post_guest_process(struct kvmppc_vcore *vc, bool is_master)
 		 */
 		spin_unlock(&vc->lock);
 		/* cancel pending dec exception if dec is positive */
-		if (now < vcpu->arch.dec_expires &&
+		if (now < kvmppc_dec_expires_host_tb(vcpu) &&
 		    kvmppc_core_pending_dec(vcpu))
 			kvmppc_core_dequeue_dec(vcpu);
 
@@ -4174,20 +4172,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
@@ -4213,6 +4197,23 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4224,6 +4225,12 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4231,6 +4238,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			kvmppc_set_gpr(vcpu, 3, 0);
 			trap = 0;
 		}
+
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr);
@@ -4262,12 +4270,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4752,7 +4754,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * by L2 and the L1 decrementer is provided in hdec_expires
 	 */
 	if (kvmppc_core_pending_dec(vcpu) &&
-			((get_tb() < vcpu->arch.dec_expires) ||
+			((get_tb() < kvmppc_dec_expires_host_tb(vcpu)) ||
 			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
 			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
 		kvmppc_core_dequeue_dec(vcpu);
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 3ffc63ffebc5..fad7bc8736ea 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -380,6 +380,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* convert TB values/offsets to host (L0) values */
 	hdec_exp = l2_hv.hdec_expiry - vc->tb_offset;
 	vc->tb_offset += l2_hv.tb_offset;
+	vcpu->arch.dec_expires += l2_hv.tb_offset;
 
 	/* set L1 state to L2 state */
 	vcpu->arch.nested = l2;
@@ -421,6 +422,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	if (l2_regs.msr & MSR_TS_MASK)
 		vcpu->arch.shregs.msr |= MSR_TS_S;
 	vc->tb_offset = saved_l1_hv.tb_offset;
+	/* XXX: is this always the same delta as saved_l1_hv.tb_offset? */
+	vcpu->arch.dec_expires -= l2_hv.tb_offset;
 	restore_hv_regs(vcpu, &saved_l1_hv);
 	vcpu->arch.purr += delta_purr;
 	vcpu->arch.spurr += delta_spurr;
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index fb9cb34445ea..814b0dfd590f 100644
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
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 tm_return_to_guest:
 #endif
@@ -461,6 +463,12 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
index 05be8648937d..16cb3240df52 100644
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
@@ -1186,9 +1182,6 @@ guest_bypass:
 	mftb	r6
 	extsw	r5,r5
 16:	add	r5,r5,r6
-	/* r5 is a guest timebase value here, convert to host TB */
-	ld	r4,VCORE_TB_OFFSET_APPL(r3)
-	subf	r5,r4,r5
 	std	r5,VCPU_DEC_EXPIRES(r9)
 
 	/* Increment exit count, poke other threads to exit */
@@ -2153,10 +2146,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 67:
 	/* save expiry time of guest decrementer */
 	add	r3, r3, r5
-	ld	r4, HSTATE_KVM_VCPU(r13)
-	ld	r5, HSTATE_KVM_VCORE(r13)
-	ld	r6, VCORE_TB_OFFSET_APPL(r5)
-	subf	r3, r6, r3	/* convert to host TB value */
 	std	r3, VCPU_DEC_EXPIRES(r4)
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
@@ -2253,9 +2242,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 
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

