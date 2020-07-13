Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1005821DE8A
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 Jul 2020 19:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbgGMRWH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 Jul 2020 13:22:07 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3758 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMRWF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 13 Jul 2020 13:22:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0c97cd0000>; Mon, 13 Jul 2020 10:20:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 13 Jul 2020 10:22:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 13 Jul 2020 10:22:05 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 13 Jul
 2020 17:21:59 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 13 Jul 2020 17:21:59 +0000
Received: from rcampbell-dev.nvidia.com (Not Verified[10.110.48.66]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f0c98360005>; Mon, 13 Jul 2020 10:21:59 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>,
        <nouveau@lists.freedesktop.org>, <kvm-ppc@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        "Ben Skeggs" <bskeggs@redhat.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "Ralph Campbell" <rcampbell@nvidia.com>
Subject: [PATCH v2 1/5] nouveau: fix storing invalid ptes
Date:   Mon, 13 Jul 2020 10:21:45 -0700
Message-ID: <20200713172149.2310-2-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200713172149.2310-1-rcampbell@nvidia.com>
References: <20200713172149.2310-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594660813; bh=rz9ii3/rSLaotraZODv9PDOOFrnasJhkv9z9XY7GWhs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=VswAJyQZ7manJ2SfOLznJm8rAKzIbt64JdSJ43MkwLlhuHyXzmFh52wAvmFtpNPDW
         +jyEcn970ykf8LGntBY+F+RIDnr2nFHfOC0b9btqH8RNqeo+T+haRZmc9tLLE0cifQ
         wrWYu1OALfcGxVn3Q1f0RqDYOB8vZCa3Wg3CZgHjJE6Nm2acpHo0M01MG0oJpsyphH
         ANNoa0KS+FojsYBXaBordvpqiTpWIlC14Z3XmoijCG5KmSRaXVJoZb6yy/Ie6hxDYu
         8I7ZtUJ9uwHhYIOBrHIiXkklut9fRHTrxiR0UD7Vqc6pulM5yOXNyn9amCeRJf1913
         x68cXPgjrdxtQ==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

When migrating a range of system memory to device private memory, some
of the pages in the address range may not be migrating. In this case,
the non migrating pages won't have a new GPU MMU entry to store but
the nvif_object_ioctl() NVIF_VMM_V0_PFNMAP method doesn't check the input
and stores a bad valid GPU page table entry.
Fix this by skipping the invalid input PTEs when updating the GPU page
tables.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c b/drivers/g=
pu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
index ed37fddd063f..7eabe9fe0d2b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
@@ -79,8 +79,12 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu_=
pt *pt,
 	dma_addr_t addr;
=20
 	nvkm_kmap(pt->memory);
-	while (ptes--) {
+	for (; ptes; ptes--, map->pfn++) {
 		u64 data =3D 0;
+
+		if (!(*map->pfn & NVKM_VMM_PFN_V))
+			continue;
+
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
@@ -100,7 +104,6 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu=
_pt *pt,
 		}
=20
 		VMM_WO064(pt, vmm, ptei++ * 8, data);
-		map->pfn++;
 	}
 	nvkm_done(pt->memory);
 }
@@ -310,9 +313,12 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm, struct nvkm_mm=
u_pt *pt,
 	dma_addr_t addr;
=20
 	nvkm_kmap(pt->memory);
-	while (ptes--) {
+	for (; ptes; ptes--, map->pfn++) {
 		u64 data =3D 0;
=20
+		if (!(*map->pfn & NVKM_VMM_PFN_V))
+			continue;
+
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
@@ -332,7 +338,6 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu=
_pt *pt,
 		}
=20
 		VMM_WO064(pt, vmm, ptei++ * 16, data);
-		map->pfn++;
 	}
 	nvkm_done(pt->memory);
 }
--=20
2.20.1

