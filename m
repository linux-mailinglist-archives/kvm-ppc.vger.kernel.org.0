Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C2024AD61
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Aug 2020 05:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHTDjj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 19 Aug 2020 23:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHTDji (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 19 Aug 2020 23:39:38 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98DFC061383
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Aug 2020 20:39:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o5so517755pgb.2
        for <kvm-ppc@vger.kernel.org>; Wed, 19 Aug 2020 20:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fp5cogFleKYt2kfkyZQa3LqTJg0rC3b/rXFp/F6KVBg=;
        b=SmzpctziEWIRKv42lPAnL4O6Fay8ngZwLeXKtpOLTVjDi44OPAHVcfVYxcdUQ8P+O0
         gN8bGRRKzTXm515QkT+BbRxfRw9w4gp6xjolwcCRQETzCMxY6pPdKZ+BzS4lCPRjG4W1
         2g48Bz+3eCyjedXffCB5ooixDlJXPdexwwNtAK0FpA07z60x2KPzQ/CQ1rFxovmeVDdD
         AhvtYV2EBnd89NyEL2CTO1xGoZhla57Sx7rdyU2Fy1R0cLTG4IARTnxQKZq9vrids8us
         Ewm+lfiwM7wXu8lzqJpV5k0PyKijLE36ubBG0gk3GhRCu7Qq8eZCAVOajmzRWljUY5wV
         bNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fp5cogFleKYt2kfkyZQa3LqTJg0rC3b/rXFp/F6KVBg=;
        b=ZMxo+F5OH9Zt61NmQ+40GWsbiF4rrxYMG+4QTeFoDvSAji4Xf88fx6dLVTHT5OSd+p
         lDrVAqaltGINMoQqk+3UBg+BS8jeDr48GvpAlvztznzNvGbH8nsqUWX74f+m7XxS9A8V
         rUz8+/ihbG6RnJALa338NktT517t5gKndtXRkkG15WIbSXm0StQFP8luYSnIRG71MU0N
         L1KObwebMFrHdoh2aMgXkDYVU19HnX/G3VS365aYpdaMsx8u3VKDMdCBsZJSi0y4ReK3
         XWQO/Jv+lLC5jFnl5SGzwA+WZOg5OcuL/Q2JUjFBDWEpUfH3XtDIQt3tMNOIslFclmdZ
         XxDg==
X-Gm-Message-State: AOAM533uXppzObwWEk55ByxUA5+BhGuhNhHwLDcqEmj+eTkQuxan08VJ
        ZiLFjBt/JkF8OB63ZRvoWr6USOIy8iA=
X-Google-Smtp-Source: ABdhPJzHm/RWYFEBJL85a8EFY9hiJaUq0hGJfVeFsyRE70Hy2cjLkCVoF5OM0qV4hMmKrhGkru6DvA==
X-Received: by 2002:a63:1b0b:: with SMTP id b11mr1134991pgb.447.1597894777529;
        Wed, 19 Aug 2020 20:39:37 -0700 (PDT)
Received: from localhost.localdomain (180-150-65-4.b49641.syd.nbn.aussiebb.net. [180.150.65.4])
        by smtp.gmail.com with ESMTPSA id lb1sm405205pjb.26.2020.08.19.20.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 20:39:37 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Jordan Niethe <jniethe5@gmail.com>
Subject: [RFC PATCH 2/2] KVM: PPC: Book3S HV: Support prefixed instructions
Date:   Thu, 20 Aug 2020 13:39:22 +1000
Message-Id: <20200820033922.32311-2-jniethe5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200820033922.32311-1-jniethe5@gmail.com>
References: <20200820033922.32311-1-jniethe5@gmail.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There are two main places where instructions are loaded from the guest:
    * Emulate loadstore - such as when performing MMIO emulation
      triggered by an HDSI
    * After an HV emulation assistance interrupt (e40)

If it is a prefixed instruction that triggers these cases, its suffix
must be loaded. Use the SRR1_PREFIX bit to decide if a suffix needs to
be loaded. Make sure if this bit is set inject_interrupt() also sets it
when giving an interrupt to the guest.

ISA v3.10 extends the Hypervisor Emulation Instruction Register (HEIR)
to 64 bits long to accommodate prefixed instructions. For interrupts
caused by a word instruction the instruction is loaded into bits 32:63
and bits 0:31 are zeroed. When caused by a prefixed instruction the
prefix and suffix are loaded into bits 0:63.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s.c               | 15 +++++++++++++--
 arch/powerpc/kvm/book3s_64_mmu_hv.c     | 10 +++++++---
 arch/powerpc/kvm/book3s_hv_builtin.c    |  3 +++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 14 ++++++++++++++
 4 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 70d8967acc9b..18b1928a571b 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -456,13 +456,24 @@ int kvmppc_load_last_inst(struct kvm_vcpu *vcpu,
 {
 	ulong pc = kvmppc_get_pc(vcpu);
 	u32 word;
+	u64 doubleword;
 	int r;
 
 	if (type == INST_SC)
 		pc -= 4;
 
-	r = kvmppc_ld(vcpu, &pc, sizeof(u32), &word, false);
-	*inst = ppc_inst(word);
+	if ((kvmppc_get_msr(vcpu) & SRR1_PREFIXED)) {
+		r = kvmppc_ld(vcpu, &pc, sizeof(u64), &doubleword, false);
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+		*inst = ppc_inst_prefix(doubleword & 0xffffffff, doubleword >> 32);
+#else
+		*inst = ppc_inst_prefix(doubleword >> 32, doubleword & 0xffffffff);
+#endif
+	} else {
+		r = kvmppc_ld(vcpu, &pc, sizeof(u32), &word, false);
+		*inst = ppc_inst(word);
+	}
+
 	if (r == EMULATE_DONE)
 		return r;
 	else
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 775ce41738ce..0802471f4856 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -411,9 +411,13 @@ static int instruction_is_store(struct ppc_inst instr)
 	unsigned int mask;
 
 	mask = 0x10000000;
-	if ((ppc_inst_val(instr) & 0xfc000000) == 0x7c000000)
-		mask = 0x100;		/* major opcode 31 */
-	return (ppc_inst_val(instr) & mask) != 0;
+	if (ppc_inst_prefixed(instr)) {
+		return (ppc_inst_suffix(instr) & mask) != 0;
+	} else {
+		if ((ppc_inst_val(instr) & 0xfc000000) == 0x7c000000)
+			mask = 0x100;		/* major opcode 31 */
+		return (ppc_inst_val(instr) & mask) != 0;
+	}
 }
 
 int kvmppc_hv_emulate_mmio(struct kvm_vcpu *vcpu,
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 073617ce83e0..41e07e63104b 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -807,6 +807,9 @@ static void inject_interrupt(struct kvm_vcpu *vcpu, int vec, u64 srr1_flags)
 		new_pc += 0xC000000000004000ULL;
 	}
 
+	if (msr & SRR1_PREFIXED)
+		srr1_flags |= SRR1_PREFIXED;
+
 	kvmppc_set_srr0(vcpu, pc);
 	kvmppc_set_srr1(vcpu, (msr & SRR1_MSR_BITS) | srr1_flags);
 	kvmppc_set_pc(vcpu, new_pc);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 4853b3444c5f..f2a609413621 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1365,6 +1365,16 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	cmpwi	r12,BOOK3S_INTERRUPT_H_EMUL_ASSIST
 	bne	11f
 	mfspr	r3,SPRN_HEIR
+	andis.  r0,r11,SRR1_PREFIXED@h
+	cmpwi   r0,0
+	beq	12f
+	rldicl	r4,r3,0,32	/* Suffix */
+	srdi	r3,r3,32	/* Prefix */
+	b	11f
+12:
+BEGIN_FTR_SECTION
+	rldicl	r3,r3,0,32	/* Word */
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_31)
 11:	stw	r3,VCPU_HEIR(r9)
 	stw	r4,VCPU_HEIR+4(r9)
 
@@ -2175,6 +2185,10 @@ fast_interrupt_c_return:
 	ori	r4, r3, MSR_DR		/* Enable paging for data */
 	mtmsrd	r4
 	lwz	r8, 0(r10)
+	andis.  r7, r11, SRR1_PREFIXED@h
+	cmpwi   r7,0
+	beq	+4
+	lwz	r5, 4(r10)
 	mtmsrd	r3
 
 	/* Store the result */
-- 
2.17.1

