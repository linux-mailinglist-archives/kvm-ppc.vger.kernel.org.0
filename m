Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF98C314552
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 Feb 2021 02:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBIBKX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Feb 2021 20:10:23 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6629 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhBIBKR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Feb 2021 20:10:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021e0d10000>; Mon, 08 Feb 2021 17:09:37 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 01:09:36 +0000
Received: from localhost (172.20.145.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021 01:09:36
 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, "Alistair Popple" <apopple@nvidia.com>
Subject: [PATCH 5/9] hmm-tests: Add test for unmap and pin
Date:   Tue, 9 Feb 2021 12:07:18 +1100
Message-ID: <20210209010722.13839-6-apopple@nvidia.com>
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
        t=1612832977; bh=eX6MwlujUfKQJ41uDmpXkpSxuNOWqBqcyMk+9htUm4I=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZUvc6YKwpnF7J4Z7k4xQ9aVuBZ46oSRqSppWJIki35wS/IAu4LBbCO/dUkdeEVXL/
         wBHqQ1XO0ZV2IHKJrqnyhrPM7QerfJ4Uwpa20mtIZGPiIj4AC4phTspMsvzcFN8y6/
         /PVwslkyzXJmcdYHReSOHdlp6tsXxixwP9zm0B43laeT9TI1YRV0fMyTo0As6ItNAJ
         WHIqhCbx3m6af9VX9unRQtMEXsKIlAHyjZlfohaE2wGbbCstX/KnIGflWQ4W5vj6e+
         M42Oh6R/N2rRhBjQs6mRLp7bbxWRmJqYH8njZ8H89vtZsRoRL+xvCXYfM97St2ClLq
         WMd2ksOkhewKw==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Adds a basic test of the HMM unmap and pin operation.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 lib/test_hmm.c                         | 107 +++++++++++++++++++++----
 lib/test_hmm_uapi.h                    |   1 +
 tools/testing/selftests/vm/hmm-tests.c |  49 +++++++++++
 3 files changed, 140 insertions(+), 17 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 98848b96ff09..c78a473250a3 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -46,6 +46,7 @@ struct dmirror_bounce {
 	unsigned long		cpages;
 };
=20
+#define DPT_XA_TAG_ATOMIC 1UL
 #define DPT_XA_TAG_WRITE 3UL
=20
 /*
@@ -83,6 +84,7 @@ struct dmirror_device {
 	struct cdev		cdevice;
 	struct hmm_devmem	*devmem;
=20
+	unsigned int		devmem_faults;
 	unsigned int		devmem_capacity;
 	unsigned int		devmem_count;
 	struct dmirror_chunk	**devmem_chunks;
@@ -203,8 +205,18 @@ static void dmirror_do_update(struct dmirror *dmirror,=
 unsigned long start,
 	 * Therefore, it is OK to just clear the entry.
 	 */
 	xa_for_each_range(&dmirror->pt, pfn, entry, start >> PAGE_SHIFT,
-			  end >> PAGE_SHIFT)
+			  end >> PAGE_SHIFT) {
+		/*
+		 * Typically this would be done in devmap free page, but as
+		 * we're using the XArray to store the reference to the original
+		 * page do it here as it doesn't matter if clean up of the
+		 * pinned page is delayed.
+		 */
+		if (xa_pointer_tag(entry) =3D=3D DPT_XA_TAG_ATOMIC)
+			unpin_user_page(xa_untag_pointer(entry));
+
 		xa_erase(&dmirror->pt, pfn);
+	}
 }
=20
 static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
@@ -571,7 +583,8 @@ static struct page *dmirror_devmem_alloc_page(struct dm=
irror_device *mdevice)
 }
=20
 static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
-					   struct dmirror *dmirror)
+					   struct dmirror *dmirror,
+					   int allow_ref)
 {
 	struct dmirror_device *mdevice =3D dmirror->mdevice;
 	const unsigned long *src =3D args->src;
@@ -598,9 +611,17 @@ static void dmirror_migrate_alloc_and_copy(struct migr=
ate_vma *args,
 			continue;
=20
 		rpage =3D dpage->zone_device_data;
-		if (spage)
+		if (spage && !(*src & MIGRATE_PFN_PIN))
 			copy_highpage(rpage, spage);
 		else
+			/*
+			 * In the MIGRATE_PFN_PIN case we don't really
+			 * need rpage at all because the existing page is
+			 * staying in place and will be mapped. However we need
+			 * somewhere to store dmirror and that place is
+			 * rpage->zone_device_data so we keep it for
+			 * simplicity.
+			 */
 			clear_highpage(rpage);
=20
 		/*
@@ -620,7 +641,8 @@ static void dmirror_migrate_alloc_and_copy(struct migra=
te_vma *args,
 }
=20
 static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
-					    struct dmirror *dmirror)
+					    struct dmirror *dmirror,
+					    int allow_ref)
 {
 	unsigned long start =3D args->start;
 	unsigned long end =3D args->end;
@@ -647,8 +669,14 @@ static int dmirror_migrate_finalize_and_map(struct mig=
rate_vma *args,
 		 * Store the page that holds the data so the page table
 		 * doesn't have to deal with ZONE_DEVICE private pages.
 		 */
-		entry =3D dpage->zone_device_data;
-		if (*dst & MIGRATE_PFN_WRITE)
+		if (*src & MIGRATE_PFN_PIN)
+			entry =3D migrate_pfn_to_page(*src);
+		else
+			entry =3D dpage->zone_device_data;
+
+		if (*src & MIGRATE_PFN_PIN)
+			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_ATOMIC);
+		else if (*dst & MIGRATE_PFN_WRITE)
 			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 		entry =3D xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
 		if (xa_is_err(entry)) {
@@ -662,7 +690,8 @@ static int dmirror_migrate_finalize_and_map(struct migr=
ate_vma *args,
 }
=20
 static int dmirror_migrate(struct dmirror *dmirror,
-			   struct hmm_dmirror_cmd *cmd)
+			   struct hmm_dmirror_cmd *cmd,
+			   int allow_ref)
 {
 	unsigned long start, end, addr;
 	unsigned long size =3D cmd->npages << PAGE_SHIFT;
@@ -673,7 +702,7 @@ static int dmirror_migrate(struct dmirror *dmirror,
 	struct dmirror_bounce bounce;
 	struct migrate_vma args;
 	unsigned long next;
-	int ret;
+	int i, ret;
=20
 	start =3D cmd->addr;
 	end =3D start + size;
@@ -696,8 +725,13 @@ static int dmirror_migrate(struct dmirror *dmirror,
 		if (next > vma->vm_end)
 			next =3D vma->vm_end;
=20
-		memset(src_pfns, 0, ARRAY_SIZE(src_pfns));
-		memset(dst_pfns, 0, ARRAY_SIZE(dst_pfns));
+		if (allow_ref)
+			for (i =3D 0; i < 64; ++i)
+				src_pfns[i] =3D MIGRATE_PFN_PIN;
+		else
+			memset(src_pfns, 0, sizeof(src_pfns));
+		memset(dst_pfns, 0, sizeof(dst_pfns));
+
 		args.vma =3D vma;
 		args.src =3D src_pfns;
 		args.dst =3D dst_pfns;
@@ -709,9 +743,9 @@ static int dmirror_migrate(struct dmirror *dmirror,
 		if (ret)
 			goto out;
=20
-		dmirror_migrate_alloc_and_copy(&args, dmirror);
+		dmirror_migrate_alloc_and_copy(&args, dmirror, allow_ref);
 		migrate_vma_pages(&args);
-		dmirror_migrate_finalize_and_map(&args, dmirror);
+		dmirror_migrate_finalize_and_map(&args, dmirror, allow_ref);
 		migrate_vma_finalize(&args);
 	}
 	mmap_read_unlock(mm);
@@ -739,6 +773,28 @@ static int dmirror_migrate(struct dmirror *dmirror,
 	return ret;
 }
=20
+static int dmirror_migrate_pin(struct dmirror *dmirror,
+			       struct hmm_dmirror_cmd *cmd)
+{
+	void *tmp;
+	int nr_pages =3D cmd->npages;
+	int ret;
+
+	ret =3D dmirror_migrate(dmirror, cmd, true);
+
+	tmp =3D kmalloc(nr_pages << PAGE_SHIFT, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	/* Make sure user access faults */
+	dmirror->mdevice->devmem_faults =3D 0;
+	if (copy_from_user(tmp, u64_to_user_ptr(cmd->addr), nr_pages << PAGE_SHIF=
T))
+		ret =3D -EFAULT;
+	cmd->faults =3D dmirror->mdevice->devmem_faults;
+
+	return ret;
+}
+
 static void dmirror_mkentry(struct dmirror *dmirror, struct hmm_range *ran=
ge,
 			    unsigned char *perm, unsigned long entry)
 {
@@ -948,7 +1004,11 @@ static long dmirror_fops_unlocked_ioctl(struct file *=
filp,
 		break;
=20
 	case HMM_DMIRROR_MIGRATE:
-		ret =3D dmirror_migrate(dmirror, &cmd);
+		ret =3D dmirror_migrate(dmirror, &cmd, false);
+		break;
+
+	case HMM_DMIRROR_MIGRATE_PIN:
+		ret =3D dmirror_migrate_pin(dmirror, &cmd);
 		break;
=20
 	case HMM_DMIRROR_SNAPSHOT:
@@ -1004,20 +1064,31 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_co=
py(struct migrate_vma *args,
 	for (addr =3D start; addr < end; addr +=3D PAGE_SIZE,
 				       src++, dst++) {
 		struct page *dpage, *spage;
+		void *entry;
=20
 		spage =3D migrate_pfn_to_page(*src);
 		if (!spage || !(*src & MIGRATE_PFN_MIGRATE))
 			continue;
-		spage =3D spage->zone_device_data;
=20
-		dpage =3D alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+		entry =3D xa_load(&dmirror->pt, addr >> PAGE_SHIFT);
+		if (entry && xa_pointer_tag(entry) =3D=3D DPT_XA_TAG_ATOMIC) {
+			spage =3D NULL;
+			dpage =3D xa_untag_pointer(entry);
+			*dst =3D migrate_pfn(page_to_pfn(dpage)) |
+				MIGRATE_PFN_LOCKED | MIGRATE_PFN_UNPIN;
+		} else {
+			spage =3D spage->zone_device_data;
+			dpage =3D alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+			*dst =3D migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+		}
+
 		if (!dpage)
 			continue;
=20
 		lock_page(dpage);
 		xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
-		copy_highpage(dpage, spage);
-		*dst =3D migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+		if (spage)
+			copy_highpage(dpage, spage);
 		if (*src & MIGRATE_PFN_WRITE)
 			*dst |=3D MIGRATE_PFN_WRITE;
 	}
@@ -1041,6 +1112,8 @@ static vm_fault_t dmirror_devmem_fault(struct vm_faul=
t *vmf)
 	rpage =3D vmf->page->zone_device_data;
 	dmirror =3D rpage->zone_device_data;
=20
+	dmirror->mdevice->devmem_faults++;
+
 	/* FIXME demonstrate how we can adjust migrate range */
 	args.vma =3D vmf->vma;
 	args.start =3D vmf->address;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index 670b4ef2a5b6..b40f4e6affe0 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -33,6 +33,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_MIGRATE		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_PIN		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
=20
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftes=
ts/vm/hmm-tests.c
index 5d1ac691b9f4..7111ebab93c7 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -947,6 +947,55 @@ TEST_F(hmm, migrate_fault)
 	hmm_buffer_free(buffer);
 }
=20
+TEST_F(hmm, migrate_fault_pin)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+
+	npages =3D ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size =3D npages << self->page_shift;
+
+	buffer =3D malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd =3D -1;
+	buffer->size =3D size;
+	buffer->mirror =3D malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr =3D mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] =3D i;
+
+	/* Migrate memory to device. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_MIGRATE_PIN, buffer, npages=
);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i =3D 0, ptr =3D buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	ASSERT_EQ(buffer->faults, npages);
+
+	/* Fault pages back to system memory and check them. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate anonymous shared memory to device private memory.
  */
--=20
2.20.1

