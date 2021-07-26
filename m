Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690F3D51B6
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhGZDLH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77989C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d1so2753529pll.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F6EXfh7wwFLDO6tYfgdCgo9uI2whqhTz3oD65TnzIBk=;
        b=HRDm27uAj54KL0N0O6EShyPejA2HVwuvz4TbRwkcPJKpHvUCkyuCaecubM0laavj+X
         9jb8VbAtA7+bu6bDElTvi6k/sQNplhrZvNTpnxzEgaZZLkqfoG+cSoInODlyRN7/z1pQ
         GzY07TqLgIg3k2kDI1M/zKDLyHLZz1eSVMTFAiPGSMNXvxGenOCT3dssH/eIqEYuaox+
         OnE9zdw9TS1HU5yBT8MR2VewR44h4N3dIH44kPZlFRtvcofauX3qLcqYLNezjc7z8GLk
         vlvAdCug89gsQ9PxbFSyCTrpiH670cYsXKwAqM+n4hWokJjLC/wgAYLaHwBhI4HWnXPA
         zeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F6EXfh7wwFLDO6tYfgdCgo9uI2whqhTz3oD65TnzIBk=;
        b=ayUvNVkZI+/iPp5IzYrikL41Bdn55AxVxgffEvVACPtVlotrjMsJC/H7emc1qvu7EL
         Fy1Ja7ZsbHTQB/5Fl6GrWz0RtHkjtdiF7l5/RKnYI+GCk0PEJG1RZaAcyiW4OzhrdyFk
         ckulh9SLG0+vyie+DCDyhR/dPlA/NELWwpkOSwr5/2mICeaOtnaQ8u60L1bH6/rDk/7i
         VYt308alg7W6Z1hBfJb6i2JWpHn6HkzWmGFTIlWJA1vyPmGsXAnJEAHSES+2GRKNFSii
         vDUHsbISR/fpDszJnHQMMiN1gjkhsLudoln0sx+OGRYtrjSsyS01VJEwgz02CcqDQ/gC
         p8IA==
X-Gm-Message-State: AOAM533tqD0iVPzm40GLivWNa+JfhyyVWUVXDxgXHJAqQhu5mH2YxRP5
        ik3vnGTk6qwHBngUAii4lrkMYAYa6AA=
X-Google-Smtp-Source: ABdhPJyEqODVeSC6Sg+g/8PLrsHLPa3K65zRCYAfuCQMV7V+iFZkeSlfLPF/sDlCcFMkaf5H5DWWbg==
X-Received: by 2002:a17:902:7598:b029:12b:e9ca:dfd5 with SMTP id j24-20020a1709027598b029012be9cadfd5mr8682207pll.12.1627271494995;
        Sun, 25 Jul 2021 20:51:34 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:34 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 21/55] KVM: PPC: Book3S HV: CTRL SPR does not require read-modify-write
Date:   Mon, 26 Jul 2021 13:50:02 +1000
Message-Id: <20210726035036.739609-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Processors that support KVM HV do not require read-modify-write of
the CTRL SPR to set/clear their thread's runlatch. Just write 1 or 0
to it.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c            |  2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 772f1e6c93e1..f212d5013622 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4024,7 +4024,7 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	 */
 
 	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+		mtspr(SPRN_CTRLT, 0);
 }
 
 static void store_spr_state(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 551ce223b40c..05be8648937d 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -775,12 +775,11 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	mtspr	SPRN_AMR,r5
 	mtspr	SPRN_UAMOR,r6
 
-	/* Restore state of CTRL run bit; assume 1 on entry */
+	/* Restore state of CTRL run bit; the host currently has it set to 1 */
 	lwz	r5,VCPU_CTRL(r4)
 	andi.	r5,r5,1
 	bne	4f
-	mfspr	r6,SPRN_CTRLF
-	clrrdi	r6,r6,1
+	li	r6,0
 	mtspr	SPRN_CTRLT,r6
 4:
 	/* Secondary threads wait for primary to have done partition switch */
@@ -1203,12 +1202,12 @@ guest_bypass:
 	stw	r0, VCPU_CPU(r9)
 	stw	r0, VCPU_THREAD_CPU(r9)
 
-	/* Save guest CTRL register, set runlatch to 1 */
+	/* Save guest CTRL register, set runlatch to 1 if it was clear */
 	mfspr	r6,SPRN_CTRLF
 	stw	r6,VCPU_CTRL(r9)
 	andi.	r0,r6,1
 	bne	4f
-	ori	r6,r6,1
+	li	r6,1
 	mtspr	SPRN_CTRLT,r6
 4:
 	/*
@@ -2178,8 +2177,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	 * Also clear the runlatch bit before napping.
 	 */
 kvm_do_nap:
-	mfspr	r0, SPRN_CTRLF
-	clrrdi	r0, r0, 1
+	li	r0,0
 	mtspr	SPRN_CTRLT, r0
 
 	li	r0,1
@@ -2198,8 +2196,7 @@ kvm_nap_sequence:		/* desired LPCR value in r5 */
 
 	bl	isa206_idle_insn_mayloss
 
-	mfspr	r0, SPRN_CTRLF
-	ori	r0, r0, 1
+	li	r0,1
 	mtspr	SPRN_CTRLT, r0
 
 	mtspr	SPRN_SRR1, r3
-- 
2.23.0

