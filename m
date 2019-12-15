Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0211F70D
	for <lists+kvm-ppc@lfdr.de>; Sun, 15 Dec 2019 10:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOJtH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 04:49:07 -0500
Received: from bahamut-sn.mc.pp.se ([213.115.244.39]:36736 "EHLO
        bahamut.mc.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfLOJtH (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 15 Dec 2019 04:49:07 -0500
Received: from hakua (hakua [192.168.42.40])
        by bahamut.mc.pp.se (Postfix) with SMTP id 93E90A3C06;
        Sun, 15 Dec 2019 10:49:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mc.pp.se; s=hedgehog;
        t=1576403345; bh=yXGLwjD345CaXg2lBpjGZKcFu4vIc+N91onoyvmmduE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:
         Content-Transfer-Encoding; b=URDw7iSxJu6Yyo3fpVZI4EBw6FZk55bLqggfE
        o1BF+nKuH4V8ggByY+L7H7+P1kJyuJzyCqVCP0qjbZ8H/m6tU5tCdtOEDO+a8CWQ8uX
        tGNdprpYlA7EAAP9Mhg1Ikwvwf+sKUiDNLkGv4AjZhYMF9wEfSfBBdXQEvi/upaTGLA
        =
Received: by hakua (sSMTP sendmail emulation); Sun, 15 Dec 2019 10:49:04 +0100
From:   "Marcus Comstedt" <marcus@mc.pp.se>
To:     kvm-ppc@vger.kernel.org
Cc:     Marcus Comstedt <marcus@mc.pp.se>
Subject: [PATCH] KVM: PPC: Book3S HV: Fix regression on big endian hosts
Date:   Sun, 15 Dec 2019 10:49:00 +0100
Message-Id: <20191215094900.46740-1-marcus@mc.pp.se>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

VCPU_CR is the offset of arch.regs.ccr in kvm_vcpu.
arch/powerpc/include/asm/kvm_host.h defines arch.regs as a struct
pt_regs, and arch/powerpc/include/asm/ptrace.h defines the ccr field
of pt_regs as "unsigned long ccr".  Since unsigned long is 64 bits, a
64-bit load needs to be used to load it, unless an endianness specific
correction offset is added to access the desired subpart.  In this
case there is no reason to _not_ use a 64 bit load though.

Signed-off-by: Marcus Comstedt <marcus@mc.pp.se>
---
This was tested on 5.4.3 on a Talos II (POWER9 Nimbus DD2.2)

 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 0496e66aaa56..c6fbbd29bd87 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1117,7 +1117,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 	ld	r7, VCPU_GPR(R7)(r4)
 	bne	ret_to_ultra
 
-	lwz	r0, VCPU_CR(r4)
+	ld	r0, VCPU_CR(r4)
 	mtcr	r0
 
 	ld	r0, VCPU_GPR(R0)(r4)
@@ -1137,7 +1137,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
  *   R3 = UV_RETURN
  */
 ret_to_ultra:
-	lwz	r0, VCPU_CR(r4)
+	ld	r0, VCPU_CR(r4)
 	mtcr	r0
 
 	ld	r0, VCPU_GPR(R3)(r4)
-- 
2.23.0

