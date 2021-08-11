Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6263E9565
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhHKQDy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbhHKQDx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C43C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so10433805pjs.0
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h9r7slMa/wxjs1UUTM7giJfy6Yufgbe7vAh2oRXYxVo=;
        b=Lx3QQ9odZsPvd10rGGcBQyoWkVluSa+FHJrDKFAxKHsXzb/31cevkrNjpB2+FNLTbD
         0+BPI5fyC+4RtfBNRR3tPVsYKszXK3Lo4KbVgbw25t6Gt7Y/0xattrtkGC59RMX3CgLk
         cIKEW+xpgmh8M3zKsv3bMXjgSnx05gESe1MRf6dIaXSzCpmm5V6uYBgEhhhNK+dTn7bd
         ORZrs3BfxsWP8dgqCDX/mV/tZzdmLdaQ6ihx1pOa4yjkzVBSjZI8UC3g88RnGfTob37K
         289TuT+csRAzuLYZL1XCbLpUnE/2od0cm4cF7sozCCEkQsG2MVvNVAToSuwNp/juA2mW
         zDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h9r7slMa/wxjs1UUTM7giJfy6Yufgbe7vAh2oRXYxVo=;
        b=YfkpFIYqeOPVSsjl6eznbs9TkeHr0YigBP8zYG+hHKLh8xJenVGSg9rymxv+HZtiAT
         YzJLam3zOlB4coYpx1FKOQWAjjpia24aN6sAYKeAyBFRNrNe39D4cyl/qPdmPG4i7u6l
         I7C1v6DrmxuvppiCEuVWCsjSBDi3GMB3KGmpuIymBXo2Okv50GOOOVYd3V1kMVr9N8fY
         u3Wzc1clZwHOtzbchH47iSSr0j42DIBWpZbPvJISeMInkMN01sR41jMO9fIcIcmMVO8u
         n0uAX/VKSZzn1DQrfkEe5eIwY9pVmG1ZCzn98cVfws1kNPR3B7M2eNG4yMzFzupxVpzG
         od5g==
X-Gm-Message-State: AOAM532ijSUYNBtGprKKqo1s72lUiiDZPVl6P6ozxaKNxH229AIWqUsh
        mAT3JU482I5oznsBI0I5A+kIWZEcDgM=
X-Google-Smtp-Source: ABdhPJyKtVY7gsWVHDzOWE5GYD38Ht12rDXBJOgWTbTjSbWADtCV64mrIDjuE+J2LKGlgHw27HiF+w==
X-Received: by 2002:a05:6a00:ccb:b029:3c6:803d:8e3 with SMTP id b11-20020a056a000ccbb02903c6803d08e3mr35308617pfv.0.1628697809419;
        Wed, 11 Aug 2021 09:03:29 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:29 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 40/60] KVM: PPC: Book3S HV P9: Implement TM fastpath for guest entry/exit
Date:   Thu, 12 Aug 2021 02:01:14 +1000
Message-Id: <20210811160134.904987-41-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

If TM is not active, only TM register state needs to be saved and
restored, avoiding several mfmsr/mtmsrd instructions and improving
performance.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 9ea70736f3d7..e52d8b040970 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -289,8 +289,15 @@ bool load_vcpu_state(struct kvm_vcpu *vcpu,
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		ret = true;
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_restore_tm_hv(vcpu, guest_msr, true);
+			ret = true;
+		} else {
+			mtspr(SPRN_TEXASR, vcpu->arch.texasr);
+			mtspr(SPRN_TFHAR, vcpu->arch.tfhar);
+			mtspr(SPRN_TFIAR, vcpu->arch.tfiar);
+		}
 	}
 
 	load_spr_state(vcpu, host_os_sprs);
@@ -316,8 +323,16 @@ void store_vcpu_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
 
 	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		unsigned long guest_msr = vcpu->arch.shregs.msr;
+		if (MSR_TM_ACTIVE(guest_msr)) {
+			kvmppc_save_tm_hv(vcpu, guest_msr, true);
+		} else {
+			vcpu->arch.texasr = mfspr(SPRN_TEXASR);
+			vcpu->arch.tfhar = mfspr(SPRN_TFHAR);
+			vcpu->arch.tfiar = mfspr(SPRN_TFIAR);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(store_vcpu_state);
 
-- 
2.23.0

