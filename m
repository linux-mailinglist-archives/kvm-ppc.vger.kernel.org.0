Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80EA111E005
	for <lists+kvm-ppc@lfdr.de>; Fri, 13 Dec 2019 09:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725799AbfLMI4M (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 13 Dec 2019 03:56:12 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:60180 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfLMI4L (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 13 Dec 2019 03:56:11 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id A3666AE80803;
        Fri, 13 Dec 2019 03:44:44 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH kernel 3/3] powerpc/pseries/iommu: Do not use H_PUT_TCE_INDIRECT in secure VM
Date:   Fri, 13 Dec 2019 19:45:37 +1100
Message-Id: <20191213084537.27306-4-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213084537.27306-1-aik@ozlabs.ru>
References: <20191213084537.27306-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

H_PUT_TCE_INDIRECT uses a 4K page with TCEs to allow handling up to 512
TCEs per hypercall. While it is a decent optimization, we rather share
less of secure VM memory so let's avoid sharing.

This only allows H_PUT_TCE_INDIRECT for normal (not secure) VMs.

This keeps using H_STUFF_TCE as it does not require sharing.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

Possible alternatives are:

1. define FW_FEATURE_STUFFTCE (to allow H_STUFF_TCE) in addition to
FW_FEATURE_MULTITCE (make it only enable H_PUT_TCE_INDIRECT) and enable
only FW_FEATURE_STUFFTCE for SVM; pro = no SVM mention in iommu.c,
con = a FW feature bit with very limited use

2. disable FW_FEATURE_MULTITCE and loose H_STUFF_TCE which adds a delay
in booting process
---
 arch/powerpc/platforms/pseries/iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index f6e9b87c82fc..2334a67c7614 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -192,7 +192,8 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	int ret = 0;
 	unsigned long flags;
 
-	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
+	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE) ||
+			is_secure_guest()) {
 		return tce_build_pSeriesLP(tbl->it_index, tcenum,
 					   tbl->it_page_shift, npages, uaddr,
 		                           direction, attrs);
@@ -402,7 +403,8 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
 	u64 rc = 0;
 	long l, limit;
 
-	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
+	if (!firmware_has_feature(FW_FEATURE_MULTITCE) ||
+			is_secure_guest()) {
 		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
 		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
 				be64_to_cpu(maprange->dma_base);
-- 
2.17.1

