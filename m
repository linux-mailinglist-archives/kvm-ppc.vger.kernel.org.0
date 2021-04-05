Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F860353AAD
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhDEBWM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhDEBWK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3413C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:04 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c17so7196347pfn.6
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ELleIfITWKdYl/6JRZ1bTw1HIDto3+vH9d6zAZjOFfA=;
        b=CvoKXKqB0mduB54xAuGzHReLCSvsf8NkTPhYy05NE3+u8LPDlsi5uRXZYqL5TvmsY0
         m40f3L9opavU30fAP+EAA+ZZrnThUUYBIpRmJfGoPdXCW+x+PrFI9W0kCyAMyMWFCfLG
         4hs8gXiXj4No3l8YxfVOQvskaTLk67RDDjIs+T5nF77R3n10GFVB8DLaMCdY4FJotO/w
         gTrz/opoSnKk4IC7wYT1qpfG53nxH+VUXEVweLyoP6/UMh+QLMh6NjXVKkIjY4GXzkZO
         zNfhwuXIuSpTqYG5o52C0dD9Mfd2jrlxbWPP0CQsKCGwbq6a/Y8jt3CM0pgrDaQ2RDTK
         6mQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ELleIfITWKdYl/6JRZ1bTw1HIDto3+vH9d6zAZjOFfA=;
        b=dWx+qW3/Wpo/eqOdRk5oPK/1AI3nnnkvWV/v4b0yF/6zgX8txSyV7Yo122OJnl6+CB
         XT/DbTVkKJ+jXNUCOr+chSKwObscwyHODQfJtOHXQgDRO7TkH8ikrrTwYbK6K2V8clfb
         8im6chzSpR/zGKajupJn2nd16hu/fBlxfvAp2DeKwgYz7qJCClK0EYve+2H4uMiyAU6l
         J1wZyZjg+bQPgWQqg0zt3W7DG4Sl1KjlRID9USN/RMzEhGgytTP8AYC7MQN4VfMcV9Dn
         3BC+Qof5TZHWSRb57ILjGBL+7Nt9YwS7szawn4qT1pv0ICg4U4s9PekVnBAnJZRR3jq0
         xeNA==
X-Gm-Message-State: AOAM531MnxSgou/QPXuixTpKMS4hsHXj4pBTjS+47FLj+6P+sW9oCP0I
        CrGGHyvQk/Q7ZdS2756rabw1N4h1kH7EMw==
X-Google-Smtp-Source: ABdhPJyfvKxwVAuMt2iSIbkOrUQMNymo5IttS8bHrxfmb/HgpZvgpNsglEmUpT4W8ZFYq/n7GxICZQ==
X-Received: by 2002:a63:c48:: with SMTP id 8mr20794300pgm.74.1617585724463;
        Sun, 04 Apr 2021 18:22:04 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 36/48] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Mon,  5 Apr 2021 11:19:36 +1000
Message-Id: <20210405011948.675354-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv_interrupt.c | 40 +++++++++++++-------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index b12bf7c01460..a430cefb822a 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -149,8 +149,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
+	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
+
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
+	vcpu->arch.ceded = 0;
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -199,26 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
 
@@ -237,6 +222,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

