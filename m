Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE1AC8746A
	for <lists+kvm-ppc@lfdr.de>; Fri,  9 Aug 2019 10:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405972AbfHIIla (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 9 Aug 2019 04:41:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405807AbfHIIl3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 9 Aug 2019 04:41:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x798bZ8f005089
        for <kvm-ppc@vger.kernel.org>; Fri, 9 Aug 2019 04:41:26 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u940u3n3g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 09 Aug 2019 04:41:25 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Fri, 9 Aug 2019 09:41:23 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 9 Aug 2019 09:41:20 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x798fJZO61800594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Aug 2019 08:41:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18FDDA405C;
        Fri,  9 Aug 2019 08:41:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3CCBA4054;
        Fri,  9 Aug 2019 08:41:16 +0000 (GMT)
Received: from bharata.ibmuc.com (unknown [9.85.95.61])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  9 Aug 2019 08:41:16 +0000 (GMT)
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, sukadev@linux.vnet.ibm.com,
        cclaudio@linux.ibm.com, hch@lst.de,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH v6 1/7] kvmppc: Driver to manage pages of secure guest
Date:   Fri,  9 Aug 2019 14:11:02 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809084108.30343-1-bharata@linux.ibm.com>
References: <20190809084108.30343-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19080908-0020-0000-0000-0000035DA569
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080908-0021-0000-0000-000021B2ABF3
Message-Id: <20190809084108.30343-2-bharata@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090089
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

KVMPPC driver to manage page transitions of secure guest
via H_SVM_PAGE_IN and H_SVM_PAGE_OUT hcalls.

H_SVM_PAGE_IN: Move the content of a normal page to secure page
H_SVM_PAGE_OUT: Move the content of a secure page to normal page

Private ZONE_DEVICE memory equal to the amount of secure memory
available in the platform for running secure guests is created
via a char device. Whenever a page belonging to the guest becomes
secure, a page from this private device memory is used to
represent and track that secure page on the HV side. The movement
of pages between normal and secure memory is done via
migrate_vma_pages() using UV_PAGE_IN and UV_PAGE_OUT ucalls.

Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
---
 arch/powerpc/include/asm/hvcall.h          |   4 +
 arch/powerpc/include/asm/kvm_book3s_devm.h |  29 ++
 arch/powerpc/include/asm/kvm_host.h        |  12 +
 arch/powerpc/include/asm/ultravisor-api.h  |   2 +
 arch/powerpc/include/asm/ultravisor.h      |  14 +
 arch/powerpc/kvm/Makefile                  |   3 +
 arch/powerpc/kvm/book3s_hv.c               |  19 +
 arch/powerpc/kvm/book3s_hv_devm.c          | 492 +++++++++++++++++++++
 8 files changed, 575 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kvm_book3s_devm.h
 create mode 100644 arch/powerpc/kvm/book3s_hv_devm.c

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index 463c63a9fcf1..2f6b952deb0f 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -337,6 +337,10 @@
 #define H_TLB_INVALIDATE	0xF808
 #define H_COPY_TOFROM_GUEST	0xF80C
 
+/* Platform-specific hcalls used by the Ultravisor */
+#define H_SVM_PAGE_IN		0xEF00
+#define H_SVM_PAGE_OUT		0xEF04
+
 /* Values for 2nd argument to H_SET_MODE */
 #define H_SET_MODE_RESOURCE_SET_CIABR		1
 #define H_SET_MODE_RESOURCE_SET_DAWR		2
diff --git a/arch/powerpc/include/asm/kvm_book3s_devm.h b/arch/powerpc/include/asm/kvm_book3s_devm.h
new file mode 100644
index 000000000000..21f3de5f2acb
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_book3s_devm.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __POWERPC_KVM_PPC_HMM_H__
+#define __POWERPC_KVM_PPC_HMM_H__
+
+#ifdef CONFIG_PPC_UV
+extern unsigned long kvmppc_h_svm_page_in(struct kvm *kvm,
+					  unsigned long gra,
+					  unsigned long flags,
+					  unsigned long page_shift);
+extern unsigned long kvmppc_h_svm_page_out(struct kvm *kvm,
+					  unsigned long gra,
+					  unsigned long flags,
+					  unsigned long page_shift);
+#else
+static inline unsigned long
+kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gra,
+		     unsigned long flags, unsigned long page_shift)
+{
+	return H_UNSUPPORTED;
+}
+
+static inline unsigned long
+kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gra,
+		      unsigned long flags, unsigned long page_shift)
+{
+	return H_UNSUPPORTED;
+}
+#endif /* CONFIG_PPC_UV */
+#endif /* __POWERPC_KVM_PPC_HMM_H__ */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 4bb552d639b8..86bbe607ad7e 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -849,4 +849,16 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#ifdef CONFIG_PPC_UV
+extern int kvmppc_devm_init(void);
+extern void kvmppc_devm_free(void);
+#else
+static inline int kvmppc_devm_init(void)
+{
+	return 0;
+}
+
+static inline void kvmppc_devm_free(void) {}
+#endif /* CONFIG_PPC_UV */
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
index 6a0f9c74f959..1cd1f595fd81 100644
--- a/arch/powerpc/include/asm/ultravisor-api.h
+++ b/arch/powerpc/include/asm/ultravisor-api.h
@@ -25,5 +25,7 @@
 /* opcodes */
 #define UV_WRITE_PATE			0xF104
 #define UV_RETURN			0xF11C
+#define UV_PAGE_IN			0xF128
+#define UV_PAGE_OUT			0xF12C
 
 #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
index 6fe1f365dec8..d668a59e099b 100644
--- a/arch/powerpc/include/asm/ultravisor.h
+++ b/arch/powerpc/include/asm/ultravisor.h
@@ -19,4 +19,18 @@ static inline int uv_register_pate(u64 lpid, u64 dw0, u64 dw1)
 	return ucall_norets(UV_WRITE_PATE, lpid, dw0, dw1);
 }
 
+static inline int uv_page_in(u64 lpid, u64 src_ra, u64 dst_gpa, u64 flags,
+			     u64 page_shift)
+{
+	return ucall_norets(UV_PAGE_IN, lpid, src_ra, dst_gpa, flags,
+			    page_shift);
+}
+
+static inline int uv_page_out(u64 lpid, u64 dst_ra, u64 src_gpa, u64 flags,
+			      u64 page_shift)
+{
+	return ucall_norets(UV_PAGE_OUT, lpid, dst_ra, src_gpa, flags,
+			    page_shift);
+}
+
 #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 4c67cc79de7c..16b40590e67c 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -71,6 +71,9 @@ kvm-hv-y += \
 	book3s_64_mmu_radix.o \
 	book3s_hv_nested.o
 
+kvm-hv-$(CONFIG_PPC_UV) += \
+	book3s_hv_devm.o
+
 kvm-hv-$(CONFIG_PPC_TRANSACTIONAL_MEM) += \
 	book3s_hv_tm.o
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ec1804f822af..00b43ee8b693 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -72,6 +72,8 @@
 #include <asm/xics.h>
 #include <asm/xive.h>
 #include <asm/hw_breakpoint.h>
+#include <asm/kvm_host.h>
+#include <asm/kvm_book3s_devm.h>
 
 #include "book3s.h"
 
@@ -1075,6 +1077,18 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 					 kvmppc_get_gpr(vcpu, 5),
 					 kvmppc_get_gpr(vcpu, 6));
 		break;
+	case H_SVM_PAGE_IN:
+		ret = kvmppc_h_svm_page_in(vcpu->kvm,
+					   kvmppc_get_gpr(vcpu, 4),
+					   kvmppc_get_gpr(vcpu, 5),
+					   kvmppc_get_gpr(vcpu, 6));
+		break;
+	case H_SVM_PAGE_OUT:
+		ret = kvmppc_h_svm_page_out(vcpu->kvm,
+					    kvmppc_get_gpr(vcpu, 4),
+					    kvmppc_get_gpr(vcpu, 5),
+					    kvmppc_get_gpr(vcpu, 6));
+		break;
 	default:
 		return RESUME_HOST;
 	}
@@ -5510,11 +5524,16 @@ static int kvmppc_book3s_init_hv(void)
 			no_mixing_hpt_and_radix = true;
 	}
 
+	r = kvmppc_devm_init();
+	if (r < 0)
+		pr_err("KVM-HV: kvmppc_devm_init failed %d\n", r);
+
 	return r;
 }
 
 static void kvmppc_book3s_exit_hv(void)
 {
+	kvmppc_devm_free();
 	kvmppc_free_host_rm_ops();
 	if (kvmppc_radix_possible())
 		kvmppc_radix_exit();
diff --git a/arch/powerpc/kvm/book3s_hv_devm.c b/arch/powerpc/kvm/book3s_hv_devm.c
new file mode 100644
index 000000000000..2e6c077bd22e
--- /dev/null
+++ b/arch/powerpc/kvm/book3s_hv_devm.c
@@ -0,0 +1,492 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Driver to manage page migration between normal and secure
+ * memory.
+ *
+ * Copyright 2018 Bharata B Rao, IBM Corp. <bharata@linux.ibm.com>
+ */
+
+/*
+ * A pseries guest can be run as a secure guest on Ultravisor-enabled
+ * POWER platforms. On such platforms, this driver will be used to manage
+ * the movement of guest pages between the normal memory managed by
+ * hypervisor (HV) and secure memory managed by Ultravisor (UV).
+ *
+ * The page-in or page-out requests from UV will come to HV as hcalls and
+ * HV will call back into UV via uvcalls to satisfy these page requests.
+ *
+ * Private ZONE_DEVICE memory equal to the amount of secure memory
+ * available in the platform for running secure guests is created
+ * via a char device. Whenever a page belonging to the guest becomes
+ * secure, a page from this private device memory is used to
+ * represent and track that secure page on the HV side.
+ *
+ * For each page that gets moved into secure memory, a device PFN is used
+ * on the HV side and migration PTE corresponding to that PFN would be
+ * populated in the QEMU page tables. Device PFNs are stored in the rmap
+ * array. Whenever a guest page becomes secure, device PFN allocated for
+ * the same will be populated in the corresponding slot in the rmap
+ * array. The overloading of rmap array's usage which otherwise is
+ * used primarily by HPT guests means that this feature (secure
+ * guest on PEF platforms) is available only for Radix MMU guests.
+ * Also the same rmap array is used differently by nested HPT guests.
+ * Hence a secure guest can't have nested guests.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/migrate.h>
+#include <linux/kvm_host.h>
+#include <linux/sched/mm.h>
+#include <asm/ultravisor.h>
+
+struct kvmppc_devm_device {
+	struct device dev;
+	dev_t devt;
+	struct dev_pagemap pagemap;
+	unsigned long pfn_first, pfn_last;
+	unsigned long *pfn_bitmap;
+};
+
+
+static struct kvmppc_devm_device kvmppc_devm;
+spinlock_t kvmppc_devm_lock;
+
+struct kvmppc_devm_page_pvt {
+	unsigned long *rmap;
+	unsigned int lpid;
+	unsigned long gpa;
+};
+
+struct kvmppc_devm_copy_args {
+	unsigned long *rmap;
+	unsigned int lpid;
+	unsigned long gpa;
+	unsigned long page_shift;
+};
+
+/*
+ * Bits 60:56 in the rmap entry will be used to identify the
+ * different uses/functions of rmap. This definition with move
+ * to a proper header when all other functions are defined.
+ */
+#define KVMPPC_PFN_DEVM		(0x2ULL << 56)
+
+static inline bool kvmppc_is_devm_pfn(unsigned long pfn)
+{
+	return !!(pfn & KVMPPC_PFN_DEVM);
+}
+
+/*
+ * Get a free device PFN from the pool
+ *
+ * Called when a normal page is moved to secure memory (UV_PAGE_IN). Device
+ * PFN will be used to keep track of the secure page on HV side.
+ *
+ * @rmap here is the slot in the rmap array that corresponds to @gpa.
+ * Thus a non-zero rmap entry indicates that the corresonding guest
+ * page has become secure, and is not mapped on the HV side.
+ *
+ * NOTE: In this and subsequent functions, we pass around and access
+ * individual elements of kvm_memory_slot->arch.rmap[] without any
+ * protection. Should we use lock_rmap() here?
+ */
+static struct page *kvmppc_devm_get_page(unsigned long *rmap,
+					unsigned long gpa, unsigned int lpid)
+{
+	struct page *dpage = NULL;
+	unsigned long bit, devm_pfn;
+	unsigned long nr_pfns = kvmppc_devm.pfn_last -
+				kvmppc_devm.pfn_first;
+	unsigned long flags;
+	struct kvmppc_devm_page_pvt *pvt;
+
+	if (kvmppc_is_devm_pfn(*rmap))
+		return NULL;
+
+	spin_lock_irqsave(&kvmppc_devm_lock, flags);
+	bit = find_first_zero_bit(kvmppc_devm.pfn_bitmap, nr_pfns);
+	if (bit >= nr_pfns)
+		goto out;
+
+	bitmap_set(kvmppc_devm.pfn_bitmap, bit, 1);
+	devm_pfn = bit + kvmppc_devm.pfn_first;
+	dpage = pfn_to_page(devm_pfn);
+
+	if (!trylock_page(dpage))
+		goto out_clear;
+
+	*rmap = devm_pfn | KVMPPC_PFN_DEVM;
+	pvt = kzalloc(sizeof(*pvt), GFP_ATOMIC);
+	if (!pvt)
+		goto out_unlock;
+	pvt->rmap = rmap;
+	pvt->gpa = gpa;
+	pvt->lpid = lpid;
+	dpage->zone_device_data = pvt;
+	spin_unlock_irqrestore(&kvmppc_devm_lock, flags);
+
+	get_page(dpage);
+	return dpage;
+
+out_unlock:
+	unlock_page(dpage);
+out_clear:
+	bitmap_clear(kvmppc_devm.pfn_bitmap,
+		     devm_pfn - kvmppc_devm.pfn_first, 1);
+out:
+	spin_unlock_irqrestore(&kvmppc_devm_lock, flags);
+	return NULL;
+}
+
+/*
+ * Release the device PFN back to the pool
+ *
+ * Gets called when secure page becomes a normal page during UV_PAGE_OUT.
+ */
+static void kvmppc_devm_put_page(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+	unsigned long flags;
+	struct kvmppc_devm_page_pvt *pvt;
+
+	spin_lock_irqsave(&kvmppc_devm_lock, flags);
+	pvt = (struct kvmppc_devm_page_pvt *)page->zone_device_data;
+	page->zone_device_data = 0;
+
+	bitmap_clear(kvmppc_devm.pfn_bitmap,
+		     pfn - kvmppc_devm.pfn_first, 1);
+	*(pvt->rmap) = 0;
+	spin_unlock_irqrestore(&kvmppc_devm_lock, flags);
+	kfree(pvt);
+}
+
+/*
+ * Alloc a PFN from private device memory pool and copy page from normal
+ * memory to secure memory.
+ */
+static int
+kvmppc_devm_migrate_alloc_and_copy(struct migrate_vma *mig,
+				   struct kvmppc_devm_copy_args *args)
+{
+	struct page *spage = migrate_pfn_to_page(*mig->src);
+	unsigned long pfn = *mig->src >> MIGRATE_PFN_SHIFT;
+	struct page *dpage;
+
+	*mig->dst = 0;
+	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
+		return 0;
+
+	dpage = kvmppc_devm_get_page(args->rmap, args->gpa, args->lpid);
+	if (!dpage)
+		return -EINVAL;
+
+	if (spage)
+		uv_page_in(args->lpid, pfn << args->page_shift,
+			   args->gpa, 0, args->page_shift);
+
+	*mig->dst = migrate_pfn(page_to_pfn(dpage)) | MIGRATE_PFN_LOCKED;
+	return 0;
+}
+
+/*
+ * Move page from normal memory to secure memory.
+ */
+unsigned long
+kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
+		     unsigned long flags, unsigned long page_shift)
+{
+	unsigned long addr, end;
+	unsigned long src_pfn, dst_pfn;
+	struct kvmppc_devm_copy_args args;
+	struct migrate_vma mig;
+	struct vm_area_struct *vma;
+	int srcu_idx;
+	unsigned long gfn = gpa >> page_shift;
+	struct kvm_memory_slot *slot;
+	unsigned long *rmap;
+	int ret;
+
+	if (page_shift != PAGE_SHIFT)
+		return H_P3;
+
+	if (flags)
+		return H_P2;
+
+	ret = H_PARAMETER;
+	down_read(&kvm->mm->mmap_sem);
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	slot = gfn_to_memslot(kvm, gfn);
+	rmap = &slot->arch.rmap[gfn - slot->base_gfn];
+	addr = gfn_to_hva(kvm, gpa >> page_shift);
+	if (kvm_is_error_hva(addr))
+		goto out;
+
+	end = addr + (1UL << page_shift);
+	vma = find_vma_intersection(kvm->mm, addr, end);
+	if (!vma || vma->vm_start > addr || vma->vm_end < end)
+		goto out;
+
+	args.rmap = rmap;
+	args.lpid = kvm->arch.lpid;
+	args.gpa = gpa;
+	args.page_shift = page_shift;
+
+	memset(&mig, 0, sizeof(mig));
+	mig.vma = vma;
+	mig.start = addr;
+	mig.end = end;
+	mig.src = &src_pfn;
+	mig.dst = &dst_pfn;
+
+	if (migrate_vma_setup(&mig))
+		goto out;
+
+	if (kvmppc_devm_migrate_alloc_and_copy(&mig, &args))
+		goto out_finalize;
+
+	migrate_vma_pages(&mig);
+	ret = H_SUCCESS;
+out_finalize:
+	migrate_vma_finalize(&mig);
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	up_read(&kvm->mm->mmap_sem);
+	return ret;
+}
+
+/*
+ * Provision a new page on HV side and copy over the contents
+ * from secure memory.
+ */
+static int
+kvmppc_devm_fault_migrate_alloc_and_copy(struct migrate_vma *mig)
+{
+	struct page *dpage, *spage;
+	struct kvmppc_devm_page_pvt *pvt;
+	unsigned long pfn;
+	int ret = U_SUCCESS;
+
+	spage = migrate_pfn_to_page(*mig->src);
+	if (!spage || !(*mig->src & MIGRATE_PFN_MIGRATE))
+		return 0;
+	if (!is_zone_device_page(spage))
+		return 0;
+
+	dpage = alloc_page_vma(GFP_HIGHUSER, mig->vma, mig->start);
+	if (!dpage)
+		return -EINVAL;
+	lock_page(dpage);
+	pvt = (struct kvmppc_devm_page_pvt *)spage->zone_device_data;
+
+	pfn = page_to_pfn(dpage);
+	ret = uv_page_out(pvt->lpid, pfn << PAGE_SHIFT,
+			  pvt->gpa, 0, PAGE_SHIFT);
+	if (ret == U_SUCCESS)
+		*mig->dst = migrate_pfn(pfn) | MIGRATE_PFN_LOCKED;
+	return 0;
+}
+
+/*
+ * Fault handler callback when HV touches any page that has been
+ * moved to secure memory, we ask UV to give back the page by
+ * issuing a UV_PAGE_OUT uvcall.
+ *
+ * This eventually results in dropping of device PFN and the newly
+ * provisioned page/PFN gets populated in QEMU page tables.
+ */
+static vm_fault_t kvmppc_devm_migrate_to_ram(struct vm_fault *vmf)
+{
+	unsigned long src_pfn, dst_pfn = 0;
+	struct migrate_vma mig;
+	int ret = 0;
+
+	memset(&mig, 0, sizeof(mig));
+	mig.vma = vmf->vma;
+	mig.start = vmf->address;
+	mig.end = vmf->address + PAGE_SIZE;
+	mig.src = &src_pfn;
+	mig.dst = &dst_pfn;
+
+	if (migrate_vma_setup(&mig)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	if (kvmppc_devm_fault_migrate_alloc_and_copy(&mig)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_finalize;
+	}
+
+	migrate_vma_pages(&mig);
+out_finalize:
+	migrate_vma_finalize(&mig);
+out:
+	return ret;
+}
+
+static void kvmppc_devm_page_free(struct page *page)
+{
+	kvmppc_devm_put_page(page);
+}
+
+static const struct dev_pagemap_ops kvmppc_devm_ops = {
+	.page_free = kvmppc_devm_page_free,
+	.migrate_to_ram	= kvmppc_devm_migrate_to_ram,
+};
+
+/*
+ * Move page from secure memory to normal memory.
+ */
+unsigned long
+kvmppc_h_svm_page_out(struct kvm *kvm, unsigned long gpa,
+		      unsigned long flags, unsigned long page_shift)
+{
+	struct migrate_vma mig;
+	unsigned long addr, end;
+	struct vm_area_struct *vma;
+	unsigned long src_pfn, dst_pfn = 0;
+	int srcu_idx;
+	int ret;
+
+	if (page_shift != PAGE_SHIFT)
+		return H_P3;
+
+	if (flags)
+		return H_P2;
+
+	ret = H_PARAMETER;
+	down_read(&kvm->mm->mmap_sem);
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	addr = gfn_to_hva(kvm, gpa >> page_shift);
+	if (kvm_is_error_hva(addr))
+		goto out;
+
+	end = addr + (1UL << page_shift);
+	vma = find_vma_intersection(kvm->mm, addr, end);
+	if (!vma || vma->vm_start > addr || vma->vm_end < end)
+		goto out;
+
+	memset(&mig, 0, sizeof(mig));
+	mig.vma = vma;
+	mig.start = addr;
+	mig.end = end;
+	mig.src = &src_pfn;
+	mig.dst = &dst_pfn;
+	if (migrate_vma_setup(&mig))
+		goto out;
+
+	if (kvmppc_devm_fault_migrate_alloc_and_copy(&mig))
+		goto out_finalize;
+
+	migrate_vma_pages(&mig);
+	ret = H_SUCCESS;
+out_finalize:
+	migrate_vma_finalize(&mig);
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	up_read(&kvm->mm->mmap_sem);
+	return ret;
+}
+
+static u64 kvmppc_get_secmem_size(void)
+{
+	struct device_node *np;
+	int i, len;
+	const __be32 *prop;
+	u64 size = 0;
+
+	np = of_find_node_by_path("/ibm,ultravisor/ibm,uv-firmware");
+	if (!np)
+		goto out;
+
+	prop = of_get_property(np, "secure-memory-ranges", &len);
+	if (!prop)
+		goto out_put;
+
+	for (i = 0; i < len / (sizeof(*prop) * 4); i++)
+		size += of_read_number(prop + (i * 4) + 2, 2);
+
+out_put:
+	of_node_put(np);
+out:
+	return size;
+}
+
+static int kvmppc_devm_pages_init(void)
+{
+	unsigned long nr_pfns = kvmppc_devm.pfn_last -
+				kvmppc_devm.pfn_first;
+
+	kvmppc_devm.pfn_bitmap = kcalloc(BITS_TO_LONGS(nr_pfns),
+				 sizeof(unsigned long), GFP_KERNEL);
+	if (!kvmppc_devm.pfn_bitmap)
+		return -ENOMEM;
+
+	spin_lock_init(&kvmppc_devm_lock);
+
+	return 0;
+}
+
+static void kvmppc_devm_release(struct device *dev)
+{
+	unregister_chrdev_region(kvmppc_devm.devt, 1);
+}
+
+int kvmppc_devm_init(void)
+{
+	int ret = 0;
+	unsigned long size;
+	struct resource *res;
+	void *addr;
+
+	size = kvmppc_get_secmem_size();
+	if (!size) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = alloc_chrdev_region(&kvmppc_devm.devt, 0, 1,
+				"kvmppc-devm");
+	if (ret)
+		goto out;
+
+	dev_set_name(&kvmppc_devm.dev, "kvmppc_devm_device%d", 0);
+	kvmppc_devm.dev.release = kvmppc_devm_release;
+	device_initialize(&kvmppc_devm.dev);
+	res = devm_request_free_mem_region(&kvmppc_devm.dev,
+		&iomem_resource, size);
+	if (IS_ERR(res)) {
+		ret = PTR_ERR(res);
+		goto out_unregister;
+	}
+
+	kvmppc_devm.pagemap.type = MEMORY_DEVICE_PRIVATE;
+	kvmppc_devm.pagemap.res = *res;
+	kvmppc_devm.pagemap.ops = &kvmppc_devm_ops;
+	addr = devm_memremap_pages(&kvmppc_devm.dev, &kvmppc_devm.pagemap);
+	if (IS_ERR(addr)) {
+		ret = PTR_ERR(addr);
+		goto out_unregister;
+	}
+
+	kvmppc_devm.pfn_first = res->start >> PAGE_SHIFT;
+	kvmppc_devm.pfn_last = kvmppc_devm.pfn_first +
+			(resource_size(res) >> PAGE_SHIFT);
+	ret = kvmppc_devm_pages_init();
+	if (ret < 0)
+		goto out_unregister;
+
+	pr_info("KVMPPC-DEVM: Secure Memory size 0x%lx\n", size);
+	return ret;
+
+out_unregister:
+	put_device(&kvmppc_devm.dev);
+out:
+	return ret;
+}
+
+void kvmppc_devm_free(void)
+{
+	kfree(kvmppc_devm.pfn_bitmap);
+	put_device(&kvmppc_devm.dev);
+}
-- 
2.21.0

