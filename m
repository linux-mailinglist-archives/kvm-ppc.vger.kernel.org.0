Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8551816800
	for <lists+kvm-ppc@lfdr.de>; Tue,  7 May 2019 18:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfEGQiQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 7 May 2019 12:38:16 -0400
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:55796 "EHLO
        7.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfEGQiQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 7 May 2019 12:38:16 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 12:38:15 EDT
Received: from player770.ha.ovh.net (unknown [10.108.35.240])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 2D2EB191B8A
        for <kvm-ppc@vger.kernel.org>; Tue,  7 May 2019 18:20:58 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n0.emea.ibm.com [195.212.29.162])
        (Authenticated sender: clg@kaod.org)
        by player770.ha.ovh.net (Postfix) with ESMTPSA id C92D85849DC3;
        Tue,  7 May 2019 16:20:52 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: fix 'release' method of KVM device
Date:   Tue,  7 May 2019 18:20:47 +0200
Message-Id: <20190507162047.17152-1-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12711972901352868823
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrkedtgddutdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is no need to test for the device pointer validity when releasing
a KVM device. The file descriptor should identify it safely.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
---

 Fixes http://patchwork.ozlabs.org/patch/1087506/
 https://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git/commit/?h=kvm-ppc-next&id=2bde9b3ec8bdf60788e9e2ce8c07a2f8d6003dbd

 virt/kvm/kvm_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 161830ec0aa5..ac15b8fd8399 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2939,12 +2939,6 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
 	struct kvm_device *dev = filp->private_data;
 	struct kvm *kvm = dev->kvm;
 
-	if (!dev)
-		return -ENODEV;
-
-	if (dev->kvm != kvm)
-		return -EPERM;
-
 	if (dev->ops->release) {
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
-- 
2.20.1

