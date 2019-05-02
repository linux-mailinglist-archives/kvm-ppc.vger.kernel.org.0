Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DECB11724
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 May 2019 12:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEBKXS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 May 2019 06:23:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42748 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfEBKXS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 May 2019 06:23:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hM8ry-0006jK-0U; Thu, 02 May 2019 10:23:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: PPC: Book3S HV: XIVE: fix spelling mistake "acessing" -> "accessing"
Date:   Thu,  2 May 2019 11:23:13 +0100
Message-Id: <20190502102313.25093-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_err message, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/powerpc/kvm/book3s_xive_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index 5e14df1a4403..6a8e698c4b6e 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -235,7 +235,7 @@ static vm_fault_t xive_native_esb_fault(struct vm_fault *vmf)
 	arch_spin_unlock(&sb->lock);
 
 	if (WARN_ON(!page)) {
-		pr_err("%s: acessing invalid ESB page for source %lx !\n",
+		pr_err("%s: accessing invalid ESB page for source %lx !\n",
 		       __func__, irq);
 		return VM_FAULT_SIGBUS;
 	}
-- 
2.20.1

