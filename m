Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C61D511FD88
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 05:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLPETb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 23:19:31 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:34734 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfLPETa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 15 Dec 2019 23:19:30 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 546B7AE80565;
        Sun, 15 Dec 2019 23:18:21 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 1/4] Revert "powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests"
Date:   Mon, 16 Dec 2019 15:19:21 +1100
Message-Id: <20191216041924.42318-2-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216041924.42318-1-aik@ozlabs.ru>
References: <20191216041924.42318-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

This reverts commit edea902c1c1efb855f77e041f9daf1abe7a9768a.

At the time the change allowed direct DMA ops for secure VMs; however
since then we switched on using SWIOTLB backed with IOMMU (direct mapping)
and to make this work, we need dma_iommu_ops which handles all cases
including TCE mapping I/O pages in the presence of an IOMMU.

Fixes: edea902c1c1e ("powerpc/pseries/iommu: Don't use dma_iommu_ops on secure guests")
Signed-off-by: Ram Pai <linuxram@us.ibm.com>
[aik: added "revert" and "fixes:"]
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2
* made it a revert patch, added "fixes:"
---
 arch/powerpc/platforms/pseries/iommu.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 6ba081dd61c9..df7db33ca93b 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -36,7 +36,6 @@
 #include <asm/udbg.h>
 #include <asm/mmzone.h>
 #include <asm/plpar_wrappers.h>
-#include <asm/svm.h>
 
 #include "pseries.h"
 
@@ -1320,15 +1319,7 @@ void iommu_init_early_pSeries(void)
 	of_reconfig_notifier_register(&iommu_reconfig_nb);
 	register_memory_notifier(&iommu_mem_nb);
 
-	/*
-	 * Secure guest memory is inacessible to devices so regular DMA isn't
-	 * possible.
-	 *
-	 * In that case keep devices' dma_map_ops as NULL so that the generic
-	 * DMA code path will use SWIOTLB to bounce buffers for DMA.
-	 */
-	if (!is_secure_guest())
-		set_pci_dma_ops(&dma_iommu_ops);
+	set_pci_dma_ops(&dma_iommu_ops);
 }
 
 static int __init disable_multitce(char *str)
-- 
2.17.1

