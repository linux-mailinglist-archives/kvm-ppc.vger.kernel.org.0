Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E7421384
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhJDQEl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJDQEk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B30C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:52 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h3so6337768pgb.7
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vCwWZGrYE8T5YkED8uLzl3raa2ughTUaoc+B3T67xTw=;
        b=cpBuA2+p/mQO3rKiuksM1s0lHQmv86BzOqNOKncg79TDpe6EJeli+QnzXdKgMzlRLs
         99BA0E+OWvTqJPh8gRe32pLGGuokKo0TGClU6753EomRo4z7JEF7FV4vSmknBKqUMXPm
         hwoEVffSfEDOxDcBbMbIZooGE0vkzOpzzLqiAW0OAy178zu6LQoXnSm1rontg7QtjKIJ
         CrUEV//hc/HaWMowRnpjee2Fsi55Qgic1DEH8r3BCTypshYWzeUX1SDhonu7acepCcs1
         RPaazrn1u8lpULKgEUnh/hkl5Bra5Xk7o0vru3LHwsknbiDMaph25u/VVcX1n8wwYSB5
         cneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCwWZGrYE8T5YkED8uLzl3raa2ughTUaoc+B3T67xTw=;
        b=Y7zRmTM/FAkl6KUhPP9AN61A7miBRRuXY0pg+pJIxF5vgTLpsva7OedEm9OVPGk0n3
         buJlsxHda1pVtilAPlJqfK5bUEVUHgU6lpm7A9N+e0uViFKbXC8GZNaSmp/lGuypkh/0
         4UV0ChHQ5Q7j42zWl7cmJkLCqFb/LctJgGLRVhPFibtYZ2A8wZy5pN8QEOGfY1qVMauK
         DsNrioRW7HNlQrbYLM+SWT/TQp4vEYv+9QtM8JvgFVglxsiYwwq8Xo9BA52DkAj26XcS
         jNyhAxOQ/skh7YilGTP017WpQ4fb9NUIDbJwyaIvORBbDixX5riOZSlJllmpJ3pxHQ07
         zixg==
X-Gm-Message-State: AOAM5339UIevBq2Wyh4WIgGBDEQd0fOUeUvyYrwEpYoU960gMEh9aSX1
        0C6FUUMS+QFrSTFXekOaOqvVH/Bb5Y0=
X-Google-Smtp-Source: ABdhPJwsgIX03roCMtb6NAeSHPwc6TBmSZsvJ+1epu+plLdCue3rqiWj47CVjfAgsnqf0VTXdwC5GQ==
X-Received: by 2002:a05:6a00:c81:b029:30e:21bf:4c15 with SMTP id a1-20020a056a000c81b029030e21bf4c15mr25167641pfv.70.1633363371378;
        Mon, 04 Oct 2021 09:02:51 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 46/52] KVM: PPC: Book3S HV P9: Avoid changing MSR[RI] in entry and exit
Date:   Tue,  5 Oct 2021 02:00:43 +1000
Message-Id: <20211004160049.1338837-47-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvm_hstate.in_guest provides the equivalent of MSR[RI]=0 protection,
and it covers the existing MSR[RI]=0 section in late entry and early
exit, so clearing and setting MSR[RI] in those cases does not
actually do anything useful.

Remove the RI manipulation and replace it with comments. Make the
in_guest memory accesses a bit closer to a proper critical section
pattern. This speeds up guest entry/exit performance.

This also removes the MSR[RI] warnings which aren't very interesting
and would cause crashes if they hit due to causing an interrupt in
non-recoverable code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 50 ++++++++++++---------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 99ce5805ea28..5a71532a3adf 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -829,7 +829,15 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 * But TM could be split out if this would be a significant benefit.
 	 */
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_HV_P9;
+	/*
+	 * MSR[RI] does not need to be cleared (and is not, for radix guests
+	 * with no prefetch bug), because in_guest is set. If we take a SRESET
+	 * or MCE with in_guest set but still in HV mode, then
+	 * kvmppc_p9_bad_interrupt handles the interrupt, which effectively
+	 * clears MSR[RI] and doesn't return.
+	 */
+	WRITE_ONCE(local_paca->kvm_hstate.in_guest, KVM_GUEST_MODE_HV_P9);
+	barrier(); /* Open in_guest critical section */
 
 	/*
 	 * Hash host, hash guest, or radix guest with prefetch bug, all have
@@ -841,14 +849,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	save_clear_host_mmu(kvm);
 
-	if (kvm_is_radix(kvm)) {
+	if (kvm_is_radix(kvm))
 		switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-		if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-			__mtmsrd(0, 1); /* clear RI */
-
-	} else {
+	else
 		switch_mmu_to_guest_hpt(kvm, vcpu, lpcr);
-	}
 
 	/* TLBIEL uses LPID=LPIDR, so run this after setting guest LPID */
 	kvmppc_check_need_tlb_flush(kvm, vc->pcpu, nested);
@@ -903,19 +907,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vcpu->arch.regs.gpr[3] = local_paca->kvm_hstate.scratch2;
 
 	/*
-	 * Only set RI after reading machine check regs (DAR, DSISR, SRR0/1)
-	 * and hstate scratch (which we need to move into exsave to make
-	 * re-entrant vs SRESET/MCE)
+	 * After reading machine check regs (DAR, DSISR, SRR0/1) and hstate
+	 * scratch (which we need to move into exsave to make re-entrant vs
+	 * SRESET/MCE), register state is protected from reentrancy. However
+	 * timebase, MMU, among other state is still set to guest, so don't
+	 * enable MSR[RI] here. It gets enabled at the end, after in_guest
+	 * is cleared.
+	 *
+	 * It is possible an NMI could come in here, which is why it is
+	 * important to save the above state early so it can be debugged.
 	 */
-	if (ri_set) {
-		if (unlikely(!(mfmsr() & MSR_RI))) {
-			__mtmsrd(MSR_RI, 1);
-			WARN_ON_ONCE(1);
-		}
-	} else {
-		WARN_ON_ONCE(mfmsr() & MSR_RI);
-		__mtmsrd(MSR_RI, 1);
-	}
 
 	vcpu->arch.regs.gpr[9] = exsave[EX_R9/sizeof(u64)];
 	vcpu->arch.regs.gpr[10] = exsave[EX_R10/sizeof(u64)];
@@ -973,13 +974,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 				 */
 				mtspr(SPRN_HSRR0, vcpu->arch.regs.nip);
 				mtspr(SPRN_HSRR1, vcpu->arch.shregs.msr);
-
-				/*
-				 * tm_return_to_guest re-loads SRR0/1, DAR,
-				 * DSISR after RI is cleared, in case they had
-				 * been clobbered by a MCE.
-				 */
-				__mtmsrd(0, 1); /* clear RI */
 				goto tm_return_to_guest;
 			}
 		}
@@ -1079,7 +1073,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
+	barrier(); /* Close in_guest critical section */
+	WRITE_ONCE(local_paca->kvm_hstate.in_guest, KVM_GUEST_MODE_NONE);
+	/* Interrupts are recoverable at this point */
 
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
-- 
2.23.0

