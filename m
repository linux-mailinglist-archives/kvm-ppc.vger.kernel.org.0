Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11153E9576
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhHKQEd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhHKQEc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6370C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so5727888pjb.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2i616JlEKtPLceUUCFltWk30KazQ8LPnIgBLdHO5H14=;
        b=CZuo5gIZ+d9XJdBV2l4Eqoug+9wAhSYuKmHY9WQYzDdKB0iVAK7tJdg/WjNzobpLVH
         o9ZjSEHGEMobaee8lcbVew7w4ShhA3c1A0TPjc79BjBh8SVs4zb72gnuxCye8BHq9mxX
         gCNJrJjI2cmW+PJ3akMB9EHgZ8skP14p7PXSL0wCsAKZasVZOYC/LrtgKuFE6YNvJUmZ
         6Am+tNx0Qo3yim22R8paWEG9OfATSJS4nPiK/37KTTzxsbV1yxjNXM6Y2sgssWmWRm6R
         JV4vowG+WO7RQfQm862l4s8RUO+dnxYR01owbdms+rdKg74XEtjJG3DfPA+dzgXjLCxQ
         w9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2i616JlEKtPLceUUCFltWk30KazQ8LPnIgBLdHO5H14=;
        b=b5b641mViJitjJwSINKf69aSuSAtnx5ZNNCnkRk/c0NcqVY/eiEWa179e7voTQyaCp
         cKaUV+kF7ncCEd59TtTU9yF1MTbAA8vvT/fm3p7LTqY3BCwQud7jECOjrY+Wg38V7E1R
         q4Fe4S0zsvG0H0RjfP9pTZuceO8EK8kmW+xKAf/HUQRqiTifAZXaoYbA9lEEsriZLKoO
         pwzhnNemKWYNXfGm7kFaij9DlIZ8t6E9n8O21WabEyFxD9s4/i64ptlIwQ0a1acA2+pI
         +p7l82WsQHeSaSLQOB1rvpbdA5uPHfRGBoPIrXFTumbvNh0lGTX3lT9wAF4hBZFPKrSF
         tr9g==
X-Gm-Message-State: AOAM531GoVmAIWAL4ReN569jZ2Oiv625JEPfzFzg09wKL1FKmDk58Nse
        ROTeLmA/s7DOhoSvtxJsR0Xcvye2jFE=
X-Google-Smtp-Source: ABdhPJwWHrCBicsMfJQly5fMPBDZpgAcu/r8DOPamVr3DJWzXGqzOze/rDmlNx1fL1MvoZPVKTSJrg==
X-Received: by 2002:a17:90b:1d82:: with SMTP id pf2mr4146868pjb.212.1628697847217;
        Wed, 11 Aug 2021 09:04:07 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 55/60] KVM: PPC: Book3S HV P9: Add unlikely annotation for !mmu_ready
Date:   Thu, 12 Aug 2021 02:01:29 +1000
Message-Id: <20210811160134.904987-56-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The mmu will almost always be ready.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 979223018c8e..d3fc486a4817 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4399,7 +4399,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
-	if (!kvm->arch.mmu_ready) {
+	if (unlikely(!kvm->arch.mmu_ready)) {
 		r = kvmhv_setup_mmu(vcpu);
 		if (r) {
 			run->exit_reason = KVM_EXIT_FAIL_ENTRY;
-- 
2.23.0

