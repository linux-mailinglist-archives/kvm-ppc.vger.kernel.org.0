Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13AC31F3DB
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 03:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBSCIt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 18 Feb 2021 21:08:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2737 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhBSCIs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 18 Feb 2021 21:08:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602f1d870001>; Thu, 18 Feb 2021 18:08:07 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 19 Feb
 2021 02:08:06 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     <linux-mm@kvack.org>, <nouveau@lists.freedesktop.org>,
        <bskeggs@redhat.com>, <akpm@linux-foundation.org>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <jhubbard@nvidia.com>, <rcampbell@nvidia.com>,
        <jglisse@redhat.com>, <jgg@nvidia.com>, <hch@infradead.org>,
        <daniel@ffwll.ch>, Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 2/4] hmm: Selftests for exclusive device memory
Date:   Fri, 19 Feb 2021 13:07:48 +1100
Message-ID: <20210219020750.16444-3-apopple@nvidia.com>
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
        t=1613700487; bh=UOgMin+hr8IvGv0vIpPpaKdghp+MMGxdR4XPVayfQ8E=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bT7+ynxI02R88DBM4bpvxstp5MfaC50RGerw17lcVytVWuEpQTerVe6Nsm+tZG9RY
         Z0WU902W3s5DhWssFDXGBug04f0eEi2lI0eI1Q1FCRDP5a2BEu1iiUsQFneMzcOqDe
         GDuhQWZB8sHoJrY7MbI/4AGQqv4fY6i4co9zoQojGhTZeH0SZYT29XLjmxu3JJi4zE
         /XiuknmQi74O6ZCiaRoOWkjBiKsreWJv6ybHoh6f6ZwamZKpY2OoT7aFztTYDMkbOa
         zSIRcmGsUaL5w7o6raobC5TE1HHdpRQr1ojI1h3YoBr78ot/Q9kuFEakRirXjm0xb5
         Hm36JvWrBi2iA==
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Adds some selftests for exclusive device memory.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 lib/test_hmm.c                         | 124 ++++++++++++++
 lib/test_hmm_uapi.h                    |   2 +
 tools/testing/selftests/vm/hmm-tests.c | 219 +++++++++++++++++++++++++
 3 files changed, 345 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 80a78877bd93..d517d9d4c5aa 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -25,6 +25,7 @@
 #include <linux/swapops.h>
 #include <linux/sched/mm.h>
 #include <linux/platform_device.h>
+#include <linux/rmap.h>
=20
 #include "test_hmm_uapi.h"
=20
@@ -46,6 +47,7 @@ struct dmirror_bounce {
 	unsigned long		cpages;
 };
=20
+#define DPT_XA_TAG_ATOMIC 1UL
 #define DPT_XA_TAG_WRITE 3UL
=20
 /*
@@ -619,6 +621,54 @@ static void dmirror_migrate_alloc_and_copy(struct migr=
ate_vma *args,
 	}
 }
=20
+static int dmirror_check_atomic(struct dmirror *dmirror, unsigned long sta=
rt,
+			     unsigned long end)
+{
+	unsigned long pfn;
+
+	for (pfn =3D start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn++) {
+		void *entry;
+		struct page *page;
+
+		entry =3D xa_load(&dmirror->pt, pfn);
+		page =3D xa_untag_pointer(entry);
+		if (xa_pointer_tag(entry) =3D=3D DPT_XA_TAG_ATOMIC)
+			return -EPERM;
+	}
+
+	return 0;
+}
+
+static int dmirror_atomic_map(unsigned long start, unsigned long end,
+			      struct page **pages, struct dmirror *dmirror)
+{
+	unsigned long pfn, mapped =3D 0;
+	int i;
+
+	/* Map the migrated pages into the device's page tables. */
+	mutex_lock(&dmirror->mutex);
+
+	for (i =3D 0, pfn =3D start >> PAGE_SHIFT; pfn < (end >> PAGE_SHIFT); pfn=
++, i++) {
+		void *entry;
+
+		if (!pages[i])
+			continue;
+
+		entry =3D pages[i];
+		entry =3D xa_tag_pointer(entry, DPT_XA_TAG_ATOMIC);
+		entry =3D xa_store(&dmirror->pt, pfn, entry, GFP_ATOMIC);
+		if (xa_is_err(entry)) {
+			mutex_unlock(&dmirror->mutex);
+			return xa_err(entry);
+		}
+
+		mapped++;
+	}
+
+	mutex_unlock(&dmirror->mutex);
+	return mapped;
+}
+
 static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 					    struct dmirror *dmirror)
 {
@@ -661,6 +711,71 @@ static int dmirror_migrate_finalize_and_map(struct mig=
rate_vma *args,
 	return 0;
 }
=20
+static int dmirror_exclusive(struct dmirror *dmirror,
+			     struct hmm_dmirror_cmd *cmd)
+{
+	unsigned long start, end, addr;
+	unsigned long size =3D cmd->npages << PAGE_SHIFT;
+	struct mm_struct *mm =3D dmirror->notifier.mm;
+	struct page *pages[64];
+	struct dmirror_bounce bounce;
+	unsigned long next;
+	int ret;
+
+	start =3D cmd->addr;
+	end =3D start + size;
+	if (end < start)
+		return -EINVAL;
+
+	/* Since the mm is for the mirrored process, get a reference first. */
+	if (!mmget_not_zero(mm))
+		return -EINVAL;
+
+	mmap_read_lock(mm);
+	for (addr =3D start; addr < end; addr =3D next) {
+		int i, mapped;
+
+		if (end < addr + (64 << PAGE_SHIFT))
+			next =3D end;
+		else
+			next =3D addr + (64 << PAGE_SHIFT);
+
+		ret =3D hmm_exclusive_range(mm, addr, next, pages);
+		mapped =3D dmirror_atomic_map(addr, next, pages, dmirror);
+		for (i =3D 0; i < ret; i++) {
+			if (pages[i]) {
+				unlock_page(pages[i]);
+				put_page(pages[i]);
+			}
+		}
+
+		if (addr + (mapped << PAGE_SHIFT) < next) {
+			mmap_read_unlock(mm);
+			mmput(mm);
+			return -EBUSY;
+		}
+	}
+	mmap_read_unlock(mm);
+	mmput(mm);
+
+	/* Return the migrated data for verification. */
+	ret =3D dmirror_bounce_init(&bounce, start, size);
+	if (ret)
+		return ret;
+	mutex_lock(&dmirror->mutex);
+	ret =3D dmirror_do_read(dmirror, start, end, &bounce);
+	mutex_unlock(&dmirror->mutex);
+	if (ret =3D=3D 0) {
+		if (copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr,
+				 bounce.size))
+			ret =3D -EFAULT;
+	}
+
+	cmd->cpages =3D bounce.cpages;
+	dmirror_bounce_fini(&bounce);
+	return ret;
+}
+
 static int dmirror_migrate(struct dmirror *dmirror,
 			   struct hmm_dmirror_cmd *cmd)
 {
@@ -949,6 +1064,15 @@ static long dmirror_fops_unlocked_ioctl(struct file *=
filp,
 		ret =3D dmirror_migrate(dmirror, &cmd);
 		break;
=20
+	case HMM_DMIRROR_EXCLUSIVE:
+		ret =3D dmirror_exclusive(dmirror, &cmd);
+		break;
+
+	case HMM_DMIRROR_CHECK_EXCLUSIVE:
+		ret =3D dmirror_check_atomic(dmirror, cmd.addr,
+					cmd.addr + (cmd.npages << PAGE_SHIFT));
+		break;
+
 	case HMM_DMIRROR_SNAPSHOT:
 		ret =3D dmirror_snapshot(dmirror, &cmd);
 		break;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index 670b4ef2a5b6..f14dea5dcd06 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -33,6 +33,8 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_MIGRATE		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x05, struct hmm_dmirror_cm=
d)
=20
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftes=
ts/vm/hmm-tests.c
index 5d1ac691b9f4..5d3c5db9ed3a 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1485,4 +1485,223 @@ TEST_F(hmm2, double_map)
 	hmm_buffer_free(buffer);
 }
=20
+/*
+ * Basic check of exclusive faulting.
+ */
+TEST_F(hmm, exclusive)
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
+	/* Map memory exclusively for device access. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i =3D 0, ptr =3D buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Fault pages back to system memory and check them. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i]++, i);
+
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i+1);
+
+	/* Check atomic access revoked */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_CHECK_EXCLUSIVE, buffer, np=
ages);
+	ASSERT_EQ(ret, 0);
+
+	hmm_buffer_free(buffer);
+}
+
+TEST_F(hmm, exclusive_shared)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	int *ptr;
+	int ret, i;
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
+			   MAP_SHARED | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] =3D i;
+
+	/* Map memory exclusively for device access. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i =3D 0, ptr =3D buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Fault pages back to system memory and check them. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i]++, i);
+
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i+1);
+
+	/* Check atomic access revoked */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_CHECK_EXCLUSIVE, buffer, np=
ages);
+	ASSERT_FALSE(ret);
+
+	/* Map memory exclusively for device access again to check process tear d=
own */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Same as above but for shared anonymous memory.
+ */
+TEST_F(hmm, exclusive_mprotect)
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
+	/* Map memory exclusively for device access. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i =3D 0, ptr =3D buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	ret =3D mprotect(buffer->ptr, size, PROT_READ);
+	ASSERT_EQ(ret, 0);
+
+	/* Simulate a device writing system memory. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_WRITE, buffer, npages);
+	ASSERT_EQ(ret, -EPERM);
+
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Check copy-on-write works.
+ */
+TEST_F(hmm, exclusive_cow)
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
+	/* Map memory exclusively for device access. */
+	ret =3D hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	fork();
+
+	/* Fault pages back to system memory and check them. */
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i]++, i);
+
+	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i+1);
+
+	hmm_buffer_free(buffer);
+}
+
 TEST_HARNESS_MAIN
--=20
2.20.1

