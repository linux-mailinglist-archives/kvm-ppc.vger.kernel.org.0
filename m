Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74115393F80
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhE1JKq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbhE1JKf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04376C061350
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h12so1319035plf.11
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OnKJh4y5kXTOR3ecJKEiQJFMQnnKoAjceJviPL+WZes=;
        b=kC1kkCYzNaU1UwHgcCyIxOYVav32pD95xQVypy1ZC4XJccHM7xYeAiqy/p2GIHFtIS
         U6BFduasKNct4+eSiIteclntK71XHBPIgwbvPnX7KfaNHcOHxxp27dT066rtlC45pxEd
         GKLyi5hXrczZ6eAXRPQMN1jc9IhzJxI0kc/yOpzgftJQNGp4NlOVXkJLP5wIIh+zsOAR
         Z+UxGOTdVNK6WfbfI4IdX/BAo9QcTXAC4M28pD1Ud/zSho/KJbWfN41ZNHpVFZsZduau
         LLgvn/kesA/tJMf13odzUpVd8M5Wlvnndsuz/dbu5vlCiYZO8dNV79t+ruwt4LJJBRQ0
         Fedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OnKJh4y5kXTOR3ecJKEiQJFMQnnKoAjceJviPL+WZes=;
        b=AudyoTMqYpooUpkcoT8Yn4hG1Jo+7X4MMTq6MJj5NhCHLFQRwXOxl/t0sHs0PJBiB5
         SQtcGPIX05vY4mJuyYR+Rh4nmn/ue1ds8DkCYrv1SmfrDsxUk/MWUAKBUEJbDupNPX08
         qOdGH1v5M9I+i5RfOuEP0FtJG0nB/atQ37KamEoZSGXSBZ9Wl2sgkeHy6xSeh05NHr0H
         HR22kjk10gSud82siDyKmmRHMqRHZPPMsIbcm2D7xuA0XED1Eh3fWKt63FSK9IVGS7UF
         JJfKiTDEghQd0/bmdWpe07CrLNUPFR2/4e6GlY/x2uUmghmTzGfjolUrvYjgNh2WsPfn
         //Hw==
X-Gm-Message-State: AOAM531tVlThuYL2UGhm/FcPCYBzozIgeyh2vaO/c+1ifr/LGoNAZvNe
        ZryAL5HPp5jT7arl6SNZJqd56NesUgk=
X-Google-Smtp-Source: ABdhPJzd1SIf+CiXZ6GlwxeXlHPblGpVAhxWBw6f26GT1i+xKX2NCnoMzL8il8DRrdts1icJRR9fqQ==
X-Received: by 2002:a17:90a:c68f:: with SMTP id n15mr3177324pjt.112.1622192935404;
        Fri, 28 May 2021 02:08:55 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 22/32] KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
Date:   Fri, 28 May 2021 19:07:42 +1000
Message-Id: <20210528090752.3542186-23-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dependent-threads mode is the normal KVM mode for pre-POWER9 SMT
processors, where all threads in a core (or subcore) would run the same
partition at the same time, or they would run the host.

This design was mandated by MMU state that is shared between threads in
a processor, so the synchronisation point is in hypervisor real-mode
that has essentially no shared state, so it's safe for multiple threads
to gather and switch to the correct mode.

It is implemented by having the host unplug all secondary threads and
always run in SMT1 mode, and host QEMU threads essentially represent
virtual cores that wake these secondary threads out of unplug when the
ioctl is called to run the guest. This happens via a side-path that is
mostly invisible to the rest of the Linux host and the secondary threads
still appear to be unplugged.

POWER9 / ISA v3.0 has a more flexible MMU design that is independent
per-thread and allows a much simpler KVM implementation. Before the new
"P9 fast path" was added that began to take advantage of this, POWER9
support was implemented in the existing path which has support to run
in the dependent threads mode. So it was not much work to add support to
run POWER9 in this dependent threads mode.

The mode is not required by the POWER9 MMU (although "mixed-mode" hash /
radix MMU limitations of early processors were worked around using this
mode). But it is one way to run SMT guests without running different
guests or guest and host on different threads of the same core, so it
could avoid or reduce some SMT attack surfaces without turning off SMT
entirely.

This security feature has some real, if indeterminate, value. However
the old path is lagging in features (nested HV), and with this series
the new P9 path adds remaining missing features (radix prefetch bug
and hash support, in later patches), so POWER9 dependent threads mode
support would be the only remaining reason to keep that code in and keep
supporting POWER9/POWER10 in the old path. So here we make the call to
drop this feature.

Remove dependent threads mode support for POWER9 and above processors.
Systems can still achieve this security by disabling SMT entirely, but
that would generally come at a larger performance cost for guests.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_asm.h  |  2 +-
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/powerpc/kvm/book3s_64_entry.S  |  3 +--
 arch/powerpc/kvm/book3s_hv.c        | 27 +++++----------------------
 4 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index 43b1788e1f93..f4ae37810aa9 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -147,7 +147,7 @@
 #define KVM_GUEST_MODE_SKIP	2
 #define KVM_GUEST_MODE_GUEST_HV	3
 #define KVM_GUEST_MODE_HOST_HV	4
-#define KVM_GUEST_MODE_HV_FAST	5 /* ISA >= v3.0 host+guest radix, indep thr */
+#define KVM_GUEST_MODE_HV_FAST	5 /* ISA >= v3.0 host+guest radix */
 
 #define KVM_INST_FETCH_FAILED	-1
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 69add9d662df..6904ce9e8190 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -297,7 +297,6 @@ struct kvm_arch {
 	u8 fwnmi_enabled;
 	u8 secure_guest;
 	u8 svm_enabled;
-	bool threads_indep;
 	bool nested_enable;
 	bool dawr1_enabled;
 	pgd_t *pgtable;
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 177e8fad5c8d..bac664c1a9f7 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -184,8 +184,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
  * void kvmppc_p9_enter_guest(struct vcpu *vcpu);
  *
  * Enter the guest on a ISAv3.0 or later system where we have exactly
- * one vcpu per vcore, and both the host and guest are radix, and threads
- * are set to "indepdent mode".
+ * one vcpu per vcore, and both the host and guest are radix.
  */
 .balign	IFETCH_ALIGN_BYTES
 _GLOBAL(kvmppc_p9_enter_guest)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index eb25605e23b9..acb0c72ea900 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -103,13 +103,9 @@ static int target_smt_mode;
 module_param(target_smt_mode, int, 0644);
 MODULE_PARM_DESC(target_smt_mode, "Target threads per core (0 = max)");
 
-static bool indep_threads_mode = true;
-module_param(indep_threads_mode, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(indep_threads_mode, "Independent-threads mode (only on POWER9)");
-
 static bool one_vm_per_core;
 module_param(one_vm_per_core, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires indep_threads_mode=N)");
+MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires POWER8 or older)");
 
 #ifdef CONFIG_KVM_XICS
 static const struct kernel_param_ops module_param_ops = {
@@ -2265,7 +2261,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
  */
 static int threads_per_vcore(struct kvm *kvm)
 {
-	if (kvm->arch.threads_indep)
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
 		return 1;
 	return threads_per_subcore;
 }
@@ -4369,7 +4365,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm))
+		if (kvm_is_radix(kvm))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4992,21 +4988,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 	/*
 	 * Track that we now have a HV mode VM active. This blocks secondary
 	 * CPU threads from coming online.
-	 * On POWER9, we only need to do this if the "indep_threads_mode"
-	 * module parameter has been set to N.
 	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-		if (!indep_threads_mode && !cpu_has_feature(CPU_FTR_HVMODE)) {
-			pr_warn("KVM: Ignoring indep_threads_mode=N in nested hypervisor\n");
-			kvm->arch.threads_indep = true;
-		} else if (!indep_threads_mode && cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
-			pr_warn("KVM: Ignoring indep_threads_mode=N on pre-DD2.2 POWER9\n");
-			kvm->arch.threads_indep = true;
-		} else {
-			kvm->arch.threads_indep = indep_threads_mode;
-		}
-	}
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_activated();
 
 	/*
@@ -5047,7 +5030,7 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 {
 	debugfs_remove_recursive(kvm->arch.debugfs_dir);
 
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_deactivated();
 
 	kvmppc_free_vcores(kvm);
-- 
2.23.0

