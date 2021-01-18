Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201632F99E8
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 07:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731070AbhARG3Q (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 01:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732359AbhARG3D (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 01:29:03 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4713BC061575
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id i7so10313715pgc.8
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXaTZ2SGwG1cE+iI7Sy2bmCo1yKmf961EI27ucblZh4=;
        b=IRKw4e4tDWXh4pqfVmo2G+R5JjX3xazmyrDoBVbDdHEbGeldFpI2xg2YNmNqwUyYom
         NqETqxRjqnwAWsuigKOtbe8tSI0xcf5UqWYQ9/qhppex3FZqU7WoYCjDxMJnBvQBZRF8
         N9eW8gcIvcJoltTkfxxCHN7P6FOVihuE422dzhyrbnyqwpUB9CTB0T1UZCRWMZhqerkd
         24xSeT1evxNOhhvtlXPil17n11Qtj9b3NPSMYVXF4MYkWkoUSw9/dCJOZ/IlPWdqFMFD
         Lr4HTI1hExSlwZTxJw+qbfMk5R6IFu9AVOQgsuhSjCvyvDYfDTO68QIZzv0IbpmaaWLs
         qi9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXaTZ2SGwG1cE+iI7Sy2bmCo1yKmf961EI27ucblZh4=;
        b=fEX2H5edbzEwApKS3+3oL2adHi769agPEFmnqoFob38ULjqv4fZNo6yY2nJ0NRmwHQ
         90iUj+7O7N8lV6ioiu3e/9WRKSyyHP9UaEH65BbXzRwGh8veLuihNUfYIc5ZFZM/gXua
         pU1CGQ6+pU6v+/2/gyc9xeqQYoXBaEIYZk27K6SDdtQE6yg3wl16Q+OljLG+PAhWkVcg
         x/IzPHPfMFzkLJm018C0owSACuhYIMzERAW3n++JZewdJdelA9qw9GKxtSJ8Yalb+/Zn
         yGNNzlISCmgxokAEfLN/SECDJcyluaJ9mL5OVMweNijCeybSnW3mYPpjUot/lBc4f6v6
         LC5g==
X-Gm-Message-State: AOAM531an4VeU1ZnYJFji4346g5fEz2piZckoccPGI8hLLgsOn2I8TpY
        CkcCiGFrROUyYhLGeZn1IKd0B0KwYU0=
X-Google-Smtp-Source: ABdhPJxGh8qEA/O08tQng/lZyfyoQ2G9xC5NxXCawABM83Yk/uUVzwuGbsUqRmfVExHJdCxnAG803w==
X-Received: by 2002:a63:e24a:: with SMTP id y10mr9851779pgj.413.1610951301726;
        Sun, 17 Jan 2021 22:28:21 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id w25sm8502318pfg.103.2021.01.17.22.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:28:21 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/4] KVM: PPC: Book3S HV: Fix radix guest SLB side channel
Date:   Mon, 18 Jan 2021 16:28:07 +1000
Message-Id: <20210118062809.1430920-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210118062809.1430920-1-npiggin@gmail.com>
References: <20210118062809.1430920-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The slbmte instruction is legal in radix mode, including radix guest
mode. This means radix guests can load the SLB with arbitrary data.

KVM host does not clear the SLB when exiting a guest if it was a
radix guest, which would allow a rogue radix guest to use the SLB as
a side channel to communicate with other guests.

Fix this by ensuring the SLB is cleared when coming out of a radix
guest. Only the first 4 entries are a concern, because radix guests
always run with LPCR[UPRT]=1, which limits the reach of slbmte. slbia
is not used (except in a non-performance-critical path) because it
can clear cached translations.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 39 ++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index d5a9b57ec129..0e1f5bf168a1 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1157,6 +1157,20 @@ EXPORT_SYMBOL_GPL(__kvmhv_vcpu_entry_p9)
 	mr	r4, r3
 	b	fast_guest_entry_c
 guest_exit_short_path:
+	/*
+	 * Malicious or buggy radix guests may have inserted SLB entries
+	 * (only 0..3 because radix always runs with UPRT=1), so these must
+	 * be cleared here to avoid side-channels. slbmte is used rather
+	 * than slbia, as it won't clear cached translations.
+	 */
+	li	r0,0
+	slbmte	r0,r0
+	li	r4,1
+	slbmte	r0,r4
+	li	r4,2
+	slbmte	r0,r4
+	li	r4,3
+	slbmte	r0,r4
 
 	li	r0, KVM_GUEST_MODE_NONE
 	stb	r0, HSTATE_IN_GUEST(r13)
@@ -1469,7 +1483,7 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	lbz	r0, KVM_RADIX(r5)
 	li	r5, 0
 	cmpwi	r0, 0
-	bne	3f			/* for radix, save 0 entries */
+	bne	0f			/* for radix, save 0 entries */
 	lwz	r0,VCPU_SLB_NR(r9)	/* number of entries in SLB */
 	mtctr	r0
 	li	r6,0
@@ -1490,12 +1504,9 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	slbmte	r0,r0
 	slbia
 	ptesync
-3:	stw	r5,VCPU_SLB_MAX(r9)
+	stw	r5,VCPU_SLB_MAX(r9)
 
 	/* load host SLB entries */
-BEGIN_MMU_FTR_SECTION
-	b	0f
-END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 	ld	r8,PACA_SLBSHADOWPTR(r13)
 
 	.rept	SLB_NUM_BOLTED
@@ -1508,7 +1519,17 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 	slbmte	r6,r5
 1:	addi	r8,r8,16
 	.endr
-0:
+	b	guest_bypass
+
+0:	/* Sanitise radix guest SLB, see guest_exit_short_path comment. */
+	li	r0,0
+	slbmte	r0,r0
+	li	r4,1
+	slbmte	r0,r4
+	li	r4,2
+	slbmte	r0,r4
+	li	r4,3
+	slbmte	r0,r4
 
 guest_bypass:
 	stw	r12, STACK_SLOT_TRAP(r1)
@@ -3302,12 +3323,14 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 	mtspr	SPRN_CIABR, r0
 	mtspr	SPRN_DAWRX0, r0
 
+	/* Clear hash and radix guest SLB, see guest_exit_short_path comment. */
+	slbmte	r0, r0
+	slbia
+
 BEGIN_MMU_FTR_SECTION
 	b	4f
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 
-	slbmte	r0, r0
-	slbia
 	ptesync
 	ld	r8, PACA_SLBSHADOWPTR(r13)
 	.rept	SLB_NUM_BOLTED
-- 
2.23.0

