Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ED4314557
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 02:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhBIBK3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Feb 2021 20:10:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9773 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhBIBK0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Feb 2021 20:10:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021e0da0002>; Mon, 08 Feb 2021 17:09:46 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 01:09:45 +0000
Received: from localhost (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021 01:09:45
 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, "Alistair Popple" <apopple@nvidia.com>
Subject: [PATCH 8/9] nouveau/dmem: Add support for multiple page types
Date:   Tue, 9 Feb 2021 12:07:21 +1100
Message-ID: <20210209010722.13839-9-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209010722.13839-1-apopple@nvidia.com>
References: <20210209010722.13839-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612832986; bh=7iHwtR9sau7241FKCrgteBkrT9cHXs6BLCPTLWgKcXQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=VKRG5N9NY9ae9S7GkfqgricGvo5ZGs2UBfcbmWhnNfa6uuRK5Oi4wNrQhOYQjkYs5
         CtYJHlMQmzVd2GcxxcWItL2jNHWW0zO+4uoMRB4r/Mg1zI+NQBo4KEUztggcr/nOaa
         NxPUZ84dy/ZQRoeSStEePDecVkKIGsgW3/eDkS6lakAMbXLykzTozQj8RgBXyst0It
         bv4Lx4xAnRZfRkKbGIwOihbwBewLn6XMpOhiTSFfOvbktrB5fv5cMMDJ0eFcECGyG7
         m+P9i28q28Ovin8mEgLRLtMysXyi/8arOL1T9Xf7Alt9GnBQWEodaOJ7g4rsh67f1x
         ZmdyxxPwBzagw==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Device private pages are used to track a per-page migrate_to_ram()
callback which is called when the CPU attempts to access a GPU page from
the CPU. Currently the same callback is used for all GPU pages tracked
by Nouveau. However a future patch requires support for calling a
different callback when accessing some GPU pages.

This patch extends the existing Nouveau device private page allocator to
make it easier to allocate device private pages with different callbacks
but should not introduce any functional changes.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 27 ++++++++++++++------------
 drivers/gpu/drm/nouveau/nouveau_dmem.h |  5 +++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouve=
au/nouveau_dmem.c
index 9579bd001f11..8fb4949f3778 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -67,6 +67,7 @@ struct nouveau_dmem_chunk {
 	struct nouveau_bo *bo;
 	struct nouveau_drm *drm;
 	unsigned long callocated;
+	enum nouveau_dmem_type type;
 	struct dev_pagemap pagemap;
 };
=20
@@ -81,7 +82,7 @@ struct nouveau_dmem {
 	struct nouveau_dmem_migrate migrate;
 	struct list_head chunks;
 	struct mutex mutex;
-	struct page *free_pages;
+	struct page *free_pages[NOUVEAU_DMEM_NTYPES];
 	spinlock_t lock;
 };
=20
@@ -112,8 +113,8 @@ static void nouveau_dmem_page_free(struct page *page)
 	struct nouveau_dmem *dmem =3D chunk->drm->dmem;
=20
 	spin_lock(&dmem->lock);
-	page->zone_device_data =3D dmem->free_pages;
-	dmem->free_pages =3D page;
+	page->zone_device_data =3D dmem->free_pages[chunk->type];
+	dmem->free_pages[chunk->type] =3D page;
=20
 	WARN_ON(!chunk->callocated);
 	chunk->callocated--;
@@ -224,7 +225,8 @@ static const struct dev_pagemap_ops nouveau_dmem_pagema=
p_ops =3D {
 };
=20
 static int
-nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage)
+nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struct page **ppage,
+	enum nouveau_dmem_type type)
 {
 	struct nouveau_dmem_chunk *chunk;
 	struct resource *res;
@@ -248,6 +250,7 @@ nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struc=
t page **ppage)
 	}
=20
 	chunk->drm =3D drm;
+	chunk->type =3D type;
 	chunk->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
 	chunk->pagemap.range.start =3D res->start;
 	chunk->pagemap.range.end =3D res->end;
@@ -279,8 +282,8 @@ nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, struc=
t page **ppage)
 	page =3D pfn_to_page(pfn_first);
 	spin_lock(&drm->dmem->lock);
 	for (i =3D 0; i < DMEM_CHUNK_NPAGES - 1; ++i, ++page) {
-		page->zone_device_data =3D drm->dmem->free_pages;
-		drm->dmem->free_pages =3D page;
+		page->zone_device_data =3D drm->dmem->free_pages[type];
+		drm->dmem->free_pages[type] =3D page;
 	}
 	*ppage =3D page;
 	chunk->callocated++;
@@ -304,22 +307,22 @@ nouveau_dmem_chunk_alloc(struct nouveau_drm *drm, str=
uct page **ppage)
 }
=20
 static struct page *
-nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
+nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm, enum nouveau_dmem_=
type type)
 {
 	struct nouveau_dmem_chunk *chunk;
 	struct page *page =3D NULL;
 	int ret;
=20
 	spin_lock(&drm->dmem->lock);
-	if (drm->dmem->free_pages) {
-		page =3D drm->dmem->free_pages;
-		drm->dmem->free_pages =3D page->zone_device_data;
+	if (drm->dmem->free_pages[type]) {
+		page =3D drm->dmem->free_pages[type];
+		drm->dmem->free_pages[type] =3D page->zone_device_data;
 		chunk =3D nouveau_page_to_chunk(page);
 		chunk->callocated++;
 		spin_unlock(&drm->dmem->lock);
 	} else {
 		spin_unlock(&drm->dmem->lock);
-		ret =3D nouveau_dmem_chunk_alloc(drm, &page);
+		ret =3D nouveau_dmem_chunk_alloc(drm, &page, type);
 		if (ret)
 			return NULL;
 	}
@@ -577,7 +580,7 @@ static unsigned long nouveau_dmem_migrate_copy_one(stru=
ct nouveau_drm *drm,
 	if (!(src & MIGRATE_PFN_MIGRATE))
 		goto out;
=20
-	dpage =3D nouveau_dmem_page_alloc_locked(drm);
+	dpage =3D nouveau_dmem_page_alloc_locked(drm, NOUVEAU_DMEM);
 	if (!dpage)
 		goto out;
=20
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.h b/drivers/gpu/drm/nouve=
au/nouveau_dmem.h
index 64da5d3635c8..02e261c4acf1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.h
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.h
@@ -28,6 +28,11 @@ struct nouveau_drm;
 struct nouveau_svmm;
 struct hmm_range;
=20
+enum nouveau_dmem_type {
+	NOUVEAU_DMEM,
+	NOUVEAU_DMEM_NTYPES, /* Number of types, must be last */
+};
+
 #if IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM)
 void nouveau_dmem_init(struct nouveau_drm *);
 void nouveau_dmem_fini(struct nouveau_drm *);
--=20
2.20.1

