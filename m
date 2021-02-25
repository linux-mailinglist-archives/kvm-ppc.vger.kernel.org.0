Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF63250D5
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBYNtN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhBYNtH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:07 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70A4C061786
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:59 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a24so3201164plm.11
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZdOYv8+nnZM3a+E6C6u4dc+uTen+WkrGUatgkgkogK4=;
        b=StdzBC0eEVJ9WgNSNszS5UOUmm2MlwItvdM2++qKNG31X+dDJfL8y1/FbivVnxW5R5
         KQx1RYsU9PPY8KpzwB5/RvcXHnVoxFs1+q2vZDiR+QUzqh4aoObq+3afXp7Miu0gF43g
         6oMVe9FwjgTCs0cwcUUY/dV0RYNvDgWkxRRHy/M87E2UyPtHdBNhYnJYvhJRns4gI4SI
         THmRU0YOTy4LTQvfsp1191QRRtAhHkzjWMAtxwE8gc7MtJh28RfuZGqNUQGJkNZyuHVR
         Pc1QfkBMpmSPFzSzuAQW/U5i30hl1ziOl6C3Tqg9pSJPyOX3jQCq4DZAsUsLfYZXxz3a
         2uSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZdOYv8+nnZM3a+E6C6u4dc+uTen+WkrGUatgkgkogK4=;
        b=r1w0iNj8jSRYTulkTwOlK93OTVBT8zbDs3kIMt6nIQir4AjvRlqoiW4qpDbj3Zr7xz
         x3hguoru1JWhNilf0bQNYEkzT6Jzlo//hZz/G1xOVnuIg5dmVH2RIGHNebCkcaX7TB7Q
         dPe3cl6zEp0DWHk494h9DudUz23Kppvf8h79zXgH2Oz34sDW88KnHqtxPA07UuCkuQCa
         ZxVln/+kk9YBbdadZGYCRx8X15UGjOz8whRqos5Tx0hWS7KYDsHrUxhTc2ZuZJcKufBg
         dYishb+urSBJcZuE7zw5jZIgfztg5gde+ZihsB5mTlRgH+mcVDdyQEO4zKv+kjrY6cXW
         1YHw==
X-Gm-Message-State: AOAM530FSF78a/EArhFRJgCnO0rfFUaSM0c2RslpBd645wA4p8f1L4JG
        ASghZrV/rdrWYUN7IktRYTdcZIm41Xg=
X-Google-Smtp-Source: ABdhPJxE4Ai4Jq/cmQXxsnBQq6UKSowfA2PoZk0/AuHyqwVUVi8xPVcj7vR6uqQJ2gOhoQ8FKCmxKA==
X-Received: by 2002:a17:90b:1c0c:: with SMTP id oc12mr3364744pjb.180.1614260878614;
        Thu, 25 Feb 2021 05:47:58 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:57 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 16/37] KVM: PPC: Book3S HV P9: Stop handling hcalls in real-mode in the P9 path
Date:   Thu, 25 Feb 2021 23:46:31 +1000
Message-Id: <20210225134652.2127648-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/kvm_ppc.h      |  5 +++++
 arch/powerpc/kvm/book3s_hv.c            | 25 ++++++++++++++++++++++---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  5 +++++
 arch/powerpc/kvm/book3s_xive.c          | 25 +++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 3 deletions(-)

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
index 7e23838b7f9b..d4770b222d7e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1144,7 +1144,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
  * This has to be done early, not in kvmppc_pseries_do_hcall(), so
  * that the cede logic in kvmppc_run_single_vcpu() works properly.
  */
-static void kvmppc_nested_cede(struct kvm_vcpu *vcpu)
+static void kvmppc_cede(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.shregs.msr |= MSR_EE;
 	vcpu->arch.ceded = 1;
@@ -3731,15 +3731,34 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
+			if (req == H_EOI || req == H_CPPR || req == H_IPI ||
+			    req == H_IPOLL || req == H_XIRR || req == H_XIRR_X) {
+				unsigned long ret;
+				ret = kvmppc_xive_xics_hcall(vcpu, req);
+				kvmppc_set_gpr(vcpu, 3, ret);
+				trap = 0;
+			}
+		}
+		kvmppc_xive_pull_vcpu(vcpu);
 	}
 
 	vcpu->arch.slb_max = 0;
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
index 8632fb998a55..d2266d36a7c7 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2109,6 +2109,31 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
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
+
 int kvmppc_xive_debug_show_queues(struct seq_file *m, struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
-- 
2.23.0

