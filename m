Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5BD3D51E1
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhGZDMR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhGZDMQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018DEC061760
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ch6so2118701pjb.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iUws3UTIX1TvCQYo2LYjoB9sUWO54hgibFdVZfokms4=;
        b=fYWRJi9Qmh8c7vxOZ2Mj0IA9wn7JYkndfcdC/tjT9rAPlpL6LepCTX8YBvyC52DyZf
         3YB/i+T6HF3yfMG6udn04kDM90XRB0lu3HGzl4fk0lr42wvKDBTCi6pYqtqN132Epdcv
         x4DykmcWnI/Ja6m0fQHNpzX+0vWlvPUVAU0Jjtv+mLpEq8MkHSG2+QEZjbfjJ33XKLXo
         u5kH5hrUXuXiDyNZ1z3O0APfNyu8nS9adxrk07t3OyW0sB9vFjMXkmHLaoMJoStt4xwD
         WtVVAOEPypmxuL4zLDrl7JUJSzrPAVWfBBi3AF2OUQAGx2LkFfLNoJdZu4DeIR2l52t7
         s/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUws3UTIX1TvCQYo2LYjoB9sUWO54hgibFdVZfokms4=;
        b=D8jjWU5p3GA2i+ps3P3emt15gadEEH9Q0N31rl3Sgj06sMKt8Qn6Rvl8NWpHeSTmEe
         eQLuKH1X1VmOLmXVTYLOvZDiJwpQRbvxRe+ldz3X/5Zbv1DASf19t2MICuuZ6wXsGdua
         YOTNq1Md8FO3sKOh6XFkTH+9jcWdb43QcUqYe6VwOjxEb2deZqnB3YuP77vyvbSGPfuD
         xufnYdqJ7ADiZvquxbWlm73n1AcCgS2DntchZjkJD6ffrpBxN8x7X5KWUZng2Kc23yLu
         68cCquB0nhLf+Z+NA/xt9DN2bOFna+OQn57xlP/Emy/miaplDCJOfz3z49o4r/8a0aEL
         5vvg==
X-Gm-Message-State: AOAM53174wlBFd0Lj28aKRCeJIS7ShjMSLXvnZx9IdG0r4ti0KmlI+Iw
        Kvcrxp07b0wcz2qzAriDkk05QtbY+PI=
X-Google-Smtp-Source: ABdhPJw/wTtyRvCoMNn5B6X6n/f2xubB+bOFBGnWOyLXRjHnaW4xpkEWJCf3Uhss5JITW177qQYxMg==
X-Received: by 2002:a65:62da:: with SMTP id m26mr16257272pgv.370.1627271564384;
        Sun, 25 Jul 2021 20:52:44 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 52/55] KVM: PPC: Book3S HV P9: Remove most of the vcore logic
Date:   Mon, 26 Jul 2021 13:50:33 +1000
Message-Id: <20210726035036.739609-53-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The P9 path always uses one vcpu per vcore, so none of the the vcore,
locks, stolen time, blocking logic, shared waitq, etc., is required.

Remove most of it.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 147 ++++++++++++++++++++---------------
 1 file changed, 85 insertions(+), 62 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f29fa7d77cc..f83ae33e875c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -281,6 +281,8 @@ static void kvmppc_core_start_stolen(struct kvmppc_vcore *vc, u64 tb)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	spin_lock_irqsave(&vc->stoltb_lock, flags);
 	vc->preempt_tb = tb;
 	spin_unlock_irqrestore(&vc->stoltb_lock, flags);
@@ -290,6 +292,8 @@ static void kvmppc_core_end_stolen(struct kvmppc_vcore *vc, u64 tb)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	spin_lock_irqsave(&vc->stoltb_lock, flags);
 	if (vc->preempt_tb != TB_NIL) {
 		vc->stolen_tb += tb - vc->preempt_tb;
@@ -302,7 +306,12 @@ static void kvmppc_core_vcpu_load_hv(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long flags;
-	u64 now = mftb();
+	u64 now;
+
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		return;
+
+	now = mftb();
 
 	/*
 	 * We can test vc->runner without taking the vcore lock,
@@ -326,7 +335,12 @@ static void kvmppc_core_vcpu_put_hv(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	unsigned long flags;
-	u64 now = mftb();
+	u64 now;
+
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		return;
+
+	now = mftb();
 
 	if (vc->runner == vcpu && vc->vcore_state >= VCORE_SLEEPING)
 		kvmppc_core_start_stolen(vc, now);
@@ -678,6 +692,8 @@ static u64 vcore_stolen_time(struct kvmppc_vcore *vc, u64 now)
 	u64 p;
 	unsigned long flags;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	spin_lock_irqsave(&vc->stoltb_lock, flags);
 	p = vc->stolen_tb;
 	if (vc->vcore_state != VCORE_INACTIVE &&
@@ -700,13 +716,19 @@ static void kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
 	dt = vcpu->arch.dtl_ptr;
 	vpa = vcpu->arch.vpa.pinned_addr;
 	now = tb;
-	core_stolen = vcore_stolen_time(vc, now);
-	stolen = core_stolen - vcpu->arch.stolen_logged;
-	vcpu->arch.stolen_logged = core_stolen;
-	spin_lock_irqsave(&vcpu->arch.tbacct_lock, flags);
-	stolen += vcpu->arch.busy_stolen;
-	vcpu->arch.busy_stolen = 0;
-	spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
+
+	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
+		stolen = 0;
+	} else {
+		core_stolen = vcore_stolen_time(vc, now);
+		stolen = core_stolen - vcpu->arch.stolen_logged;
+		vcpu->arch.stolen_logged = core_stolen;
+		spin_lock_irqsave(&vcpu->arch.tbacct_lock, flags);
+		stolen += vcpu->arch.busy_stolen;
+		vcpu->arch.busy_stolen = 0;
+		spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
+	}
+
 	if (!dt || !vpa)
 		return;
 	memset(dt, 0, sizeof(struct dtl_entry));
@@ -903,13 +925,14 @@ static int kvm_arch_vcpu_yield_to(struct kvm_vcpu *target)
 	 * mode handler is not called but no other threads are in the
 	 * source vcore.
 	 */
-
-	spin_lock(&vcore->lock);
-	if (target->arch.state == KVMPPC_VCPU_RUNNABLE &&
-	    vcore->vcore_state != VCORE_INACTIVE &&
-	    vcore->runner)
-		target = vcore->runner;
-	spin_unlock(&vcore->lock);
+	if (!cpu_has_feature(CPU_FTR_ARCH_300)) {
+		spin_lock(&vcore->lock);
+		if (target->arch.state == KVMPPC_VCPU_RUNNABLE &&
+		    vcore->vcore_state != VCORE_INACTIVE &&
+		    vcore->runner)
+			target = vcore->runner;
+		spin_unlock(&vcore->lock);
+	}
 
 	return kvm_vcpu_yield_to(target);
 }
@@ -3105,13 +3128,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
 		kvmppc_ipi_thread(cpu);
 }
 
-/* Old path does this in asm */
-static void kvmppc_stop_thread(struct kvm_vcpu *vcpu)
-{
-	vcpu->cpu = -1;
-	vcpu->arch.thread_cpu = -1;
-}
-
 static void kvmppc_wait_for_nap(int n_threads)
 {
 	int cpu = smp_processor_id();
@@ -3200,6 +3216,8 @@ static void kvmppc_vcore_preempt(struct kvmppc_vcore *vc)
 {
 	struct preempted_vcore_list *lp = this_cpu_ptr(&preempted_vcores);
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	vc->vcore_state = VCORE_PREEMPT;
 	vc->pcpu = smp_processor_id();
 	if (vc->num_threads < threads_per_vcore(vc->kvm)) {
@@ -3216,6 +3234,8 @@ static void kvmppc_vcore_end_preempt(struct kvmppc_vcore *vc)
 {
 	struct preempted_vcore_list *lp;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	kvmppc_core_end_stolen(vc, mftb());
 	if (!list_empty(&vc->preempt_list)) {
 		lp = &per_cpu(preempted_vcores, vc->pcpu);
@@ -3944,7 +3964,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr, u64 *tb)
 {
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 next_timer;
 	int trap;
 
@@ -3960,9 +3979,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_subcore_enter_guest();
 
-	vc->entry_exit_map = 1;
-	vc->in_guest = 1;
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4015,9 +4031,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	vc->entry_exit_map = 0x101;
-	vc->in_guest = 0;
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
@@ -4083,6 +4096,13 @@ static bool kvmppc_vcpu_woken(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static bool kvmppc_vcpu_check_block(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.ceded || kvmppc_vcpu_woken(vcpu))
+		return true;
+	return false;
+}
+
 /*
  * Check to see if any of the runnable vcpus on the vcore have pending
  * exceptions or are no longer ceded
@@ -4093,7 +4113,7 @@ static int kvmppc_vcore_check_block(struct kvmppc_vcore *vc)
 	int i;
 
 	for_each_runnable_thread(i, vcpu, vc) {
-		if (!vcpu->arch.ceded || kvmppc_vcpu_woken(vcpu))
+		if (kvmppc_vcpu_check_block(vcpu))
 			return 1;
 	}
 
@@ -4110,6 +4130,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	int do_sleep = 1;
 	u64 block_ns;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	/* Poll for pending exceptions and ceded state */
 	cur = start_poll = ktime_get();
 	if (vc->halt_poll_ns) {
@@ -4375,11 +4397,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu->arch.ceded = 0;
 	vcpu->arch.run_task = current;
 	vcpu->arch.state = KVMPPC_VCPU_RUNNABLE;
-	vcpu->arch.busy_preempt = TB_NIL;
 	vcpu->arch.last_inst = KVM_INST_FETCH_FAILED;
-	vc->runnable_threads[0] = vcpu;
-	vc->n_runnable = 1;
-	vc->runner = vcpu;
 
 	/* See if the MMU is ready to go */
 	if (unlikely(!kvm->arch.mmu_ready)) {
@@ -4397,11 +4415,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_update_vpas(vcpu);
 
-	init_vcore_to_run(vc);
-
 	preempt_disable();
 	pcpu = smp_processor_id();
-	vc->pcpu = pcpu;
 	if (kvm_is_radix(kvm))
 		kvmppc_prepare_radix_vcpu(vcpu, pcpu);
 
@@ -4430,21 +4445,23 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 		goto out;
 	}
 
-	tb = mftb();
+	if (vcpu->arch.timer_running) {
+		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);
+		vcpu->arch.timer_running = 0;
+	}
 
-	vcpu->arch.stolen_logged = vcore_stolen_time(vc, tb);
-	vc->preempt_tb = TB_NIL;
+	tb = mftb();
 
-	kvmppc_clear_host_core(pcpu);
+	vcpu->cpu = pcpu;
+	vcpu->arch.thread_cpu = pcpu;
+	local_paca->kvm_hstate.kvm_vcpu = vcpu;
+	local_paca->kvm_hstate.ptid = 0;
+	local_paca->kvm_hstate.fake_suspend = 0;
 
-	local_paca->kvm_hstate.napping = 0;
-	local_paca->kvm_hstate.kvm_split_mode = NULL;
-	kvmppc_start_thread(vcpu, vc);
+	vc->pcpu = pcpu; // for kvmppc_create_dtl_entry
 	kvmppc_create_dtl_entry(vcpu, vc, tb);
-	trace_kvm_guest_enter(vcpu);
 
-	vc->vcore_state = VCORE_RUNNING;
-	trace_kvmppc_run_core(vc, 0);
+	trace_kvm_guest_enter(vcpu);
 
 	guest_enter_irqoff();
 
@@ -4466,11 +4483,10 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	set_irq_happened(trap);
 
-	kvmppc_set_host_core(pcpu);
-
 	guest_exit_irqoff();
 
-	kvmppc_stop_thread(vcpu);
+	vcpu->cpu = -1;
+	vcpu->arch.thread_cpu = -1;
 
 	powerpc_local_irq_pmu_restore(flags);
 
@@ -4497,28 +4513,31 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	}
 	vcpu->arch.ret = r;
 
-	if (is_kvmppc_resume_guest(r) && vcpu->arch.ceded &&
-	    !kvmppc_vcpu_woken(vcpu)) {
+	if (is_kvmppc_resume_guest(r) && !kvmppc_vcpu_check_block(vcpu)) {
 		kvmppc_set_timer(vcpu);
-		while (vcpu->arch.ceded && !kvmppc_vcpu_woken(vcpu)) {
+
+		prepare_to_rcuwait(&vcpu->wait);
+		for (;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
 			if (signal_pending(current)) {
 				vcpu->stat.signal_exits++;
 				run->exit_reason = KVM_EXIT_INTR;
 				vcpu->arch.ret = -EINTR;
 				break;
 			}
-			spin_lock(&vc->lock);
-			kvmppc_vcore_blocked(vc);
-			spin_unlock(&vc->lock);
+
+			if (kvmppc_vcpu_check_block(vcpu))
+				break;
+
+			trace_kvmppc_vcore_blocked(vc, 0);
+			schedule();
+			trace_kvmppc_vcore_blocked(vc, 1);
 		}
+		finish_rcuwait(&vcpu->wait);
 	}
 	vcpu->arch.ceded = 0;
 
-	vc->vcore_state = VCORE_INACTIVE;
-	trace_kvmppc_run_core(vc, 1);
-
  done:
-	kvmppc_remove_runnable(vc, vcpu, tb);
 	trace_kvmppc_run_vcpu_exit(vcpu);
 
 	return vcpu->arch.ret;
@@ -4602,7 +4621,8 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	kvmppc_save_current_sprs();
 
-	vcpu->arch.waitp = &vcpu->arch.vcore->wait;
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
+		vcpu->arch.waitp = &vcpu->arch.vcore->wait;
 	vcpu->arch.pgdir = kvm->mm->pgd;
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
@@ -5064,6 +5084,9 @@ void kvmppc_alloc_host_rm_ops(void)
 	int cpu, core;
 	int size;
 
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
+		return;
+
 	/* Not the first time here ? */
 	if (kvmppc_host_rm_ops_hv != NULL)
 		return;
-- 
2.23.0

