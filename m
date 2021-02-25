Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE70B3250DA
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBYNtZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhBYNtO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:14 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A10CC061574
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:59 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id o38so3795497pgm.9
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uEQIGr8Qp8LFoR1y4PL0b7+g3Mw1hvzNAwtrHtHvVdU=;
        b=lO8j5A1AGxcM10U9YGyU7kGNYkYvI5h+IB9BX3Gy2rw0u8flT32H5Q96VFCkBVzM4i
         6ubVdEoi4bljklOLXBqtBhol/jlSwhiN6TakhwbID81h8ASr2H33wVAas7Z0T93nVamg
         UvMuWZRWhIi9Kg8sNEFoVZKkiCpdlGjhNTeyJtWpQNAuqLNzL/cyYDbQ/l+U4TKUJv26
         QVubzlr1OWdWsOmr9YOELifPL/kRAsA2pMV1ICiRV6SfUcdR+0BpSm+y/2K6tNNPCris
         HzkmfY8DGYYrUjLD4Opp5zmMtIZYApDHMcimWfPNml9troOZ7jquiptYJz+8zUjHY6Dm
         D0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uEQIGr8Qp8LFoR1y4PL0b7+g3Mw1hvzNAwtrHtHvVdU=;
        b=QbQIZQKkxD+GWwfoNnPV3vV8E+1ST20vGbUtHtcR2kDXTks4ol/0VCiEA1ut1L5ZSN
         qpOmVUbZ1rgdGF0Yj/dHjqXp35r2XTMcK/hd9+mwW47AQKYTKaWGl4EvNZp5fMZOBMj8
         mEfvqPB41hxYgMkm7BdK3jsq+XdMS5bS7TkZlgncKGDctNWgBzBuLywNZskfUaIcUEAk
         JK9og6l9nxXEla+AtuVr2JWfj/oz2MVWq1mAIeAOo8RBYDRpJ0Yu4+MOAie7CtBhoWtn
         kwH2CWhxb9GzqWU6CGEGEzWerl3+3eQhYW0xYumsftcpJCcQPp+wivQkbbUAdyhgv80b
         56Sg==
X-Gm-Message-State: AOAM5326/dDVRgnsNn3v6jr+lC6reJsPwNb19IV/Mzv5GEYj5hHYsD4A
        4Hs7yDf6L/q831qT3h5NZpUl3ng8cGQ=
X-Google-Smtp-Source: ABdhPJzTgPyR7/GY4LHlXD8W7cxZ9ohC9HH4hNz/Lz3TX4tnQt7EqG2yJmSc29rGHYiqhEbqva7PhQ==
X-Received: by 2002:a63:520d:: with SMTP id g13mr3098033pgb.234.1614260938490;
        Thu, 25 Feb 2021 05:48:58 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:57 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 34/37] KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults
Date:   Thu, 25 Feb 2021 23:46:49 +1000
Message-Id: <20210225134652.2127648-35-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In order to support hash guests in the P9 path (which does not do real
mode hcalls or page fault handling), these real-mode hash specific
interrupts need to be implemented in virt mode.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 118 +++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9d2fa21201c1..1bbc46f2cfbf 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -935,6 +935,52 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 		return RESUME_HOST;
 
 	switch (req) {
+	case H_REMOVE:
+		ret = kvmppc_h_remove(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5),
+					kvmppc_get_gpr(vcpu, 6));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_ENTER:
+		ret = kvmppc_h_enter(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5),
+					kvmppc_get_gpr(vcpu, 6),
+					kvmppc_get_gpr(vcpu, 7));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_READ:
+		ret = kvmppc_h_read(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_CLEAR_MOD:
+		ret = kvmppc_h_clear_mod(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_CLEAR_REF:
+		ret = kvmppc_h_clear_ref(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_PROTECT:
+		ret = kvmppc_h_protect(vcpu, kvmppc_get_gpr(vcpu, 4),
+					kvmppc_get_gpr(vcpu, 5),
+					kvmppc_get_gpr(vcpu, 6));
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+	case H_BULK_REMOVE:
+		ret = kvmppc_h_bulk_remove(vcpu);
+		if (ret == H_TOO_HARD)
+			return RESUME_HOST;
+		break;
+
 	case H_CEDE:
 		break;
 	case H_PROD:
@@ -1134,6 +1180,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	default:
 		return RESUME_HOST;
 	}
+	WARN_ON_ONCE(ret == H_TOO_HARD);
 	kvmppc_set_gpr(vcpu, 3, ret);
 	vcpu->arch.hcall_needed = 0;
 	return RESUME_GUEST;
@@ -1420,19 +1467,80 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	 * host page has been paged out.  Any other HDSI/HISI interrupts
 	 * have been handled already.
 	 */
-	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
-		r = RESUME_PAGE_FAULT;
-		if (vcpu->arch.fault_dsisr == HDSISR_CANARY)
+	case BOOK3S_INTERRUPT_H_DATA_STORAGE: {
+		unsigned long vsid;
+		long err;
+
+		if (vcpu->arch.fault_dsisr == HDSISR_CANARY) {
 			r = RESUME_GUEST; /* Just retry if it's the canary */
+			break;
+		}
+
+		if (kvm_is_radix(vcpu->kvm)) {
+			r = RESUME_PAGE_FAULT;
+			break;
+		}
+
+		if (!(vcpu->arch.fault_dsisr & (DSISR_NOHPTE | DSISR_PROTFAULT))) {
+			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
+			r = RESUME_GUEST;
+			break;
+		}
+		if (!(vcpu->arch.shregs.msr & MSR_DR)) {
+			vsid = vcpu->kvm->arch.vrma_slb_v;
+		} else {
+			vsid = vcpu->arch.fault_gpa;
+		}
+		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
+				vsid, vcpu->arch.fault_dsisr, true);
+		if (err == 0) {
+			r = RESUME_GUEST;
+		} else if (err == -1 || err == -2) {
+			r = RESUME_PAGE_FAULT;
+		} else {
+			kvmppc_core_queue_data_storage(vcpu, vcpu->arch.fault_dar, err);
+			r = RESUME_GUEST;
+		}
 		break;
-	case BOOK3S_INTERRUPT_H_INST_STORAGE:
+	}
+	case BOOK3S_INTERRUPT_H_INST_STORAGE: {
+		unsigned long vsid;
+		long err;
+
 		vcpu->arch.fault_dar = kvmppc_get_pc(vcpu);
 		vcpu->arch.fault_dsisr = vcpu->arch.shregs.msr &
 			DSISR_SRR1_MATCH_64S;
 		if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
 			vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
-		r = RESUME_PAGE_FAULT;
+		if (kvm_is_radix(vcpu->kvm)) {
+			r = RESUME_PAGE_FAULT;
+			break;
+		}
+
+		if (!(vcpu->arch.fault_dsisr & SRR1_ISI_NOPT)) {
+			/* XXX: clear DSISR_ISSTORE? */
+			kvmppc_core_queue_inst_storage(vcpu, vcpu->arch.fault_dsisr);
+			r = RESUME_GUEST;
+			break;
+		}
+		if (!(vcpu->arch.shregs.msr & MSR_DR)) {
+			vsid = vcpu->kvm->arch.vrma_slb_v;
+		} else {
+			vsid = vcpu->arch.fault_gpa;
+		}
+		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
+				vsid, vcpu->arch.fault_dsisr, false);
+		if (err == 0) {
+			r = RESUME_GUEST;
+		} else if (err == -1) {
+			r = RESUME_PAGE_FAULT;
+		} else {
+			kvmppc_core_queue_inst_storage(vcpu, err);
+			r = RESUME_GUEST;
+		}
 		break;
+	}
+
 	/*
 	 * This occurs if the guest executes an illegal instruction.
 	 * If the guest debug is disabled, generate a program interrupt
-- 
2.23.0

