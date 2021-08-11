Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629873E9571
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhHKQET (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhHKQET (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943D5C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:55 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d17so3263638plr.12
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ln6cdzeucykGbF0vTkTvQZAkd6bVcCqA4wzaEbEDif0=;
        b=oD0jskWxqr7aS/KUJbVu8G2XpHq5H/isMbATGUXHSULeArmjmPzb1JFu64rUrLP4t8
         MpxKHSQsLhCAgfQFPWZ9v1RJjw5u5cuRFYBX+tCk58d/ApJCgh4x747a+NPYeEFIi9QF
         EnYTp0504WSqmFDwomy+g94kBiTsVmFcZDKxWI5aKGdUYNuKOpyOsr5HH4PqO9oQWbmS
         INs5ellFjuo1T9cPWv5kSb7b1cxkGcNhFYwVXFyBkmI8EKFNcNn5bbyyC+u/POMtlHMy
         XZkWaGjRFoeoNuANV0BJDVLR8YqoH/3uEsWHVtQOLl3UDRqnp6HZmcVIEBQwqfFZz7A/
         KX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ln6cdzeucykGbF0vTkTvQZAkd6bVcCqA4wzaEbEDif0=;
        b=pBx5s2Ka1e3HPI4ivxHO+A5QpZhZcGReNkJ4LClRDpYMXDnI+k+6gLUeO0tKyOQAj/
         Vzj+HMffUGLzVXU5rG3xXhMIWnG7FA9NokH+sScBC16mBk5gwR2ed7peQR/NuN33HY3S
         41egfdYUVG96fDDK6T9DsZXEv00MB6zJaPOZipCscW2R41MrFMF4DHzg34/jIbUe9Vl7
         Qxdti7nRfYeAVosSBd0h21BueG9h+ZHFwRlWkTOx3hVdVZazfFiAFtdr/GWje82qTNEm
         clR7RkekeWK1KQ8GrYM7XiPQZNln4WD7P/wQEY4zpDt/Ov6uPpbjJJDCZuR5EgB/pHPX
         2Gxw==
X-Gm-Message-State: AOAM530w/sx6v6bpTxjSBS8FmhM/2lsOnybgFPukIxZyopfdgHO4msTX
        /jYUO0AA/DeZCeQPI4wAYvlnnZH64mg=
X-Google-Smtp-Source: ABdhPJwlcB+1WRxjCluA6sdnTpIqSepiajUMT2RVFM4FcH9PPRIkQXbUMBapQGtwW7FJc/YoF46OIw==
X-Received: by 2002:a17:90a:ba8e:: with SMTP id t14mr38079862pjr.176.1628697835026;
        Wed, 11 Aug 2021 09:03:55 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 50/60] KVM: PPC: Book3S HV P9: Avoid tlbsync sequence on radix guest exit
Date:   Thu, 12 Aug 2021 02:01:24 +1000
Message-Id: <20210811160134.904987-51-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use the existing TLB flushing logic to IPI the previous CPU and run the
necessary barriers before running a guest vCPU on a new physical CPU,
to do the necessary radix GTSE barriers for handling the case of an
interrupted guest tlbie sequence.

This results in more IPIs than the TLB flush logic requires, but it's
a significant win for common case scheduling when the vCPU remains on
the same physical CPU.

This saves about 520 cycles (nearly 10%) on a guest entry+exit micro
benchmark on a POWER9.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 31 +++++++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  9 --------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3983c5fa065a..7d08b826d355 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3028,6 +3028,25 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 			smp_call_function_single(i, do_nothing, NULL, 1);
 }
 
+static void do_migrate_away_vcpu(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	struct kvm *kvm = vcpu->kvm;
+
+	/*
+	 * If the guest has GTSE, it may execute tlbie, so do a eieio; tlbsync;
+	 * ptesync sequence on the old CPU before migrating to a new one, in
+	 * case we interrupted the guest between a tlbie ; eieio ;
+	 * tlbsync; ptesync sequence.
+	 *
+	 * Otherwise, ptesync is sufficient.
+	 */
+	if (kvm->arch.lpcr & LPCR_GTSE)
+		asm volatile("eieio; tlbsync; ptesync");
+	else
+		asm volatile("ptesync");
+}
+
 static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 {
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -3055,10 +3074,14 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	 * so we use a single bit in .need_tlb_flush for all 4 threads.
 	 */
 	if (prev_cpu != pcpu) {
-		if (prev_cpu >= 0 &&
-		    cpu_first_tlb_thread_sibling(prev_cpu) !=
-		    cpu_first_tlb_thread_sibling(pcpu))
-			radix_flush_cpu(kvm, prev_cpu, vcpu);
+		if (prev_cpu >= 0) {
+			if (cpu_first_tlb_thread_sibling(prev_cpu) !=
+			    cpu_first_tlb_thread_sibling(pcpu))
+				radix_flush_cpu(kvm, prev_cpu, vcpu);
+
+			smp_call_function_single(prev_cpu,
+					do_migrate_away_vcpu, vcpu, 1);
+		}
 		if (nested)
 			nested->prev_cpu[vcpu->arch.nested_vcpu_id] = pcpu;
 		else
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 183d5884e362..94b15294a388 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -1045,15 +1045,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
-	if (kvm_is_radix(kvm)) {
-		/*
-		 * Since this is radix, do a eieio; tlbsync; ptesync sequence
-		 * in case we interrupted the guest between a tlbie and a
-		 * ptesync.
-		 */
-		asm volatile("eieio; tlbsync; ptesync");
-	}
-
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
 	 * to clear the copy buffer that was under control of the guest.
-- 
2.23.0

