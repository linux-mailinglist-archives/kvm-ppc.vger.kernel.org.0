Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB913D51AD
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhGZDKq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CA7C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:14 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso11984362pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nHXorjUusC91+jyzJOv3GiElWAcAvxrDfngAVt6HQtc=;
        b=XJpB6Q5OVySTQUMREJ36E7xsrRDoAhmruwwzWwAmOkgS62otiHnGIeNEqF5jvtcteA
         lkMqHfOflQoYtWHUxMcxEH1ehmbiqfDJrpZbkqo34eFlre+hi3qHGZya1riGmLphf3zW
         Wl1/CKIFX9rUj+rhQJC4eTaLnuI66TPWTgXr1J/HIJHZFbAPZrmrDbdpP3P1TVqGxJ04
         CezxFJSNq/SdHEI0owOXHJHbfnrzEurtDXN+mLfEViAFNa5cDvvPemf4tL9gHvoOhhOJ
         FMWhbkFtbOkbEqckP4nUnarVJQpErOeKDPPISkrPVhNbQc6Ub/ezfBIaQbezJvXlPvBG
         2y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHXorjUusC91+jyzJOv3GiElWAcAvxrDfngAVt6HQtc=;
        b=GZ0SP0Ge2ud1fd7N8ymGbn9plHiWnULObQf1pcESk1jBZ7KMvnws198n7ju7Fvsz9d
         s1kkPVi0p1y6REQFQwj1S6Ukw2Z4L3hRl6a7I634IHkGyqpPcfOtRK6GCFaMunWkPCXd
         eLDxXtQvRpgygH2gu2AaIKQMPiwkE/z8rqF6V1CVj8wh3fUWAR+QXJrZLsQiSXiSdz80
         QmrhXmeumFWOAkq3mwo3BNhSr4mYDh5bWP9d7e0X4fn7exkUXN10y9MpPipxImNhWycu
         nNyALqqirFD9GSllvvjNB/EIgSmKbSMPWITCAgk1zHjpzRB/1VJQTMetq1cix/22SLUt
         PysQ==
X-Gm-Message-State: AOAM532BqsAduT00tHA3Ratfsr/IpCXpdHHcVSUr4x5RR/GP5HRjh4Sf
        A8N2sjghLTcSTsbhzZL+HGqnwRSZ6C8=
X-Google-Smtp-Source: ABdhPJwGI8F7bs93/D8S+wnBK4/3Kk44t+pq4eUUgGYplkQR8R/Ji5RnzvPuewdwOYF/YWdvm83CNw==
X-Received: by 2002:a17:90a:3048:: with SMTP id q8mr3507857pjl.120.1627271473907;
        Sun, 25 Jul 2021 20:51:13 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 12/55] KVM: PPC: Book3S HV: POWER10 enable HAIL when running radix guests
Date:   Mon, 26 Jul 2021 13:49:53 +1000
Message-Id: <20210726035036.739609-13-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0cef578930f9..e7f8cc04944b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5004,6 +5004,8 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
  */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
+
 	if (nesting_enabled(kvm))
 		kvmhv_release_all_nested(kvm);
 	kvmppc_rmap_reset(kvm);
@@ -5013,8 +5015,13 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
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
 
@@ -5024,6 +5031,7 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
  */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
 	int err;
 
 	err = kvmppc_init_vm_radix(kvm);
@@ -5035,8 +5043,17 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
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
 
@@ -5200,6 +5217,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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

