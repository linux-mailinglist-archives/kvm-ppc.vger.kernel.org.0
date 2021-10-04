Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E333642137C
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhJDQEZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJDQEX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:23 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB2C061746
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 133so17002783pgb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkexsEOAVWXa6SP1z3QouXaKbTqKQYxhAWf7gffMh3A=;
        b=aa+V/DKUu5ZG43rwzwPT5Up2WHq7gydSdPPXN+iPlScH8Sd57ZrlSzllLHIWLna83w
         Pj7KSV9yAIeWnKUYUukT4L8GxCcaVBMGwRArP+Aa48odGEaWFe+zpKw62cuCyAkSXSD6
         vmmVWp6jBSRfZHPU7Qq2r18QxmRCvRM7sOk51DI1dK1fU0US+FWbFqXDRIGbZudBdD7/
         BoqQeggUCJn+v0CQmQAuG+3MoyK3tZEAIFlkWKqFYGscYrK4hKQ+XwPhJePm/FgUTwLM
         OgLgbymP6vTq7cAJ4adBv0988BljJ7IUPf3oUQBZvbzRW3XPVwuY37cEavzJBewiHx0V
         IyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkexsEOAVWXa6SP1z3QouXaKbTqKQYxhAWf7gffMh3A=;
        b=qfltlbffzKQS3m5VrhL0U0xJqxnNlpYlaY5IK+kgBmhE/zKv76fq25GSHBup7hxhdH
         YuXfUVPome5NWSePrFt9Fs813pZVe3lKq9BcCNHHiKSDVS8Fg1hipm+nLwVoHxguFN9i
         Yoc/WUrIXyoJiRQyBgRvpSkeU0ljx0RV/ogo514ndUysiiCDhRAvm1vONI3i7HDoaq/g
         R4Jz8NqpVu3zX9h0U1cTj74aQC7x+DWmITv7zUiVYV5P3SI0BoBvKTjgG9tMrG9uYAV3
         WeWOnwj+5344w6y0unyJqqhzx+PBV9kDbY+mcGrJwdOgaNcRAv6yrw3g7qv5VKf0VEgK
         2zpg==
X-Gm-Message-State: AOAM530yAi/vGYjlGQNBGBS+Yhf0i0NUI/5ck/B8aWYeVkuUncR8R9mA
        iHIOCBSR6K8fzM5LALO+Gf7adrl+6Lc=
X-Google-Smtp-Source: ABdhPJyVts0WOd2f1YH/HiuCLKbXMqHRXf4oG8muSDOuCcQN+BgnIEGqP9eV64UKcV57jAOPFDbjhQ==
X-Received: by 2002:a62:8f8a:0:b0:44c:6e3c:4807 with SMTP id n132-20020a628f8a000000b0044c6e3c4807mr2778896pfd.68.1633363353507;
        Mon, 04 Oct 2021 09:02:33 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:33 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 38/52] KVM: PPC: Book3S HV P9: Use Linux SPR save/restore to manage some host SPRs
Date:   Tue,  5 Oct 2021 02:00:35 +1000
Message-Id: <20211004160049.1338837-39-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Linux implements SPR save/restore including storage space for registers
in the task struct for process context switching. Make use of this
similarly to the way we make use of the context switching fp/vec save
restore.

This improves code reuse, allows some stack space to be saved, and helps
with avoiding VRSAVE updates if they are not required.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/switch_to.h  |  1 +
 arch/powerpc/kernel/process.c         |  6 ++
 arch/powerpc/kvm/book3s_hv.c          | 21 +-----
 arch/powerpc/kvm/book3s_hv.h          |  3 -
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 93 +++++++++++++++++++--------
 5 files changed, 73 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index e8013cd6b646..1f43ef696033 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -113,6 +113,7 @@ static inline void clear_task_ebb(struct task_struct *t)
 }
 
 void kvmppc_save_user_regs(void);
+void kvmppc_save_current_sprs(void);
 
 extern int set_thread_tidr(struct task_struct *t);
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 3fca321b820d..b2d191a8fbf9 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1182,6 +1182,12 @@ void kvmppc_save_user_regs(void)
 #endif
 }
 EXPORT_SYMBOL_GPL(kvmppc_save_user_regs);
+
+void kvmppc_save_current_sprs(void)
+{
+	save_sprs(&current->thread);
+}
+EXPORT_SYMBOL_GPL(kvmppc_save_current_sprs);
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 
 static inline void restore_sprs(struct thread_struct *old_thread,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e9037f7a3737..f4445cc5a29a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4540,9 +4540,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	int r;
 	int srcu_idx;
-	unsigned long ebb_regs[3] = {};	/* shut up GCC */
-	unsigned long user_tar = 0;
-	unsigned int user_vrsave;
 	struct kvm *kvm;
 	unsigned long msr;
 
@@ -4603,14 +4600,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	kvmppc_save_user_regs();
 
-	/* Save userspace EBB and other register values */
-	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
-		ebb_regs[0] = mfspr(SPRN_EBBHR);
-		ebb_regs[1] = mfspr(SPRN_EBBRR);
-		ebb_regs[2] = mfspr(SPRN_BESCR);
-		user_tar = mfspr(SPRN_TAR);
-	}
-	user_vrsave = mfspr(SPRN_VRSAVE);
+	kvmppc_save_current_sprs();
 
 	vcpu->arch.waitp = &vcpu->arch.vcore->wait;
 	vcpu->arch.pgdir = kvm->mm->pgd;
@@ -4651,15 +4641,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		}
 	} while (is_kvmppc_resume_guest(r));
 
-	/* Restore userspace EBB and other register values */
-	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
-		mtspr(SPRN_EBBHR, ebb_regs[0]);
-		mtspr(SPRN_EBBRR, ebb_regs[1]);
-		mtspr(SPRN_BESCR, ebb_regs[2]);
-		mtspr(SPRN_TAR, user_tar);
-	}
-	mtspr(SPRN_VRSAVE, user_vrsave);
-
 	vcpu->arch.state = KVMPPC_VCPU_NOTREADY;
 	atomic_dec(&kvm->arch.vcpus_running);
 
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index d7485b9e9762..6b7f07d9026b 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -4,11 +4,8 @@
  * Privileged (non-hypervisor) host registers to save.
  */
 struct p9_host_os_sprs {
-	unsigned long dscr;
-	unsigned long tidr;
 	unsigned long iamr;
 	unsigned long amr;
-	unsigned long fscr;
 
 	unsigned int pmc1;
 	unsigned int pmc2;
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 8499e8a9ca8f..093ac0453d91 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -231,15 +231,26 @@ EXPORT_SYMBOL_GPL(switch_pmu_to_host);
 static void load_spr_state(struct kvm_vcpu *vcpu,
 				struct p9_host_os_sprs *host_os_sprs)
 {
+	/* TAR is very fast */
 	mtspr(SPRN_TAR, vcpu->arch.tar);
 
+#ifdef CONFIG_ALTIVEC
+	if (cpu_has_feature(CPU_FTR_ALTIVEC) &&
+	    current->thread.vrsave != vcpu->arch.vrsave)
+		mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+#endif
+
 	if (vcpu->arch.hfscr & HFSCR_EBB) {
-		mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
-		mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
-		mtspr(SPRN_BESCR, vcpu->arch.bescr);
+		if (current->thread.ebbhr != vcpu->arch.ebbhr)
+			mtspr(SPRN_EBBHR, vcpu->arch.ebbhr);
+		if (current->thread.ebbrr != vcpu->arch.ebbrr)
+			mtspr(SPRN_EBBRR, vcpu->arch.ebbrr);
+		if (current->thread.bescr != vcpu->arch.bescr)
+			mtspr(SPRN_BESCR, vcpu->arch.bescr);
 	}
 
-	if (cpu_has_feature(CPU_FTR_P9_TIDR))
+	if (cpu_has_feature(CPU_FTR_P9_TIDR) &&
+			current->thread.tidr != vcpu->arch.tid)
 		mtspr(SPRN_TIDR, vcpu->arch.tid);
 	if (host_os_sprs->iamr != vcpu->arch.iamr)
 		mtspr(SPRN_IAMR, vcpu->arch.iamr);
@@ -247,9 +258,9 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
 		mtspr(SPRN_AMR, vcpu->arch.amr);
 	if (vcpu->arch.uamor != 0)
 		mtspr(SPRN_UAMOR, vcpu->arch.uamor);
-	if (host_os_sprs->fscr != vcpu->arch.fscr)
+	if (current->thread.fscr != vcpu->arch.fscr)
 		mtspr(SPRN_FSCR, vcpu->arch.fscr);
-	if (host_os_sprs->dscr != vcpu->arch.dscr)
+	if (current->thread.dscr != vcpu->arch.dscr)
 		mtspr(SPRN_DSCR, vcpu->arch.dscr);
 	if (vcpu->arch.pspb != 0)
 		mtspr(SPRN_PSPB, vcpu->arch.pspb);
@@ -269,20 +280,15 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.tar = mfspr(SPRN_TAR);
 
+#ifdef CONFIG_ALTIVEC
+	if (cpu_has_feature(CPU_FTR_ALTIVEC))
+		vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
+#endif
+
 	if (vcpu->arch.hfscr & HFSCR_EBB) {
 		vcpu->arch.ebbhr = mfspr(SPRN_EBBHR);
 		vcpu->arch.ebbrr = mfspr(SPRN_EBBRR);
 		vcpu->arch.bescr = mfspr(SPRN_BESCR);
-		/*
-		 * This is like load_fp in context switching, turn off the
-		 * facility after it wraps the u8 to try avoiding saving
-		 * and restoring the registers each partition switch.
-		 */
-		if (!vcpu->arch.nested) {
-			vcpu->arch.load_ebb++;
-			if (!vcpu->arch.load_ebb)
-				vcpu->arch.hfscr &= ~HFSCR_EBB;
-		}
 	}
 
 	if (cpu_has_feature(CPU_FTR_P9_TIDR))
@@ -324,7 +330,6 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 #ifdef CONFIG_ALTIVEC
 	load_vr_state(&vcpu->arch.vr);
 #endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
 	return ret;
 }
@@ -338,7 +343,6 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
 #endif
-	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (cpu_has_feature(CPU_FTR_TM) ||
@@ -364,12 +368,8 @@ EXPORT_SYMBOL_GPL(store_vcpu_state);
 
 void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 {
-	if (cpu_has_feature(CPU_FTR_P9_TIDR))
-		host_os_sprs->tidr = mfspr(SPRN_TIDR);
 	host_os_sprs->iamr = mfspr(SPRN_IAMR);
 	host_os_sprs->amr = mfspr(SPRN_AMR);
-	host_os_sprs->fscr = mfspr(SPRN_FSCR);
-	host_os_sprs->dscr = mfspr(SPRN_DSCR);
 }
 EXPORT_SYMBOL_GPL(save_p9_host_os_sprs);
 
@@ -377,26 +377,63 @@ EXPORT_SYMBOL_GPL(save_p9_host_os_sprs);
 void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 			     struct p9_host_os_sprs *host_os_sprs)
 {
+	/*
+	 * current->thread.xxx registers must all be restored to host
+	 * values before a potential context switch, othrewise the context
+	 * switch itself will overwrite current->thread.xxx with the values
+	 * from the guest SPRs.
+	 */
+
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
-	if (cpu_has_feature(CPU_FTR_P9_TIDR))
-		mtspr(SPRN_TIDR, host_os_sprs->tidr);
+	if (cpu_has_feature(CPU_FTR_P9_TIDR) &&
+			current->thread.tidr != vcpu->arch.tid)
+		mtspr(SPRN_TIDR, current->thread.tidr);
 	if (host_os_sprs->iamr != vcpu->arch.iamr)
 		mtspr(SPRN_IAMR, host_os_sprs->iamr);
 	if (vcpu->arch.uamor != 0)
 		mtspr(SPRN_UAMOR, 0);
 	if (host_os_sprs->amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_os_sprs->amr);
-	if (host_os_sprs->fscr != vcpu->arch.fscr)
-		mtspr(SPRN_FSCR, host_os_sprs->fscr);
-	if (host_os_sprs->dscr != vcpu->arch.dscr)
-		mtspr(SPRN_DSCR, host_os_sprs->dscr);
+	if (current->thread.fscr != vcpu->arch.fscr)
+		mtspr(SPRN_FSCR, current->thread.fscr);
+	if (current->thread.dscr != vcpu->arch.dscr)
+		mtspr(SPRN_DSCR, current->thread.dscr);
 	if (vcpu->arch.pspb != 0)
 		mtspr(SPRN_PSPB, 0);
 
 	/* Save guest CTRL register, set runlatch to 1 */
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, 1);
+
+#ifdef CONFIG_ALTIVEC
+	if (cpu_has_feature(CPU_FTR_ALTIVEC) &&
+	    vcpu->arch.vrsave != current->thread.vrsave)
+		mtspr(SPRN_VRSAVE, current->thread.vrsave);
+#endif
+	if (vcpu->arch.hfscr & HFSCR_EBB) {
+		if (vcpu->arch.bescr != current->thread.bescr)
+			mtspr(SPRN_BESCR, current->thread.bescr);
+		if (vcpu->arch.ebbhr != current->thread.ebbhr)
+			mtspr(SPRN_EBBHR, current->thread.ebbhr);
+		if (vcpu->arch.ebbrr != current->thread.ebbrr)
+			mtspr(SPRN_EBBRR, current->thread.ebbrr);
+
+		if (!vcpu->arch.nested) {
+			/*
+			 * This is like load_fp in context switching, turn off
+			 * the facility after it wraps the u8 to try avoiding
+			 * saving and restoring the registers each partition
+			 * switch.
+			 */
+			vcpu->arch.load_ebb++;
+			if (!vcpu->arch.load_ebb)
+				vcpu->arch.hfscr &= ~HFSCR_EBB;
+		}
+	}
+
+	if (vcpu->arch.tar != current->thread.tar)
+		mtspr(SPRN_TAR, current->thread.tar);
 }
 EXPORT_SYMBOL_GPL(restore_p9_host_os_sprs);
 
-- 
2.23.0

