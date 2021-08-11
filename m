Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB483E9555
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbhHKQDP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQDP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:15 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A72EC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so5350257pje.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q0d0iaopUkL57P/YF2EiZzRzVhFFGYIegIp/ZQI3dO8=;
        b=tEdIQaqs2HRZCjge8fh1ibXHwlZC+5KChx8ndqotUyE69jWlERwDq7ecjhtfEBxaBq
         K9O8G/N6GpS9Yc6P16JFFjYuO0HTfWNOe1PWBe3+7Wt1nfPFR+K5M80NCIAqLtz979kP
         /i2b+qbrFPNc0NgluKbYwJG5PHIAVKQxwOMgPepDqWo/STuhyDM0vLLizY6OeqTClPMU
         ugyDxaqDn6bYXm6dmnwEeGyNRKePgbpwtSSQ0Tyb07jyo0k7OWn/BDhKBjSks58uB/8n
         G6ToDuGVYYcnT2gswCIC9QbM/wYQYvg6b3ReZxeJ2xkpjY4E3zLaoqH8tt5iAdXL4liF
         GlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0d0iaopUkL57P/YF2EiZzRzVhFFGYIegIp/ZQI3dO8=;
        b=cOaXIGNpakDHbiDkeqEJjC/71ry/XLZCUBtWzgQX33KDhEZwSV7EHpBox26g4lbSjH
         tXwEHgrwAtRZvsdghxP5SjrdbQVKXwne5W9PSyiccn3UuvQ0aaCDF73A+OsnITdx5GCh
         a6szu6m1oNIV3buJkCHeMHIzPam/B+u9N/myGIBxFe6i27mApQ+x8svU2IYXSGux26kB
         7/fN6qIa0Meor8dBgqWpI3D2Z7zBQPjpDMXmdc3ENMj37HCnBwCjn481Lfv4SFKRXD6r
         lXmiLOj9pPg50F4LbXP46Yo8d2qD6LbmjAYkYHipx29spMAf7CeytAOJk1QN0IEJXftX
         wqBg==
X-Gm-Message-State: AOAM530yLAXNjVEnk5qaK0S4HQspURPuP3jn0PXMYs7TzBTdnyhJhPMO
        WQ7yKTz5KbHmMD/OkXCwiTaQ0fbu5KY=
X-Google-Smtp-Source: ABdhPJzd+cZm7lc8lSMZdvmG9Mg0irEwwXBZrOzKs7aJnrs7cThmGx00AGnzug/cEOiJRet08RQRpQ==
X-Received: by 2002:a17:90a:a091:: with SMTP id r17mr4239723pjp.56.1628697770805;
        Wed, 11 Aug 2021 09:02:50 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 25/60] KVM: PPC: Book3S HV: CTRL SPR does not require read-modify-write
Date:   Thu, 12 Aug 2021 02:00:59 +1000
Message-Id: <20210811160134.904987-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index fa12a3efeeb2..f9942eeaefd3 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4060,7 +4060,7 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
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

