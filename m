Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238483D51CA
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhGZDLi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhGZDLb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:11:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187EAC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ch6so2116887pjb.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YoEeMmSqnvFKWKfBwYyk8RCXQVi3ja3orrar8JiO4tk=;
        b=O6Rb7Rmt6QCh6w+Klwzr9LN7o5OZd3TtSkNXnW95T7qkdMdW6Ny2eOcF+g1iEWzILD
         EdorcqXgUXUTkU4Z2eeju2pE6H5dEIHosih3PpWVofy3X/vBcIiNnVHg3W7cqXOZHxEi
         XgWTlO+ChfhYwKT4M04Wjpt3xR3fxAZmaBqMyzTfp4KLJqv8lOGUCKAs67ngQptsl6QD
         TXpAdFUEQLbTgzALNLgeBjw9fXlzVES0bmM08X6h4kLclEucyivaH35zJwYKFVbMmbOR
         bZGHGDCzn5KDskbyM+qpMxBfIZOfTRzFGZ0poZdEIFulGY47CvLQZ44KogrspdfP2sZ9
         9bQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YoEeMmSqnvFKWKfBwYyk8RCXQVi3ja3orrar8JiO4tk=;
        b=MDSlcQJRsgeafuG0QvlH7iUFLzEFAVgGOu+wp9zD9Bbw5EpTNw2V10d9OCnAALENuZ
         be1QDrFD05+/MEllKwaYCkYnyJKLvPN39/BpxJUs95wqOcp9eG4iLP7R9gYDRrHIDpcI
         /S47XNC5+oiInmuBEMiLgOQ5eQXGY7M2oPIA783PYio4RpYl/aB0OtNqtk0xNdlw+/wf
         vwRdrJLNA2SyodQ5HHTYhkeCXzdhtOHJeQPxUxRqkopOHxGaGi/RJnejC+EBo0Ey9+Yd
         ma09SZsArYP/ozBcg+q3SnjBpNsEbwaJOvueRs3DfuswomANy34NnXl6Gti6orWRxZOU
         MCzA==
X-Gm-Message-State: AOAM531wUcfmzso6zHzGOQ0RW+PUjf7CkoHu7x31spfLJwOfm1n40DSE
        gYTftuq1hJm/5wDYszGlWFg9oc61psI=
X-Google-Smtp-Source: ABdhPJzr0hLlHf/k25iTZeVNCkWOSf/iquwxNFX4+rD1Ug8qEvheoO7fpDgRunhFC/hjz4E6grSyqw==
X-Received: by 2002:a65:61ab:: with SMTP id i11mr16393083pgv.168.1627271519612;
        Sun, 25 Jul 2021 20:51:59 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 32/55] KVM: PPC: Book3S HV P9: Move vcpu register save/restore into functions
Date:   Mon, 26 Jul 2021 13:50:13 +1000
Message-Id: <20210726035036.739609-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This should be no functional difference but makes the caller easier
to read.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 65 +++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c2c72875fca9..45211458ac05 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4062,6 +4062,44 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
 }
 
+/* Returns true if current MSR and/or guest MSR may have changed */
+static bool load_vcpu_state(struct kvm_vcpu *vcpu,
+			   struct p9_host_os_sprs *host_os_sprs)
+{
+	bool ret = false;
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
+		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+		ret = true;
+	}
+
+	load_spr_state(vcpu, host_os_sprs);
+
+	load_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	load_vr_state(&vcpu->arch.vr);
+#endif
+	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+
+	return ret;
+}
+
+static void store_vcpu_state(struct kvm_vcpu *vcpu)
+{
+	store_spr_state(vcpu);
+
+	store_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	store_vr_state(&vcpu->arch.vr);
+#endif
+	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
+
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+}
+
 static void save_p9_host_os_sprs(struct p9_host_os_sprs *host_os_sprs)
 {
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
@@ -4169,19 +4207,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) {
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-		msr = mfmsr(); /* TM restore can update msr */
-	}
-
-	load_spr_state(vcpu, &host_os_sprs);
-
-	load_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	load_vr_state(&vcpu->arch.vr);
-#endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+	if (unlikely(load_vcpu_state(vcpu, &host_os_sprs)))
+		msr = mfmsr(); /* MSR may have been updated */
 
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
@@ -4285,17 +4312,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	switch_pmu_to_host(vcpu, &host_os_sprs);
 
-	store_spr_state(vcpu);
-
-	store_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	store_vr_state(&vcpu->arch.vr);
-#endif
-	vcpu->arch.vrsave = mfspr(SPRN_VRSAVE);
-
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_save_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+	store_vcpu_state(vcpu);
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-- 
2.23.0

