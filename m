Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D4D2709A7
	for <lists+kvm-ppc@lfdr.de>; Sat, 19 Sep 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgISB3H (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 18 Sep 2020 21:29:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13266 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISB3F (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 18 Sep 2020 21:29:05 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 04B72926D1F79BAFA753;
        Sat, 19 Sep 2020 09:29:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 09:28:53 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] KVM: PPC: Book3S HV: XIVE: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 19 Sep 2020 09:29:25 +0800
Message-ID: <20200919012925.174377-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 arch/powerpc/kvm/book3s_xive_native.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index bdea91df1..d0c2db0e0 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1227,17 +1227,7 @@ static int xive_native_debug_show(struct seq_file *m, void *private)
 	return 0;
 }
 
-static int xive_native_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, xive_native_debug_show, inode->i_private);
-}
-
-static const struct file_operations xive_native_debug_fops = {
-	.open = xive_native_debug_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(xive_native_debug);
 
 static void xive_native_debugfs_init(struct kvmppc_xive *xive)
 {
-- 
2.23.0

