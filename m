Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADB31C5C4
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Feb 2021 04:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBPDVR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Feb 2021 22:21:17 -0500
Received: from ozlabs.ru ([107.174.27.60]:39102 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhBPDVR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 15 Feb 2021 22:21:17 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 84C9FAE8020D;
        Mon, 15 Feb 2021 22:20:04 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>, kvm-ppc@vger.kernel.org
Subject: [PATCH kernel] powerpc/iommu: Annotate nested lock for lockdep
Date:   Tue, 16 Feb 2021 14:20:00 +1100
Message-Id: <20210216032000.21642-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The IOMMU table is divided into pools for concurrent mappings and each
pool has a separate spinlock. When taking the ownership of an IOMMU group
to pass through a device to a VM, we lock these spinlocks which triggers
a false negative warning in lockdep (below).

This fixes it by annotating the large pool's spinlock as a nest lock.

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
 arch/powerpc/kernel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 557a09dd5b2f..2ee642a6731a 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1089,7 +1089,7 @@ int iommu_take_ownership(struct iommu_table *tbl)
 
 	spin_lock_irqsave(&tbl->large_pool.lock, flags);
 	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
 
 	iommu_table_release_pages(tbl);
 
-- 
2.17.1

