Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC63B0212
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhFVLBd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLB3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC92C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:12 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id u18so10732965pfk.11
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JaQQukVVLtIelVEbNkhVokmtF+DUGFzRwD4mBIzHcNA=;
        b=G7qkniK09sfdIYfShu3Q4lal0H3GzetSPeiXgCukzVpn2qm9kwXS6WDs88eEvb0ZMQ
         3I80IxMyB9OH0k7uMN+2fN+WPireqF1+OD+uHhoRuB76HqU6MxOZTmgMS8mi47brk158
         8Vg9eHW26Y+NAI6IAUZ+r2uWHYI7JNRQYWPM6T6czarr2OaINsBFRekEWIVhY/Dez/CN
         FaewOwDaxBv0wjJbALIc+tFyBeqKUnH01SjW8/vFbVieQaWCGhTOoo9mD4UJ0Urrmahu
         /A94nl73HhBQCTwCrAv3caDk3W44CqsncsDpUuKCuy19I77Dj5syuQYIPvYvxXlxiUeb
         8U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JaQQukVVLtIelVEbNkhVokmtF+DUGFzRwD4mBIzHcNA=;
        b=psAOGq1L8/bKnyEE0kwU4hHsFeIUTvtokdfZDv2GXW1J+BauT0UUVNjbNfYBaYSGDi
         gJijXuXmL1Y3O1N8z4VO9iy38x4lZ1b5bbPrWwbzwbMqhEU+lqxQWbYj724696qkhRcP
         LivhrXITVtrFParcwF1zzCUZ5y3JGXuQa8aE+dqEDatQGU+O2UUYWfs/kmG1fsyXw0yL
         4LK0z6/MJRBYz1rHUuSq7ErLpJejMnCsAY8azUqxLVvukugD0bJ3adUZk3sHAba70sC3
         oYvuxTsZm1aLdwkwmkcHMNaFFvcU7yn/l+hXey+A4avM3e8sqmAjhm/0ak9dJWSklUOC
         qaXQ==
X-Gm-Message-State: AOAM533qlKDmCSOSL5RvmuoMeaqT6wcB7ufrr9UMNF9gLM+icEaZlk4Z
        AmX+voLHjVp6cxv6p8ca3M4ag15lbxU=
X-Google-Smtp-Source: ABdhPJylOkrOdeOJPWxgG6jMoh2doCgib0Nico/ppT2SmOb2qCJ+mWsegivKmkWrb69RLCwaaicoWA==
X-Received: by 2002:aa7:8003:0:b029:2eb:2f8f:a320 with SMTP id j3-20020aa780030000b02902eb2f8fa320mr3161415pfi.70.1624359551792;
        Tue, 22 Jun 2021 03:59:11 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 31/43] KVM: PPC: Book3S HV P9: Switch PMU to guest as late as possible
Date:   Tue, 22 Jun 2021 20:57:24 +1000
Message-Id: <20210622105736.633352-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
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
index ee4002c33f89..a31397fde98e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3703,8 +3703,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	s64 dec;
 	int trap;
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -3766,9 +3764,11 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
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
@@ -3787,8 +3787,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 81ff8479ac32..9e58624566a4 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -577,8 +577,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
 	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -708,7 +706,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 	kvmppc_p9_enter_guest(vcpu);
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	accumulate_time(vcpu, &vcpu->arch.rm_intr);
 
@@ -904,8 +904,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		asm volatile(PPC_CP_ABORT);
 
 out:
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	end_timing(vcpu);
 
 	return trap;
-- 
2.23.0

