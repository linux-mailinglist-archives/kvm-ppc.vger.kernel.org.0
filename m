Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE3131F521
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBSGhN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBSGhL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:11 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1CEC06178C
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:08 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id z68so3064501pgz.0
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UBbfwbPCGZtBjpMxRHwoulDs1NabUx7gaeccGbBuSxc=;
        b=BYR6MJ4qDGmkUVdNwiZkKlCC9DkKwoMW6MlEIvqHrb9aW7pP6ZB3xHkgBoEinfGH6U
         PD/c2wnCjIU+MbChwCmLE+rfdizj8Y9Iv9ROUfH4NAElaYTiYQCGnjKqIIuQZ7IE3h3F
         uupQQMqd+PGR1eTvLKYkE+x11n1q2nF0VNAeczjPjOfyzVdigEjmEV3llUVxLJT9ozCk
         DGzRdl4Fi4O9ibUhgIQCmqi1dDX+C3XX4gTir4tU2UCpxGStqnBzPGq/fEppqKhlP76h
         t21H/CiGkhGEA6hM8CtBWc6HpCDIf3UUJGLUmK6MjiHNYE7HWbEW0bAM60t6uh+Jv+F/
         proA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UBbfwbPCGZtBjpMxRHwoulDs1NabUx7gaeccGbBuSxc=;
        b=F4ihbk83E9OZrFfpiwe5raNdvjNwofZBQwgBQpVG7Z2KbQyXZJgCFRNqdchfV3h0Fe
         CwccNmHi7gt5RnjA9Jvl6klwLptpHtB1/nSd3A8/MNLxfH4mcQUiRx2X6iTRgReTrozx
         mUDr0F7RFQW4j3kS7NoexPpsZVjIAG7yGek7bdMAv8L/8QkGIiZpVx5j3M4i828iO88U
         bFUv5iBwmZV792A1CX0Egs7Pc/K4O62E+AaG0paOdC2LjGMOlLD6AtXm5Men/eztqiw0
         b9eyO+Xvqu+qJ8vDsReJv79QkzYKbjruagGTML0sIGq0v99X6YAg0G+zWUIcYpZh7bnq
         itcQ==
X-Gm-Message-State: AOAM530YBVJnPdh0QGxcUkF0CgpyDvsdE3hG1u30ZL4CuxauONFrLx3z
        3JzmXMjEznAJhtkxGaK89fYALlCmUW0=
X-Google-Smtp-Source: ABdhPJxE8ANyVYa+gYW63PRD67yG6zAqZ9PUTkkGp7eiIhjmVYgUWzC0EVvNfuv5nGl4n2d1m6acCw==
X-Received: by 2002:a62:fcd7:0:b029:1dd:9e54:b830 with SMTP id e206-20020a62fcd70000b02901dd9e54b830mr8075408pfh.39.1613716567501;
        Thu, 18 Feb 2021 22:36:07 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:06 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 06/13] KVM: PPC: Book3S 64: Move GUEST_MODE_SKIP test into KVM
Date:   Fri, 19 Feb 2021 16:35:35 +1000
Message-Id: <20210219063542.1425130-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the GUEST_MODE_SKIP logic into KVM code. This is quite a KVM
internal detail that has no real need to be in common handlers.

Also add a comment explaining why this this thing exists.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 60 --------------------------
 arch/powerpc/kvm/book3s_64_entry.S   | 64 ++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 68 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a1640d6ea65d..96f22c582213 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -133,7 +133,6 @@ name:
 #define IBRANCH_TO_COMMON	.L_IBRANCH_TO_COMMON_\name\() /* ENTRY branch to common */
 #define IREALMODE_COMMON	.L_IREALMODE_COMMON_\name\() /* Common runs in realmode */
 #define IMASK		.L_IMASK_\name\()	/* IRQ soft-mask bit */
-#define IKVM_SKIP	.L_IKVM_SKIP_\name\()	/* Generate KVM skip handler */
 #define IKVM_REAL	.L_IKVM_REAL_\name\()	/* Real entry tests KVM */
 #define __IKVM_REAL(name)	.L_IKVM_REAL_ ## name
 #define IKVM_VIRT	.L_IKVM_VIRT_\name\()	/* Virt entry tests KVM */
@@ -191,9 +190,6 @@ do_define_int n
 	.ifndef IMASK
 		IMASK=0
 	.endif
-	.ifndef IKVM_SKIP
-		IKVM_SKIP=0
-	.endif
 	.ifndef IKVM_REAL
 		IKVM_REAL=0
 	.endif
@@ -254,15 +250,10 @@ do_define_int n
 	.balign IFETCH_ALIGN_BYTES
 \name\()_kvm:
 
-	.if IKVM_SKIP
-	cmpwi	r10,KVM_GUEST_MODE_SKIP
-	beq	89f
-	.else
 BEGIN_FTR_SECTION
 	ld	r10,IAREA+EX_CFAR(r13)
 	std	r10,HSTATE_CFAR(r13)
 END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
-	.endif
 
 	ld	r10,IAREA+EX_CTR(r13)
 	mtctr	r10
@@ -289,27 +280,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ori	r12,r12,(IVEC)
 	.endif
 	b	kvmppc_interrupt
-
-	.if IKVM_SKIP
-89:	mtocrf	0x80,r9
-	ld	r10,IAREA+EX_CTR(r13)
-	mtctr	r10
-	ld	r9,IAREA+EX_R9(r13)
-	ld	r10,IAREA+EX_R10(r13)
-	ld	r11,IAREA+EX_R11(r13)
-	ld	r12,IAREA+EX_R12(r13)
-	.if IHSRR_IF_HVMODE
-	BEGIN_FTR_SECTION
-	b	kvmppc_skip_Hinterrupt
-	FTR_SECTION_ELSE
-	b	kvmppc_skip_interrupt
-	ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
-	.elseif IHSRR
-	b	kvmppc_skip_Hinterrupt
-	.else
-	b	kvmppc_skip_interrupt
-	.endif
-	.endif
 .endm
 
 #else
@@ -1128,7 +1098,6 @@ INT_DEFINE_BEGIN(machine_check)
 	ISET_RI=0
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(machine_check)
 
@@ -1419,7 +1388,6 @@ INT_DEFINE_BEGIN(data_access)
 	IVEC=0x300
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access)
 
@@ -1465,7 +1433,6 @@ INT_DEFINE_BEGIN(data_access_slb)
 	IVEC=0x380
 	IRECONCILE=0
 	IDAR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 INT_DEFINE_END(data_access_slb)
 
@@ -2111,7 +2078,6 @@ INT_DEFINE_BEGIN(h_data_storage)
 	IHSRR=1
 	IDAR=1
 	IDSISR=1
-	IKVM_SKIP=1
 	IKVM_REAL=1
 	IKVM_VIRT=1
 INT_DEFINE_END(h_data_storage)
@@ -3088,32 +3054,6 @@ EXPORT_SYMBOL(do_uaccess_flush)
 MASKED_INTERRUPT
 MASKED_INTERRUPT hsrr=1
 
-#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
-kvmppc_skip_interrupt:
-	/*
-	 * Here all GPRs are unchanged from when the interrupt happened
-	 * except for r13, which is saved in SPRG_SCRATCH0.
-	 */
-	mfspr	r13, SPRN_SRR0
-	addi	r13, r13, 4
-	mtspr	SPRN_SRR0, r13
-	GET_SCRATCH0(r13)
-	RFI_TO_KERNEL
-	b	.
-
-kvmppc_skip_Hinterrupt:
-	/*
-	 * Here all GPRs are unchanged from when the interrupt happened
-	 * except for r13, which is saved in SPRG_SCRATCH0.
-	 */
-	mfspr	r13, SPRN_HSRR0
-	addi	r13, r13, 4
-	mtspr	SPRN_HSRR0, r13
-	GET_SCRATCH0(r13)
-	HRFI_TO_KERNEL
-	b	.
-#endif
-
 	/*
 	 * Relocation-on interrupts: A subset of the interrupts can be delivered
 	 * with IR=1/DR=1, if AIL==2 and MSR.HV won't be changed by delivering
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 147ebf1c3c1f..820d103e5f50 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -1,9 +1,10 @@
+#include <asm/asm-offsets.h>
 #include <asm/cache.h>
-#include <asm/ppc_asm.h>
+#include <asm/exception-64s.h>
 #include <asm/kvm_asm.h>
-#include <asm/reg.h>
-#include <asm/asm-offsets.h>
 #include <asm/kvm_book3s_asm.h>
+#include <asm/ppc_asm.h>
+#include <asm/reg.h>
 
 /*
  * This is branched to from interrupt handlers in exception-64s.S which set
@@ -19,17 +20,64 @@ kvmppc_interrupt:
 	 * guest R12 saved in shadow VCPU SCRATCH0
 	 * guest R13 saved in SPRN_SCRATCH0
 	 */
+	std	r9,HSTATE_SCRATCH2(r13)
+	lbz	r9,HSTATE_IN_GUEST(r13)
+	cmpwi	r9,KVM_GUEST_MODE_SKIP
+	beq-	.Lmaybe_skip
+.Lno_skip:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-	std	r9, HSTATE_SCRATCH2(r13)
-	lbz	r9, HSTATE_IN_GUEST(r13)
-	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
 	beq	kvmppc_bad_host_intr
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	cmpwi	r9, KVM_GUEST_MODE_GUEST
-	ld	r9, HSTATE_SCRATCH2(r13)
+	cmpwi	r9,KVM_GUEST_MODE_GUEST
+	ld	r9,HSTATE_SCRATCH2(r13)
 	beq	kvmppc_interrupt_pr
 #endif
 	b	kvmppc_interrupt_hv
 #else
 	b	kvmppc_interrupt_pr
 #endif
+
+/*
+ * KVM uses a trick where it is running in MSR[HV]=1 mode in real-mode with the
+ * guest MMU context loaded, and it sets KVM_GUEST_MODE_SKIP and enables
+ * MSR[DR]=1 while leaving MSR[IR]=0, so it continues to fetch HV instructions
+ * but loads and stores will access the guest context. This is used to load
+ * the faulting instruction without walking page tables.
+ *
+ * However the guest context may not be able to translate, or it may cause a
+ * machine check or other issue, which will result in a fault in the host
+ * (even with KVM-HV).
+ *
+ * These faults are caught here and if the fault was (or was likely) due to
+ * that load, then we just return with the PC advanced +4 and skip the load,
+ * which then goes via the slow path.
+ */
+.Lmaybe_skip:
+	cmpwi	r12,BOOK3S_INTERRUPT_MACHINE_CHECK
+	beq	1f
+	cmpwi	r12,BOOK3S_INTERRUPT_DATA_STORAGE
+	beq	1f
+	cmpwi	r12,BOOK3S_INTERRUPT_DATA_SEGMENT
+	beq	1f
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	cmpwi	r12,BOOK3S_INTERRUPT_H_DATA_STORAGE | 0x2
+	beq	2f
+#endif
+	b	.Lno_skip
+1:	mfspr	r9,SPRN_SRR0
+	addi	r9,r9,4
+	mtspr	SPRN_SRR0,r9
+	ld	r12,HSTATE_SCRATCH0(r13)
+	ld	r9,HSTATE_SCRATCH2(r13)
+	GET_SCRATCH0(r13)
+	RFI_TO_KERNEL
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+2:	mfspr	r9,SPRN_HSRR0
+	addi	r9,r9,4
+	mtspr	SPRN_HSRR0,r9
+	ld	r12,HSTATE_SCRATCH0(r13)
+	ld	r9,HSTATE_SCRATCH2(r13)
+	GET_SCRATCH0(r13)
+	HRFI_TO_KERNEL
+#endif
-- 
2.23.0

