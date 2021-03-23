Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5B34547D
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhCWBET (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhCWBEP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:15 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA28C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x26so12513299pfn.0
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JAFMIe0yYAzJxMahTUIpwR/Z3qkqPJ3NyE7gYKKG1lM=;
        b=SqjRpG/LV5qxZO0/uQ9B0O/oX8S/biUOnkAYQJo8Hklmi2HiMSJZ9sk1N3JwUly4Iq
         nS8sPVbJdZIOPtBaHjbinklJ9rx5dBHKGmIM7rJyg8IMUiFizB+mOSOe81T1J7H2eTAw
         3+8faNQok0aaacPNtpvpynDEDe0fbQZHU+RfFlRuilmKGPkPQNukZLmfbEWotZTrY9+z
         dsQ7f6kV0JAUYNquaymDbf7gAc2ZMrdIucAURvdEclsygDlooC0xFU1L7ZepMNixNJNy
         kf9eg99w3INSdyB3hIuvkvJkCN9hh8ki5H0TK6+f3qOVE3OnXPZ0HRc+EGMkGPrrMLDb
         vzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JAFMIe0yYAzJxMahTUIpwR/Z3qkqPJ3NyE7gYKKG1lM=;
        b=lErBMkDHn7K9piPUFiknbUyUldm0L/szKhwvDZuAR5fPIfL/DQkTTwZmOiu9XTuC8Q
         Pd7OP0P7DTLI4v1q0s7CPhZxg8zj3Wj/gPasPhF6yS43SwWKjJKgSpv1uNye3rOWMv7s
         hdr0allcpuVP1WpwwIVqXO5KtV/OkF5dMtguTYMDjHbmMwrJ93PWwyZ5njF8NU6T5v71
         tiiHXzUTcGuHoN4uhDHvfpWq8fbNppNquQtT605u5dZATk+T6VLEZLDH3JMt6qBWzpNe
         CO+l6+JbCjiK+00waVFlTK38n5J3cAB16jf8OIQqg7Z7YhWCZnbkoAoRff9q09KWjEm4
         7eZA==
X-Gm-Message-State: AOAM531Vd+BhriAltJyMTsV2tApxAGcETNBhyqkI6GcFInWW16q1MhJE
        GCQVgizRMQYRgV9G3UpJsc3SMvUnCHM=
X-Google-Smtp-Source: ABdhPJxQtY3Qu8F6RhkcuFbetWI7b6b/giOuOx5PBgVAxD0hA4IXugK6JAgKWZGM1yxMWasEmirY0w==
X-Received: by 2002:a17:903:4112:b029:e5:f79d:3eb1 with SMTP id r18-20020a1709034112b02900e5f79d3eb1mr2303702pld.48.1616461454131;
        Mon, 22 Mar 2021 18:04:14 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 18/46] KVM: PPC: Book3S 64: Minimise hcall handler calling convention differences
Date:   Tue, 23 Mar 2021 11:02:37 +1000
Message-Id: <20210323010305.1045293-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
 arch/powerpc/kernel/exceptions-64s.S | 21 +++++++++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 37 +++++++++-------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

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
index b6149df21de3..de81ab69555b 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -11,33 +11,21 @@
  * These are branched to from interrupt handlers in exception-64s.S which set
  * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
  */
+
+/*
+ * This is a hcall, so guest register call convention is as
+ * Documentation/powerpc/papr_hcalls.rst.
+ *
+ * The state of registers is as below, except CFAR is not saved, R13 is not
+ * in SCRATCH0, and R10 does not contain the trap.
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
@@ -84,7 +72,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

