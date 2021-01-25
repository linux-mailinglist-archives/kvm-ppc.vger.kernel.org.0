Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B1F3022AA
	for <lists+kvm-ppc@lfdr.de>; Mon, 25 Jan 2021 09:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbhAYIIh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 25 Jan 2021 03:08:37 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:40834 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727307AbhAYIAd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 25 Jan 2021 03:00:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UMmi-sD_1611561544;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMmi-sD_1611561544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 15:59:08 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     paulus@ozlabs.org
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] KVM: PPC: Book3S: Assign boolean values to a bool variable
Date:   Mon, 25 Jan 2021 15:59:02 +0800
Message-Id: <1611561542-17017-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Fix the following coccicheck warnings:

./arch/powerpc/kvm/book3s_hv_rm_xics.c:381:3-15: WARNING: Assignment of
0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 arch/powerpc/kvm/book3s_hv_rm_xics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index c2c9c73..68e509d 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -378,7 +378,7 @@ static void icp_rm_deliver_irq(struct kvmppc_xics *xics, struct kvmppc_icp *icp,
 			arch_spin_unlock(&ics->lock);
 			icp->n_reject++;
 			new_irq = reject;
-			check_resend = 0;
+			check_resend = false;
 			goto again;
 		}
 	} else {
-- 
1.8.3.1

