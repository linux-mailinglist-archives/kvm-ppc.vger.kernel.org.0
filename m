Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B85B3B01F6
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhFVLAa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhFVLA3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:00:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36186C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:14 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c5so3463588pfv.8
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aLS2HA3rhZnqHz80QmW/NBi9H72JRFYsLO4Fm5ShJwg=;
        b=PThU4QDqI3EvJC+YAgfRo6xlGBVAhAZCYU+t/XDDnKcM1Apv0BlNNkQmu1YwkY7ImD
         GH4DUtEkHsIXoPBx7xTFioaZ9+Cw98j3R0SFuKvBAlwvCHoObAvLrfbNk4cNXQse7VTQ
         zQcJow+XtpzwtkEmf74yoQLYRdPHNn+eEIbMNzNS9wFsXqq2+6I8HcAXuaDrUgoUZuLx
         oPi30y+RgHJ+5I6U2M+0AIIzDX378uQg/WP2Xr6QAyRoFa8o6vlI6tGbZvX/K/pc1h+h
         xWl3cTl0MwJCwg3AIVhgcilMRu5y7D+S426M0aaJV2cCbFFzqxV1a2LmeyxCAz3Z32Qg
         vMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aLS2HA3rhZnqHz80QmW/NBi9H72JRFYsLO4Fm5ShJwg=;
        b=Pxf0wv6UCJ0f9G6GNcXALhgQebP01Q3XHy29A5C6eJbpqdYSmY904qBGrtaynefePq
         wlyweuFK5+ZMYim7bO20877s4tjEfR9V8f12fzmjvQfJt75Ux9LpCtLLUlf1WEBogFLG
         3H/Nj6zbPmbSH7cEpLCNDjqMwcY2vzZ1jmvIH047+RWfISG4+BslE05mL+41INp4NWKS
         JCzhiQDW508EfKLEkMuxJkJHoXTXTsn3PdgRqBdCofZxZB+7F8D7NTgMUsd3+z+sQItK
         EJRt29H4nlJOQTCwg7H8eSe3dM0H5ims+wI5ZKv81IGrDZ6DMU+Wdl12o5qwm/JcR711
         cxUw==
X-Gm-Message-State: AOAM531rtwBH3za65KAJUkkSISqf9kuxydbw2N6jG5L8FBup3i7tgpZU
        eaQYAJ0Ysp2F9jXoPvWQMHtSicVobwo=
X-Google-Smtp-Source: ABdhPJxZwzCkve3ftR3pC2pgaEL1aECEG5+kndsRo8W7zuXlq4hsoHbo9edDMivXrWeDhB0XMg+duw==
X-Received: by 2002:a63:2742:: with SMTP id n63mr1745713pgn.94.1624359493686;
        Tue, 22 Jun 2021 03:58:13 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 07/43] KVM: PPC: Book3S HV: POWER10 enable HAIL when running radix guests
Date:   Tue, 22 Jun 2021 20:57:00 +1000
Message-Id: <20210622105736.633352-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

HV interrupts may be taken with the MMU enabled when radix guests are
running. Enable LPCR[HAIL] on ISA v3.1 processors for radix guests.
Make this depend on the host LPCR[HAIL] being enabled. Currently that is
always enabled, but having this test means any issue that might require
LPCR[HAIL] to be disabled in the host will not have to be duplicated in
KVM.

-1380 cycles on P10 NULL hcall entry+exit

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 36e1db48fccf..ed713f49fbd5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4896,6 +4896,8 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
  */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
+
 	if (nesting_enabled(kvm))
 		kvmhv_release_all_nested(kvm);
 	kvmppc_rmap_reset(kvm);
@@ -4905,8 +4907,13 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	kvm->arch.radix = 0;
 	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_radix(kvm);
-	kvmppc_update_lpcr(kvm, LPCR_VPM1,
-			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
+
+	lpcr = LPCR_VPM1;
+	lpcr_mask = LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		lpcr_mask |= LPCR_HAIL;
+	kvmppc_update_lpcr(kvm, lpcr, lpcr_mask);
+
 	return 0;
 }
 
@@ -4916,6 +4923,7 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
  */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
 	int err;
 
 	err = kvmppc_init_vm_radix(kvm);
@@ -4927,8 +4935,17 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 	kvm->arch.radix = 1;
 	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_hpt(&kvm->arch.hpt);
-	kvmppc_update_lpcr(kvm, LPCR_UPRT | LPCR_GTSE | LPCR_HR,
-			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
+
+	lpcr = LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	lpcr_mask = LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		lpcr_mask |= LPCR_HAIL;
+		if (cpu_has_feature(CPU_FTR_HVMODE) &&
+				(kvm->arch.host_lpcr & LPCR_HAIL))
+			lpcr |= LPCR_HAIL;
+	}
+	kvmppc_update_lpcr(kvm, lpcr, lpcr_mask);
+
 	return 0;
 }
 
@@ -5092,6 +5109,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 		kvm->arch.mmu_ready = 1;
 		lpcr &= ~LPCR_VPM1;
 		lpcr |= LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+		if (cpu_has_feature(CPU_FTR_HVMODE) &&
+		    cpu_has_feature(CPU_FTR_ARCH_31) &&
+		    (kvm->arch.host_lpcr & LPCR_HAIL))
+			lpcr |= LPCR_HAIL;
 		ret = kvmppc_init_vm_radix(kvm);
 		if (ret) {
 			kvmppc_free_lpid(kvm->arch.lpid);
-- 
2.23.0

