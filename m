Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6ED3D51C0
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhGZDLe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbhGZDLU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FA7C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:49 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so4439995plh.7
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InnIngdCZKWqNjgAIB+VqHmGiblNFRvsyL7J2HN5wII=;
        b=lnOzFb4YJpYCfhT+K1PMdbx9Nfbf1/IjFRcap6NDJB/eSyMcf0i9r2cFi7yHEcf9Lk
         XUY9jpj3hk4Dh/bNFCvTMaogclMUopmicvdC6yu62jiws/hQnsFhprXg4BZQZzoi+2on
         oZskw7fOeWlxdEz1xWDwcMIDwJ64ZoWQnkYZDlDeFDtKT2pQVsi1LxJ9hhjahnwaBd4/
         /8e2geN76hB7FTYGmPL0+tq2sYYWrxoQtMxIwMWSSQir57FBQYmvpgYdsEGnorqtoXGt
         +glVlDmKb9rJ9sTcRsf9gdEKssTnxtBo3lq6LCDbRqtm7Ffews80srcjUB1ey3Ym9+HH
         yuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InnIngdCZKWqNjgAIB+VqHmGiblNFRvsyL7J2HN5wII=;
        b=F8QK25xiTMNqUYqfnKDwpvCoZsjiw2vNrlYGBmPP7pYNHRzSTsoLcCb6gU5oRFyXnF
         Ev+A6GVtK16EuEhd0l5SmCxN6PMDHVeKaZv04hzZwcV3///iUeAV83WAxpqZcyj4jC7v
         htl07SaJszMefYK7Jb4cHOoK1Ho0bHIIX62He9+xisGcmFFE1hIgjuK7o2TjLYV5DbBu
         X/Xz5VBT3+dlRNlmv5CgH43gCbksRf2idBEN3LtVQJwYj9P8FHsppoMIjsQratk2oZDG
         2MQ+PyJVImPZ9qPZ9+fELIU37jh7gF+zYGqMkuyw9vlq4Gx9ken7EfqnYfHBALpkYoKY
         1xjQ==
X-Gm-Message-State: AOAM533j4EAnvRSvUJWsDyxUIi4AprOD7ldpQtIthxJZKvsq7Us7xHHJ
        0NPgpngfyy+d1BUBaSqL/v3oZvTBHsE=
X-Google-Smtp-Source: ABdhPJzs+7y0r81P3TH9r8iY5j4AV0YnhCSDQP1XzTu7Q2upvYgtQi2kw3DNSbHWVaLRRPEqPIwk+Q==
X-Received: by 2002:a65:63d0:: with SMTP id n16mr6256947pgv.432.1627271508565;
        Sun, 25 Jul 2021 20:51:48 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 27/55] KVM: PPC: Book3S HV P9: Move TB updates
Date:   Mon, 26 Jul 2021 13:50:08 +1000
Message-Id: <20210726035036.739609-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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

