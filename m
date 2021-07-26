Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0827B3D51D7
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGZDL4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhGZDL4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0274AC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:25 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so12490830pjd.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rHN3RL3Kn4gtidkizBvHwU218V2wDO26g3I1nj+ZzZU=;
        b=ZXebVxUPRpZWJRSIzunQL1v9ZNlR/v9unJ6D2We+uCwLXOLRmV1CKxV06gdl0M4oAs
         f1JV/zx4DgMFkHPILQdNm+LHfL1yFS07RPQpjQ2V0xh3J6AVIP+yifZ79ZXNR0BqdA9M
         xzX9GZEYf0kiVgzo0RDqP5r3LRLm9AisDRNNINvEK5NFUu4xQXwo8BXlyvNQWCj/TEmi
         gqtHf3OKSQJ0ggCMXCdLU1RexQYSeOWIOrGOGy7a5R1FYeE3SZytQbbPRe2D1Iqi7E6h
         Jhz6W6Epo78Bht9iA+3mm9t1851yorPUilxn/0Ti4gcKiSsKG12Vq0SiKpp9bUA9o5lV
         ZoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rHN3RL3Kn4gtidkizBvHwU218V2wDO26g3I1nj+ZzZU=;
        b=Lkl+Uz0niX895bBb0Djq1rAxqvy4WYNPyxpYKdhJ/1LGafYRg4/05lurHVGaIV0BKK
         UnjK3SglEZJ8Hr011bY/OC57tiEPOpFHClGg9A/QtIILXf6mfJXo+V2Spd+ASKpcS9tE
         lc4NfSaHv5Ee7NFqiNm7JH+wOF7CMZi+BF6SOc7vDZX7QgcefW9EU//AKD9K2cU3gYLh
         sEMvJBlb7ycwEU/VDSPVYDBh1Fn/HsoYxvR540qvVUnKoK2006hGL9sW5xNU72LHuDLS
         K+fKRV6GnDtUqX+YElG+2UESa8eg8Lf7FBCbok6sTqJzkjxEGY3DgHpastd1l1cd/tH9
         JmfQ==
X-Gm-Message-State: AOAM5333WflXsSY+0almCrSc4AHXkMYdnm3QoQok+R7Sm7e7gZrBqCwS
        oZ4mc6dB5UDH9drq4Gl6jQP9cyVzODQ=
X-Google-Smtp-Source: ABdhPJzSv71EF3qtG2jx97SNiTNF/lT49k775lPxxecYyeqng2PbysFg9oEU1fj20g9NC0dCPiSigQ==
X-Received: by 2002:a17:90a:ea98:: with SMTP id h24mr23846562pjz.7.1627271544517;
        Sun, 25 Jul 2021 20:52:24 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:24 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 43/55] KVM: PPC: Book3S HV P9: Comment and fix MMU context switching code
Date:   Mon, 26 Jul 2021 13:50:24 +1000
Message-Id: <20210726035036.739609-44-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index b5905ae4377c..c5508744e14c 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -54,6 +54,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 
 	preempt_disable();
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the lpid first to avoid running host with unallocated pid */
 	old_lpid = mfspr(SPRN_LPID);
 	if (old_lpid != lpid)
@@ -70,6 +72,8 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	else
 		ret = copy_to_user_nofault((void __user *)to, from, n);
 
+	asm volatile("hwsync" ::: "memory");
+	isync();
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
 		mtspr(SPRN_PID, old_pid);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 5fca0a09425d..0aad2bf29d6e 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -521,17 +521,19 @@ static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u6
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
@@ -541,25 +543,41 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 
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

