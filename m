Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84583DEFE5
	for <lists+kvm-ppc@lfdr.de>; Tue,  3 Aug 2021 16:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhHCORS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 3 Aug 2021 10:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbhHCORS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 3 Aug 2021 10:17:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56EC061764;
        Tue,  3 Aug 2021 07:17:06 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHPrHYGQ8v1XEJpOG6LdVnCzD7dhUki+Kf02opOvfjU=;
        b=ZqWIXiuVrluOH6iMS6Xlm9z7Ed3vOeofFPYHEViqoTIPemJarf5N37Ne63K+k3xJAO4NuJ
        2yzS9PVdJ44DqcS/3f+nH5UCVQU49tGOQtnvcLGlLpPsg9xtMGM5GddgB8eLeGqBYZQOYM
        tar59mvdyYqpgyFPDFY2cEXsWZ0TwoKLK4xOOcISCB4SV48PeSqXHVOM7I7hBGqN7dGh67
        T4zW2qFOMLBa4jNyBJW0i/W6shbcyqtFyW+NfqDAFuuYGOzAJ7oMSVnU9RzPxcnkCz91pC
        bIAvE1hI0YXr8g1Iq94DxJNv4UQt98IP66mJMncNkgRwt64G8BvnwOI9H4lemg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHPrHYGQ8v1XEJpOG6LdVnCzD7dhUki+Kf02opOvfjU=;
        b=6wt1eryPb47jrAEEQtsyqUMvEE2Jnwi1ug80WIzJ6t1diQJMBy4yg75wT0OqzN7iDwBoyE
        v/7Q+HrPVFVnC2Aw==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 03/38] powerpc: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:15:46 +0200
Message-Id: <20210803141621.780504-4-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm-ppc@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/powerpc/kernel/rtasd.c               |  4 ++--
 arch/powerpc/kvm/book3s_hv_builtin.c      | 10 +++++-----
 arch/powerpc/platforms/powernv/idle.c     |  4 ++--
 arch/powerpc/platforms/powernv/opal-imc.c |  8 ++++----
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 8561dfb33f241..32ee17753eb4a 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -429,7 +429,7 @@ static void rtas_event_scan(struct work_struct *w)
=20
 	do_event_scan();
=20
-	get_online_cpus();
+	cpus_read_lock();
=20
 	/* raw_ OK because just using CPU as starting point. */
 	cpu =3D cpumask_next(raw_smp_processor_id(), cpu_online_mask);
@@ -451,7 +451,7 @@ static void rtas_event_scan(struct work_struct *w)
 	schedule_delayed_work_on(cpu, &event_scan_work,
 		__round_jiffies_relative(event_scan_delay, cpu));
=20
-	put_online_cpus();
+	cpus_read_unlock();
 }
=20
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s=
_hv_builtin.c
index be8ef1c5b1bfb..fcf4760a3a0ea 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -137,23 +137,23 @@ long int kvmppc_rm_h_confer(struct kvm_vcpu *vcpu, in=
t target,
  * exist in the system. We use a counter of VMs to track this.
  *
  * One of the operations we need to block is onlining of secondaries, so we
- * protect hv_vm_count with get/put_online_cpus().
+ * protect hv_vm_count with cpus_read_lock/unlock().
  */
 static atomic_t hv_vm_count;
=20
 void kvm_hv_vm_activated(void)
 {
-	get_online_cpus();
+	cpus_read_lock();
 	atomic_inc(&hv_vm_count);
-	put_online_cpus();
+	cpus_read_unlock();
 }
 EXPORT_SYMBOL_GPL(kvm_hv_vm_activated);
=20
 void kvm_hv_vm_deactivated(void)
 {
-	get_online_cpus();
+	cpus_read_lock();
 	atomic_dec(&hv_vm_count);
-	put_online_cpus();
+	cpus_read_unlock();
 }
 EXPORT_SYMBOL_GPL(kvm_hv_vm_deactivated);
=20
diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms=
/powernv/idle.c
index 528a7e0cf83aa..aa27689b832db 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -199,12 +199,12 @@ static ssize_t store_fastsleep_workaround_applyonce(s=
truct device *dev,
 	 */
 	power7_fastsleep_workaround_exit =3D false;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	primary_thread_mask =3D cpu_online_cores_map();
 	on_each_cpu_mask(&primary_thread_mask,
 				pnv_fastsleep_workaround_apply,
 				&err, 1);
-	put_online_cpus();
+	cpus_read_unlock();
 	if (err) {
 		pr_err("fastsleep_workaround_applyonce change failed while running pnv_f=
astsleep_workaround_apply");
 		goto fail;
diff --git a/arch/powerpc/platforms/powernv/opal-imc.c b/arch/powerpc/platf=
orms/powernv/opal-imc.c
index 7824cc364bc40..ba02a75c14102 100644
--- a/arch/powerpc/platforms/powernv/opal-imc.c
+++ b/arch/powerpc/platforms/powernv/opal-imc.c
@@ -186,7 +186,7 @@ static void disable_nest_pmu_counters(void)
 	int nid, cpu;
 	const struct cpumask *l_cpumask;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_node_with_cpus(nid) {
 		l_cpumask =3D cpumask_of_node(nid);
 		cpu =3D cpumask_first_and(l_cpumask, cpu_online_mask);
@@ -195,7 +195,7 @@ static void disable_nest_pmu_counters(void)
 		opal_imc_counters_stop(OPAL_IMC_COUNTERS_NEST,
 				       get_hard_smp_processor_id(cpu));
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 }
=20
 static void disable_core_pmu_counters(void)
@@ -203,7 +203,7 @@ static void disable_core_pmu_counters(void)
 	cpumask_t cores_map;
 	int cpu, rc;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	/* Disable the IMC Core functions */
 	cores_map =3D cpu_online_cores_map();
 	for_each_cpu(cpu, &cores_map) {
@@ -213,7 +213,7 @@ static void disable_core_pmu_counters(void)
 			pr_err("%s: Failed to stop Core (cpu =3D %d)\n",
 				__FUNCTION__, cpu);
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 }
=20
 int get_max_nest_dev(void)
--=20
2.32.0

