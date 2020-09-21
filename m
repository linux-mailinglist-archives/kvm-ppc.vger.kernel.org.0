Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB5272257
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Sep 2020 13:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIULY6 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Sep 2020 07:24:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726367AbgIULY5 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 21 Sep 2020 07:24:57 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 26FF28EAE5C88EE86BD1;
        Mon, 21 Sep 2020 19:24:56 +0800 (CST)
Received: from huawei.com (10.175.112.208) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 21 Sep 2020
 19:24:50 +0800
From:   Wang Wensheng <wangwensheng4@huawei.com>
To:     <paulus@ozlabs.org>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] powerpc/kvm/books: Fix symbol undeclared warnings
Date:   Mon, 21 Sep 2020 11:22:11 +0000
Message-ID: <20200921112211.82830-1-wangwensheng4@huawei.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Build the kernel with `C=2`:
arch/powerpc/kvm/book3s_hv_nested.c:572:25: warning: symbol
'kvmhv_alloc_nested' was not declared. Should it be static?
arch/powerpc/kvm/book3s_64_mmu_radix.c:350:6: warning: symbol
'kvmppc_radix_set_pte_at' was not declared. Should it be static?
arch/powerpc/kvm/book3s_hv.c:3568:5: warning: symbol
'kvmhv_p9_guest_entry' was not declared. Should it be static?
arch/powerpc/kvm/book3s_hv_rm_xics.c:767:15: warning: symbol 'eoi_rc'
was not declared. Should it be static?
arch/powerpc/kvm/book3s_64_vio_hv.c:240:13: warning: symbol
'iommu_tce_kill_rm' was not declared. Should it be static?
arch/powerpc/kvm/book3s_64_vio.c:492:6: warning: symbol
'kvmppc_tce_iommu_do_map' was not declared. Should it be static?
arch/powerpc/kvm/book3s_pr.c:572:6: warning: symbol 'kvmppc_set_pvr_pr'
was not declared. Should it be static?

Those symbols are used only in the files that define them so make them
static to fix the warnings.

Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 +-
 arch/powerpc/kvm/book3s_64_vio.c       | 2 +-
 arch/powerpc/kvm/book3s_64_vio_hv.c    | 2 +-
 arch/powerpc/kvm/book3s_hv.c           | 2 +-
 arch/powerpc/kvm/book3s_hv_nested.c    | 2 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c   | 2 +-
 arch/powerpc/kvm/book3s_pr.c           | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 22a677b18695..bb35490400e9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -347,7 +347,7 @@ static unsigned long kvmppc_radix_update_pte(struct kvm *kvm, pte_t *ptep,
 	return __radix_pte_update(ptep, clr, set);
 }
 
-void kvmppc_radix_set_pte_at(struct kvm *kvm, unsigned long addr,
+static void kvmppc_radix_set_pte_at(struct kvm *kvm, unsigned long addr,
 			     pte_t *ptep, pte_t pte)
 {
 	radix__set_pte_at(kvm->mm, addr, ptep, pte, 0);
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 1a529df0ab44..c2fbeb04bba2 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -489,7 +489,7 @@ static long kvmppc_tce_iommu_unmap(struct kvm *kvm,
 	return ret;
 }
 
-long kvmppc_tce_iommu_do_map(struct kvm *kvm, struct iommu_table *tbl,
+static long kvmppc_tce_iommu_do_map(struct kvm *kvm, struct iommu_table *tbl,
 		unsigned long entry, unsigned long ua,
 		enum dma_data_direction dir)
 {
diff --git a/arch/powerpc/kvm/book3s_64_vio_hv.c b/arch/powerpc/kvm/book3s_64_vio_hv.c
index ac6ac192b8bb..470e7c518a10 100644
--- a/arch/powerpc/kvm/book3s_64_vio_hv.c
+++ b/arch/powerpc/kvm/book3s_64_vio_hv.c
@@ -237,7 +237,7 @@ static long iommu_tce_xchg_no_kill_rm(struct mm_struct *mm,
 	return ret;
 }
 
-extern void iommu_tce_kill_rm(struct iommu_table *tbl,
+static void iommu_tce_kill_rm(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages)
 {
 	if (tbl->it_ops->tce_kill)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index cb1d16a3730c..31407be44e57 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3575,7 +3575,7 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
  * Virtual-mode guest entry for POWER9 and later when the host and
  * guest are both using the radix MMU.  The LPIDR has already been set.
  */
-int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
+static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 			 unsigned long lpcr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 6822d23a2da4..33b58549a9aa 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -569,7 +569,7 @@ static void kvmhv_update_ptbl_cache(struct kvm_nested_guest *gp)
 	kvmhv_set_nested_ptbl(gp);
 }
 
-struct kvm_nested_guest *kvmhv_alloc_nested(struct kvm *kvm, unsigned int lpid)
+static struct kvm_nested_guest *kvmhv_alloc_nested(struct kvm *kvm, unsigned int lpid)
 {
 	struct kvm_nested_guest *gp;
 	long shadow_lpid;
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index 4d7e5610731a..c2c9c733f359 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -764,7 +764,7 @@ int xics_rm_h_eoi(struct kvm_vcpu *vcpu, unsigned long xirr)
 	return ics_rm_eoi(vcpu, irq);
 }
 
-unsigned long eoi_rc;
+static unsigned long eoi_rc;
 
 static void icp_eoi(struct irq_chip *c, u32 hwirq, __be32 xirr, bool *again)
 {
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 88fac22fbf09..b1fefa63e125 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -569,7 +569,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
 #endif
 }
 
-void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
+static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
 {
 	u32 host_pvr;
 
-- 
2.25.0

