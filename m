Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3B73D51E2
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhGZDMT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhGZDMS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:18 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D9EC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:47 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso17855806pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6yYGFwGtBMz3pGfvtqXbW3QlyXdSr1TV6daCQwMp9Lw=;
        b=SZhCqBvetmL1PmioiHO/N5X374alSsgY6mxVs3IioJLuPWNFZFVdGZo4a/FYu0jDya
         Lwqx6VtLSeAYvT3MBT5t/woStLlo4l3j0HbLfazQjkzv7yvZH753U0PhOouDAfZFdvvK
         VOaZqhXvnY/wxCZKQOuEv6cPFU9Ubz702+wEfiNbtDOTINa0LB8CU6Q7O9s0HT9xg8uw
         QIDWzAM68pl+VIFWVs7pANtwphiev4VXEY6DCQOwE3mf0AC70OYsQXaGC3gCZU+DhDTk
         wxrFYR+2a2EgTl6d0xxXkGAn93EWQ3SOnq485y+n1lWOLu6LgPD3dx0lBg1dZohRTLPS
         R6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yYGFwGtBMz3pGfvtqXbW3QlyXdSr1TV6daCQwMp9Lw=;
        b=BQS+RE+xKKnFu99A6U99NsnVVl6TmhfYrfgcKgpVTzZJ2JS569yCgSuYPYadOr7O17
         YeicL0BGnZsQtJgaqN+/akBpZI9hb1mx38Kbtrv2HTdVllfcsg/hMC/Zk3Bi+Dngo5PF
         +3TnZjmoWeUNZEHUE7JCwO+X6ke6y8/reCY0+mLyzJ1DgqUJ0t33LbFcIY400D8qoe1F
         GgEkAh0L46OrfFdP2b66RTek9iE7QNFSJPuKXAtENMOZ8lbIV492b1RRLHfL10+hNbkk
         AYmMwEdcNVtVSuAqwoqKBQ+nEZ0hXlVOcAv+UPR2BxOIn9dGyz6ypVHaM0nXrxmIAhWk
         qyaA==
X-Gm-Message-State: AOAM533n7eyDZsOS5UDYMtdNa83rdsJjG3aboddBNny/TDM2K1j3umqi
        t9jWk6iV14MeiGACwDL3Hb1LStMaiEQ=
X-Google-Smtp-Source: ABdhPJzAOT5HxVR12j8Q6CgfMrAjIkX/L3bzZd7tfFwDSWOjCX6MXd1ZvsZYeST1AHwYwZw3P9ZKPw==
X-Received: by 2002:a63:1f24:: with SMTP id f36mr16266493pgf.151.1627271566669;
        Sun, 25 Jul 2021 20:52:46 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 53/55] KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
Date:   Mon, 26 Jul 2021 13:50:34 +1000
Message-Id: <20210726035036.739609-54-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This goes further to removing vcores from the P9 path. Also avoid the
memset in favour of explicitly initialising all fields.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 61 +++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f83ae33e875c..f233ff1c18e1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -703,41 +703,30 @@ static u64 vcore_stolen_time(struct kvmppc_vcore *vc, u64 now)
 	return p;
 }
 
-static void kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
-				    struct kvmppc_vcore *vc, u64 tb)
+static void __kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
+					unsigned int pcpu, u64 now,
+					unsigned long stolen)
 {
 	struct dtl_entry *dt;
 	struct lppaca *vpa;
-	unsigned long stolen;
-	unsigned long core_stolen;
-	u64 now;
-	unsigned long flags;
 
 	dt = vcpu->arch.dtl_ptr;
 	vpa = vcpu->arch.vpa.pinned_addr;
-	now = tb;
-
-	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-		stolen = 0;
-	} else {
-		core_stolen = vcore_stolen_time(vc, now);
-		stolen = core_stolen - vcpu->arch.stolen_logged;
-		vcpu->arch.stolen_logged = core_stolen;
-		spin_lock_irqsave(&vcpu->arch.tbacct_lock, flags);
-		stolen += vcpu->arch.busy_stolen;
-		vcpu->arch.busy_stolen = 0;
-		spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
-	}
 
 	if (!dt || !vpa)
 		return;
-	memset(dt, 0, sizeof(struct dtl_entry));
+
 	dt->dispatch_reason = 7;
-	dt->processor_id = cpu_to_be16(vc->pcpu + vcpu->arch.ptid);
-	dt->timebase = cpu_to_be64(now + vc->tb_offset);
+	dt->preempt_reason = 0;
+	dt->processor_id = cpu_to_be16(pcpu + vcpu->arch.ptid);
 	dt->enqueue_to_dispatch_time = cpu_to_be32(stolen);
+	dt->ready_to_enqueue_time = 0;
+	dt->waiting_to_ready_time = 0;
+	dt->timebase = cpu_to_be64(now);
+	dt->fault_addr = 0;
 	dt->srr0 = cpu_to_be64(kvmppc_get_pc(vcpu));
 	dt->srr1 = cpu_to_be64(vcpu->arch.shregs.msr);
+
 	++dt;
 	if (dt == vcpu->arch.dtl.pinned_end)
 		dt = vcpu->arch.dtl.pinned_addr;
@@ -748,6 +737,27 @@ static void kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
 	vcpu->arch.dtl.dirty = true;
 }
 
+static void kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
+				    struct kvmppc_vcore *vc)
+{
+	unsigned long stolen;
+	unsigned long core_stolen;
+	u64 now;
+	unsigned long flags;
+
+	now = mftb();
+
+	core_stolen = vcore_stolen_time(vc, now);
+	stolen = core_stolen - vcpu->arch.stolen_logged;
+	vcpu->arch.stolen_logged = core_stolen;
+	spin_lock_irqsave(&vcpu->arch.tbacct_lock, flags);
+	stolen += vcpu->arch.busy_stolen;
+	vcpu->arch.busy_stolen = 0;
+	spin_unlock_irqrestore(&vcpu->arch.tbacct_lock, flags);
+
+	__kvmppc_create_dtl_entry(vcpu, vc->pcpu, now + vc->tb_offset, stolen);
+}
+
 /* See if there is a doorbell interrupt pending for a vcpu */
 static bool kvmppc_doorbell_pending(struct kvm_vcpu *vcpu)
 {
@@ -3730,7 +3740,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		pvc->pcpu = pcpu + thr;
 		for_each_runnable_thread(i, vcpu, pvc) {
 			kvmppc_start_thread(vcpu, pvc);
-			kvmppc_create_dtl_entry(vcpu, pvc, mftb());
+			kvmppc_create_dtl_entry(vcpu, pvc);
 			trace_kvm_guest_enter(vcpu);
 			if (!vcpu->arch.ptid)
 				thr0_done = true;
@@ -4281,7 +4291,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 		if ((vc->vcore_state == VCORE_PIGGYBACK ||
 		     vc->vcore_state == VCORE_RUNNING) &&
 			   !VCORE_IS_EXITING(vc)) {
-			kvmppc_create_dtl_entry(vcpu, vc, mftb());
+			kvmppc_create_dtl_entry(vcpu, vc);
 			kvmppc_start_thread(vcpu, vc);
 			trace_kvm_guest_enter(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
@@ -4458,8 +4468,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	local_paca->kvm_hstate.ptid = 0;
 	local_paca->kvm_hstate.fake_suspend = 0;
 
-	vc->pcpu = pcpu; // for kvmppc_create_dtl_entry
-	kvmppc_create_dtl_entry(vcpu, vc, tb);
+	__kvmppc_create_dtl_entry(vcpu, pcpu, tb + vc->tb_offset, 0);
 
 	trace_kvm_guest_enter(vcpu);
 
-- 
2.23.0

