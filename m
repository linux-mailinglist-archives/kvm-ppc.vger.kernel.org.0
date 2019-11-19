Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C55101943
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Nov 2019 07:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKSGU3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 19 Nov 2019 01:20:29 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:35438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfKSGU2 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 19 Nov 2019 01:20:28 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BE2B87CCBDD3710A776F;
        Tue, 19 Nov 2019 14:20:26 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 19 Nov 2019
 14:20:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <paulus@ozlabs.org>, <benh@kernel.crashing.org>,
        <mpe@ellerman.id.au>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] KVM: PPC: Remove set but not used variable 'ra','rs','rt'
Date:   Tue, 19 Nov 2019 14:27:40 +0800
Message-ID: <1574144860-22954-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:6: warning: variable ra set but not used [-Wunused-but-set-variable]
arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:10: warning: variable rs set but not used [-Wunused-but-set-variable]
arch/powerpc/kvm/emulate_loadstore.c: In function kvmppc_emulate_loadstore:
arch/powerpc/kvm/emulate_loadstore.c:87:14: warning: variable rt set but not used [-Wunused-but-set-variable]

They are not used since commit 2b33cb585f94 ("KVM: PPC: Reimplement
LOAD_FP/STORE_FP instruction mmio emulation with analyse_instr() input")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 arch/powerpc/kvm/emulate_loadstore.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 2e496eb..1139bc5 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -73,7 +73,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 inst;
-	int ra, rs, rt;
 	enum emulation_result emulated = EMULATE_FAIL;
 	int advance = 1;
 	struct instruction_op op;
@@ -85,10 +84,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 	if (emulated != EMULATE_DONE)
 		return emulated;

-	ra = get_ra(inst);
-	rs = get_rs(inst);
-	rt = get_rt(inst);
-
 	vcpu->arch.mmio_vsx_copy_nums = 0;
 	vcpu->arch.mmio_vsx_offset = 0;
 	vcpu->arch.mmio_copy_type = KVMPPC_VSX_COPY_NONE;
--
2.7.4

