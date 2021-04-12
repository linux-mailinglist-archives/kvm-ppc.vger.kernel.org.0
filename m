Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1312E35BB47
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 09:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhDLHvs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbhDLHvp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 03:51:45 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F852C06138D
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c17so8674764pfn.6
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RrAQ9t5aU19C916t2HbMQEBrsf8uUvVy6k1sAk+QuI=;
        b=APVhvbt3Sa+eKdtdz6f0NE0hJSZKhTpyn2mZe3QMXjysaikDuDXFhdgzGEazRhDdmy
         66T5X1PXv/NYUP9Ll1KDJPhp3HFOYb0d+GStD87mrpTLNp0QH+L2yFHFubYpNwfxqF1k
         yAvNn73L4y8x/YrsS4lYxN7yu9lIsVsx8NPmdmpzQGJQAg2ZgJfOrqOOnzfBuGdUVrb2
         dU65ZI76Swy7Fd3q2/waM6ncTuJys04GuYsnMdIJnRIj9TqVSqKao/2nGV5TAqym0ll/
         PF6Vamw6AViEfkRgTnjLUBfyY0gLTTx7vCV8fLONjRyBa7SkHTLAYWW2dJLjcfpezAkF
         Kb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RrAQ9t5aU19C916t2HbMQEBrsf8uUvVy6k1sAk+QuI=;
        b=HaufG+rHSFiuHajzb7mJXCIA3SU8GeeKExanwU7kV9LyJyX9iMpQcXIrxPUZrN/Lsn
         bsVQZej2V2p/6glWlvYPU3LX9PQJb0/HjjxB9sirxuslwSGhE7sXdtX397EKiWN349x3
         0RYi99urr5VKaQgJev2uWPXAoV/iVcSZ6LGjSx0qC5+7j/kF9pLRp/43WDjSJIXT8i/a
         e1kQmZDo9DcEv2IyX8XSD7qyTT085L3o6+OtashjeqUpops5dhBtP+Mh87YO66kyvnvn
         r0tQTc490eUfFIe8Xy/kfrpRWnj9pIedY8Cz2q8DfBJJmFiwYwUN7hQESqvBKEuy1CCK
         grTw==
X-Gm-Message-State: AOAM533iYtumTrCWHVL/Vj23SyCA2VLipMU+4O5kaKHeek7D96KPkJeT
        gklny4OeUiPitbFAXNJSMfOuP9L3kbY=
X-Google-Smtp-Source: ABdhPJx7dYhU+LiD5Fs/mU+wOO1UeEYeck4wSVCTaPq29Ol/UpjScX7BPvN1V4SdTyBvypmzVDaHig==
X-Received: by 2002:a65:47ca:: with SMTP id f10mr25899817pgs.206.1618213887902;
        Mon, 12 Apr 2021 00:51:27 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id i18sm606180pfq.168.2021.04.12.00.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 00:51:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1 7/7] KVM: PPC: Book3S 64: Minimise hcall handler calling convention differences
Date:   Mon, 12 Apr 2021 17:51:03 +1000
Message-Id: <20210412075103.1533302-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412075103.1533302-1-npiggin@gmail.com>
References: <20210412075103.1533302-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This sets up the same calling convention from interrupt entry to
KVM interrupt handler for system calls as exists for other interrupt
types.

This is a better API, it uses a save area rather than SPR, and it has
more registers free to use. Using a single common API helps maintain
it, and it becomes easier to use in C in a later patch.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 21 +++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 61 ++++++++++++----------------
 2 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index cd1731642b12..24c54b6fb3d7 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1892,8 +1892,27 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 TRAMP_REAL_BEGIN(kvm_hcall)
+	std	r9,PACA_EXGEN+EX_R9(r13)
+	std	r11,PACA_EXGEN+EX_R11(r13)
+	std	r12,PACA_EXGEN+EX_R12(r13)
+	mfcr	r9
 	mfctr	r10
-	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
+	std	r10,PACA_EXGEN+EX_R13(r13)
+	li	r10,0
+	std	r10,PACA_EXGEN+EX_CFAR(r13)
+	std	r10,PACA_EXGEN+EX_CTR(r13)
+	 /*
+	  * Save the PPR (on systems that support it) before changing to
+	  * HMT_MEDIUM. That allows the KVM code to save that value into the
+	  * guest state (it is the guest's PPR value).
+	  */
+BEGIN_FTR_SECTION
+	mfspr	r10,SPRN_PPR
+	std	r10,PACA_EXGEN+EX_PPR(r13)
+END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
+
+	HMT_MEDIUM
+
 #ifdef CONFIG_RELOCATABLE
 	/*
 	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 66170ea85bc2..a01046202eef 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -11,40 +11,30 @@
  * These are branched to from interrupt handlers in exception-64s.S which set
  * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
  */
+
+/*
+ * This is a hcall, so register convention is as
+ * Documentation/powerpc/papr_hcalls.rst.
+ *
+ * This may also be a syscall from PR-KVM userspace that is to be
+ * reflected to the PR guest kernel, so registers may be set up for
+ * a system call rather than hcall. We don't currently clobber
+ * anything here, but the 0xc00 handler has already clobbered CTR
+ * and CR0, so PR-KVM can not support a guest kernel that preserves
+ * those registers across its system calls.
+ *
+ * The state of registers is as kvmppc_interrupt, except CFAR is not
+ * saved, R13 is not in SCRATCH0, and R10 does not contain the trap.
+ */
 .global	kvmppc_hcall
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
-	/*
-	 * This is a hcall, so register convention is as
-	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
-	 * R13		= PACA
-	 * guest R13 saved in SPRN_SCRATCH0
-	 * R10		= free
-	 * guest r10 saved in PACA_EXGEN
-	 *
-	 * This may also be a syscall from PR-KVM userspace that is to be
-	 * reflected to the PR guest kernel, so registers may be set up for
-	 * a system call rather than hcall. We don't currently clobber
-	 * anything here, but the 0xc00 handler has already clobbered CTR
-	 * and CR0, so PR-KVM can not support a guest kernel that preserves
-	 * those registers across its system calls.
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
-	mfcr	r10
-	std	r12,HSTATE_SCRATCH0(r13)
-	sldi	r12,r10,32
-	ori	r12,r12,0xc00
-	ld	r10,PACA_EXGEN+EX_R10(r13)
-	b	do_kvm_interrupt
+	ld	r10,PACA_EXGEN+EX_R13(r13)
+	SET_SCRATCH0(r10)
+	li	r10,0xc00
+	/* Now we look like kvmppc_interrupt */
+	li	r11,PACA_EXGEN
+	b	.Lgot_save_area
 
 /*
  * KVM interrupt entry occurs after GEN_INT_ENTRY runs, and follows that
@@ -67,12 +57,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 kvmppc_interrupt:
 	li	r11,PACA_EXGEN
 	cmpdi	r10,0x200
-	bgt+	1f
+	bgt+	.Lgot_save_area
 	li	r11,PACA_EXMC
-	beq	1f
+	beq	.Lgot_save_area
 	li	r11,PACA_EXNMI
-1:	add	r11,r11,r13
-
+.Lgot_save_area:
+	add	r11,r11,r13
 BEGIN_FTR_SECTION
 	ld	r12,EX_CFAR(r11)
 	std	r12,HSTATE_CFAR(r13)
@@ -91,7 +81,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

