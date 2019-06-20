Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F97B4C705
	for <lists+kvm-ppc@lfdr.de>; Thu, 20 Jun 2019 08:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfFTGBb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 20 Jun 2019 02:01:31 -0400
Received: from ozlabs.org ([203.11.71.1]:39043 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfFTGBb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 20 Jun 2019 02:01:31 -0400
Received: from neuling.org (localhost [127.0.0.1])
        by ozlabs.org (Postfix) with ESMTP id 45TrmR2nPPz9sBp;
        Thu, 20 Jun 2019 16:01:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=neuling.org;
        s=201811; t=1561010487;
        bh=glw+2Td0oj/mdyoNqtydbZ/PHo9y+XS8MVB4rgGAwdY=;
        h=From:To:Cc:Subject:Date:From;
        b=UWQ8mUCsEbEnHRzuGYhHXMHaAPZMVt9UnTg3EP3ILgq+OvpmJBUGXKmMcrDoPOlp+
         uLHGP9MVwxoo1WpENcE27tjnBSTBbe/vgnc4HTWmUETUGEARZoPmujK3MSNpRDLPde
         YcDHw8DrorWVhxXp7SnC1WRUnK0DDCzDH70WMSzSzs+TCP4Gr8ZR3BXr2TgKfXX4WE
         TADLVZC3wKndLUwqzIEP3dO7zlRCGUPLgi3OQeESbwosJ6TQ/T0c/kjwBW4OfOgrDp
         c/SJXA9HYFCMjSlrzi0Sc3SH9TxJJByseaGLO1EGISQ+9hOK0DfjUq3CDV/Mx4xyTz
         txTRjd6bnt1KA==
Received: by neuling.org (Postfix, from userid 1000)
        id D6E8A2A2091; Thu, 20 Jun 2019 16:00:54 +1000 (AEST)
From:   Michael Neuling <mikey@neuling.org>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        paulus@ozlabs.org, kvm-ppc@vger.kernel.org,
        sjitindarsingh@gmail.com
Subject: [PATCH] KVM: PPC: Book3S HV: Fix CR0 setting in TM emulation
Date:   Thu, 20 Jun 2019 16:00:40 +1000
Message-Id: <20190620060040.26945-1-mikey@neuling.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When emulating tsr, treclaim and trechkpt, we incorrectly set CR0. The
code currently sets:
    CR0 <- 00 || MSR[TS]
but according to the ISA it should be:
    CR0 <-  0 || MSR[TS] || 0

This fixes the bit shift to put the bits in the correct location.

Tested-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/kvm/book3s_hv_tm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index 888e2609e3..31cd0f327c 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -131,7 +131,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		}
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		/* L=1 => tresume, L=0 => tsuspend */
 		if (instr & (1 << 21)) {
 			if (MSR_TM_SUSPENDED(msr))
@@ -175,7 +175,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
 		return RESUME_GUEST;
 
@@ -205,7 +205,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 
 		/* Set CR0 to indicate previous transactional state */
 		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
-			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
+			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 29);
 		vcpu->arch.shregs.msr = msr | MSR_TS_S;
 		return RESUME_GUEST;
 	}
-- 
2.21.0

