Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF13B021B
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFVLBu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE0CC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m2so16746246pgk.7
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xPyCWheb+1Z64y/WgpLe0xrHcADgbTwB5xPQ8FG4Ops=;
        b=Xa4Jpf5JAtihG3Tn1Q9wB7yMWqgrGxOmf67V2x2/OwQz49+SAK8Es+9SA2UEaU48EJ
         VOTdLB21/H19RJf2HWE6uNaW9EjS8KRw9d4pI7JqySRCTX1HF212tkO2bfvsZ+It+nrE
         mQnL8BodsztStj71KeunAF5bOgN9mYBLLe+ltpd+yWnQIXkAGN8wmLswGcIdkBwQEpgI
         XZlOZUdjh34LrFjU1jTAdu7LnISj5A9J5t2FABjrtUvVJLI2MbIw+cShfo5Xxmg0dwhS
         TyFQOHzsM9oszwQxjNau8YUbuxLCm8OvkyoofgDQi0bQ4Qo8Ue6EaulVnv2iOQSvAMQi
         bUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xPyCWheb+1Z64y/WgpLe0xrHcADgbTwB5xPQ8FG4Ops=;
        b=An3xvi9bP8jt4cayNDktD8h9zKS5NH8x7BkwIuWXMOVFx/CyHpXBBOTOFeChPBaS8j
         Oob4pIFEFvFFqRNt9q+H/0iG4sKezcUDFln7zpysM+8xMsR++Qs/BeJnKpuPF5AsOaet
         hzDkh7MoCMQsIcKYV+g3AU2/fMiEicJS+XMnkoKfybfQoHGXJvyaXJaeU8O7jzrhFg5X
         DoOzoVHvEFkmIEoFBxwbygK58dFafi8smfWHqUPbvbzAdqM3ZjFKSBgeXrhiH9zBFjto
         zi9rINO/XTNpdGykukWarBuhnJ2+LJz+0W1OlbhwOz6S8I8D4lmtc4ThYG3AKtvN21j3
         21Sw==
X-Gm-Message-State: AOAM530Zhi20ovkujzjalR4bf5L5TvVRB6kL1fhSplo/w5LlxAPHOrcA
        QeTYn02QEh8K8phFEF7fnSsF9TvZE0k=
X-Google-Smtp-Source: ABdhPJxJBZn/z6aU2IH4Gchc/1hXFXpzbwIbyEfFC3kMU+HKOCOkjCoIRYRxmswVhvevg+T44l9csg==
X-Received: by 2002:a63:5153:: with SMTP id r19mr3280267pgl.56.1624359572618;
        Tue, 22 Jun 2021 03:59:32 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 40/43] KVM: PPC: Book3S HV P9: Avoid tlbsync sequence on radix guest exit
Date:   Tue, 22 Jun 2021 20:57:33 +1000
Message-Id: <20210622105736.633352-41-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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

-522 cycles (5754) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 31 +++++++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  9 --------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 91bbd0a8f6b6..9d8277a4c829 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2906,6 +2906,25 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
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
@@ -2933,10 +2952,14 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
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
index 4bab56c10254..48b0ce9e0c39 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -994,15 +994,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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

