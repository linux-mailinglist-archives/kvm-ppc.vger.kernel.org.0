Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1372353AB5
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhDEBWd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhDEBWc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAEEC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:26 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id w10so1678187pgh.5
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pdmRKC0+A/lxg5MleIGjZCeeIx1sWRVwvGao9UDQW6o=;
        b=HHbOVKHiOBWr+G8xFW7RIRSZv8tUFBfxIdYuJfm3IEJ25RcDfky9eSniF+vD1y6Yd+
         0Z+yFBaSDjBo+WM2/UNo+8mG5L9h9vpITNQ6a71YAd4lckcH2ocjiFhY+YFnk24+b0ih
         M/C60OQ0YC4on9bSP7XR/BcL5jJmzt4A/QQvEJ6RxYKAO1OPE1YfyQ6xLH21ZckjAkMs
         W6gpPix22tLER1Pb/H635cRroX5jnLygmNTIF3mgn8h4b1QL/hAWfFrVXiJPF1BuyTdr
         +vfQDIi6DCBpZPzdtebaRC+iIst8Mnvao/XHrYzpKSCog5nkagjCuRor4LblZWtLWwB7
         at1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pdmRKC0+A/lxg5MleIGjZCeeIx1sWRVwvGao9UDQW6o=;
        b=DD/zU5wbHIdc3PUYoU58G52ardl+dPTMFgAMsy3pl+ETARcQ15BP08P+6YISnOTA+N
         +j1JwEV2r4DvhwnoLv+eoVmFqbXOq1Im1gosMU23j/lbLKuDXS097tuu+Z7xWGaj3IVq
         KhDWRzLMiVvOUUVI51MB+bN0Z+EVqJono3HGrCSWZfmucfYUX2ptcKbRUy2HqN15goz2
         LdA0sfWy/kJsdjMVlL2c1aX1i/QDiLoPiVz6/aWqzdnsf/UFyiypVR0fMUIbha2fOAPq
         0ZA/A8Vl94s4eN8VziM8HwwP5GRWHVqBPJPxMCHa/iKGN/sBm+2jcbX7aL3cFzZrhmoN
         6/Aw==
X-Gm-Message-State: AOAM532GW/21KLAR8h5Qa5GHuGN3cvAjOPu8XD90WocyEz3cdCk14tj8
        BisIaBUlcGE8kA9hrtwNxZztfzTzKf3LcQ==
X-Google-Smtp-Source: ABdhPJwSIFx8ukfEtjjf+im29WHCk6IgpkFeZtw1PSGg5YUWzCZXJbLote7uXh0iWV1wQg1JU6SGGw==
X-Received: by 2002:a63:4415:: with SMTP id r21mr21215311pga.222.1617585745681;
        Sun, 04 Apr 2021 18:22:25 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 43/48] KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
Date:   Mon,  5 Apr 2021 11:19:43 +1000
Message-Id: <20210405011948.675354-44-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index 5ef43d9b19bc..4b4250c04117 100644
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

