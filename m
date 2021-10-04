Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C418421388
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhJDQEu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbhJDQEt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49B7C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:03:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3080142pjc.3
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iAp5cZPlH2CQn7Ni2mzcHZSZ7/uct2D+QzsCLoH2W/0=;
        b=XuviA3b7q6DWcTCbVp2sJoDpCn3wytM5lazWjg5MGsb/SYjmiZ4E5opHkuVHRuJYIl
         gxi0YzWtIuZ2lc95Lm+FLSCMhTp4vzHU3c4TkEjVlrpqX15E7PJvmXH2x6JX5pFfzPl4
         ZiAKVkhED30oODf3am+0NypHe1VBrwVPKMO1hV2To+MTGv8WyL4jTGlJIo9Q6kqturtB
         +TgkqMH/CZNdPBy7OXUk+GMyaT7jZUYGI4XgQYY5lrF5C+O7bl3BjE4Zw+y6ItUtrMjG
         Q6FH8adB0z8pd09cH7Uai2IZwtDbbjI7pfc2+gXYsQrx9WvB9HIUgGGAlQpG4OQSe2Hm
         qq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iAp5cZPlH2CQn7Ni2mzcHZSZ7/uct2D+QzsCLoH2W/0=;
        b=5QMPq0tWxCx3Hi46JSOisUYQRBiV7E781kJnpcBexaR/cR01wjiuAp3jsPFI6wtdSf
         q4OnUkcfioNiLfymd6/WD0tGPF8x2mYtLXkFVnUlMtoXAHk7erR4ST4ElHXvuWiqy74l
         yJ/+oMiHrjY4RjqLRCwj26DudXiNqni+pUyWzu7fL4bWHdY94DewRK/BC7JoK7ZJWP+4
         eSCgDy2/eShLB8A9CR2DDOnchxXoi/1ms/aWI7f4ijyidwWDY2FVXS0NW4lyjpyhkGXK
         djh0z31Am+6X6nnfmMKk6Lz4Rc6LR9wL1+ACUqChNJm7dNAO1pb/rL8Lt886Xtea6H6J
         gz5g==
X-Gm-Message-State: AOAM531A/ls4d+HikNGfUSK58wIKNX9HhAW0H+x8LA8IkpNM8D55b/1k
        Qs6NM1AwdPbKebOA61lXjoJcjMT1sC8=
X-Google-Smtp-Source: ABdhPJw7jTzQ4D3ZQvNDT7P6IeqodWCkjSNS1WudIYUggjGNdSkwjYqfGKnjF+BNSBGxuk7VgLJ6Yw==
X-Received: by 2002:a17:90b:3591:: with SMTP id mm17mr1836820pjb.140.1633363380123;
        Mon, 04 Oct 2021 09:03:00 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 50/52] KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
Date:   Tue,  5 Oct 2021 02:00:47 +1000
Message-Id: <20211004160049.1338837-51-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index d614f83c7b3f..57bf49c90e73 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -698,41 +698,30 @@ static u64 vcore_stolen_time(struct kvmppc_vcore *vc, u64 now)
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
@@ -743,6 +732,27 @@ static void kvmppc_create_dtl_entry(struct kvm_vcpu *vcpu,
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
@@ -3750,7 +3760,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		pvc->pcpu = pcpu + thr;
 		for_each_runnable_thread(i, vcpu, pvc) {
 			kvmppc_start_thread(vcpu, pvc);
-			kvmppc_create_dtl_entry(vcpu, pvc, mftb());
+			kvmppc_create_dtl_entry(vcpu, pvc);
 			trace_kvm_guest_enter(vcpu);
 			if (!vcpu->arch.ptid)
 				thr0_done = true;
@@ -4313,7 +4323,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 		if ((vc->vcore_state == VCORE_PIGGYBACK ||
 		     vc->vcore_state == VCORE_RUNNING) &&
 			   !VCORE_IS_EXITING(vc)) {
-			kvmppc_create_dtl_entry(vcpu, vc, mftb());
+			kvmppc_create_dtl_entry(vcpu, vc);
 			kvmppc_start_thread(vcpu, vc);
 			trace_kvm_guest_enter(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
@@ -4490,8 +4500,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	local_paca->kvm_hstate.ptid = 0;
 	local_paca->kvm_hstate.fake_suspend = 0;
 
-	vc->pcpu = pcpu; // for kvmppc_create_dtl_entry
-	kvmppc_create_dtl_entry(vcpu, vc, tb);
+	__kvmppc_create_dtl_entry(vcpu, pcpu, tb + vc->tb_offset, 0);
 
 	trace_kvm_guest_enter(vcpu);
 
-- 
2.23.0

