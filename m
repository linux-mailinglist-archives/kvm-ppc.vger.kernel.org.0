Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C767132CCAB
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Mar 2021 07:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhCDGSE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Mar 2021 01:18:04 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4553 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbhCDGR5 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 4 Mar 2021 01:17:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60407b6d0000>; Wed, 03 Mar 2021 22:17:17 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 06:17:17 +0000
Received: from localhost (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar 2021 06:17:16
 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, "Alistair Popple" <apopple@nvidia.com>
Subject: [PATCH v4 8/8] nouveau/svm: Implement atomic SVM access
Date:   Thu, 4 Mar 2021 17:16:45 +1100
Message-ID: <20210304061645.29747-9-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304061645.29747-1-apopple@nvidia.com>
References: <20210304061645.29747-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614838637; bh=qO4yC80uoEqn5XcAiLxVhRuuZamrwUlLIEsRNkFlf1Q=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=GsQLvPfRvQRfmqf8mKuT920WEkX5vWtgMSh+eV/98GjyrC6JKLo2eo6Yt+DLanQtF
         IswaFaECLMY1ZolVCUdDD8DV1pf+e/MpArqMrNIVm5DD+FJAXlLYk5h2lgvK2jkZvm
         F5V3ndKC+Fxo4wdES41b0yxarlcn3yXtR64Dc+91eE5tODMlABwAcbTPE1T7xduP60
         xZ7OmmDg4X7xwfmh5BFITiCh9iUzg1n5dazObwwoJQXJFMTFG8UTKm97W29zUcxUsh
         ClcLGfneipAKeHx8lFzI+rb5wJ7h4VZaxETbcJh6ovoy3Au1arwgUwvfZMsQS4eAKh
         z8x1fii0ZDRvw==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Some NVIDIA GPUs do not support direct atomic access to system memory
via PCIe. Instead this must be emulated by granting the GPU exclusive
access to the memory. This is achieved by replacing CPU page table
entries with special swap entries that fault on userspace access.

The driver then grants the GPU permission to update the page undergoing
atomic access via the GPU page tables. When CPU access to the page is
required a CPU fault is raised which calls into the device driver via
MMU notifiers to revoke the atomic access. The original page table
entries are then restored allowing CPU access to proceed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

v4:
* Check that page table entries haven't changed before mapping on the
  device
---
 drivers/gpu/drm/nouveau/include/nvif/if000c.h |   1 +
 drivers/gpu/drm/nouveau/nouveau_svm.c         | 107 ++++++++++++++++--
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h |   1 +
 .../drm/nouveau/nvkm/subdev/mmu/vmmgp100.c    |   6 +
 4 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvif/if000c.h b/drivers/gpu/dr=
m/nouveau/include/nvif/if000c.h
index d6dd40f21eed..9c7ff56831c5 100644
--- a/drivers/gpu/drm/nouveau/include/nvif/if000c.h
+++ b/drivers/gpu/drm/nouveau/include/nvif/if000c.h
@@ -77,6 +77,7 @@ struct nvif_vmm_pfnmap_v0 {
 #define NVIF_VMM_PFNMAP_V0_APER                           0x00000000000000=
f0ULL
 #define NVIF_VMM_PFNMAP_V0_HOST                           0x00000000000000=
00ULL
 #define NVIF_VMM_PFNMAP_V0_VRAM                           0x00000000000000=
10ULL
+#define NVIF_VMM_PFNMAP_V0_A				  0x0000000000000004ULL
 #define NVIF_VMM_PFNMAP_V0_W                              0x00000000000000=
02ULL
 #define NVIF_VMM_PFNMAP_V0_V                              0x00000000000000=
01ULL
 #define NVIF_VMM_PFNMAP_V0_NONE                           0x00000000000000=
00ULL
diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouvea=
u/nouveau_svm.c
index cd7b47c946cf..6d24424770e4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -35,6 +35,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sort.h>
 #include <linux/hmm.h>
+#include <linux/rmap.h>
=20
 struct nouveau_svm {
 	struct nouveau_drm *drm;
@@ -421,9 +422,9 @@ nouveau_svm_fault_cmp(const void *a, const void *b)
 		return ret;
 	if ((ret =3D (s64)fa->addr - fb->addr))
 		return ret;
-	/*XXX: atomic? */
-	return (fa->access =3D=3D 0 || fa->access =3D=3D 3) -
-	       (fb->access =3D=3D 0 || fb->access =3D=3D 3);
+	/* Atomic access (2) has highest priority */
+	return (-1*(fa->access =3D=3D 2) + (fa->access =3D=3D 0 || fa->access =3D=
=3D 3)) -
+	       (-1*(fb->access =3D=3D 2) + (fb->access =3D=3D 0 || fb->access =3D=
=3D 3));
 }
=20
 static void
@@ -555,6 +556,84 @@ static void nouveau_hmm_convert_pfn(struct nouveau_drm=
 *drm,
 		args->p.phys[0] |=3D NVIF_VMM_PFNMAP_V0_W;
 }
=20
+static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
+			       struct nouveau_drm *drm,
+			       struct nouveau_pfnmap_args *args, u32 size,
+			       struct svm_notifier *notifier)
+{
+	unsigned long timeout =3D
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	struct mm_struct *mm =3D svmm->notifier.mm;
+	struct page *page;
+	unsigned long start =3D args->p.addr;
+	unsigned long notifier_seq;
+	int ret =3D 0;
+
+	ret =3D mmu_interval_notifier_insert(&notifier->notifier, mm,
+					args->p.addr, args->p.size,
+					&nouveau_svm_mni_ops);
+	if (ret)
+		return ret;
+
+	mmap_read_lock(mm);
+	make_device_exclusive_range(mm, start, start + PAGE_SIZE, &page);
+	mmap_read_unlock(mm);
+	if (!page) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	while (true) {
+		if (time_after(jiffies, timeout)) {
+			ret =3D -EBUSY;
+			goto out;
+		}
+
+		notifier_seq =3D mmu_interval_read_begin(&notifier->notifier);
+		if (!check_device_exclusive_range(mm, start, start + PAGE_SIZE,
+						  &page)) {
+			mmap_read_lock(mm);
+			make_device_exclusive_range(mm, start,
+						    start + PAGE_SIZE, &page);
+			mmap_read_unlock(mm);
+			if (!page) {
+				ret =3D -EINVAL;
+				goto out;
+			}
+			continue;
+		}
+		mutex_lock(&svmm->mutex);
+		if (mmu_interval_read_retry(&notifier->notifier,
+					    notifier_seq)) {
+			mutex_unlock(&svmm->mutex);
+			continue;
+		}
+		break;
+	}
+
+	/* Map the page on the GPU. */
+	args->p.page =3D 12;
+	args->p.size =3D PAGE_SIZE;
+	args->p.addr =3D start;
+	args->p.phys[0] =3D page_to_phys(page) |
+		NVIF_VMM_PFNMAP_V0_V |
+		NVIF_VMM_PFNMAP_V0_W |
+		NVIF_VMM_PFNMAP_V0_A |
+		NVIF_VMM_PFNMAP_V0_HOST;
+
+	svmm->vmm->vmm.object.client->super =3D true;
+	ret =3D nvif_object_ioctl(&svmm->vmm->vmm.object, args, size, NULL);
+	svmm->vmm->vmm.object.client->super =3D false;
+	mutex_unlock(&svmm->mutex);
+
+	unlock_page(page);
+	put_page(page);
+
+out:
+	mmu_interval_notifier_remove(&notifier->notifier);
+	return ret;
+}
+
 static int nouveau_range_fault(struct nouveau_svmm *svmm,
 			       struct nouveau_drm *drm,
 			       struct nouveau_pfnmap_args *args, u32 size,
@@ -637,7 +716,7 @@ nouveau_svm_fault(struct nvif_notify *notify)
 	unsigned long hmm_flags;
 	u64 inst, start, limit;
 	int fi, fn;
-	int replay =3D 0, ret;
+	int replay =3D 0, atomic =3D 0, ret;
=20
 	/* Parse available fault buffer entries into a cache, and update
 	 * the GET pointer so HW can reuse the entries.
@@ -718,12 +797,14 @@ nouveau_svm_fault(struct nvif_notify *notify)
 		/*
 		 * Determine required permissions based on GPU fault
 		 * access flags.
-		 * XXX: atomic?
 		 */
 		switch (buffer->fault[fi]->access) {
 		case 0: /* READ. */
 			hmm_flags =3D HMM_PFN_REQ_FAULT;
 			break;
+		case 2: /* ATOMIC. */
+			atomic =3D true;
+			break;
 		case 3: /* PREFETCH. */
 			hmm_flags =3D 0;
 			break;
@@ -739,8 +820,14 @@ nouveau_svm_fault(struct nvif_notify *notify)
 		}
=20
 		notifier.svmm =3D svmm;
-		ret =3D nouveau_range_fault(svmm, svm->drm, &args.i,
-					sizeof(args), hmm_flags, &notifier);
+		if (atomic)
+			ret =3D nouveau_atomic_range_fault(svmm, svm->drm,
+							 &args.i, sizeof(args),
+							 &notifier);
+		else
+			ret =3D nouveau_range_fault(svmm, svm->drm, &args.i,
+						  sizeof(args), hmm_flags,
+						  &notifier);
 		mmput(mm);
=20
 		limit =3D args.i.p.addr + args.i.p.size;
@@ -760,7 +847,11 @@ nouveau_svm_fault(struct nvif_notify *notify)
 			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_V)) ||
 			    (buffer->fault[fi]->access !=3D 0 /* READ. */ &&
 			     buffer->fault[fi]->access !=3D 3 /* PREFETCH. */ &&
-			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_W)))
+			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_W)) ||
+			    (buffer->fault[fi]->access !=3D 0 /* READ. */ &&
+			     buffer->fault[fi]->access !=3D 1 /* WRITE. */ &&
+			     buffer->fault[fi]->access !=3D 3 /* PREFETCH. */ &&
+			     !(args.phys[0] & NVIF_VMM_PFNMAP_V0_A)))
 				break;
 		}
=20
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h b/drivers/gpu/dr=
m/nouveau/nvkm/subdev/mmu/vmm.h
index a2b179568970..f6188aa9171c 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.h
@@ -178,6 +178,7 @@ void nvkm_vmm_unmap_region(struct nvkm_vmm *, struct nv=
km_vma *);
 #define NVKM_VMM_PFN_APER                                 0x00000000000000=
f0ULL
 #define NVKM_VMM_PFN_HOST                                 0x00000000000000=
00ULL
 #define NVKM_VMM_PFN_VRAM                                 0x00000000000000=
10ULL
+#define NVKM_VMM_PFN_A					  0x0000000000000004ULL
 #define NVKM_VMM_PFN_W                                    0x00000000000000=
02ULL
 #define NVKM_VMM_PFN_V                                    0x00000000000000=
01ULL
 #define NVKM_VMM_PFN_NONE                                 0x00000000000000=
00ULL
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c b/drivers/g=
pu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
index 236db5570771..f02abd9cb4dd 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmmgp100.c
@@ -88,6 +88,9 @@ gp100_vmm_pgt_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu_p=
t *pt,
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
+		if (!(*map->pfn & NVKM_VMM_PFN_A))
+			data |=3D BIT_ULL(7); /* Atomic disable. */
+
 		if (!(*map->pfn & NVKM_VMM_PFN_VRAM)) {
 			addr =3D *map->pfn >> NVKM_VMM_PFN_ADDR_SHIFT;
 			addr =3D dma_map_page(dev, pfn_to_page(addr), 0,
@@ -322,6 +325,9 @@ gp100_vmm_pd0_pfn(struct nvkm_vmm *vmm, struct nvkm_mmu=
_pt *pt,
 		if (!(*map->pfn & NVKM_VMM_PFN_W))
 			data |=3D BIT_ULL(6); /* RO. */
=20
+		if (!(*map->pfn & NVKM_VMM_PFN_A))
+			data |=3D BIT_ULL(7); /* Atomic disable. */
+
 		if (!(*map->pfn & NVKM_VMM_PFN_VRAM)) {
 			addr =3D *map->pfn >> NVKM_VMM_PFN_ADDR_SHIFT;
 			addr =3D dma_map_page(dev, pfn_to_page(addr), 0,
--=20
2.20.1

