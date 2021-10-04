Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BCD421380
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhJDQEc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhJDQEb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:31 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14FC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:42 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r201so11054513pgr.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5szwdcp8gimTWh83kL+eYl+KLG10+CVqh8cwZxo6/c=;
        b=e+GWjShnYaFzfI7wJ36T6V/Zk98hgHTcjWJp5SiZKF0BgPJDFwKIeezIhIZbknJxpk
         6MdZ/d5DshIBXSs/S3Fb7YdC4tAKFGXK98gTPepNe6qmnaRjlgLYaw27t/QFgNfssxUI
         7ML2gx2XlMVhVAmyw/yEiM+SClcgXEDbhs2CEp+wqY/9oIhhYMmMNLMySCZcG/aoOFmQ
         FIkgUpf2zovaTiax/ehXo3uoY+X61juQ/Kfg8VEnZoA8Dv/dZj/QrZzPp2eXULOrqQiM
         1cCeJSQQi2jVgdsZdUJLB9wkg4JcrOPgF1mxQ/Na5w75m+cXyLUiNNTHL0QqATIg7PTF
         fUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5szwdcp8gimTWh83kL+eYl+KLG10+CVqh8cwZxo6/c=;
        b=t5zY4iBjuioseexg9kfTw1jB8i7eX/eIKRI8oRjuybz6MUjW18omKVl6r6Cq5hoS7M
         fhY3WZdjfPP3u6ng3skVIbP6xg8B+K9UALjOPLEGMCmbVfeDbBJumUnAldNf8Tkm8EHC
         +Pp3mW78Q0u/meI3j2AluqKdlvYvpMCtXJnupO1FniGpvNUEQQdMYk2GOk+G006dVEDi
         LHx/01clhj4OhsG0zcUjFtKdJfp+Hi7HmAWJTBUpFCdb+JpDWn77O3TNtKqvCIigqYqE
         g/AuCKFMaXpsQmplTKfH3Wj61jsBnBQydXlVQLag74YbOaEKef/eHnH4GanWVj+oznxV
         XrhA==
X-Gm-Message-State: AOAM533DYkoGncbQKpLo6r1PA1s2R/h9nQmXm1+NVVd/RHgiyfBbXLvn
        QaK5FHpN0/BFB0KHyepVYcqwWX+AFIw=
X-Google-Smtp-Source: ABdhPJwNXUfyXHg1yzKfJoKSyALY7bUoUHvkNOX/NnXrS8Tugninsd4rl5KnNdqFvPh9W/eYBZYAOQ==
X-Received: by 2002:a63:131f:: with SMTP id i31mr11639549pgl.207.1633363362384;
        Mon, 04 Oct 2021 09:02:42 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 42/52] KVM: PPC: Book3S HV P9: Avoid tlbsync sequence on radix guest exit
Date:   Tue,  5 Oct 2021 02:00:39 +1000
Message-Id: <20211004160049.1338837-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index f10cb4167549..d2a9c930f33e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3025,6 +3025,25 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
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
@@ -3052,10 +3071,14 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
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
index eae9d806d704..a45ba584c734 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -1049,15 +1049,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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

