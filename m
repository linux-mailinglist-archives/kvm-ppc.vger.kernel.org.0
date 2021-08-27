Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0AF3F9366
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Aug 2021 06:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhH0EIC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Aug 2021 00:08:02 -0400
Received: from ozlabs.ru ([107.174.27.60]:58306 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhH0EIB (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 27 Aug 2021 00:08:01 -0400
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 4666FAE80030;
        Fri, 27 Aug 2021 00:07:09 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Leonardo Bras <leobras.c@gmail.com>
Subject: [PATCH kernel] KVM: PPC: Fix clearing never mapped TCEs in realmode
Date:   Fri, 27 Aug 2021 14:07:06 +1000
Message-Id: <20210827040706.517652-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Since e1a1ef84cd07, pages for TCE tables for KVM guests are allocated
only when needed. This allows skipping any update when clearing TCEs.
This works mostly fine as TCE updates are handled when MMU is enabled.
The realmode handlers fail with H_TOO_HARD when pages are not yet
allocated except when clearing a TCE in which case KVM prints a warning
but proceeds to dereference a NULL pointer which crashes the host OS.

This has not been caught so far as the change is reasonably new,
POWER9 runs mostly radix which does not use realmode handlers.
With hash, the default TCE table is memset() by QEMU the machine reset
which triggers page faults and the KVM TCE device's kvm_spapr_tce_fault()
handles those with MMU on. And the huge DMA windows are not cleared
by VMs whicn instead successfully create a DMA window big enough to map
the VM memory 1:1 and then VMs just map everything without clearing.

This started crashing now as upcoming sriov-under-powervm support added
a mode when a dymanic DMA window not big enough to map the VM memory 1:1
but it is used anyway, and the VM now is the first (i.e. not QEMU) to
clear a just created table. Note that the upstream QEMU needs to be
modified to trigger the VM to trigger the host OS crash.

This replaces WARN_ON_ONCE_RM() with a check and return.
This adds another warning if TCE is not being cleared.

Cc: Leonardo Bras <leobras.c@gmail.com>
Fixes: e1a1ef84cd07 ("KVM: PPC: Book3S: Allocate guest TCEs on demand too")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

With recent changes in the printk() department, calling pr_err() when MMU
off causes lockdep lockups which I did not dig any further so we should
start getting rid of the realmode's WARN_ON_ONCE_RM().
---
 arch/powerpc/kvm/book3s_64_vio_hv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index 083a4e037718..e5ba96c41f3f 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -173,10 +173,13 @@ static void kvmppc_rm_tce_put(struct kvmppc_spapr_tce_table *stt,
 	idx -= stt->offset;
 	page = stt->pages[idx / TCES_PER_PAGE];
 	/*
-	 * page must not be NULL in real mode,
-	 * kvmppc_rm_ioba_validate() must have taken care of this.
+	 * kvmppc_rm_ioba_validate() allows pages not be allocated if TCE is
+	 * being cleared, otherwise it returns H_TOO_HARD and we skip this.
 	 */
-	WARN_ON_ONCE_RM(!page);
+	if (!page) {
+		WARN_ON_ONCE_RM(tce != 0);
+		return;
+	}
 	tbl = kvmppc_page_address(page);
 
 	tbl[idx % TCES_PER_PAGE] = tce;
-- 
2.30.2

