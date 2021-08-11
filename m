Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1593E9567
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhHKQEB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhHKQEA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DFDC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so3262416plr.12
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/uO7fK/ax0SJRwBtePDjtrqOVVG3TZBN5bKm0iorBes=;
        b=dgY37+ZO0KFV8f/X0uji62/5wt7HJc0rsRWa9GgQ4A1k6v1He4ROiguj+2EC5/pcRm
         NqDQFsrWnGgumfzWgjItDr4B/gj4/vCqi+jDeETvhMgxS5XjllMPZG/labRd0IeQw3x6
         aSg59ivgJXB4qwnnTCwOCt2uf2UpFxdvX8LARQedZRLDR34sb+t2yNahAzoil9J7xxww
         xO5YuiN1ojVvoNu15wrXjGSTIfnJ9ua8JAO4nZWP0OHpsWzoeYHFKHGYwDIXtr++n5Em
         aYE9fizIuoj2NknLva3F1pfdxUkT2Znwh2YrYNfYA0oWH9beGUaED71VSJ6yzsrKqCRa
         NvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/uO7fK/ax0SJRwBtePDjtrqOVVG3TZBN5bKm0iorBes=;
        b=X15fxKJuf6QTiF97czO6zZkzTWGAZJ85qMLhbqze2wG1ewsiu+oemen6F5Tuu2OLKu
         TW3LzDHqor7jSYCalDaV8+LyA+PrSkZ60vS1DrPsC96raITlvJ0veQNOC4cFTw5e41T5
         tWk8qANgThS2eRVj5uR7hq9zEth5cY8aevqgOoDmqoWYnpnqAG+KuodACLjvBXR8E1fS
         /UuZIRCRYwb7gIYx/dLTioSwAWqN/zfF1l+Q9SaGyac9otSX0IyG1mZZ8kBIvFEYD+sC
         QxAfabPz/8Y8Z7FvCm7IC6ExK9+eUFqO/LZxxrbXS26l9k/9vpxyDBV/tv+2OJ4FeDrp
         G7zg==
X-Gm-Message-State: AOAM5307pReBAm+CAHcbe9aw6ONQtWrNdw8viZt5Ul82EC8V7ZdvSSds
        G5ByyV74KLj23v5G/AAq4FsVyagNM3s=
X-Google-Smtp-Source: ABdhPJxtzgvDTQuCTcRgYnIN7pZsE7yXgv2IhyBUHJf8+vFhQW6dTqB0sHxvEz8D59vd932NRLgUqw==
X-Received: by 2002:a17:90a:4481:: with SMTP id t1mr38074543pjg.232.1628697814599;
        Wed, 11 Aug 2021 09:03:34 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:34 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 42/60] KVM: PPC: Book3S HV P9: Restrict DSISR canary workaround to processors that require it
Date:   Thu, 12 Aug 2021 02:01:16 +1000
Message-Id: <20210811160134.904987-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use CPU_FTR_P9_RADIX_PREFETCH_BUG to apply the workaround, to test for
DD2.1 and below processors. This saves a mtSPR in guest entry.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c76deb3de3e9..8ca081a32d91 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1593,7 +1593,8 @@ XXX benchmark guest exits
 		unsigned long vsid;
 		long err;
 
-		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
+		    unlikely(vcpu->arch.fault_dsisr == HDSISR_CANARY)) {
 			r = RESUME_GUEST; /* Just retry if it's the canary */
 			break;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 48cc94f3d642..3ec0d825b7d4 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -679,9 +679,11 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 * HDSI which should correctly update the HDSISR the second time HDSI
 	 * entry.
 	 *
-	 * Just do this on all p9 processors for now.
+	 * The "radix prefetch bug" test can be used to test for this bug, as
+	 * it also exists fo DD2.1 and below.
 	 */
-	mtspr(SPRN_HDSISR, HDSISR_CANARY);
+	if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
 	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
 	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-- 
2.23.0

