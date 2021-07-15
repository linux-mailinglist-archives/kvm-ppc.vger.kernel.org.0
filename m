Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A33C9F38
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbhGONSY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONSY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993FC06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso5555306pjx.1
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LEyWXV1GBTM3FA5uKVvdVajFCXRipZIvyhNLU9oRCwI=;
        b=liF8tBgS1TwYNouKOibIOm55eYMwlwz5WHtJvwmlA9QqMkqvlBjY7m9ZC2By0VwSnH
         b9SHyZS8gMAvMVJxGF9d6tDzKm+pNBgYqUIC7L61QDAWqXY25dlFQ/dt0aas/kiwNqez
         Y/pVHZ68Zw8VP/ZjctfESm4OcQgzv0looY2LHsZlnqrOTd+nxBqd0lO2yV1ujaqZ1jUG
         OuriizqRvMTy73vJ7qcvvkb8I9ZL6jrFh6KOaMtE8EBesibhUv4AQYiusZsIZCt3ssje
         udr19XpM8Q4pk67zTqlDZl2E3b1dpvaQ6l7UW5DVPSzdvDI5Q7VYMPjQDiWKRLZr9i1g
         Vp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEyWXV1GBTM3FA5uKVvdVajFCXRipZIvyhNLU9oRCwI=;
        b=mf0jXs+IuVS5OsHArGblVBU2TXHprhCTEO40/G40Djp4dNidyqiz9TW4IgwrUab1C7
         EksPugCFqyigsbc5XSx+QkefkMIUivY9MnvrOie0nf5RCrtW6L/YWfrRrcjykMX0KxWm
         Cxi9pzm0JGKhga8Wy6eF8UJkvHJfQ3bqwNBdFqckG1YywxKRNKuIWsvdyn3MeNZwaa7u
         HoF+4sI7xnndxEr74hl5oaPQ2XhVNdRpuygy0jgcqYjZz3PkTop+nuKKBvMemI2uflOM
         Fzurn63ko3Iz1Z+TyMJ3iHoVEAVLaVYa27eFabvX97ON3z6oRdZypuq0QdfxNe1lV8QQ
         ljhA==
X-Gm-Message-State: AOAM530wYuG0+mUcno47kGTvJ1jPNHZFOlpTxNqsdvhZfgqmvlEJHRID
        9uCl6JGrcaSCmlRyzRPx3djEiUd9GpnFfQ==
X-Google-Smtp-Source: ABdhPJxsAieIhcXMVZSeAw12Pqch/PpJ6O1r9RWmvUXhEn6iO5SUhD0tgxz3Wptan3W6tKLNXeweKg==
X-Received: by 2002:a17:90a:930e:: with SMTP id p14mr4331970pjo.132.1626354929879;
        Thu, 15 Jul 2021 06:15:29 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:29 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 2/6] KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
Date:   Thu, 15 Jul 2021 23:15:14 +1000
Message-Id: <20210715131518.146917-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210715131518.146917-1-npiggin@gmail.com>
References: <20210715131518.146917-1-npiggin@gmail.com>
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
index 20ca9b1a2d41..2b442e00fb5d 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -43,7 +43,6 @@ struct kvm_nested_guest {
 	struct mutex tlb_lock;		/* serialize page faults and tlbies */
 	struct kvm_nested_guest *next;
 	cpumask_t need_tlb_flush;
-	cpumask_t cpu_in_guest;
 	short prev_cpu[NR_CPUS];
 	u8 radix;			/* is this nested guest radix */
 };
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index cd7939eb47ca..45dc92812020 100644
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
index 27a7a856eed1..d809566918de 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2981,30 +2981,33 @@ static void kvmppc_release_hwthread(int cpu)
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
@@ -3072,7 +3075,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 {
 	int cpu;
 	struct paca_struct *tpaca;
-	struct kvm *kvm = vc->kvm;
 
 	cpu = vc->pcpu;
 	if (vcpu) {
@@ -3083,7 +3085,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		cpu += vcpu->arch.ptid;
 		vcpu->cpu = vc->pcpu;
 		vcpu->arch.thread_cpu = cpu;
-		cpumask_set_cpu(cpu, &kvm->arch.cpu_in_guest);
 	}
 	tpaca = paca_ptrs[cpu];
 	tpaca->kvm_hstate.kvm_vcpu = vcpu;
@@ -3801,7 +3802,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		kvmppc_release_hwthread(pcpu + i);
 		if (sip && sip->napped[i])
 			kvmppc_ipi_thread(pcpu + i);
-		cpumask_clear_cpu(pcpu + i, &vc->kvm->arch.cpu_in_guest);
 	}
 
 	spin_unlock(&vc->lock);
@@ -3968,8 +3968,14 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -3994,7 +4000,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 		kvmppc_xive_pull_vcpu(vcpu);
 
-		if (kvm_is_radix(vcpu->kvm))
+		if (kvm_is_radix(kvm))
 			vcpu->arch.slb_max = 0;
 	}
 
@@ -4459,8 +4465,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	powerpc_local_irq_pmu_restore(flags);
 
-	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-
 	preempt_enable();
 
 	/*
-- 
2.23.0

