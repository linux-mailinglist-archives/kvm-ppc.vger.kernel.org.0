Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C443D51D2
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhGZDLq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhGZDLm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410D3C061760
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so17861758pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fj7EqZ1a9KKmPKWWgZnBHqfjaGtCWGrav4QAo3a930k=;
        b=ml2SPelvbj9Nffp52p9OVwG9OFrnF8xxapcL+Eq6SenWfhry3RuMimkYnAMsuvzAY3
         gFl4ZNUsPQ19Fr/xgsK1pqUyKL1WKPhLhYygbYjfAy9mCuAyerEWB/GezhVco3ax5vHA
         Asj+GM7CaTpiud9YBVswsFjelaH8NZgsF+e+9wdSOAW+MyC1RabTsFFo9VNb7+rQO5wh
         b9rGTpzt2RN8yPZKd1iFsQujMUHo7URKFussIlBqV4vl3u/XOPbkIF52Y8rIasn/jJEa
         nYAznWMLEb9m2m3kUpJNZ4hYW9dQKxHdGQk6MC7RcYvMgJXAJp+4hymG1Gfg0V2ReKZF
         qMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fj7EqZ1a9KKmPKWWgZnBHqfjaGtCWGrav4QAo3a930k=;
        b=P9XwwN0OD6zOgK8if7uhcXHAXA5lN9Ino5obvRN4BNMN2EvH0IE/MTiS5cKr0uvkz1
         0r+S/AsiCm6pjjZNW8KfMvoN/bNpZysok8umfA/Mt+4JcspMJ3ldrTyFTPrTB1QljMl3
         Y4Yr/mNDTXUs3A2W1IN2iNF7toUeLHm4wct2FVH9I+iEIqFcCZPJOXNqlocV382Dh45T
         kMj5TvqHt+fKwRqojq3V26X+yeTAFa/vfBFn/YtPWCM3ngCavsCqYLXcLonF5PhlJw9w
         /2qw0wA0gNXnU3dfKVw9Fgb2jSSbu2xcHd2rk9ArH8pjOCeFtLQNTlIr839I1ElI2YWh
         WNJg==
X-Gm-Message-State: AOAM530X4SgAaZqJIBN1xmRA7jQc2D51PJyKFyufxG/t5F06lSLDu3Q2
        HD4jFUPcLvt4oxKk77CHUURo2kL5rfc=
X-Google-Smtp-Source: ABdhPJwURJ7v1fon0Xcds+Pd8NEDmZUqscIezSGHTil3VDPjh8f7u4NLsAarbim2nbvo4LJ1/QaEWg==
X-Received: by 2002:a05:6a00:1582:b029:333:a366:fe47 with SMTP id u2-20020a056a001582b0290333a366fe47mr16104658pfk.0.1627271530761;
        Sun, 25 Jul 2021 20:52:10 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 37/55] KVM: PPC: Book3S HV P9: Switch PMU to guest as late as possible
Date:   Mon, 26 Jul 2021 13:50:18 +1000
Message-Id: <20210726035036.739609-38-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This moves PMU switch to guest as late as possible in entry, and switch
back to host as early as possible at exit. This helps the host get the
most perf coverage of KVM entry/exit code as possible.

This is slightly suboptimal for SPR scheduling point of view when the
PMU is enabled, but when perf is disabled there is no real difference.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 6 ++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8c1c93ebd669..e7dfc33e2b38 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3800,8 +3800,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	s64 dec;
 	int trap;
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -3864,9 +3862,11 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
 	mtspr(SPRN_DSISR, vcpu->arch.shregs.dsisr);
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 	trap = plpar_hcall_norets(H_ENTER_NESTED, __pa(&hvregs),
 				  __pa(&vcpu->arch.regs));
 	kvmhv_restore_hv_return_state(vcpu, &hvregs);
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
 	vcpu->arch.shregs.dar = mfspr(SPRN_DAR);
 	vcpu->arch.shregs.dsisr = mfspr(SPRN_DSISR);
@@ -3885,8 +3885,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 2e7498817b2e..737d4eaf74bc 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -589,8 +589,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
 	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -732,7 +730,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 	kvmppc_p9_enter_guest(vcpu);
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	accumulate_time(vcpu, &vcpu->arch.rm_intr);
 
@@ -943,8 +943,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		asm volatile(PPC_CP_ABORT);
 
 out:
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	end_timing(vcpu);
 
 	return trap;
-- 
2.23.0

