Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5B93E9577
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhHKQEe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhHKQEd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:33 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDDCC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id a5so3296601plh.5
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jy4R8BFfYquj/C4NC6ERCf9CQ1VWlLViGyEiq+5maxY=;
        b=k/M2kOOSXZ5BdRmESaWzo2oAi8T5VoxoaozOXgbSabHr9O2C/MM+3vnYHxU2SmbjyB
         YYSzdq0R9XdXI5PgftMNBIRhlN9nvVpBpdZj43JEdioJhScH/e6rq2RG/EkUFUDqzeLL
         m2ND/cvFXhHtxeA1gWbdZDPlCqTjDUDsgHGCaWwBrUiTuKcC2xEjySdKMFXR1QiLXMc1
         TdqsAoWxbANQYzvJiAEF/GaYvC0S9m22Zr/Wp6wAuZKkVz20///tD8Y4ayylSqHizod9
         tl94YfvWqTljw7VkKmXMETNKeowlM3iMysXpQkjYtizu+W2YJjms1rjzCDl7+rEGS3fD
         6x+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jy4R8BFfYquj/C4NC6ERCf9CQ1VWlLViGyEiq+5maxY=;
        b=qocLPqYhVWjjcFz2MAvt5ZkN7dCMjfqjPi+HHfg8Y0XL3ze5EqPyxZQDT2DhN2fvAt
         mU/5OPSGEPsuoNP4QkjKr7Crl/SXywAmAg+fGJX6TwL2/4qbc7lZZHPHNILeWxgJ+T58
         FaEh969a2I57yMkIsrnOdRm40LoVdEj59O9CaM0j0yFMQQIUzluT2blC5OoT/N1Xgncn
         zjemf/zzCyVtqddC2TI+P9HVQSaMNFop6oOp4pbKEm9AboeSYu32erAGgoyBBCLk0KTq
         taKoycbl8XDQIRoDoepj0Feh0FEghUkUJ7hpfDCYgc7mx6haQjyOKfhWS7ypsooj9XK7
         2T5A==
X-Gm-Message-State: AOAM533d6OJ3YAVasAGHTZeM0RJKfiFzejOeGTRZ1RppJ7dPMOGu7XuS
        Om/UKfI5kdg0yEVrGW1No0MoO2SohFc=
X-Google-Smtp-Source: ABdhPJx5XySbSq1D8RPC+5DJS+5KrEfdxP5ai4aA/BSTh6lL+5dYrA186eI+5J/AldSAMaxrR9BJGw==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr10852415pjb.150.1628697849500;
        Wed, 11 Aug 2021 09:04:09 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:09 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 56/60] KVM: PPC: Book3S HV P9: Avoid cpu_in_guest atomics on entry and exit
Date:   Thu, 12 Aug 2021 02:01:30 +1000
Message-Id: <20210811160134.904987-57-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index ee25e93febe6..3109b41865b2 100644
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
index ef60f5cce251..2bcac6da0a4b 100644
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
index d3fc486a4817..d4df2add81ae 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3012,30 +3012,33 @@ static void kvmppc_release_hwthread(int cpu)
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
@@ -3103,7 +3106,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 {
 	int cpu;
 	struct paca_struct *tpaca;
-	struct kvm *kvm = vc->kvm;
 
 	cpu = vc->pcpu;
 	if (vcpu) {
@@ -3114,7 +3116,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		cpu += vcpu->arch.ptid;
 		vcpu->cpu = vc->pcpu;
 		vcpu->arch.thread_cpu = cpu;
-		cpumask_set_cpu(cpu, &kvm->arch.cpu_in_guest);
 	}
 	tpaca = paca_ptrs[cpu];
 	tpaca->kvm_hstate.kvm_vcpu = vcpu;
@@ -3832,7 +3833,6 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		kvmppc_release_hwthread(pcpu + i);
 		if (sip && sip->napped[i])
 			kvmppc_ipi_thread(pcpu + i);
-		cpumask_clear_cpu(pcpu + i, &vc->kvm->arch.cpu_in_guest);
 	}
 
 	spin_unlock(&vc->lock);
@@ -4000,8 +4000,14 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4026,7 +4032,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		}
 		kvmppc_xive_pull_vcpu(vcpu);
 
-		if (kvm_is_radix(vcpu->kvm))
+		if (kvm_is_radix(kvm))
 			vcpu->arch.slb_max = 0;
 	}
 
@@ -4491,8 +4497,6 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	powerpc_local_irq_pmu_restore(flags);
 
-	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
-
 	preempt_enable();
 
 	/*
-- 
2.23.0

