Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2349353AB6
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhDEBWg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhDEBWe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5C6C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so7103132pjb.0
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w9g9tEIvKA9BaaOhyCdKJhH/7pnlKO+LumCOdT40cHo=;
        b=KzyyK6fh7FXEEP8X3gGPI33ooxIx35VOAyAdSCryB43BwpT2glwfDa13nPmxX8qQln
         u4G5pBZVKNdk8wan5cAzAtdRv07y4Pz5TCm++vbCFHQYMUbEilfVRPEnO1ZPbf10+GUk
         qI2y6NaGRC94F5z6S6AByfnJZJOBeMGJZsBS85iUZv3MYbx74n1KS3Kp4pOH4k2FmDgc
         ixefxxXK071ieGA/VooY7deZknTWpB18/ddCUTLqaeDkKW4xfEzHD+oxk8FWVPup1bqD
         9xsI9LTDJhdhZH624O9pEVGXN7qVRekKMqY7MPRTulJxPn4J3s1Ov+/6b7PHUzyylkck
         Gzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w9g9tEIvKA9BaaOhyCdKJhH/7pnlKO+LumCOdT40cHo=;
        b=CUsLrEBGIQ3tokhQau1uDJ83arxAmU4mCmIdUJxZIjpkD7HuiQ7cUXC7GDoxLfWIaW
         RFoTZnT07i9xsEO8fjjEW5sIt/Wx+eMjVpOdSSAzGTyO2Ogq/9/mqgac0VOaa6c2GmZf
         RitqP1zWr3c8kLy7JyAuvTmGQ2v3f0fFgrpD2g178n+vEhWKDXOOsYNYn4W6JmHvjmBp
         WD4M5tRg2gX9g4AV+60O3BIAdP9uKm4Kit6pEYTXYlnhNygXCEMxeziT6pfHbZuLdW1r
         Ak8Nj3u13xL/cp1XdQFvhF+36Obd1ScRa0EoemNNSpd0XmNmAR3/wb4qTBeZp8H8IHrD
         516Q==
X-Gm-Message-State: AOAM5311MUCk6rfigGDAJLmIQ1c/XKyCDTvvVClduaJP0x9+ETrXYYaS
        +IAoumYYW3Vgtzq60aEbHnNj/sX1oWmZdw==
X-Google-Smtp-Source: ABdhPJzJfsoPPimRtez0ZO7paZfzCo4qu1VuzIH3E1IyOQ/H7hbN2C22TJlHDr6s43pnz2fHHBbjzA==
X-Received: by 2002:a17:902:263:b029:e7:35d8:4554 with SMTP id 90-20020a1709020263b02900e735d84554mr21596890plc.83.1617585748664;
        Sun, 04 Apr 2021 18:22:28 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:28 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 44/48] KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults
Date:   Mon,  5 Apr 2021 11:19:44 +1000
Message-Id: <20210405011948.675354-45-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c        | 145 ++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv_rm_mmu.c |   8 ++
 2 files changed, 144 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4b4250c04117..d8e36f1ea66d 100644
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
@@ -1437,22 +1484,102 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	 * We get these next two if the guest accesses a page which it thinks
 	 * it has mapped but which is not actually present, either because
 	 * it is for an emulated I/O device or because the corresonding
-	 * host page has been paged out.  Any other HDSI/HISI interrupts
-	 * have been handled already.
+	 * host page has been paged out.
+	 *
+	 * Any other HDSI/HISI interrupts have been handled already for P7/8
+	 * guests. For POWER9 hash guests not using rmhandlers, basic hash
+	 * fault handling is done here.
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
+		if (kvm_is_radix(vcpu->kvm) || !cpu_has_feature(CPU_FTR_ARCH_300)) {
+			/*
+			 * Radix doesn't require anything, and pre-ISAv3.0 hash
+			 * already attempted to handle this in rmhandlers. The
+			 * hash fault handling below is v3 only (it uses ASDR
+			 * via fault_gpa).
+			 */
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
+		if (kvm_is_radix(vcpu->kvm) || !cpu_has_feature(CPU_FTR_ARCH_300)) {
+			/*
+			 * Radix doesn't require anything, and pre-ISAv3.0 hash
+			 * already attempted to handle this in rmhandlers. The
+			 * hash fault handling below is v3 only (it uses ASDR
+			 * via fault_gpa).
+			 */
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
+		if (!(vcpu->arch.shregs.msr & MSR_IR))
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

