Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFD3250C2
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhBYNsj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhBYNsg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:36 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A28C0617A9
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:46 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e9so867514pjs.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KauVfKK9v1PaXpgGlh5JvIFa1U0JoxcWq/+O2Lu+hJo=;
        b=kb3bUEGXfY0FtDkkBhOm7FxpBiB6LA3hXoDpBRNvQtSHgqdsqOPKnGJNb+h8i+W2kD
         jBvQOUt4nMvg9L6Opxa49XpQRqHPpZaaelv1uVGcbPWkAjon7gcGXDb+XAx33i1WvGT4
         1rzuPh3WYDWF/YumOqdY+dlH9WCPTDeLhqrX6e6JCjKam0TS6d+WpadaUpz9Vmb9jtRH
         UUUIzipFNl6u8OjfpLcYZUBmFqgKjh9QwPCHWpkBxTJ3tF7+HYult0YpRaXJojWuHFYR
         nt7vtHx8X8R0IiWd6pM3M1wIBt87yhdYIrQLRO1L+AFCzDOm9BRhfYo9ScQ5dehdCrCb
         mFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KauVfKK9v1PaXpgGlh5JvIFa1U0JoxcWq/+O2Lu+hJo=;
        b=EGoaSvdvLCffuRDJkI7/CXJ9YoDJjxL17OSYmk82BfYab8aYO4UNFQW+7K42QP2llM
         jAcbzwIUzkAXoEeygLIMp0Zth+N1JEqN0+FmpLEgN7TArBKTDznjvJtMOnjep3F77xnN
         X/Z1D06rxe+l9GCYUb6gs7mJMN1uUCNnWUgbvsqoJG24+FaTzZmwlJxbtlMqyLGQ/5lK
         81LdHV4aBeXiDjZStxZ73Hw2eoo4Snv349qotVR/i++QuNytdFOYdTtMSa8/I5QNaFU6
         vpLP7r25rZt3Tk4cF74T338emKRKEuOfW3o57RMpqUFKS2ODypJJ8UuxWKfanSH99Mtd
         YeGw==
X-Gm-Message-State: AOAM530HdZE7zw+Y5J8eYhgliNO47tWZkkYbgagqx/HMqfuyabtonIcd
        FNEnGJl9qgheq41mvBdkJ01VAukK6aM=
X-Google-Smtp-Source: ABdhPJw2SWurXvHLMFh8Yl6Ug+xl7KifH4v7V10LgKHzNwmgS8UAexzi5tmBK9eQ9ZhWhO8GE2nX0A==
X-Received: by 2002:a17:90a:be16:: with SMTP id a22mr3561956pjs.32.1614260865303;
        Thu, 25 Feb 2021 05:47:45 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:44 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 12/37] KVM: PPC: Book3S 64: Minimise hcall handler calling convention differences
Date:   Thu, 25 Feb 2021 23:46:27 +1000
Message-Id: <20210225134652.2127648-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 16 +++++++++++++++-
 arch/powerpc/kvm/book3s_64_entry.S   | 22 +++-------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index bbda628ab344..dcd71d9e7913 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1892,8 +1892,22 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
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
index 75accb1321c9..f826c8dc2e19 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -13,24 +13,9 @@
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
@@ -61,7 +46,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

