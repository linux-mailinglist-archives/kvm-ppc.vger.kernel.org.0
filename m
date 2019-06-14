Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB8467EF
	for <lists+kvm-ppc@lfdr.de>; Fri, 14 Jun 2019 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFNS5x (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 14 Jun 2019 14:57:53 -0400
Received: from mail.ilande.co.uk ([46.43.2.167]:44436 "EHLO
        mail.default.ilande.uk0.bigv.io" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfFNS5x (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 14 Jun 2019 14:57:53 -0400
Received: from host81-158-188-206.range81-158.btcentralplus.com ([81.158.188.206] helo=kentang.home)
        by mail.default.ilande.uk0.bigv.io with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mark.cave-ayland@ilande.co.uk>)
        id 1hbrON-0005Ow-4q; Fri, 14 Jun 2019 19:57:40 +0100
From:   Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
To:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org, farosas@linux.ibm.com
Date:   Fri, 14 Jun 2019 19:57:45 +0100
Message-Id: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
X-Mailer: git-send-email 2.11.0
X-SA-Exim-Connect-IP: 81.158.188.206
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        mail.default.ilande.uk0.bigv.io
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: [PATCH] KVM: PPC: Book3S PR: fix software breakpoints
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail.default.ilande.uk0.bigv.io)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

QEMU's kvm_handle_debug() function identifies software breakpoints by checking
for a value of 0 in kvm_debug_exit_arch's status field. Since this field isn't
explicitly set to 0 when the software breakpoint instruction is detected, any
previous non-zero value present causes a hang in QEMU as it tries to process
the breakpoint instruction incorrectly as a hardware breakpoint.

Ensure that the kvm_debug_exit_arch status field is set to 0 when the software
breakpoint instruction is detected (similar to the existing logic in booke.c
and e500_emulate.c) to restore software breakpoint functionality under Book3S
PR.

Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
---
 arch/powerpc/kvm/emulate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index bb4d09c1ad56..6fca38ca791f 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -271,6 +271,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		 */
 		if (inst == KVMPPC_INST_SW_BREAKPOINT) {
 			run->exit_reason = KVM_EXIT_DEBUG;
+			run->debug.arch.status = 0;
 			run->debug.arch.address = kvmppc_get_pc(vcpu);
 			emulated = EMULATE_EXIT_USER;
 			advance = 0;
-- 
2.11.0

