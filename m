Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F22353AAF
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhDEBWS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhDEBWQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:16 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9628C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:10 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q10so7182196pgj.2
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fU8rVkLPEHoGeyqW2eB3kTtDzLVfSoiwh9umkMxq39o=;
        b=ubfLRA8vtVLCQI8/PfHtoiTKhRJinzORY7U2/Iqf8xWIR0GYMU0rXJlAhdj7PfSpsQ
         yHTISvePqMMRvSaJekCbtD2nj6EhpCLMUOL6U+V9EUDrcUFywhGf+aJolKXXp8Mrzige
         IjNbSpiJcoB2Hpg1Yp/U/g/7sJo3qH76Eg33x155S34TvrIabm0yZm/W8bWDEpIINfN2
         BYTrAZawl54NLW11HyGiZBQfkOHmvdsESEjPvputVuxSuMPfv6AgtbRl88uzpHHgD7am
         LJ3V31yf5ogQYnpgFNkFV039doZbMzKqfGUPwg3XsCqe97d9kyssU9VSl7C2F7qOLAn8
         tehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fU8rVkLPEHoGeyqW2eB3kTtDzLVfSoiwh9umkMxq39o=;
        b=uCIEM8jksfwMZSswRL1U0ib1/mvus+GK/PNkh2sp/1hRFdQ8gZhSlyiAftD92Qlhv0
         tnc9BH0BTqZNdM9TopRPB6lMIFKEzHqwBLV/YlX1tnmHBnGV/7Yi9FvIQ29MtHg8qt8r
         azTD48ZNa5XRTwYOSBnp0HoJRuYZZKoTJYBbN4OCtFdkgzEV9gPJn1bSsDSfSAyX+jjl
         jGp1e7MhI8BSqNuDARkkQ6fqiB7iUh5Ec/PSYJt/ZEzCxVUP799RDv159ZMf5P+dUmLJ
         KcPkVerlnGwSjh/zyJR00Tcm82ycMQDpJvKPqjHyTd/wogf56RWBhHVx8lctfiRg7YIt
         TlzQ==
X-Gm-Message-State: AOAM533a+ApUXPgZIgvqlHZ7xb/Pxk8imovbeteslGszZVV0K3waacQV
        P8LAT4XzJ2lKYjyeJqfUXmjCHzL7LtX9LA==
X-Google-Smtp-Source: ABdhPJxpbUPbFpaB42uNqOZR+mV9rupEDrjjm2d5eLCjRD47aw1Sypjfg9qPTgWZwcO+2VM4AiHQRw==
X-Received: by 2002:a65:640f:: with SMTP id a15mr20435369pgv.121.1617585730176;
        Sun, 04 Apr 2021 18:22:10 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 38/48] KVM: PPC: Book3S HV: Remove support for dependent threads mode on P9
Date:   Mon,  5 Apr 2021 11:19:38 +1000
Message-Id: <20210405011948.675354-39-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index fa0083345b11..102928811da9 100644
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
index 21e13f93235a..20ced6c5edfd 100644
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
@@ -2264,7 +2260,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
  */
 static int threads_per_vcore(struct kvm *kvm)
 {
-	if (kvm->arch.threads_indep)
+	if (cpu_has_feature(CPU_FTR_ARCH_300))
 		return 1;
 	return threads_per_subcore;
 }
@@ -4360,7 +4356,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
 	do {
-		if (kvm->arch.threads_indep && kvm_is_radix(kvm))
+		if (kvm_is_radix(kvm))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
@@ -4984,21 +4980,8 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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
@@ -5039,7 +5022,7 @@ static void kvmppc_core_destroy_vm_hv(struct kvm *kvm)
 {
 	debugfs_remove_recursive(kvm->arch.debugfs_dir);
 
-	if (!kvm->arch.threads_indep)
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
 		kvm_hv_vm_deactivated();
 
 	kvmppc_free_vcores(kvm);
-- 
2.23.0

