Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F933270B5C
	for <lists+kvm-ppc@lfdr.de>; Sat, 19 Sep 2020 09:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgISHMW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 19 Sep 2020 03:12:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13327 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISHMW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 19 Sep 2020 03:12:22 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 064361527795F6012CE4;
        Sat, 19 Sep 2020 15:12:16 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 15:12:07 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <paulus@ozlabs.org>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>
CC:     <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <jingxiangfeng@huawei.com>
Subject: [PATCH] KVM: PPC: Book3S: Remove redundant initialization of variable ret
Date:   Sat, 19 Sep 2020 15:12:30 +0800
Message-ID: <20200919071230.125798-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The variable ret is being initialized with '-ENOMEM' that is meaningless.
So remove it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 arch/powerpc/kvm/book3s_64_vio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 1a529df0ab44..b277a75cd1be 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -283,7 +283,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 	struct kvmppc_spapr_tce_table *siter;
 	struct mm_struct *mm = kvm->mm;
 	unsigned long npages, size = args->size;
-	int ret = -ENOMEM;
+	int ret;
 
 	if (!args->size || args->page_shift < 12 || args->page_shift > 34 ||
 		(args->offset + args->size > (ULLONG_MAX >> args->page_shift)))
-- 
2.17.1

