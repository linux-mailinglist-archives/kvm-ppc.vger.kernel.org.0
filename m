Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F533E954C
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhHKQCx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbhHKQCx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9A4C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so5809865pjb.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/sqZTnORdZuItaT1yAiOHwnavM4EItQXgoU+iu2aPc=;
        b=fAA4kxhEbTwbiOXg5yCqxeDBawIM+5SiKntmU59nwBTx3YG48mZV9UCg70OCuh3RY1
         6gH8dDMObgW8l2UES4ODenHlsxODyww3lPSx4FwEU63f2SpHHIAzxOlAUF8IxaMOaTdX
         hHcPAaEHDgnmKtxvVib6Sbpver9+Gju/6zIVeiLabGGtxpB61pICRtZazWY5ePV0XYIk
         m3Kv9u9kRkXlUG+AJX2to5L07xCljwSxwx3SnaAnLuHCvmF7VJPdOFKdTyGNoijl8mpX
         /50m3BwPnuHYEtP/TA0IjsCyq2JYTVFiqV6/KN7RN35AwXvAwo6PErhTX6Ss7KYWDgBq
         qyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/sqZTnORdZuItaT1yAiOHwnavM4EItQXgoU+iu2aPc=;
        b=J7lmn5J9w7CivVD7QuDqoY4BXIM2CHPGqQlJ3WADLTHeDDcxpAnw1DXRn00npKNZE3
         R6jJrBdadegzAWOX4GPyT4Gdgx6feUsFTvqIbrECrDQoUpfZA/deN7MBC/oaT+yNbRSo
         Y3FLxMi2BfPceu++Jo8BEDm8hMiVqXxrVaGSdhSxqzoncgvN7XQ4VDa7pPcpBsQKmIYX
         SF9ejxRImDFIFk8TXNbFqCMr8/y/JpcqEDoU6XbDmk18P2cDB6lnzWjFfQxDLFnU3++E
         kIHEgdHhNxrliO4wqt9CUXelXQt7vMZpebMXZF0GBrchBCf8EDAsMGcXbQfnwOiuR+fT
         pxlw==
X-Gm-Message-State: AOAM5305pmNd/XHZVMjbfISlBdBAgW35a+0A3yZzCS9VUm/SLr1bfL3p
        GuUnEqbxho+96oRQwvAM79UH55uqBC8=
X-Google-Smtp-Source: ABdhPJxRk5lT65wV9miwWbYeCWtZRrQEo390TolWS+ANIV1KqhWIz6XYlZ8qMGuWUvaAaA42yJu9og==
X-Received: by 2002:a17:90a:4481:: with SMTP id t1mr38069017pjg.232.1628697748797;
        Wed, 11 Aug 2021 09:02:28 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 17/60] powerpc/64s: Keep AMOR SPR a constant ~0 at runtime
Date:   Thu, 12 Aug 2021 02:00:51 +1000
Message-Id: <20210811160134.904987-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This register controls supervisor SPR modifications, and as such is only
relevant for KVM. KVM always sets AMOR to ~0 on guest entry, and never
restores it coming back out to the host, so it can be kept constant and
avoid the mtSPR in KVM guest entry.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/cpu_setup_power.c    |  8 ++++++++
 arch/powerpc/kernel/dt_cpu_ftrs.c        |  2 ++
 arch/powerpc/kvm/book3s_hv_p9_entry.c    |  2 --
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  2 --
 arch/powerpc/mm/book3s64/radix_pgtable.c | 15 ---------------
 arch/powerpc/platforms/powernv/idle.c    |  8 +++-----
 6 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kernel/cpu_setup_power.c b/arch/powerpc/kernel/cpu_setup_power.c
index 3cca88ee96d7..a29dc8326622 100644
--- a/arch/powerpc/kernel/cpu_setup_power.c
+++ b/arch/powerpc/kernel/cpu_setup_power.c
@@ -137,6 +137,7 @@ void __setup_cpu_power7(unsigned long offset, struct cpu_spec *t)
 		return;
 
 	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA206(mfspr(SPRN_LPCR), LPCR_LPES1 >> LPCR_LPES_SH);
 }
@@ -150,6 +151,7 @@ void __restore_cpu_power7(void)
 		return;
 
 	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA206(mfspr(SPRN_LPCR), LPCR_LPES1 >> LPCR_LPES_SH);
 }
@@ -164,6 +166,7 @@ void __setup_cpu_power8(unsigned long offset, struct cpu_spec *t)
 		return;
 
 	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA206(mfspr(SPRN_LPCR) | LPCR_PECEDH, 0); /* LPES = 0 */
 	init_HFSCR();
@@ -184,6 +187,7 @@ void __restore_cpu_power8(void)
 		return;
 
 	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA206(mfspr(SPRN_LPCR) | LPCR_PECEDH, 0); /* LPES = 0 */
 	init_HFSCR();
@@ -202,6 +206,7 @@ void __setup_cpu_power9(unsigned long offset, struct cpu_spec *t)
 	mtspr(SPRN_PSSCR, 0);
 	mtspr(SPRN_LPID, 0);
 	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
 			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
@@ -223,6 +228,7 @@ void __restore_cpu_power9(void)
 	mtspr(SPRN_PSSCR, 0);
 	mtspr(SPRN_LPID, 0);
 	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
 			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
@@ -242,6 +248,7 @@ void __setup_cpu_power10(unsigned long offset, struct cpu_spec *t)
 	mtspr(SPRN_PSSCR, 0);
 	mtspr(SPRN_LPID, 0);
 	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
 			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
@@ -264,6 +271,7 @@ void __restore_cpu_power10(void)
 	mtspr(SPRN_PSSCR, 0);
 	mtspr(SPRN_LPID, 0);
 	mtspr(SPRN_PID, 0);
+	mtspr(SPRN_AMOR, ~0);
 	mtspr(SPRN_PCR, PCR_MASK);
 	init_LPCR_ISA300((mfspr(SPRN_LPCR) | LPCR_PECEDH | LPCR_PECE_HVEE |\
 			 LPCR_HVICE | LPCR_HEIC) & ~(LPCR_UPRT | LPCR_HR), 0);
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index af95f337e54b..38ea20fadc4a 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -80,6 +80,7 @@ static void __restore_cpu_cpufeatures(void)
 	mtspr(SPRN_LPCR, system_registers.lpcr);
 	if (hv_mode) {
 		mtspr(SPRN_LPID, 0);
+		mtspr(SPRN_AMOR, ~0);
 		mtspr(SPRN_HFSCR, system_registers.hfscr);
 		mtspr(SPRN_PCR, system_registers.pcr);
 	}
@@ -216,6 +217,7 @@ static int __init feat_enable_hv(struct dt_cpu_feature *f)
 	}
 
 	mtspr(SPRN_LPID, 0);
+	mtspr(SPRN_AMOR, ~0);
 
 	lpcr = mfspr(SPRN_LPCR);
 	lpcr &=  ~LPCR_LPES0; /* HV external interrupts */
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index bd8cf0a65ce8..a7f63082b4e3 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -286,8 +286,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
 	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
 
-	mtspr(SPRN_AMOR, ~0UL);
-
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_P9;
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 75079397c2a5..9021052f1579 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -772,10 +772,8 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 	/* Restore AMR and UAMOR, set AMOR to all 1s */
 	ld	r5,VCPU_AMR(r4)
 	ld	r6,VCPU_UAMOR(r4)
-	li	r7,-1
 	mtspr	SPRN_AMR,r5
 	mtspr	SPRN_UAMOR,r6
-	mtspr	SPRN_AMOR,r7
 
 	/* Restore state of CTRL run bit; assume 1 on entry */
 	lwz	r5,VCPU_CTRL(r4)
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index e50ddf129c15..5aebd70ef66a 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -572,18 +572,6 @@ void __init radix__early_init_devtree(void)
 	return;
 }
 
-static void radix_init_amor(void)
-{
-	/*
-	* In HV mode, we init AMOR (Authority Mask Override Register) so that
-	* the hypervisor and guest can setup IAMR (Instruction Authority Mask
-	* Register), enable key 0 and set it to 1.
-	*
-	* AMOR = 0b1100 .... 0000 (Mask for key 0 is 11)
-	*/
-	mtspr(SPRN_AMOR, (3ul << 62));
-}
-
 void __init radix__early_init_mmu(void)
 {
 	unsigned long lpcr;
@@ -644,7 +632,6 @@ void __init radix__early_init_mmu(void)
 		lpcr = mfspr(SPRN_LPCR);
 		mtspr(SPRN_LPCR, lpcr | LPCR_UPRT | LPCR_HR);
 		radix_init_partition_table();
-		radix_init_amor();
 	} else {
 		radix_init_pseries();
 	}
@@ -668,8 +655,6 @@ void radix__early_init_mmu_secondary(void)
 
 		set_ptcr_when_no_uv(__pa(partition_tb) |
 				    (PATB_SIZE_SHIFT - 12));
-
-		radix_init_amor();
 	}
 
 	radix__switch_mmu_context(NULL, &init_mm);
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index df19e2ff9d3c..721ac4f7e2d1 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -306,8 +306,8 @@ struct p7_sprs {
 	/* per thread SPRs that get lost in shallow states */
 	u64 amr;
 	u64 iamr;
-	u64 amor;
 	u64 uamor;
+	/* amor is restored to constant ~0 */
 };
 
 static unsigned long power7_idle_insn(unsigned long type)
@@ -378,7 +378,6 @@ static unsigned long power7_idle_insn(unsigned long type)
 	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
 		sprs.amr	= mfspr(SPRN_AMR);
 		sprs.iamr	= mfspr(SPRN_IAMR);
-		sprs.amor	= mfspr(SPRN_AMOR);
 		sprs.uamor	= mfspr(SPRN_UAMOR);
 	}
 
@@ -397,7 +396,7 @@ static unsigned long power7_idle_insn(unsigned long type)
 			 */
 			mtspr(SPRN_AMR,		sprs.amr);
 			mtspr(SPRN_IAMR,	sprs.iamr);
-			mtspr(SPRN_AMOR,	sprs.amor);
+			mtspr(SPRN_AMOR,	~0);
 			mtspr(SPRN_UAMOR,	sprs.uamor);
 		}
 	}
@@ -687,7 +686,6 @@ static unsigned long power9_idle_stop(unsigned long psscr)
 
 	sprs.amr	= mfspr(SPRN_AMR);
 	sprs.iamr	= mfspr(SPRN_IAMR);
-	sprs.amor	= mfspr(SPRN_AMOR);
 	sprs.uamor	= mfspr(SPRN_UAMOR);
 
 	srr1 = isa300_idle_stop_mayloss(psscr);		/* go idle */
@@ -708,7 +706,7 @@ static unsigned long power9_idle_stop(unsigned long psscr)
 		 */
 		mtspr(SPRN_AMR,		sprs.amr);
 		mtspr(SPRN_IAMR,	sprs.iamr);
-		mtspr(SPRN_AMOR,	sprs.amor);
+		mtspr(SPRN_AMOR,	~0);
 		mtspr(SPRN_UAMOR,	sprs.uamor);
 
 		/*
-- 
2.23.0

