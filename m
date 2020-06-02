Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B071EB585
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Jun 2020 07:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgFBFxg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 2 Jun 2020 01:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFBFxg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 2 Jun 2020 01:53:36 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AB4C061A0E
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Jun 2020 22:53:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bh6j07cVz9sSg;
        Tue,  2 Jun 2020 15:53:32 +1000 (AEST)
From:   Alistair Popple <alistair@popple.id.au>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     paulus@ozlabs.org, mpe@ellerman.id.au, mikey@neuling.org,
        kvm-ppc@vger.kernel.org, ravi.bangoria@linux.ibm.com,
        Alistair Popple <alistair@popple.id.au>
Subject: [PATCH] powerpc/kvm: Enable support for ISA v3.1 guests
Date:   Tue,  2 Jun 2020 15:53:25 +1000
Message-Id: <20200602055325.6102-1-alistair@popple.id.au>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Adds support for emulating ISAv3.1 guests by adding the appropriate PCR
and FSCR bits.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
---
 arch/powerpc/include/asm/reg.h |  1 +
 arch/powerpc/kvm/book3s_hv.c   | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 773f76402392..d77040d0588a 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -1348,6 +1348,7 @@
 #define PVR_ARCH_206p	0x0f100003
 #define PVR_ARCH_207	0x0f000004
 #define PVR_ARCH_300	0x0f000005
+#define PVR_ARCH_31	0x0f000006
 
 /* Macros for setting and retrieving special purpose registers */
 #ifndef __ASSEMBLY__
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..359bb2ed43e1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -345,7 +345,7 @@ static void kvmppc_set_pvr_hv(struct kvm_vcpu *vcpu, u32 pvr)
 }
 
 /* Dummy value used in computing PCR value below */
-#define PCR_ARCH_300	(PCR_ARCH_207 << 1)
+#define PCR_ARCH_31    (PCR_ARCH_300 << 1)
 
 static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 {
@@ -353,7 +353,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	/* We can (emulate) our own architecture version and anything older */
-	if (cpu_has_feature(CPU_FTR_ARCH_300))
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		host_pcr_bit = PCR_ARCH_31;
+	else if (cpu_has_feature(CPU_FTR_ARCH_300))
 		host_pcr_bit = PCR_ARCH_300;
 	else if (cpu_has_feature(CPU_FTR_ARCH_207S))
 		host_pcr_bit = PCR_ARCH_207;
@@ -379,6 +381,9 @@ static int kvmppc_set_arch_compat(struct kvm_vcpu *vcpu, u32 arch_compat)
 		case PVR_ARCH_300:
 			guest_pcr_bit = PCR_ARCH_300;
 			break;
+		case PVR_ARCH_31:
+			guest_pcr_bit = PCR_ARCH_31;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -2318,7 +2323,7 @@ static int kvmppc_core_vcpu_create_hv(struct kvm_vcpu *vcpu)
 	 * to trap and then we emulate them.
 	 */
 	vcpu->arch.hfscr = HFSCR_TAR | HFSCR_EBB | HFSCR_PM | HFSCR_BHRB |
-		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP;
+		HFSCR_DSCR | HFSCR_VECVSX | HFSCR_FP | HFSCR_PREFIX;
 	if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		vcpu->arch.hfscr &= mfspr(SPRN_HFSCR);
 		if (cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
-- 
2.20.1

