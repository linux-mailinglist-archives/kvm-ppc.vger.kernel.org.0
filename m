Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE6D1F6048
	for <lists+kvm-ppc@lfdr.de>; Thu, 11 Jun 2020 05:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKDGj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jun 2020 23:06:39 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:53058 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgFKDGi (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 10 Jun 2020 23:06:38 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 842FBAE80021;
        Wed, 10 Jun 2020 23:03:47 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH kernel] KVM: PPC: Fix nested guest RC bits update
Date:   Thu, 11 Jun 2020 13:05:59 +1000
Message-Id: <20200611030559.75257-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Before commit 6cdf30375f82 ("powerpc/kvm/book3s: Use kvm helpers
to walk shadow or secondary table") we called __find_linux_pte() with
a page table pointer from a kvm_nested_guest struct but
now we rely on kvmhv_find_nested() which takes an L1 LPID and returns
a kvm_nested_guest pointer, however we pass a L0 LPID there and
the L2 guest hangs.

This fixes the LPID passed to kvmppc_hv_handle_set_rc().

Fixes: 6cdf30375f82 ("powerpc/kvm/book3s: Use kvm helpers to walk shadow or secondary table")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 99011f1b772a..f36f0a2993c0 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1234,7 +1234,7 @@ static long kvmhv_handle_nested_set_rc(struct kvm_vcpu *vcpu,
 
 	/* Set the rc bit in the pte of the shadow_pgtable for the nest guest */
 	ret = kvmppc_hv_handle_set_rc(kvm, true, writing,
-				      n_gpa, gp->shadow_lpid);
+				      n_gpa, gp->l1_lpid);
 	if (!ret)
 		ret = -EINVAL;
 	else
-- 
2.17.1

