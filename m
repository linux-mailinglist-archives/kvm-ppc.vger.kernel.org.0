Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16334548E
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhCWBFX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhCWBE4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F328EC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id l123so12535184pfl.8
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmDpEHgsazPBq/iaHf1gq1ioVfAETKz0M2WFtf/RE1s=;
        b=g0KPjTuwknaPHORqF8abNTqxzcfOHoswrBnb1gDIuoXptLY6IUUsijMyI3pTUQ1jUV
         h+un+hveOYovOJODCiIOd7ilsjWeWIx5EwWfJGcY2ifHGigJgkWhfzLiY+I/1dhCA8KW
         0Q3xfBIQIJ2qqQYz99ieZPKpcsE6T+9bPxYU553lDMgIv0kX6Xif5FCXlMf+be/OeNxy
         ZqsW830mMSXOpWQXcWQHxxXaTibYoQAc3Mwx6sKt2u4SCNvaXGODd9B0Tl1oA1qKqjsa
         JoQzbr6NtRtkv1jK06VgBRfyFfmG9GPv1dBJNJSkbzvPIoa2Jf/kLph9RD7RTyLsQ7UX
         amew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmDpEHgsazPBq/iaHf1gq1ioVfAETKz0M2WFtf/RE1s=;
        b=RcUfXFEjUkiwlx/R+Z8iTqi6ONdFAVb8ylLaWb5BHgXj7j/NpK4EQVg3jGKpYGJgw9
         RC1v/TkYAaSw+4uK7VNo4gAk2+iRQdi58sH1DfQel6MGw5NrsbiEMqv9psOUeIm5hpTY
         GV/cVe1gsEehHVrYrn77P10+0bfVB1Fyqk9xJFaMxnHXD7drPJCNC36gH1wT4l8ZZFny
         KKg/Hn7lgb2HFnTDoq9Q4xXEg27rhv2xBCC0vgu2wL+WI/1xuj66EX7hxNvrB8K4V8JB
         91EC/mmro5NhQTPhSaLxSzo40inBz+wH8ohjnV8wiSr6ZDtuGGsnj90Rk7kt4ckGvmrf
         DBOw==
X-Gm-Message-State: AOAM532rf6LHs/6G9w6oLvjmTKefAte6VXPWh3tB3/6yh63bjBIp5yIw
        MV6XNeYUleHmrZ6es8kjihLNM30mPKI=
X-Google-Smtp-Source: ABdhPJxMas/9lfwRgTcjcrbFuFFIram7aZO0X8Y5LpmjHrmv+Ugt6nLLBms3F3mgsWZlh5LPD0+RUw==
X-Received: by 2002:a62:8485:0:b029:1fc:823d:2a70 with SMTP id k127-20020a6284850000b02901fc823d2a70mr2398327pfd.18.1616461495441;
        Mon, 22 Mar 2021 18:04:55 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:55 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 33/46] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Tue, 23 Mar 2021 11:02:52 +1000
Message-Id: <20210323010305.1045293-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is wasted work if the time limit is exceeded.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 36 ++++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 4058a325a7f0..f57379e73b5c 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -138,21 +138,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	u64 tb, purr, spurr;
 	u64 *exsave;
 	bool ri_set;
-	unsigned long msr = mfmsr();
 	int trap;
-	unsigned long host_hfscr = mfspr(SPRN_HFSCR);
-	unsigned long host_ciabr = mfspr(SPRN_CIABR);
-	unsigned long host_dawr0 = mfspr(SPRN_DAWR0);
-	unsigned long host_dawrx0 = mfspr(SPRN_DAWRX0);
-	unsigned long host_psscr = mfspr(SPRN_PSSCR);
-	unsigned long host_pidr = mfspr(SPRN_PID);
-	unsigned long host_dawr1 = 0;
-	unsigned long host_dawrx1 = 0;
-
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
-	}
+	unsigned long msr;
+	unsigned long host_hfscr;
+	unsigned long host_ciabr;
+	unsigned long host_dawr0;
+	unsigned long host_dawrx0;
+	unsigned long host_psscr;
+	unsigned long host_pidr;
+	unsigned long host_dawr1;
+	unsigned long host_dawrx1;
 
 	tb = mftb();
 	hdec = time_limit - tb;
@@ -170,6 +165,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = vc->tb_offset;
 	}
 
+	msr = mfmsr();
+
+	host_hfscr = mfspr(SPRN_HFSCR);
+	host_ciabr = mfspr(SPRN_CIABR);
+	host_dawr0 = mfspr(SPRN_DAWR0);
+	host_dawrx0 = mfspr(SPRN_DAWRX0);
+	host_psscr = mfspr(SPRN_PSSCR);
+	host_pidr = mfspr(SPRN_PID);
+	if (cpu_has_feature(CPU_FTR_DAWR1)) {
+		host_dawr1 = mfspr(SPRN_DAWR1);
+		host_dawrx1 = mfspr(SPRN_DAWRX1);
+	}
+
 	if (vc->pcr)
 		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
 	mtspr(SPRN_DPDES, vc->dpdes);
-- 
2.23.0

