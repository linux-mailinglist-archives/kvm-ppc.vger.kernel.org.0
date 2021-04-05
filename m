Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8001C353A95
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhDEBVE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhDEBVD (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:03 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B1EC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:57 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x26so465121pfn.0
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=br9KsSPqAYwn2ChgsOdZxU/P/wvzrThXCx6ps2GjyIQ=;
        b=XlpZ+f26ijm5QlRP/XaP9w28migRZBSvTlRhklIMXIA/1xbiIiVZyjkmIW5KnqYWn6
         61K5xN3hbUeSv4ILa9tHiQtxNaRo5Z7Zxr148EcPdSlT8GVmyIJ53g6plSY3sf1DV+xM
         KMX1ipJHs9ASxMdzf+/VsQB7oGartO0CZB/nLcTzkAJAQtErvF0VhcUzHUxGTfQ0pPXk
         zSe/He7O8Z7xiCyDCrm6PNWRav9bn6H9Wl4HGVUFSCpvirl0/H0zYmRpNAXe37eiEGNT
         4On7KPueRKg35vfHa6JTqHY1jMtPBoJcMfAM2rPvyvX88J73q9ERp6MfJ3FlCtbHcA1j
         dOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=br9KsSPqAYwn2ChgsOdZxU/P/wvzrThXCx6ps2GjyIQ=;
        b=WSW7RevxX+mqTcLf/BvAxBK9+tlarymBq5uB7wBPSRY2y/hZzyPpp2E9gDLQPpUBa9
         zlSTnnIVpaJm1D7EbzsYwNRb7PkUVuTufOOBqzB1FcgvgHIu1AvSJBUFd/RInySO5ZRo
         fYcO5S9lpjUgFSYzyEcyBtGl3PrtTvYLIpn2PjZ9+5yUfK36AePZ4AxCE24xX15dd/kM
         1bnFdcMnuoabox/7cc7/hQOwabrtH9gAe525GHU9v/E9jxx9JUbKLCAmlOps4Vnltfa9
         s+Y+Q4SIvXjPLe+PyE6hWuAwY5RdnzgDhD8L+49yS5RaHRZNdghiLROGJrcnh8xDTGEp
         974A==
X-Gm-Message-State: AOAM533xHjq+tCtpJoGkNn6OcjKxXVlFmpyHUgGYjWJgVj/Hgaww6bey
        kYxQE9g6ilUcrLIXhDqbCzUugLvbUlh2Cw==
X-Google-Smtp-Source: ABdhPJwzNh485AOCMuE40Zaj15xORArf8KbiAhxqGToIMroIvkxSk2Bm8poytBRn4liBEE98JuihRQ==
X-Received: by 2002:a63:1820:: with SMTP id y32mr20950285pgl.157.1617585656491;
        Sun, 04 Apr 2021 18:20:56 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 15/48] KVM: PPC: Book3S 64: Move hcall early register setup to KVM
Date:   Mon,  5 Apr 2021 11:19:15 +1000
Message-Id: <20210405011948.675354-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index 98bf73df0f57..a23feaa445b5 100644
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
@@ -1964,29 +1948,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
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
@@ -1994,15 +1957,12 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
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

