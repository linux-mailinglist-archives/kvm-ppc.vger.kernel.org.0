Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E713D51A1
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhGZDKT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5500BC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso9375828pjq.2
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tBUS86yzW++npW3fONJoOYSWPBRI54iAbyTNCBlq0wE=;
        b=gZHMKKZ8Bwij9kIOUgjyL2u2T9r766e2UvTf+se7ksIInEfRWZIvTBfMb5f9Ro7nCL
         39LTzq781qnnwdcpe3uSm9B61p86wAxvCfuFtXutFNs5ftedtFl5UCJTNwSKFZl1VLi1
         EB8YfhZU7Nkormc75q3pjUcW+J+sbAr5/a754rLtR6Z5W/FMhIcMN2j9kIRpcZd2s1MN
         Xx/3Qo6Iu5LGXoTPSEd++CUl21G7JAmEGkUaw0trW+IxDwWYwT0w28R5TuTXEv/+24GR
         M3xNyjdTcrCvnI2Mk2VmoB0f/L0BhTIEP7BZoexp9Y/eWAneVEPljKBGKJDIG9P2wZX3
         tRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tBUS86yzW++npW3fONJoOYSWPBRI54iAbyTNCBlq0wE=;
        b=QKHZAwVGlc2ee3Tr3tQ+gtXl+bxTzOVHE5irVfgmc6FY7AEMqeYCy3fixMeN/OoJSI
         6bfXNvDnmld7RnVigGjN6HOq/XZoZ5jZXJBfGn0STOb5priFJyXq3i2QbHs+6pvJu/nR
         P88LpfhKSEot6cinqzOdJ4khCN/kNt2/sm4zff9TXiqALTuDgPvVZaK1iYlSIyi0OoMk
         tBOxoKMQqz85VRmak+2NcUM/YVotqg2SUbbrY7tKVePNZemGJn+xbzGV6b1m2gDRSWu4
         XJ10MmlUchUlLnJ28SopWcbx7sakE9DFWSkWYg4J9IdYIqOhyC47Tljv+rurWctrlr5Z
         /DPw==
X-Gm-Message-State: AOAM530ReBINNqImlfLuqZY0nxZzgtab3FCCanJLxIeLepkRGHadTnCf
        zT/AiDtFzzlSMOb67dv50TuFuH8w/Y0=
X-Google-Smtp-Source: ABdhPJz3trP7pDym2e415b3RsbmZOL9WcoANJnLcFx883v2fnv5zGIksLxn8S+G332jFZlwJE1wybQ==
X-Received: by 2002:a05:6a00:1582:b029:332:67bf:c196 with SMTP id u2-20020a056a001582b029033267bfc196mr16147180pfk.52.1627271446786;
        Sun, 25 Jul 2021 20:50:46 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 01/55] KVM: PPC: Book3S HV: Remove TM emulation from POWER7/8 path
Date:   Mon, 26 Jul 2021 13:49:42 +1000
Message-Id: <20210726035036.739609-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

TM fake-suspend emulation is only used by POWER9. Remove it from the old
code path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 42 -------------------------
 1 file changed, 42 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 8dd437d7a2c6..75079397c2a5 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1088,12 +1088,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	cmpwi	r12, BOOK3S_INTERRUPT_H_INST_STORAGE
 	beq	kvmppc_hisi
 
-#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-	/* For softpatch interrupt, go off and do TM instruction emulation */
-	cmpwi	r12, BOOK3S_INTERRUPT_HV_SOFTPATCH
-	beq	kvmppc_tm_emul
-#endif
-
 	/* See if this is a leftover HDEC interrupt */
 	cmpwi	r12,BOOK3S_INTERRUPT_HV_DECREMENTER
 	bne	2f
@@ -1599,42 +1593,6 @@ maybe_reenter_guest:
 	blt	deliver_guest_interrupt
 	b	guest_exit_cont
 
-#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-/*
- * Softpatch interrupt for transactional memory emulation cases
- * on POWER9 DD2.2.  This is early in the guest exit path - we
- * haven't saved registers or done a treclaim yet.
- */
-kvmppc_tm_emul:
-	/* Save instruction image in HEIR */
-	mfspr	r3, SPRN_HEIR
-	stw	r3, VCPU_HEIR(r9)
-
-	/*
-	 * The cases we want to handle here are those where the guest
-	 * is in real suspend mode and is trying to transition to
-	 * transactional mode.
-	 */
-	lbz	r0, HSTATE_FAKE_SUSPEND(r13)
-	cmpwi	r0, 0		/* keep exiting guest if in fake suspend */
-	bne	guest_exit_cont
-	rldicl	r3, r11, 64 - MSR_TS_S_LG, 62
-	cmpwi	r3, 1		/* or if not in suspend state */
-	bne	guest_exit_cont
-
-	/* Call C code to do the emulation */
-	mr	r3, r9
-	bl	kvmhv_p9_tm_emulation_early
-	nop
-	ld	r9, HSTATE_KVM_VCPU(r13)
-	li	r12, BOOK3S_INTERRUPT_HV_SOFTPATCH
-	cmpwi	r3, 0
-	beq	guest_exit_cont		/* continue exiting if not handled */
-	ld	r10, VCPU_PC(r9)
-	ld	r11, VCPU_MSR(r9)
-	b	fast_interrupt_c_return	/* go back to guest if handled */
-#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
-
 /*
  * Check whether an HDSI is an HPTE not found fault or something else.
  * If it is an HPTE not found fault that is due to the guest accessing
-- 
2.23.0

