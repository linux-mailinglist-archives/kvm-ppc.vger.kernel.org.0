Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2986B7929A3
	for <lists+kvm-ppc@lfdr.de>; Tue,  5 Sep 2023 18:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbjIEQXG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 5 Sep 2023 12:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344561AbjIEDsL (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Sep 2023 23:48:11 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12EBCC7;
        Mon,  4 Sep 2023 20:48:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso907786a12.1;
        Mon, 04 Sep 2023 20:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693885686; x=1694490486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3DhPj1sFxIg6NbbDXpm0bwylwTPhPNoOlTSUEy3pC8=;
        b=T1s98aauj/Qhf4GAooVjaZdVm1oYNYDNOYp6lnDoZWwKltZJqk08QpWGF1fqd8OO5u
         UPADc/wITwqZqk7PciEOMrbNLGKF57zIA9HzFaoM1rMTBIjK+9G801ui63HOwWI4bYDy
         5CQCFrxzG66C2lEMlUYchzIRJtMkDGEgh4b2xAtqjIG5kSZf3RGs6I7SOLM39EOAl6z1
         t8dj2lpS4nM1gchMLoc5raFvBmFWOrrGBkGFD1D3qxQeF6gOphtYsQP4rs1hkWWC/MAR
         fWxRYp4jNmsEK0zzaunKs618Tk8qZ44n70hpaIzW0qadsSW6ISCeL5bO3lY60K7RqCvd
         UvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693885686; x=1694490486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3DhPj1sFxIg6NbbDXpm0bwylwTPhPNoOlTSUEy3pC8=;
        b=c/YPcSciPF0uXdTs55R5x7u/SrMjpPNSpN2hvXvthq3lK4uhJrsq/cOUD95Bf0D01X
         YfaNFyKCr4PQe3kZOhM/JLOb7418ncszwMk6NhO9nLV3L1+2DJQ7PnjOP2fHdTp0xx4v
         cNVeOrOvvWcMiziO+Ke80N6QZyCC5DzXUzywef3SCVlVE7dBobheFyJCc2D8moWg/zqG
         MRkcYeVVCsnLl10RX+4Ea236P05/ddCcTL2dYv+ieVwTtIC78c1pJwZioKYxH1bjB8h0
         weHMqt9rvBxQrb+5WslfjU4vTB5J7Geqgr+A7MZqB2UV9ixmwV2ZDtJ0Ir0rlbqcGtth
         OVsQ==
X-Gm-Message-State: AOJu0Yz3diio40tYZHK1vKRLIC3Cua+xq+YOs3VA3+4iZYZcADTEUxBy
        9LAqzqOwRit5K23IpHbXGtI=
X-Google-Smtp-Source: AGHT+IGUFatYNwaRO3ez44WO/2nkEUnvvOnpqWnVcGMxccQ+0jNB627Q7+b6tUsO0J3eg+45ziGb5A==
X-Received: by 2002:a05:6a20:8f20:b0:134:d4d3:f0a8 with SMTP id b32-20020a056a208f2000b00134d4d3f0a8mr11328919pzk.3.1693885686236;
        Mon, 04 Sep 2023 20:48:06 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([129.41.57.2])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78097000000b0063f0068cf6csm7994951pff.198.2023.09.04.20.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 20:48:05 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v4 06/11] KVM: PPC: Book3S HV: Use accessors for VCPU registers
Date:   Tue,  5 Sep 2023 13:46:53 +1000
Message-Id: <20230905034658.82835-7-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230905034658.82835-1-jniethe5@gmail.com>
References: <20230905034658.82835-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Introduce accessor generator macros for Book3S HV VCPU registers. Use
the accessor functions to replace direct accesses to this registers.

This will be important later for Nested APIv2 support which requires
additional functionality for accessing and modifying VCPU state.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v4:
  - Split to unique patch
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c |   5 +-
 arch/powerpc/kvm/book3s_hv.c           | 148 +++++++++++++------------
 arch/powerpc/kvm/book3s_hv.h           |  58 ++++++++++
 3 files changed, 139 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 5c71d6ae3a7b..ab646f59afd7 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -15,6 +15,7 @@
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
+#include "book3s_hv.h"
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
@@ -294,9 +295,9 @@ int kvmppc_mmu_radix_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	} else {
 		if (!(pte & _PAGE_PRIVILEGED)) {
 			/* Check AMR/IAMR to see if strict mode is in force */
-			if (vcpu->arch.amr & (1ul << 62))
+			if (kvmppc_get_amr_hv(vcpu) & (1ul << 62))
 				gpte->may_read = 0;
-			if (vcpu->arch.amr & (1ul << 63))
+			if (kvmppc_get_amr_hv(vcpu) & (1ul << 63))
 				gpte->may_write = 0;
 			if (vcpu->arch.iamr & (1ul << 62))
 				gpte->may_execute = 0;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 73d9a9eb376f..fabe99af0e0b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -868,7 +868,7 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		/* Guests can't breakpoint the hypervisor */
 		if ((value1 & CIABR_PRIV) == CIABR_PRIV_HYPER)
 			return H_P3;
-		vcpu->arch.ciabr  = value1;
+		kvmppc_set_ciabr_hv(vcpu, value1);
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_SET_DAWR0:
 		if (!kvmppc_power8_compatible(vcpu))
@@ -879,8 +879,8 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 			return H_UNSUPPORTED_FLAG_START;
 		if (value2 & DABRX_HYP)
 			return H_P4;
-		vcpu->arch.dawr0  = value1;
-		vcpu->arch.dawrx0 = value2;
+		kvmppc_set_dawr0_hv(vcpu, value1);
+		kvmppc_set_dawrx0_hv(vcpu, value2);
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_SET_DAWR1:
 		if (!kvmppc_power8_compatible(vcpu))
@@ -895,8 +895,8 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 			return H_UNSUPPORTED_FLAG_START;
 		if (value2 & DABRX_HYP)
 			return H_P4;
-		vcpu->arch.dawr1  = value1;
-		vcpu->arch.dawrx1 = value2;
+		kvmppc_set_dawr1_hv(vcpu, value1);
+		kvmppc_set_dawrx1_hv(vcpu, value2);
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
 		/*
@@ -1548,7 +1548,7 @@ static int kvmppc_pmu_unavailable(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.hfscr_permitted & HFSCR_PM))
 		return EMULATE_FAIL;
 
-	vcpu->arch.hfscr |= HFSCR_PM;
+	kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) | HFSCR_PM);
 
 	return RESUME_GUEST;
 }
@@ -1558,7 +1558,7 @@ static int kvmppc_ebb_unavailable(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.hfscr_permitted & HFSCR_EBB))
 		return EMULATE_FAIL;
 
-	vcpu->arch.hfscr |= HFSCR_EBB;
+	kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) | HFSCR_EBB);
 
 	return RESUME_GUEST;
 }
@@ -1568,7 +1568,7 @@ static int kvmppc_tm_unavailable(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.hfscr_permitted & HFSCR_TM))
 		return EMULATE_FAIL;
 
-	vcpu->arch.hfscr |= HFSCR_TM;
+	kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) | HFSCR_TM);
 
 	return RESUME_GUEST;
 }
@@ -1867,7 +1867,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	 * Otherwise, we just generate a program interrupt to the guest.
 	 */
 	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
-		u64 cause = vcpu->arch.hfscr >> 56;
+		u64 cause = kvmppc_get_hfscr_hv(vcpu) >> 56;
 
 		r = EMULATE_FAIL;
 		if (cpu_has_feature(CPU_FTR_ARCH_300)) {
@@ -2211,64 +2211,64 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.dabrx);
 		break;
 	case KVM_REG_PPC_DSCR:
-		*val = get_reg_val(id, vcpu->arch.dscr);
+		*val = get_reg_val(id, kvmppc_get_dscr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_PURR:
-		*val = get_reg_val(id, vcpu->arch.purr);
+		*val = get_reg_val(id, kvmppc_get_purr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SPURR:
-		*val = get_reg_val(id, vcpu->arch.spurr);
+		*val = get_reg_val(id, kvmppc_get_spurr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_AMR:
-		*val = get_reg_val(id, vcpu->arch.amr);
+		*val = get_reg_val(id, kvmppc_get_amr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_UAMOR:
-		*val = get_reg_val(id, vcpu->arch.uamor);
+		*val = get_reg_val(id, kvmppc_get_uamor_hv(vcpu));
 		break;
 	case KVM_REG_PPC_MMCR0 ... KVM_REG_PPC_MMCR1:
 		i = id - KVM_REG_PPC_MMCR0;
-		*val = get_reg_val(id, vcpu->arch.mmcr[i]);
+		*val = get_reg_val(id, kvmppc_get_mmcr_hv(vcpu, i));
 		break;
 	case KVM_REG_PPC_MMCR2:
-		*val = get_reg_val(id, vcpu->arch.mmcr[2]);
+		*val = get_reg_val(id, kvmppc_get_mmcr_hv(vcpu, 2));
 		break;
 	case KVM_REG_PPC_MMCRA:
-		*val = get_reg_val(id, vcpu->arch.mmcra);
+		*val = get_reg_val(id, kvmppc_get_mmcra_hv(vcpu));
 		break;
 	case KVM_REG_PPC_MMCRS:
 		*val = get_reg_val(id, vcpu->arch.mmcrs);
 		break;
 	case KVM_REG_PPC_MMCR3:
-		*val = get_reg_val(id, vcpu->arch.mmcr[3]);
+		*val = get_reg_val(id, kvmppc_get_mmcr_hv(vcpu, 3));
 		break;
 	case KVM_REG_PPC_PMC1 ... KVM_REG_PPC_PMC8:
 		i = id - KVM_REG_PPC_PMC1;
-		*val = get_reg_val(id, vcpu->arch.pmc[i]);
+		*val = get_reg_val(id, kvmppc_get_pmc_hv(vcpu, i));
 		break;
 	case KVM_REG_PPC_SPMC1 ... KVM_REG_PPC_SPMC2:
 		i = id - KVM_REG_PPC_SPMC1;
 		*val = get_reg_val(id, vcpu->arch.spmc[i]);
 		break;
 	case KVM_REG_PPC_SIAR:
-		*val = get_reg_val(id, vcpu->arch.siar);
+		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SDAR:
-		*val = get_reg_val(id, vcpu->arch.sdar);
+		*val = get_reg_val(id, kvmppc_get_siar_hv(vcpu));
 		break;
 	case KVM_REG_PPC_SIER:
-		*val = get_reg_val(id, vcpu->arch.sier[0]);
+		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 0));
 		break;
 	case KVM_REG_PPC_SIER2:
-		*val = get_reg_val(id, vcpu->arch.sier[1]);
+		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 1));
 		break;
 	case KVM_REG_PPC_SIER3:
-		*val = get_reg_val(id, vcpu->arch.sier[2]);
+		*val = get_reg_val(id, kvmppc_get_sier_hv(vcpu, 2));
 		break;
 	case KVM_REG_PPC_IAMR:
-		*val = get_reg_val(id, vcpu->arch.iamr);
+		*val = get_reg_val(id, kvmppc_get_iamr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_PSPB:
-		*val = get_reg_val(id, vcpu->arch.pspb);
+		*val = get_reg_val(id, kvmppc_get_pspb_hv(vcpu));
 		break;
 	case KVM_REG_PPC_DPDES:
 		/*
@@ -2286,19 +2286,19 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, kvmppc_get_vtb(vcpu));
 		break;
 	case KVM_REG_PPC_DAWR:
-		*val = get_reg_val(id, vcpu->arch.dawr0);
+		*val = get_reg_val(id, kvmppc_get_dawr0_hv(vcpu));
 		break;
 	case KVM_REG_PPC_DAWRX:
-		*val = get_reg_val(id, vcpu->arch.dawrx0);
+		*val = get_reg_val(id, kvmppc_get_dawrx0_hv(vcpu));
 		break;
 	case KVM_REG_PPC_DAWR1:
-		*val = get_reg_val(id, vcpu->arch.dawr1);
+		*val = get_reg_val(id, kvmppc_get_dawr1_hv(vcpu));
 		break;
 	case KVM_REG_PPC_DAWRX1:
-		*val = get_reg_val(id, vcpu->arch.dawrx1);
+		*val = get_reg_val(id, kvmppc_get_dawrx1_hv(vcpu));
 		break;
 	case KVM_REG_PPC_CIABR:
-		*val = get_reg_val(id, vcpu->arch.ciabr);
+		*val = get_reg_val(id, kvmppc_get_ciabr_hv(vcpu));
 		break;
 	case KVM_REG_PPC_CSIGR:
 		*val = get_reg_val(id, vcpu->arch.csigr);
@@ -2316,7 +2316,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.acop);
 		break;
 	case KVM_REG_PPC_WORT:
-		*val = get_reg_val(id, vcpu->arch.wort);
+		*val = get_reg_val(id, kvmppc_get_wort_hv(vcpu));
 		break;
 	case KVM_REG_PPC_TIDR:
 		*val = get_reg_val(id, vcpu->arch.tid);
@@ -2349,7 +2349,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, kvmppc_get_lpcr(vcpu));
 		break;
 	case KVM_REG_PPC_PPR:
-		*val = get_reg_val(id, vcpu->arch.ppr);
+		*val = get_reg_val(id, kvmppc_get_ppr_hv(vcpu));
 		break;
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	case KVM_REG_PPC_TFHAR:
@@ -2429,6 +2429,9 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_PTCR:
 		*val = get_reg_val(id, vcpu->kvm->arch.l1_ptcr);
 		break;
+	case KVM_REG_PPC_FSCR:
+		*val = get_reg_val(id, kvmppc_get_fscr_hv(vcpu));
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -2457,29 +2460,29 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.dabrx = set_reg_val(id, *val) & ~DABRX_HYP;
 		break;
 	case KVM_REG_PPC_DSCR:
-		vcpu->arch.dscr = set_reg_val(id, *val);
+		kvmppc_set_dscr_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_PURR:
-		vcpu->arch.purr = set_reg_val(id, *val);
+		kvmppc_set_purr_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SPURR:
-		vcpu->arch.spurr = set_reg_val(id, *val);
+		kvmppc_set_spurr_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_AMR:
-		vcpu->arch.amr = set_reg_val(id, *val);
+		kvmppc_set_amr_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_UAMOR:
-		vcpu->arch.uamor = set_reg_val(id, *val);
+		kvmppc_set_uamor_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_MMCR0 ... KVM_REG_PPC_MMCR1:
 		i = id - KVM_REG_PPC_MMCR0;
-		vcpu->arch.mmcr[i] = set_reg_val(id, *val);
+		kvmppc_set_mmcr_hv(vcpu, i, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_MMCR2:
-		vcpu->arch.mmcr[2] = set_reg_val(id, *val);
+		kvmppc_set_mmcr_hv(vcpu, 2, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_MMCRA:
-		vcpu->arch.mmcra = set_reg_val(id, *val);
+		kvmppc_set_mmcra_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_MMCRS:
 		vcpu->arch.mmcrs = set_reg_val(id, *val);
@@ -2489,32 +2492,32 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		break;
 	case KVM_REG_PPC_PMC1 ... KVM_REG_PPC_PMC8:
 		i = id - KVM_REG_PPC_PMC1;
-		vcpu->arch.pmc[i] = set_reg_val(id, *val);
+		kvmppc_set_pmc_hv(vcpu, i, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SPMC1 ... KVM_REG_PPC_SPMC2:
 		i = id - KVM_REG_PPC_SPMC1;
 		vcpu->arch.spmc[i] = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_SIAR:
-		vcpu->arch.siar = set_reg_val(id, *val);
+		kvmppc_set_siar_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SDAR:
-		vcpu->arch.sdar = set_reg_val(id, *val);
+		kvmppc_set_sdar_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SIER:
-		vcpu->arch.sier[0] = set_reg_val(id, *val);
+		kvmppc_set_sier_hv(vcpu, 0, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SIER2:
-		vcpu->arch.sier[1] = set_reg_val(id, *val);
+		kvmppc_set_sier_hv(vcpu, 1, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_SIER3:
-		vcpu->arch.sier[2] = set_reg_val(id, *val);
+		kvmppc_set_sier_hv(vcpu, 2, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_IAMR:
-		vcpu->arch.iamr = set_reg_val(id, *val);
+		kvmppc_set_iamr_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_PSPB:
-		vcpu->arch.pspb = set_reg_val(id, *val);
+		kvmppc_set_pspb_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DPDES:
 		if (cpu_has_feature(CPU_FTR_ARCH_300))
@@ -2526,22 +2529,22 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		kvmppc_set_vtb(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DAWR:
-		vcpu->arch.dawr0 = set_reg_val(id, *val);
+		kvmppc_set_dawr0_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DAWRX:
-		vcpu->arch.dawrx0 = set_reg_val(id, *val) & ~DAWRX_HYP;
+		kvmppc_set_dawrx0_hv(vcpu, set_reg_val(id, *val) & ~DAWRX_HYP);
 		break;
 	case KVM_REG_PPC_DAWR1:
-		vcpu->arch.dawr1 = set_reg_val(id, *val);
+		kvmppc_set_dawr1_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DAWRX1:
-		vcpu->arch.dawrx1 = set_reg_val(id, *val) & ~DAWRX_HYP;
+		kvmppc_set_dawrx1_hv(vcpu, set_reg_val(id, *val) & ~DAWRX_HYP);
 		break;
 	case KVM_REG_PPC_CIABR:
-		vcpu->arch.ciabr = set_reg_val(id, *val);
+		kvmppc_set_ciabr_hv(vcpu, set_reg_val(id, *val));
 		/* Don't allow setting breakpoints in hypervisor code */
-		if ((vcpu->arch.ciabr & CIABR_PRIV) == CIABR_PRIV_HYPER)
-			vcpu->arch.ciabr &= ~CIABR_PRIV;	/* disable */
+		if ((kvmppc_get_ciabr_hv(vcpu) & CIABR_PRIV) == CIABR_PRIV_HYPER)
+			kvmppc_set_ciabr_hv(vcpu, kvmppc_get_ciabr_hv(vcpu) & ~CIABR_PRIV);	/* disable */
 		break;
 	case KVM_REG_PPC_CSIGR:
 		vcpu->arch.csigr = set_reg_val(id, *val);
@@ -2559,7 +2562,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.acop = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_WORT:
-		vcpu->arch.wort = set_reg_val(id, *val);
+		kvmppc_set_wort_hv(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_TIDR:
 		vcpu->arch.tid = set_reg_val(id, *val);
@@ -2620,7 +2623,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		kvmppc_set_lpcr(vcpu, set_reg_val(id, *val), false);
 		break;
 	case KVM_REG_PPC_PPR:
-		vcpu->arch.ppr = set_reg_val(id, *val);
+		kvmppc_set_ppr_hv(vcpu, set_reg_val(id, *val));
 		break;
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	case KVM_REG_PPC_TFHAR:
@@ -2704,6 +2707,9 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 	case KVM_REG_PPC_PTCR:
 		vcpu->kvm->arch.l1_ptcr = set_reg_val(id, *val);
 		break;
+	case KVM_REG_PPC_FSCR:
+		kvmppc_set_fscr_hv(vcpu, set_reg_val(id, *val));
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -2921,13 +2927,14 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	vcpu->arch.shared_big_endian = false;
 #endif
 #endif
-	vcpu->arch.mmcr[0] = MMCR0_FC;
+	kvmppc_set_mmcr_hv(vcpu, 0, MMCR0_FC);
+
 	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
-		vcpu->arch.mmcr[0] |= MMCR0_PMCCEXT;
-		vcpu->arch.mmcra = MMCRA_BHRB_DISABLE;
+		kvmppc_set_mmcr_hv(vcpu, 0, kvmppc_get_mmcr_hv(vcpu, 0) | MMCR0_PMCCEXT);
+		kvmppc_set_mmcra_hv(vcpu, MMCRA_BHRB_DISABLE);
 	}
 
-	vcpu->arch.ctrl = CTRL_RUNLATCH;
+	kvmppc_set_ctrl_hv(vcpu, CTRL_RUNLATCH);
 	/* default to host PVR, since we can't spoof it */
 	kvmppc_set_pvr_hv(vcpu, mfspr(SPRN_PVR));
 	spin_lock_init(&vcpu->arch.vpa_update_lock);
@@ -2943,29 +2950,30 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	 * don't set the HFSCR_MSGP bit, and that causes those instructions
 	 * to trap and then we emulate them.
 	 */
-	vcpu->arch.hfscr = HFSCR_TAR | HFSCR_EBB | HFSCR_PM | HFSCR_BHRB |
-		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP;
+	kvmppc_set_hfscr_hv(vcpu, HFSCR_TAR | HFSCR_EBB | HFSCR_PM | HFSCR_BHRB |
+			    HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP);
 
 	/* On POWER10 and later, allow prefixed instructions */
 	if (cpu_has_feature(CPU_FTR_ARCH_31))
-		vcpu->arch.hfscr |= HFSCR_PREFIX;
+		kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) | HFSCR_PREFIX);
 
 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
-		vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
+		kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) & mfspr(SPRN_HFSCR));
+
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 		if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-			vcpu->arch.hfscr |= HFSCR_TM;
+			kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) | HFSCR_TM);
 #endif
 	}
 	if (cpu_has_feature(CPU_FTR_TM_COMP))
 		vcpu->arch.hfscr |= HFSCR_TM;
 
-	vcpu->arch.hfscr_permitted = vcpu->arch.hfscr;
+	vcpu->arch.hfscr_permitted = kvmppc_get_hfscr_hv(vcpu);
 
 	/*
 	 * PM, EBB, TM are demand-faulted so start with it clear.
 	 */
-	vcpu->arch.hfscr &= ~(HFSCR_PM | HFSCR_EBB | HFSCR_TM);
+	kvmppc_set_hfscr_hv(vcpu, kvmppc_get_hfscr_hv(vcpu) & ~(HFSCR_PM | HFSCR_EBB | HFSCR_TM));
 
 	kvmppc_mmu_book3s_hv_init(vcpu);
 
@@ -4848,7 +4856,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		msr |= MSR_VSX;
 	if ((cpu_has_feature(CPU_FTR_TM) ||
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST)) &&
-			(vcpu->arch.hfscr & HFSCR_TM))
+			(kvmppc_get_hfscr_hv(vcpu) & HFSCR_TM))
 		msr |= MSR_TM;
 	msr = msr_check_and_set(msr);
 
diff --git a/arch/powerpc/kvm/book3s_hv.h b/arch/powerpc/kvm/book3s_hv.h
index 2f2e59d7d433..acd9a7a95bbf 100644
--- a/arch/powerpc/kvm/book3s_hv.h
+++ b/arch/powerpc/kvm/book3s_hv.h
@@ -50,3 +50,61 @@ void accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next);
 #define start_timing(vcpu, next) do {} while (0)
 #define end_timing(vcpu) do {} while (0)
 #endif
+
+#define KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_SET(reg, size)			\
+static inline void kvmppc_set_##reg ##_hv(struct kvm_vcpu *vcpu, u##size val)	\
+{									\
+	vcpu->arch.reg = val;						\
+}
+
+#define KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_GET(reg, size)			\
+static inline u##size kvmppc_get_##reg ##_hv(struct kvm_vcpu *vcpu)	\
+{									\
+	return vcpu->arch.reg;						\
+}
+
+#define KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(reg, size)			\
+	KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_SET(reg, size)			\
+	KVMPPC_BOOK3S_HV_VCPU_ACCESSOR_GET(reg, size)			\
+
+#define KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR_SET(reg, size)		\
+static inline void kvmppc_set_##reg ##_hv(struct kvm_vcpu *vcpu, int i, u##size val)	\
+{									\
+	vcpu->arch.reg[i] = val;					\
+}
+
+#define KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR_GET(reg, size)		\
+static inline u##size kvmppc_get_##reg ##_hv(struct kvm_vcpu *vcpu, int i)	\
+{									\
+	return vcpu->arch.reg[i];					\
+}
+
+#define KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR(reg, size)			\
+	KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR_SET(reg, size)		\
+	KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR_GET(reg, size)		\
+
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(mmcra, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(hfscr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(fscr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dscr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(purr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(spurr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(amr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(uamor, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(siar, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(sdar, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(iamr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr0, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawr1, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx0, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(dawrx1, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ciabr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(wort, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ppr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(ctrl, 64)
+
+KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR(mmcr, 64)
+KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR(sier, 64)
+KVMPPC_BOOK3S_HV_VCPU_ARRAY_ACCESSOR(pmc, 32)
+
+KVMPPC_BOOK3S_HV_VCPU_ACCESSOR(pspb, 32)
-- 
2.39.3

