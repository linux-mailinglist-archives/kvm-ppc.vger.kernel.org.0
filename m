Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6900353AAB
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhDEBWF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhDEBWE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:04 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CE4C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so7623056pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TGKHP+bbZ5HpeqjL0ziVqhKR6G70TwNSVTHqxmQ2sOI=;
        b=muOHp/vI+RhL5vOz6Bu5jATo+MrWev1hms+tcMLsQUtMe+ZR1ua4Mx9NKk05l0798I
         UGSB3/BtoGPV6sMhIBTBiIeJMj0cioS81x4Hu5oT2TFkpL/Php2RE5C3rxQR4iwDlHUg
         WZ7E8hC1NBhTvy/5NqcUFjc11ZwRXkhu33wVqMoI2ZaqIlGEkzB6OJg+WfOTosvvPQML
         QCPHp+yYB4FX48toTHfpjjU/Y0Okw4cvhjJXeIXTM0YSyAYTHNLbtGICaqiaxBN0gazF
         COs6Chf8mZhflp7796ngJMJMqj47sd7WZhyj8KO56f5NkeArip96XsjTnFmIN3ZNMl+w
         xZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TGKHP+bbZ5HpeqjL0ziVqhKR6G70TwNSVTHqxmQ2sOI=;
        b=EmQztZZ6e50aHqYO0w17nvxC5VGyjUZGtONC6WVdYkW1C2LcoSA6nkpNk8pS4GR9tJ
         KbtXcOxmTfYyJ6XRFxwE3eC8PBQZfmJY3jGZhEV5Q2bjRkD29Ft0gtilRJOod3AeOhga
         yC2cTzbdiMj88A6f8QdgBi6tzpKw0zUquSDS6o7L/zzZAxKwKnv0JO4xPelfJHzfwQdy
         rrZOtHZYxltEYlXce4PD/k2eLZQjuA3WBsg2s7o154tgJD45VAH5HKbV9XbX8u19fjF3
         0V+cphrp1EyndLcDfyFId4a7OE9S+DJOfdiITqj8OLLg4AO3IyFyWJFEUCg/qe43pje1
         LW7w==
X-Gm-Message-State: AOAM533Zj7byXS+/sXGUvqkD+UwEnfnE50Kc9wwqWTfwXarmCZlTDK2M
        anzm6IQt3JIQkiZ9hSfq5/A5TaiHLaMVgA==
X-Google-Smtp-Source: ABdhPJxcGNfJM1qoYqtN8hzaJAWk6fODQ6qJicUk+aq23Cv/V0CpmV8cqsQSUTETOoBV1Q84lo69vw==
X-Received: by 2002:a17:902:c407:b029:e7:2272:d12e with SMTP id k7-20020a170902c407b02900e72272d12emr21804963plk.52.1617585718333;
        Sun, 04 Apr 2021 18:21:58 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 34/48] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Mon,  5 Apr 2021 11:19:34 +1000
Message-Id: <20210405011948.675354-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index 44c77f907f91..b12bf7c01460 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -133,21 +133,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -165,6 +160,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

