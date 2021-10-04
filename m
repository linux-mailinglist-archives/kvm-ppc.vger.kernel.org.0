Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DF6421371
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhJDQEM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhJDQEL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:11 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4757C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 75so16991552pga.3
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ow8cYghbA2bnydpS+MNEJPmRY9uv0/URFDPZIuLqe34=;
        b=VEmWxjjtJgcn907S87MPwBbiKZ4eygPZE+dXkofvgkMg+pKmw7DDeWn5Y2pN25EnQd
         bnQeS1VimSvi9qVo5n+NXhJa9tS1E/NZpHwudWc6jeRIPJpknLIGaHLrElJ3SNsLWjpp
         hyTfSuA2ICX1xpiJC1OrMoImo1zmSnkiRB0rgQFNc05EpeElBAAEvkLeDiH3nh+oZGrj
         qltW42gRoCCfn1Zy6cjw09/W7CMaRVTr2RUmPGBDNZxtKsiRuX7oOYfG00jQWX6Ojhw0
         02MFzOC3MAZr39pcZcdDGK/y56KrTM8upu5rj4GUraTUC+C9Iuk82qqYwyu1Ii/0AzPD
         DEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ow8cYghbA2bnydpS+MNEJPmRY9uv0/URFDPZIuLqe34=;
        b=wTy2VSz0yfhHI5ZE2acl3X8C0M+ezVNFeo5rw+pOqxnRCj0CCOvMk6xjU54EFALi5a
         7LuVW1cxqc6cJVB8El2PhmOypyjX0X0xtfcVukrx3LHSSg9ECPBFThNx6g9RA09Qq+/3
         wxZ6J8SQTIhOxD0ySUDzUc7CkjX/SAfCO1tQGd0Wkpp4YF/mtwYO4PZa9weKMMj2jMGb
         EFYNYH+r0i4zyG6vDXcQEDFmlD+pcwo8LUd1EtiHgHGUhM15a0bngmHkw9tT8QP7bg2E
         okzICIRyeqQmGxJA7JZ4ztzyd3o5I0mloO8rlplWTDjynDVUY9uUXZj3IZzThf8YuejQ
         DtRQ==
X-Gm-Message-State: AOAM5323lelpsKRZYgrmcXRzDv3+Ft2Yr0HIlUdIWOlWw7JLwdpvGr/A
        bS/zyEMorBmd2+lNIpa0soRL7S7t7vA=
X-Google-Smtp-Source: ABdhPJwdOPIdI6NPSumcNUNoT0WRyLbrL2YZd8kgEZ/NWbnGWwDkeCSwNbq33rhu/cMGb7C7mqoJpQ==
X-Received: by 2002:a05:6a00:1944:b0:438:d002:6e35 with SMTP id s4-20020a056a00194400b00438d0026e35mr25462359pfk.20.1633363342102;
        Mon, 04 Oct 2021 09:02:22 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:21 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 33/52] KVM: PPC: Book3S HV P9: Switch PMU to guest as late as possible
Date:   Tue,  5 Oct 2021 02:00:30 +1000
Message-Id: <20211004160049.1338837-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index db42eeb27c15..5a1859311b3e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3820,8 +3820,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 	s64 dec;
 	int trap;
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -3884,9 +3882,11 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
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
@@ -3905,8 +3905,6 @@ static int kvmhv_vcpu_entry_p9_nested(struct kvm_vcpu *vcpu, u64 time_limit, uns
 
 	restore_p9_host_os_sprs(vcpu, &host_os_sprs);
 
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	return trap;
 }
 
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 6bef509bccb8..619bbcd47b92 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -601,8 +601,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	local_paca->kvm_hstate.host_purr = mfspr(SPRN_PURR);
 	local_paca->kvm_hstate.host_spurr = mfspr(SPRN_SPURR);
 
-	switch_pmu_to_guest(vcpu, &host_os_sprs);
-
 	save_p9_host_os_sprs(&host_os_sprs);
 
 	/*
@@ -744,7 +742,9 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	accumulate_time(vcpu, &vcpu->arch.guest_time);
 
+	switch_pmu_to_guest(vcpu, &host_os_sprs);
 	kvmppc_p9_enter_guest(vcpu);
+	switch_pmu_to_host(vcpu, &host_os_sprs);
 
 	accumulate_time(vcpu, &vcpu->arch.rm_intr);
 
@@ -955,8 +955,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		asm volatile(PPC_CP_ABORT);
 
 out:
-	switch_pmu_to_host(vcpu, &host_os_sprs);
-
 	end_timing(vcpu);
 
 	return trap;
-- 
2.23.0

