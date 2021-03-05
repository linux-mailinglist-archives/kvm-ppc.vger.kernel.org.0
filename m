Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278FD32EDCF
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhCEPHn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhCEPHk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:40 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C797C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:40 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a24so1531766plm.11
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i/yeewQhUiQ0T9DZyWQBsO7hcNFmoeIz9mIQyOpJdyo=;
        b=OblvNJWGB/+QmLCjtBoDShlmF5hvoygSxnXHdt4P2rxUdFthjbgLZn8roIr9xZwkOj
         DlEy1bADz78pXMnX2hpIGywZiIy6BrTJJMr4VI5qIQErtJnzeRLTTekScKkmw64n5WZd
         a6sQs/vWVMKSbivzStmpJ7LK24HNCttVR7zG74EqcGt75VGJpnEpwRIuGGpnb/JTD1O9
         KvqauVnB6GKr71jkV4g39PK9dFqO5V9gvl5J5dDGJKnsPlJn9TiAgRDeuaYbpx62jJU4
         Zt8whC3+8I1UBDiQ1kyatSOG0rTQyypaQOXLk0e9ekNoxNmBXSTo6aZ9FhcNvnH6F4GO
         5sHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i/yeewQhUiQ0T9DZyWQBsO7hcNFmoeIz9mIQyOpJdyo=;
        b=IA1iP/igHp6a3QRgvYvzP+4BUoIUIMpFIiGee2m9OZSmx2wDm3QjpTIivv0Ltq6hgn
         WesJrMde4T1PW6cdFJ8jI6BmoIWtv9WuN/tQnEdlsIjM1U0AWJSyyxCr/NTtDe8b7cnY
         OFUS7H2KJXBuVRX3rZGfNIkH+ULOOoTlj+Hbwh0dENugORtJl3QnFUYxGNp5OLckPyBU
         sv4JSUsWlkOkoP8rAofe4mkULMX5ANVlEQVCMNkX9IP+913+2YjHxT10+Fq6eOAqpUuj
         KdLQvIsVdvDGTV5EQQSi+kLPbU8xVXgBo9iGotKMIJ/e1AYZvXf5bOP08xsq6jcMDIk6
         jq3Q==
X-Gm-Message-State: AOAM531CaBrk6A4IJVP9L6F2sNr8fLnqAuBROvEaA0q98nHJ552zv0d6
        A0FoStQ20TH2yxKfXlLMe8YCsG4rUfY=
X-Google-Smtp-Source: ABdhPJxzSW201g1TvhETvb9hl2LO8/RZbae5DQpoF7xecuB+GicFzQFFcu5r59jyxTOZQM83PAkv1w==
X-Received: by 2002:a17:90a:e7cd:: with SMTP id kb13mr10615428pjb.10.1614956859630;
        Fri, 05 Mar 2021 07:07:39 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:39 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 15/41] KVM: PPC: Book3S 64: Minimise hcall handler calling convention differences
Date:   Sat,  6 Mar 2021 01:06:12 +1000
Message-Id: <20210305150638.2675513-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index b4eab5084964..ce6f5f863d3d 100644
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
index 7a6b060ceed8..129d3f81800e 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -14,24 +14,9 @@
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
@@ -62,7 +47,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ld	r10,EX_R10(r11)
 	ld	r11,EX_R11(r11)
 
-do_kvm_interrupt:
 	/*
 	 * Hcalls and other interrupts come here after normalising register
 	 * contents and save locations:
-- 
2.23.0

