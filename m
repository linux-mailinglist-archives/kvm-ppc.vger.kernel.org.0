Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B623277B0
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Mar 2021 07:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhCAGie (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Mar 2021 01:38:34 -0500
Received: from ozlabs.ru ([107.174.27.60]:46794 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhCAGhw (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 1 Mar 2021 01:37:52 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id CA33CAE80007;
        Mon,  1 Mar 2021 01:36:55 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org,
        Frederic Barrat <fbarrat@linux.ibm.com>
Subject: [PATCH kernel v2] powerpc/iommu: Annotate nested lock for lockdep
Date:   Mon,  1 Mar 2021 17:36:53 +1100
Message-Id: <20210301063653.51003-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The IOMMU table is divided into pools for concurrent mappings and each
pool has a separate spinlock. When taking the ownership of an IOMMU group
to pass through a device to a VM, we lock these spinlocks which triggers
a false negative warning in lockdep (below).

This fixes it by annotating the large pool's spinlock as a nest lock
which makes lockdep not complaining when locking nested locks if
the nest lock is locked already.

===
WARNING: possible recursive locking detected
5.11.0-le_syzkaller_a+fstn1 #100 Not tainted
--------------------------------------------
qemu-system-ppc/4129 is trying to acquire lock:
c0000000119bddb0 (&(p->lock)/1){....}-{2:2}, at: iommu_take_ownership+0xac/0x1e0

but task is already holding lock:
c0000000119bdd30 (&(p->lock)/1){....}-{2:2}, at: iommu_take_ownership+0xac/0x1e0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(p->lock)/1);
  lock(&(p->lock)/1);
===

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2:
* fixed iommu_release_ownership() as well

---
 arch/powerpc/kernel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c1a5c366a664..d0df3e5ff5e0 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1089,7 +1089,7 @@ int iommu_take_ownership(struct iommu_table *tbl)
 
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
 
 	iommu_table_release_pages(tbl);
 
@@ -1117,7 +1117,7 @@ void iommu_release_ownership(struct iommu_table *tbl)
 
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
 
 	memset(tbl->it_map, 0, sz);
 
-- 
2.17.1

