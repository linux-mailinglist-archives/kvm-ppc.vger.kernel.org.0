Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2A3E9575
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhHKQE3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhHKQE3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6033AC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so10374860pjr.1
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGFwm9eLMc818K8Y7HbXY46Jvms/PHQTfB9Xnbg0In4=;
        b=UKOkMobR524dzmwACOuDHce1apQN8B3xOUPuWeZ+dEAbTPZ7xWGBwUrDeOFqQwhIKf
         vu90SPr2ao5wIranB8XSk/XoEbm9hR7SXqSZtmKj3m/W/w/kdrvnnvGY8/5YtC8mz1sN
         LHWh0E7qj9ZGIoCEYJlg3UHkPpblLCp9wPtW/nygqC5qqdxVWOoP1q0ty94crB2uVxwk
         qZPVCbo7M3ZWNftVYOMOTIzOXZ2KXsIUPtbk3C5AWDwCRVIuBCBkq1rZKVqz+6aH6VMr
         6P8lde9ikwC3rG6R5vECx2XzO3oAAZS9ytowh3BfTBDik3PixzZPIhO14DtYMY0P1tDY
         M8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGFwm9eLMc818K8Y7HbXY46Jvms/PHQTfB9Xnbg0In4=;
        b=I6rcn5wOLrpH3q+qHJXOeeANtMHQKePSjHaF2oGSTjZDKMVzCyxf6tBmmSe6Wcg5C3
         SVU4Gxj2MDdW1QrkEp7jSE6gAu1VOySKL70EUPQ1nl5sKmRVADMGstWW0MDh+SzIoLLf
         +yKTk1JqJgk8HDS/xyJ/PaXIJnNlfwyopcxCVayC4oape7icqLO/dnfuH/7w026PANV5
         Tw7yg7BwUyD4+j+zc6E6keHkal6/1IweT0kCjWY4xR6YmLqRaiyj1C4YwMck7mmES+7L
         cZmYzQ90IUX7o7UsIsJpLbxtXJ7f6QNVZniSK7R5KNitDdEs8eyPjUk80y4kjfB6H0+j
         n7gA==
X-Gm-Message-State: AOAM531MEaN+JhKFtWQ9j93TamsaYtadRJvHf/YbuITNaC2CwOgYDM3V
        78RmwZ/44TR6CKN0lBaIkI/urD0PwCc=
X-Google-Smtp-Source: ABdhPJz0cgfxKnR+wqNYHrawFiUMpNNJFs8wHnfFYJOWIj1C27SkzJRTWtm2J0AqLhTROVRE3ixSKw==
X-Received: by 2002:a17:90a:1d44:: with SMTP id u4mr11329555pju.119.1628697844869;
        Wed, 11 Aug 2021 09:04:04 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 54/60] KVM: PPC: Book3S HV P9: Avoid changing MSR[RI] in entry and exit
Date:   Thu, 12 Aug 2021 02:01:28 +1000
Message-Id: <20210811160134.904987-55-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

From: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 50 ++++++++++++---------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index cb865fe2580d..5745a49021c3 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -825,7 +825,15 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -837,14 +845,10 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
@@ -899,19 +903,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -969,13 +970,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -1075,7 +1069,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
+	barrier(); /* Close in_guest critical section */
+	WRITE_ONCE(local_paca->kvm_hstate.in_guest, KVM_GUEST_MODE_NONE);
+	/* Interrupts are recoverable at this point */
 
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
-- 
2.23.0

