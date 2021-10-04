Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E07142137E
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhJDQE1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJDQE1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:27 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD91C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:38 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g184so16990328pgc.6
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AdZU0vsaA7eoEc1W7hEx0HHSrDx68parS+Neoj58wvs=;
        b=FuPAPdd4AuCMzRlUAw1cO3YyYFfbBll4q/e22WAjqphgz+yORSeWc1whfUX0xYO+tG
         b2fJBd5sSqXGF9cwPjM+mxuP9lZRwwEv37XVnMSAmk70ENRjTJcbH8cJ8ykv1VfGAWMs
         K57sksAIEjAPB1iZ6eutfhzrFodokQQZ5BR8YF3ftYXeNF2cRkWImWzOgTU28duvo41K
         3VgexiwLGFSHBo2oCaNpSkrEgllgmK9GlMfPI096srSoWquBbSngcT4SWa0vOIa0pNcH
         HQny8M7qI7TOfdduBacS6aF1UFWF8WkxQhUP9rFgFTd9yx41LeMTWvLT8ggzZppH3TFV
         qJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdZU0vsaA7eoEc1W7hEx0HHSrDx68parS+Neoj58wvs=;
        b=xqY8PjC06swqr/8bSbnr0yfCQhdo7FCBFBTeGAp++cFjFoViO7q/x6LZZyZcaVumEj
         pbpzICLjef3wvZlX496Ze5nMx9DtGGU0/ibM5x1jmTuVrZzDUVn0aT+QU9tVYV/b46Ov
         UocKbe0o3trt/jA3F3dBh0FoxlgpveVdVUwGQSofQJZnUVllmD2OLNqhn0sq2RJTvm/W
         5/9tTDFynFiw9DWmw4FrHz6MDk9kd8UqO2wjoBknTMfarKttQZbt4QMDn6BjROw2s0BZ
         gegFyUnVCsZb42fgcyjIqD4XSOZm8GslRcVYPZ6ePBcbqnLUeV9UED4ENOBHLTWu7bLJ
         aBNw==
X-Gm-Message-State: AOAM532dK0XeXigKhSxPCLTxIcWt5DEWQSBmFGRcXtVtW3uLDe8lf1qL
        RrDbkQ88cyNxyVrsKLyiXz8tvIRjkks=
X-Google-Smtp-Source: ABdhPJwv7mubAZbz9fLyx8zI6rdNmj3T5moHXZxRqMNMlkCpzygbuyOQ2xtOyp4IrySG5p75oaTEHA==
X-Received: by 2002:a63:dd51:: with SMTP id g17mr11486439pgj.47.1633363357835;
        Mon, 04 Oct 2021 09:02:37 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:37 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 40/52] KVM: PPC: Book3S HV P9: Test dawr_enabled() before saving host DAWR SPRs
Date:   Tue,  5 Oct 2021 02:00:37 +1000
Message-Id: <20211004160049.1338837-41-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 323b692bbfe2..0f341011816c 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -666,13 +666,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
@@ -1006,15 +1009,18 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

