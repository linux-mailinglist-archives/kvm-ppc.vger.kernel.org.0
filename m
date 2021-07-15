Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E980B3C9F39
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbhGONS1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONS0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D2BC06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso4137187pjp.5
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QqHqtvZb6+Pm+8g3m8ALUWyG/qaVFq846tO0Idu5F9s=;
        b=qtbNk+iziUvE+kp/nGNUhDo9+yPAmhMFmvRLjq7mMzHpApNtJI9B5r3boU3MpLUwDW
         Mb03j8pKuIc1ltg5JzwHaygJp5RmchLy3nmdTY1HbXRhXV4dLfNCIxzAKuW9lLiuzNrI
         8rxaaL/AHnsueF2vj6PSKpn6ZQL5fY3AD9hu+YeEhBVPXzwHQoODcOnHuVZlva9xtXfy
         42KksbaiKAns2d+J+Wf69LDPAA8magU/SGViRMXN8y9ZT309y3vLQtoEwcA2AhFJeVj/
         DDsmXSUoJGiZsILT3xIwCbPbbD/M8tiCNIiOFJKAnMGmxSdwNznZQ+lrdG5A6oAaUl5m
         EdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QqHqtvZb6+Pm+8g3m8ALUWyG/qaVFq846tO0Idu5F9s=;
        b=ti/XgmR53Zyh6ak1U9yeTphrsBryR3AVV821CioGf+yH1DND2WMZ4K7gswUt6MWPI9
         89lAmPo+xhSad3qSBjEynKYtYhYDDLzf0mDxALJfoqJCmneU7xg3Mc2Zqh0Ush27+uck
         xRB3GX08/zDTOgvPnKXRlq5kS4HKKdDKdzYE91bInQKMpBTwGDt4rFwlf9lDQpK/gafm
         tcRoo7koiSnUoDY/9+cXutOV+Wy6EnCKOTrxfBdw1wmtRWRiKyZ7RtLMuFktUuZlolpH
         4iJMrNvMWdrvMd8afjnXnihe4IadxNShgJtOe0fDmFtDBj56nELHhPp371uoVBEOLNRQ
         0WKA==
X-Gm-Message-State: AOAM532K8IxtUkSbtkW3bNiE0Z8QMItMdeMcsAo0STNktn6tzrALVtwF
        3Qe8uvpatHKDwRgWQU3drEFW/ADUA9AR8w==
X-Google-Smtp-Source: ABdhPJwKZWdjuZHiXzNQBM5xJzxtLJ5MAamBhN+4qRxV6YRcGETbSSIEBca09wtxQcgctdBF/Z/qxQ==
X-Received: by 2002:a17:90b:2411:: with SMTP id nr17mr4144241pjb.153.1626354932390;
        Thu, 15 Jul 2021 06:15:32 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:32 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 3/6] KVM: PPC: Book3S HV P9: Remove most of the vcore logic
Date:   Thu, 15 Jul 2021 23:15:15 +1000
Message-Id: <20210715131518.146917-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210715131518.146917-1-npiggin@gmail.com>
References: <20210715131518.146917-1-npiggin@gmail.com>
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
index d809566918de..2b02cfe3e456 100644
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
@@ -3097,13 +3120,6 @@ static void kvmppc_start_thread(struct kvm_vcpu *vcpu, struct kvmppc_vcore *vc)
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
@@ -3192,6 +3208,8 @@ static void kvmppc_vcore_preempt(struct kvmppc_vcore *vc)
 {
 	struct preempted_vcore_list *lp = this_cpu_ptr(&preempted_vcores);
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	vc->vcore_state = VCORE_PREEMPT;
 	vc->pcpu = smp_processor_id();
 	if (vc->num_threads < threads_per_vcore(vc->kvm)) {
@@ -3208,6 +3226,8 @@ static void kvmppc_vcore_end_preempt(struct kvmppc_vcore *vc)
 {
 	struct preempted_vcore_list *lp;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	kvmppc_core_end_stolen(vc, mftb());
 	if (!list_empty(&vc->preempt_list)) {
 		lp = &per_cpu(preempted_vcores, vc->pcpu);
@@ -3935,7 +3955,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr, u64 *tb)
 {
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 next_timer;
 	int trap;
 
@@ -3951,9 +3970,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_subcore_enter_guest();
 
-	vc->entry_exit_map = 1;
-	vc->in_guest = 1;
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4006,9 +4022,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	vc->entry_exit_map = 0x101;
-	vc->in_guest = 0;
-
 	kvmppc_subcore_exit_guest();
 
 	return trap;
@@ -4074,6 +4087,13 @@ static bool kvmppc_vcpu_woken(struct kvm_vcpu *vcpu)
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
@@ -4084,7 +4104,7 @@ static int kvmppc_vcore_check_block(struct kvmppc_vcore *vc)
 	int i;
 
 	for_each_runnable_thread(i, vcpu, vc) {
-		if (!vcpu->arch.ceded || kvmppc_vcpu_woken(vcpu))
+		if (kvmppc_vcpu_check_block(vcpu))
 			return 1;
 	}
 
@@ -4101,6 +4121,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	int do_sleep = 1;
 	u64 block_ns;
 
+	WARN_ON_ONCE(cpu_has_feature(CPU_FTR_ARCH_300));
+
 	/* Poll for pending exceptions and ceded state */
 	cur = start_poll = ktime_get();
 	if (vc->halt_poll_ns) {
@@ -4366,11 +4388,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4388,11 +4406,8 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	kvmppc_update_vpas(vcpu);
 
-	init_vcore_to_run(vc);
-
 	preempt_disable();
 	pcpu = smp_processor_id();
-	vc->pcpu = pcpu;
 	if (kvm_is_radix(kvm))
 		kvmppc_prepare_radix_vcpu(vcpu, pcpu);
 
@@ -4421,21 +4436,23 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
 
@@ -4457,11 +4474,10 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	set_irq_happened(trap);
 
-	kvmppc_set_host_core(pcpu);
-
 	guest_exit_irqoff();
 
-	kvmppc_stop_thread(vcpu);
+	vcpu->cpu = -1;
+	vcpu->arch.thread_cpu = -1;
 
 	powerpc_local_irq_pmu_restore(flags);
 
@@ -4488,28 +4504,31 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
@@ -4593,7 +4612,8 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 
 	kvmppc_save_current_sprs();
 
-	vcpu->arch.waitp = &vcpu->arch.vcore->wait;
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
+		vcpu->arch.waitp = &vcpu->arch.vcore->wait;
 	vcpu->arch.pgdir = kvm->mm->pgd;
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
@@ -5055,6 +5075,9 @@ void kvmppc_alloc_host_rm_ops(void)
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

