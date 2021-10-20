Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C73434849
	for <lists+kvm-ppc@lfdr.de>; Wed, 20 Oct 2021 11:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhJTJvG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Oct 2021 05:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJTJuy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 20 Oct 2021 05:50:54 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17B5C06174E
        for <kvm-ppc@vger.kernel.org>; Wed, 20 Oct 2021 02:48:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HZ5Qv0WT6z4xb9;
        Wed, 20 Oct 2021 20:48:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1634723319;
        bh=yrsVAUODqbT1Kig4Jeti7vBlyyWb8oQHopqazA+I77I=;
        h=From:To:Cc:Subject:Date:From;
        b=qoyHM4r647UOikwesgO+kqUgGdJc3w4qo0hmA0y0w2DCtLomkbVU/zbMGZgbOk1cy
         hGtfz+I84en9ldjO51my5vQyhYv3F7Ct3ZkmZPYeboPjJe31XzCxFOzUuPLfUzoCZJ
         M8wczt7XOhL5l+X10QFsHbKZWjjsfFGsJ+s22X4mzeNxfgpAKJmYV+QEUUNIpokIP9
         7pEz2uLKDu2hGcOP9eJI8QVDQTIK44TuAYQC7u7C1mZ/lvJdeiqkXo+L+TgKFloAax
         M0pMpUgzXV63rf+4JnGWa3UmWDo+w50GEcgip51W1iV5G753Cs9X8QprBiDNykXXLz
         ZtYlUPqWcGTzg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     <linuxppc-dev@lists.ozlabs.org>
Cc:     <npiggin@gmail.com>, <kvm-ppc@vger.kernel.org>
Subject: [PATCH] powerpc/idle: Don't corrupt back chain when going idle
Date:   Wed, 20 Oct 2021 20:48:26 +1100
Message-Id: <20211020094826.3222052-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In isa206_idle_insn_mayloss() we store various registers into the stack
red zone, which is allowed.

However inside the IDLE_STATE_ENTER_SEQ_NORET macro we save r2 again,
to 0(r1), which corrupts the stack back chain.

We used to do the same in isa206_idle_insn_mayloss() itself, but we
fixed that in 73287caa9210 ("powerpc64/idle: Fix SP offsets when saving
GPRs"), however we missed that the macro also corrupts the back chain.

Corrupting the back chain is bad for debuggability but doesn't
necessarily cause a bug.

However we recently changed the stack handling in some KVM code, and it
now relies on the stack back chain being valid when it returns. The
corruption causes that code to return with r1 pointing somewhere in
kernel data, at some point LR is restored from the stack and we branch
to NULL or somewhere else invalid.

Only affects Power8 hosts running KVM guests, with dynamic_mt_modes
enabled (which it is by default).

The fixes tag below points to the commit that changed the KVM stack
handling, exposing this bug. The actual corruption of the back chain has
always existed since 948cf67c4726 ("powerpc: Add NAP mode support on
Power7 in HV mode").

Fixes: 9b4416c5095c ("KVM: PPC: Book3S HV: Fix stack handling in idle_kvm_start_guest()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/idle_book3s.S | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/idle_book3s.S b/arch/powerpc/kernel/idle_book3s.S
index abb719b21cae..3d97fb833834 100644
--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -126,14 +126,16 @@ _GLOBAL(idle_return_gpr_loss)
 /*
  * This is the sequence required to execute idle instructions, as
  * specified in ISA v2.07 (and earlier). MSR[IR] and MSR[DR] must be 0.
- *
- * The 0(r1) slot is used to save r2 in isa206, so use that here.
+ * We have to store a GPR somewhere, ptesync, then reload it, and create
+ * a false dependency on the result of the load. It doesn't matter which
+ * GPR we store, or where we store it. We have already stored r2 to the
+ * stack at -8(r1) in isa206_idle_insn_mayloss, so use that.
  */
 #define IDLE_STATE_ENTER_SEQ_NORET(IDLE_INST)			\
 	/* Magic NAP/SLEEP/WINKLE mode enter sequence */	\
-	std	r2,0(r1);					\
+	std	r2,-8(r1);					\
 	ptesync;						\
-	ld	r2,0(r1);					\
+	ld	r2,-8(r1);					\
 236:	cmpd	cr0,r2,r2;					\
 	bne	236b;						\
 	IDLE_INST;						\
-- 
2.31.1

