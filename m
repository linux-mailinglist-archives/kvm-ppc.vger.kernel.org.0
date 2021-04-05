Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A85353A99
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhDEBVO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhDEBVN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49C5C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d8so4916171plh.11
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q/vrWSy5tKpNMm8JT9TVnUYhWIiLWI9uewuCHeVdsyY=;
        b=WV2XthWuPT9/cftO4jyAQMkQfgRRC4+QEmApAQRGSesXU3VuVt/e4xmYOXe6v84Btr
         maxSA/4kVRdGsRMnVDPixsG5K+KXrKYCqDUJ2GdwYd3Z56k5878Pidppxt13AYwKN7uk
         y7MkatCBilm0cVILibFBZdISeY4OSg8B38kNqLIiBXb84h0O8553BPiwYS26nBc5m9aI
         fUfwis/RNEjbwq1+pDp/DP4C90Co8+U3IjeiRioDAswcSXE3J26fxsGbe1fVFlKJDM+q
         SM9538Fn+iGoRnPbdu5OxBHWo53ODqUyYwlMvRgtFQHpjHN3vkaKU3cknG36XwZ3NI2o
         JChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q/vrWSy5tKpNMm8JT9TVnUYhWIiLWI9uewuCHeVdsyY=;
        b=aVazUsimR3CZDyKolAMo/1gmyxUiSHyP2Xhgs7k9U5+MSmj8ZtJbpSkJzVTHzQP0mS
         MGfqSmdR2g8nba2Gc2mmIdcXdYj//BVII4HCiD2AFIf4tJtZO8oFObuapmIFynV87QH3
         lyW+/TSBfICNelkyN4QS+QzB0WhFixEih2J5Z3emOc5jt91EEFATUidf0avPSFMjHRB4
         u6A9x5NiDsa0Q046G0fOHPGlxNsOAm7OWfd1hNlI9p23mw6/dYQeBhJoEEibCBhhbADK
         IQjzyLjVwRODEOHTK64/3rZ6nyi3NZEqKOqRkSxJqApxYLreEpdIPCmyK++TsgtZBoCR
         XFJA==
X-Gm-Message-State: AOAM532SOOPaKQUjNDzRNyWTEBKYLvp8/LbILJnum63Dbnmm8E+1BUg+
        VvvKO5SkFcYVpkwocXUfEgzoADH/bkH47A==
X-Google-Smtp-Source: ABdhPJyYEF8rbZUxav/uIFRMoKTSByTeRmwh278CPs/pAoDCJFcyu9ZwUh5F0zUZ9zwBsi4D3r/d2Q==
X-Received: by 2002:a17:90b:1802:: with SMTP id lw2mr13771910pjb.226.1617585666126;
        Sun, 04 Apr 2021 18:21:06 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:05 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 18/48] KVM: PPC: Book3S 64: Minimise hcall handler calling convention differences
Date:   Mon,  5 Apr 2021 11:19:18 +1000
Message-Id: <20210405011948.675354-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
 arch/powerpc/kernel/exceptions-64s.S | 21 +++++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 51 +++++++++++-----------------
 2 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 115cf79f3e82..4615057681c3 100644
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
index 66170ea85bc2..0c79c89c6a4b 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -11,40 +11,28 @@
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
 
 /*
  * KVM interrupt entry occurs after GEN_INT_ENTRY runs, and follows that
@@ -91,7 +79,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

