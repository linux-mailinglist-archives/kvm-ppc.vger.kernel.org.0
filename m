Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A081D280662
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Oct 2020 20:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbgJASRl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Oct 2020 14:17:41 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17840 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgJASRf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Oct 2020 14:17:35 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f761cd70000>; Thu, 01 Oct 2020 11:15:51 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 1 Oct
 2020 18:17:29 +0000
Received: from rcampbell-dev.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Thu, 1 Oct 2020 18:17:29 +0000
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>, <kvm-ppc@vger.kernel.org>,
        <nouveau@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
CC:     Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Bharata B Rao" <bharata@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>
Subject: [RFC PATCH v3 1/2] ext4/xfs: add page refcount helper
Date:   Thu, 1 Oct 2020 11:17:14 -0700
Message-ID: <20201001181715.17416-2-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201001181715.17416-1-rcampbell@nvidia.com>
References: <20201001181715.17416-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601576151; bh=VLAy80mbYwI3MPUr9LJsjYSkzab7kMcONlGXWDVu9v8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=nW+GVezOz/M9Txi1Yse02hBAzQayHj45arMn9Dk/rcArxmstJCArmfkr/5URM8Cr4
         q0wJaU0vGAxW9OSp1AD8Ulk7Td9/1/RlOT2ybex8u6Kxc+GvXHVTO8jlA5kSO2nnJp
         U6/Yn3xANUa++i6p4aruXgAPBzO3S+BGx8fPXGGzvnEIDnPehQGqWZHr9vZfRWeFc5
         3vI/f0hWKXDcyfPFobbclf1ZDZ+Pvo9F4WrTi7iaGHl690+FfyTOnmpz7UAGqbRmaD
         gzrwhLQN8QdoygvXTCRtvdoq7iNd4FXkZLYk4WYAdFyz6Gp1UVMN43XRVGvmFCJZld
         ceHs5YJI58Ebg==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There are several places where ZONE_DEVICE struct pages assume a reference
count =3D=3D 1 means the page is idle and free. Instead of open coding this=
,
add a helper function to hide this detail.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
---
 fs/dax.c            |  4 ++--
 fs/ext4/inode.c     |  5 +----
 fs/xfs/xfs_file.c   |  4 +---
 include/linux/dax.h | 10 ++++++++++
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5b47834f2e1b..85c63f735909 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -358,7 +358,7 @@ static void dax_disassociate_entry(void *entry, struct =
address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page =3D pfn_to_page(pfn);
=20
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(trunc && !dax_layout_is_idle_page(page));
 		WARN_ON_ONCE(page->mapping && page->mapping !=3D mapping);
 		page->mapping =3D NULL;
 		page->index =3D 0;
@@ -372,7 +372,7 @@ static struct page *dax_busy_page(void *entry)
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page =3D pfn_to_page(pfn);
=20
-		if (page_ref_count(page) > 1)
+		if (!dax_layout_is_idle_page(page))
 			return page;
 	}
 	return NULL;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bf596467c234..4c3b80e68121 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3926,10 +3926,7 @@ int ext4_break_layouts(struct inode *inode)
 		if (!page)
 			return 0;
=20
-		error =3D ___wait_var_event(&page->_refcount,
-				atomic_read(&page->_refcount) =3D=3D 1,
-				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(ei));
+		error =3D dax_wait_page(ei, page, ext4_wait_dax_page);
 	} while (error =3D=3D 0);
=20
 	return error;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3d1b95124744..a5304aaeaa3a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -749,9 +749,7 @@ xfs_break_dax_layouts(
 		return 0;
=20
 	*retry =3D true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) =3D=3D 1, TASK_INTERRUPTIBLE,
-			0, 0, xfs_wait_dax_page(inode));
+	return dax_wait_page(inode, page, xfs_wait_dax_page);
 }
=20
 int
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b52f084aa643..f906cf4db1cc 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -243,6 +243,16 @@ static inline bool dax_mapping(struct address_space *m=
apping)
 	return mapping->host && IS_DAX(mapping->host);
 }
=20
+static inline bool dax_layout_is_idle_page(struct page *page)
+{
+	return page_ref_count(page) =3D=3D 1;
+}
+
+#define dax_wait_page(_inode, _page, _wait_cb)				\
+	___wait_var_event(&(_page)->_refcount,				\
+		dax_layout_is_idle_page(_page),				\
+		TASK_INTERRUPTIBLE, 0, 0, _wait_cb(_inode))
+
 #ifdef CONFIG_DEV_DAX_HMEM_DEVICES
 void hmem_register_device(int target_nid, struct resource *r);
 #else
--=20
2.20.1

