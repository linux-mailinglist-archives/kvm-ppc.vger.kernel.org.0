Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768E73B01FF
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFVLAu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFVLAu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:50 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80122C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h1so10258650plt.1
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1fKhypOmGQSqqKdatKoUBvryDJM47nxmnuUJKIWQRE4=;
        b=VndSM+cmxnJz9l7hkNaPXyL3YPIHAGHioB8JP+iTxViqsgfcV/aNXftzeoSWUEwdsQ
         vxRpJQYRGqKdW2UXu0IVimKsITvOY3y5oh/WrakwnjQ/dw50nugQRwQAYk3l59RVxbY/
         a6Oq7uBkHWINhWJzZri722LBd35SBwCGaHIrlZFselAe2MRVBGSTjdIvuxBCdBY4QcOI
         zSQsHcFpaZmGRKGyGKnKVLrApEwEmvd7fxX9WVqoBYMCoTmIl6FKvwuPcmZm4IPm2PcU
         grIfKwALAIUkmy1FWxtqomnWAcjFaVNMMcbPiGVwTuX1uFBhzWxHOM/G+f5Ey5B4jFmE
         Rk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1fKhypOmGQSqqKdatKoUBvryDJM47nxmnuUJKIWQRE4=;
        b=czdExh30+dE8JgyHCrT2ZF6b+Od6F6DYiWU39LytiLLYAmPlcn52Uvo0CR+KRS+Ehx
         Eg/o8k5apbsN24OswanzVJYdHNBQQch226XZghugfYBm+O+0NPWeK8Ls0CCkvMdzUxfp
         JUPCliWevAOLst4aHS0IJYOxlcfrp3ldPyWvgvYRYI8MdaIrC7kJ1Pzl+cxtTz5xYkdM
         EIR58YikX5yq+r3O+qfdB9EA8DXaSx/3BrBIgZe1JhJWGwkN23J9eS/j+a99kQLPXGcu
         lVrgT00M/Uxe/S+DEv6agf6T6xYl/GS0Ud5x2vS0e6kWtNZQQ2iBqi49xJb2R0OvFs5p
         KxbQ==
X-Gm-Message-State: AOAM530PRn9DxJwrl9Z++v8JZDfS0LXZwvrmdFTsCPt0KeOV3q8lidKg
        bzZNUThvOP8HJ4q7Z6uh76XU01m1A30=
X-Google-Smtp-Source: ABdhPJzXQr4ULKKE4zJWGEQsRXHbOUH10ZnEyW8QwWcydJZDc5tLxPmzsIMYrrBCRC1eKbRFRWI+RQ==
X-Received: by 2002:a17:90b:1188:: with SMTP id gk8mr3196788pjb.138.1624359513032;
        Tue, 22 Jun 2021 03:58:33 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 15/43] KVM: PPC: Book3S HV: CTRL SPR does not require read-modify-write
Date:   Tue, 22 Jun 2021 20:57:08 +1000
Message-Id: <20210622105736.633352-16-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index 0733bb95f439..f0298b286c42 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3920,7 +3920,7 @@ static void load_spr_state(struct kvm_vcpu *vcpu)
 	 */
 
 	if (!(vcpu->arch.ctrl & 1))
-		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
+		mtspr(SPRN_CTRLT, 0);
 }
 
 static void store_spr_state(struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 0eb06734bc26..488a1e07958c 100644
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
@@ -1209,12 +1208,12 @@ guest_bypass:
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
@@ -2220,8 +2219,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_TM)
 	 * Also clear the runlatch bit before napping.
 	 */
 kvm_do_nap:
-	mfspr	r0, SPRN_CTRLF
-	clrrdi	r0, r0, 1
+	li	r0,0
 	mtspr	SPRN_CTRLT, r0
 
 	li	r0,1
@@ -2240,8 +2238,7 @@ kvm_nap_sequence:		/* desired LPCR value in r5 */
 
 	bl	isa206_idle_insn_mayloss
 
-	mfspr	r0, SPRN_CTRLF
-	ori	r0, r0, 1
+	li	r0,1
 	mtspr	SPRN_CTRLT, r0
 
 	mtspr	SPRN_SRR1, r3
-- 
2.23.0

