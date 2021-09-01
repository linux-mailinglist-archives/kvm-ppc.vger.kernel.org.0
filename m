Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75B3FD5D5
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Sep 2021 10:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhIAIqv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Sep 2021 04:46:51 -0400
Received: from ozlabs.ru ([107.174.27.60]:55840 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241376AbhIAIqv (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 1 Sep 2021 04:46:51 -0400
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 5A385AE80203;
        Wed,  1 Sep 2021 04:45:52 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Book3S: Suppress failed alloc warning in H_COPY_TOFROM_GUEST
Date:   Wed,  1 Sep 2021 18:45:50 +1000
Message-Id: <20210901084550.1658699-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

H_COPY_TOFROM_GUEST is an hcall for an upper level VM to access its nested
VMs memory. The userspace can trigger WARN_ON_ONCE(!(gfp & __GFP_NOWARN))
in __alloc_pages() by constructing a tiny VM which only does
H_COPY_TOFROM_GUEST with a too big GPR9 (number of bytes to copy).

This silences the warning by adding __GFP_NOWARN.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index e57c08b968c0..a2e34efb8d31 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -580,7 +580,7 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 	if (eaddr & (0xFFFUL << 52))
 		return H_PARAMETER;
 
-	buf = kzalloc(n, GFP_KERNEL);
+	buf = kzalloc(n, GFP_KERNEL | __GFP_NOWARN);
 	if (!buf)
 		return H_NO_MEM;
 
-- 
2.30.2

