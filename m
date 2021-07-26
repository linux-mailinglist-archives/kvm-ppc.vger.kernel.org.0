Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27C13D51D6
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhGZDLz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhGZDLy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D632EC061760
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:22 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k4-20020a17090a5144b02901731c776526so17813949pjm.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDldY7WS69pzamb+qF1B1lhBHOY60F2IGoOPkLlUvXg=;
        b=IREJ8dMTDIhYmdKNdsxmPvt6UzKlLqUqqmfAoiL7fy2d/2QntBZ0Sl5La2hnN6nR8j
         YnzMWK+LhrPBHrnTtUXZBJmXmANPAOSUK0/LQS7NPABsVZcFxSt6EJ8+pFee1b8UYcTj
         BR5INrCTL7CfXT2c8HRAS9VkWOVNCcmpzPs1ReUK6CM8MESFlDEZBEc96sILnAZiKW/r
         GaxGyDr7NZEP3q2nMLpUcmmk8kra1a7u0blE2UZsE6dxWaJuJcuXG8F+cTNKtallo0iC
         EVfADXBClZA/kN1aJMjswz+SCnhljtkf759USVN0nYzp1+LjC5p+Gm+No5jknrQMY1xK
         cWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDldY7WS69pzamb+qF1B1lhBHOY60F2IGoOPkLlUvXg=;
        b=jXy6srOgYCs8viNUziiE77JcDwNVgeYZRTlshgsVwxphMoxWokXm9AVAjsvQg4bOm6
         p2E8i7Y4lFhImnrW8nnw/nAHzuvmoWn4Q4GHo0mc25IH2QGmqTk7fs6EeFjNyxhe18XL
         PVoKJsnEakF3tfiZNFvdpSKgQVsJEGXtXUm+Z1T4GO32zQQzefk1Ni9P9Fp9zw0q+dUe
         6Z7R8keXE51/NYL1jUCk8WLxifo4Dz0iFRMB19Ucbm7Pl33O7O5hiWA9kdN0X1gVs19B
         Z85sHVrYHp4St2o6T5mqHpT2nzribp61RvPHCej/NqgpK35yxvxsW6GyFbq3CjVEVZVq
         SghA==
X-Gm-Message-State: AOAM532UJM/yZlJT4VupRe+hul4n2wSPR7RDMnWl3Y4b0rYEvjvb3CfP
        luiBi69VOfQMQWiqHnYE3MSRG18htWc=
X-Google-Smtp-Source: ABdhPJx5DsfwPbLxORQw9voCYaFAIUrVyUdr4Ll+vVm6M4idPAgw7Sn6TW4fuvue82h4nUEKXacarg==
X-Received: by 2002:a65:568c:: with SMTP id v12mr16603284pgs.88.1627271542323;
        Sun, 25 Jul 2021 20:52:22 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:22 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 42/55] KVM: PPC: Book3S HV P9: Use Linux SPR save/restore to manage some host SPRs
Date:   Mon, 26 Jul 2021 13:50:23 +1000
Message-Id: <20210726035036.739609-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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

-61 cycles (6620) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/switch_to.h  |  2 +
 arch/powerpc/kernel/process.c         |  6 ++
 arch/powerpc/kvm/book3s_hv.c          | 21 +-----
 arch/powerpc/kvm/book3s_hv.h          |  3 -
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 93 +++++++++++++++++++--------
 5 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 9d1fbd8be1c7..de17c45314bc 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -112,6 +112,8 @@ static inline void clear_task_ebb(struct task_struct *t)
 #endif
 }
 
+void kvmppc_save_current_sprs(void);
+
 extern int set_thread_tidr(struct task_struct *t);
 
 #endif /* _ASM_POWERPC_SWITCH_TO_H */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 00b55b38a460..d54baa3e20d2 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1180,6 +1180,12 @@ static inline void save_sprs(struct thread_struct *t)
 #endif
 }
 
+void kvmppc_save_current_sprs(void)
+{
+	save_sprs(&current->thread);
+}
+EXPORT_SYMBOL_GPL(kvmppc_save_current_sprs);
+
 static inline void restore_sprs(struct thread_struct *old_thread,
 				struct thread_struct *new_thread)
 {
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5b2114c00c43..c0a04ce39e00 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4510,9 +4510,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	int r;
 	int srcu_idx;
-	unsigned long ebb_regs[3] = {};	/* shut up GCC */
-	unsigned long user_tar = 0;
-	unsigned int user_vrsave;
 	struct kvm *kvm;
 	unsigned long msr;
 
@@ -4573,14 +4570,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	save_user_regs_kvm();
 
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
@@ -4621,15 +4611,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
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
index a9065a380547..04884e271862 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -3,11 +3,8 @@
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
index db5eb83e26d1..5fca0a09425d 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -223,15 +223,26 @@ EXPORT_SYMBOL_GPL(switch_pmu_to_host);
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
 
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+	if (!cpu_has_feature(CPU_FTR_ARCH_31) &&
+			current->thread.tidr != vcpu->arch.tid)
 		mtspr(SPRN_TIDR, vcpu->arch.tid);
 	if (host_os_sprs->iamr != vcpu->arch.iamr)
 		mtspr(SPRN_IAMR, vcpu->arch.iamr);
@@ -239,9 +250,9 @@ static void load_spr_state(struct kvm_vcpu *vcpu,
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
@@ -261,20 +272,15 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
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
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
@@ -315,7 +321,6 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 #ifdef CONFIG_ALTIVEC
 	load_vr_state(&vcpu->arch.vr);
 #endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
 
 	return ret;
 }
@@ -329,7 +334,6 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_ALTIVEC
 	store_vr_state(&vcpu->arch.vr);
 #endif
-	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 	if ((cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
@@ -354,12 +358,8 @@ EXPORT_SYMBOL_GPL(store_vcpu_state);
 
 void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 {
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		host_os_sprs->tidr = mfspr(SPRN_TIDR);
 	host_os_sprs->iamr = mfspr(SPRN_IAMR);
 	host_os_sprs->amr = mfspr(SPRN_AMR);
-	host_os_sprs->fscr = mfspr(SPRN_FSCR);
-	host_os_sprs->dscr = mfspr(SPRN_DSCR);
 }
 EXPORT_SYMBOL_GPL(save_p9_host_os_sprs);
 
@@ -367,26 +367,63 @@ EXPORT_SYMBOL_GPL(save_p9_host_os_sprs);
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
 
-	if (!cpu_has_feature(CPU_FTR_ARCH_31))
-		mtspr(SPRN_TIDR, host_os_sprs->tidr);
+	if (!cpu_has_feature(CPU_FTR_ARCH_31) &&
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

