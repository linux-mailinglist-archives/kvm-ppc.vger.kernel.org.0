Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9887D3B0202
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhFVLA4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLAz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AFEC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o21so10240747pll.6
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZsiQN9J6oa0kU+XOcLhtqmzOw5qPUAZ0H870q5gDHs=;
        b=oXgKGnSJWf02f7//UKclDr/sY/W/n5Ltsl+LkJNmPb7GfodfTJvlsxGyhXUPNf2HhY
         ftzY/eGPAzPbkVMjQ5p3GMGJb8QxjqImr8RoT44qhpTcbPm2Z/Ngt4RZfeLp6VH/iv3r
         D2Pz5ZVluJvRVqmjl2SiiOv5lPdyQk8dubaIaKEDzk/9Rz6IfmwqEPs2G2nFeCJ3Zc4N
         Bjl6X/8aCGsk9XDoweWzDMEEo8CUceMXPFxzvM6I+ZJEV7PZlZ158FYZikjRWfylAB2z
         386jJHZqU6awBLtTkwGxRnNfVGla8UKM9pQ9N1wurjqecxdG08w4vZrv+v7dqbFTz0UU
         WC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZsiQN9J6oa0kU+XOcLhtqmzOw5qPUAZ0H870q5gDHs=;
        b=Hc6922UMoUOnU6N93NDgRaAM66jgJbVhp8csCkGDAQUngD46IxpFBLxCl6ugQbTrzF
         vdtz5Q6u1vD9qKP2Svro4rByfI4rpO2bMHKrwN8SN7EZKnZJQFi3DKbqEQvwAwUwQc/k
         A+gn0a5aU78DFdrrzJx/Go0GFbL+wfNnFz/Gnhl0q1pBUC7rOlBc97cpQfzGT5iDwKYW
         jx8iUa6F2QPPY3dSJ/A5X201oVRkpYdOrfQAC0Fh9v4JYaWlWM+/g392NDtWU7UuU0he
         oBIkde56G9/zi9Yr1WZ+rJUhy9O7Ket9aXXVkWsQqCy7vGAN1QnK435RZSQ6CIuXo9HF
         g1Og==
X-Gm-Message-State: AOAM53174Jdl2hy0tpLgQAYge8NxKeu7V2gR99oKA5m9lp5vlLFB6s8B
        V7yfMsWrCR5ur7HfLFe43HgWilL1CWU=
X-Google-Smtp-Source: ABdhPJxZiINE41XCeFsG3jcgc0NnxGeUyLgSthjARikfH6htHg4KAKhBj5QVacEqpKZ6xZ1d8bNJKQ==
X-Received: by 2002:a17:90b:4392:: with SMTP id in18mr3313783pjb.54.1624359519819;
        Tue, 22 Jun 2021 03:58:39 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 18/43] KVM: PPC: Book3S HV P9: Improve mtmsrd scheduling by delaying MSR[EE] disable
Date:   Tue, 22 Jun 2021 20:57:11 +1000
Message-Id: <20210622105736.633352-19-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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

-12 cycles (7791) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3ac5dbdb59f8..b8b0695a9312 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4015,6 +4015,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
@@ -4512,6 +4524,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	unsigned long flags;
 
 	trace_kvmppc_run_vcpu_enter(vcpu);
 
@@ -4555,11 +4568,11 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4614,7 +4627,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
@@ -4672,7 +4685,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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

