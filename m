Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168D339B48A
	for <lists+kvm-ppc@lfdr.de>; Fri,  4 Jun 2021 10:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFDIFl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 4 Jun 2021 04:05:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4356 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhFDIFl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 4 Jun 2021 04:05:41 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FxFYL5K7wz66YP;
        Fri,  4 Jun 2021 16:00:06 +0800 (CST)
Received: from dggema766-chm.china.huawei.com (10.1.198.208) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 16:03:53 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggema766-chm.china.huawei.com (10.1.198.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 16:03:52 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <paulus@ozlabs.org>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>
CC:     <kvm-ppc@vger.kernel.org>, <yangerkun@huawei.com>,
        <yukuai3@huawei.com>
Subject: [PATCH] KVM: PPC: Book3S PR: remove unused define in kvmppc_mmu_book3s_64_xlate
Date:   Fri, 4 Jun 2021 16:13:03 +0800
Message-ID: <20210604081303.3701171-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema766-chm.china.huawei.com (10.1.198.208)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

arch/powerpc/kvm/book3s_64_mmu.c:199:6: warning: variable ‘v’ set but
not used [-Wunused-but-set-variable]
  199 |  u64 v, r;
      |      ^

Fix it by remove the define.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 arch/powerpc/kvm/book3s_64_mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
index 26b8b27a3755..feee40cb2ba1 100644
--- a/arch/powerpc/kvm/book3s_64_mmu.c
+++ b/arch/powerpc/kvm/book3s_64_mmu.c
@@ -196,7 +196,7 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	hva_t ptegp;
 	u64 pteg[16];
 	u64 avpn = 0;
-	u64 v, r;
+	u64 r;
 	u64 v_val, v_mask;
 	u64 eaddr_mask;
 	int i;
@@ -285,7 +285,6 @@ static int kvmppc_mmu_book3s_64_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 		goto do_second;
 	}
 
-	v = be64_to_cpu(pteg[i]);
 	r = be64_to_cpu(pteg[i+1]);
 	pp = (r & HPTE_R_PP) | key;
 	if (r & HPTE_R_PP0)
-- 
2.31.1

