Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E75397FFD
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Jun 2021 06:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFBEGj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Jun 2021 00:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhFBEGj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Jun 2021 00:06:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068ECC061574
        for <kvm-ppc@vger.kernel.org>; Tue,  1 Jun 2021 21:04:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k7so891374pjf.5
        for <kvm-ppc@vger.kernel.org>; Tue, 01 Jun 2021 21:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opIrV19eAsCnqykv2+ngjE4tZUavc+i3PGUBqFkvTtA=;
        b=CTmDuvnkcAwnPHdIlMpyGNmsVaMg2rz9ExsKm1coJEG1799NW6AkRLnCaCTch5Of2J
         DkrzwPXILicVSHpz6/NxycYTEDuFuq0lR4mAWtqTHwNdKZgK7QXlJBr1+pLWFqslzn96
         z/G7UKwpLaEUqqkcXjyGcZVJUvIGyiYVG23cy4tO96a+rSaMdtkIH4qol/6ASwNYAdik
         z74CzUgWURXk5e/EAfsXiHANUqPF64mcrgSr+izHkR5rc0dPvgZPDFQz534TLdU8+AQR
         blkcaLU7KjuPadyMTjKd7db/yUReBS1oHWLW0Dwu9CrRkR78ZKHlgHhBKof7tr0yXDmv
         /Deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opIrV19eAsCnqykv2+ngjE4tZUavc+i3PGUBqFkvTtA=;
        b=YZBHi4eBMUJKcxIXByUXbKokilQVClAePRNy6xLL+1s4Q+Lq93BnlTaljgpT2wKVay
         X4UwMyW1K5EtIo4twAC2k8ey1yYvIUlQz7XrIMlQIQjkk/eibDM2wLATlaIRCw0Dj+Vm
         UJ3hmbGoBRyXLTeQKiJdUjH9U2ClH3t6L/a4czrKFRV5rqZQbG/yG/284YDLRgM3Ffrn
         tmU/XFlDqs4zekec10z9NlPlBoI86L7uvh6n1jPNZU0aY1oZRqcXHX9rJ0SyRZ5SjzvA
         iGcBfpxO+UYbyCnogULPefAVTwU8zNQn9/9RKvg2zWOBni4nOtb00wlHFO3IAeY7xS7y
         q2sw==
X-Gm-Message-State: AOAM530mmiqhyLvRY6fheN9dRlAzzj5Guk3dV1CS7bw1J+vFq+iFpo7j
        wJ2IncJ4RMjbQUzcJaIH13prA1HT+Ow=
X-Google-Smtp-Source: ABdhPJwIJv3iLBKNzPpyH4QSAmQrzA6dT/WfPZnuGGRkn5FiSdiq1prfCrkiUNDLBGna0YBvQwxf1w==
X-Received: by 2002:a17:90b:ed5:: with SMTP id gz21mr29280786pjb.102.1622606695193;
        Tue, 01 Jun 2021 21:04:55 -0700 (PDT)
Received: from bobo.ibm.com (60-241-69-122.static.tpgi.com.au. [60.241.69.122])
        by smtp.gmail.com with ESMTPSA id v14sm15195292pgl.86.2021.06.01.21.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 21:04:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors
Date:   Wed,  2 Jun 2021 14:04:41 +1000
Message-Id: <20210602040441.3984352-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

The POWER9 vCPU TLB management code assumes all threads in a core share
a TLB, and that TLBIEL execued by one thread will invalidate TLBs for
all threads. This is not the case for SMT8 capable POWER9 and POWER10
(big core) processors, where the TLB is split between groups of threads.
This results in TLB multi-hits, random data corruption, etc.

Fix this by introducing cpu_first_tlb_thread_sibling etc., to determine
which siblings share TLBs, and use that in the guest TLB flushing code.

[npiggin@gmail.com: add changelog and comment]

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/cputhreads.h | 30 +++++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c          | 13 ++++++------
 arch/powerpc/kvm/book3s_hv_builtin.c  |  2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c   |  2 +-
 4 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/cputhreads.h b/arch/powerpc/include/asm/cputhreads.h
index 98c8bd155bf9..b167186aaee4 100644
--- a/arch/powerpc/include/asm/cputhreads.h
+++ b/arch/powerpc/include/asm/cputhreads.h
@@ -98,6 +98,36 @@ static inline int cpu_last_thread_sibling(int cpu)
 	return cpu | (threads_per_core - 1);
 }
 
+/*
+ * tlb_thread_siblings are siblings which share a TLB. This is not
+ * architected, is not something a hypervisor could emulate and a future
+ * CPU may change behaviour even in compat mode, so this should only be
+ * used on PowerNV, and only with care.
+ */
+static inline int cpu_first_tlb_thread_sibling(int cpu)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return cpu & ~0x6;	/* Big Core */
+	else
+		return cpu_first_thread_sibling(cpu);
+}
+
+static inline int cpu_last_tlb_thread_sibling(int cpu)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return cpu | 0x6;	/* Big Core */
+	else
+		return cpu_last_thread_sibling(cpu);
+}
+
+static inline int cpu_tlb_thread_sibling_step(void)
+{
+	if (cpu_has_feature(CPU_FTR_ARCH_300) && (threads_per_core == 8))
+		return 2;		/* Big Core */
+	else
+		return 1;
+}
+
 static inline u32 get_tensr(void)
 {
 #ifdef	CONFIG_BOOKE
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d240b76..0a8398a63f80 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2657,7 +2657,7 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 	cpumask_t *cpu_in_guest;
 	int i;
 
-	cpu = cpu_first_thread_sibling(cpu);
+	cpu = cpu_first_tlb_thread_sibling(cpu);
 	if (nested) {
 		cpumask_set_cpu(cpu, &nested->need_tlb_flush);
 		cpu_in_guest = &nested->cpu_in_guest;
@@ -2671,9 +2671,10 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 	 * the other side is the first smp_mb() in kvmppc_run_core().
 	 */
 	smp_mb();
-	for (i = 0; i < threads_per_core; ++i)
-		if (cpumask_test_cpu(cpu + i, cpu_in_guest))
-			smp_call_function_single(cpu + i, do_nothing, NULL, 1);
+	for (i = cpu; i <= cpu_last_tlb_thread_sibling(cpu);
+					i += cpu_tlb_thread_sibling_step())
+		if (cpumask_test_cpu(i, cpu_in_guest))
+			smp_call_function_single(i, do_nothing, NULL, 1);
 }
 
 static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
@@ -2704,8 +2705,8 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	 */
 	if (prev_cpu != pcpu) {
 		if (prev_cpu >= 0 &&
-		    cpu_first_thread_sibling(prev_cpu) !=
-		    cpu_first_thread_sibling(pcpu))
+		    cpu_first_tlb_thread_sibling(prev_cpu) !=
+		    cpu_first_tlb_thread_sibling(pcpu))
 			radix_flush_cpu(kvm, prev_cpu, vcpu);
 		if (nested)
 			nested->prev_cpu[vcpu->arch.nested_vcpu_id] = pcpu;
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 7a0e33a9c980..3edc25c89092 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -800,7 +800,7 @@ void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
 	 * Thus we make all 4 threads use the same bit.
 	 */
 	if (cpu_has_feature(CPU_FTR_ARCH_300))
-		pcpu = cpu_first_thread_sibling(pcpu);
+		pcpu = cpu_first_tlb_thread_sibling(pcpu);
 
 	if (nested)
 		need_tlb_flush = &nested->need_tlb_flush;
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 7af7c70f1468..407dbf21bcbc 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -67,7 +67,7 @@ static int global_invalidates(struct kvm *kvm)
 		 * so use the bit for the first thread to represent the core.
 		 */
 		if (cpu_has_feature(CPU_FTR_ARCH_300))
-			cpu = cpu_first_thread_sibling(cpu);
+			cpu = cpu_first_tlb_thread_sibling(cpu);
 		cpumask_clear_cpu(cpu, &kvm->arch.need_tlb_flush);
 	}
 
-- 
2.23.0

