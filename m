Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451643E9579
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhHKQEj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbhHKQEi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:38 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F7C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so10315743pji.5
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyeznd7fI3Ttr5fjCtFBb+9Yq8CmDhEuQG11aiCoAXM=;
        b=YD2K34I094rIr+N9jGMAzNglTlN0rbrNyRVt5azEbS9j2f/TbsvU1kBqmx0uxbfHZD
         DH35XhINHZdSiV26yb2+slG/pxwJXn7yyZCB66/CCKTF4X+unfPAEXy1MCoLKKhYFkjr
         7WvB/zdYS9g04Eq1f/U8PTllisZvOmkdjhI+s7wGFx4VRQkG55T/dfScEVPZp04dK0OH
         eU+ypA9ANP99yPetQV5dzYbUaNyRwBfmDd5qO5baIMNFqFxrO6S++dmjjsg/NOx/zjLI
         gRtDsmcudwqZRKHFAX8hk/id3FYmQAdhy50Appf6ZxKz7N55Eg6+bwN/yQDE6K8gmjwB
         Oe1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyeznd7fI3Ttr5fjCtFBb+9Yq8CmDhEuQG11aiCoAXM=;
        b=H5/V0WTj2H944g+WBWI+aK2nm7oZxaXRKkJvmkEpGBUAA9dztGgcERc9SV/Dr4LHPE
         vSyDiEpThkj+hbmkZvyxUSb2MxHQQ6WH2ih6De4uvotQnCq3XyWqhTag3AfzFxI9WIRA
         1TYQFWKL47YnkKpPiUGPyYVLil2YRIQktpniKBl9M9ZT1+FUCViq/lJKTDi5pbcE+zeO
         ++vq3FRgNFndINoDiC4GyotFQcJUTB2a4mONiU1C+h4WGT8ekSHTX9u1W5y30Y/GgEs9
         nQ924x3fdFJRaU6mL8tKkIIXL5S6RgTBLtscNI7EndoJUnHxPOtgD6go6+nsSzywEVhb
         G51Q==
X-Gm-Message-State: AOAM530SxNVLU/CfVaOwdI6t/Fdvyj/NAuwEDn5tFisOUKKFre0Jfapb
        HPA25Wb8vSfGz8AyZgIWn/Km+cqULN4=
X-Google-Smtp-Source: ABdhPJyEAS4DeIsBBaSu60Jd/s1YbdXwUcLMuOGyVqPs22LFWEoaz/lDh8ekRrwMpolxGdS+O/vznQ==
X-Received: by 2002:a17:902:bc84:b029:12c:f9b9:db98 with SMTP id bb4-20020a170902bc84b029012cf9b9db98mr4783798plb.19.1628697854428;
        Wed, 11 Aug 2021 09:04:14 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:14 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 58/60] KVM: PPC: Book3S HV P9: Tidy kvmppc_create_dtl_entry
Date:   Thu, 12 Aug 2021 02:01:32 +1000
Message-Id: <20210811160134.904987-59-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index c8ea430d1955..1dc98e553997 100644
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
@@ -3753,7 +3763,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 		pvc->pcpu = pcpu + thr;
 		for_each_runnable_thread(i, vcpu, pvc) {
 			kvmppc_start_thread(vcpu, pvc);
-			kvmppc_create_dtl_entry(vcpu, pvc, mftb());
+			kvmppc_create_dtl_entry(vcpu, pvc);
 			trace_kvm_guest_enter(vcpu);
 			if (!vcpu->arch.ptid)
 				thr0_done = true;
@@ -4304,7 +4314,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 		if ((vc->vcore_state == VCORE_PIGGYBACK ||
 		     vc->vcore_state == VCORE_RUNNING) &&
 			   !VCORE_IS_EXITING(vc)) {
-			kvmppc_create_dtl_entry(vcpu, vc, mftb());
+			kvmppc_create_dtl_entry(vcpu, vc);
 			kvmppc_start_thread(vcpu, vc);
 			trace_kvm_guest_enter(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
@@ -4481,8 +4491,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	local_paca->kvm_hstate.ptid = 0;
 	local_paca->kvm_hstate.fake_suspend = 0;
 
-	vc->pcpu = pcpu; // for kvmppc_create_dtl_entry
-	kvmppc_create_dtl_entry(vcpu, vc, tb);
+	__kvmppc_create_dtl_entry(vcpu, pcpu, tb + vc->tb_offset, 0);
 
 	trace_kvm_guest_enter(vcpu);
 
-- 
2.23.0

