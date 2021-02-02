Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB030B59D
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhBBDEZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhBBDEQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:16 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7050C0613ED
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gx20so1454625pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZsZUb1tipuGJLFc8CXbHJcSzf07LaotriP4425D9e2E=;
        b=JKUYvKnL1DiLUNxaDR6EVJEAk16ZjH/Zy5lGbuLiTn43wePE/qzhk77hDTbSS8XjUy
         MrA6DTLQJj8qjoCHi0u3KWk8ZcP450Mj7+e+cF8SOidsJXkMI/8OY2Dd9/y2qhZl3qQp
         zn1EiR/Q2IosYl1rqRP15E8Qo1AhfbMGwSNirj0ZhPji0lyI1rYoI1geTzhbzKQ7y3O3
         qXqZOYmy8ai4V6wykRvoe3/nSn6PSDA5GVfd7F94fY+3/BwGiXNfCYa6c8W3hu6B2euj
         GHUymrR0GMh7EB5xj+5HuZjWc/FzDI7Oh1ZAQfvfJxxMtinZF3VfO8DcsOGI3Jv++a+p
         mbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZsZUb1tipuGJLFc8CXbHJcSzf07LaotriP4425D9e2E=;
        b=J45cYbfEk9MN7ggsbo9+KBpCePvP+ceeZ5mv39mlK41LF6e/TTcrKwtCUwBtWI9sIK
         Xl5FI1d5WK9Aidv+ixCgm90ltDNR2ofOb5+i49UgLFcfUxmQG7kD2ubzq65wlZV289yF
         z7k7eFJI3+ny1SOELhvFZUTvUxGRyWAV75YqZ2yNWZKdi4hfhiNrrRTfNHAybLmBsnfM
         Wysbv8B3TMcjyN+W2ZqJyFhnnzv9HlD5rirh17VRuTy584qfgZWPHzS5qqIX4SlXM4hd
         IZs+G/t1REF9tYtXbgjSfvduLrjobZKuC9EE3oKRgSSnQdcsq0JsZJBwdBg+F+Du4O6p
         +pFw==
X-Gm-Message-State: AOAM532jsBLMDdzMt29pqNv/VvRh+pJ7bEPolLcwpZZUFXox+lTkdL17
        on1/ziZl51nkuQtcjJCx5voW4uTWcbk=
X-Google-Smtp-Source: ABdhPJz4LZc5Z8biiwhdj9rgXKWOg0KiAh2ae+TxSh5T1rvEysYFRoDcn1lIMxGzOzq9ysl+E7VOZw==
X-Received: by 2002:a17:903:22c2:b029:dd:f952:e341 with SMTP id y2-20020a17090322c2b02900ddf952e341mr20155558plg.67.1612235015263;
        Mon, 01 Feb 2021 19:03:35 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:34 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 4/9] KVM: PPC: Book3S HV: Move hcall early register setup to KVM
Date:   Tue,  2 Feb 2021 13:03:08 +1000
Message-Id: <20210202030313.3509446-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
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

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/exception-64s.h | 13 +++++++
 arch/powerpc/kernel/exceptions-64s.S     | 44 ++----------------------
 arch/powerpc/kvm/book3s_64_entry.S       | 17 +++++++++
 3 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 1d32b174ab6a..7e5168b83155 100644
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
index c25395b5921a..e964ea5149e8 100644
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
@@ -2000,45 +1984,21 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
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
-	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
+	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
 	 * outside the head section.
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
index 3b894b90862f..df074d33f6d7 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -12,6 +12,23 @@
 .global	kvmppc_hcall
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
+	/*
+	 * This is a hcall, so register convention is as
+	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
+	 * R13		= PACA
+	 * guest R13 saved in SPRN_SCRATCH0
+	 * R10		= free
+	 */
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

