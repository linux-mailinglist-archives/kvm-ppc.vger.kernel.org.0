Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1861B4592
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Apr 2020 14:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgDVM6b (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Apr 2020 08:58:31 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:51747 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgDVM6a (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Apr 2020 08:58:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TwKEIDQ_1587560295;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwKEIDQ_1587560295)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Apr 2020 20:58:15 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com
Subject: [PATCH v2 5/7] KVM: PPC: clean up redundant kvm_run parameters in assembly
Date:   Wed, 22 Apr 2020 20:58:08 +0800
Message-Id: <20200422125810.34847-6-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
structure. Earlier than historical reasons, many kvm-related function
parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
This patch does a unified cleanup of these remaining redundant parameters.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/powerpc/include/asm/kvm_ppc.h    |  2 +-
 arch/powerpc/kvm/book3s_interrupts.S  | 17 ++++++++---------
 arch/powerpc/kvm/book3s_pr.c          |  9 ++++-----
 arch/powerpc/kvm/booke.c              |  9 ++++-----
 arch/powerpc/kvm/booke_interrupts.S   |  9 ++++-----
 arch/powerpc/kvm/bookehv_interrupts.S | 10 +++++-----
 6 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ccf66b3a4c1d..0a056c64c317 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -59,7 +59,7 @@ enum xlate_readwrite {
 };
 
 extern int kvmppc_vcpu_run(struct kvm_vcpu *vcpu);
-extern int __kvmppc_vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu);
+extern int __kvmppc_vcpu_run(struct kvm_vcpu *vcpu);
 extern void kvmppc_handler_highmem(void);
 
 extern void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/powerpc/kvm/book3s_interrupts.S b/arch/powerpc/kvm/book3s_interrupts.S
index f7ad99d972ce..0eff749d8027 100644
--- a/arch/powerpc/kvm/book3s_interrupts.S
+++ b/arch/powerpc/kvm/book3s_interrupts.S
@@ -55,8 +55,7 @@
  ****************************************************************************/
 
 /* Registers:
- *  r3: kvm_run pointer
- *  r4: vcpu pointer
+ *  r3: vcpu pointer
  */
 _GLOBAL(__kvmppc_vcpu_run)
 
@@ -68,8 +67,8 @@ kvm_start_entry:
 	/* Save host state to the stack */
 	PPC_STLU r1, -SWITCH_FRAME_SIZE(r1)
 
-	/* Save r3 (kvm_run) and r4 (vcpu) */
-	SAVE_2GPRS(3, r1)
+	/* Save r3 (vcpu) */
+	SAVE_GPR(3, r1)
 
 	/* Save non-volatile registers (r14 - r31) */
 	SAVE_NVGPRS(r1)
@@ -82,11 +81,11 @@ kvm_start_entry:
 	PPC_STL	r0, _LINK(r1)
 
 	/* Load non-volatile guest state from the vcpu */
-	VCPU_LOAD_NVGPRS(r4)
+	VCPU_LOAD_NVGPRS(r3)
 
 kvm_start_lightweight:
 	/* Copy registers into shadow vcpu so we can access them in real mode */
-	mr	r3, r4
+	mr	r4, r3
 	bl	FUNC(kvmppc_copy_to_svcpu)
 	nop
 	REST_GPR(4, r1)
@@ -191,10 +190,10 @@ after_sprg3_load:
 	PPC_STL	r31, VCPU_GPR(R31)(r7)
 
 	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */
-	lwz	r5, VCPU_TRAP(r7)
+	lwz	r4, VCPU_TRAP(r7)
 
-	/* Restore r3 (kvm_run) and r4 (vcpu) */
-	REST_2GPRS(3, r1)
+	/* Restore r3 (vcpu) */
+	REST_GPR(3, r1)
 	bl	FUNC(kvmppc_handle_exit_pr)
 
 	/* If RESUME_GUEST, get back in the loop */
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ef54f917bdaf..01c8fe5abe0d 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1151,9 +1151,9 @@ static int kvmppc_exit_pr_progint(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	return r;
 }
 
-int kvmppc_handle_exit_pr(struct kvm_run *run, struct kvm_vcpu *vcpu,
-			  unsigned int exit_nr)
+int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 {
+	struct kvm_run *run = vcpu->run;
 	int r = RESUME_HOST;
 	int s;
 
@@ -1826,7 +1826,6 @@ static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
 
 static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	int ret;
 #ifdef CONFIG_ALTIVEC
 	unsigned long uninitialized_var(vrsave);
@@ -1834,7 +1833,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 
 	/* Check if we can run the vcpu at all */
 	if (!vcpu->arch.sane) {
-		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1861,7 +1860,7 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 
 	kvmppc_fix_ee_before_entry();
 
-	ret = __kvmppc_vcpu_run(run, vcpu);
+	ret = __kvmppc_vcpu_run(vcpu);
 
 	kvmppc_clear_debug(vcpu);
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 26b3f5900b72..942039aae598 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -732,12 +732,11 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
 
 int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	struct kvm_run *run = vcpu->run;
 	int ret, s;
 	struct debug_reg debug;
 
 	if (!vcpu->arch.sane) {
-		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return -EINVAL;
 	}
 
@@ -779,7 +778,7 @@ int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.pgdir = vcpu->kvm->mm->pgd;
 	kvmppc_fix_ee_before_entry();
 
-	ret = __kvmppc_vcpu_run(run, vcpu);
+	ret = __kvmppc_vcpu_run(vcpu);
 
 	/* No need for guest_exit. It's done in handle_exit.
 	   We also get here with interrupts enabled. */
@@ -983,9 +982,9 @@ static int kvmppc_resume_inst_load(struct kvm_vcpu *vcpu,
  *
  * Return value is in the form (errcode<<2 | RESUME_FLAG_HOST | RESUME_FLAG_NV)
  */
-int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
-                       unsigned int exit_nr)
+int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 {
+	struct kvm_run *run = vcpu->run;
 	int r = RESUME_HOST;
 	int s;
 	int idx;
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 2e56ab5a5f55..6fa82efe833b 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -237,7 +237,7 @@ _GLOBAL(kvmppc_resume_host)
 	/* Switch to kernel stack and jump to handler. */
 	LOAD_REG_ADDR(r3, kvmppc_handle_exit)
 	mtctr	r3
-	lwz	r3, HOST_RUN(r1)
+	mr	r3, r4
 	lwz	r2, HOST_R2(r1)
 	mr	r14, r4 /* Save vcpu pointer. */
 
@@ -337,15 +337,14 @@ heavyweight_exit:
 
 
 /* Registers:
- *  r3: kvm_run pointer
- *  r4: vcpu pointer
+ *  r3: vcpu pointer
  */
 _GLOBAL(__kvmppc_vcpu_run)
 	stwu	r1, -HOST_STACK_SIZE(r1)
-	stw	r1, VCPU_HOST_STACK(r4)	/* Save stack pointer to vcpu. */
+	stw	r1, VCPU_HOST_STACK(r3)	/* Save stack pointer to vcpu. */
 
 	/* Save host state to stack. */
-	stw	r3, HOST_RUN(r1)
+	mr	r4, r3
 	mflr	r3
 	stw	r3, HOST_STACK_LR(r1)
 	mfcr	r5
diff --git a/arch/powerpc/kvm/bookehv_interrupts.S b/arch/powerpc/kvm/bookehv_interrupts.S
index c577ba4b3169..8262c14fc9e6 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -434,9 +434,10 @@ _GLOBAL(kvmppc_resume_host)
 #endif
 
 	/* Switch to kernel stack and jump to handler. */
-	PPC_LL	r3, HOST_RUN(r1)
+	mr	r3, r4
 	mr	r5, r14 /* intno */
 	mr	r14, r4 /* Save vcpu pointer. */
+	mr	r4, r5
 	bl	kvmppc_handle_exit
 
 	/* Restore vcpu pointer and the nonvolatiles we used. */
@@ -525,15 +526,14 @@ heavyweight_exit:
 	blr
 
 /* Registers:
- *  r3: kvm_run pointer
- *  r4: vcpu pointer
+ *  r3: vcpu pointer
  */
 _GLOBAL(__kvmppc_vcpu_run)
 	stwu	r1, -HOST_STACK_SIZE(r1)
-	PPC_STL	r1, VCPU_HOST_STACK(r4)	/* Save stack pointer to vcpu. */
+	PPC_STL	r1, VCPU_HOST_STACK(r3)	/* Save stack pointer to vcpu. */
 
 	/* Save host state to stack. */
-	PPC_STL	r3, HOST_RUN(r1)
+	mr	r4, r3
 	mflr	r3
 	mfcr	r5
 	PPC_STL	r3, HOST_STACK_LR(r1)
-- 
2.17.1

