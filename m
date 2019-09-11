Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA48B04AB
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Sep 2019 21:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfIKTwk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Sep 2019 15:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfIKTwk (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 11 Sep 2019 15:52:40 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 49B3F30833BE;
        Wed, 11 Sep 2019 19:52:40 +0000 (UTC)
Received: from thuth.com (ovpn-116-192.ams2.redhat.com [10.36.116.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00F3A19C6A;
        Wed, 11 Sep 2019 19:52:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Remove superfluous check for non-zero return value
Date:   Wed, 11 Sep 2019 21:52:35 +0200
Message-Id: <20190911195235.29048-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 11 Sep 2019 19:52:40 +0000 (UTC)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

After the kfree()s haven been removed in the previous
commit 9798f4ea71ea ("fix rollback when kvmppc_xive_create fails"),
the code can be simplified even more to simply always "return ret"
now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/powerpc/kvm/book3s_xive.c        | 5 +----
 arch/powerpc/kvm/book3s_xive_native.c | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index e3ba67095895..2f6f463fcdfb 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1986,10 +1986,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
 
 	xive->single_escalation = xive_native_has_single_escalation();
 
-	if (ret)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 int kvmppc_xive_debug_show_queues(struct seq_file *m, struct kvm_vcpu *vcpu)
diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index a998823f68a3..7a50772f26fe 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1089,10 +1089,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
 	xive->single_escalation = xive_native_has_single_escalation();
 	xive->ops = &kvmppc_xive_native_ops;
 
-	if (ret)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.18.1

