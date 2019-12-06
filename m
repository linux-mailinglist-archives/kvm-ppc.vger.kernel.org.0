Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF0114B5B
	for <lists+kvm-ppc@lfdr.de>; Fri,  6 Dec 2019 04:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLFDRw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 5 Dec 2019 22:17:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35995 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFDRw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 5 Dec 2019 22:17:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so1915702pgc.3
        for <kvm-ppc@vger.kernel.org>; Thu, 05 Dec 2019 19:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gkGpgdPUBIiEgGfl9znwx+fNhWGwOTyCZKNW1OnKDWI=;
        b=NivpDNQqCm6+EHJQmbuS/r1/mFkX+QMB85cqTZmH3QLdFI57wW85OXpUIBlMFDay8g
         WwWRn1/IpUw9upaWXLXCD2O6DodzNh7LtVFEwarx8JaHaaI4qIbKKwaXSUdAz0XviS+d
         jGSem92P4JX+DrukV5ycbO7XV77KRvx9qTNeENSyM4ukp3Pxz9tLYOqyZctfFFdnrNEv
         4zA2Tk58DS19NJwLBytaz09Ua5+TUUWINQoc782tRMOHbx2/SBIC1fN1CEDBL1hGPldC
         SMbFcTE1KCxAj7MpqpRa9VbjB+A5Pibd0NRW/dmkLi5e2Szhy3KUrHp5alWIWcqu12lA
         GauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gkGpgdPUBIiEgGfl9znwx+fNhWGwOTyCZKNW1OnKDWI=;
        b=lUDggN+MsOwjL+mSCIKiFcTPdfow0oleLK6S75W/l9BciB2OVHtwDC9cK2nwEZ21Oi
         J9KyQWZwrKcxq2eGoPzZeOuyhlBrcMKXBl43O2aKfrde/ZHBjqHU7ery2DqmzCasmyIM
         5psGv2XVVysSH9rD+x7qGAI0yX31l9KoT1VUzTEvMYbpLm1MFpmDF7jjVQ+CWF4kkFCz
         sHCLYtmcXNMw0YP1/zm0NeCX++2P/d1jdY7UF0oPGAc3ihbLsglsqulRBY0X7kLn2QGe
         doC/oqTccVFhRbbYXoRYxmUCaulMylE/2fy6v3EH4j5MUCi/GD73oYRkJG9fzTME9BwE
         YuQA==
X-Gm-Message-State: APjAAAX8PHKdrRbg9MIGYpEs91CzT1QSsyvvDxx+SHDwMl/r+pdBDej/
        eI/dhzQ3bDeNwdmIZh+c+M2eT34f+Ds=
X-Google-Smtp-Source: APXvYqw3FP4Rmg1+rXKd9S+wTKwCfh/HU6E8rrdBG+sheEXPvtpHSKiE2LV22En6hpK/QqzGopSyMQ==
X-Received: by 2002:a62:fb0e:: with SMTP id x14mr12535849pfm.194.1575602271386;
        Thu, 05 Dec 2019 19:17:51 -0800 (PST)
Received: from tee480.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id o3sm1072635pju.13.2019.12.05.19.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 19:17:50 -0800 (PST)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Cc:     oohall@gmail.com, mpe@ellerman.id.au,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v3] powerpc/mm: Remove kvm radix prefetch workaround for Power9 DD2.2
Date:   Fri,  6 Dec 2019 14:17:22 +1100
Message-Id: <20191206031722.25781-1-jniethe5@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Commit a25bd72badfa ("powerpc/mm/radix: Workaround prefetch issue with
KVM") introduced a number of workarounds as coming out of a guest with
the mmu enabled would make the cpu would start running in hypervisor
state with the PID value from the guest. The cpu will then start
prefetching for the hypervisor with that PID value.

In Power9 DD2.2 the cpu behaviour was modified to fix this. When
accessing Quadrant 0 in hypervisor mode with LPID != 0 prefetching will
not be performed. This means that we can get rid of the workarounds for
Power9 DD2.2 and later revisions. Add a new cpu feature
CPU_FTR_P9_RADIX_PREFETCH_BUG to indicate if the workarounds are needed.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v2: Use a cpu feature instead of open coding the PVR check
v3: Put parentheses around CPU_FTRS_POWER9_DD2_0 value
---
 arch/powerpc/include/asm/cputable.h      |  7 +++++--
 arch/powerpc/kernel/dt_cpu_ftrs.c        | 13 ++++++++-----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  2 ++
 arch/powerpc/mm/book3s64/radix_pgtable.c |  6 +++++-
 arch/powerpc/mm/book3s64/radix_tlb.c     |  3 +++
 5 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index cf00ff0d121d..40a4d3c6fd99 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -212,6 +212,7 @@ static inline void cpu_feature_keys_init(void) { }
 #define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_P9_TIDR			LONG_ASM_CONST(0x0000800000000000)
 #define CPU_FTR_P9_TLBIE_ERAT_BUG	LONG_ASM_CONST(0x0001000000000000)
+#define CPU_FTR_P9_RADIX_PREFETCH_BUG	LONG_ASM_CONST(0x0002000000000000)
 
 #ifndef __ASSEMBLY__
 
@@ -459,8 +460,10 @@ static inline void cpu_feature_keys_init(void) { }
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
 	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_PKEY | \
 	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TLBIE_ERAT_BUG | CPU_FTR_P9_TIDR)
-#define CPU_FTRS_POWER9_DD2_0 CPU_FTRS_POWER9
-#define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1)
+#define CPU_FTRS_POWER9_DD2_0 (CPU_FTRS_POWER9 | CPU_FTR_P9_RADIX_PREFETCH_BUG)
+#define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | \
+			       CPU_FTR_P9_RADIX_PREFETCH_BUG | \
+			       CPU_FTR_POWER9_DD2_1)
 #define CPU_FTRS_POWER9_DD2_2 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1 | \
 			       CPU_FTR_P9_TM_HV_ASSIST | \
 			       CPU_FTR_P9_TM_XER_SO_BUG)
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 180b3a5d1001..182b4047c1ef 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -727,17 +727,20 @@ static __init void cpufeatures_cpu_quirks(void)
 	/*
 	 * Not all quirks can be derived from the cpufeatures device tree.
 	 */
-	if ((version & 0xffffefff) == 0x004e0200)
-		; /* DD2.0 has no feature flag */
-	else if ((version & 0xffffefff) == 0x004e0201)
+	if ((version & 0xffffefff) == 0x004e0200) {
+		/* DD2.0 has no feature flag */
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_RADIX_PREFETCH_BUG;
+	} else if ((version & 0xffffefff) == 0x004e0201) {
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD2_1;
-	else if ((version & 0xffffefff) == 0x004e0202) {
+		cur_cpu_spec->cpu_features |= CPU_FTR_P9_RADIX_PREFETCH_BUG;
+	} else if ((version & 0xffffefff) == 0x004e0202) {
 		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TM_HV_ASSIST;
 		cur_cpu_spec->cpu_features |= CPU_FTR_P9_TM_XER_SO_BUG;
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD2_1;
-	} else if ((version & 0xffff0000) == 0x004e0000)
+	} else if ((version & 0xffff0000) == 0x004e0000) {
 		/* DD2.1 and up have DD2_1 */
 		cur_cpu_spec->cpu_features |= CPU_FTR_POWER9_DD2_1;
+	}
 
 	if ((version & 0xffff0000) == 0x004e0000) {
 		cur_cpu_spec->cpu_features &= ~(CPU_FTR_DAWR);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index faebcbb8c4db..72b08bb17200 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1793,6 +1793,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	tlbsync
 	ptesync
 
+BEGIN_FTR_SECTION
 	/* Radix: Handle the case where the guest used an illegal PID */
 	LOAD_REG_ADDR(r4, mmu_base_pid)
 	lwz	r3, VCPU_GUEST_PID(r9)
@@ -1822,6 +1823,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	addi	r7,r7,0x1000
 	bdnz	1b
 	ptesync
+END_FTR_SECTION_IFSET(CPU_FTR_P9_RADIX_PREFETCH_BUG)
 
 2:
 #endif /* CONFIG_PPC_RADIX_MMU */
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 6ee17d09649c..25cd2a5a6f9f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -336,7 +336,11 @@ static void __init radix_init_pgtable(void)
 	}
 
 	/* Find out how many PID bits are supported */
-	if (cpu_has_feature(CPU_FTR_HVMODE)) {
+	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
+		if (!mmu_pid_bits)
+			mmu_pid_bits = 20;
+		mmu_base_pid = 1;
+	} else if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		if (!mmu_pid_bits)
 			mmu_pid_bits = 20;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 67af871190c6..d3ab36b33650 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1221,6 +1221,9 @@ extern void radix_kvm_prefetch_workaround(struct mm_struct *mm)
 	if (unlikely(pid == MMU_NO_CONTEXT))
 		return;
 
+	if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		return;
+
 	/*
 	 * If this context hasn't run on that CPU before and KVM is
 	 * around, there's a slim chance that the guest on another
-- 
2.20.1

