Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9273250DD
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhBYNtf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhBYNt3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:29 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19C9C061756
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:49 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t5so5069607pjd.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jZ1wfYQFjuRbdyvcRSS6ix6mGNgmk39buWP9mBEV9/M=;
        b=aF54FXJ8C41bl5cKZY58N0m8jnWaI7Nj6Q6FgN1HlMLmfL1QeZcH3TNLg0EAx3gmyN
         +qAx3jSBopJo8GAetxELd0lNX7C6Q75l/0hMJF12CSNbwZPQRv9b9wcI52NctexkWTKE
         98eaYPmqE6WGr1C5Fh9kIyIx0lEVlftuUmUjrTq7lMGAnpEoi/IJATt3OemEW+mn0X5J
         GLAo4Ut7CE6bZHW/gtlU2KleJ7NcbhFJ41PAAcH0pB9YxcHPI9hp+9KhYzHbtB5qwkZo
         B3xeJP4DDGLZVP3TNw99IAsIAFBtz1QZ1/YkvO77w1JqEE1IeEU5Ej3LWIFfMGea41TD
         vpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZ1wfYQFjuRbdyvcRSS6ix6mGNgmk39buWP9mBEV9/M=;
        b=Xg0mle44ZdtRh7p5BSQlkGoErgCXF2fZ7oQWg7uCZgXFPQqGdCnVBMGRuh71YXGs2h
         vvMrGKfqoG6jS4xEH22ttazCPP0Mi09kTBkowgfjdMIK1K6W8sektFm0KSsfLwognHPc
         h7+LKbTF+OMKAKey63IUEucN4gVj/ARpPWF+zllC2Zv+GI5DwR4vVkespyoFtzYQJrBn
         dEQsvoNvursxNSmGMXUd/xRYqD9txr4mHwSeXIXWeMSJ2ahHKzkM5MeTGis7yAhyYHgl
         bA4efrCXpaTesING36MYPM/0jJrTmuOMQBhDr3ikDERhgXi+HRP3qHD+baWu1CMQlbge
         +BqA==
X-Gm-Message-State: AOAM532wKQ1ATdhS8/oxZfXonYcHX+0S7jSZQ8Z7UlGG8l3pAFGGuOTQ
        VkM3wFbY1jiOOsAS0TC0zDQiXTZBFsw=
X-Google-Smtp-Source: ABdhPJwMBUWfvwykU+tx48kV3tQeLk29DGRGlwSw7c67hvySaKDQiqoeNcwT0v45yjz2hih1yc/CgA==
X-Received: by 2002:a17:902:f702:b029:e3:5e25:85bb with SMTP id h2-20020a170902f702b02900e35e2585bbmr3190850plo.56.1614260928742;
        Thu, 25 Feb 2021 05:48:48 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:48 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 31/37] KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
Date:   Thu, 25 Feb 2021 23:46:46 +1000
Message-Id: <20210225134652.2127648-32-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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
index c3064075f1d7..1f27187ff1e7 100644
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
@@ -2201,7 +2197,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
  */
 static int threads_per_vcore(struct kvm *kvm)
 {
-	if (kvm->arch.threads_indep)
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
 		return 1;
 	return threads_per_subcore;
 }
@@ -4290,7 +4286,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		 * The TLB prefetch bug fixup is only in the kvmppc_run_vcpu
 		 * path, which also handles hash and dependent threads mode.
 		 */
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm))
+		if (kvm_is_radix(kvm))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4910,21 +4906,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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
@@ -4965,7 +4948,7 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 {
 	debugfs_remove_recursive(kvm->arch.debugfs_dir);
 
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_deactivated();
 
 	kvmppc_free_vcores(kvm);
-- 
2.23.0

