Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07448161FD5
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2020 05:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBREgy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Feb 2020 23:36:54 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:44883 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgBREgy (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Feb 2020 23:36:54 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48M7Ng6t2Mz9sRk; Tue, 18 Feb 2020 15:36:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1582000612;
        bh=U0U17NF49vRbyn1OV0IRUsxvoX+k8LKqDmfKFiXQQ20=;
        h=From:To:Cc:Subject:Date:From;
        b=Ce6fEKD705UMcatq9F7doOjWqmMvTKwXtIlKQMWu0qmOUVXczESkRElsyWmM02lEh
         2fgU1jGkr5+QzN8ECFJu3wkebxg5OYGRH4v2z+mZfMQdcxvWF+4ZnnBMW7mvHQTbNP
         O0hlO6NwXAj8OvdMSLdhpQcuJ/AYYmtN0CM43aqbJ/I3/GxE422N3Dtfon9Xl/qw7v
         sDWIiiCm5/ZUhr+JIsFIhMk4Uo/ShDgksfRs/ulpPMEtwIgVCzp6QfVZTe6WKiY7+K
         b2ndJqY3WCxu5ZwE0eKKCzAVYTWoyVn2piyImomxNJw73TcXm0KhrEzVXdd9J+6+ga
         GNtMsh7e2+56A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@ozlabs.org
Subject: [PATCH] KVM: PPC: Book3S HV: Use RADIX_PTE_INDEX_SIZE in Radix MMU code
Date:   Tue, 18 Feb 2020 15:36:50 +1100
Message-Id: <20200218043650.24410-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

In kvmppc_unmap_free_pte() in book3s_64_mmu_radix.c, we use the
non-constant value PTE_INDEX_SIZE to clear a PTE page.

We can instead use the constant RADIX_PTE_INDEX_SIZE, because we know
this code will only be running when the Radix MMU is active.

Note that we already use RADIX_PTE_INDEX_SIZE for the allocation of
kvm_pte_cache.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 803940d79b73..134fbc1f029f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -425,7 +425,7 @@ static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
 				  unsigned int lpid)
 {
 	if (full) {
-		memset(pte, 0, sizeof(long) << PTE_INDEX_SIZE);
+		memset(pte, 0, sizeof(long) << RADIX_PTE_INDEX_SIZE);
 	} else {
 		pte_t *p = pte;
 		unsigned long it;
-- 
2.21.1

