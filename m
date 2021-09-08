Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF1E4037B0
	for <lists+kvm-ppc@lfdr.de>; Wed,  8 Sep 2021 12:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347927AbhIHKSj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 8 Sep 2021 06:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbhIHKSj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 8 Sep 2021 06:18:39 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4427C061575
        for <kvm-ppc@vger.kernel.org>; Wed,  8 Sep 2021 03:17:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g14so1644612pfm.1
        for <kvm-ppc@vger.kernel.org>; Wed, 08 Sep 2021 03:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZpvq7x2lHuZWsil0sfaEPemJ8g24kmEc0HiGKQSHYo=;
        b=d1FDrK4DwZVEKSJ+CCu2erJOj3mUVKWHDH4jl0iZnD/kwWvbrAenl2iXvHL4U795hF
         STP8lnfwJzuw2GSezB2N6ayq8FbHEQnacWEOA4mkLCyAzGflTBviGZ1dYKxihLUHRdBT
         VYjzuVytNWpwMIx64AOihV2JCvvadFbvO0OtSi5uwGfePngQZfQdcFyBKTtypZV46qNM
         fDXYfbyt7ATTqwIkBZUfAypXbw6nfr4o4YwgMVHEc6e1tPW4cOimTHvx88goHbV23EVU
         EoIElQcP4Vsv7dPsb2x+aogFTWVO4i33C0eIUIiBxQYcXlqf//baRBqY0uAIq+A3Z1ej
         4bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZpvq7x2lHuZWsil0sfaEPemJ8g24kmEc0HiGKQSHYo=;
        b=WpbUZyCIikU1oQoaDjLurhe29IZ9TwN29nrH7rDEu9dMmiKh//aycH4OSE3/R4VIev
         7wewcAkse2s50o3AuzKGMkrOTinOnmNvzmF0sADDjwZJPXeFSiblrODWLHuaOtwI+H7K
         Ise1gatjn1NgOk+XuUbYDG+fuWBg5MLPGuD0GMVGCotGmjlrjPoKyt/Ah+mepoArapjE
         q3DkY50cWYIemKkXRfa2tzRWhzHB9XjrYbVqziwKYWJIrgzmg/W2LjSDmu+9rlu0q4yC
         zrS29i/uB8rBFP8yBYlBjSQ2+RCPJ6fTISqMp9sfuMygMk2VwCl6IKtJra4gLwoiwX3m
         PXyw==
X-Gm-Message-State: AOAM533TbaMyKtVmljqEn70Oohs3zbTtnfjMzGLevTd6Fuxs5Boe81sq
        glPN4iC0EP4UwmlcoPSFeUM=
X-Google-Smtp-Source: ABdhPJyiU+4j19v7oPN6Tl7GXyP+OVn/YtiRXqPOSVzWdoiB0Z3l1smI2rJU0h0lE/IZQupm+24FrQ==
X-Received: by 2002:a63:1358:: with SMTP id 24mr2913654pgt.327.1631096251508;
        Wed, 08 Sep 2021 03:17:31 -0700 (PDT)
Received: from bobo.ibm.com (115-64-207-17.tpgi.com.au. [115.64.207.17])
        by smtp.gmail.com with ESMTPSA id bj13sm1722019pjb.28.2021.09.08.03.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 03:17:31 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Eirik Fuller <efuller@redhat.com>
Subject: [PATCH v1 2/2] KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers
Date:   Wed,  8 Sep 2021 20:17:18 +1000
Message-Id: <20210908101718.118522-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210908101718.118522-1-npiggin@gmail.com>
References: <20210908101718.118522-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

POWER9 DD2.2 and 2.3 hardware implements a "fake-suspend" mode where
certain TM instructions executed in HV=0 mode cause softpatch interrupts
so the hypervisor can emulate them and prevent problematic processor
conditions. In this fake-suspend mode, the treclaim. instruction does
not modify registers.

Unfortunately the rfscv instruction executed by the guest do not
generate softpatch interrupts, which can cause the hypervisor to lose
track of the fake-suspend mode, and it can execute this treclaim. while
not in fake-suspend mode. This modifies GPRs and crashes the hypervisor.

It's not trivial to disable scv in the guest with HFSCR now, because
they assume a POWER9 has scv available. So this fix saves and restores
checkpointed registers across the treclaim.

Fixes: 7854f7545bff ("KVM: PPC: Book3S: Rework TM save/restore code and make it C-callable")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 36 +++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 8dd437d7a2c6..dd18e1c44751 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2578,7 +2578,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
 	/* The following code handles the fake_suspend = 1 case */
 	mflr	r0
 	std	r0, PPC_LR_STKOFF(r1)
-	stdu	r1, -PPC_MIN_STKFRM(r1)
+	stdu	r1, -TM_FRAME_SIZE(r1)
 
 	/* Turn on TM. */
 	mfmsr	r8
@@ -2593,10 +2593,42 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_SO_BUG)
 	nop
 
+	/*
+	 * It's possible that treclaim. may modify registers, if we have lost
+	 * track of fake-suspend state in the guest due to it using rfscv.
+	 * Save and restore registers in case this occurs.
+	 */
+	mfspr	r3, SPRN_DSCR
+	mfspr	r4, SPRN_XER
+	mfspr	r5, SPRN_AMR
+	/* SPRN_TAR would need to be saved here if the kernel ever used it */
+	mfcr	r12
+	SAVE_NVGPRS(r1)
+	SAVE_GPR(2, r1)
+	SAVE_GPR(3, r1)
+	SAVE_GPR(4, r1)
+	SAVE_GPR(5, r1)
+	stw	r12, 8(r1)
+	std	r1, HSTATE_HOST_R1(r13)
+
 	/* We have to treclaim here because that's the only way to do S->N */
 	li	r3, TM_CAUSE_KVM_RESCHED
 	TRECLAIM(R3)
 
+	GET_PACA(r13)
+	ld	r1, HSTATE_HOST_R1(r13)
+	REST_GPR(2, r1)
+	REST_GPR(3, r1)
+	REST_GPR(4, r1)
+	REST_GPR(5, r1)
+	lwz	r12, 8(r1)
+	REST_NVGPRS(r1)
+	mtspr	SPRN_DSCR, r3
+	mtspr	SPRN_XER, r4
+	mtspr	SPRN_AMR, r5
+	mtcr	r12
+	HMT_MEDIUM
+
 	/*
 	 * We were in fake suspend, so we are not going to save the
 	 * register state as the guest checkpointed state (since
@@ -2624,7 +2656,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_SO_BUG)
 	std	r5, VCPU_TFHAR(r9)
 	std	r6, VCPU_TFIAR(r9)
 
-	addi	r1, r1, PPC_MIN_STKFRM
+	addi	r1, r1, TM_FRAME_SIZE
 	ld	r0, PPC_LR_STKOFF(r1)
 	mtlr	r0
 	blr
-- 
2.23.0

