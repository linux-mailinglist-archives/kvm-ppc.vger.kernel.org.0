Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75331F522
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBSGhS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSGhR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501BFC061797
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:17 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e9so3564064pjj.0
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OdlfHYZUWQmMCI4VrZDC5WGcjjApRdnh2LEJphLKTG8=;
        b=XSuyKNYJezb3OehGlt+RjBtPU38jzrVnBz8uXd3lMh/PL+/2cWoWc5K+Q+xMxNRFE9
         dPJTlhosPoXOpAkTWwnIaMIv9qyCwJpO1wJd50O586xP4KZmZMl4VAZe8G7L1rRUovfR
         5nTwDYJ5J2cPoLDwOz4hO4eMqvKOtjG5GN7kxv1E3rmZN7kk3yDa8t3r+fXjvhXVDlvw
         vp1SmBFQDmPb91VqUUGkrC2lJ7PpKIakvtl42FlzD3BvYYwGdTKlndOmJX2NOTZc7yjU
         64LmFI3tj+EnG0NLznyeqqqTElKLUvJ1Pe8AJ8xV2PjO6F5wwNLW4jmz9QhQU4EpkgoN
         acAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OdlfHYZUWQmMCI4VrZDC5WGcjjApRdnh2LEJphLKTG8=;
        b=P0wqYx5Ko+fFW0MkPO+4KDmP768/BEoroSOBtN7omWO5emFp2UEvKDbqbeWXsBB3qq
         /21YXImC4IhSns4p3hRvXLhpzsWKioj2LArqTB0FenSoZSvc1Jv07BCT3jKSJ6Ck7lQM
         X+u7qE3Q7jdxsrexTOEvmEsQFqkS7CwFDwdh7cDAF3a3kYZ/bypsIZDBe6JQnE1YWRRt
         2nTF6HVJT/iO5KHo/W+tdSaIhbVZQZWXaFiBfwD5v82LZofMKWEg4Kd7QQ5y87IMgV2x
         23QNVi8kcaNkkWym5DNaJeX/Aal+ZbhQSWKC3cT9jaJfZdu5HQ8ORy7najotIdy7chEP
         mHrA==
X-Gm-Message-State: AOAM532azlNLvBob+OOWeHyB80MzFuk82dqff1Ndw3uXi53/m6mlY4RB
        b5F1bNBNAwPQO+bIBhJR4MYND4J5YtI=
X-Google-Smtp-Source: ABdhPJw+l1Znj6Osv2LHEgmWboVfC+pOPDXmttOJ4J1GyGGmuhs1eA+FtyggC/fGCZUUilpMngcZ+w==
X-Received: by 2002:a17:902:e211:b029:e2:843c:426e with SMTP id u17-20020a170902e211b02900e2843c426emr7854726plb.16.1613716576267;
        Thu, 18 Feb 2021 22:36:16 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:15 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 09/13] KVM: PPC: Book3S HV: Move interrupt early register setup to KVM
Date:   Fri, 19 Feb 2021 16:35:38 +1000
Message-Id: <20210219063542.1425130-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Like the earlier patch for hcalls, KVM interrupt entry requires a
different calling convention than the Linux interrupt handlers
set up. Move the code that converts from one to the other into KVM.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 126 ++++-----------------------
 arch/powerpc/kvm/book3s_64_entry.S   |  34 +++++++-
 2 files changed, 50 insertions(+), 110 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 6872f0376003..4878f05b5325 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -191,7 +191,6 @@ do_define_int n
 	.endif
 .endm
 
-#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 /*
  * All interrupts which set HSRR registers, as well as SRESET and MCE and
  * syscall when invoked with "sc 1" switch to MSR[HV]=1 (HVMODE) to be taken,
@@ -224,54 +223,25 @@ do_define_int n
  * to KVM to handle.
  */
 
-.macro KVMTEST name
+.macro KVMTEST name handler
+#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
 	lbz	r10,HSTATE_IN_GUEST(r13)
 	cmpwi	r10,0
-	bne	\name\()_kvm
-.endm
-
-.macro GEN_KVM name
-	.balign IFETCH_ALIGN_BYTES
-\name\()_kvm:
-
-BEGIN_FTR_SECTION
-	ld	r10,IAREA+EX_CFAR(r13)
-	std	r10,HSTATE_CFAR(r13)
-END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
-
-	ld	r10,IAREA+EX_CTR(r13)
-	mtctr	r10
-BEGIN_FTR_SECTION
-	ld	r10,IAREA+EX_PPR(r13)
-	std	r10,HSTATE_PPR(r13)
-END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
-	ld	r11,IAREA+EX_R11(r13)
-	ld	r12,IAREA+EX_R12(r13)
-	std	r12,HSTATE_SCRATCH0(r13)
-	sldi	r12,r9,32
-	ld	r9,IAREA+EX_R9(r13)
-	ld	r10,IAREA+EX_R10(r13)
 	/* HSRR variants have the 0x2 bit added to their trap number */
 	.if IHSRR_IF_HVMODE
 	BEGIN_FTR_SECTION
-	ori	r12,r12,(IVEC + 0x2)
+	li	r10,(IVEC + 0x2)
 	FTR_SECTION_ELSE
-	ori	r12,r12,(IVEC)
+	li	r10,(IVEC)
 	ALT_FTR_SECTION_END_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
 	.elseif IHSRR
-	ori	r12,r12,(IVEC+ 0x2)
+	li	r10,(IVEC + 0x2)
 	.else
-	ori	r12,r12,(IVEC)
+	li	r10,(IVEC)
 	.endif
-	b	kvmppc_interrupt
-.endm
-
-#else
-.macro KVMTEST name
-.endm
-.macro GEN_KVM name
-.endm
+	bne	\handler
 #endif
+.endm
 
 /*
  * This is the BOOK3S interrupt entry code macro.
@@ -413,7 +383,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 DEFINE_FIXED_SYMBOL(\name\()_common_real)
 \name\()_common_real:
 	.if IKVM_REAL
-		KVMTEST \name
+		KVMTEST \name kvm_interrupt
 	.endif
 
 	ld	r10,PACAKMSR(r13)	/* get MSR value for kernel */
@@ -436,7 +406,7 @@ DEFINE_FIXED_SYMBOL(\name\()_common_real)
 DEFINE_FIXED_SYMBOL(\name\()_common_virt)
 \name\()_common_virt:
 	.if IKVM_VIRT
-		KVMTEST \name
+		KVMTEST \name kvm_interrupt
 1:
 	.endif
 	.endif /* IVIRT */
@@ -450,7 +420,7 @@ DEFINE_FIXED_SYMBOL(\name\()_common_virt)
 DEFINE_FIXED_SYMBOL(\name\()_common_real)
 \name\()_common_real:
 	.if IKVM_REAL
-		KVMTEST \name
+		KVMTEST \name kvm_interrupt
 	.endif
 .endm
 
@@ -1011,8 +981,6 @@ EXC_COMMON_BEGIN(system_reset_common)
 	EXCEPTION_RESTORE_REGS
 	RFI_TO_USER_OR_KERNEL
 
-	GEN_KVM system_reset
-
 
 /**
  * Interrupt 0x200 - Machine Check Interrupt (MCE).
@@ -1196,7 +1164,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
 	/*
 	 * Check if we are coming from guest. If yes, then run the normal
 	 * exception handler which will take the
-	 * machine_check_kvm->kvmppc_interrupt branch to deliver the MC event
+	 * machine_check_kvm->kvm_interrupt branch to deliver the MC event
 	 * to guest.
 	 */
 	lbz	r11,HSTATE_IN_GUEST(r13)
@@ -1267,8 +1235,6 @@ EXC_COMMON_BEGIN(machine_check_common)
 	bl	machine_check_exception
 	b	interrupt_return
 
-	GEN_KVM machine_check
-
 
 #ifdef CONFIG_PPC_P7_NAP
 /*
@@ -1393,8 +1359,6 @@ MMU_FTR_SECTION_ELSE
 	b	handle_page_fault
 ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 
-	GEN_KVM data_access
-
 
 /**
  * Interrupt 0x380 - Data Segment Interrupt (DSLB).
@@ -1449,8 +1413,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 	bl	do_bad_slb_fault
 	b	interrupt_return
 
-	GEN_KVM data_access_slb
-
 
 /**
  * Interrupt 0x400 - Instruction Storage Interrupt (ISI).
@@ -1489,8 +1451,6 @@ MMU_FTR_SECTION_ELSE
 	b	handle_page_fault
 ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 
-	GEN_KVM instruction_access
-
 
 /**
  * Interrupt 0x480 - Instruction Segment Interrupt (ISLB).
@@ -1540,8 +1500,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
 	bl	do_bad_slb_fault
 	b	interrupt_return
 
-	GEN_KVM instruction_access_slb
-
 
 /**
  * Interrupt 0x500 - External Interrupt.
@@ -1588,8 +1546,6 @@ EXC_COMMON_BEGIN(hardware_interrupt_common)
 	bl	do_IRQ
 	b	interrupt_return
 
-	GEN_KVM hardware_interrupt
-
 
 /**
  * Interrupt 0x600 - Alignment Interrupt
@@ -1617,8 +1573,6 @@ EXC_COMMON_BEGIN(alignment_common)
 	REST_NVGPRS(r1) /* instruction emulation may change GPRs */
 	b	interrupt_return
 
-	GEN_KVM alignment
-
 
 /**
  * Interrupt 0x700 - Program Interrupt (program check).
@@ -1681,8 +1635,6 @@ EXC_COMMON_BEGIN(program_check_common)
 	REST_NVGPRS(r1) /* instruction emulation may change GPRs */
 	b	interrupt_return
 
-	GEN_KVM program_check
-
 
 /*
  * Interrupt 0x800 - Floating-Point Unavailable Interrupt.
@@ -1735,8 +1687,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_TM)
 	b	interrupt_return
 #endif
 
-	GEN_KVM fp_unavailable
-
 
 /**
  * Interrupt 0x900 - Decrementer Interrupt.
@@ -1777,8 +1727,6 @@ EXC_COMMON_BEGIN(decrementer_common)
 	bl	timer_interrupt
 	b	interrupt_return
 
-	GEN_KVM decrementer
-
 
 /**
  * Interrupt 0x980 - Hypervisor Decrementer Interrupt.
@@ -1825,8 +1773,6 @@ EXC_COMMON_BEGIN(hdecrementer_common)
 	ld	r13,PACA_EXGEN+EX_R13(r13)
 	HRFI_TO_KERNEL
 
-	GEN_KVM hdecrementer
-
 
 /**
  * Interrupt 0xa00 - Directed Privileged Doorbell Interrupt.
@@ -1868,8 +1814,6 @@ EXC_COMMON_BEGIN(doorbell_super_common)
 #endif
 	b	interrupt_return
 
-	GEN_KVM doorbell_super
-
 
 EXC_REAL_NONE(0xb00, 0x100)
 EXC_VIRT_NONE(0x4b00, 0x100)
@@ -1919,7 +1863,7 @@ INT_DEFINE_END(system_call)
 	GET_PACA(r13)
 	std	r10,PACA_EXGEN+EX_R10(r13)
 	INTERRUPT_TO_KERNEL
-	KVMTEST system_call /* uses r10, branch to system_call_kvm */
+	KVMTEST system_call kvm_hcall /* uses r10, branch to kvm_hcall */
 	mfctr	r9
 #else
 	mr	r9,r13
@@ -1978,7 +1922,7 @@ EXC_VIRT_BEGIN(system_call, 0x4c00, 0x100)
 EXC_VIRT_END(system_call, 0x4c00, 0x100)
 
 #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
-TRAMP_REAL_BEGIN(system_call_kvm)
+TRAMP_REAL_BEGIN(kvm_hcall)
 	mfctr	r10
 	SET_SCRATCH0(r10) /* Save r13 in SCRATCH0 */
 #ifdef CONFIG_RELOCATABLE
@@ -2018,8 +1962,6 @@ EXC_COMMON_BEGIN(single_step_common)
 	bl	single_step_exception
 	b	interrupt_return
 
-	GEN_KVM single_step
-
 
 /**
  * Interrupt 0xe00 - Hypervisor Data Storage Interrupt (HDSI).
@@ -2060,8 +2002,6 @@ MMU_FTR_SECTION_ELSE
 ALT_MMU_FTR_SECTION_END_IFSET(MMU_FTR_TYPE_RADIX)
 	b       interrupt_return
 
-	GEN_KVM h_data_storage
-
 
 /**
  * Interrupt 0xe20 - Hypervisor Instruction Storage Interrupt (HISI).
@@ -2087,8 +2027,6 @@ EXC_COMMON_BEGIN(h_instr_storage_common)
 	bl	unknown_exception
 	b	interrupt_return
 
-	GEN_KVM h_instr_storage
-
 
 /**
  * Interrupt 0xe40 - Hypervisor Emulation Assistance Interrupt.
@@ -2113,8 +2051,6 @@ EXC_COMMON_BEGIN(emulation_assist_common)
 	REST_NVGPRS(r1) /* instruction emulation may change GPRs */
 	b	interrupt_return
 
-	GEN_KVM emulation_assist
-
 
 /**
  * Interrupt 0xe60 - Hypervisor Maintenance Interrupt (HMI).
@@ -2187,8 +2123,6 @@ EXC_COMMON_BEGIN(hmi_exception_early_common)
 	EXCEPTION_RESTORE_REGS hsrr=1
 	GEN_INT_ENTRY hmi_exception, virt=0
 
-	GEN_KVM hmi_exception_early
-
 EXC_COMMON_BEGIN(hmi_exception_common)
 	GEN_COMMON hmi_exception
 	FINISH_NAP
@@ -2197,8 +2131,6 @@ EXC_COMMON_BEGIN(hmi_exception_common)
 	bl	handle_hmi_exception
 	b	interrupt_return
 
-	GEN_KVM hmi_exception
-
 
 /**
  * Interrupt 0xe80 - Directed Hypervisor Doorbell Interrupt.
@@ -2231,8 +2163,6 @@ EXC_COMMON_BEGIN(h_doorbell_common)
 #endif
 	b	interrupt_return
 
-	GEN_KVM h_doorbell
-
 
 /**
  * Interrupt 0xea0 - Hypervisor Virtualization Interrupt.
@@ -2261,8 +2191,6 @@ EXC_COMMON_BEGIN(h_virt_irq_common)
 	bl	do_IRQ
 	b	interrupt_return
 
-	GEN_KVM h_virt_irq
-
 
 EXC_REAL_NONE(0xec0, 0x20)
 EXC_VIRT_NONE(0x4ec0, 0x20)
@@ -2308,8 +2236,6 @@ EXC_COMMON_BEGIN(performance_monitor_common)
 	bl	performance_monitor_exception
 	b	interrupt_return
 
-	GEN_KVM performance_monitor
-
 
 /**
  * Interrupt 0xf20 - Vector Unavailable Interrupt.
@@ -2362,8 +2288,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	bl	altivec_unavailable_exception
 	b	interrupt_return
 
-	GEN_KVM altivec_unavailable
-
 
 /**
  * Interrupt 0xf40 - VSX Unavailable Interrupt.
@@ -2415,8 +2339,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 	bl	vsx_unavailable_exception
 	b	interrupt_return
 
-	GEN_KVM vsx_unavailable
-
 
 /**
  * Interrupt 0xf60 - Facility Unavailable Interrupt.
@@ -2445,8 +2367,6 @@ EXC_COMMON_BEGIN(facility_unavailable_common)
 	REST_NVGPRS(r1) /* instruction emulation may change GPRs */
 	b	interrupt_return
 
-	GEN_KVM facility_unavailable
-
 
 /**
  * Interrupt 0xf60 - Hypervisor Facility Unavailable Interrupt.
@@ -2475,8 +2395,6 @@ EXC_COMMON_BEGIN(h_facility_unavailable_common)
 	REST_NVGPRS(r1) /* XXX Shouldn't be necessary in practice */
 	b	interrupt_return
 
-	GEN_KVM h_facility_unavailable
-
 
 EXC_REAL_NONE(0xfa0, 0x20)
 EXC_VIRT_NONE(0x4fa0, 0x20)
@@ -2506,8 +2424,6 @@ EXC_COMMON_BEGIN(cbe_system_error_common)
 	bl	cbe_system_error_exception
 	b	interrupt_return
 
-	GEN_KVM cbe_system_error
-
 #else /* CONFIG_CBE_RAS */
 EXC_REAL_NONE(0x1200, 0x100)
 EXC_VIRT_NONE(0x5200, 0x100)
@@ -2533,8 +2449,6 @@ EXC_COMMON_BEGIN(instruction_breakpoint_common)
 	bl	instruction_breakpoint_exception
 	b	interrupt_return
 
-	GEN_KVM instruction_breakpoint
-
 
 EXC_REAL_NONE(0x1400, 0x100)
 EXC_VIRT_NONE(0x5400, 0x100)
@@ -2655,8 +2569,6 @@ EXC_COMMON_BEGIN(denorm_exception_common)
 	bl	unknown_exception
 	b	interrupt_return
 
-	GEN_KVM denorm_exception
-
 
 #ifdef CONFIG_CBE_RAS
 INT_DEFINE_BEGIN(cbe_maintenance)
@@ -2674,8 +2586,6 @@ EXC_COMMON_BEGIN(cbe_maintenance_common)
 	bl	cbe_maintenance_exception
 	b	interrupt_return
 
-	GEN_KVM cbe_maintenance
-
 #else /* CONFIG_CBE_RAS */
 EXC_REAL_NONE(0x1600, 0x100)
 EXC_VIRT_NONE(0x5600, 0x100)
@@ -2706,8 +2616,6 @@ EXC_COMMON_BEGIN(altivec_assist_common)
 #endif
 	b	interrupt_return
 
-	GEN_KVM altivec_assist
-
 
 #ifdef CONFIG_CBE_RAS
 INT_DEFINE_BEGIN(cbe_thermal)
@@ -2725,8 +2633,6 @@ EXC_COMMON_BEGIN(cbe_thermal_common)
 	bl	cbe_thermal_exception
 	b	interrupt_return
 
-	GEN_KVM cbe_thermal
-
 #else /* CONFIG_CBE_RAS */
 EXC_REAL_NONE(0x1800, 0x100)
 EXC_VIRT_NONE(0x5800, 0x100)
@@ -2999,6 +2905,10 @@ TRAMP_REAL_BEGIN(rfscv_flush_fallback)
 
 USE_TEXT_SECTION()
 
+	/* conditional branch in KVMTEST can't reach all the way, make a stub */
+kvm_interrupt:
+	b	kvmppc_interrupt
+
 _GLOBAL(do_uaccess_flush)
 	UACCESS_FLUSH_FIXUP_SECTION
 	nop
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 7050197cd359..ef946e202773 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -30,15 +30,45 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	sldi	r12,r10,32
 	ori	r12,r12,0xc00
 	ld	r10,PACA_EXGEN+EX_R10(r13)
+	b	do_kvm_interrupt
 
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
 kvmppc_interrupt:
+	li	r11,PACA_EXGEN
+	cmpdi	r10,0x200
+	bgt+	1f
+	li	r11,PACA_EXMC
+	beq	1f
+	li	r11,PACA_EXNMI
+1:	add	r11,r11,r13
+
+BEGIN_FTR_SECTION
+	ld	r12,EX_CFAR(r11)
+	std	r12,HSTATE_CFAR(r13)
+END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
+	ld	r12,EX_CTR(r11)
+	mtctr	r12
+BEGIN_FTR_SECTION
+	ld	r12,EX_PPR(r11)
+	std	r12,HSTATE_PPR(r13)
+END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
+	ld	r12,EX_R12(r11)
+	std	r12,HSTATE_SCRATCH0(r13)
+	sldi	r12,r9,32
+	or	r12,r12,r10
+	ld	r9,EX_R9(r11)
+	ld	r10,EX_R10(r11)
+	ld	r11,EX_R11(r11)
+
+do_kvm_interrupt:
 	/*
-	 * Register contents:
+	 * Hcalls and other interrupts come here after normalising register
+	 * contents and save locations:
+	 *
 	 * R12		= (guest CR << 32) | interrupt vector
 	 * R13		= PACA
-	 * guest R12 saved in shadow VCPU SCRATCH0
+	 * guest R12 saved in shadow HSTATE_SCRATCH0
 	 * guest R13 saved in SPRN_SCRATCH0
 	 */
 	std	r9,HSTATE_SCRATCH2(r13)
-- 
2.23.0

