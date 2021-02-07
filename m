Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD4312209
	for <lists+kvm-ppc@lfdr.de>; Sun,  7 Feb 2021 07:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBGGoF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 7 Feb 2021 01:44:05 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:50245 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229506AbhBGGoE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 7 Feb 2021 01:44:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UO3FkMB_1612680193;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UO3FkMB_1612680193)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 07 Feb 2021 14:43:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     paulus@ozlabs.org
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] powerpc/xive: Assign boolean values to a bool variable
Date:   Sun,  7 Feb 2021 14:43:12 +0800
Message-Id: <1612680192-43116-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fix the following coccicheck warnings:

./arch/powerpc/kvm/book3s_xive.c:1856:2-17: WARNING: Assignment of 0/1
to bool variable.

./arch/powerpc/kvm/book3s_xive.c:1854:2-17: WARNING: Assignment of 0/1
to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 arch/powerpc/kvm/book3s_xive.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 30dfeac..e7219b6 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1813,9 +1813,9 @@ int kvmppc_xive_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
 		return -EINVAL;
 
 	if ((level == 1 && state->lsi) || level == KVM_INTERRUPT_SET_LEVEL)
-		state->asserted = 1;
+		state->asserted = true;
 	else if (level == 0 || level == KVM_INTERRUPT_UNSET) {
-		state->asserted = 0;
+		state->asserted = false;
 		return 0;
 	}
 
-- 
1.8.3.1

