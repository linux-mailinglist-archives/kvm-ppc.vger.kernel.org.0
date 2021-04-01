Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86646351843
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbhDARoX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhDARl1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:41:27 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88CAC00F7CF
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso1176137pjh.2
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDEkLrbLG9R2apsCK2gnQqMuFPbkZM9kNaSGb4ipSQE=;
        b=MgCVQ0kn2v3ELNofv7xq5fBlGyvWfZEGUNanq46SCXMsQE0oiIM/eqHlk7YpAHmATC
         Qpw0xJ/QwV1vmlqTDp1btFY/wp9rMbHEfr/B4gu9NhZXgYm0FnzRqqOTF2M+EMFHnjSq
         lAKl+YmAMBz/ZsBBKBXFBrjB2vukooMmlKjRFJlO6Ll1k+ep5rImn0W/CBMD+a7kWeF8
         JnyO7adnb3BDl4HccDK1lX2ZCk8Yk2k5xA9mfDPmJJC2adgt/Px2ymGaKE5zBw3XWcAI
         KLxsQWWJmX8UGyuK54TYC8hBSwSQkAb58hxrQQEGvQqlClVKEbazdPxWiSLrF6BRui/n
         G3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDEkLrbLG9R2apsCK2gnQqMuFPbkZM9kNaSGb4ipSQE=;
        b=iA3S2eutkVrVqhHYLVxZMyQmRlJvNlMav4ZkpBmbaIbhhOUbOEEeyYT9aRZ46PHEcK
         Uhb+7nPAJUwOiOKThB7ALA3uijTWBBRr3gFA9PY9V03dwKsCvBvfboAraL4poGMNozzK
         Yxt0OM4VOOGb3s/zzCbjeWPxicFMhj3omM6UZ8Sl47tpPDaPaAv25h8BM2OHz060NF5y
         zcJvvotdOPOEX9u4LOFaca7a3TvIqKLMeq4OrSS1IfHr6phOmMvNu5PbAFYqUqhzF5Ic
         F7+jD3bN2M2NdGXleIseIoMcP5aOOsz9ha2s0KUSuDV1wNZADrnXjQ7T40nxJIjFoEot
         puIQ==
X-Gm-Message-State: AOAM531GmuS9aegtrt3Mw6G5TEGnCUKM9f4cAWT8Ossb1a22le1Ez61Z
        XbXxxGpM+tKwUuRoHbhfZT9WbcGzbEs=
X-Google-Smtp-Source: ABdhPJx8eQfJk4OchZktXu7GJIRr/s2T1IVbVUBSSyYAgKydMCloANXTahawxOY9BOfFVNlvFPEiiQ==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr9140000pjb.169.1617289548274;
        Thu, 01 Apr 2021 08:05:48 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:48 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 44/48] KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
Date:   Fri,  2 Apr 2021 01:03:21 +1000
Message-Id: <20210401150325.442125-45-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Functionality should not be changed.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f4fa39f4cd4c..8416ec0d88bc 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -925,6 +925,7 @@ static int kvmppc_get_yield_count(struct kvm_vcpu *vcpu)
 
 int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	unsigned long req = kvmppc_get_gpr(vcpu, 3);
 	unsigned long target, ret = H_SUCCESS;
 	int yield_count;
@@ -940,7 +941,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		break;
 	case H_PROD:
 		target = kvmppc_get_gpr(vcpu, 4);
-		tvcpu = kvmppc_find_vcpu(vcpu->kvm, target);
+		tvcpu = kvmppc_find_vcpu(kvm, target);
 		if (!tvcpu) {
 			ret = H_PARAMETER;
 			break;
@@ -954,7 +955,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		target = kvmppc_get_gpr(vcpu, 4);
 		if (target == -1)
 			break;
-		tvcpu = kvmppc_find_vcpu(vcpu->kvm, target);
+		tvcpu = kvmppc_find_vcpu(kvm, target);
 		if (!tvcpu) {
 			ret = H_PARAMETER;
 			break;
@@ -970,12 +971,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 					kvmppc_get_gpr(vcpu, 6));
 		break;
 	case H_RTAS:
-		if (list_empty(&vcpu->kvm->arch.rtas_tokens))
+		if (list_empty(&kvm->arch.rtas_tokens))
 			return RESUME_HOST;
 
-		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		idx = srcu_read_lock(&kvm->srcu);
 		rc = kvmppc_rtas_hcall(vcpu);
-		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		srcu_read_unlock(&kvm->srcu, idx);
 
 		if (rc == -ENOENT)
 			return RESUME_HOST;
@@ -1062,12 +1063,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 
 	case H_SET_PARTITION_TABLE:
 		ret = H_FUNCTION;
-		if (nesting_enabled(vcpu->kvm))
+		if (nesting_enabled(kvm))
 			ret = kvmhv_set_partition_table(vcpu);
 		break;
 	case H_ENTER_NESTED:
 		ret = H_FUNCTION;
-		if (!nesting_enabled(vcpu->kvm))
+		if (!nesting_enabled(kvm))
 			break;
 		ret = kvmhv_enter_nested_guest(vcpu);
 		if (ret == H_INTERRUPT) {
@@ -1082,12 +1083,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		break;
 	case H_TLB_INVALIDATE:
 		ret = H_FUNCTION;
-		if (nesting_enabled(vcpu->kvm))
+		if (nesting_enabled(kvm))
 			ret = kvmhv_do_nested_tlbie(vcpu);
 		break;
 	case H_COPY_TOFROM_GUEST:
 		ret = H_FUNCTION;
-		if (nesting_enabled(vcpu->kvm))
+		if (nesting_enabled(kvm))
 			ret = kvmhv_copy_tofrom_guest_nested(vcpu);
 		break;
 	case H_PAGE_INIT:
@@ -1098,7 +1099,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_PAGE_IN:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_page_in(vcpu->kvm,
+			ret = kvmppc_h_svm_page_in(kvm,
 						   kvmppc_get_gpr(vcpu, 4),
 						   kvmppc_get_gpr(vcpu, 5),
 						   kvmppc_get_gpr(vcpu, 6));
@@ -1106,7 +1107,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_PAGE_OUT:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_page_out(vcpu->kvm,
+			ret = kvmppc_h_svm_page_out(kvm,
 						    kvmppc_get_gpr(vcpu, 4),
 						    kvmppc_get_gpr(vcpu, 5),
 						    kvmppc_get_gpr(vcpu, 6));
@@ -1114,12 +1115,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_INIT_START:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_init_start(vcpu->kvm);
+			ret = kvmppc_h_svm_init_start(kvm);
 		break;
 	case H_SVM_INIT_DONE:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_init_done(vcpu->kvm);
+			ret = kvmppc_h_svm_init_done(kvm);
 		break;
 	case H_SVM_INIT_ABORT:
 		/*
@@ -1129,7 +1130,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		 * Instead the kvm->arch.secure_guest flag is checked inside
 		 * kvmppc_h_svm_init_abort().
 		 */
-		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
+		ret = kvmppc_h_svm_init_abort(kvm);
 		break;
 
 	default:
-- 
2.23.0

