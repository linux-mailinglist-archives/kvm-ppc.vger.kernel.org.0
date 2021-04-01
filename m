Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633BB351DB7
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbhDASbp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239147AbhDASUm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:20:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F2BC00F7D0
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v8so1150813plz.10
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YwgW/IzByL/GBvKynVGK4GTgGQ8KhzbkEW+bUvuKPnk=;
        b=NuGOW17Z95NM7UW1ZDDudbu0EfhpuP/PSU8Goo0KD7DH3faGBIr+5iXI8Krje3xiph
         1J4PANz9/vdQvMuqc+gb1nFStCj/2gPn6LErJxNY27OccrBiPh2zpKBL7NfQzm2DOSQK
         pSiU321ZNPlOFuhDJCe7EYZejxoNOu6HXoN4UKWpN7PohQG2ZistMkWJBlrICoMUr/p1
         FMJJOuH6jBPZ1AYAXOy2ko//0PVPdcmuufWjPKvO+AgQdBijvPOTVSoM7ED95SzDn9Md
         EHqZ/sexhh/OPK9nh/7G3KoTOG4UtVCw/L998/MYWtYZ3rZHR48+RjZ+hMHzhLIKlwB6
         7yPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YwgW/IzByL/GBvKynVGK4GTgGQ8KhzbkEW+bUvuKPnk=;
        b=XpcE+p+AY12Ej8Bqo1lB4OrygkGI3tDJ5uAzcMmVM/x0Bg89kJwHmD2E1TbSIRPimz
         73+G1UV97Uz/xRDM1Nb/IdmlCTUXyRi0/kcZYSFNTSjyt8iy+pQN0t4S/5ovRxThiGqB
         Tj9n3jFTwOd7hdn8OJQSmGS5rviUhlxvm/j/uO5FpgEkxNCuNSeFjZah+Xq16KXadKlV
         Z2UJPXET8rh6inmMJY7ogZNdU+IYeoH2LEKvltgxYAaA7rQ2L3i28lRjfP/W51rK1VtZ
         esgDBs597iVY9mzhtru57jpZPX2hVxz/YRKB97DNznsTDgKxe7ey/QsdcACqn8yu3qO0
         +Ehw==
X-Gm-Message-State: AOAM533PhsgLRNW3noZ99jIKGIrcpuj1+d2q3sxq/0TwiJO8t+os+FGe
        kSAr1LQVQYxS3DLUzt/rJZ+3P3d+QpI=
X-Google-Smtp-Source: ABdhPJxIkLjvr3J9eeahEj0+LLQ0o6+LMnTTsxftpSBra9QthDyWfB7zjjhSr9Rpat/AdVRa3Vrbag==
X-Received: by 2002:a17:90a:29e4:: with SMTP id h91mr9101208pjd.225.1617289551003;
        Thu, 01 Apr 2021 08:05:51 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 45/48] KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults
Date:   Fri,  2 Apr 2021 01:03:22 +1000
Message-Id: <20210401150325.442125-46-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c        | 126 ++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv_rm_mmu.c |   8 ++
 2 files changed, 127 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8416ec0d88bc..6b34cd81000e 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -937,6 +937,52 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
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
@@ -1136,6 +1182,7 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 	default:
 		return RESUME_HOST;
 	}
+	WARN_ON_ONCE(ret == H_TOO_HARD);
 	kvmppc_set_gpr(vcpu, 3, ret);
 	vcpu->arch.hcall_needed = 0;
 	return RESUME_GUEST;
@@ -1443,19 +1490,84 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
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
+			kvmppc_core_queue_data_storage(vcpu,
+				vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
+			r = RESUME_GUEST;
+			break;
+		}
+
+		if (!(vcpu->arch.shregs.msr & MSR_DR))
+			vsid = vcpu->kvm->arch.vrma_slb_v;
+		else
+			vsid = vcpu->arch.fault_gpa;
+
+		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
+				vsid, vcpu->arch.fault_dsisr, true);
+		if (err == 0) {
+			r = RESUME_GUEST;
+		} else if (err == -1 || err == -2) {
+			r = RESUME_PAGE_FAULT;
+		} else {
+			kvmppc_core_queue_data_storage(vcpu,
+				vcpu->arch.fault_dar, err);
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
-		if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
-			vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
-		r = RESUME_PAGE_FAULT;
+		if (kvm_is_radix(vcpu->kvm)) {
+			if (vcpu->arch.shregs.msr & HSRR1_HISI_WRITE)
+				vcpu->arch.fault_dsisr |= DSISR_ISSTORE;
+			r = RESUME_PAGE_FAULT;
+			break;
+		}
+
+		if (!(vcpu->arch.fault_dsisr & SRR1_ISI_NOPT)) {
+			kvmppc_core_queue_inst_storage(vcpu,
+				vcpu->arch.fault_dsisr);
+			r = RESUME_GUEST;
+			break;
+		}
+
+		if (!(vcpu->arch.shregs.msr & MSR_DR))
+			vsid = vcpu->kvm->arch.vrma_slb_v;
+		else
+			vsid = vcpu->arch.fault_gpa;
+
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
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 7af7c70f1468..8cc73abbf42b 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -409,6 +409,7 @@ long kvmppc_h_enter(struct kvm_vcpu *vcpu, unsigned long flags,
 				 vcpu->arch.pgdir, true,
 				 &vcpu->arch.regs.gpr[4]);
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_enter);
 
 #ifdef __BIG_ENDIAN__
 #define LOCK_TOKEN	(*(u32 *)(&get_paca()->lock_token))
@@ -553,6 +554,7 @@ long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
 	return kvmppc_do_h_remove(vcpu->kvm, flags, pte_index, avpn,
 				  &vcpu->arch.regs.gpr[4]);
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_remove);
 
 long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 {
@@ -671,6 +673,7 @@ long kvmppc_h_bulk_remove(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_bulk_remove);
 
 long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
 		      unsigned long pte_index, unsigned long avpn)
@@ -741,6 +744,7 @@ long kvmppc_h_protect(struct kvm_vcpu *vcpu, unsigned long flags,
 
 	return H_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_protect);
 
 long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
 		   unsigned long pte_index)
@@ -781,6 +785,7 @@ long kvmppc_h_read(struct kvm_vcpu *vcpu, unsigned long flags,
 	}
 	return H_SUCCESS;
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_read);
 
 long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 			unsigned long pte_index)
@@ -829,6 +834,7 @@ long kvmppc_h_clear_ref(struct kvm_vcpu *vcpu, unsigned long flags,
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_clear_ref);
 
 long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 			unsigned long pte_index)
@@ -876,6 +882,7 @@ long kvmppc_h_clear_mod(struct kvm_vcpu *vcpu, unsigned long flags,
 	unlock_hpte(hpte, v & ~HPTE_V_HVLOCK);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvmppc_h_clear_mod);
 
 static int kvmppc_get_hpa(struct kvm_vcpu *vcpu, unsigned long mmu_seq,
 			  unsigned long gpa, int writing, unsigned long *hpa,
@@ -1294,3 +1301,4 @@ long kvmppc_hpte_hv_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 
 	return -1;		/* send fault up to host kernel mode */
 }
+EXPORT_SYMBOL_GPL(kvmppc_hpte_hv_fault);
-- 
2.23.0

