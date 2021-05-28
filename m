Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF29393F7D
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhE1JKo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbhE1JKc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B37C06134A
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:51 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x188so2759473pfd.7
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bgJyhFHkeuBf76WTc9/+UXDBZJJlpHTMyd2G3pGpHY=;
        b=ngBcIpOp87klHGKDYf3C6Ba7ht+U3XXQH6/REjiERCJ7tHnbe59fET+MSbZVOxWiF+
         zVxXkiO4tYnHRL/Qw94TbvnRLdJ0sBVOy9bYuJrz8mSYoKZI8PrOMqcXsVtrul3BwcA7
         Gc/ZyukyW5zZEycnK5BDiY+GQswPWVg0kJmZHbVi6GC3egJW0hqDENh2En7PpLRqKMq5
         kZ6Lj1kmyrUlzibjbBKItbBhsZiWXy5a5/CJDn7rLznri08AdhkcfGeDVqCiMjCk14rQ
         5T6+s/g/YggkxhyW/wU2fzM/pm2bzKsqcGLw6yT4GFZ9R6HTHkt7HfYiL6d5uOeRXJlQ
         wKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bgJyhFHkeuBf76WTc9/+UXDBZJJlpHTMyd2G3pGpHY=;
        b=mJJcRlby2WbzZ3ugihjKzAV9XAxRXjZx+NA29nNbHKOuu7QTZlnJV8Dt1a1URetxrw
         1R59L0V35V1fUCqtaECLwAmIBZ9y/C1FYnqhNFz69eoC6Jlj7moCVRBg7SPQrVQTko5y
         JHVGICxmHkE/fqR0grgjlLAL+OKxqEg1lXljDKhSkJ066TA4VFQohOe0szZBFknZ4ThN
         4OjvPiUbrdNuMDFqk4NhGH1eO1BECRfgK/Am7ereyaKZ5vEUtHUSQ4bSz45wjHplMqCw
         Ykx2du29zL3hrby9RBRkb92LPJIllKMFQoptTfogY4ns6tdMo49ZeCtOOTBQGVoWP0MU
         jE1Q==
X-Gm-Message-State: AOAM531Z2oDSMlzoJSKBPyHQP9Ax8slIhH1kC+VEza03joL7KvlWaqKk
        mW7ALvocrU0JWkb2S99jITO2nsqSoxw=
X-Google-Smtp-Source: ABdhPJyN5EmM+LBvnAUXWy9946H67rrdYeOcCsua/YzNsPfv3lKmuarj318PQbnbmDRHHsumW6UFTA==
X-Received: by 2002:a65:4887:: with SMTP id n7mr7973140pgs.284.1622192930725;
        Fri, 28 May 2021 02:08:50 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 20/32] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Fri, 28 May 2021 19:07:40 +1000
Message-Id: <20210528090752.3542186-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move MMU context switch as late as reasonably possible to minimise code
running with guest context switched in. This becomes more important when
this code may run in real-mode, with later changes.

Move WARN_ON as early as possible so program check interrupts are less
likely to tangle everything up.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 40 +++++++++++++--------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index f24a12632b72..0b5bd00c9d0f 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -138,8 +138,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
+	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
+
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
+	vcpu->arch.ceded = 0;
+
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -188,26 +193,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
 
-	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
-	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
-	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
-
-	mtspr(SPRN_AMOR, ~0UL);
-
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-
-	/*
-	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
-	 * so set guest LPCR (with HDICE) before writing HDEC.
-	 */
-	mtspr(SPRN_HDEC, hdec);
-
-	vcpu->arch.ceded = 0;
-
-	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
-	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
-
 	mtspr(SPRN_HSRR0, vcpu->arch.regs.nip);
 	mtspr(SPRN_HSRR1, (vcpu->arch.shregs.msr & ~MSR_HV) | MSR_ME);
 
@@ -226,6 +211,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
+	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
+	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
+	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
+	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
+
+	mtspr(SPRN_AMOR, ~0UL);
+
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	__mtmsrd(0, 1); /* clear RI */
 
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-- 
2.23.0

