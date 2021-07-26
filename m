Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808D63D51D3
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhGZDLq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGZDLn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69774C0613C1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso5068803pjo.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSmVzL4c1YQEwgpeygYKTRCpdKgworBmM1lrd2e93zY=;
        b=iII4mvQZd7A61sKYSg5blG9nCxBOJkE7sLfMABwTu+6BvfEiPRQODXjf/zRpZZUqBy
         xJEwiYBOK6WeH4DEmYUuc95c0LnX3lvLzuy/7aXLaG1xWcZ2VCZxIgikJbjK8IvCQFos
         p2QdHepyt+z9gIkROglukNYu7WB5zmckhYpaB1Zc3p5+f1YdpFYzDG9Ykis1pc1H+2EK
         IVHqcGdgwMR7Hlqdre0sov8ELYbcpStB/PEvYzlSa8ym0+cslmpFkNWKmZpck686B0ia
         upCOoaAZEBD00wC2/r5hIYldjrJRFh9u3/mFpERSI1QqJvA8lcDVuquCEb5WML3S0fbP
         VEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSmVzL4c1YQEwgpeygYKTRCpdKgworBmM1lrd2e93zY=;
        b=lY+nnCyPjfVzgMf5AcZ/dbHlGdKymOg4lO6XN2epAZQqrjwpnG+Ai7Oyq9XMSMt6Wd
         Aw1DNSQUo76wVovEupCGNhYOghhZVHNV+dXVKU/0TTEBviy7H+/0df5Hpr/WCiF2wodR
         zlC8ELbvwvb9GpppKnWidGDkIjjAt0UmiAcPsA6ioar6LFt+nbprL/nqE3KhrtnQlnER
         s5A/6uppMs3EFOYc7VHKNPNpXVBMz/VmiNKG7OPtfpvJ5WTIXm/1JbREzFnWCogwomcV
         XWZVbeJ2L1WxRZ/BwtQA0RAsS2qVrlGnK4o5MNT9rgiR5JcUZLGkhFiMxaErHMKstj+4
         8JcA==
X-Gm-Message-State: AOAM530sQgjvmrsSW7gZg9+TFO0Qk2fq+7OGkCK9c3IcfGWB3aAMHea0
        +rxF1tY1gxvGAqbKzr+wUXUZaPRV9i8=
X-Google-Smtp-Source: ABdhPJwqbi7Bm1VNXw0rR05N1QF7VUxQw7HRIu5SUrB3z0DuugVhc7yinaOnxi7co67WY/jHhzsJiw==
X-Received: by 2002:aa7:978c:0:b029:32a:403e:88cc with SMTP id o12-20020aa7978c0000b029032a403e88ccmr16006240pfp.7.1627271532915;
        Sun, 25 Jul 2021 20:52:12 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 38/55] KVM: PPC: Book3S HV P9: Restrict DSISR canary workaround to processors that require it
Date:   Mon, 26 Jul 2021 13:50:19 +1000
Message-Id: <20210726035036.739609-39-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use CPU_FTR_P9_RADIX_PREFETCH_BUG for this, to test for DD2.1 and below
processors.

-43 cycles (7178) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 3 ++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e7dfc33e2b38..47ccea5ffba2 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1598,7 +1598,8 @@ XXX benchmark guest exits
 		unsigned long vsid;
 		long err;
 
-		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
+		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG) &&
+		    unlikely(vcpu->arch.fault_dsisr == HDSISR_CANARY)) {
 			r = RESUME_GUEST; /* Just retry if it's the canary */
 			break;
 		}
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 737d4eaf74bc..d83b5d4d02c1 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -671,9 +671,11 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

