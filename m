Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B317732EDEF
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCEPJT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhCEPI6 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FA0C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o6so2194073pjf.5
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GYzq1ayK9w1BxArP5pBVclo32cuyuXTwcie8/PZ7+DA=;
        b=X3F+oxp64GFwCOgm3DKNRGP51VTwWNA4/YLdQonI0ivEAJ8xJSGaRk0H2a/yjs9TJs
         BT0s0ytT03AQov+iEcuToWlpWUZzoOnxUQ5GI6WIglEczLWQOGIOdn+5OUcvrEiNr1vm
         JsX0NdUvfnZgAsbrZdFOHCn5eMVu1LnuFVqs+07cVLN+lUuTjDJlS9OZU2t3QIyw4yd7
         YEkRxXcbI8RX8cPr7rzVfVo1iI6A1vbXnwiwTjkEmNlWt6sN+102XIiT498Hmrr0YtaB
         8Cx5wuHlCw6er4aCOnmqc/+67yWion/2z2eSadSdGqiBHwx0wHufLN5C6it2cVzOicH1
         VJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GYzq1ayK9w1BxArP5pBVclo32cuyuXTwcie8/PZ7+DA=;
        b=SSTn3UPJaM/L+pL1DhknimSTQSHTWCzKAl5ATgqSZn247Nz2Pj18iyBSIhoXSuU4V7
         KAQ+kyxTECo6gYbddqcy0xB2b8fhf35nWK2EBp9k2E4jWPTaPxIeqgUxYGfFEHbW6J2B
         hzQO4rx9fCJNhoy07HOE/XqYkHNMe6zSG1AB2v47QmCE3hlMNXHG4pa8QUkj96eXXTN8
         IlkJZ2wDA2QWjQm2/J1J0xmYnH2orcbWzDHV7QsS0gadJnYB76xF/3ZJ/KGBSAgSQWKS
         DATiC6YhL87DuuCSLVBRJtnAQJ7yQWazwoy4X0iSU2vYK18CTQ/qoCt3aUMsGyW7Sfrf
         /jFg==
X-Gm-Message-State: AOAM533fqUiFQRyPYmDj8wLe//dceAvs5lCsbTgg0rQXNU5HQTOwpbed
        G4RRlZpkiEJgq75fa1YFXfv3cBKhDvs=
X-Google-Smtp-Source: ABdhPJwvKCdOCSPAKLMeYjv7FCUlxNEtUBoUOubghv2ALpyh+qcFy+0RjgLUlBCl8uqZKDuKKifw9Q==
X-Received: by 2002:a17:902:8204:b029:e3:b425:762e with SMTP id x4-20020a1709028204b02900e3b425762emr9217074pln.13.1614956937054;
        Fri, 05 Mar 2021 07:08:57 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:56 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 35/41] KVM: PPC: Book3S HV: Remove radix guest support from P7/8 path
Date:   Sat,  6 Mar 2021 01:06:32 +1000
Message-Id: <20210305150638.2675513-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The P9 path now runs all supported radix guest combinations, so
remove radix guest support from the P7/8 path.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 65 ++-----------------------
 1 file changed, 3 insertions(+), 62 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 61f71a7df238..a8ce68eed13e 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -899,11 +899,6 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	cmpdi	r3, 512		/* 1 microsecond */
 	blt	hdec_soon
 
-	ld	r6, VCPU_KVM(r4)
-	lbz	r0, KVM_RADIX(r6)
-	cmpwi	r0, 0
-	bne	9f
-
 	/* For hash guest, clear out and reload the SLB */
 BEGIN_MMU_FTR_SECTION
 	/* Radix host won't have populated the SLB, so no need to clear */
@@ -1389,11 +1384,7 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	patch_site 1b patch__call_kvm_flush_link_stack
 
 	/* For hash guest, read the guest SLB and save it away */
-	ld	r5, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r5)
 	li	r5, 0
-	cmpwi	r0, 0
-	bne	0f			/* for radix, save 0 entries */
 	lwz	r0,VCPU_SLB_NR(r9)	/* number of entries in SLB */
 	mtctr	r0
 	li	r6,0
@@ -1432,23 +1423,6 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 	slbmte	r6,r5
 1:	addi	r8,r8,16
 	.endr
-	b	guest_bypass
-
-0:	/*
-	 * Malicious or buggy radix guests may have inserted SLB entries
-	 * (only 0..3 because radix always runs with UPRT=1), so these must
-	 * be cleared here to avoid side-channels. slbmte is used rather
-	 * than slbia, as it won't clear cached translations.
-	 */
-	li	r0,0
-	stw	r0,VCPU_SLB_MAX(r9)
-	slbmte	r0,r0
-	li	r4,1
-	slbmte	r0,r4
-	li	r4,2
-	slbmte	r0,r4
-	li	r4,3
-	slbmte	r0,r4
 
 guest_bypass:
 	stw	r12, STACK_SLOT_TRAP(r1)
@@ -1694,24 +1668,6 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_PID, r7
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 
-#ifdef CONFIG_PPC_RADIX_MMU
-	/*
-	 * Are we running hash or radix ?
-	 */
-	ld	r5, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r5)
-	cmpwi	cr2, r0, 0
-	beq	cr2, 2f
-
-	/*
-	 * Radix: do eieio; tlbsync; ptesync sequence in case we
-	 * interrupted the guest between a tlbie and a ptesync.
-	 */
-	eieio
-	tlbsync
-	ptesync
-#endif /* CONFIG_PPC_RADIX_MMU */
-
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
 	 * to clear the copy buffer that was under control of the guest.
@@ -1970,8 +1926,6 @@ kvmppc_tm_emul:
  * reflect the HDSI to the guest as a DSI.
  */
 kvmppc_hdsi:
-	ld	r3, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r3)
 	mfspr	r4, SPRN_HDAR
 	mfspr	r6, SPRN_HDSISR
 BEGIN_FTR_SECTION
@@ -1979,8 +1933,6 @@ BEGIN_FTR_SECTION
 	cmpdi	r6, 0x7fff
 	beq	6f
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
-	cmpwi	r0, 0
-	bne	.Lradix_hdsi		/* on radix, just save DAR/DSISR/ASDR */
 	/* HPTE not found fault or protection fault? */
 	andis.	r0, r6, (DSISR_NOHPTE | DSISR_PROTFAULT)@h
 	beq	1f			/* if not, send it to the guest */
@@ -2057,23 +2009,11 @@ fast_interrupt_c_return:
 	stb	r0, HSTATE_IN_GUEST(r13)
 	b	guest_exit_cont
 
-.Lradix_hdsi:
-	std	r4, VCPU_FAULT_DAR(r9)
-	stw	r6, VCPU_FAULT_DSISR(r9)
-.Lradix_hisi:
-	mfspr	r5, SPRN_ASDR
-	std	r5, VCPU_FAULT_GPA(r9)
-	b	guest_exit_cont
-
 /*
  * Similarly for an HISI, reflect it to the guest as an ISI unless
  * it is an HPTE not found fault for a page that we have paged out.
  */
 kvmppc_hisi:
-	ld	r3, VCPU_KVM(r9)
-	lbz	r0, KVM_RADIX(r3)
-	cmpwi	r0, 0
-	bne	.Lradix_hisi		/* for radix, just save ASDR */
 	andis.	r0, r11, SRR1_ISI_NOPT@h
 	beq	1f
 	andi.	r0, r11, MSR_IR		/* instruction relocation enabled? */
@@ -3217,15 +3157,16 @@ BEGIN_FTR_SECTION
 	mtspr	SPRN_DAWRX1, r0
 END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 
-	/* Clear hash and radix guest SLB. */
+	/* Clear guest SLB. */
 	slbmte	r0, r0
 	PPC_SLBIA(6)
+	ptesync
 
 BEGIN_MMU_FTR_SECTION
 	b	4f
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_TYPE_RADIX)
 
-	ptesync
+	/* load host SLB entries */
 	ld	r8, PACA_SLBSHADOWPTR(r13)
 	.rept	SLB_NUM_BOLTED
 	li	r3, SLBSHADOW_SAVEAREA
-- 
2.23.0

