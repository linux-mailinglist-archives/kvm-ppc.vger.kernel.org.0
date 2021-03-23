Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63F9345493
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhCWBF3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhCWBFG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:06 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F23C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:05 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v2so10041320pgk.11
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xHgVkqThu3YVjb/LlhPKNVCBzPJbceg0r7qPQTj5Pz4=;
        b=ngUv60Qh9l4EaxWirUBMWlqDNLd022gVdFbIZnhx6N37VR5FWIEWlN+21edabbm596
         aoCe/cXnt5Vb++HAGn374inPONUNnRA4c+9Sx/1uN3ynk3fJw2toVQlqNArdW8Qk5xMP
         /1dFEvhh9tBz6ZXc+l5F3s+oyDoLHfcFQlmVagqNOj80r6zWPMHak9KIx/WkbbGbuYeZ
         SMOHyDmQfLYHoduuK10WXY7xLxKgTSmNCnQLfMDpRcT/w/UWBmJxWVfTfsmPNOQMqBkV
         zXq8ORkq+eNyvKAbmZScfW0GlfzjYMjcMmapmohzYrP8gxtvQIvqhZeaZUPGUOgnXrWk
         HUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xHgVkqThu3YVjb/LlhPKNVCBzPJbceg0r7qPQTj5Pz4=;
        b=QS45SPnOQldW/HntYx1Pup+q2TV4HhDGU2cjXRXk+rrlx48KCCBFuHD9GJHL4e+rTz
         mIKrcLzMGFM+YS639d47vVPefkhhOQ34YQ1j1SixlNElZojweB0FCZLrFcyfuANz1vU0
         UqDD1Vs1OzEtNZeoYdV4a4kJXaFzFBN3CuIoXpQb5nm55D34fe5KGXj5JgJ+fNW2KexY
         5DmckRghkiyl/GQJs7jOuBe/xBh6lmsKZpzC47Nzth0z44s2OicTJcWeA0Uj8rU2V0PN
         loBWSbJQZ6tN25n3PL/eNXB5DAO84UuKFWvJMSYbkazHPc3aFoFlXGEyVZzGyayR6sLF
         K75g==
X-Gm-Message-State: AOAM530Fc8Z2PAF+jvjpabn1vdwC/IynAvm/MoA0DNERPY0J88e9K9S7
        L+TmJp7vNM+F92x9e1EcNXv3VhE6844=
X-Google-Smtp-Source: ABdhPJxCNtGVq6QBH3SllkpPoBJaip1LbeJ9wLqrjGVYJ1u2tX7wg/lnsr8LW6AURmbNddnSMp/OHQ==
X-Received: by 2002:aa7:824e:0:b029:20a:3a1:eeda with SMTP id e14-20020aa7824e0000b029020a03a1eedamr2277597pfn.71.1616461505176;
        Mon, 22 Mar 2021 18:05:05 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 37/46] KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
Date:   Tue, 23 Mar 2021 11:02:56 +1000
Message-Id: <20210323010305.1045293-38-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Radix guest support will be removed from the P7/8 path, so disallow
dependent threads mode on P9.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_host.h |  1 -
 arch/powerpc/kvm/book3s_hv.c        | 27 +++++----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 05fb00d37609..dd017dfa4e65 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -304,7 +304,6 @@ struct kvm_arch {
 	u8 fwnmi_enabled;
 	u8 secure_guest;
 	u8 svm_enabled;
-	bool threads_indep;
 	bool nested_enable;
 	bool dawr1_enabled;
 	pgd_t *pgtable;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8480cbe4b4fa..85a14ce0ea0e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -103,13 +103,9 @@ static int target_smt_mode;
 module_param(target_smt_mode, int, 0644);
 MODULE_PARM_DESC(target_smt_mode, "Target threads per core (0 = max)");
 
-static bool indep_threads_mode = true;
-module_param(indep_threads_mode, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(indep_threads_mode, "Independent-threads mode (only on POWER9)");
-
 static bool one_vm_per_core;
 module_param(one_vm_per_core, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires indep_threads_mode=N)");
+MODULE_PARM_DESC(one_vm_per_core, "Only run vCPUs from the same VM on a core (requires POWER8 or older)");
 
 #ifdef CONFIG_KVM_XICS
 static const struct kernel_param_ops module_param_ops = {
@@ -2247,7 +2243,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
  */
 static int threads_per_vcore(struct kvm *kvm)
 {
-	if (kvm->arch.threads_indep)
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
 		return 1;
 	return threads_per_subcore;
 }
@@ -4345,7 +4341,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm))
+		if (kvm_is_radix(kvm))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4961,21 +4957,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 	/*
 	 * Track that we now have a HV mode VM active. This blocks secondary
 	 * CPU threads from coming online.
-	 * On POWER9, we only need to do this if the "indep_threads_mode"
-	 * module parameter has been set to N.
 	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
-		if (!indep_threads_mode && !cpu_has_feature(CPU_FTR_HVMODE)) {
-			pr_warn("KVM: Ignoring indep_threads_mode=N in nested hypervisor\n");
-			kvm->arch.threads_indep = true;
-		} else if (!indep_threads_mode && cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG)) {
-			pr_warn("KVM: Ignoring indep_threads_mode=N on pre-DD2.2 POWER9\n");
-			kvm->arch.threads_indep = true;
-		} else {
-			kvm->arch.threads_indep = indep_threads_mode;
-		}
-	}
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_activated();
 
 	/*
@@ -5016,7 +4999,7 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 {
 	debugfs_remove_recursive(kvm->arch.debugfs_dir);
 
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_deactivated();
 
 	kvmppc_free_vcores(kvm);
-- 
2.23.0

