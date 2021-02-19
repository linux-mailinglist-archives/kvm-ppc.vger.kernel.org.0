Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00FA31F529
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhBSGhP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhBSGhO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECC0C061794
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:14 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id g20so2831651plo.2
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tm1JSLSwhGSe4s4EFLvsM1CkmkzCV1wQG3+ZCo+peeA=;
        b=uiRsnAAMfXhU2Ejd41yqOiaimlwItidJ4fG1EGD4fDomqEU6qJEya5iu7f4H/eq8cA
         SbEPMuSms1tX6HrWs9SSaU3NAroU7gQAp6k6byDXGbqN43bxGHXrzvijSnP5tt+9vqfk
         RxjVDMU4uch2a+9BkvpUNHODFxjIi5Sff4ZM8Jjpxfm8GarQj7L829JfOXO8es9tY/xU
         4slYEQtJslEyVFqN1aVWJD2fMRYZCj6guv2vS9EJc1DjTxDHT6IdKOYehW6PIlct9arW
         2ZailIr95gsvgqbRREYWbyz3bodQKImN867JJj7HyZP6sNClFQDxdLZT7FCFugFGxmS4
         glqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tm1JSLSwhGSe4s4EFLvsM1CkmkzCV1wQG3+ZCo+peeA=;
        b=VfrJnyU4H7CxGrbCAvlYFStShixgLOYHKVXpeUiq0xIKaIPubjEFfNxZDNdAym6gph
         awNmsaHcm6VQm66li1am30TmYoCOIoFcqbuMLWnY9YUP7Wjv38kQ1onvnZ9KOM4UMjlv
         cZodR0YAzuMBFgfuyGzCL/2Y8jcBgiOKlmrAFoueUcO5Wr9ExhkZoV0jSEKAmYL8/6CI
         ab6oewuFWWPS8rk/FA3hlAEAfDeDvwXJS+zBt1P8cUvrRfnKi+cjBZit3r9kDdigQmCD
         mqBL6XH5JflfHraMTVp/8VOnhNjbMjXWlzLOClttoKX4DkhthUplWd4JW7YZk3VC81vQ
         dXuA==
X-Gm-Message-State: AOAM533LFau2m28a9xBJTLPU+IPRlUpxKEPN1z2rZq2MElwUHaNeDCHC
        wRMCW8kxXNT4OEcCM1pQ5ITFZWjD6yM=
X-Google-Smtp-Source: ABdhPJx+2cgB1owDliVX1zZi2r+195kLFdFJeyqClHyl0jOnC2BsG9KxyjeJdFWVM/lZnWFW1K/pwg==
X-Received: by 2002:a17:90a:df93:: with SMTP id p19mr7592916pjv.130.1613716573269;
        Thu, 18 Feb 2021 22:36:13 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:12 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 08/13] KVM: PPC: Book3S HV: Move hcall early register setup to KVM
Date:   Fri, 19 Feb 2021 16:35:37 +1000
Message-Id: <20210219063542.1425130-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
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
index a61a45704925..6872f0376003 100644
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
@@ -1995,45 +1979,21 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
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
index 53addbbe7b1a..7050197cd359 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -13,6 +13,23 @@
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

