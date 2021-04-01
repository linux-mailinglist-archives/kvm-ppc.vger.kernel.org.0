Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E6351C99
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbhDASSw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhDASM4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:12:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5961EC0F26E2
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so3235025pjc.2
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAMjwOXp/lCYiC25gxUp2qYMVNKEbzScenfHr/CileU=;
        b=DsgL149uRCI/uUpAfyeuvnG/hvjXkSlPnQ1+DDD5yec7xiHV+qgxP2lLKiHvgbCIEc
         iVXIj9A4wrmaOPdzPnv2DMo9SiNeWVnPutt6pidrGpH2jLN5i3zC+sHDyNjcc39MIb8/
         EJXkJVMjiSctgxAnporHqTXs9EHnC1SBMe0ElrpTMwuQ+yct1OzV/RquxslhN3qwg54z
         BtL+5/ImO11VSN3ImDwa2pWikrXkmCJBwWrEt2S/OspA30IDOhhZYKJNwFna8RlEmdIF
         XEVjvcc3Q8GduXRFo6NzFd5awFzyYXE7xB0KJPwT6NclCZxBmOLAhbA7NbxmkStLVP3+
         I05A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAMjwOXp/lCYiC25gxUp2qYMVNKEbzScenfHr/CileU=;
        b=E6eHSqneD1q4bagxLoY8pPGeJBZ/FHeiUe+awRK/6IKcTtWriTBhpGZMku1bka0mF+
         nWhlAE/0YZm0V8cFr0iPoT4B7c6zP4wGcxZDf0hWC4EfuRc0RTikVVvw8JFbn1ezyzEP
         hq/dm9Y166D1uXCRZ8ELcLL2Al+f7yzj+XqFYrKtSXwvVGAMg4VauDjGYZ3RPVstTqFW
         Qg3ySTtNgh28FHDSpCg4h+EXMCt0QQzAC/JRBVixFIq5f7aerpIahpFZ5cyEP0uwnj6x
         mA4qAGXMZ8ikYkkPbayxP8TSCYupPyz6eimVyP2QnOKGYUg2SxJzy/qzZqSzqQhBZVN7
         Khlw==
X-Gm-Message-State: AOAM530fwICnECg7XkoUt2FGcCKXrHwH8me3Km+LcyshACSQlvN/KDaL
        2bCRya0IY596K8AVnBsvA72wNc209q0=
X-Google-Smtp-Source: ABdhPJz39CT2Q5MQfoqUCnrlngki/QUG0ZvaPOpeDu+eQ00hKiOBF49thnxVQBlhHtVQPiXSAMNlyw==
X-Received: by 2002:a17:90a:7786:: with SMTP id v6mr9275847pjk.16.1617289456749;
        Thu, 01 Apr 2021 08:04:16 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 12/48] KVM: PPC: Book3S 64: move KVM interrupt entry to a common entry point
Date:   Fri,  2 Apr 2021 01:02:49 +1000
Message-Id: <20210401150325.442125-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than bifurcate the call depending on whether or not HV is
possible, and have the HV entry test for PR, just make a single
common point which does the demultiplexing. This makes it simpler
to add another type of exit handler.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S    |  8 +-----
 arch/powerpc/kvm/Makefile               |  3 +++
 arch/powerpc/kvm/book3s_64_entry.S      | 36 +++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 ++------
 4 files changed, 42 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_64_entry.S

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index c9c446ccff54..162595af1ac7 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -208,7 +208,6 @@ do_define_int n
 .endm
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 /*
  * All interrupts which set HSRR registers, as well as SRESET and MCE and
  * syscall when invoked with "sc 1" switch to MSR[HV]=1 (HVMODE) to be taken,
@@ -238,13 +237,8 @@ do_define_int n
 
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
index 000000000000..7a039ea78f15
--- /dev/null
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#include <asm/asm-offsets.h>
+#include <asm/cache.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_book3s_asm.h>
+#include <asm/ppc_asm.h>
+#include <asm/reg.h>
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
+	std	r9,HSTATE_SCRATCH2(r13)
+	lbz	r9,HSTATE_IN_GUEST(r13)
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
+	beq	kvmppc_bad_host_intr
+#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
+	cmpwi	r9,KVM_GUEST_MODE_GUEST
+	ld	r9,HSTATE_SCRATCH2(r13)
+	beq	kvmppc_interrupt_pr
+#endif
+	b	kvmppc_interrupt_hv
+#else
+	b	kvmppc_interrupt_pr
+#endif
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5e634db4809b..f976efb7e4a9 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1269,16 +1269,8 @@ kvmppc_interrupt_hv:
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
@@ -3280,6 +3272,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
  * cfar is saved in HSTATE_CFAR(r13)
  * ppr is saved in HSTATE_PPR(r13)
  */
+.global kvmppc_bad_host_intr
 kvmppc_bad_host_intr:
 	/*
 	 * Switch to the emergency stack, but start half-way down in
-- 
2.23.0

