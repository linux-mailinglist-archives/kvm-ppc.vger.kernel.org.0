Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4B23B0218
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFVLBm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321F1C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:26 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c15so10167179pls.13
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUzaj3ou1GO2NNNnuj5/I2wDiFVQkUTWC6/PNkNyxk8=;
        b=s5dXxDXl9r4dJGMNKTA2/SVozQIrYdO2CQCqy7/1XUQX1I6OjD4hf1scTqvfPUNASg
         6KDFpLRjNHX1glPMzBMJzB0yGtLYmeEiRG3E0yyHMIrPsU2ScwfEf2eJWwXeH2bxkABJ
         VfR9mqDiQTRL9iofQslV02dJ3paE/F3eqGT6K0bIpxy+atjX6mvHynUolwzc4RZc6c3N
         9EXbKAdpH1alBLp7NzhU3Wlp4lV2HT2cI2PhBvmCc2u1LEKmtdbhRee1GmdC6HrpTQz3
         WcYB/jQAtO/GBqQcCxXamnBU+gBpxBBM6PzyzNa0hxVrlxaW29arh2X1bMzgsjH2/W6o
         /yqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUzaj3ou1GO2NNNnuj5/I2wDiFVQkUTWC6/PNkNyxk8=;
        b=qPEYmnVDtVJzlFfCj3gPKpH7Erbu1S+fzD6+DMulPXz0udAHTuiPKnvQdL/NUVd/2j
         9jEnbfIQ1VtpGq1JefFWl8INUPpVYocdRLEk3KJtwDuoNF/4+I6xacNYwiUVNnvLNGHC
         QwgwTMfXQgp/22X3B5Grwc/q0hvy4bIJgXtkNALvZETSssyKh6CXvz4s16UdEdwwUhyZ
         Rf2aG9iwFWvgOGIbKOlKdkUbGVTpZyTbc+yIWeyecsYr073ejiz/FZs3HaiV6f617Hsl
         7JXlObk5KZSo3C05mVEi81Y3Yqf7V2P6ZbeT3sXzTVvgBcAR5a5wAFYE0ZOjGBg/lRbn
         vvxg==
X-Gm-Message-State: AOAM530YizhoQf5PmDvjoOeCp78/zlekNbqlDJAPjnPHIEkoyecOXjxj
        1WBpHTk8jYHvMgnAhm2l3Y3v1FUxZYI=
X-Google-Smtp-Source: ABdhPJz/BlKlTe8dkJTTinukuFFoQXWOFhqJEg9MaiXsO/sN/is8rdosD4OxcFhmPOxt3jmY15ZZbg==
X-Received: by 2002:a17:902:d694:b029:103:ec01:12d5 with SMTP id v20-20020a170902d694b0290103ec0112d5mr22300383ply.19.1624359565584;
        Tue, 22 Jun 2021 03:59:25 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 37/43] KVM: PPC: Book3S HV P9: Comment and fix MMU context switching code
Date:   Tue, 22 Jun 2021 20:57:30 +1000
Message-Id: <20210622105736.633352-38-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Tighten up partition switching code synchronisation and comments.

In particular, hwsync ; isync is required after the last access that is
performed in the context of a partition, before the partition is
switched away from.

-301 cycles (6319) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  4 +++
 arch/powerpc/kvm/book3s_hv_p9_entry.c  | 40 +++++++++++++++++++-------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index d909c069363e..5a6ab0a61b68 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -53,6 +53,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 
 	preempt_disable();
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the lpid first to avoid running host with unallocated pid */
 	old_lpid = mfspr(SPRN_LPID);
 	if (old_lpid != lpid)
@@ -69,6 +71,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	else
 		ret = copy_to_user_nofault((void __user *)to, from, n);
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
 		mtspr(SPRN_PID, old_pid);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 55286a8357f7..7aa72efcac6c 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -503,17 +503,19 @@ static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u6
 	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
 
 	/*
-	 * All the isync()s are overkill but trivially follow the ISA
-	 * requirements. Some can likely be replaced with justification
-	 * comment for why they are not needed.
+	 * Prior memory accesses to host PID Q3 must be completed before we
+	 * start switching, and stores must be drained to avoid not-my-LPAR
+	 * logic (see switch_mmu_to_host).
 	 */
+	asm volatile("hwsync" ::: "memory");
 	isync();
 	mtspr(SPRN_LPID, lpid);
-	isync();
 	mtspr(SPRN_LPCR, lpcr);
-	isync();
 	mtspr(SPRN_PID, vcpu->arch.pid);
-	isync();
+	/*
+	 * isync not required here because we are HRFID'ing to guest before
+	 * any guest context access, which is context synchronising.
+	 */
 }
 
 static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64 lpcr)
@@ -523,25 +525,41 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 
 	lpid = kvm->arch.lpid;
 
+	/*
+	 * See switch_mmu_to_guest_radix. ptesync should not be required here
+	 * even if the host is in HPT mode because speculative accesses would
+	 * not cause RC updates (we are in real mode).
+	 */
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	mtspr(SPRN_LPID, lpid);
 	mtspr(SPRN_LPCR, lpcr);
 	mtspr(SPRN_PID, vcpu->arch.pid);
 
 	for (i = 0; i < vcpu->arch.slb_max; i++)
 		mtslb(vcpu->arch.slb[i].orige, vcpu->arch.slb[i].origv);
-
-	isync();
+	/*
+	 * isync not required here, see switch_mmu_to_guest_radix.
+	 */
 }
 
 static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
+	/*
+	 * The guest has exited, so guest MMU context is no longer being
+	 * non-speculatively accessed, but a hwsync is needed before the
+	 * mtLPIDR / mtPIDR switch, in order to ensure all stores are drained,
+	 * so the not-my-LPAR tlbie logic does not overlook them.
+	 */
+	asm volatile("hwsync" ::: "memory");
 	isync();
 	mtspr(SPRN_PID, pid);
-	isync();
 	mtspr(SPRN_LPID, kvm->arch.host_lpid);
-	isync();
 	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
-	isync();
+	/*
+	 * isync is not required after the switch, because mtmsrd with L=0
+	 * is performed after this switch, which is context synchronising.
+	 */
 
 	if (!radix_enabled())
 		slb_restore_bolted_realmode();
-- 
2.23.0

