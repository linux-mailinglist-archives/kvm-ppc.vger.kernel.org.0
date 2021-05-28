Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACE8393F7A
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhE1JKm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbhE1JKS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:18 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75906C06174A
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 27so2063433pgy.3
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdLbZJS4H0W1njTybYNPIOA1CAvkdKw8pFhNmZNlDgc=;
        b=CxRW/bwzuRp4pnVGfmnBrAv5WTPlkXtoTlUCYPO5TtpoJWSLAtBbOtuJGyYpOcWC5d
         ZMqCqhzWf7lZoQbsOF5vl5bbpoQBNJ0qnUVJh69HH8bF7xOtscD2bKCsnIIIXqJQYJgw
         9fCVu6QJ2Q4meMic5WYtSvY1eWp9y1vIFGOKBRT+j3xmRYN8jrWNFy9kwskG6hwk/glM
         wUItqhICqWnTa+woOjtFi2Qykgc4iznGmUVH2XQHd0OBifat9bQRdPcvmb08qisA3CIH
         p6OGV3HCtLgODi47cFLbv5bTvdsAoZsGZuACKWSRf5ZyyaTe9gcyf83z+Qhb3TQ6b0x6
         g7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdLbZJS4H0W1njTybYNPIOA1CAvkdKw8pFhNmZNlDgc=;
        b=ap47mBsvGRPwy3eMmI7N/FvpAMfbYs3NV0MTfLcrdmyvUiEpKx0p0u0q6hBZ44Vl1r
         LWujYH80BYfxbtEutkbb/DF6LB6YPgiuCgomRZXO6MxsyWbbeLvaZQ4mjKDhOdLMFczp
         ii+1kPBAnq3pIW2WxzU1TjGlZ+Ed9/ZLycDjXK9xrA5NX/dfTP8kqARoRoEa4rMbIwWy
         ZX8sOpnuvi5q/MPT+wIFtCwyn5C5eZms/Vx7rM8qf3ZQ4ESIU5YWXfoUAaSN+eCYrpyZ
         MyyvcPWVZoAfi3EJ3tO9LedjTWGmN4lpZCH3ftFjePKUDiHagx29/NWjXV6fokht6cvy
         mfOg==
X-Gm-Message-State: AOAM530SZggioPuI7Qs5ySInC5+DuuXZ+5rVROvPPnDpF3QgvHBAL+Us
        J9MzY7Gre4phz06Y6WJpG4JXkThisM0=
X-Google-Smtp-Source: ABdhPJwaqblBBBesmw0zpFCEBdwfYIXQUcsUWiWn/kxdQeQIR4uUWz2YEWRm08qc+4f3LWkKaSgUWw==
X-Received: by 2002:a65:638e:: with SMTP id h14mr7967807pgv.108.1622192923911;
        Fri, 28 May 2021 02:08:43 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:43 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v7 17/32] KVM: PPC: Book3S HV P9: Improve exit timing accounting coverage
Date:   Fri, 28 May 2021 19:07:37 +1000
Message-Id: <20210528090752.3542186-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The C conversion caused exit timing to become a bit cramped. Expand it
to cover more of the entry and exit code.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a6f89e30040b..8a56141214c1 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -143,6 +143,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	start_timing(vcpu, &vcpu->arch.rm_entry);
+
 	if (vc->tb_offset) {
 		u64 new_tb = mftb() + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -193,8 +195,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDEC, hdec);
 
-	start_timing(vcpu, &vcpu->arch.rm_entry);
-
 	vcpu->arch.ceded = 0;
 
 	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
@@ -337,8 +337,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.rm_exit);
 
-	end_timing(vcpu);
-
 	/* Advance host PURR/SPURR by the amount used by guest */
 	purr = mfspr(SPRN_PURR);
 	spurr = mfspr(SPRN_SPURR);
@@ -402,6 +400,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
+	end_timing(vcpu);
+
 	return trap;
 }
 EXPORT_SYMBOL_GPL(kvmhv_vcpu_entry_p9);
-- 
2.23.0

