Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1693250D0
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhBYNsy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBYNsx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D740BC061793
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:36 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id a4so3788436pgc.11
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4wpRUIXYsph30RZ+o04YHt9M47A98ys3vHV9XOremLs=;
        b=oEq6KFmHXRFXCmls+yOQT9IO5CWXZ8JmfrXrz1qZvOOvuCFPvSWwvnMUfjvlaXcWnM
         k7//repmAwqZY2KIyLPmjx5+ciDhQP23uZ9UQycPgelC3yaUnX/LsJiFI2nsUwpRnwIg
         kwHUVq63k15vh9zvYWG/Oqs2ZxBuBptilpvff3t0ODpz6qChGSNE0hcvZPxekx5e8Tde
         fA9VCIsCi3xotst0DZCD4gSJu0qSzwTVXv4dKCba4BT3iqOio7uABDRUuksSOmpSrqBU
         Ehn7X/0gjEjvJrcUUfMUsttC2cdxxp9ugQ5Be2hGRxqH5oUqDUtkl94/3SIpWugFU3lw
         I0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4wpRUIXYsph30RZ+o04YHt9M47A98ys3vHV9XOremLs=;
        b=JbbNe32DQZoMtks1yhuBM/4gdq3FcquePGUcxC4+UwN9oYn9/IQBwSxVejT+TBrnxT
         CFMtt1dNbIPus/9bdf8GvndfFKbri/yX0EUI9tBs/IRI4oXrIubSbGMsWqKBYac0kWFa
         pXDeErjlbNGuTdv+sh81oJVMnKk4bTWN+qPOlSnxRGA5OK6zHxdAOEQQ4BVgFe/frsoK
         5htaPVehmH4iPyJ553f6t+upZne7azGUCY176jl6qSv0xo9uwGZCT4AnMZlzBkr5h1ky
         CiKp3w+q0zIP2aiknY/B12O/uL6hwNTAyCAUDjrVPmACNBeeTY6ltREI31irpA8E1ICX
         +H8w==
X-Gm-Message-State: AOAM53347TQO2B0q0WKxWstafzKi9jo5KD954OD29QVS9OTBSOuc/ElW
        otWBCWWcPE83C3gB0QMF3jyqHYVijkM=
X-Google-Smtp-Source: ABdhPJzooV747wcG/f0eQ83XVGXoIqrpt9BT1iLlSxgTTidzwjL+5hbDniMdc1wEKts8PZDfFFnsFA==
X-Received: by 2002:a63:df01:: with SMTP id u1mr3052930pgg.341.1614260916109;
        Thu, 25 Feb 2021 05:48:36 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:35 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 27/37] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Thu, 25 Feb 2021 23:46:42 +1000
Message-Id: <20210225134652.2127648-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is wasted work if the time limit is exceeded.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 38 ++++++++++++++++----------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index 4a158c8fc0bc..dd0a78a69f49 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -126,22 +126,17 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	s64 hdec;
 	u64 tb, purr, spurr;
 	u64 *exsave;
-	bool ri_clear;
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
+	bool ri_clear;
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
@@ -159,6 +154,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

