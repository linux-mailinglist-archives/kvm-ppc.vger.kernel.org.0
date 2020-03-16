Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6432118735D
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbgCPTc2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:32:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732473AbgCPTc1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:32:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4gaTFJs/l9N8IeQMQi7DOyHD1CPLDY/nz5Zeu/uMNCU=; b=oEHEcwlD88rLBGohYprCQEAAgf
        HCglg57j6YbWxMQ22C8YyUXtRbsGd1W/FJ1f793/E+7o8EC3qy/ThsQ9MEqZTb9oL/KRVqjarX3o5
        VGJMJpnkyaCqfdcxcNDeqGKflR3tAaU4Mvz0Z7dXn4raeJeEz2Mu097skFYa2NmSkHL/Yb/UZeX/x
        dLst1Tr1iwFwkUj0h8I3nbwlnxyWkTyNyehKoWvsHFLSc6M73sLPL09j41pPjGNP3XofxH1N7AYVS
        puYeetoypX8PAC2xhtd239cqs6kbXSpXceIk27vNdraVVTe7pU9R3Uzmy/eUwcQ4Shv5Phg5NXgsN
        p8K8zWoA==;
Received: from [2001:4bb8:188:30cd:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jDvTI-0003bC-LS; Mon, 16 Mar 2020 19:32:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Cc:     Jerome Glisse <jglisse@redhat.com>, kvm-ppc@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-mm@kvack.org
Subject: [PATCH 1/4] memremap: add an owner field to struct dev_pagemap
Date:   Mon, 16 Mar 2020 20:32:13 +0100
Message-Id: <20200316193216.920734-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316193216.920734-1-hch@lst.de>
References: <20200316193216.920734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a new opaque owner field to struct dev_pagemap, which will allow
the hmm and migrate_vma code to identify who owns ZONE_DEVICE memory,
and refuse to work on mappings not owned by the calling entity.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c     | 2 ++
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 1 +
 include/linux/memremap.h               | 4 ++++
 mm/memremap.c                          | 4 ++++
 4 files changed, 11 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 79b1202b1c62..67fefb03b9b7 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -779,6 +779,8 @@ int kvmppc_uvmem_init(void)
 	kvmppc_uvmem_pgmap.type = MEMORY_DEVICE_PRIVATE;
 	kvmppc_uvmem_pgmap.res = *res;
 	kvmppc_uvmem_pgmap.ops = &kvmppc_uvmem_ops;
+	/* just one global instance: */
+	kvmppc_uvmem_pgmap.owner = &kvmppc_uvmem_pgmap;
 	addr = memremap_pages(&kvmppc_uvmem_pgmap, NUMA_NO_NODE);
 	if (IS_ERR(addr)) {
 		ret = PTR_ERR(addr);
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 0ad5d87b5a8e..a4682272586e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -526,6 +526,7 @@ nouveau_dmem_init(struct nouveau_drm *drm)
 	drm->dmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
 	drm->dmem->pagemap.res = *res;
 	drm->dmem->pagemap.ops = &nouveau_dmem_pagemap_ops;
+	drm->dmem->pagemap.owner = drm->dev;
 	if (IS_ERR(devm_memremap_pages(device, &drm->dmem->pagemap)))
 		goto out_free;
 
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 6fefb09af7c3..60d97e8fd3c0 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -103,6 +103,9 @@ struct dev_pagemap_ops {
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @ops: method table
+ * @owner: an opaque pointer identifying the entity that manages this
+ *	instance.  Used by various helpers to make sure that no
+ *	foreign ZONE_DEVICE memory is accessed.
  */
 struct dev_pagemap {
 	struct vmem_altmap altmap;
@@ -113,6 +116,7 @@ struct dev_pagemap {
 	enum memory_type type;
 	unsigned int flags;
 	const struct dev_pagemap_ops *ops;
+	void *owner;
 };
 
 static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
diff --git a/mm/memremap.c b/mm/memremap.c
index 09b5b7adc773..9b2c97ceb775 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -181,6 +181,10 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 			WARN(1, "Missing migrate_to_ram method\n");
 			return ERR_PTR(-EINVAL);
 		}
+		if (!pgmap->owner) {
+			WARN(1, "Missing owner\n");
+			return ERR_PTR(-EINVAL);
+		}
 		break;
 	case MEMORY_DEVICE_FS_DAX:
 		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
-- 
2.24.1

