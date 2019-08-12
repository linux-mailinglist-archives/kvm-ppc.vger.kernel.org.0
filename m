Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC68969A
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Aug 2019 07:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfHLFIC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Aug 2019 01:08:02 -0400
Received: from ozlabs.org ([203.11.71.1]:35081 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfHLFIC (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 12 Aug 2019 01:08:02 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 466P4H10BLz9sP7; Mon, 12 Aug 2019 15:07:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565586479; bh=hga7Z6eiRhJaNXetrKX6T9cmViB3+7ByIyfSAsch+nY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=djWpErbSFzLaczMa5OHQPKAyJ6oFQXb1Xljwid+wZtt5l+DoKETxY4C9+/FG1mRVY
         OJUQjqk3TKoM9km5lDAp+T9UPMkRG8WgrbnkYmoDZRW6/xFTAreQMkpsH7uiP6ZNUm
         dpSqrpg3Xoyy2CLq/3kUcNGXd/BUZ1FOIs4sHUBZtzS4HW6Icc4DgtNTdsRBcc3F+X
         /KNpSlcbBaqf8amtBz7j3UOdR9RGiBhF2tn5bZHC0lQrX0uIvr+WJx+TJq5a7yYCk+
         tg8u/rNEYXX+OlYrvd2oQMj4egoPpzBZNsEULfCP4yrqqitfqZgwMjK2dYQJTKc16e
         1Aua/W8f3kZbw==
Date:   Mon, 12 Aug 2019 15:07:05 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: Fix race in re-enabling XIVE
 escalation interrupts
Message-ID: <20190812050705.mlszjkatxa635pzh@oak.ozlabs.ibm.com>
References: <20190812050623.ltla46gh5futsqv4@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812050623.ltla46gh5futsqv4@oak.ozlabs.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Escalation interrupts are interrupts sent to the host by the XIVE
hardware when it has an interrupt to deliver to a guest VCPU but that
VCPU is not running anywhere in the system.  Hence we disable the
escalation interrupt for the VCPU being run when we enter the guest
and re-enable it when the guest does an H_CEDE hypercall indicating
it is idle.

It is possible that an escalation interrupt gets generated just as we
are entering the guest.  In that case the escalation interrupt may be
using a queue entry in one of the interrupt queues, and that queue
entry may not have been processed when the guest exits with an H_CEDE.
The existing entry code detects this situation and does not clear the
vcpu->arch.xive_esc_on flag as an indication that there is a pending
queue entry (if the queue entry gets processed, xive_esc_irq() will
clear the flag).  There is a comment in the code saying that if the
flag is still set on H_CEDE, we have to abort the cede rather than
re-enabling the escalation interrupt, lest we end up with two
occurrences of the escalation interrupt in the interrupt queue.

However, the exit code doesn't do that; it aborts the cede in the sense
that vcpu->arch.ceded gets cleared, but it still enables the escalation
interrupt by setting the source's PQ bits to 00.  Instead we need to
set the PQ bits to 10, indicating that an interrupt has been triggered.
We also need to avoid setting vcpu->arch.xive_esc_on in this case
(i.e. vcpu->arch.xive_esc_on seen to be set on H_CEDE) because
xive_esc_irq() will run at some point and clear it, and if we race with
that we may end up with an incorrect result (i.e. xive_esc_on set when
the escalation interrupt has just been handled).

It is extremely unlikely that having two queue entries would cause
observable problems; theoretically it could cause queue overflow, but
the CPU would have to have thousands of interrupts targetted to it for
that to be possible.  However, this fix will also make it possible to
determine accurately whether there is an unhandled escalation
interrupt in the queue, which will be needed by the following patch.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 337e64468d78..0e70d63b16b3 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2831,29 +2831,38 @@ kvm_cede_prodded:
 kvm_cede_exit:
 	ld	r9, HSTATE_KVM_VCPU(r13)
 #ifdef CONFIG_KVM_XICS
-	/* Abort if we still have a pending escalation */
+	li	r6, XIVE_ESB_SET_PQ_00
+	/*
+	 * If we still have a pending escalation, abort the cede,
+	 * and we must set PQ to 10 rather than 00 so that we don't
+	 * potentially end up with two entries for the escalation
+	 * interrupt in the XIVE interrupt queue.  In that case
+	 * we also don't want to set xive_esc_on to 1 here in
+	 * case we race with xive_esc_irq().
+	 */
 	lbz	r5, VCPU_XIVE_ESC_ON(r9)
 	cmpwi	r5, 0
-	beq	1f
+	beq	4f
 	li	r0, 0
 	stb	r0, VCPU_CEDED(r9)
+	li	r6, XIVE_ESB_SET_PQ_10
+	b	1f
+4:	li	r0, 1
+	stb	r0, VCPU_XIVE_ESC_ON(r9)
 1:	/* Enable XIVE escalation */
-	li	r5, XIVE_ESB_SET_PQ_00
 	mfmsr	r0
 	andi.	r0, r0, MSR_DR		/* in real mode? */
 	beq	1f
 	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
 	cmpdi	r10, 0
 	beq	3f
-	ldx	r0, r10, r5
+	ldx	r0, r10, r6
 	b	2f
 1:	ld	r10, VCPU_XIVE_ESC_RADDR(r9)
 	cmpdi	r10, 0
 	beq	3f
-	ldcix	r0, r10, r5
+	ldcix	r0, r10, r6
 2:	sync
-	li	r0, 1
-	stb	r0, VCPU_XIVE_ESC_ON(r9)
 #endif /* CONFIG_KVM_XICS */
 3:	b	guest_exit_cont
 
-- 
2.11.0

