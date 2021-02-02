Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B3030B599
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBBDE5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhBBDEz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:55 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD96C06178C
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:45 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so13966670pga.2
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4BVMs1eI4ftVoSL+zUWabpiVvkWT9oHnIuTQaI+hCtQ=;
        b=QtHkEhU7O7wVhrxoiCNhEOoC8Gwhh4xDnIiufAU/Jb72B4OfoxFnHi0jVdzokikKmW
         aGvnjPy49j3eQLgwCyqWXQieQ9MI7pLYEa98DEREzEWJInqtkCQY1SlMgg1nMnaiXEnU
         k4XinTG1Qp296sxkNFGKEt56ynamIz286baVgf/ZhsoX9+DtO0RjyqHRgogSPNHJGSwl
         THfnKEptdIOJexcRTkFodEnmKp3eUhpjbAkCb68r8EcryzmVP2CV+yZcahM036kpnEkL
         beZs1ss4qkUG/zFte5304WRjftJIfu+8srOhuYI/iAUL3YMKOWJzKxEG+HMr9ZnrWCNg
         X2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4BVMs1eI4ftVoSL+zUWabpiVvkWT9oHnIuTQaI+hCtQ=;
        b=cpLeyE0D4iedfRCmELXtaNGR0lRU9cxAAHCg3UDbBNQi8ZPnVBv6smXGAhHmWggRwQ
         5IYG4wM6o731ZsSM+4w90Ufcx+M/YniOkIIzfD7L6eyCcnYioR0UcdeZQO1pAonXgvGD
         gKAgDWLtTusNIgU8ibJqKdjnITN13i1p0elblASvzo4r/yMOsq8j1vqV0dWTCF9T0TTp
         2ktJX2WKflT7/XzK6YFV7p0H9S7c9+eDF9ekbR22FpaQBBUIqnyyAcyNDY3iFaDPxL0R
         nyOefPG1XPZ8ow+eurSBmdJlpXqP5Tp7U8Uwd4M48Oes6ZiK7X+UzGWJhqW0eE2JKSAw
         8XAg==
X-Gm-Message-State: AOAM531lSbEIlBN86fDBnPMCQ2AzAbUERLRK5RxgMxzUIX0W+1VZFKal
        Y8CD3aDVvFgamOZoJcs8knqpliXlSWY=
X-Google-Smtp-Source: ABdhPJx/DlMu/4wAMZY8C9aMWnzLHQaYGm9MJb5STjougpD298+ZD0uUU71SCjKWiJer61zGLPMS0Q==
X-Received: by 2002:a05:6a00:a8f:b029:1bd:bb89:5911 with SMTP id b15-20020a056a000a8fb02901bdbb895911mr19069196pfl.42.1612235025069;
        Mon, 01 Feb 2021 19:03:45 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:44 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 8/9] KVM: PPC: Book3S HV: Minimise hcall handler calling convention differences
Date:   Tue,  2 Feb 2021 13:03:12 +1000
Message-Id: <20210202030313.3509446-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 16 +++++++++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 22 +++-------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index bed4499488b3..0844558f1d7c 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1923,8 +1923,22 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
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
index 0d9e1e55c24d..0e39267aef63 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -9,24 +9,9 @@
 .global	kvmppc_hcall
 .balign IFETCH_ALIGN_BYTES
 kvmppc_hcall:
-	/*
-	 * This is a hcall, so register convention is as
-	 * Documentation/powerpc/papr_hcalls.rst, with these additions:
-	 * R13		= PACA
-	 * guest R13 saved in SPRN_SCRATCH0
-	 * R10		= free
-	 */
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
 
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
@@ -57,7 +42,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

