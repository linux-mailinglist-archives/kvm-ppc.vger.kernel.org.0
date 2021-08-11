Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539D23E9558
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhHKQDX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhHKQDX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A2C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so10431304pjs.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B1FzzEpWRWY6cyBzpZZ3791Kwi4/Y0fUuP+n4T9dwEg=;
        b=A9uYqJaRiCkqI8Cb3FkasbSgEl3gK5mwm5eqEJmExODe/P//TGj+1FTMJseEzS0fqc
         zAWshLkHMARXKwONch0fIYzJfAMDa+TjfNHDW12dPlExNUInelsRUrdWIgOdHBdRHJc1
         gBI8wj2zM1QYPwnIAVjrtDtHSsU2Q5ygmHRQtOP/0M1IOCNo3lt29gLdGH12kLvdJP03
         fnFc8IhlHHqo/oTCdONAMPdJFFlDHWxRIOAa6bm4veqFCYdNtER7TfyWEy3iTFIKaduX
         FqS0PGqjsWEFbypa7+mNhSCdK/ccLLJs+mIUS3qhcUYYbZlwTS+ysaeNV6HuM1ELOZGq
         ZWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B1FzzEpWRWY6cyBzpZZ3791Kwi4/Y0fUuP+n4T9dwEg=;
        b=IpTUWoS99r4xb/e75DFhy3fQ9LMc7VJDpdGxIUC+ls+axv07ziEAGshpFROf5Sg3rP
         DbdwY8G1MRLxj6OZv5n5mJ/66zzZFEkmmEiOp4PYZ3lnYM7HTHn9IBWh6swBlw8twAXg
         eVwo0Z2wEDr6VFjOd0NeKVxMYvQgH8PFbjzQp9mdPsYl2Vw/9CF+bAmzrzhz82s/PNIp
         uNxGWzFfl2+LGHxUplebETWYsuBuHy7Ob/nGsceF7cs8sTUyt79fUaiCVdo8dkTycW9a
         z8NggsWy63x0ZxPB5qSZd7CXtVnPejm/NVcS46W0AcO/68svpsr+XZOWncp0YF2RETfG
         TRYg==
X-Gm-Message-State: AOAM530o4Um6RMZK7AUHBE2cT/2gjNvnGo2KjawPptszMHl7HCyQ9MaP
        lbl7Ae9vRqN0HuyZ78BNiz70AJ2Z7ck=
X-Google-Smtp-Source: ABdhPJyN2EA7DwVy9t1bAH9Q7tLIwAsGs34tgc8S/b0Te5GkFuudS97nzvmnpFCRgNmjiSPTv3hh1A==
X-Received: by 2002:a05:6a00:1c6d:b029:3cd:da92:7296 with SMTP id s45-20020a056a001c6db02903cdda927296mr9159427pfw.33.1628697778762;
        Wed, 11 Aug 2021 09:02:58 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 28/60] KVM: PPC: Book3S HV P9: Improve mtmsrd scheduling by delaying MSR[EE] disable
Date:   Thu, 12 Aug 2021 02:01:02 +1000
Message-Id: <20210811160134.904987-29-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Moving the mtmsrd after the host SPRs are saved and before the guest
SPRs start to be loaded can prevent an SPR scoreboard stall (because
the mtmsrd is L=1 type which does not cause context synchronisation.

This is also now more convenient to combined with the mtmsrd L=0
instruction to enable facilities just below, but that is not done yet.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 77a4138732af..376687286fef 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4155,6 +4155,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
+	/*
+	 * This could be combined with MSR[RI] clearing, but that expands
+	 * the unrecoverable window. It would be better to cover unrecoverable
+	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
+	 *
+	 * Much more difficult and less worthwhile to combine with IR/DR
+	 * disable.
+	 */
+	hard_irq_disable();
+	if (lazy_irq_pending())
+		return 0;
+
 	/* MSR bits may have been cleared by context switch */
 	msr = 0;
 	if (IS_ENABLED(CONFIG_PPC_FPU))
@@ -4654,6 +4666,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	unsigned long flags;
 
 	trace_kvmppc_run_vcpu_enter(vcpu);
 
@@ -4697,11 +4710,11 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (kvm_is_radix(kvm))
 		kvmppc_prepare_radix_vcpu(vcpu, pcpu);
 
-	local_irq_disable();
-	hard_irq_disable();
+	/* flags save not required, but irq_pmu has no disable/enable API */
+	powerpc_local_irq_pmu_save(flags);
 	if (signal_pending(current))
 		goto sigpend;
-	if (lazy_irq_pending() || need_resched() || !kvm->arch.mmu_ready)
+	if (need_resched() || !kvm->arch.mmu_ready)
 		goto out;
 
 	if (!nested) {
@@ -4756,7 +4769,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
@@ -4814,7 +4827,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	run->exit_reason = KVM_EXIT_INTR;
 	vcpu->arch.ret = -EINTR;
  out:
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 	preempt_enable();
 	goto done;
 }
-- 
2.23.0

