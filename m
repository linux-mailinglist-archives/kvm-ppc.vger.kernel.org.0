Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A5F3B020B
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhFVLBQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLBP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0A8C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so1508957pjn.1
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VQVm8iqw2WbTFtSnmqUmUPnGnahuafjyJU8AqyBfZk=;
        b=nx1aCIo+0V3MG6kMLg2e8AVqZvDHmd+5nyqfs7J9Y5J7DaGXrhGzYXqHYZLod+Wh2P
         hWM/wAcFuwtWAuMcn0YTG0ilP9xTJ9/sGWJYSdG5YmsqwgCZn5vsl003QCzYrc8xuMWG
         A2B215zqe3bwRqFo9RCXbC7/yRRXfwbi4fT96xdaG/e44UWijJLslOth4NbqLWd+4Bk8
         iVJwnfMtfVbOSP/3/0GOVcrX9NiSXQrd/FO796vecgUn4TNGEQOXcZ8xXQRTkHll7/Iq
         jb/SocYPjb2hEbAKv7n24fUDAGTqHSg9+QEju+aHslgmsDBpKAaraXfZW8Xok5MiMYEZ
         0qoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VQVm8iqw2WbTFtSnmqUmUPnGnahuafjyJU8AqyBfZk=;
        b=tO8yVdfOVZgO5QTPuEKgbZ3LReSF5kE5KtrnP+BFj9liCsAtWRFx1+sFeONGmh6uA6
         v7EzbP56AcCqineBYQs3IFmzQAojb1hhA+/x3Pn4g+BkZVgqou8VgfGlWrH6awfQf940
         lfhDse+Vx7krwzEWZYDvDCPULRL1MWCCN7w2G3vfAS9hNIdSvUWZAYKIGc7U/8ZjlwXK
         E2Xokl0JpUQN7zP9PtMZ8qp+SV3UWMSg2VEoHDGNLISn+KJtWEdB2pA0jCHpEw7cUNK6
         GtNpPdlLvggVLBwwG2MM1pNCQsy1yo97/6iq6f7zYijtyHcakTkzx8hGfnrqo9uicU/U
         NvAA==
X-Gm-Message-State: AOAM531/BDdtTSLtyaY/lobsKBms++eDCuEx6I2krvLDZq4IH68MG+lW
        vhbU/uzD/nRZaP02bLcgmqxIDlyXnqE=
X-Google-Smtp-Source: ABdhPJwBUlyKqVQy1LFjCcucqHbd9NGFmY8xxbNCKOnWjv4FPipEb0Jj+AEs30ooJzrmSYV0hGLjkA==
X-Received: by 2002:a17:903:3093:b029:121:d072:d3e with SMTP id u19-20020a1709033093b0290121d0720d3emr12510560plc.30.1624359539965;
        Tue, 22 Jun 2021 03:58:59 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:58:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 26/43] KVM: PPC: Book3S HV P9: Move vcpu register save/restore into functions
Date:   Tue, 22 Jun 2021 20:57:19 +1000
Message-Id: <20210622105736.633352-27-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This should be no functional difference but makes the caller easier
to read.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 55 +++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a780a9b9effd..35749b0b663f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3958,6 +3958,37 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
 }
 
+static void load_vcpu_state(struct kvm_vcpu *vcpu,
+			   struct p9_host_os_sprs *host_os_sprs)
+{
+	if (cpu_has_feature(CPU_FTR_TM) ||
+	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
+		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
+
+	load_spr_state(vcpu, host_os_sprs);
+
+	load_fp_state(&vcpu->arch.fp);
+#ifdef CONFIG_ALTIVEC
+	load_vr_state(&vcpu->arch.vr);
+#endif
+	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
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
@@ -4065,17 +4096,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	if (cpu_has_feature(CPU_FTR_TM) ||
-	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
-
-	load_spr_state(vcpu, &host_os_sprs);
-
-	load_fp_state(&vcpu->arch.fp);
-#ifdef CONFIG_ALTIVEC
-	load_vr_state(&vcpu->arch.vr);
-#endif
-	mtspr(SPRN_VRSAVE, vcpu->arch.vrsave);
+	load_vcpu_state(vcpu, &host_os_sprs);
 
 	switch_pmu_to_guest(vcpu, &host_os_sprs);
 
@@ -4179,17 +4200,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

