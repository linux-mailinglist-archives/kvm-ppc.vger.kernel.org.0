Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24623E9561
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbhHKQDn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbhHKQDn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:03:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65B6C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b7so3284641plh.7
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nSYAtI8P17mLu9fXMsfGStnZ2i1gV8qJNG1zXcMJXYc=;
        b=XJqwDEXZ1TmJVgaAZbsPYwhy/zHNIJw9dyq5b9vepuoqGa9FonsxE15xQixMwOIPSA
         0eQ8VuWbHvQRflYSzYFDDpzigE5OJ06n1AHujAibRT84kZtsguujccvLpbNXqR0vkLVq
         L797vhzmblb1JFS/yZwoIstySRBaJQijH/477RDJcUEgKvgnKYdS2Mw7dL06H1VDFX/r
         zmXZcoVpnUPgBruMljhKY5hyvQzo2t6au0SCGouXi/pZQcO+4sIp/SvZYTadel9RRkZr
         elyfai5Jf9PxXEeebBJzPgmhuHkKQDybAVxPU8BOOt1WRu1l4/2EFXLYtH95z5/xXKoQ
         9Srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSYAtI8P17mLu9fXMsfGStnZ2i1gV8qJNG1zXcMJXYc=;
        b=Wh9W/9HEW+0jrzvtxxdm7Tk0HEHTamzabKnHQ0/Y8h2742WK2rZwu1LQSwKVMRDAXU
         Cy7hYXD9gS1XbgaLQJj2hIMR3u1MWb8jEF3unQ2a208kV7dPv+7Wr6O/1GSgGARy0Lio
         Ub6ZJ01mU+N70EX4I+Bd7WDcYOdy0kQaNncn+Pvn76icebTi43B5P8ItqiEQvOjz/YcA
         TzgK8ZSeI1XXG5sYS9ZHD+YGLy73O2ulQh8+wVLYGyNWv+ttFPS40MRdvJXQw+Fv2rUN
         0k0x2QAXaf2N2SDgtLpCFHUTp2j4ijfXMy9UH94vvxsB1YrOAADK9ds0ZohhLQ0V4PXe
         gjng==
X-Gm-Message-State: AOAM5332wlNQ2LFwq3bGObgpCtYJkyG6tbXmpw1cIgxpzRGPRGGJW+b8
        9BNHt3cAUG3SfqCfMmZc/X63zoQ0kho=
X-Google-Smtp-Source: ABdhPJzYHkcy92be5dnLULlLQ58hc/tVRRBzsBWSWBMxdO9FX9NIlvnt7dZL9vptNvxz3XXxEvbLfA==
X-Received: by 2002:a17:90a:9cf:: with SMTP id 73mr11357005pjo.136.1628697799168;
        Wed, 11 Aug 2021 09:03:19 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:03:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 36/60] KVM: PPC: Book3S HV P9: Move vcpu register save/restore into functions
Date:   Thu, 12 Aug 2021 02:01:10 +1000
Message-Id: <20210811160134.904987-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
index 7867d6793b3e..0f86b65efc10 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4098,6 +4098,44 @@ static void store_spr_state(struct kvm_vcpu *vcpu)
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
@@ -4205,19 +4243,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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
 
@@ -4321,17 +4348,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
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

