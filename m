Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6E7393F6C
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhE1JKN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236700AbhE1JJt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:09:49 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E91C061352
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:10 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q67so2765532pfb.4
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YYpXWHagod15l1uSKaMx6/6ESzelpSM0Ld4l3vsuE4Q=;
        b=Rj+7Wo9U4/XqWosiUW94yEKWQOV3lBflIzoEV5v2zJgXAhfj3hIw6yq62lOEjKxDS0
         DZ8Yzd6SyEVDUOIvyzqt1kv/bmhhPXVPZ5u4AA4TjS1RpNcN4OUBQhUiKY1mfKHfqmMs
         91M2UTZtkSaCCW/ftGf7EIsXYPJpmAKYxN5/r5B38hBsi5ZsHm2vKPXqhkC1XylRI/Q0
         Cf5lUfQtnTG+lBbnK6WHfkw0Y74zaXp/ms9DIJAwKmyiB7cdaiJWpHElFDnY+vylYJ2k
         YMY+19hqRIAx6QJvXlj9fE5snV8Hsx5bY5exkh7ynJEUQZzlRp2dSsk81w1K/z3OzOgH
         KzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YYpXWHagod15l1uSKaMx6/6ESzelpSM0Ld4l3vsuE4Q=;
        b=XhcOJzTCHI0OVT6ZeBizHZ436rAzEMGVIAkWwFQF232yg6jZhaPjdep3S9bU7/jLHz
         GFjDtJxeYpQ/TdwtwA6mkHVeq5oSld5jRHlDhL7bAasCQsJ3ep7R1Z6VlTaj3V1IcYgc
         r4Axzl7Rz5ORDnMr6HZFjbDXFR3ZA2g7kFeQfQ9501YdOv3MewVgsBqnv/ypdsf27Ugh
         7zGtZNpz0H4OziWnyDSaquYm7+Tx4qNfVlqviKsk2veo8/vVYapW0L0z05WABR9al7Rr
         7IMGaAU8sX42uOV9V34ZZM6yBzyYlP/BzEJHvTVDgskoll+hLo0uSNtrMJoI1O8C7xGy
         TbeA==
X-Gm-Message-State: AOAM532fZAsVNWkGJaoQtNGRz5PEkGK8DphbmFDxnlsFUQrV3y09ld0h
        RxDLZUVI/DG+ETxdfJUllWt9zHvFRbY=
X-Google-Smtp-Source: ABdhPJzbD8NUWG25vP98jQpwUlJtve5kEi5aw0iT1UjXROiBE0qk1qzjGX0DKu21rBELyVN1TMw6RQ==
X-Received: by 2002:a63:5252:: with SMTP id s18mr8006312pgl.229.1622192889840;
        Fri, 28 May 2021 02:08:09 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:09 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v7 04/32] KVM: PPC: Book3S 64: Move hcall early register setup to KVM
Date:   Fri, 28 May 2021 19:07:24 +1000
Message-Id: <20210528090752.3542186-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

System calls / hcalls have a different calling convention than
other interrupts, so there is code in the KVMTEST to massage these
into the same form as other interrupt handlers.

Move this work into the KVM hcall handler. This means teaching KVM
a little more about the low level interrupt handler setup, PACA save
areas, etc., although that's not obviously worse than the current
approach of coming up with an entirely different interrupt register
/ save convention.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/exception-64s.h | 13 ++++++++
 arch/powerpc/kernel/exceptions-64s.S     | 42 +-----------------------
 arch/powerpc/kvm/book3s_64_entry.S       | 30 +++++++++++++++++
 3 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index c1a8aac01cf9..bb6f78fcf981 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -35,6 +35,19 @@
 /* PACA save area size in u64 units (exgen, exmc, etc) */
 #define EX_SIZE		10
 
+/* PACA save area offsets */
+#define EX_R9		0
+#define EX_R10		8
+#define EX_R11		16
+#define EX_R12		24
+#define EX_R13		32
+#define EX_DAR		40
+#define EX_DSISR	48
+#define EX_CCR		52
+#define EX_CFAR		56
+#define EX_PPR		64
+#define EX_CTR		72
+
 /*
  * maximum recursive depth of MCE exceptions
  */
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 4819bf60324c..03e2d65d3d3f 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -21,22 +21,6 @@
 #include <asm/feature-fixups.h>
 #include <asm/kup.h>
 
-/* PACA save area offsets (exgen, exmc, etc) */
-#define EX_R9		0
-#define EX_R10		8
-#define EX_R11		16
-#define EX_R12		24
-#define EX_R13		32
-#define EX_DAR		40
-#define EX_DSISR	48
-#define EX_CCR		52
-#define EX_CFAR		56
-#define EX_PPR		64
-#define EX_CTR		72
-.if EX_SIZE != 10
-	.error "EX_SIZE is wrong"
-.endif
-
 /*
  * Following are fixed section helper macros.
  *
@@ -1941,29 +1925,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 TRAMP_REAL_BEGIN(system_call_kvm)
-	/*
-	 * This is a hcall, so register convention is as above, with these
-	 * differences:
-	 * r13 = PACA
-	 * ctr = orig r13
-	 * orig r10 saved in PACA
-	 */
-	 /*
-	  * Save the PPR (on systems that support it) before changing to
-	  * HMT_MEDIUM. That allows the KVM code to save that value into the
-	  * guest state (it is the guest's PPR value).
-	  */
-BEGIN_FTR_SECTION
-	mfspr	r10,SPRN_PPR
-	std	r10,HSTATE_PPR(r13)
-END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
-	HMT_MEDIUM
 	mfctr	r10
-	SET_SCRATCH0(r10)
-	mfcr	r10
-	std	r12,HSTATE_SCRATCH0(r13)
-	sldi	r12,r10,32
-	ori	r12,r12,0xc00
+	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
 #ifdef CONFIG_RELOCATABLE
 	/*
 	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
@@ -1971,15 +1934,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 */
 	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
 	mtctr   r10
-	ld	r10,PACA_EXGEN+EX_R10(r13)
 	bctr
 #else
-	ld	r10,PACA_EXGEN+EX_R10(r13)
 	b       kvmppc_hcall
 #endif
 #endif
 
-
 /**
  * Interrupt 0xd00 - Trace Interrupt.
  * This is a synchronous interrupt in response to instruction step or
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index c21fa64059ef..f527e16707db 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -14,6 +14,36 @@
 .global	kvmppc_hcall
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
+	/*
+	 * This is a hcall, so register convention is as
+	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
+	 * R13		= PACA
+	 * guest R13 saved in SPRN_SCRATCH0
+	 * R10		= free
+	 * guest r10 saved in PACA_EXGEN
+	 *
+	 * This may also be a syscall from PR-KVM userspace that is to be
+	 * reflected to the PR guest kernel, so registers may be set up for
+	 * a system call rather than hcall. We don't currently clobber
+	 * anything here, but the 0xc00 handler has already clobbered CTR
+	 * and CR0, so PR-KVM can not support a guest kernel that preserves
+	 * those registers across its system calls.
+	 */
+	 /*
+	  * Save the PPR (on systems that support it) before changing to
+	  * HMT_MEDIUM. That allows the KVM code to save that value into the
+	  * guest state (it is the guest's PPR value).
+	  */
+BEGIN_FTR_SECTION
+	mfspr	r10,SPRN_PPR
+	std	r10,HSTATE_PPR(r13)
+END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
+	HMT_MEDIUM
+	mfcr	r10
+	std	r12,HSTATE_SCRATCH0(r13)
+	sldi	r12,r10,32
+	ori	r12,r12,0xc00
+	ld	r10,PACA_EXGEN+EX_R10(r13)
 
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
-- 
2.23.0

