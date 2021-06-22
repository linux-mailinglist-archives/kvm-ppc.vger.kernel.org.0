Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4363B0219
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFVLBp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBo (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:44 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BEC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c8so2261144pfp.5
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+1GsA6ZmKD4nmYQtf9IKf0wEf4lVcm4Be7DlE4qj3g=;
        b=f17RklGlBCUwmnePSVpnLp8kFHodpXukg765daSsJYKtkMlSuGKCxTPzg0Dqzgba/Y
         8Sq3HSjS+884sLZiRdTxv51TKtdlFockH5nV3qfTl6qz53tHHUUcmROGQnN6zPe7w3gp
         jdAQy8KSiWRxQdWIOiafHFrGcPD2h/i3fEdMxvwQpF8BoPd5UlJfGqUdtKaQZnQSORxE
         pO6M9Nn/sLbVRkYToN34zzYiLNUiaMsVc6JP/8H92CkgF0Wpw+wjn4IXlCE4u//EMKrv
         xphZCgMQ1mJ6+N26HmCktOChdhqrWmUANzc0/CoXWV7KlKgoGEdzL2OeHExG7PrSszPD
         vo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+1GsA6ZmKD4nmYQtf9IKf0wEf4lVcm4Be7DlE4qj3g=;
        b=sJsnfL0zai4Peuge71t3sje59KoobptQlYDBziF7LggyFqAvIEpQDHsRI7egN5alpM
         uRtWpnUG0Sj5VDDAzqepuVB1c2iGN/Z3y64mtNOgALuB+juvRACRcXIwpPC8SNh4DCel
         oqtREclPFqrsbG7/3lI0Xxyfqn8ABCWCQ6NPsJEJQC61rrWSOJj3py4nbn+K9f1iSoz8
         zYU/P8KWngsqMwXUPGFk2ZjEukdlJ0k0MQe7EWyfDBYFXZbzOo+6/giFSQKspCqvhDvy
         g3Gssbt4x+X44F+xPq5oCYE3iKi+t+TNAYylDf0dhOLw2mMWFAz1AFqNKBubpmzGpivK
         /6Dw==
X-Gm-Message-State: AOAM5307R6NGVkTCLcCZp/+EKMoyFkrZwryDevm0sINkElWak3rc7DXJ
        kleluCA3bpWjlPIhjr45g+G6d+yL0c0=
X-Google-Smtp-Source: ABdhPJxDWavWUwUySm81FjkOyf58wBP6lQ3kVLsq4wedDamjPrqD4S3WBeiFtG+0KyaXu4Xzy7RAsg==
X-Received: by 2002:a62:d447:0:b029:291:19f7:ddcd with SMTP id u7-20020a62d4470000b029029119f7ddcdmr3129358pfl.54.1624359567973;
        Tue, 22 Jun 2021 03:59:27 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:27 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 38/43] KVM: PPC: Book3S HV P9: Test dawr_enabled() before saving host DAWR SPRs
Date:   Tue, 22 Jun 2021 20:57:31 +1000
Message-Id: <20210622105736.633352-39-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some of the DAWR SPR access is already predicated on dawr_enabled(),
apply this to the remainder of the accesses.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 34 ++++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 7aa72efcac6c..f305d1d6445c 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -638,13 +638,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	host_hfscr = mfspr(SPRN_HFSCR);
 	host_ciabr = mfspr(SPRN_CIABR);
-	host_dawr0 = mfspr(SPRN_DAWR0);
-	host_dawrx0 = mfspr(SPRN_DAWRX0);
 	host_psscr = mfspr(SPRN_PSSCR);
 	host_pidr = mfspr(SPRN_PID);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		host_dawr1 = mfspr(SPRN_DAWR1);
-		host_dawrx1 = mfspr(SPRN_DAWRX1);
+
+	if (dawr_enabled()) {
+		host_dawr0 = mfspr(SPRN_DAWR0);
+		host_dawrx0 = mfspr(SPRN_DAWRX0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			host_dawr1 = mfspr(SPRN_DAWR1);
+			host_dawrx1 = mfspr(SPRN_DAWRX1);
+		}
 	}
 
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
@@ -951,15 +954,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_HFSCR, host_hfscr);
 	if (vcpu->arch.ciabr != host_ciabr)
 		mtspr(SPRN_CIABR, host_ciabr);
-	if (vcpu->arch.dawr0 != host_dawr0)
-		mtspr(SPRN_DAWR0, host_dawr0);
-	if (vcpu->arch.dawrx0 != host_dawrx0)
-		mtspr(SPRN_DAWRX0, host_dawrx0);
-	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		if (vcpu->arch.dawr1 != host_dawr1)
-			mtspr(SPRN_DAWR1, host_dawr1);
-		if (vcpu->arch.dawrx1 != host_dawrx1)
-			mtspr(SPRN_DAWRX1, host_dawrx1);
+
+	if (dawr_enabled()) {
+		if (vcpu->arch.dawr0 != host_dawr0)
+			mtspr(SPRN_DAWR0, host_dawr0);
+		if (vcpu->arch.dawrx0 != host_dawrx0)
+			mtspr(SPRN_DAWRX0, host_dawrx0);
+		if (cpu_has_feature(CPU_FTR_DAWR1)) {
+			if (vcpu->arch.dawr1 != host_dawr1)
+				mtspr(SPRN_DAWR1, host_dawr1);
+			if (vcpu->arch.dawrx1 != host_dawrx1)
+				mtspr(SPRN_DAWRX1, host_dawrx1);
+		}
 	}
 
 	if (vc->dpdes)
-- 
2.23.0

