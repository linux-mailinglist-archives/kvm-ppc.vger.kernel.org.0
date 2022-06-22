Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A29554284
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Jun 2022 08:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357087AbiFVFwl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 22 Jun 2022 01:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiFVFwk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 22 Jun 2022 01:52:40 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87EC0366B0
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Jun 2022 22:52:39 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 7F7478218B;
        Wed, 22 Jun 2022 01:52:37 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Book3s: Fix warning about xics_rm_h_xirr_x
Date:   Wed, 22 Jun 2022 15:52:35 +1000
Message-Id: <20220622055235.1139204-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This fixes "no previous prototype":

arch/powerpc/kvm/book3s_hv_rm_xics.c:482:15:
warning: no previous prototype for 'xics_rm_h_xirr_x' [-Wmissing-prototypes]

Reported by the kernel test robot.

Fixes: b22af9041927 ("KVM: PPC: Book3s: Remove real mode interrupt controller hcalls handlers")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_xics.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_xics.h b/arch/powerpc/kvm/book3s_xics.h
index 8e4c79e2fcd8..08fb0843faf5 100644
--- a/arch/powerpc/kvm/book3s_xics.h
+++ b/arch/powerpc/kvm/book3s_xics.h
@@ -143,6 +143,7 @@ static inline struct kvmppc_ics *kvmppc_xics_find_ics(struct kvmppc_xics *xics,
 }
 
 extern unsigned long xics_rm_h_xirr(struct kvm_vcpu *vcpu);
+extern unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu);
 extern int xics_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 			 unsigned long mfrr);
 extern int xics_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);
-- 
2.30.2

