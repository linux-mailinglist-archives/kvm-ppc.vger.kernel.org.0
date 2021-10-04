Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E01421360
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhJDQDj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbhJDQDj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:39 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722BAC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:50 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 66so16566660pgc.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbNMN5/ycF90abyDvuus1UyFcgyOK6fk2IGspBrPPPc=;
        b=EDKj8e2OCD1oNd6XMKXNSyzhvjqRttg0JdlauhpsHZig3ufREVZQJZXGJ9Pjygq0F3
         5r7thMf9llIC+mx+PAznq0dMCNPUvg419LUXbxQ/1JE3WnaUb1SB+WM/J0Xih3tYcnis
         BStK+ZJF1FQ3ES5bOQtPtcWHwG2VXEOmSeuMxpXdv8Kt7iKc3T22YE1bzeY2n0VUZM2q
         GOmTYo7z6ldBS9JFkJ/M4kFRUljo2D+/XRIRyrMuuAtX2nqAFPNUMaFDTve1foR/FnhH
         IfuE+g4D0BCajyxF1s4Y2vjtdWzwaT4PNYkI6jONzYSs69nSeDxInXAMlpH1BU7Am55l
         pVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbNMN5/ycF90abyDvuus1UyFcgyOK6fk2IGspBrPPPc=;
        b=ZflZh2+3thqDelvtDakSwFSe5UUuIxLQWveacEvhTryoQASmQAqftJYt+gwk61DBqW
         EleVu3KuOBOscOS9cJ2kx9am/WvYNQRiO0gMzph4I5/iXGc5z+TDDLmpWz05jr3cvDy8
         ceeKNmAR4mKrElnqEO03eZ0rNKO7mMs8rmoHoV2N3rBmXN2j1l4p3XrdhW/Dp63cCM1/
         ZKtiJeuZSqvgVzu5JML74UMVGfHJGQiEV4OO8tbc/5g/K8+Mp6JaQg718jl5N6YnmPzm
         rYGMsoRuniWPByFxVYBcE5gMohscn3SEQdf3GYFGNL6pXQeZWnEdsndE2bjH29cQikyv
         M6bg==
X-Gm-Message-State: AOAM532Sj7oV2NvN9g9+Fsex7EjXnxAXdIUmGXN5geKwp6JAGxVkF7T+
        kJw1mG+cfRTT6IhpYYzuiPxpYXdj5yw=
X-Google-Smtp-Source: ABdhPJxYgoK0eSIGz6nCE8LCrmlN+ynSfHHlsBS/gxu1ZN3R1c4RJZLKXwXJjDWqduKRYw303ZEMVQ==
X-Received: by 2002:a63:710d:: with SMTP id m13mr11593324pgc.467.1633363309813;
        Mon, 04 Oct 2021 09:01:49 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:49 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 20/52] KVM: PPC: Book3S HV P9: Improve mtmsrd scheduling by delaying MSR[EE] disable
Date:   Tue,  5 Oct 2021 02:00:17 +1000
Message-Id: <20211004160049.1338837-21-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 16365c0e9872..7e8ddffd61c7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4156,6 +4156,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
@@ -4667,6 +4679,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	unsigned long flags;
 
 	trace_kvmppc_run_vcpu_enter(vcpu);
 
@@ -4710,11 +4723,11 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4769,7 +4782,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
@@ -4827,7 +4840,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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

