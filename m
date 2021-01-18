Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A24C2FA279
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 15:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392625AbhAROE4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 09:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391440AbhARM06 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 07:26:58 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C93FC061573
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 04:26:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id kx7so163311pjb.2
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 04:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVfhBrBc4bRhWEYaMdwcW79J/KS3SFlxun+R1Uj1eXU=;
        b=On3XP3a3BY0kh1TareEHF1WeVCC5eq2vIVMzv44lvynxhGvnwHUEcEnD6gYdSvIi2d
         ev5Y0DhuGWz8DJiWB9C6dXq1HSUAQ2EzbrNxPTXYzNqXYgWkuDOGbSlJnaMyox98dkLj
         0FJiLI5fOhJw6sduO61HMumGA+sUe9547W/Bm9MmsZRwvdHfiWph4BVj8V7745TKCYJf
         6FgIDPBGiGN19lHNMi+xE/0RIqK1YYj8saqJ3Xkv7rZbLV5M6RNP0sKyLzC8WsaoJhCs
         PxhzU5cCfjkaCMErfNNZNQxUte14Ak9d3j8YHhs1tl2DSaZx1Ya8D/LqtyPPdM+aXH2G
         /ROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EVfhBrBc4bRhWEYaMdwcW79J/KS3SFlxun+R1Uj1eXU=;
        b=PZAW2fpCjdaboOW55RTfd8FwxRuVCll862yjSYHZG6M5cMGiqLFT7Y+ZamXsOo5Su+
         T5pYEnhljLFI1QHzHPFF3OerGudEmwbYKb4wLKXFYUcnaFPbOFycrBUilyMuZwiExK5d
         qKa7nHC6dY1gYK5CFlBZ2Slg8MhsvxL59nR6a6MdwkehoBQY+bCwj+mfFN8U+GTiKV2u
         nzi1FoINJ8eyXIFoThHrZzMUOh1IHDZeXPwhW90DG1z/Fl6o4gDMhvGgbm7+6eYDA607
         p1VhM5HXB+6J/GiSe9BQr6XgqKpVOpOoa3vKfx7tE6D1Ey2DiuQwe5A/WN+eZvHpPE02
         PvZg==
X-Gm-Message-State: AOAM532HVCuN0TGUAQCFlTEXp+iBrH30g8EZzrHjKpOpDFdp4Ph2MMBw
        GJN8SKTuGJ9obvNNFIdRuxvZ85Bunos=
X-Google-Smtp-Source: ABdhPJxs8Dq1VNINpn+3xDNUm1xm3HTQZoVuZQfOkT0U4jf7mnfthiIGzQpWds62KetZdKnhp6w9tQ==
X-Received: by 2002:a17:902:6b02:b029:da:c6c0:d650 with SMTP id o2-20020a1709026b02b02900dac6c0d650mr26480557plk.74.1610972777777;
        Mon, 18 Jan 2021 04:26:17 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id h3sm15896098pgm.67.2021.01.18.04.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 04:26:17 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: Remove shared-TLB optimisation from vCPU TLB coherency logic
Date:   Mon, 18 Jan 2021 22:26:08 +1000
Message-Id: <20210118122609.1447366-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Processors that implement ISA v3.0 or later don't necessarily have
threads in a core sharing all translations, and/or TLBIEL does not
necessarily invalidate translations on all other threads (the
architecture talks only about the effect on translations for "the thread
executing the tlbiel instruction".

While this worked for POWER9, it may not for future implementations, so
remove it. A POWER9 specific optimisation would have to have a specific
CPU feature to check, if it were to be re-added.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c         | 32 +++++++++++++++++++---------
 arch/powerpc/kvm/book3s_hv_builtin.c |  9 --------
 arch/powerpc/kvm/book3s_hv_rm_mmu.c  |  6 ------
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2d8627dbd9f6..752daf43f780 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2588,22 +2588,34 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 {
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	cpumask_t *cpu_in_guest;
+	cpumask_t *need_tlb_flush;
 	int i;
 
-	cpu = cpu_first_thread_sibling(cpu);
 	if (nested) {
-		cpumask_set_cpu(cpu, &nested->need_tlb_flush);
+		need_tlb_flush = &nested->need_tlb_flush;
 		cpu_in_guest = &nested->cpu_in_guest;
 	} else {
-		cpumask_set_cpu(cpu, &kvm->arch.need_tlb_flush);
+		need_tlb_flush = &kvm->arch.need_tlb_flush;
 		cpu_in_guest = &kvm->arch.cpu_in_guest;
 	}
+
+	cpu = cpu_first_thread_sibling(cpu);
+	for (i = 0; i < threads_per_core; ++i)
+		cpumask_set_cpu(cpu + i, need_tlb_flush);
+
 	/*
-	 * Make sure setting of bit in need_tlb_flush precedes
+	 * Make sure setting of bits in need_tlb_flush precedes
 	 * testing of cpu_in_guest bits.  The matching barrier on
 	 * the other side is the first smp_mb() in kvmppc_run_core().
 	 */
 	smp_mb();
+
+	/*
+	 * Pull vcpus out of guests if necessary, such that they'll notice
+	 * the need_tlb_flush bit when they re-enter the guest. If this was
+	 * ever a performance concern, it would be interesting to compare
+	 * with performance of using TLBIE.
+	 */
 	for (i = 0; i < threads_per_core; ++i)
 		if (cpumask_test_cpu(cpu + i, cpu_in_guest))
 			smp_call_function_single(cpu + i, do_nothing, NULL, 1);
@@ -2632,18 +2644,18 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	 * can move around between pcpus.  To cope with this, when
 	 * a vcpu moves from one pcpu to another, we need to tell
 	 * any vcpus running on the same core as this vcpu previously
-	 * ran to flush the TLB.  The TLB is shared between threads,
-	 * so we use a single bit in .need_tlb_flush for all 4 threads.
+	 * ran to flush the TLB.
 	 */
 	if (prev_cpu != pcpu) {
-		if (prev_cpu >= 0 &&
-		    cpu_first_thread_sibling(prev_cpu) !=
-		    cpu_first_thread_sibling(pcpu))
-			radix_flush_cpu(kvm, prev_cpu, vcpu);
 		if (nested)
 			nested->prev_cpu[vcpu->arch.nested_vcpu_id] = pcpu;
 		else
 			vcpu->arch.prev_cpu = pcpu;
+
+		if (prev_cpu < 0)
+			return; /* first run */
+
+		radix_flush_cpu(kvm, prev_cpu, vcpu);
 	}
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index f3d3183249fe..dad118760a4e 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -789,15 +789,6 @@ void kvmppc_check_need_tlb_flush(struct kvm *kvm, int pcpu,
 {
 	cpumask_t *need_tlb_flush;
 
-	/*
-	 * On POWER9, individual threads can come in here, but the
-	 * TLB is shared between the 4 threads in a core, hence
-	 * invalidating on one thread invalidates for all.
-	 * Thus we make all 4 threads use the same bit.
-	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_300))
-		pcpu = cpu_first_thread_sibling(pcpu);
-
 	if (nested)
 		need_tlb_flush = &nested->need_tlb_flush;
 	else
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 88da2764c1bb..f87237927096 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -62,12 +62,6 @@ static int global_invalidates(struct kvm *kvm)
 		smp_wmb();
 		cpumask_setall(&kvm->arch.need_tlb_flush);
 		cpu = local_paca->kvm_hstate.kvm_vcore->pcpu;
-		/*
-		 * On POWER9, threads are independent but the TLB is shared,
-		 * so use the bit for the first thread to represent the core.
-		 */
-		if (cpu_has_feature(CPU_FTR_ARCH_300))
-			cpu = cpu_first_thread_sibling(cpu);
 		cpumask_clear_cpu(cpu, &kvm->arch.need_tlb_flush);
 	}
 
-- 
2.23.0

