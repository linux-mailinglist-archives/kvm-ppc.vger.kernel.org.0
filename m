Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552543E954B
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbhHKQCu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbhHKQCu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F50C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so10307149pji.5
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PvCtp8x/xnVOg7P/kY+PiLHYDRcQOyLkNAyPlsDlMl8=;
        b=ajkySZGKELPOFGlAUa0DcURtiIKi9T3MyAEIAFYJvPxxWt9C91f84Djb5JTPQCUFDQ
         pJi0II2JSDY5y670wq5wlqBTT291LpkBwSrjMzCoOjL/uvaQDHXKcEkEGTi/MR0ZSM0d
         CVQyKQPDn0vXr8+v4Rtd0AAOmF24Ew3j+uvsWVO3sOX+e7jZkCTWsUh4xHUWnPe2KWvI
         y4qVxsudnZI93rN+VL2lD1Ehem6MT4xIhHgBmciaxi8PivyEm4KktZlQlR8sqIdROgfh
         9k999+8Qu3uD5Fh5bgvenxgcJ/QiLFGbJy07en+uRZiwYfv7jMOCep6KMrZPwytwtTgC
         sn6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PvCtp8x/xnVOg7P/kY+PiLHYDRcQOyLkNAyPlsDlMl8=;
        b=NmhMsX7+v68ZqzKU0bvj41f7cFxyCXkENHB59WGuC6gbvmGzKGyWHxannwtPJK+EL0
         8KtvTvNgS05efWiLjTF+8fzEX/FMVfc2MO7V8YlrV3eScw3m3aE9A2k5ecd+TmJoGwLx
         kGp6Wwv6h25fcg5c/aEsnCCAW5pmMDB9i6Uym6LYw0kt0/pefFG2zs8DS5mX1U33UTJC
         o1mvb1aiKLSg5hfg3gmPm6LFrNEKkEX8VAGOX3zs8X4dtthqjEv6LImqBXBOZOGh+U3R
         u2WAs8UgkxJrM3QkuLC9ypOvrOY0A6IiBw+O4mmSASPacLZG6MWchB4QtDZ37wEO5XHd
         uAng==
X-Gm-Message-State: AOAM532O9BHXLxQfoZZIYsB2HUHCsnIWyyFNUUOBAdQPvn2GGn1kcILp
        vXxeKXDSPM57k6vv2sN1efXFB+0p9ic=
X-Google-Smtp-Source: ABdhPJwM2JXz9u/GyBAQDqJFThzbzJNZQ9eRAZFa1EjHHIAXHksIN4bDV6a30r/1jGgLUAZRKZRnrg==
X-Received: by 2002:a17:90b:3758:: with SMTP id ne24mr16269601pjb.218.1628697745967;
        Wed, 11 Aug 2021 09:02:25 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 16/60] KVM: PPC: Book3S HV: POWER10 enable HAIL when running radix guests
Date:   Thu, 12 Aug 2021 02:00:50 +1000
Message-Id: <20210811160134.904987-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

This optimisation takes 1380 cycles off a NULL hcall entry+exit micro
benchmark on a POWER10.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 5e48a929d670..2fe01dc2062f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5034,6 +5034,8 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
  */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
+
 	if (nesting_enabled(kvm))
 		kvmhv_release_all_nested(kvm);
 	kvmppc_rmap_reset(kvm);
@@ -5043,8 +5045,13 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
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
 
@@ -5054,6 +5061,7 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
  */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
 	int err;
 
 	err = kvmppc_init_vm_radix(kvm);
@@ -5065,8 +5073,17 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
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
 
@@ -5230,6 +5247,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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

