Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07702353AB1
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhDEBWX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhDEBWW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF7BC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id a6so1598898pls.1
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x1na3vKWwEVLh/wkax9yvasb6uioVZX1qkzSylCi2Js=;
        b=uOJB+Ghy53Ghc8UzNECb4Nf0+lGPr+JWma/TJ6fF/BGpu+5++Wg+HMFjkZO+WYbe1j
         OKCQUkIZlz02/1D6MawQDCEQrLRQe8rbUYM7NXGpu0OkQn9ziJl1i0r/IAm6CjoSCpgj
         IGv4LuFe5geIjpkpP7ZBAJSkvvT9Mx9eVIxHi9EqhvSfVbP9YgYHkXbPd2rhqyMTjlTa
         ylvz86VqhbIFn8mGn4kAZhknIGmi/Q8RaGnS4JB+e/sUh8zZBfCO7RNnrGfleGBquSbM
         BZuvupBGyCe3BIAzh/OvxMsqzGaZ/La+/KqIQN0ORpzprM9XzXMFU1nUN75UlgjDRkaU
         tyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1na3vKWwEVLh/wkax9yvasb6uioVZX1qkzSylCi2Js=;
        b=rkN3qZe0/BBC8ZNLVkp7j+QagmUFo+3CByIW3mdPDbaH5p1dnEboKN4b2ek0z+quMi
         BYgzSm2+Sl7oc3+phI3oK3hc9j2hcr82oAAKDmWn93yfbcbcks9DLIX5gHqiUUkLQ7qg
         SIz+FOutJuWq2o3CsROUED8FNDS9i7n4T5iQ4TGi3ifR64W2KwbyM9wNcPx0lHK8+IR9
         3NpPfQi/mZoJdDYrxwaxcaSi6doTNkeD8jnwI3r7VXSUdXyKmOjCh/skkfWM8Ib45kz6
         SVx1KKH4qgw1UMSjGIAtv0YyBBIWW+R2YAzXGtUf14ILif1NodIvhSHJHHkjix3qD6Ib
         y7zw==
X-Gm-Message-State: AOAM532P+bJfM9w8QJXkJ8pftZ5BLwqt8fJKVYWJdaFTXfLnvG19gXKy
        TmD6YOrtQJQKFr2YHlOUcGU085m94hdn/A==
X-Google-Smtp-Source: ABdhPJwcO3PSZjxZHKnHQzXBvAAaNe2vJZtVwpFsI++nW9t9O5Pc9xDjIHBlaCON+A97iNPEwVOWnA==
X-Received: by 2002:a17:90b:360b:: with SMTP id ml11mr23488807pjb.98.1617585736153;
        Sun, 04 Apr 2021 18:22:16 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:15 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH v6 40/48] KVM: PPC: Book3S HV: Remove virt mode checks from real mode handlers
Date:   Mon,  5 Apr 2021 11:19:40 +1000
Message-Id: <20210405011948.675354-41-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Now that the P7/8 path no longer supports radix, real-mode handlers
do not need to deal with being called in virt mode.

This change effectively reverts commit acde25726bc6 ("KVM: PPC: Book3S
HV: Add radix checks in real-mode hypercall handlers").

It removes a few more real-mode tests in rm hcall handlers, which
allows the indirect ops for the xive module to be removed from the
built-in xics rm handlers.

kvmppc_h_random is renamed to kvmppc_rm_h_random to be a bit more
descriptive and consistent with other rm handlers.

Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_ppc.h      | 10 +--
 arch/powerpc/kvm/book3s.c               | 11 +--
 arch/powerpc/kvm/book3s_64_vio_hv.c     | 12 ----
 arch/powerpc/kvm/book3s_hv_builtin.c    | 91 ++++++-------------------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 +-
 arch/powerpc/kvm/book3s_xive.c          | 18 -----
 arch/powerpc/kvm/book3s_xive.h          |  7 --
 arch/powerpc/kvm/book3s_xive_native.c   | 10 ---
 8 files changed, 23 insertions(+), 138 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index cbd8deba2e8a..896e309431fb 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -660,8 +660,6 @@ extern int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				u32 *priority);
 extern int kvmppc_xive_int_on(struct kvm *kvm, u32 irq);
 extern int kvmppc_xive_int_off(struct kvm *kvm, u32 irq);
-extern void kvmppc_xive_init_module(void);
-extern void kvmppc_xive_exit_module(void);
 
 extern int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 				    struct kvm_vcpu *vcpu, u32 cpu);
@@ -687,8 +685,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 extern int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu);
 extern void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu);
-extern void kvmppc_xive_native_init_module(void);
-extern void kvmppc_xive_native_exit_module(void);
 extern int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 				     union kvmppc_one_reg *val);
 extern int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu,
@@ -702,8 +698,6 @@ static inline int kvmppc_xive_get_xive(struct kvm *kvm, u32 irq, u32 *server,
 				       u32 *priority) { return -1; }
 static inline int kvmppc_xive_int_on(struct kvm *kvm, u32 irq) { return -1; }
 static inline int kvmppc_xive_int_off(struct kvm *kvm, u32 irq) { return -1; }
-static inline void kvmppc_xive_init_module(void) { }
-static inline void kvmppc_xive_exit_module(void) { }
 
 static inline int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
 					   struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
@@ -726,8 +720,6 @@ static inline int kvmppc_xive_enabled(struct kvm_vcpu *vcpu)
 static inline int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
 			  struct kvm_vcpu *vcpu, u32 cpu) { return -EBUSY; }
 static inline void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu) { }
-static inline void kvmppc_xive_native_init_module(void) { }
-static inline void kvmppc_xive_native_exit_module(void) { }
 static inline int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
 					    union kvmppc_one_reg *val)
 { return 0; }
@@ -763,7 +755,7 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 			   unsigned long tce_value, unsigned long npages);
 long int kvmppc_rm_h_confer(struct kvm_vcpu *vcpu, int target,
                             unsigned int yield_count);
-long kvmppc_h_random(struct kvm_vcpu *vcpu);
+long kvmppc_rm_h_random(struct kvm_vcpu *vcpu);
 void kvmhv_commence_exit(int trap);
 void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu);
 void kvmppc_subcore_enter_guest(void);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 1658f899e289..d3bd509b4093 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1052,13 +1052,10 @@ static int kvmppc_book3s_init(void)
 #ifdef CONFIG_KVM_XICS
 #ifdef CONFIG_KVM_XIVE
 	if (xics_on_xive()) {
-		kvmppc_xive_init_module();
 		kvm_register_device_ops(&kvm_xive_ops, KVM_DEV_TYPE_XICS);
-		if (kvmppc_xive_native_supported()) {
-			kvmppc_xive_native_init_module();
+		if (kvmppc_xive_native_supported())
 			kvm_register_device_ops(&kvm_xive_native_ops,
 						KVM_DEV_TYPE_XIVE);
-		}
 	} else
 #endif
 		kvm_register_device_ops(&kvm_xics_ops, KVM_DEV_TYPE_XICS);
@@ -1068,12 +1065,6 @@ static int kvmppc_book3s_init(void)
 
 static void kvmppc_book3s_exit(void)
 {
-#ifdef CONFIG_KVM_XICS
-	if (xics_on_xive()) {
-		kvmppc_xive_exit_module();
-		kvmppc_xive_native_exit_module();
-	}
-#endif
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kvmppc_book3s_exit_pr();
 #endif
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..dc6591548f0c 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -391,10 +391,6 @@ long kvmppc_rm_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
 	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
 	/* 	    liobn, ioba, tce); */
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
@@ -489,10 +485,6 @@ long kvmppc_rm_h_put_tce_indirect(struct kvm_vcpu *vcpu,
 	bool prereg = false;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	/*
 	 * used to check for invalidations in progress
 	 */
@@ -602,10 +594,6 @@ long kvmppc_rm_h_stuff_tce(struct kvm_vcpu *vcpu,
 	long i, ret;
 	struct kvmppc_spapr_tce_iommu_table *stit;
 
-	/* For radix, we might be in virtual mode, so punt */
-	if (kvm_is_radix(vcpu->kvm))
-		return H_TOO_HARD;
-
 	stt = kvmppc_find_table(vcpu->kvm, liobn);
 	if (!stt)
 		return H_TOO_HARD;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7a0e33a9c980..8d669a0e15f8 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -34,21 +34,6 @@
 #include "book3s_xics.h"
 #include "book3s_xive.h"
 
-/*
- * The XIVE module will populate these when it loads
- */
-unsigned long (*__xive_vm_h_xirr)(struct kvm_vcpu *vcpu);
-unsigned long (*__xive_vm_h_ipoll)(struct kvm_vcpu *vcpu, unsigned long server);
-int (*__xive_vm_h_ipi)(struct kvm_vcpu *vcpu, unsigned long server,
-		       unsigned long mfrr);
-int (*__xive_vm_h_cppr)(struct kvm_vcpu *vcpu, unsigned long cppr);
-int (*__xive_vm_h_eoi)(struct kvm_vcpu *vcpu, unsigned long xirr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_xirr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_ipoll);
-EXPORT_SYMBOL_GPL(__xive_vm_h_ipi);
-EXPORT_SYMBOL_GPL(__xive_vm_h_cppr);
-EXPORT_SYMBOL_GPL(__xive_vm_h_eoi);
-
 /*
  * Hash page table alignment on newer cpus(CPU_FTR_ARCH_206)
  * should be power of 2.
@@ -196,16 +181,9 @@ int kvmppc_hwrng_present(void)
 }
 EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
 
-long kvmppc_h_random(struct kvm_vcpu *vcpu)
+long kvmppc_rm_h_random(struct kvm_vcpu *vcpu)
 {
-	int r;
-
-	/* Only need to do the expensive mfmsr() on radix */
-	if (kvm_is_radix(vcpu->kvm) && (mfmsr() & MSR_IR))
-		r = powernv_get_random_long(&vcpu->arch.regs.gpr[4]);
-	else
-		r = powernv_get_random_real_mode(&vcpu->arch.regs.gpr[4]);
-	if (r)
+	if (powernv_get_random_real_mode(&vcpu->arch.regs.gpr[4]))
 		return H_SUCCESS;
 
 	return H_HARDWARE;
@@ -541,22 +519,13 @@ static long kvmppc_read_one_intr(bool *again)
 }
 
 #ifdef CONFIG_KVM_XICS
-static inline bool is_rm(void)
-{
-	return !(mfmsr() & MSR_DR);
-}
-
 unsigned long kvmppc_rm_h_xirr(struct kvm_vcpu *vcpu)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_xirr(vcpu);
-		if (unlikely(!__xive_vm_h_xirr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_xirr(vcpu);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_xirr(vcpu);
+	else
 		return xics_rm_h_xirr(vcpu);
 }
 
@@ -565,13 +534,9 @@ unsigned long kvmppc_rm_h_xirr_x(struct kvm_vcpu *vcpu)
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
 	vcpu->arch.regs.gpr[5] = get_tb();
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_xirr(vcpu);
-		if (unlikely(!__xive_vm_h_xirr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_xirr(vcpu);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_xirr(vcpu);
+	else
 		return xics_rm_h_xirr(vcpu);
 }
 
@@ -579,13 +544,9 @@ unsigned long kvmppc_rm_h_ipoll(struct kvm_vcpu *vcpu, unsigned long server)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_ipoll(vcpu, server);
-		if (unlikely(!__xive_vm_h_ipoll))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_ipoll(vcpu, server);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_ipoll(vcpu, server);
+	else
 		return H_TOO_HARD;
 }
 
@@ -594,13 +555,9 @@ int kvmppc_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_ipi(vcpu, server, mfrr);
-		if (unlikely(!__xive_vm_h_ipi))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_ipi(vcpu, server, mfrr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_ipi(vcpu, server, mfrr);
+	else
 		return xics_rm_h_ipi(vcpu, server, mfrr);
 }
 
@@ -608,13 +565,9 @@ int kvmppc_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_cppr(vcpu, cppr);
-		if (unlikely(!__xive_vm_h_cppr))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_cppr(vcpu, cppr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_cppr(vcpu, cppr);
+	else
 		return xics_rm_h_cppr(vcpu, cppr);
 }
 
@@ -622,13 +575,9 @@ int kvmppc_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr)
 {
 	if (!kvmppc_xics_enabled(vcpu))
 		return H_TOO_HARD;
-	if (xics_on_xive()) {
-		if (is_rm())
-			return xive_rm_h_eoi(vcpu, xirr);
-		if (unlikely(!__xive_vm_h_eoi))
-			return H_NOT_AVAILABLE;
-		return __xive_vm_h_eoi(vcpu, xirr);
-	} else
+	if (xics_on_xive())
+		return xive_rm_h_eoi(vcpu, xirr);
+	else
 		return xics_rm_h_eoi(vcpu, xirr);
 }
 #endif /* CONFIG_KVM_XICS */
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 87fa8bda3515..1bc5a3805a26 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2299,7 +2299,7 @@ hcall_real_table:
 #else
 	.long	0		/* 0x2fc - H_XIRR_X*/
 #endif
-	.long	DOTSYM(kvmppc_h_random) - hcall_real_table
+	.long	DOTSYM(kvmppc_rm_h_random) - hcall_real_table
 	.globl	hcall_real_table_end
 hcall_real_table_end:
 
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 24c07094651a..9268d386b128 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2352,21 +2352,3 @@ struct kvm_device_ops kvm_xive_ops = {
 	.get_attr = xive_get_attr,
 	.has_attr = xive_has_attr,
 };
-
-void kvmppc_xive_init_module(void)
-{
-	__xive_vm_h_xirr = xive_vm_h_xirr;
-	__xive_vm_h_ipoll = xive_vm_h_ipoll;
-	__xive_vm_h_ipi = xive_vm_h_ipi;
-	__xive_vm_h_cppr = xive_vm_h_cppr;
-	__xive_vm_h_eoi = xive_vm_h_eoi;
-}
-
-void kvmppc_xive_exit_module(void)
-{
-	__xive_vm_h_xirr = NULL;
-	__xive_vm_h_ipoll = NULL;
-	__xive_vm_h_ipi = NULL;
-	__xive_vm_h_cppr = NULL;
-	__xive_vm_h_eoi = NULL;
-}
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 86c24a4ad809..afe9eeac6d56 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -289,13 +289,6 @@ extern int xive_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 extern int xive_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);
 extern int xive_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr);
 
-extern unsigned long (*__xive_vm_h_xirr)(struct kvm_vcpu *vcpu);
-extern unsigned long (*__xive_vm_h_ipoll)(struct kvm_vcpu *vcpu, unsigned long server);
-extern int (*__xive_vm_h_ipi)(struct kvm_vcpu *vcpu, unsigned long server,
-			      unsigned long mfrr);
-extern int (*__xive_vm_h_cppr)(struct kvm_vcpu *vcpu, unsigned long cppr);
-extern int (*__xive_vm_h_eoi)(struct kvm_vcpu *vcpu, unsigned long xirr);
-
 /*
  * Common Xive routines for XICS-over-XIVE and XIVE native
  */
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 76800c84f2a3..1253666dd4d8 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1281,13 +1281,3 @@ struct kvm_device_ops kvm_xive_native_ops = {
 	.has_attr = kvmppc_xive_native_has_attr,
 	.mmap = kvmppc_xive_native_mmap,
 };
-
-void kvmppc_xive_native_init_module(void)
-{
-	;
-}
-
-void kvmppc_xive_native_exit_module(void)
-{
-	;
-}
-- 
2.23.0

