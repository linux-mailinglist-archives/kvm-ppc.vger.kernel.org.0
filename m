Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC2734549A
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCWBFv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhCWBFT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:05:19 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8650FC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:19 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id l123so12536081pfl.8
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+/jqa7B3jf0e6tfJqI+bzs5aqditxAeCE1iDWiOChs=;
        b=AWdeqxvI9YnPt91lzdFR83KTwWnWDUOD0t+7Eoxqh+1oQG3mZuDW82aWscsJMzKnLK
         RE45qh+HiM2BN8U0xZ6LbVhpNkgb3rq6WoUsSPDOXjlIgrPSnqezE11tDIWpNMpgbtIZ
         WM5bWZLDUFS9D3Lheal+KRfasUZ6caZ+XSbcpXvv/SEvT4nr28LHiSZP0MXKv9x7Wtsv
         x3ElHW5P0Y8L9Gxc6AQVrPf/hHvz0cDCW69nqKIauceECpH8jg5aqbpgWZNL7eDCjGtE
         APQJasMnJ38BGnm6gK0N1/VM3IsMzBgJoSMkg8dcECdM15tZV57ZnU1AbKo4TDc+TuGf
         xniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+/jqa7B3jf0e6tfJqI+bzs5aqditxAeCE1iDWiOChs=;
        b=HxV4p/aXsu4lsztaXUfmA3vp/9H2VqDs+/fUMvJ1jJHJ6tidhUxlCuZpxtUcTGVCLk
         xMdMqdvKys605o9fKtP5ZyzvbGiLgmEVeNtbkjT81atHgwn8+nuC/L3y9sS0PP0MgmXe
         SyWh9fAn6cFDPaSGY/92FaVxxVbBaPiflRy9lxciMZbCdTJESlTQmWK4S97sQefCaH0i
         XOY4wi6HPZxgZ3zFFYyc47h4hh2FERDVGrPAW0Jn08TJW1inAuVMoIrbOCO9TN58FSeO
         yM8LadujNhuM4QfEp3WkzpGk86zDlHJp8hITWStxeQ/5SNGPAp0XlXvWUGRlhr7ngX7v
         PFQg==
X-Gm-Message-State: AOAM5328nqghX6Dil6ZCkCVYbRsNMZohnXFuHsw7d188q0h+70NfYm54
        0jf2onTuvoJsRVFFYQ3WT6lNiHhg8VQ=
X-Google-Smtp-Source: ABdhPJyh2Dwkz641EnyI9TwIhS4cZJqJXunzqZrBC0m/I4s0Ja/Uw+bWq5nbR//KLHGH5u0tOI+K4w==
X-Received: by 2002:a17:902:d78a:b029:e6:e1f:f695 with SMTP id z10-20020a170902d78ab02900e60e1ff695mr2277666ply.82.1616461518877;
        Mon, 22 Mar 2021 18:05:18 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:05:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 42/46] KVM: PPC: Book3S HV: small pseries_do_hcall cleanup
Date:   Tue, 23 Mar 2021 11:03:01 +1000
Message-Id: <20210323010305.1045293-43-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index 0f3c1792ab86..e6d113dbc076 100644
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

