Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62424351DB2
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhDASbm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238907AbhDASUf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:20:35 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA1C00F7C4
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:21 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w11so1160286ply.6
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6HGt1pa4lw5NCECf9jcYilrTKWgWaQkMBLbkdgvbSzU=;
        b=UL063ESDaetizihR1x6Z8QYrvRMsgagWoj54zTtxRPgj/jXknACxbFhfq1piuz/Xo7
         PYqDRwq24Wy5TObjFxLDhY4XP7BEjwZlEfVuUInnXnRTarZAgTRdy3aG/OlUo5MQE0h4
         tX3fokHmrgT2EnAJzXuX0FVNtxzTS8Xi/bZDQKNKZb61D2w0zDpAEnjKmakyy/BgA1nz
         fQeDHb3hMixTVy4cRP2+TviXzSEjt4uGXbLJE9bMVpWduOCKl+xPHC7hDJVcBGb3bQut
         O+XkD/BN1aUVaHP7c6fMVHawozfR5dNmNiKjn+Bd+xet411UudNxLWry2zYhjwgzec7S
         A/gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6HGt1pa4lw5NCECf9jcYilrTKWgWaQkMBLbkdgvbSzU=;
        b=ndNMn7qqFQhus/RS/g33COv7LUjZs0d147QA8zTBP3fhrKB1fIfbG8cZWHHT5U43h6
         x/COO5h9RPCNMc6TCgkinhuleDccp+WLnGz16V7CfxfC5QQl5SGWZgT7WmVRVJ8IOyJd
         UO4JCyN34t9zPZB+t3bW0tQ71GHXG5JOKr4ETyzj7G4l9bkmPHHbaQ3XMLnriQDh4xb+
         lgPqrzPMyGJVuqKCd3FwpB5pf7If57c/Ou4WAastiEjrfv6m8/y/xagmQlOC8IFFubs9
         Q3uej3Vcj0La9jg8UgS3KfPXEjtwAASxteU5PH9VANDxqK2oWmVT09eAsOtOchR6w0r3
         rEcg==
X-Gm-Message-State: AOAM531I6A/6jDwl1AicxrJPS8DYDKM7bax7cWY5+aE5iAt4MfWhjBh/
        6dPTI6Jgku7y46cDOKfg2/SE4FKOc1g=
X-Google-Smtp-Source: ABdhPJxyQY6etD1TI+8X+6/TZvuyFgXri8vMVp2lw4Hqoxh9HiSAKhQAkNRv5hPjoQc/X+B63dqLFA==
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr9453032pjr.228.1617289521273;
        Thu, 01 Apr 2021 08:05:21 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 34/48] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Fri,  2 Apr 2021 01:03:11 +1000
Message-Id: <20210401150325.442125-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index 62cf0907e2a1..29e2ae04b8d5 100644
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

