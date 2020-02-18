Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9706116219E
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2020 08:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgBRHpx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Feb 2020 02:45:53 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:37210 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRHpw (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Feb 2020 02:45:52 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 44429AE807E2;
        Tue, 18 Feb 2020 02:35:30 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 5/5] vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB
Date:   Tue, 18 Feb 2020 18:36:50 +1100
Message-Id: <20200218073650.16149-6-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200218073650.16149-1-aik@ozlabs.ru>
References: <20200218073650.16149-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

So far the only option for a big 64big DMA window was a window located
at 0x800.0000.0000.0000 (1<<59) which creates problems for devices
supporting smaller DMA masks.

This exploits a POWER9 PHB option to allow the second DMA window to map
at 0 and advertises it with a 4GB offset to avoid overlap with
the default 32bit window.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/uapi/linux/vfio.h           |  2 ++
 drivers/vfio/vfio_iommu_spapr_tce.c | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9e843a147ead..c7f89d47335a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -831,9 +831,11 @@ struct vfio_iommu_spapr_tce_info {
 	__u32 argsz;
 	__u32 flags;
 #define VFIO_IOMMU_SPAPR_INFO_DDW	(1 << 0)	/* DDW supported */
+#define VFIO_IOMMU_SPAPR_INFO_DDW_START	(1 << 1)	/* DDW offset */
 	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
 	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
 	struct vfio_iommu_spapr_tce_ddw_info ddw;
+	__u64 dma64_window_start;
 };
 
 #define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 16b3adc508db..4f22be3c4aa2 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -691,7 +691,7 @@ static long tce_iommu_create_window(struct tce_container *container,
 	container->tables[num] = tbl;
 
 	/* Return start address assigned by platform in create_table() */
-	*start_addr = tbl->it_offset << tbl->it_page_shift;
+	*start_addr = tbl->it_dmaoff << tbl->it_page_shift;
 
 	return 0;
 
@@ -842,7 +842,13 @@ static long tce_iommu_ioctl(void *iommu_data,
 			info.ddw.levels = table_group->max_levels;
 		}
 
-		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info, ddw);
+		ddwsz = offsetofend(struct vfio_iommu_spapr_tce_info,
+				dma64_window_start);
+
+		if (info.argsz >= ddwsz) {
+			info.flags |= VFIO_IOMMU_SPAPR_INFO_DDW_START;
+			info.dma64_window_start = table_group->tce64_start;
+		}
 
 		if (info.argsz >= ddwsz)
 			minsz = ddwsz;
-- 
2.17.1

