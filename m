Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F26842F3E3
	for <lists+kvm-ppc@lfdr.de>; Fri, 15 Oct 2021 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhJONlr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 15 Oct 2021 09:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236572AbhJONlq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 15 Oct 2021 09:41:46 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED48C061762
        for <kvm-ppc@vger.kernel.org>; Fri, 15 Oct 2021 06:39:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HW6ng475Mz4xbY;
        Sat, 16 Oct 2021 00:39:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634305175;
        bh=PRMwh/FXIE11bV1ym0EHGSVocCQqj96Ad0R6qxSlFk8=;
        h=From:To:Cc:Subject:Date:From;
        b=OKLFWp6Q+WsrnsVKCx/qYJUm7EqcjzTkM9bIZvDgd6sxRUjY+V1wCqY00cr5PflKm
         DTzdlxSQu+wSJKGN25b49MHcQofkEfqU9uQnqbA5/oLHgf9HQFOgJvxUU2b3KImmtU
         Z9A6LIjFoAfXUsGVcIyvlS4qBzm3W0xd4fmKRo3ZcTPjrOG0AiKZKGvY8MCbssMZfr
         sr4NFqTT69teAnWwZAl9XZmZ+K8ZGXB6m485A3FL7NTeotskvhWvB3MYauYxmvx+e1
         Bo75ou1VnkhUP5Ow20il2VE8DIbBSnbclsyvwPP0GmINSFsWgrSgKjTA3Bpx0HBngV
         s+QT8rRrjx2Pg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <linuxppc-dev@lists.ozlabs.org>
Cc:     <npiggin@gmail.com>, <kvm-ppc@vger.kernel.org>
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()
Date:   Sat, 16 Oct 2021 00:39:28 +1100
Message-Id: <20211015133929.832061-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In commit 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in
C") kvm_start_guest() became idle_kvm_start_guest(). The old code
allocated a stack frame on the emergency stack, but didn't use the
frame to store anything, and also didn't store anything in its caller's
frame.

idle_kvm_start_guest() on the other hand is written more like a normal C
function, it creates a frame on entry, and also stores CR/LR into its
callers frame (per the ABI). The problem is that there is no caller
frame on the emergency stack.

The emergency stack for a given CPU is allocated with:

  paca_ptrs[i]->emergency_sp = alloc_stack(limit, i) + THREAD_SIZE;

So emergency_sp actually points to the first address above the emergency
stack allocation for a given CPU, we must not store above it without
first decrementing it to create a frame. This is different to the
regular kernel stack, paca->kstack, which is initialised to point at an
initial frame that is ready to use.

idle_kvm_start_guest() stores the backchain, CR and LR all of which
write outside the allocation for the emergency stack. It then creates a
stack frame and saves the non-volatile registers. Unfortunately the
frame it creates is not large enough to fit the non-volatiles, and so
the saving of the non-volatile registers also writes outside the
emergency stack allocation.

The end result is that we corrupt whatever is at 0-24 bytes, and 112-248
bytes above the emergency stack allocation.

In practice this has gone unnoticed because the memory immediately above
the emergency stack happens to be used for other stack allocations,
either another CPUs mc_emergency_sp or an IRQ stack. See the order of
calls to irqstack_early_init() and emergency_stack_init().

The low addresses of another stack are the top of that stack, and so are
only used if that stack is under extreme pressue, which essentially
never happens in practice - and if it did there's a high likelyhood we'd
crash due to that stack overflowing.

Still, we shouldn't be corrupting someone else's stack, and it is purely
luck that we aren't corrupting something else.

To fix it we save CR/LR into the caller's frame using the existing r1 on
entry, we then create a SWITCH_FRAME_SIZE frame (which has space for
pt_regs) on the emergency stack with the backchain pointing to the
existing stack, and then finally we switch to the new frame on the
emergency stack.

Fixes: 10d91611f426 ("powerpc/64s: Reimplement book3s idle code in C")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 90484425a1e6..ec57952b60b0 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -255,13 +255,15 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
  * r3 contains the SRR1 wakeup value, SRR1 is trashed.
  */
 _GLOBAL(idle_kvm_start_guest)
-	ld	r4,PACAEMERGSP(r13)
 	mfcr	r5
 	mflr	r0
-	std	r1,0(r4)
-	std	r5,8(r4)
-	std	r0,16(r4)
-	subi	r1,r4,STACK_FRAME_OVERHEAD
+	std	r5, 8(r1)	// Save CR in caller's frame
+	std	r0, 16(r1)	// Save LR in caller's frame
+	// Create frame on emergency stack
+	ld	r4, PACAEMERGSP(r13)
+	stdu	r1, -SWITCH_FRAME_SIZE(r4)
+	// Switch to new frame on emergency stack
+	mr	r1, r4
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -395,10 +397,9 @@ _GLOBAL(idle_kvm_start_guest)
 	/* set up r3 for return */
 	mfspr	r3,SPRN_SRR1
 	REST_NVGPRS(r1)
-	addi	r1, r1, STACK_FRAME_OVERHEAD
-	ld	r0, 16(r1)
-	ld	r5, 8(r1)
-	ld	r1, 0(r1)
+	ld	r1, 0(r1)	// Switch back to caller stack
+	ld	r0, 16(r1)	// Reload LR
+	ld	r5, 8(r1)	// Reload CR
 	mtlr	r0
 	mtcr	r5
 	blr
-- 
2.25.1

