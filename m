Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B48C3250F0
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhBYNtr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhBYNtg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:36 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEE5C06178B
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id u26so3640111pfn.6
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=veJ44tY4H1b4cNQs/+ikD/U07gxfyKVeQOKDpom/Qlo=;
        b=bIvzWMw7UyfnfE3dxFo/LOmOsyj6lCHMn9htGdUAKrD1h57jVAzaW+cTmRQ6MprAzo
         LLyROP07D4p09AfGlneIf8mQLUSp9m6C3c6sWlbdp1heDCCCZ73gYVIAs7sPuce9+jm+
         fvSY7ch69daYTM1WtnyRLkwoTN0CACzuW//5g0Orh4AVzfyu/UuXt554N3qu0lQPdrvw
         oJlJQ6leXpfEZ5YvHSHxZPUUr1cZUM/TWCblWil0mUD0eOtuIWg51p7g0/2ISSUsWxYN
         XedrKGPiqh8QZ+k4RpX1k5mNfwRyM7M3yGx3+7rQgo27ZmHQg7HMu1WWFW4BbY5tpJpP
         uZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=veJ44tY4H1b4cNQs/+ikD/U07gxfyKVeQOKDpom/Qlo=;
        b=WUSnq4GAR7kMefAgUtAFuDJrPtDXDD/GOUyce2f/e96ojACf92lcigRpHktVjq+A43
         yhxMZZgkTP6/u2Y4VEsCmQgRFWMeUlicKln2+0g80WU21oD9DSkoeC9fpzfG3AJ1eBzd
         XPmXpZiN7WXp03bgLQlXw44KKrEgub1l9TPPvMH9RGZqgNjnPycRDHfWnaPt5y+EZRNo
         F56sufjP6G3LsFdAvL4WaoxEOhqpaH02LFQxrrq2nnuwomWfnHOg2REJYXn7iOjMFVc6
         iEw8gdIdpatOpWVdsCCe5qyn3kS64t7q8ZYc/Bl49vZvqkbZxR4Frh5fto9Hgu38gOEQ
         Tvew==
X-Gm-Message-State: AOAM531vVo/Ao6AfRDxUW8QJDs7Ck2Of2XzqNLZmQznlXnSiWD6BsegL
        nrehTduUXbrR94fMRWsnCUfngVnY1+M=
X-Google-Smtp-Source: ABdhPJxq3tMoWnWb0JY9fjh/na9nQWenmY9OE5PZW5fALA538ouxAlTXUPGyJTgn2rEH91+7PngU5g==
X-Received: by 2002:a63:2a17:: with SMTP id q23mr3026533pgq.223.1614260935198;
        Thu, 25 Feb 2021 05:48:55 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:54 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 33/37] KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
Date:   Thu, 25 Feb 2021 23:46:48 +1000
Message-Id: <20210225134652.2127648-34-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
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
index 1f27187ff1e7..9d2fa21201c1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -923,6 +923,7 @@ static int kvmppc_get_yield_count(struct kvm_vcpu *vcpu)
 
 int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	unsigned long req = kvmppc_get_gpr(vcpu, 3);
 	unsigned long target, ret = H_SUCCESS;
 	int yield_count;
@@ -938,7 +939,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		break;
 	case H_PROD:
 		target = kvmppc_get_gpr(vcpu, 4);
-		tvcpu = kvmppc_find_vcpu(vcpu->kvm, target);
+		tvcpu = kvmppc_find_vcpu(kvm, target);
 		if (!tvcpu) {
 			ret = H_PARAMETER;
 			break;
@@ -952,7 +953,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		target = kvmppc_get_gpr(vcpu, 4);
 		if (target == -1)
 			break;
-		tvcpu = kvmppc_find_vcpu(vcpu->kvm, target);
+		tvcpu = kvmppc_find_vcpu(kvm, target);
 		if (!tvcpu) {
 			ret = H_PARAMETER;
 			break;
@@ -968,12 +969,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
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
@@ -1060,12 +1061,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 
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
@@ -1080,12 +1081,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
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
@@ -1096,7 +1097,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_PAGE_IN:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_page_in(vcpu->kvm,
+			ret = kvmppc_h_svm_page_in(kvm,
 						   kvmppc_get_gpr(vcpu, 4),
 						   kvmppc_get_gpr(vcpu, 5),
 						   kvmppc_get_gpr(vcpu, 6));
@@ -1104,7 +1105,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	case H_SVM_PAGE_OUT:
 		ret = H_UNSUPPORTED;
 		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_page_out(vcpu->kvm,
+			ret = kvmppc_h_svm_page_out(kvm,
 						    kvmppc_get_gpr(vcpu, 4),
 						    kvmppc_get_gpr(vcpu, 5),
 						    kvmppc_get_gpr(vcpu, 6));
@@ -1112,12 +1113,12 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
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
@@ -1127,7 +1128,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		 * Instead the kvm->arch.secure_guest flag is checked inside
 		 * kvmppc_h_svm_init_abort().
 		 */
-		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
+		ret = kvmppc_h_svm_init_abort(kvm);
 		break;
 
 	default:
-- 
2.23.0

