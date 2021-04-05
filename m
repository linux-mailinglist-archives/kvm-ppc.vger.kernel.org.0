Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF2353A9C
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhDEBVX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhDEBVW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0EEC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:16 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y2so4928608plg.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0MvDZ1F9X/SZ94TT66c0+OApX1YU3GVKikmjXf/RuQ=;
        b=F7sn4PNtawZZ+0n4PkDaXml8Zr5ys7vuudGUP/2FwhYXAIbyXJliCSpcFYCnGYCYXc
         KJHx7+6GqcS/ZQgOxTYVc7Fn3HF8cXskQrPVL3mKu9G+qF4LSkfF3VMle+B70Ne3G2Wl
         PT7qdEeG7Pg3JfXUhCCvKMNvdSzH7BT9Rq3I/2YXO9FYO11PfKv41AuyOMkJuPby0FdV
         TRwJSfFNiRSGzcc4t4jIUYx28I0VJnLfbv5Z0/oyPwPt2BwVk2PXSz8/DAMf1ZQO7zeE
         KLm0gdKr1dg4SXO4ydC3vkrYmpfEVzO47cUsLaCo/muJAZpcdDrOx0cmlsI3qaCpOmRU
         S0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0MvDZ1F9X/SZ94TT66c0+OApX1YU3GVKikmjXf/RuQ=;
        b=mlD6V7iRZT+G9C0pzKDgTGzuOR1dAnYq/bH9lICJ5+hZDKyTsfRzrbXbftzEnc5Zvp
         RYCyDXEA/zUaQmAmmTaEfqgaWq+7tOHJFPrHew6IAY8+rsecIVCfj4UJOKcPAud4noVm
         UBIDTugMWiQNuJvZUnq1vLc8id+Y0zafxvCPVERVgHktItdgXsk+NBkNi0Z9NL5HMIMU
         RT2g5FhK4t+a++ZjxnzN+qGlftlRGZOAfmyaVLI6c3O7ZnZtt3vzpEw/FvvxBmCOTItg
         jv/zJa4YceazfmRP2UVHLjE4vuQbultQCsnMLinob0DsV1Sy+WBhj/X2r53bRgOKW1vJ
         hhFQ==
X-Gm-Message-State: AOAM531JELGLVUzpIAQnMtRdc/k2skdshHkFMEUMbqHsDk5umt5Fi6sF
        gbGUSIoeNtXOGMPXwCL0JfOWU9c2ghM0KA==
X-Google-Smtp-Source: ABdhPJwtPrpV+zXiV4XPpDvj9qVH5USq3fAtYCWCwwtYuSrsWHqeWpm1iPvPJRRRGaU3gWu5FoOdMg==
X-Received: by 2002:a17:90b:b0d:: with SMTP id bf13mr23848251pjb.7.1617585675964;
        Sun, 04 Apr 2021 18:21:15 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:15 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 21/48] KVM: PPC: Book3S HV P9: Move xive vcpu context management into kvmhv_p9_guest_entry
Date:   Mon,  5 Apr 2021 11:19:21 +1000
Message-Id: <20210405011948.675354-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move the xive management up so the low level register switching can be
pushed further down in a later patch. XIVE MMIO CI operations can run in
higher level code with machine checks, tracing, etc., available.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6ca47f26a397..2dc65d752f80 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3598,15 +3598,11 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 
-	kvmppc_xive_push_vcpu(vcpu);
-
 	mtspr(SPRN_SRR0, vcpu->arch.shregs.srr0);
 	mtspr(SPRN_SRR1, vcpu->arch.shregs.srr1);
 
 	trap = __kvmhv_vcpu_entry_p9(vcpu);
 
-	kvmppc_xive_pull_vcpu(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -3789,7 +3785,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			trap = 0;
 		}
 	} else {
+		kvmppc_xive_push_vcpu(vcpu);
 		trap = kvmhv_load_hv_regs_and_go(vcpu, time_limit, lpcr);
+		kvmppc_xive_pull_vcpu(vcpu);
+
 	}
 
 	vcpu->arch.slb_max = 0;
-- 
2.23.0

