Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3583FD5D3
	for <lists+kvm-ppc@lfdr.de>; Wed,  1 Sep 2021 10:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhIAIqS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 1 Sep 2021 04:46:18 -0400
Received: from ozlabs.ru ([107.174.27.60]:55610 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241682AbhIAIqR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 1 Sep 2021 04:46:17 -0400
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 4AD66AE801F8;
        Wed,  1 Sep 2021 04:45:18 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] KVM: PPC: Book3S: Suppress warnings when allocating too big memory slots
Date:   Wed,  1 Sep 2021 18:45:12 +1000
Message-Id: <20210901084512.1658628-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The userspace can trigger "vmalloc size %lu allocation failure: exceeds
total pages" via the KVM_SET_USER_MEMORY_REGION ioctl.

This silences the warning by checking the limit before calling vzalloc()
and returns ENOMEM if failed.

This does not call underlying valloc helpers as __vmalloc_node() is only
exported when CONFIG_TEST_VMALLOC_MODULE and __vmalloc_node_range() is not
exported at all.

Spotted by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 474c0cfde384..a59f1cccbcf9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4830,8 +4830,12 @@ static int kvmppc_core_prepare_memory_region_hv(struct kvm *kvm,
 	unsigned long npages = mem->memory_size >> PAGE_SHIFT;
 
 	if (change == KVM_MR_CREATE) {
-		slot->arch.rmap = vzalloc(array_size(npages,
-					  sizeof(*slot->arch.rmap)));
+		unsigned long cb = array_size(npages, sizeof(*slot->arch.rmap));
+
+		if ((cb >> PAGE_SHIFT) > totalram_pages())
+			return -ENOMEM;
+
+		slot->arch.rmap = vzalloc(cb);
 		if (!slot->arch.rmap)
 			return -ENOMEM;
 	}
-- 
2.30.2

