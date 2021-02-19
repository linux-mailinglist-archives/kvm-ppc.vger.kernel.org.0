Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B779B31F3E0
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 03:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhBSCIv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Feb 2021 21:08:51 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12047 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhBSCIv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 18 Feb 2021 21:08:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602f1d8a0000>; Thu, 18 Feb 2021 18:08:10 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 19 Feb
 2021 02:08:09 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, <jgg@nvidia.com>, <hch@infradead.org>,
        <daniel@ffwll.ch>, Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 3/4] nouveau/svm: Refactor nouveau_range_fault
Date:   Fri, 19 Feb 2021 13:07:49 +1100
Message-ID: <20210219020750.16444-4-apopple@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210219020750.16444-1-apopple@nvidia.com>
References: <20210219020750.16444-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613700490; bh=IDt/w91IyQ/+IVJx/VBVmCwlFW3knn/F3DU7wj6KD1M=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jDSKRchWDe0vv8BCZc3iKUl/ACudAdFotBemvBuqVBEcZD0wuQTt9itLGYNGYhCJa
         qabo+ILCKFybU11p/wWCEHsuEK8AHyyvMsqXe7AJQvE31a0kxiNbQ0Bwu/Q+0hyVQQ
         WbEGEMhm+Q0sSmOa8wOcNmwq7cv38qf2tR2zAkKhW/gwO3/vWE8g5hbjZYExCduKbq
         dv3pl6T2Vm6FQBweW/7WqZOnjg09yVlZWb5KECqVFeC9mYcuAPQ6hPT/Z+4QmS1rCR
         wGT53h3QwOdJYgksTPrFuYGxP3J/+LPreoA3qn1bgMH7W86ehdDzcjNwHni41LYR4u
         Ny1yYzAgLgBNA==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Call mmu_interval_notifier_insert() as part of nouveau_range_fault().
This doesn't introduce any functional change but makes it easier for a
subsequent patch to alter the behaviour of nouveau_range_fault() to
support GPU atomic operations.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 34 ++++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouvea=
u/nouveau_svm.c
index f18bd53da052..cd7b47c946cf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -567,18 +567,27 @@ static int nouveau_range_fault(struct nouveau_svmm *s=
vmm,
 	unsigned long hmm_pfns[1];
 	struct hmm_range range =3D {
 		.notifier =3D &notifier->notifier,
-		.start =3D notifier->notifier.interval_tree.start,
-		.end =3D notifier->notifier.interval_tree.last + 1,
 		.default_flags =3D hmm_flags,
 		.hmm_pfns =3D hmm_pfns,
 		.dev_private_owner =3D drm->dev,
 	};
-	struct mm_struct *mm =3D notifier->notifier.mm;
+	struct mm_struct *mm =3D svmm->notifier.mm;
 	int ret;
=20
+	ret =3D mmu_interval_notifier_insert(&notifier->notifier, mm,
+					args->p.addr, args->p.size,
+					&nouveau_svm_mni_ops);
+	if (ret)
+		return ret;
+
+	range.start =3D notifier->notifier.interval_tree.start;
+	range.end =3D notifier->notifier.interval_tree.last + 1;
+
 	while (true) {
-		if (time_after(jiffies, timeout))
-			return -EBUSY;
+		if (time_after(jiffies, timeout)) {
+			ret =3D -EBUSY;
+			goto out;
+		}
=20
 		range.notifier_seq =3D mmu_interval_read_begin(range.notifier);
 		mmap_read_lock(mm);
@@ -587,7 +596,7 @@ static int nouveau_range_fault(struct nouveau_svmm *svm=
m,
 		if (ret) {
 			if (ret =3D=3D -EBUSY)
 				continue;
-			return ret;
+			goto out;
 		}
=20
 		mutex_lock(&svmm->mutex);
@@ -606,6 +615,9 @@ static int nouveau_range_fault(struct nouveau_svmm *svm=
m,
 	svmm->vmm->vmm.object.client->super =3D false;
 	mutex_unlock(&svmm->mutex);
=20
+out:
+	mmu_interval_notifier_remove(&notifier->notifier);
+
 	return ret;
 }
=20
@@ -727,14 +739,8 @@ nouveau_svm_fault(struct nvif_notify *notify)
 		}
=20
 		notifier.svmm =3D svmm;
-		ret =3D mmu_interval_notifier_insert(&notifier.notifier, mm,
-						   args.i.p.addr, args.i.p.size,
-						   &nouveau_svm_mni_ops);
-		if (!ret) {
-			ret =3D nouveau_range_fault(svmm, svm->drm, &args.i,
-				sizeof(args), hmm_flags, &notifier);
-			mmu_interval_notifier_remove(&notifier.notifier);
-		}
+		ret =3D nouveau_range_fault(svmm, svm->drm, &args.i,
+					sizeof(args), hmm_flags, &notifier);
 		mmput(mm);
=20
 		limit =3D args.i.p.addr + args.i.p.size;
--=20
2.20.1

