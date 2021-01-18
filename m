Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD96B2F9F8D
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403897AbhARM1F (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 07:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403857AbhARM1B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 07:27:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECC4C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 04:26:21 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id be12so8575364plb.4
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 04:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1erHg5LqqpKnTmLz3Bmoeq2XFVM/7b2u2hm1s2oUlH0=;
        b=RJS6vqyr8nt8AcIgRse7VffNVIgUqt84yrBtaBMv8sNofehRNk9zpW1tFrm6Fy5Das
         bThJ8lhFduPDkje8ttbuoJEmqzm7XuBi+bFfg64gUiRW7NN97AQ5j/aOR1ON+HgZo5Ij
         /1DkQxQr4TsxuYI6sRSfZkzdHRQw+SGueXgOxSeSiVIB0agzD0OoUp76jjWghHnLQ7kK
         XzXU+RfTatFPgRSdyqPbWe7zpCEvBfRv7C4Y0Ytou+hFp9sZdfVQCnHOTK4lB3R9ToVY
         qBFFf7+2WKflmE4mfy8DNx7zMmakXtBPkWCkBMroVaOZsdDxYfqmMI9YRwT36qvBYVUz
         LB7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1erHg5LqqpKnTmLz3Bmoeq2XFVM/7b2u2hm1s2oUlH0=;
        b=kVzvEz/S34S/s8UU5GqUD2s/IhOaY/BXK1f16++PsGKD/RNLJsio0A/CAmGzqCzcZQ
         2BA+4a6VIucfQqWN7JPvkEF3dTX4f+lFBL4zRT2MCokAkYDnI4lsFl8qmn9CTxBzU6Np
         cd3OrVU4kzWtndvtbU4qed9KVLWwgN8crPLe8P7fsj6GVF0TooVE8mjWwYKRhq5mJn3g
         0uvDM3WXfLusd1UROFtOBLfezitPWB2BNjcPU7AtvfAEKvBP70WYXHVmeMl1X0rgn8jh
         82VRbEkwAK/RFtf9OGBN46LIcAHEE2SaIvP0ZdQx46SbVwusDeXsubdmRJaBjIWtHAYi
         BdKA==
X-Gm-Message-State: AOAM5310LM6O93AbmuDWCkv13CgXxX7e6ukNYdX6Hv6efhUhF1o+pmEZ
        3uraZDgUNeZamUQzBH6vRQdAjmBvvEE=
X-Google-Smtp-Source: ABdhPJyESkwNd5/ykmGqwSM4XY6ECqMcOzUj4X7gKo0p2bf869gPvdmkL76KW85yAwEt703x5/iCcg==
X-Received: by 2002:a17:90a:f2cf:: with SMTP id gt15mr5861299pjb.166.1610972780652;
        Mon, 18 Jan 2021 04:26:20 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id h3sm15896098pgm.67.2021.01.18.04.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 04:26:20 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 2/2] KVM: PPC: Book3S HV: Optimise TLB flushing when a vcpu moves between threads in a core
Date:   Mon, 18 Jan 2021 22:26:09 +1000
Message-Id: <20210118122609.1447366-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210118122609.1447366-1-npiggin@gmail.com>
References: <20210118122609.1447366-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

As explained in the comment, there is no need to flush TLBs on all
threads in a core when a vcpu moves between threads in the same core.

Thread migrations can be a significant proportion of vcpu migrations,
so this can help reduce the TLB flushing and IPI traffic.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
I believe we can do this and have the TLB coherency correct as per
the architecture, but would appreciate someone else verifying my
thinking.

Thanks,
Nick

 arch/powerpc/kvm/book3s_hv.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 752daf43f780..53d0cbfe5933 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2584,7 +2584,7 @@ static void kvmppc_release_hwthread(int cpu)
 	tpaca->kvm_hstate.kvm_split_mode = NULL;
 }
 
-static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
+static void radix_flush_cpu(struct kvm *kvm, int cpu, bool core, struct kvm_vcpu *vcpu)
 {
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	cpumask_t *cpu_in_guest;
@@ -2599,6 +2599,14 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 		cpu_in_guest = &kvm->arch.cpu_in_guest;
 	}
 
+	if (!core) {
+		cpumask_set_cpu(cpu, need_tlb_flush);
+		smp_mb();
+		if (cpumask_test_cpu(cpu, cpu_in_guest))
+			smp_call_function_single(cpu, do_nothing, NULL, 1);
+		return;
+	}
+
 	cpu = cpu_first_thread_sibling(cpu);
 	for (i = 0; i < threads_per_core; ++i)
 		cpumask_set_cpu(cpu + i, need_tlb_flush);
@@ -2655,7 +2663,23 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 		if (prev_cpu < 0)
 			return; /* first run */
 
-		radix_flush_cpu(kvm, prev_cpu, vcpu);
+		/*
+		 * If changing cores, all threads on the old core should
+		 * flush, because TLBs can be shared between threads. More
+		 * precisely, the thread we previously ran on should be
+		 * flushed, and the thread to first run a vcpu on the old
+		 * core should flush, but we don't keep enough information
+		 * around to track that, so we flush all.
+		 *
+		 * If changing threads in the same core, only the old thread
+		 * need be flushed.
+		 */
+		if (cpu_first_thread_sibling(prev_cpu) !=
+		    cpu_first_thread_sibling(pcpu))
+			radix_flush_cpu(kvm, prev_cpu, true, vcpu);
+		else
+			radix_flush_cpu(kvm, prev_cpu, false, vcpu);
+
 	}
 }
 
-- 
2.23.0

