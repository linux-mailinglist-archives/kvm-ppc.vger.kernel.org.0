Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C1A3D51E0
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhGZDMO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGZDMO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42D9C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so11102004pjv.3
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Od0aBmiRV7nfGJrUiIs+liiazjhz4hDN8E8M4lUNSM=;
        b=dGnLADup8PXhp2alX1zwmgnoMeROJhet7wzxDOBYK9Wqrp9siBgyNrnayez9DVnqvA
         RqM267IWKQjI2WRgpbFc5Hy1acxtprxWFsTLxlR310gwLCMBUw81WaMQt5bATflqCb/V
         hgjcp35AVGcfqYOxsQnUpHADABCVRCkIPpFO+bXwveW1qS7cAyKM99vJ+1M4dJfr0FvD
         5XoCrZmeahmwyITZOHgN6tKdH7uTSPRFIzwPVmvYNqFe9Z5qQ6Kb/M4WGO6KpLdsAawe
         +Htg08f85C/Ceuarq2Vn+Fbx/96twDLQxn/5cXUah2zOVYg+CZorZadaiYVPKuiE2rP5
         bIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Od0aBmiRV7nfGJrUiIs+liiazjhz4hDN8E8M4lUNSM=;
        b=GE9jYdLB5g7hwhaG4nNSfx/pyczVMbTy+Hf9VSjo87zHy/talb7umQJafA29PapwOD
         hKsPlJbM9QuqE6EJwED+j5WGeWJIUKrI6wwYJWHGU5mX2E+Hs1eSHsTJW/VGwYX1AL9s
         PLNU3xHKSpm5nV0qjjkiIyawja/Bi3YKDxT/q4lwMtxjPhj9h7TrpRmOL4El8Wxmrxd2
         ZEFu3p8X8PgRHX8zdWa0es2qc9VzcfHVyjELEv5w6qovV3mOAtls1gk5IbKYbNNL+nAA
         ZvA30lRkKnY0NTu5gRPaN18EJ3dNIvsnF94RwHEAoPjpdlY9pVijqgnhc19g5O51VyRX
         Z+Gw==
X-Gm-Message-State: AOAM533YzXpp3OyhuZLS4dC4h+FZekJ+4VeSG4914j45fBjXrHrVvA1v
        6m7DScNj9Z839ruNEexanwShg94gwsk=
X-Google-Smtp-Source: ABdhPJx8uSuk+e8Tl7n9R3pE4gRvBsOOzry52L9kpOAZzitiY675t4Edy5Ljuh0bb+zMDA/7gDzhag==
X-Received: by 2002:a63:fc02:: with SMTP id j2mr16507162pgi.235.1627271562183;
        Sun, 25 Jul 2021 20:52:42 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 51/55] KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
Date:   Mon, 26 Jul 2021 13:50:32 +1000
Message-Id: <20210726035036.739609-52-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

cpu_in_guest is set to determine if a CPU needs to be IPI'ed to exit
the guest and notice the need_tlb_flush bit.

This can be implemented as a global per-CPU pointer to the currently
running guest instead of per-guest cpumasks, saving 2 atomics per
entry/exit. P7/8 doesn't require cpu_in_guest, nor does a nested HV
(only the L0 does), so move it to the P9 HV path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |  1 -
 arch/powerpc/include/asm/kvm_host.h      |  1 -
 arch/powerpc/kvm/book3s_hv.c             | 38 +++++++++++++-----------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 4b0753e03731..793aa2868c3f 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -44,7 +44,6 @@ struct kvm_nested_guest {
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
 	cpumask_t need_tlb_flush;
-	cpumask_t cpu_in_guest;
 	short prev_cpu[NR_CPUS];
 	u8 radix;			/* is this nested guest radix */
 };
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 74ee3a5b110e..650e1c0d118c 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -288,7 +288,6 @@ struct kvm_arch {
 	u32 online_vcores;
 	atomic_t hpte_mod_interest;
 	cpumask_t need_tlb_flush;
-	cpumask_t cpu_in_guest;
 	u8 radix;
 	u8 fwnmi_enabled;
 	u8 secure_guest;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2bd000e2c269..6f29fa7d77cc 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2989,30 +2989,33 @@ static void kvmppc_release_hwthread(int cpu)
 	tpaca->kvm_hstate.kvm_split_mode = NULL;
 }
 
+static DEFINE_PER_CPU(struct kvm *, cpu_in_guest);
+
 static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 {
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
-	cpumask_t *cpu_in_guest;
 	int i;
 
 	cpu = cpu_first_tlb_thread_sibling(cpu);
-	if (nested) {
+	if (nested)
 		cpumask_set_cpu(cpu, &nested->need_tlb_flush);
-		cpu_in_guest = &nested->cpu_in_guest;
-	} else {
+	else
 		cpumask_set_cpu(cpu, &kvm->arch.need_tlb_flush);
-		cpu_in_guest = &kvm->arch.cpu_in_guest;
-	}
 	/*
-	 * Make sure setting of bit in need_tlb_flush precedes
-	 * testing of cpu_in_guest bits.  The matching barrier on
-	 * the other side is the first smp_mb() in kvmppc_run_core().
+	 * Make sure setting of bit in need_tlb_flush precedes testing of
+	 * cpu_in_guest. The matching barrier on the other side is hwsync
+	 * when switching to guest MMU mode, which happens between
+	 * cpu_in_guest being set to the guest kvm, and need_tlb_flush bit
+	 * being tested.
 	 */
 	smp_mb();
 	for (i = cpu; i <= cpu_last_tlb_thread_sibling(cpu);
-					i += cpu_tlb_thread_sibling_step())
-		if (cpumask_test_cpu(i, cpu_in_guest))
+					i += cpu_tlb_thread_sibling_step()) {
+		struct kvm *running = *per_cpu_ptr(&cpu_in_guest, i);
+
+		if (running == kvm)
 			smp_call_function_single(i, do_nothing, NULL, 1);
+	}
 }
 
 static void do_migrate_away_vcpu(void *arg)
@@ -3080,7 +3083,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 {
 	int cpu;
 	struct paca_struct *tpaca;
-	struct kvm *kvm = vc->kvm;
 
 	cpu = vc->pcpu;
 	if (vcpu) {
@@ -3091,7 +3093,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		cpu += vcpu->arch.ptid;
 		vcpu->cpu = vc->pcpu;
 		vcpu->arch.thread_cpu = cpu;
-		cpumask_set_cpu(cpu, &kvm->arch.cpu_in_guest);
 	}
 	tpaca = paca_ptrs[cpu];
 	tpaca->kvm_hstate.kvm_vcpu = vcpu;
@@ -3809,7 +3810,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		kvmppc_release_hwthread(pcpu + i);
 		if (sip && sip->napped[i])
 			kvmppc_ipi_thread(pcpu + i);
-		cpumask_clear_cpu(pcpu + i, &vc->kvm->arch.cpu_in_guest);
 	}
 
 	spin_unlock(&vc->lock);
@@ -3977,8 +3977,14 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 
 	} else {
+		struct kvm *kvm = vcpu->kvm;
+
 		kvmppc_xive_push_vcpu(vcpu);
+
+		__this_cpu_write(cpu_in_guest, kvm);
 		trap = kvmhv_vcpu_entry_p9(vcpu, time_limit, lpcr, tb);
+		__this_cpu_write(cpu_in_guest, NULL);
+
 		if (trap == BOOK3S_INTERRUPT_SYSCALL && !vcpu->arch.nested &&
 		    !(vcpu->arch.shregs.msr & MSR_PR)) {
 			unsigned long req = kvmppc_get_gpr(vcpu, 3);
@@ -4003,7 +4009,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 		kvmppc_xive_pull_vcpu(vcpu);
 
-		if (kvm_is_radix(vcpu->kvm))
+		if (kvm_is_radix(kvm))
 			vcpu->arch.slb_max = 0;
 	}
 
@@ -4468,8 +4474,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	powerpc_local_irq_pmu_restore(flags);
 
-	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-
 	preempt_enable();
 
 	/*
-- 
2.23.0

