Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11653B0205
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhFVLBE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFVLBE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:04 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43572C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 69so10249083plc.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LJfalil73uKeljur4BgtpcLOhSDvaBS2PpltIheRlE=;
        b=j5fUt+oE2mJuYLgpJBEkEcaa3XB3eUI6ceq+djGIuGQAw1KSMMRrmEhBBrmBhmq5mS
         /BJfbk6moCS0Q9gKPyaqrvqHmZtupsgEqwV0zFCgDl3mheV66OFSif8H+u0rhOQdk3ZD
         IYiDrD2cbT17qiV5d2UNxPRKotCwIo+5U7ZtELpd8g4EBvstU+OH1RyV2yQFGoFrQKLr
         Ivv+GvAgmRz+Mm8hsZzDaDI7XxfFdPkye7zGLjnosNDm7joPgHvkxdyQ3qiH/2g4QG1/
         cWlMIySq/mcLXI8i4g2sZif8x7STHaiRF7gTKmu6EmIVjHM709/dbRmEhL5qMyY3Ibp+
         PrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LJfalil73uKeljur4BgtpcLOhSDvaBS2PpltIheRlE=;
        b=Bp7qjaNViLG2rLbOrFeRK4CiIyfcJmPrAe/NZxERldGCfDvkj441r+NkUZ4++sk74G
         r32runEUaY8eM91k7N58U2GV7x9sTOhD78OS+7hkMXGvLjaGh7bEgVz0W+iMuv/VwpqM
         Z80sR7U501gN96gQ4pfF8uJ/zq8kyBfWsajA70gzfcOj5ZfZe93+7OIP2yrJRKgGqMET
         LZKW9fzUfZzXmDIs4IN0S/Whd3vVMkgv5DAbuYC2GFHdGWZh2t+36mwifBSiJBaJUeB2
         w/jM5cUrT1dViCbAUBtu2XBaRaRJs8e2NL0PEBy2vFYD6XmMyDN92asOBtkS7PU9UHWr
         7oFQ==
X-Gm-Message-State: AOAM532QGru4aEMy2vRKZFvVs+5nxPRUDIPSBluPRTqa+bOOn8KZHBk7
        +u8yxYimInGmjuy8U7GVkl5IuLifeWo=
X-Google-Smtp-Source: ABdhPJz/FF92zn6KzAyPUOBSWa8QE0H1Q3c56QYdIqahi2AXNBxFboZJEnGqRBUiVQt+d5XJgy8w8g==
X-Received: by 2002:a17:902:fe10:b029:127:6549:fe98 with SMTP id g16-20020a170902fe10b02901276549fe98mr160846plj.25.1624359527688;
        Tue, 22 Jun 2021 03:58:47 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:47 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 21/43] KVM: PPC: Book3S HV P9: Move TB updates
Date:   Tue, 22 Jun 2021 20:57:14 +1000
Message-Id: <20210622105736.633352-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the TB updates between saving and loading guest and host SPRs,
to improve scheduling by keeping issue-NTC operations together as
much as possible.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 36 +++++++++++++--------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 469dd5cbb52d..44ee805875ba 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -215,15 +215,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	vcpu->arch.ceded = 0;
 
-	if (vc->tb_offset) {
-		u64 new_tb = tb + vc->tb_offset;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = vc->tb_offset;
-	}
-
 	/* Could avoid mfmsr by passing around, but probably no big deal */
 	msr = mfmsr();
 
@@ -238,6 +229,15 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		host_dawrx1 = mfspr(SPRN_DAWRX1);
 	}
 
+	if (vc->tb_offset) {
+		u64 new_tb = tb + vc->tb_offset;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = vc->tb_offset;
+	}
+
 	if (vc->pcr)
 		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
 	mtspr(SPRN_DPDES, vc->dpdes);
@@ -454,6 +454,15 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	tb = mftb();
 	vcpu->arch.dec_expires = dec + tb;
 
+	if (vc->tb_offset_applied) {
+		u64 new_tb = tb - vc->tb_offset_applied;
+		mtspr(SPRN_TBU40, new_tb);
+		tb = mftb();
+		if ((tb & 0xffffff) < (new_tb & 0xffffff))
+			mtspr(SPRN_TBU40, new_tb + 0x1000000);
+		vc->tb_offset_applied = 0;
+	}
+
 	/* Preserve PSSCR[FAKE_SUSPEND] until we've called kvmppc_save_tm_hv */
 	mtspr(SPRN_PSSCR, host_psscr |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -488,15 +497,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
 
-	if (vc->tb_offset_applied) {
-		u64 new_tb = mftb() - vc->tb_offset_applied;
-		mtspr(SPRN_TBU40, new_tb);
-		tb = mftb();
-		if ((tb & 0xffffff) < (new_tb & 0xffffff))
-			mtspr(SPRN_TBU40, new_tb + 0x1000000);
-		vc->tb_offset_applied = 0;
-	}
-
 	/* HDEC must be at least as large as DEC, so decrementer_max fits */
 	mtspr(SPRN_HDEC, decrementer_max);
 
-- 
2.23.0

