Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE14A3E9566
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhHKQD4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhHKQD4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE3C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l11so3290785plk.6
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=seBS1CKh1tdJivnx8ndo4Zu4wItjYVzMJJMUXfTGVvE=;
        b=PSPAlFatBQ+1B6aLgAp2LKgkYDsDtU4inSnxdbXA2HlkzIVoFdMX5D8W31vAUax/JF
         /Ug2/aKUrWfP73U3nHdIfG3gD0JmH/L3dumzXvTfmWBfEp9saVhls/jeTWpjsqLm957R
         Z2T+MF8CCzsmWlBltQZYZTPQ1W3QUuNSMEU1rPIBUohx2bWWzO1PPCmeODkH4VMMLu59
         f2FZ6T38BEcFSIgcWAS3vPQ/Qp6JugGi703Wb5sSGDArUZisE8ZRH/4nLwT3JATwWbv+
         I918hmOvE/IIEvoGSn2kCJLfqhPmtw+itIfAB9y8/J46CPudz2HcZht+ycAQlEm1NZ4m
         STuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=seBS1CKh1tdJivnx8ndo4Zu4wItjYVzMJJMUXfTGVvE=;
        b=A685q4JpJtM77hRMKR5jOShIJZBK5WuM0iY+bOL8sUiMevTjrxW8rsHTVaOztS6AGh
         y/CKKGHs5LLVtUDpH0rWT0arTImZpZ3bJvnU+SP+e3U2EjGWrjDulKeD7lygtBIbn8EH
         evb0ez8AW4WjytheD6E/uimEk6rWkBMwKHCS3axdirW5QkHG8VPBGZj8SA4KO3uyxaXk
         IaKgoHTqKa/KcNlnVWkHw8lLory+/NfLAKQzrYYKWh9a5HUHOGLvgIBzgJMdqefvtkkN
         J0Kmdsj3sRgFGgSbLdNdNyyxw9zZpOs5rdKGs/XCr9IQdjkHUJXyMJ0JBC5rwmGb+nE0
         a8dg==
X-Gm-Message-State: AOAM531lggg1oaSVQYkKKeoat0oqBJWOSh7pu5dBXDD+YBRPlYWCXxSg
        QsBX6IKyIWcpWHCex8BtS7oq4VnQtY4=
X-Google-Smtp-Source: ABdhPJzQiy935f6UIsCwZfdi6QtVSrEE6j6Mo3zLJYxYjBVNd49DHIHZaKJEgWaBGYnctR3+MEXiyg==
X-Received: by 2002:a17:90a:648b:: with SMTP id h11mr10767670pjj.141.1628697812062;
        Wed, 11 Aug 2021 09:03:32 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:31 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 41/60] KVM: PPC: Book3S HV P9: Switch PMU to guest as late as possible
Date:   Thu, 12 Aug 2021 02:01:15 +1000
Message-Id: <20210811160134.904987-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 26872a4993fd..c76deb3de3e9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3823,8 +3823,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	s64 dec;
 	int trap;
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -3887,9 +3885,11 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
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
@@ -3908,8 +3908,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index e52d8b040970..48cc94f3d642 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -597,8 +597,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
 	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -740,7 +738,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 	kvmppc_p9_enter_guest(vcpu);
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	accumulate_time(vcpu, &vcpu->arch.rm_intr);
 
@@ -951,8 +951,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		asm volatile(PPC_CP_ABORT);
 
 out:
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	end_timing(vcpu);
 
 	return trap;
-- 
2.23.0

