Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC58137F7BF
	for <lists+kvm-ppc@lfdr.de>; Thu, 13 May 2021 14:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhEMMXf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 May 2021 08:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhEMMXe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 13 May 2021 08:23:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4947C061574
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:24 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so21590074pfn.6
        for <kvm-ppc@vger.kernel.org>; Thu, 13 May 2021 05:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MZLZe1EpGvUp3tmF8f6lJeAf6Y79X+dERgbOh0qCNo=;
        b=owe1N5TfAmHUnpsJaLU4psH4iRcMsHw4XYGgpfHrssEgGVX7lXHGDvNgD1k/1na4Uo
         iddwvk0LMk1HozlqMknGkenzlhDcWyUCtwpTQ5UFK/tjMJ0vs5HDE/5Wa+E3XXjNIQnw
         XOvQmDuTQV8Cz2xS/jeYtbOUtzrqwv+XhpbyCD3kCpm3xFSDAz4AOSPeJJooHZTwRx0s
         ReFz6HZfvwJHmmeb1bOyJPknk+c+UsQdqzHLnAAvJLgck2nzVL+aGAtZEc0RVC6RuAtt
         b6WX7DB70llLGyEC7iZy7ImR4tTUa1C0UuTRw2zB6SIMWfTocpaJUTNIzCK9fAOyEMo0
         SnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MZLZe1EpGvUp3tmF8f6lJeAf6Y79X+dERgbOh0qCNo=;
        b=GvPwaLO6ftlUkfbxMLG4Kl2j29z/WzvB0hZUZgA1AswyLi+QNo1pOdy/l5cbMXNF68
         b3FPt5PBMS2SYsPw0l+jGyodl1CwbxVTygeYSrXnHsi1R79THYAqbIq7qQWICNwD+c9J
         3Zokm8+skaz4Eg2Wy+n2hu7GremLGAFamnxHnpcUfFvFdp9+TxYG4mMfQLEqMTAotfLO
         VUXneQX0xGLoc5JCyywHmgFzuukbMBupTdr95e+jqCcAHX2YWs+kekU1CN0qFhJWIiyc
         DxGBxQ6L6BWxRHocMPNVEwiRgELwyJ6askIFm+BiR83yB8XrKYKoYva8cYZZSTGRy+9y
         X/9g==
X-Gm-Message-State: AOAM530SupU4m/xgkL3Kf7mHkh6jvfktM5IODVAebI2n1ZAHARZL63QN
        4njKGn88lNW0/GhSUtNB5dvUcZmh7MKBwg==
X-Google-Smtp-Source: ABdhPJxAeNaSrJw2+EGnU3ihloT0jQZIqyG9Rrud/ekMvLI40LXCM/BJkkPTqSOqYBq/fwjJEuX5rQ==
X-Received: by 2002:a62:7c4d:0:b029:289:d38:d1be with SMTP id x74-20020a627c4d0000b02902890d38d1bemr40360748pfc.23.1620908544163;
        Thu, 13 May 2021 05:22:24 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (14-201-155-8.tpgi.com.au. [14.201.155.8])
        by smtp.gmail.com with ESMTPSA id mp21sm6892416pjb.50.2021.05.13.05.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:22:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH 3/4] KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9 path
Date:   Thu, 13 May 2021 22:22:06 +1000
Message-Id: <20210513122207.1897664-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210513122207.1897664-1-npiggin@gmail.com>
References: <20210513122207.1897664-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the interest of minimising the amount of code that is run in
"real-mode", don't handle hcalls in real mode in the P9 path. This
requires some new handlers for H_CEDE and xics-on-xive to be added
before xive is pulled or cede logic is checked.

This introduces a change in radix guest behaviour where radix guests
that execute 'sc 1' in userspace now get a privilege fault whereas
previously the 'sc 1' would be reflected as a syscall interrupt to the
guest kernel. That reflection is only required for hash guests that run
PR KVM.

Background:

In POWER8 and earlier processors, it is very expensive to exit from the
HV real mode context of a guest hypervisor interrupt, and switch to host
virtual mode. On those processors, guest->HV interrupts reach the
hypervisor with the MMU off because the MMU is loaded with guest context
(LPCR, SDR1, SLB), and the other threads in the sub-core need to be
pulled out of the guest too. Then the primary must save off guest state,
invalidate SLB and ERAT, and load up host state before the MMU can be
enabled to run in host virtual mode (~= regular Linux mode).

Hash guests also require a lot of hcalls to run due to the nature of the
MMU architecture and paravirtualisation design. The XICS interrupt
controller requires hcalls to run.

So KVM traditionally tries hard to avoid the full exit, by handling
hcalls and other interrupts in real mode as much as possible.

By contrast, POWER9 has independent MMU context per-thread, and in radix
mode the hypervisor is in host virtual memory mode when the HV interrupt
is taken. Radix guests do not require significant hcalls to manage their
translations, and xive guests don't need hcalls to handle interrupts.

So it's much less important from a performance standpoint to handle
hcalls in real mode in P9.

The TCE hcalls are performance critical, introduced for P8 in order to
achieve 10GbE performance. They was not required on P9 (which was able
to drive 40GbE networking with just the virt mode hcalls), but
performance is quite important. After later changes that add hash guest
support to the P9 path, hash hcalls are also performance critical.  The
full entry/exit performance can still be improved significanty, but if
this is found to be inadequate then real-mode hcall handlers could be
reintroduced for the P9 path (in C), but this would be a last resort.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h      |  6 ++
 arch/powerpc/kvm/book3s.c               |  6 ++
 arch/powerpc/kvm/book3s_hv.c            | 79 +++++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 ++
 arch/powerpc/kvm/book3s_xive.c          | 64 ++++++++++++++++++++
 5 files changed, 149 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 8c10c3427166..cb9e3c85c605 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -129,6 +129,7 @@ extern void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_pending_dec(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_machine_check(struct kvm_vcpu *vcpu, ulong flags);
+extern void kvmppc_core_queue_syscall(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_program(struct kvm_vcpu *vcpu, ulong flags);
 extern void kvmppc_core_queue_fpunavail(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_queue_vec_unavail(struct kvm_vcpu *vcpu);
@@ -606,6 +607,7 @@ extern void kvmppc_free_pimap(struct kvm *kvm);
 extern int kvmppc_xics_rm_complete(struct kvm_vcpu *vcpu, u32 hcall);
 extern void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu);
 extern int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd);
+extern int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req);
 extern u64 kvmppc_xics_get_icp(struct kvm_vcpu *vcpu);
 extern int kvmppc_xics_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
 extern int kvmppc_xics_connect_vcpu(struct kvm_device *dev,
@@ -638,6 +640,8 @@ static inline int kvmppc_xics_enabled(struct kvm_vcpu *vcpu)
 static inline void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu) { }
 static inline int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd)
 	{ return 0; }
+static inline int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
+	{ return 0; }
 #endif
 
 #ifdef CONFIG_KVM_XIVE
@@ -672,6 +676,7 @@ extern int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
 			       int level, bool line_status);
 extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
 extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
+extern void kvmppc_xive_rearm_escalation(struct kvm_vcpu *vcpu);
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 {
@@ -713,6 +718,7 @@ static inline int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 ir
 				      int level, bool line_status) { return -ENODEV; }
 static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
 static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
+static inline void kvmppc_xive_rearm_escalation(struct kvm_vcpu *vcpu) { }
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 	{ return 0; }
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 2b691f4d1f26..d69560d5bf16 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -171,6 +171,12 @@ void kvmppc_core_queue_machine_check(struct kvm_vcpu *vcpu, ulong flags)
 }
 EXPORT_SYMBOL_GPL(kvmppc_core_queue_machine_check);
 
+void kvmppc_core_queue_syscall(struct kvm_vcpu *vcpu)
+{
+	kvmppc_inject_interrupt(vcpu, BOOK3S_INTERRUPT_SYSCALL, 0);
+}
+EXPORT_SYMBOL(kvmppc_core_queue_syscall);
+
 void kvmppc_core_queue_program(struct kvm_vcpu *vcpu, ulong flags)
 {
 	/* might as well deliver this straight away */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 287cd3e1b918..5815c04a48a3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -899,6 +899,10 @@ static int kvm_arch_vcpu_yield_to(struct kvm_vcpu *target)
 	 * H_SUCCESS if the source vcore wasn't idle (e.g. if it may
 	 * have useful work to do and should not confer) so we don't
 	 * recheck that here.
+	 *
+	 * In the case of the P9 single vcpu per vcore case, the real
+	 * mode handler is not called but no other threads are in the
+	 * source vcore.
 	 */
 
 	spin_lock(&vcore->lock);
@@ -1142,12 +1146,13 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Handle H_CEDE in the nested virtualization case where we haven't
- * called the real-mode hcall handlers in book3s_hv_rmhandlers.S.
+ * Handle H_CEDE in the P9 path where we don't call the real-mode hcall
+ * handlers in book3s_hv_rmhandlers.S.
+ *
  * This has to be done early, not in kvmppc_pseries_do_hcall(), so
  * that the cede logic in kvmppc_run_single_vcpu() works properly.
  */
-static void kvmppc_nested_cede(struct kvm_vcpu *vcpu)
+static void kvmppc_cede(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.shregs.msr |= MSR_EE;
 	vcpu->arch.ceded = 1;
@@ -1400,13 +1405,29 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	}
 	case BOOK3S_INTERRUPT_SYSCALL:
 	{
-		/* hcall - punt to userspace */
 		int i;
 
-		/* hypercall with MSR_PR has already been handled in rmode,
-		 * and never reaches here.
-		 */
+		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
+			/*
+			 * Guest userspace executed sc 1. This can only be
+			 * reached by the P9 path because the old path
+			 * handles this case in realmode hcall handlers.
+			 *
+			 * Radix guests can not run PR KVM or nested HV hash
+			 * guests which might run PR KVM, so this is always
+			 * a privilege fault. Send a program check to guest
+			 * kernel.
+			 */
+			kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
+			r = RESUME_GUEST;
+			break;
+		}
 
+		/*
+		 * hcall - gather args and set exit_reason. This will next be
+		 * handled by kvmppc_pseries_do_hcall which may be able to deal
+		 * with it and resume guest, or may punt to userspace.
+		 */
 		run->papr_hcall.nr = kvmppc_get_gpr(vcpu, 3);
 		for (i = 0; i < 9; ++i)
 			run->papr_hcall.args[i] = kvmppc_get_gpr(vcpu, 4 + i);
@@ -3664,6 +3685,12 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	return trap;
 }
 
+static inline bool hcall_is_xics(unsigned long req)
+{
+	return req == H_EOI || req == H_CPPR || req == H_IPI ||
+		req == H_IPOLL || req == H_XIRR || req == H_XIRR_X;
+}
+
 /*
  * Virtual-mode guest entry for POWER9 and later when the host and
  * guest are both using the radix MMU.  The LPIDR has already been set.
@@ -3787,15 +3814,36 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		/* H_CEDE has to be handled now, not later */
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    kvmppc_get_gpr(vcpu, 3) == H_CEDE) {
-			kvmppc_nested_cede(vcpu);
+			kvmppc_cede(vcpu);
 			kvmppc_set_gpr(vcpu, 3, 0);
 			trap = 0;
 		}
 	} else {
 		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
+		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+			unsigned long req = kvmppc_get_gpr(vcpu, 3);
+
+			/* H_CEDE has to be handled now, not later */
+			if (req == H_CEDE) {
+				kvmppc_cede(vcpu);
+				kvmppc_xive_rearm_escalation(vcpu); /* may un-cede */
+				kvmppc_set_gpr(vcpu, 3, 0);
+				trap = 0;
+
+			/* XICS hcalls must be handled before xive is pulled */
+			} else if (hcall_is_xics(req)) {
+				int ret;
+
+				ret = kvmppc_xive_xics_hcall(vcpu, req);
+				if (ret != H_TOO_HARD) {
+					kvmppc_set_gpr(vcpu, 3, ret);
+					trap = 0;
+				}
+			}
+		}
 		kvmppc_xive_pull_vcpu(vcpu);
-
 	}
 
 	vcpu->arch.slb_max = 0;
@@ -4461,8 +4509,17 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		else
 			r = kvmppc_run_vcpu(vcpu);
 
-		if (run->exit_reason == KVM_EXIT_PAPR_HCALL &&
-		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+		if (run->exit_reason == KVM_EXIT_PAPR_HCALL) {
+			if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_PR)) {
+				/*
+				 * These should have been caught reflected
+				 * into the guest by now. Final sanity check:
+				 * don't allow userspace to execute hcalls in
+				 * the hypervisor.
+				 */
+				r = RESUME_GUEST;
+				continue;
+			}
 			trace_kvm_hcall_enter(vcpu);
 			r = kvmppc_pseries_do_hcall(vcpu);
 			trace_kvm_hcall_exit(vcpu, r);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index c11597f815e4..2d0d14ed1d92 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1397,9 +1397,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	mr	r4,r9
 	bge	fast_guest_return
 2:
+	/* If we came in through the P9 short path, no real mode hcalls */
+	lwz	r0, STACK_SLOT_SHORT_PATH(r1)
+	cmpwi	r0, 0
+	bne	no_try_real
 	/* See if this is an hcall we can handle in real mode */
 	cmpwi	r12,BOOK3S_INTERRUPT_SYSCALL
 	beq	hcall_try_real_mode
+no_try_real:
 
 	/* Hypervisor doorbell - exit only if host IPI flag set */
 	cmpwi	r12, BOOK3S_INTERRUPT_H_DOORBELL
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 741bf1f4387a..24c07094651a 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -158,6 +158,40 @@ void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_xive_pull_vcpu);
 
+void kvmppc_xive_rearm_escalation(struct kvm_vcpu *vcpu)
+{
+	void __iomem *esc_vaddr = (void __iomem *)vcpu->arch.xive_esc_vaddr;
+
+	if (!esc_vaddr)
+		return;
+
+	/* we are using XIVE with single escalation */
+
+	if (vcpu->arch.xive_esc_on) {
+		/*
+		 * If we still have a pending escalation, abort the cede,
+		 * and we must set PQ to 10 rather than 00 so that we don't
+		 * potentially end up with two entries for the escalation
+		 * interrupt in the XIVE interrupt queue.  In that case
+		 * we also don't want to set xive_esc_on to 1 here in
+		 * case we race with xive_esc_irq().
+		 */
+		vcpu->arch.ceded = 0;
+		/*
+		 * The escalation interrupts are special as we don't EOI them.
+		 * There is no need to use the load-after-store ordering offset
+		 * to set PQ to 10 as we won't use StoreEOI.
+		 */
+		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_10);
+	} else {
+		vcpu->arch.xive_esc_on = true;
+		mb();
+		__raw_readq(esc_vaddr + XIVE_ESB_SET_PQ_00);
+	}
+	mb();
+}
+EXPORT_SYMBOL_GPL(kvmppc_xive_rearm_escalation);
+
 /*
  * This is a simple trigger for a generic XIVE IRQ. This must
  * only be called for interrupts that support a trigger page
@@ -2106,6 +2140,36 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	return 0;
 }
 
+int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+
+	/* The VM should have configured XICS mode before doing XICS hcalls. */
+	if (!kvmppc_xics_enabled(vcpu))
+		return H_TOO_HARD;
+
+	switch (req) {
+	case H_XIRR:
+		return xive_vm_h_xirr(vcpu);
+	case H_CPPR:
+		return xive_vm_h_cppr(vcpu, kvmppc_get_gpr(vcpu, 4));
+	case H_EOI:
+		return xive_vm_h_eoi(vcpu, kvmppc_get_gpr(vcpu, 4));
+	case H_IPI:
+		return xive_vm_h_ipi(vcpu, kvmppc_get_gpr(vcpu, 4),
+					  kvmppc_get_gpr(vcpu, 5));
+	case H_IPOLL:
+		return xive_vm_h_ipoll(vcpu, kvmppc_get_gpr(vcpu, 4));
+	case H_XIRR_X:
+		xive_vm_h_xirr(vcpu);
+		kvmppc_set_gpr(vcpu, 5, get_tb() + vc->tb_offset);
+		return H_SUCCESS;
+	}
+
+	return H_UNSUPPORTED;
+}
+EXPORT_SYMBOL_GPL(kvmppc_xive_xics_hcall);
+
 int kvmppc_xive_debug_show_queues(struct seq_file *m, struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
-- 
2.23.0

