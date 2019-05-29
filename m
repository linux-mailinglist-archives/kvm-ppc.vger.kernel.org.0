Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C872E683
	for <lists+kvm-ppc@lfdr.de>; Wed, 29 May 2019 22:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfE2UwC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 29 May 2019 16:52:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47256 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfE2UwC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 29 May 2019 16:52:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TKcb9H153712;
        Wed, 29 May 2019 20:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=UEVjydkCiSNXBnxPUv8ZPRtyzn2pRdmlL8Y0MMMRS90=;
 b=JjkSvx+I/jOJ1R55SJ9XTx3aJdMo6srOfR7bY39nKueu9xTbA3TP1z86EBVVQtLRcFX4
 NTJnFOlMUgercHroPKflAKP0zrU4z2Tj3hbr5W/f+7A1ObUht4XcNXRhLmVednMZpG/F
 pG5kfmEvgrD/TWtLirzReJCAWcokxiWj3tNbgOJPRYJA55jvFRqOPYeK417+zKem8O9b
 HCOKUk74lKFOaDUZcpv//SPd1LEyN58nft9EQ64c7mueIcIQFTvsTo38XNIDD0ukVyHQ
 wHPYIA6W1/ESw93USm7ioq+/NgqShXxtUiB0zIPx+ovrQpp9t1oUULZ6KL7x3FdCxn0h Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2spw4tmfgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 20:50:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TKoSMl163806;
        Wed, 29 May 2019 20:50:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sqh73xegs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 20:50:46 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TKoZ3O027508;
        Wed, 29 May 2019 20:50:35 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 13:50:34 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     akpm@linux-foundation.org
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alan Tull <atull@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Ira Weiny <ira.weiny@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm: add account_locked_vm utility function
Date:   Wed, 29 May 2019 16:50:19 -0400
Message-Id: <20190529205019.20927-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529125627.0cb5b704@x1.home>
References: <20190529125627.0cb5b704@x1.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=62 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=62 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290130
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

locked_vm accounting is done roughly the same way in five places, so
unify them in a helper.

Include the helper's caller in the debug print to distinguish between
callsites.

Error codes stay the same, so user-visible behavior does too.  The one
exception is that the -EPERM case in tce_account_locked_vm is removed
because Alexey has never seen it triggered.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alan Tull <atull@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Moritz Fischer <mdf@kernel.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Wu Hao <hao.wu@intel.com>
Cc: linux-mm@kvack.org
Cc: kvm@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
v3:
 - uninline account_locked_vm (Andrew)
 - fix doc comment (Ira)
 - retain down_write_killable in vfio type1 (Alex)
 - leave Alexey's T-b since the code is the same aside from uninlining
 - sanity tested with vfio type1, sanity-built on ppc

 arch/powerpc/kvm/book3s_64_vio.c     | 44 ++--------------
 arch/powerpc/mm/book3s64/iommu_api.c | 41 ++-------------
 drivers/fpga/dfl-afu-dma-region.c    | 53 ++------------------
 drivers/vfio/vfio_iommu_spapr_tce.c  | 54 ++------------------
 drivers/vfio/vfio_iommu_type1.c      | 17 +------
 include/linux/mm.h                   |  4 ++
 mm/util.c                            | 75 ++++++++++++++++++++++++++++
 7 files changed, 98 insertions(+), 190 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 66270e07449a..768b645c7edf 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -30,6 +30,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/iommu.h>
 #include <linux/file.h>
+#include <linux/mm.h>
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
@@ -56,43 +57,6 @@ static unsigned long kvmppc_stt_pages(unsigned long tce_pages)
 	return tce_pages + ALIGN(stt_bytes, PAGE_SIZE) / PAGE_SIZE;
 }
 
-static long kvmppc_account_memlimit(unsigned long stt_pages, bool inc)
-{
-	long ret = 0;
-
-	if (!current || !current->mm)
-		return ret; /* process exited */
-
-	down_write(&current->mm->mmap_sem);
-
-	if (inc) {
-		unsigned long locked, lock_limit;
-
-		locked = current->mm->locked_vm + stt_pages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			current->mm->locked_vm += stt_pages;
-	} else {
-		if (WARN_ON_ONCE(stt_pages > current->mm->locked_vm))
-			stt_pages = current->mm->locked_vm;
-
-		current->mm->locked_vm -= stt_pages;
-	}
-
-	pr_debug("[%d] RLIMIT_MEMLOCK KVM %c%ld %ld/%ld%s\n", current->pid,
-			inc ? '+' : '-',
-			stt_pages << PAGE_SHIFT,
-			current->mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK),
-			ret ? " - exceeded" : "");
-
-	up_write(&current->mm->mmap_sem);
-
-	return ret;
-}
-
 static void kvm_spapr_tce_iommu_table_free(struct rcu_head *head)
 {
 	struct kvmppc_spapr_tce_iommu_table *stit = container_of(head,
@@ -302,7 +266,7 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 
 	kvm_put_kvm(stt->kvm);
 
-	kvmppc_account_memlimit(
+	account_locked_vm(current->mm,
 		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)), false);
 	call_rcu(&stt->rcu, release_spapr_tce_table);
 
@@ -327,7 +291,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		return -EINVAL;
 
 	npages = kvmppc_tce_pages(size);
-	ret = kvmppc_account_memlimit(kvmppc_stt_pages(npages), true);
+	ret = account_locked_vm(current->mm, kvmppc_stt_pages(npages), true);
 	if (ret)
 		return ret;
 
@@ -373,7 +337,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	kfree(stt);
  fail_acct:
-	kvmppc_account_memlimit(kvmppc_stt_pages(npages), false);
+	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);
 	return ret;
 }
 
diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 5c521f3924a5..18d22eec0ebd 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -19,6 +19,7 @@
 #include <linux/hugetlb.h>
 #include <linux/swap.h>
 #include <linux/sizes.h>
+#include <linux/mm.h>
 #include <asm/mmu_context.h>
 #include <asm/pte-walk.h>
 #include <linux/mm_inline.h>
@@ -51,40 +52,6 @@ struct mm_iommu_table_group_mem_t {
 	u64 dev_hpa;		/* Device memory base address */
 };
 
-static long mm_iommu_adjust_locked_vm(struct mm_struct *mm,
-		unsigned long npages, bool incr)
-{
-	long ret = 0, locked, lock_limit;
-
-	if (!npages)
-		return 0;
-
-	down_write(&mm->mmap_sem);
-
-	if (incr) {
-		locked = mm->locked_vm + npages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			mm->locked_vm += npages;
-	} else {
-		if (WARN_ON_ONCE(npages > mm->locked_vm))
-			npages = mm->locked_vm;
-		mm->locked_vm -= npages;
-	}
-
-	pr_debug("[%d] RLIMIT_MEMLOCK HASH64 %c%ld %ld/%ld\n",
-			current ? current->pid : 0,
-			incr ? '+' : '-',
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK));
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
 bool mm_iommu_preregistered(struct mm_struct *mm)
 {
 	return !list_empty(&mm->context.iommu_group_mem_list);
@@ -101,7 +68,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	unsigned long entry, chunk;
 
 	if (dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
-		ret = mm_iommu_adjust_locked_vm(mm, entries, true);
+		ret = account_locked_vm(mm, entries, true);
 		if (ret)
 			return ret;
 
@@ -216,7 +183,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	kfree(mem);
 
 unlock_exit:
-	mm_iommu_adjust_locked_vm(mm, locked_entries, false);
+	account_locked_vm(mm, locked_entries, false);
 
 	return ret;
 }
@@ -316,7 +283,7 @@ long mm_iommu_put(struct mm_struct *mm, struct mm_iommu_table_group_mem_t *mem)
 unlock_exit:
 	mutex_unlock(&mem_list_mutex);
 
-	mm_iommu_adjust_locked_vm(mm, unlock_entries, false);
+	account_locked_vm(mm, unlock_entries, false);
 
 	return ret;
 }
diff --git a/drivers/fpga/dfl-afu-dma-region.c b/drivers/fpga/dfl-afu-dma-region.c
index c438722bf4e1..0a532c602d8f 100644
--- a/drivers/fpga/dfl-afu-dma-region.c
+++ b/drivers/fpga/dfl-afu-dma-region.c
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 #include "dfl-afu.h"
 
@@ -31,52 +32,6 @@ void afu_dma_region_init(struct dfl_feature_platform_data *pdata)
 	afu->dma_regions = RB_ROOT;
 }
 
-/**
- * afu_dma_adjust_locked_vm - adjust locked memory
- * @dev: port device
- * @npages: number of pages
- * @incr: increase or decrease locked memory
- *
- * Increase or decrease the locked memory size with npages input.
- *
- * Return 0 on success.
- * Return -ENOMEM if locked memory size is over the limit and no CAP_IPC_LOCK.
- */
-static int afu_dma_adjust_locked_vm(struct device *dev, long npages, bool incr)
-{
-	unsigned long locked, lock_limit;
-	int ret = 0;
-
-	/* the task is exiting. */
-	if (!current->mm)
-		return 0;
-
-	down_write(&current->mm->mmap_sem);
-
-	if (incr) {
-		locked = current->mm->locked_vm + npages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			current->mm->locked_vm += npages;
-	} else {
-		if (WARN_ON_ONCE(npages > current->mm->locked_vm))
-			npages = current->mm->locked_vm;
-		current->mm->locked_vm -= npages;
-	}
-
-	dev_dbg(dev, "[%d] RLIMIT_MEMLOCK %c%ld %ld/%ld%s\n", current->pid,
-		incr ? '+' : '-', npages << PAGE_SHIFT,
-		current->mm->locked_vm << PAGE_SHIFT, rlimit(RLIMIT_MEMLOCK),
-		ret ? "- exceeded" : "");
-
-	up_write(&current->mm->mmap_sem);
-
-	return ret;
-}
-
 /**
  * afu_dma_pin_pages - pin pages of given dma memory region
  * @pdata: feature device platform data
@@ -92,7 +47,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 	struct device *dev = &pdata->dev->dev;
 	int ret, pinned;
 
-	ret = afu_dma_adjust_locked_vm(dev, npages, true);
+	ret = account_locked_vm(current->mm, npages, true);
 	if (ret)
 		return ret;
 
@@ -121,7 +76,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 free_pages:
 	kfree(region->pages);
 unlock_vm:
-	afu_dma_adjust_locked_vm(dev, npages, false);
+	account_locked_vm(current->mm, npages, false);
 	return ret;
 }
 
@@ -141,7 +96,7 @@ static void afu_dma_unpin_pages(struct dfl_feature_platform_data *pdata,
 
 	put_all_pages(region->pages, npages);
 	kfree(region->pages);
-	afu_dma_adjust_locked_vm(dev, npages, false);
+	account_locked_vm(current->mm, npages, false);
 
 	dev_dbg(dev, "%ld pages unpinned\n", npages);
 }
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 40ddc0c5f677..d06e8e291924 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
+#include <linux/mm.h>
 
 #include <asm/iommu.h>
 #include <asm/tce.h>
@@ -34,51 +35,6 @@
 static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group);
 
-static long try_increment_locked_vm(struct mm_struct *mm, long npages)
-{
-	long ret = 0, locked, lock_limit;
-
-	if (WARN_ON_ONCE(!mm))
-		return -EPERM;
-
-	if (!npages)
-		return 0;
-
-	down_write(&mm->mmap_sem);
-	locked = mm->locked_vm + npages;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-		ret = -ENOMEM;
-	else
-		mm->locked_vm += npages;
-
-	pr_debug("[%d] RLIMIT_MEMLOCK +%ld %ld/%ld%s\n", current->pid,
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK),
-			ret ? " - exceeded" : "");
-
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
-static void decrement_locked_vm(struct mm_struct *mm, long npages)
-{
-	if (!mm || !npages)
-		return;
-
-	down_write(&mm->mmap_sem);
-	if (WARN_ON_ONCE(npages > mm->locked_vm))
-		npages = mm->locked_vm;
-	mm->locked_vm -= npages;
-	pr_debug("[%d] RLIMIT_MEMLOCK -%ld %ld/%ld\n", current->pid,
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK));
-	up_write(&mm->mmap_sem);
-}
-
 /*
  * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
  *
@@ -336,7 +292,7 @@ static int tce_iommu_enable(struct tce_container *container)
 		return ret;
 
 	locked = table_group->tce32_size >> PAGE_SHIFT;
-	ret = try_increment_locked_vm(container->mm, locked);
+	ret = account_locked_vm(container->mm, locked, true);
 	if (ret)
 		return ret;
 
@@ -355,7 +311,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	container->enabled = false;
 
 	BUG_ON(!container->mm);
-	decrement_locked_vm(container->mm, container->locked_pages);
+	account_locked_vm(container->mm, container->locked_pages, false);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -659,7 +615,7 @@ static long tce_iommu_create_table(struct tce_container *container,
 	if (!table_size)
 		return -EINVAL;
 
-	ret = try_increment_locked_vm(container->mm, table_size >> PAGE_SHIFT);
+	ret = account_locked_vm(container->mm, table_size >> PAGE_SHIFT, true);
 	if (ret)
 		return ret;
 
@@ -678,7 +634,7 @@ static void tce_iommu_free_table(struct tce_container *container,
 	unsigned long pages = tbl->it_allocated_size >> PAGE_SHIFT;
 
 	iommu_tce_table_put(tbl);
-	decrement_locked_vm(container->mm, pages);
+	account_locked_vm(container->mm, pages, false);
 }
 
 static long tce_iommu_create_window(struct tce_container *container,
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3ddc375e7063..bf449ace1676 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -275,21 +275,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 
 	ret = down_write_killable(&mm->mmap_sem);
 	if (!ret) {
-		if (npage > 0) {
-			if (!dma->lock_cap) {
-				unsigned long limit;
-
-				limit = task_rlimit(dma->task,
-						RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-				if (mm->locked_vm + npage > limit)
-					ret = -ENOMEM;
-			}
-		}
-
-		if (!ret)
-			mm->locked_vm += npage;
-
+		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
+					  dma->lock_cap);
 		up_write(&mm->mmap_sem);
 	}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e8834ac32b7..95510f6fad45 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1564,6 +1564,10 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
 
+int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+			struct task_struct *task, bool bypass_rlim);
+
 /* Container for pinned pfns / pages */
 struct frame_vector {
 	unsigned int nr_allocated;	/* Number of frames we have space for */
diff --git a/mm/util.c b/mm/util.c
index 91682a2090ee..cbbcc035b12b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -7,6 +7,7 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/security.h>
 #include <linux/swap.h>
@@ -347,6 +348,80 @@ int __weak get_user_pages_fast(unsigned long start,
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+/**
+ * __account_locked_vm - account locked pages to an mm's locked_vm
+ * @mm:          mm to account against
+ * @pages:       number of pages to account
+ * @inc:         %true if @pages should be considered positive, %false if not
+ * @task:        task used to check RLIMIT_MEMLOCK
+ * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
+ *
+ * Assumes @task and @mm are valid (i.e. at least one reference on each), and
+ * that mmap_sem is held as writer.
+ *
+ * Return:
+ * * 0       on success
+ * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
+ */
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+			struct task_struct *task, bool bypass_rlim)
+{
+	unsigned long locked_vm, limit;
+	int ret = 0;
+
+	lockdep_assert_held_exclusive(&mm->mmap_sem);
+
+	locked_vm = mm->locked_vm;
+	if (inc) {
+		if (!bypass_rlim) {
+			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+			if (locked_vm + pages > limit)
+				ret = -ENOMEM;
+		}
+		if (!ret)
+			mm->locked_vm = locked_vm + pages;
+	} else {
+		WARN_ON_ONCE(pages > locked_vm);
+		mm->locked_vm = locked_vm - pages;
+	}
+
+	pr_debug("%s: [%d] caller %ps %c%lu %lu/%lu%s\n", __func__, task->pid,
+		 (void *)_RET_IP_, (inc) ? '+' : '-', pages << PAGE_SHIFT,
+		 locked_vm << PAGE_SHIFT, task_rlimit(task, RLIMIT_MEMLOCK),
+		 ret ? " - exceeded" : "");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__account_locked_vm);
+
+/**
+ * account_locked_vm - account locked pages to an mm's locked_vm
+ * @mm:          mm to account against, may be NULL
+ * @pages:       number of pages to account
+ * @inc:         %true if @pages should be considered positive, %false if not
+ *
+ * Assumes a non-NULL @mm is valid (i.e. at least one reference on it).
+ *
+ * Return:
+ * * 0       on success, or if mm is NULL
+ * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
+ */
+int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
+{
+	int ret;
+
+	if (pages == 0 || !mm)
+		return 0;
+
+	down_write(&mm->mmap_sem);
+	ret = __account_locked_vm(mm, pages, inc, current,
+				  capable(CAP_IPC_LOCK));
+	up_write(&mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(account_locked_vm);
+
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)

base-commit: cd6c84d8f0cdc911df435bb075ba22ce3c605b07
-- 
2.21.0

