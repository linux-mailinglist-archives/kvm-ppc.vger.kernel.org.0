Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DDB3E955B
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhHKQDb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbhHKQDa (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6CAC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:06 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so5813166pjb.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InnIngdCZKWqNjgAIB+VqHmGiblNFRvsyL7J2HN5wII=;
        b=SLs5Sp2KGYzaSjW8FHaSs2/pqJVjreblwmivnXGPwMI10Y4p95FmUWnDySm/Xf69mH
         /KoL/C6fVQ5bSIKms4NGM1g9dJVY0Rw+8c/LzS5JsceonBefq6sGfn8larYR+Hee6ugs
         u9TBS3pUCwTxG4Iw7GbN00blokO9E0VXBw2QMn6ExtGj0sY+vEUaUDixf17jzQojQIMK
         VTDy4kau7brqPDmmjlg+SIvewMkmL8VjQikT+T16tzphnhLUv3W5xx7GJVpbHIwYP2qR
         aphBom2Fwy3spcSlUA+EfTmY+N3+RyX6cB3qdteLZtvU4wM1E/3SGD5kRskB7uxp4Gra
         AcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InnIngdCZKWqNjgAIB+VqHmGiblNFRvsyL7J2HN5wII=;
        b=kZjjplSwDnEB0o1ARZcBon+SjHLMf1jI5RVCakcVOvN2Nm9SzHG4ewRPvkIMpWPOFV
         qE1JCXyZJVOnwO6CTPHY4a9zhL6cMY+XqR6Lxy87Fz1AXi3NwTvRFTFJaYVDoqWRkx7W
         trjN/r/8tvCl3fvwfxHmYAL9seZcpbqHT2D+o4OjLX6smW2d4eBg2FK9EaPurkNglaIb
         1jM2MmJgyCEBjtOhelC/IC8gQF68ZIe9zsT+gPIhjGoGd8W/QOsRgbbjGY6WB6BKk4tb
         YrQ8+6jGk6jXM2QEoSl4Gqi9smDIiCCFmgqDx+ISsEujefikDW2FA5Dixao2S4sUhkpD
         eDaQ==
X-Gm-Message-State: AOAM5328w/q6+uJPCW8sMpPCHdN2FcKxUv9WgQvzxtsrVChleT/NiZCG
        ITx0k5FGdtEFRE+IF1chicDlQNMfswA=
X-Google-Smtp-Source: ABdhPJz4HafK0CG2RxLwDc1U5+eNUabmA0f5ORXEhQfO5vZsMmODLog8hZ8tYln9uMIWG01fQP9joQ==
X-Received: by 2002:a63:214b:: with SMTP id s11mr401813pgm.87.1628697786435;
        Wed, 11 Aug 2021 09:03:06 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 31/60] KVM: PPC: Book3S HV P9: Move TB updates
Date:   Thu, 12 Aug 2021 02:01:05 +1000
Message-Id: <20210811160134.904987-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 814b0dfd590f..e7793bb806eb 100644
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
@@ -469,6 +469,15 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -503,15 +512,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

