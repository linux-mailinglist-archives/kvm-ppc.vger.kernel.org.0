Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8F2330A9B
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Mar 2021 10:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCHJxk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Mar 2021 04:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhCHJxW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Mar 2021 04:53:22 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F708C06174A
        for <kvm-ppc@vger.kernel.org>; Mon,  8 Mar 2021 01:53:22 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso416673pjb.4
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Mar 2021 01:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+3GtAD//TqsqPvrxhakSIKvRtv68M6Bg8x+2UbJqxRc=;
        b=f9kxP9eRIbqZSWUWUE0lLnA0n6HpdO2868u8dDHL1NS0klypeXnyY3D6M7dXxndV4G
         6dkdsJkUxD+KtqbilIDJkpoN+FBGltrho7pNcDlzhcNeabwUGYHY8lnT/Uht7e2Xjdu9
         moDNY2117oHAx/q88Rp7xENJYpOSYrNREJLtnhdxh+G90E/N3LseVouA2ozf3/6RL6T6
         9FDRiPI4kNxnudDcc/952zNYNEJUA8qLpfnPQnCaOaK+OMAGEzExXTXHqh/KPmo3BlKx
         HtpNRZyKdvrvxGJiK59sttZw0UyO9jJrypCZieLvwl9FK8lCfZlcIZaYltt8SVO1BD9E
         o/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+3GtAD//TqsqPvrxhakSIKvRtv68M6Bg8x+2UbJqxRc=;
        b=QN8YM0KmihnfIAihssgsIkt7Vv00m1t6n98TjiDBwGwU2+GTR14NeONB/Uh3naEQ26
         fVu1c0r5HlZm0HM11vD3H78c3ltV6RowvKZKw7X28AcxrQ8LU+OOCNVVV0OyxG44OL8l
         MdlhEReaNQ8dO+77GUinfC8USYWMldKaq9BRh5us/A2P7u0Lb+9atCCicKDqCg8Npoql
         dJk3uqo4CbM5T1IvT3Um92rhpS9U8go89GgNIeBZqF/RMezS2/VoNw+/UZhffZihM2FF
         S8e0rf5mqaLmWKgMAMILPKK6ZVQcj5lZ5pupLtsM8LP544FY9BL4E0dx/eqEQRGght8p
         MTMg==
X-Gm-Message-State: AOAM533R7lSxXiB9JjxDh9i5XQ6J6yU2e0F3hOpQT/uGV7QUpKVDbErf
        z+oFfNy3N8HAQm9airNS+ws=
X-Google-Smtp-Source: ABdhPJynZ3adx690BRj+0PzUzm+axM3IVgb9utiitUUKoVIQkyxk71ncn6bWvpUhBqnzIWATxRXt3A==
X-Received: by 2002:a17:90a:9f83:: with SMTP id o3mr23838988pjp.133.1615197202041;
        Mon, 08 Mar 2021 01:53:22 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id e63sm1326850pfe.208.2021.03.08.01.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 01:53:21 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [RFC PATCH 5/7] KVM: PPC: Remove RECONCILE_IRQ_STATE from guest exit
Date:   Mon,  8 Mar 2021 19:52:42 +1000
Message-Id: <20210308095244.3195782-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210308095244.3195782-1-npiggin@gmail.com>
References: <20210308095244.3195782-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Change KVM to keep the irq soft-mask state hard disabled when entering
the guest, to avoid "reconciling" the state when exiting the guest.

IRQ tracing still has to be updated so host irqs are disabled when the
guest is exited, but this is now done in C, similarly to Book3S HV.

[ I don't have BookE or PR KVM setup to actually test this, it's not
  so important as the 64e conversion to new interrupt code, but it
  would be nice if we can get rid of this reconciling from asm entirely ]
---
 arch/powerpc/include/asm/irqflags.h   | 58 ---------------------------
 arch/powerpc/include/asm/kvm_ppc.h    | 22 ----------
 arch/powerpc/kvm/book3s_pr.c          |  8 +++-
 arch/powerpc/kvm/booke.c              |  9 ++++-
 arch/powerpc/kvm/bookehv_interrupts.S |  9 -----
 5 files changed, 13 insertions(+), 93 deletions(-)

diff --git a/arch/powerpc/include/asm/irqflags.h b/arch/powerpc/include/asm/irqflags.h
index 1a6c1ce17735..47d46712928a 100644
--- a/arch/powerpc/include/asm/irqflags.h
+++ b/arch/powerpc/include/asm/irqflags.h
@@ -11,64 +11,6 @@
  */
 #include <asm/hw_irq.h>
 
-#else
-#ifdef CONFIG_TRACE_IRQFLAGS
-#ifdef CONFIG_IRQSOFF_TRACER
-/*
- * Since the ftrace irqsoff latency trace checks CALLER_ADDR1,
- * which is the stack frame here, we need to force a stack frame
- * in case we came from user space.
- */
-#define TRACE_WITH_FRAME_BUFFER(func)		\
-	mflr	r0;				\
-	stdu	r1, -STACK_FRAME_OVERHEAD(r1);	\
-	std	r0, 16(r1);			\
-	stdu	r1, -STACK_FRAME_OVERHEAD(r1);	\
-	bl func;				\
-	ld	r1, 0(r1);			\
-	ld	r1, 0(r1);
-#else
-#define TRACE_WITH_FRAME_BUFFER(func)		\
-	bl func;
-#endif
-
-/*
- * These are calls to C code, so the caller must be prepared for volatiles to
- * be clobbered.
- */
-#define TRACE_ENABLE_INTS	TRACE_WITH_FRAME_BUFFER(trace_hardirqs_on)
-#define TRACE_DISABLE_INTS	TRACE_WITH_FRAME_BUFFER(trace_hardirqs_off)
-
-/*
- * This is used by assembly code to soft-disable interrupts first and
- * reconcile irq state.
- *
- * NB: This may call C code, so the caller must be prepared for volatiles to
- * be clobbered.
- */
-#define RECONCILE_IRQ_STATE(__rA, __rB)		\
-	lbz	__rA,PACAIRQSOFTMASK(r13);	\
-	lbz	__rB,PACAIRQHAPPENED(r13);	\
-	andi.	__rA,__rA,IRQS_DISABLED;	\
-	li	__rA,IRQS_DISABLED;		\
-	ori	__rB,__rB,PACA_IRQ_HARD_DIS;	\
-	stb	__rB,PACAIRQHAPPENED(r13);	\
-	bne	44f;				\
-	stb	__rA,PACAIRQSOFTMASK(r13);	\
-	TRACE_DISABLE_INTS;			\
-44:
-
-#else
-#define TRACE_ENABLE_INTS
-#define TRACE_DISABLE_INTS
-
-#define RECONCILE_IRQ_STATE(__rA, __rB)		\
-	lbz	__rA,PACAIRQHAPPENED(r13);	\
-	li	__rB,IRQS_DISABLED;		\
-	ori	__rA,__rA,PACA_IRQ_HARD_DIS;	\
-	stb	__rB,PACAIRQSOFTMASK(r13);	\
-	stb	__rA,PACAIRQHAPPENED(r13)
-#endif
 #endif
 
 #endif
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 8aacd76bb702..749c5cadc883 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -996,28 +996,6 @@ static inline void kvmppc_set_sr(struct kvm_vcpu *vcpu, int nr, u32 val)
 	       vcpu->arch.shared->sr[nr] = cpu_to_le32(val);
 }
 
-/*
- * Please call after prepare_to_enter. This function puts the lazy ee and irq
- * disabled tracking state back to normal mode, without actually enabling
- * interrupts.
- */
-static inline void kvmppc_fix_ee_before_entry(void)
-{
-	trace_hardirqs_on();
-
-#ifdef CONFIG_PPC64
-	/*
-	 * To avoid races, the caller must have gone directly from having
-	 * interrupts fully-enabled to hard-disabled.
-	 */
-	WARN_ON(local_paca->irq_happened != PACA_IRQ_HARD_DIS);
-
-	/* Only need to enable IRQs by hard enabling them after this */
-	local_paca->irq_happened = 0;
-	irq_soft_mask_set(IRQS_ENABLED);
-#endif
-}
-
 static inline ulong kvmppc_get_ea_indexed(struct kvm_vcpu *vcpu, int ra, int rb)
 {
 	ulong ea;
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 913944dc3620..40f1f4e207bc 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1157,6 +1157,8 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	int r = RESUME_HOST;
 	int s;
 
+	trace_hardirqs_on();
+
 	vcpu->stat.sum_exits++;
 
 	run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -1460,7 +1462,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			r = s;
 		else {
 			/* interrupts now hard-disabled */
-			kvmppc_fix_ee_before_entry();
+			trace_hardirqs_off();
 		}
 
 		kvmppc_handle_lost_ext(vcpu);
@@ -1855,10 +1857,12 @@ static int kvmppc_vcpu_run_pr(struct kvm_vcpu *vcpu)
 	if (kvmppc_get_msr(vcpu) & MSR_FP)
 		kvmppc_handle_ext(vcpu, BOOK3S_INTERRUPT_FP_UNAVAIL, MSR_FP);
 
-	kvmppc_fix_ee_before_entry();
+	trace_hardirqs_on();
 
 	ret = __kvmppc_vcpu_run(vcpu);
 
+	trace_hardirqs_off();
+
 	kvmppc_clear_debug(vcpu);
 
 	/* No need for guest_exit. It's done in handle_exit.
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 7d5fe43f85c4..bcccebee6c3c 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -776,10 +776,13 @@ int kvmppc_vcpu_run(struct kvm_vcpu *vcpu)
 	current->thread.debug = vcpu->arch.dbg_reg;
 
 	vcpu->arch.pgdir = vcpu->kvm->mm->pgd;
-	kvmppc_fix_ee_before_entry();
+
+	trace_hardirqs_on();
 
 	ret = __kvmppc_vcpu_run(vcpu);
 
+	trace_hardirqs_off();
+
 	/* No need for guest_exit. It's done in handle_exit.
 	   We also get here with interrupts enabled. */
 
@@ -991,6 +994,8 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	u32 last_inst = KVM_INST_FETCH_FAILED;
 	enum emulation_result emulated = EMULATE_DONE;
 
+	trace_hardirqs_on();
+
 	/* update before a new last_exit_type is rewritten */
 	kvmppc_update_timing_stats(vcpu);
 
@@ -1357,7 +1362,7 @@ int kvmppc_handle_exit(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			r = (s << 2) | RESUME_HOST | (r & RESUME_FLAG_NV);
 		else {
 			/* interrupts now hard-disabled */
-			kvmppc_fix_ee_before_entry();
+			trace_hardirqs_off();
 			kvmppc_load_guest_fp(vcpu);
 			kvmppc_load_guest_altivec(vcpu);
 		}
diff --git a/arch/powerpc/kvm/bookehv_interrupts.S b/arch/powerpc/kvm/bookehv_interrupts.S
index 8262c14fc9e6..b5fe6fb53c66 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -424,15 +424,6 @@ _GLOBAL(kvmppc_resume_host)
 	mtspr	SPRN_EPCR, r3
 	isync
 
-#ifdef CONFIG_64BIT
-	/*
-	 * We enter with interrupts disabled in hardware, but
-	 * we need to call RECONCILE_IRQ_STATE to ensure
-	 * that the software state is kept in sync.
-	 */
-	RECONCILE_IRQ_STATE(r3,r5)
-#endif
-
 	/* Switch to kernel stack and jump to handler. */
 	mr	r3, r4
 	mr	r5, r14 /* intno */
-- 
2.23.0

