Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7BE32EDD8
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhCEPIO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCEPHx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:53 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A41C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id jx13so2032908pjb.1
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TP7CbduLa9TGEdL03zCc1RAG+uVpzJX5xw6PaFmIEJo=;
        b=CKYQS0LwKc2shGncZLIdVHq+x9NCUPIkaqfsJjZWeyu7z+LTGT1lexMHUBKx6EE2t8
         Sqi1vTElnBvXeylOxCHr+uYzvMXoy9oB6U2S/e/ulIT8LXlGqSFCpQH5aSylBooTwlhO
         gYq0MBOS47U7aQcCkflXNd5tHmV4xbxg6bfXrh3BttTsTHlTQrRpX0cP7k7ZiqC/caoL
         38ALEc5H+SNPRqA+TeCT4uo6S/LoJuthOVDj+DpU5TQsgH9A+tH35nuh/JHuZp3gDmm2
         OgmZl7vMvdTqcIe9w8OzRHeGYkk2eNGc+YOVHzMmgU2HtPDgGUz2VBI8R+PU0lENkkRb
         Z4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TP7CbduLa9TGEdL03zCc1RAG+uVpzJX5xw6PaFmIEJo=;
        b=H0oq/+xoZSzDA1jrtjDLI0ZP6NWJ3rCXu9JYR5r2Ot8vvdzG4ei2Nhm2GNDtktiYEJ
         XIN5UCTjzjWg2tA4KawTNV1EAGaXM7Tkvdl+BgYg7B78oARGWAtBAgDLTgeVCvWxVNJ3
         GBdY8aZSTpQTqvdFJPxQrvI2WSmz8f9rkAxErUcCVrJMUdy+tMecRKSFp03QyzOsqiDr
         CQ76EOlMWjid9zxhgVN9kna+qN4bQepNUDLZRE5LAtnEq4N+16VwgG3X+Q4gWi0y0Veh
         pdEYRFm2r7Hgb2HUneAHkyK//DkvQjkIHDE0vr8F8a2d1Ldnd60WJqyup5D6ABSte5es
         l4Yg==
X-Gm-Message-State: AOAM530TrKwmI4PWBkRGNVYnjUqZwK+/gblKUjj2fJ4FuL3xBJuzI5tD
        zYQBZiuWch49wWojtTzkLGCph/CUuiw=
X-Google-Smtp-Source: ABdhPJxu1C7fXfKAusRzqWnls7MndorJCtBe+tJy6g/PQ3C2tPd2h84v4r5+pysGXZyOwwSapUQtMg==
X-Received: by 2002:a17:90a:4dc1:: with SMTP id r1mr10887921pjl.12.1614956871958;
        Fri, 05 Mar 2021 07:07:51 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:51 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 19/41] KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9 path
Date:   Sat,  6 Mar 2021 01:06:16 +1000
Message-Id: <20210305150638.2675513-20-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the interest of minimising the amount of code that is run in
"real-mode", don't handle hcalls in real mode in the P9 path.

POWER8 and earlier are much more expensive to exit from HV real mode
and switch to host mode, because on those processors HV interrupts get
to the hypervisor with the MMU off, and the other threads in the core
need to be pulled out of the guest, and SLBs all need to be saved,
ERATs invalidated, and host SLB reloaded before the MMU is re-enabled
in host mode. Hash guests also require a lot of hcalls to run. The
XICS interrupt controller requires hcalls to run.

By contrast, POWER9 has independent thread switching, and in radix mode
the hypervisor is already in a host virtual memory mode when the HV
interrupt is taken. Radix + xive guests don't need hcalls to handle
interrupts or manage translations.

So it's much less important to handle hcalls in real mode in P9.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h      |  5 +++
 arch/powerpc/kvm/book3s_hv.c            | 46 +++++++++++++++----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 +++
 arch/powerpc/kvm/book3s_xive.c          | 60 +++++++++++++++++++++++++
 4 files changed, 108 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 73b1ca5a6471..db6646c2ade2 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -607,6 +607,7 @@ extern void kvmppc_free_pimap(struct kvm *kvm);
 extern int kvmppc_xics_rm_complete(struct kvm_vcpu *vcpu, u32 hcall);
 extern void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu);
 extern int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd);
+extern int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req);
 extern u64 kvmppc_xics_get_icp(struct kvm_vcpu *vcpu);
 extern int kvmppc_xics_set_icp(struct kvm_vcpu *vcpu, u64 icpval);
 extern int kvmppc_xics_connect_vcpu(struct kvm_device *dev,
@@ -639,6 +640,8 @@ static inline int kvmppc_xics_enabled(struct kvm_vcpu *vcpu)
 static inline void kvmppc_xics_free_icp(struct kvm_vcpu *vcpu) { }
 static inline int kvmppc_xics_hcall(struct kvm_vcpu *vcpu, u32 cmd)
 	{ return 0; }
+static inline int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
+	{ return 0; }
 #endif
 
 #ifdef CONFIG_KVM_XIVE
@@ -673,6 +676,7 @@ extern int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq,
 			       int level, bool line_status);
 extern void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu);
 extern void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu);
+extern void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu);
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 {
@@ -714,6 +718,7 @@ static inline int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 ir
 				      int level, bool line_status) { return -ENODEV; }
 static inline void kvmppc_xive_push_vcpu(struct kvm_vcpu *vcpu) { }
 static inline void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu) { }
+static inline void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu) { }
 
 static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 	{ return 0; }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 497f216ad724..1f2ba8955c6a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1147,7 +1147,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
  * This has to be done early, not in kvmppc_pseries_do_hcall(), so
  * that the cede logic in kvmppc_run_single_vcpu() works properly.
  */
-static void kvmppc_nested_cede(struct kvm_vcpu *vcpu)
+static void kvmppc_cede(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.shregs.msr |= MSR_EE;
 	vcpu->arch.ceded = 1;
@@ -1403,9 +1403,15 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		/* hcall - punt to userspace */
 		int i;
 
-		/* hypercall with MSR_PR has already been handled in rmode,
-		 * and never reaches here.
-		 */
+		if (unlikely(vcpu->arch.shregs.msr & MSR_PR)) {
+			/*
+			 * Guest userspace executed sc 1, reflect it back as a
+			 * privileged program check interrupt.
+			 */
+			kvmppc_core_queue_program(vcpu, SRR1_PROGPRIV);
+			r = RESUME_GUEST;
+			break;
+		}
 
 		run->papr_hcall.nr = kvmppc_get_gpr(vcpu, 3);
 		for (i = 0; i < 9; ++i)
@@ -3740,15 +3746,36 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
-		kvmppc_xive_pull_vcpu(vcpu);
+		/* H_CEDE has to be handled now, not later */
+		/* XICS hcalls must be handled before xive is pulled */
+		if (trap == BOOK3S_INTERRUPT_SYSCALL &&
+		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+			unsigned long req = kvmppc_get_gpr(vcpu, 3);
 
+			if (req == H_CEDE) {
+				kvmppc_cede(vcpu);
+				kvmppc_xive_cede_vcpu(vcpu); /* may un-cede */
+				kvmppc_set_gpr(vcpu, 3, 0);
+				trap = 0;
+			}
+			if (req == H_EOI || req == H_CPPR ||
+			    req == H_IPI || req == H_IPOLL ||
+			    req == H_XIRR || req == H_XIRR_X) {
+				unsigned long ret;
+
+				ret = kvmppc_xive_xics_hcall(vcpu, req);
+				kvmppc_set_gpr(vcpu, 3, ret);
+				trap = 0;
+			}
+		}
+		kvmppc_xive_pull_vcpu(vcpu);
 	}
 
 	vcpu->arch.slb_max = 0;
@@ -4408,8 +4435,11 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		else
 			r = kvmppc_run_vcpu(vcpu);
 
-		if (run->exit_reason == KVM_EXIT_PAPR_HCALL &&
-		    !(vcpu->arch.shregs.msr & MSR_PR)) {
+		if (run->exit_reason == KVM_EXIT_PAPR_HCALL) {
+			if (WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_PR)) {
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
index 52cdb9e2660a..1e4871bbcad4 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -158,6 +158,40 @@ void kvmppc_xive_pull_vcpu(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_xive_pull_vcpu);
 
+void kvmppc_xive_cede_vcpu(struct kvm_vcpu *vcpu)
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
+EXPORT_SYMBOL_GPL(kvmppc_xive_cede_vcpu);
+
 /*
  * This is a simple trigger for a generic XIVE IRQ. This must
  * only be called for interrupts that support a trigger page
@@ -2106,6 +2140,32 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 	return 0;
 }
 
+int kvmppc_xive_xics_hcall(struct kvm_vcpu *vcpu, u32 req)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
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

