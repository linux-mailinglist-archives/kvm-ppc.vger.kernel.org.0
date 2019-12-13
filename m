Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0FF11E004
	for <lists+kvm-ppc@lfdr.de>; Fri, 13 Dec 2019 09:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfLMI4L (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 13 Dec 2019 03:56:11 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:60188 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfLMI4L (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 13 Dec 2019 03:56:11 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 192F7AE80037;
        Fri, 13 Dec 2019 03:44:39 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH kernel 1/3] powerpc/pseries/iommu: Use dma_iommu_ops for Secure VM.
Date:   Fri, 13 Dec 2019 19:45:35 +1100
Message-Id: <20191213084537.27306-2-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213084537.27306-1-aik@ozlabs.ru>
References: <20191213084537.27306-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Ram Pai <linuxram@us.ibm.com>

Commit edea902c1c1e ("powerpc/pseries/iommu: Don't use dma_iommu_ops on
		secure guests")
disabled dma_iommu_ops path, for secure VMs. Disabling dma_iommu_ops
path for secure VMs, helped enable dma_direct path.  This enabled
support for bounce-buffering through SWIOTLB.  However it fails to
operate when IOMMU is enabled, since I/O pages are not TCE mapped.

Reenable dma_iommu_ops path for pseries Secure VMs.  It handles all
cases including, TCE mapping I/O pages, in the presence of a
IOMMU.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
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

