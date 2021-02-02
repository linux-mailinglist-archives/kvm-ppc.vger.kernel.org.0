Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8920630B5D4
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBBDbl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:31:41 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36467 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhBBDbl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:31:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNdu28r_1612236654;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNdu28r_1612236654)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Feb 2021 11:30:55 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     paulus@ozlabs.org
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] KVM: PPC: remove unneeded semicolon
Date:   Tue,  2 Feb 2021 11:30:53 +0800
Message-Id: <1612236653-101068-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Eliminate the following coccicheck warning:
./arch/powerpc/kvm/booke.c:701:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/powerpc/kvm/booke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 288a982..f38ae3e 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -698,7 +698,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 
 		kvmppc_set_exit_type(vcpu, EMULATED_MTMSRWE_EXITS);
 		r = 1;
-	};
+	}
 
 	return r;
 }
-- 
1.8.3.1

