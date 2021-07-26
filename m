Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC23D51BA
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhGZDLO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDLN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC69C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ch6so2116167pjb.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcPpW+gVoT4ynH1L1M9O+sLZoAI7u1MA7ldnBV8oR7Y=;
        b=vOPZwS02yoJOGLWz4Iy/PiyeyCbWOXHv/4at/U8Vh8SFm4GtkI73RdS+WYVbzP/Z+t
         kAMa95542GpqHu8SyBCfHmBP2lwv5IP/DZZAx/BKSYuIChwaJ3ktqb0ofgrXb7UEicRJ
         BFqspS/o4M1MqtrBynYhzdhci7t9QS/Fu6kSi/u1aQt1LnZRqAiXyPVTnxfQeCtKGCqA
         JLtZwLYhcdHdtpoF/NQAPnDt/3AlHKVXOKYVT0XoWib3y/3Nuna8yBezK69OCtgoz87/
         wro8AYkpcESiUIkUDfyUZG3N89oFJxpRVeoy1pBTOv891E+7cqumPG+tty8rmqloIJuy
         Zlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcPpW+gVoT4ynH1L1M9O+sLZoAI7u1MA7ldnBV8oR7Y=;
        b=paHYjtlmR78F7uBRu5uMh1h2M6SmhQPrucrGIjPYoT+UcnYsx5lCbVXC3re9Re0OFy
         bL9wLJva4EdGmGnaEh5OW9R0VZ+AzzCYPQya5anmCqTSCDeUcMgyO0N7HIQb8xvuq5Zr
         hH91T3bD7Rl+udsxH47ytXaeOx8D+ovd0tOLIMWQ45wmmuEfgKPVa/QQY/wACtx2T2Fe
         AFFGmq70nocD+JrM7gdml0jslRfiYyAzue/iWFPptsltO3i+lsUYd95rYJuFBRcT8bR3
         JMjDQNxGS45R5n+AeXN5U+egCQy4j4cjIxg45Fw69ZRCP89HbVsWGItpLfgBV6m4TXj+
         6PXQ==
X-Gm-Message-State: AOAM530+H5xjTVTQ/Hg+dVhmPjaBw7/R/dE1pd+SV2YJA7LvNtrdAtMc
        9UzuIICndLmInrYB9W2G78pMrtyF14U=
X-Google-Smtp-Source: ABdhPJypQXxe5aG6GybNm+5ublhlaXyP4/3pV0wcw8Z9Sgbhefsl3Umgsds3uIkyF80QP+hKmJy0UQ==
X-Received: by 2002:a63:4c03:: with SMTP id z3mr16084182pga.130.1627271501608;
        Sun, 25 Jul 2021 20:51:41 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 24/55] KVM: PPC: Book3S HV P9: Improve mtmsrd scheduling by delaying MSR[EE] disable
Date:   Mon, 26 Jul 2021 13:50:05 +1000
Message-Id: <20210726035036.739609-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Moving the mtmsrd after the host SPRs are saved and before the guest
SPRs start to be loaded can prevent an SPR scoreboard stall (because
the mtmsrd is L=1 type which does not cause context synchronisation.

This is also now more convenient to combined with the mtmsrd L=0
instruction to enable facilities just below, but that is not done yet.

-12 cycles (7791) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index dedcf3ddba3b..7654235c1507 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4119,6 +4119,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	save_p9_host_os_sprs(&host_os_sprs);
 
+	/*
+	 * This could be combined with MSR[RI] clearing, but that expands
+	 * the unrecoverable window. It would be better to cover unrecoverable
+	 * with KVM bad interrupt handling rather than use MSR[RI] at all.
+	 *
+	 * Much more difficult and less worthwhile to combine with IR/DR
+	 * disable.
+	 */
+	hard_irq_disable();
+	if (lazy_irq_pending())
+		return 0;
+
 	/* MSR bits may have been cleared by context switch */
 	msr = 0;
 	if (IS_ENABLED(CONFIG_PPC_FPU))
@@ -4618,6 +4630,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	struct kvmppc_vcore *vc;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
+	unsigned long flags;
 
 	trace_kvmppc_run_vcpu_enter(vcpu);
 
@@ -4661,11 +4674,11 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (kvm_is_radix(kvm))
 		kvmppc_prepare_radix_vcpu(vcpu, pcpu);
 
-	local_irq_disable();
-	hard_irq_disable();
+	/* flags save not required, but irq_pmu has no disable/enable API */
+	powerpc_local_irq_pmu_save(flags);
 	if (signal_pending(current))
 		goto sigpend;
-	if (lazy_irq_pending() || need_resched() || !kvm->arch.mmu_ready)
+	if (need_resched() || !kvm->arch.mmu_ready)
 		goto out;
 
 	if (!nested) {
@@ -4720,7 +4733,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	guest_exit_irqoff();
 
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 
 	cpumask_clear_cpu(pcpu, &kvm->arch.cpu_in_guest);
 
@@ -4778,7 +4791,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	run->exit_reason = KVM_EXIT_INTR;
 	vcpu->arch.ret = -EINTR;
  out:
-	local_irq_enable();
+	powerpc_local_irq_pmu_restore(flags);
 	preempt_enable();
 	goto done;
 }
-- 
2.23.0

