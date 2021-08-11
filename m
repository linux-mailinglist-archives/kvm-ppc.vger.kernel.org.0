Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3093E9538
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhHKQCO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34547C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:50 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so5723703pjl.4
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tBUS86yzW++npW3fONJoOYSWPBRI54iAbyTNCBlq0wE=;
        b=OhMFl8HRirrAAMVDyybTuV0EAGt4CgiYNACAlQUI284h4CxKkX2rgbnqjB2AE2yH2a
         RQ7pExWFwFJtK9ol2SixJpujUvcJp76LSbXWZKFhq36PnmDcBbxddt0C45nz/2IF12FF
         rCHfQMaYRUoYpovYL9S41dTR5SA68KZHDcQnq7cG+zA9Z/h5I61AK8kcdOHQ4Q+YkPrn
         mOeTNWtMI3QrpuvYt9YaZxvDn83kamGK0RoAVNXs1WAYDXf0kZM1B62hicW1cfD6ty4m
         MvehYfrq6EpVaSH5+WH1UTFA8BaHa9C+9yv6iG/C+bXRzP2lWDrlusbZxC/9GhN7HA1m
         PpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tBUS86yzW++npW3fONJoOYSWPBRI54iAbyTNCBlq0wE=;
        b=Ga3i3pjeYb5wlSeBJ03jFHdxMYzUzD1PYXc2PcNp8ik161wGGck0WjsM+y+TAr5d8O
         xJT0/YpigC2bIqgi54u0KJ0R6xcZUBFMGn6GhJ9v01KpF+vmo1vWnQZzcbM9Udk3QZHB
         JnfLD83GWVRFRDO6ItQUtpFYlYZcjQpJVnECJ19TQUr6J7Y1cBAk1x9z4t/Zy0oEIc3y
         zsq1O84iwnH45ERwdyxcPO0na6l4yspDjYZYQ7lx3Oh39w0KN36b6ZeiisMhFVtPS9sm
         ebav4F1jsDfPCUwrYv+hs08/qkvJPKGrPVSpAk/lCvWXzFZU7D3KsYmQJ/JiqOQaPlxe
         m/iw==
X-Gm-Message-State: AOAM530ee94EokObx/ntjvcKx++zgIJPJ3EEJy1bUxBIDFWZjfNYBnj/
        SveJrYMe2nciOKTGvjsogqfo3juKWtI=
X-Google-Smtp-Source: ABdhPJyGesYYVuFvADexHokYQDJijjGlMpUAGoYMGGFnjf/wHnSaka9QLjpwaUNrFGsegQX5b2QRVA==
X-Received: by 2002:a17:902:b947:b029:12c:b414:a018 with SMTP id h7-20020a170902b947b029012cb414a018mr15908883pls.30.1628697709608;
        Wed, 11 Aug 2021 09:01:49 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:49 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 02/60] KVM: PPC: Book3S HV: Remove TM emulation from POWER7/8 path
Date:   Thu, 12 Aug 2021 02:00:36 +1000
Message-Id: <20210811160134.904987-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

