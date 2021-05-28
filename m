Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1E393F7B
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhE1JKm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbhE1JKV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F80C061760
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id l70so2076457pga.1
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=93ZW7UwUCAB4MEfJeaOXKnfYp71unN3wnqawYPiJ9mA=;
        b=bo4LQUmsJGNUIfBjNCZngm+LdbHqPqk8bYULOyUhXGT11dgYrnGZtZdJ4v/EcmK6l4
         F6cVBiupBwKBzfw7m094hA2/UPUclcFfO3izMikjKvzfadiUHE9cZ1MbFfFkySVo5o66
         Hu0s6LeiVQiyv/Q3J9+Lo93VvEgUMuCtoHyjq9tWkTIVA3wuPO+jOYNa11g3ZqLoYqnS
         WRxVVI2QBnSd6KuM4uhKP8jlP9E2spPN6WvxO/DWccyj/tO/UjQYWogyUwo398p1xxjy
         8aV1Nf6qkR9/e0waGQzDMwlH3Z4ySHUKIKKzvh/cFYACM8xIbIJfNVScqENImJQz9ILW
         libw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=93ZW7UwUCAB4MEfJeaOXKnfYp71unN3wnqawYPiJ9mA=;
        b=NKvAMqIvQ5DLmNmr/uTDqk8BWa8KfnV706R5+1MjDFY3x5TvDMwPE4NWgyR1+jdCtz
         kBC5fQwUlmWwdeTxx0CCgQL7W0141wYwv3g+KdRTPTYTH6vkE0y+keEQrhSVxjDMJLj1
         1KTs4anRQYGNEbq7doWIv5HPcdJXaL9KbyDeoW3udtjazKO0LvBTp/G6JMpng0C2Qh7c
         glLAzoTvYanb2bu3lcgKjzUDeIs/2FSa9Mk2ADF6dQ4sy+2jPQ/+4O9yTtDnRnCnISMs
         IrJwXRtIYfkwJLbAYpNKn2Vke4tUrVhqoyyFuKH5RfJOlAjsxcs3WcXnWyxRxZR65csN
         mTAQ==
X-Gm-Message-State: AOAM531OuEmdvaD8YY8dTUwFghOFvNZMVjLY42X7avOWvFWW0xdG5866
        qao/zQlMDXjAFNZYGY9igKTL2DlaNrY=
X-Google-Smtp-Source: ABdhPJwpZQuGNq1wy+JMPK3nQ1TJsPutRmULuFbJtHA/3IbKJQdCJuzbvhT6NUxd3qkQxkuUg7Lvdg==
X-Received: by 2002:a63:5252:: with SMTP id s18mr8008613pgl.229.1622192926205;
        Fri, 28 May 2021 02:08:46 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:45 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 18/32] KVM: PPC: Book3S HV P9: Move SPR loading after expiry time check
Date:   Fri, 28 May 2021 19:07:38 +1000
Message-Id: <20210528090752.3542186-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is wasted work if the time limit is exceeded.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 36 ++++++++++++++++-----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 8a56141214c1..f24a12632b72 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -123,21 +123,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
 
 	hdec = time_limit - mftb();
 	if (hdec < 0)
@@ -154,6 +149,19 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

