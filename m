Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7454031F527
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSGhN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGhM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:12 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A415EC06178B
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:05 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o38so3037784pgm.9
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jhm/8hwT0svJtVVLeIJxaUdt1v44x42QMfv9clGkodE=;
        b=WK/1U2D2H1/QhmqWgnwXfK3G44ujbg6sHrUa0q3tmsNHmQQ47I7yHZ+9/ZjTzc0Ocs
         +cRm+1zL66mFuxs/AqyIjZku5Sa9aH+6UIdlR5JqzrD6c+bixKDFLH1xB0TRhE4luKwA
         knyz4YhRn1BesxJwvQbiNT+dJS+aUI9xwRjlCF6AWsWh9XB2DuW4jRIc5oZEX0y43GmP
         ftxnyiwz6iDD66/Hwa5E3A4oAxxJNKP7PAj7ng96VqCDo5OA3paK3BqqWh3cZwlZWvcB
         dKA18HW67wzjcS7hoIGhXebuvodQx2ifh4Fng9dgCmzm7l8qX91wgm1Fi22qFjF9TozX
         w2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jhm/8hwT0svJtVVLeIJxaUdt1v44x42QMfv9clGkodE=;
        b=V1ox8tAE4u8mo8N8P+cKgUc5E2gjb01XwyI7E/Iy/OkOhRNCom8vNYbZrvYi74TLQQ
         kkAYEf3alG5sjouGN8lcz/HtS3R3+0FeNZ4VHtUagUJJ+ca84ct0kbL5DwSL6Konq5Y/
         e37/McLG1mvPi/cHBZH6Wsx4FGjADl4zRm7N8dtrBRkZm0o9xB+699o5X9rO9BFrABZ7
         xGwJS5XjzY/vFTDsqf/HkHrgvrU0uClLUdYGEmWGraXIpnSaaVhFuN4ah3OYltTPAHzk
         WBdzl+9UAZ2lZYtTnlNL/zjWW2TFHEhj3dtZTSDTWE54HTWUhSDtxlKp28V2yn4LEGSC
         a9Xg==
X-Gm-Message-State: AOAM533cq6rdU5vkUE6xQmJY0CSrM5Oz6EivrATLSagYEpeEUFxiNv/V
        jOITywLDM/QFieQ3qoXOVluZVVi7IvU=
X-Google-Smtp-Source: ABdhPJy2P2QdU7WU6ECKASm4khcLdC1wI66vOCaW/+RJVo+XB6Zpelx2LGLlmOtFeiBSMcH3anNQ6g==
X-Received: by 2002:aa7:808b:0:b029:1ce:8a32:f5e8 with SMTP id v11-20020aa7808b0000b02901ce8a32f5e8mr526952pff.34.1613716564686;
        Thu, 18 Feb 2021 22:36:04 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:04 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH 05/13] KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
Date:   Fri, 19 Feb 2021 16:35:34 +1000
Message-Id: <20210219063542.1425130-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than bifurcate the call depending on whether or not HV is
possible, and have the HV entry test for PR, just make a single
common point which does the demultiplexing. This makes it simpler
to add another type of exit handler.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S    |  8 +-----
 arch/powerpc/kvm/Makefile               |  3 +++
 arch/powerpc/kvm/book3s_64_entry.S      | 35 +++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 ++------
 4 files changed, 41 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 5bc689a546ae..a1640d6ea65d 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -212,7 +212,6 @@ do_define_int n
 .endm
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 /*
  * All interrupts which set HSRR registers, as well as SRESET and MCE and
  * syscall when invoked with "sc 1" switch to MSR[HV]=1 (HVMODE) to be taken,
@@ -242,13 +241,8 @@ do_define_int n
 
 /*
  * If an interrupt is taken while a guest is running, it is immediately routed
- * to KVM to handle. If both HV and PR KVM arepossible, KVM interrupts go first
- * to kvmppc_interrupt_hv, which handles the PR guest case.
+ * to KVM to handle.
  */
-#define kvmppc_interrupt kvmppc_interrupt_hv
-#else
-#define kvmppc_interrupt kvmppc_interrupt_pr
-#endif
 
 .macro KVMTEST name
 	lbz	r10,HSTATE_IN_GUEST(r13)
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 2bfeaa13befb..cdd119028f64 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -59,6 +59,9 @@ kvm-pr-y := \
 kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
 	tm.o
 
+kvm-book3s_64-builtin-objs-y += \
+	book3s_64_entry.o
+
 ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 kvm-book3s_64-builtin-objs-$(CONFIG_KVM_BOOK3S_64_HANDLER) += \
 	book3s_rmhandlers.o
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
new file mode 100644
index 000000000000..147ebf1c3c1f
--- /dev/null
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -0,0 +1,35 @@
+#include <asm/cache.h>
+#include <asm/ppc_asm.h>
+#include <asm/kvm_asm.h>
+#include <asm/reg.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_book3s_asm.h>
+
+/*
+ * This is branched to from interrupt handlers in exception-64s.S which set
+ * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
+ */
+.global	kvmppc_interrupt
+.balign IFETCH_ALIGN_BYTES
+kvmppc_interrupt:
+	/*
+	 * Register contents:
+	 * R12		= (guest CR << 32) | interrupt vector
+	 * R13		= PACA
+	 * guest R12 saved in shadow VCPU SCRATCH0
+	 * guest R13 saved in SPRN_SCRATCH0
+	 */
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	std	r9, HSTATE_SCRATCH2(r13)
+	lbz	r9, HSTATE_IN_GUEST(r13)
+	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
+	beq	kvmppc_bad_host_intr
+#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
+	cmpwi	r9, KVM_GUEST_MODE_GUEST
+	ld	r9, HSTATE_SCRATCH2(r13)
+	beq	kvmppc_interrupt_pr
+#endif
+	b	kvmppc_interrupt_hv
+#else
+	b	kvmppc_interrupt_pr
+#endif
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 3988873b044c..bbf786a0c0d6 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1255,16 +1255,8 @@ kvmppc_interrupt_hv:
 	 * R13		= PACA
 	 * guest R12 saved in shadow VCPU SCRATCH0
 	 * guest R13 saved in SPRN_SCRATCH0
+	 * guest R9 saved in HSTATE_SCRATCH2
 	 */
-	std	r9, HSTATE_SCRATCH2(r13)
-	lbz	r9, HSTATE_IN_GUEST(r13)
-	cmpwi	r9, KVM_GUEST_MODE_HOST_HV
-	beq	kvmppc_bad_host_intr
-#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
-	cmpwi	r9, KVM_GUEST_MODE_GUEST
-	ld	r9, HSTATE_SCRATCH2(r13)
-	beq	kvmppc_interrupt_pr
-#endif
 	/* We're now back in the host but in guest MMU context */
 	li	r9, KVM_GUEST_MODE_HOST_HV
 	stb	r9, HSTATE_IN_GUEST(r13)
@@ -3262,6 +3254,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
  * cfar is saved in HSTATE_CFAR(r13)
  * ppr is saved in HSTATE_PPR(r13)
  */
+.global kvmppc_bad_host_intr
 kvmppc_bad_host_intr:
 	/*
 	 * Switch to the emergency stack, but start half-way down in
-- 
2.23.0

