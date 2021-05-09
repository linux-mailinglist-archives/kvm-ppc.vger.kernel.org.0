Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D77B37768B
	for <lists+kvm-ppc@lfdr.de>; Sun,  9 May 2021 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhEIMBZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 9 May 2021 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEIMBZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 9 May 2021 08:01:25 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB5AC061573;
        Sun,  9 May 2021 05:00:22 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e14so11656275ils.12;
        Sun, 09 May 2021 05:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kTx7GsVUFbgNj4CE0ebZKgVk3lgKoqAHGQKzwKjpOTo=;
        b=o1U7LHIoILUMAKsu3Ff3u1/xNS1wn1G0pYDZnS8MFQxnPBmV6xnAJrwAYYsg8j7asq
         SD2hchkVH4BiazilUD8Uv3VHCVVLgKplOZ6IizO2/VicDHODdjTF9gEhaHhS0yXO8hlm
         fho+krDPMQFAPJJ+SlHhyyS6PbNpEoDSGTVksa5YeUaTc9IASJoQvAyaSXsCTugHNVEp
         PjeojXRE+ISwXshc/Ah7ngTBVgnll/17CRb/FV43maq56TDiUQziZThShSGrxcwnrXoU
         bV41slefQTRltwI6SfmFm4Z5zpgn0geIhyvZlzHEHajqtUK8+3c1YUJ0ukB2Hm6d1HS4
         sG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kTx7GsVUFbgNj4CE0ebZKgVk3lgKoqAHGQKzwKjpOTo=;
        b=rb9y13RvkMNQr19Oz1KABCwLS7Qb1CMPlxqN1RSNq5moJxFGXMNCibgaNEbglqDH9f
         135Dz3FIrYGchtym+CPWYXTQx1Fsn8dijDBnDl1JzZi03XTzE9uVr8eLg1rzsILXx9y9
         7bRRP1C3L54OZBEYI5bDduXQ2aO6Sa5cFOLbUsH8qlgTkSEFPjwPpdzVX/YUArNrJ1Qb
         asDAQ8RKpeybHjTFdGzw+TdZy17gBFolMnFJz8DFIV2GiyZj8HPLaVmObKzk0qPTbXe7
         dU5Qz/I2/glkKscrtGKv6ARF7LIvz8yHtEV+fWFLYp/82khZy0a4O5Kg1DQ+azffnC4F
         9Nrw==
X-Gm-Message-State: AOAM5306ri260lcaJ1l6bpk31Y8yJLg28V17CxsBYkvx6EYspsQxG4ac
        H/nJX/HtRy/EvHIKNncxQF6fvRla+rCt2OL86VCXk5lQywJNiw==
X-Google-Smtp-Source: ABdhPJxHWZ09Z3PyFi+Vxhf1zbM0wtuvfiwJ26dMwg1qAhPy7R05jGaIUlv+ZLXQXeRAllHhAF8Gkn7AEe12UokWC2E=
X-Received: by 2002:a05:6e02:1212:: with SMTP id a18mr17861723ilq.2.1620561621669;
 Sun, 09 May 2021 05:00:21 -0700 (PDT)
MIME-Version: 1.0
From:   Nour-eddine Taleb <1337.noureddine@gmail.com>
Date:   Sun, 9 May 2021 12:00:10 +0000
Message-ID: <CAJO4vZwtVrYoMPZ9XoEAUJYgo-rND21eGorPrRF5m6rW4WT76w@mail.gmail.com>
Subject: [PATCH] arch: powerpc: kvm: remove unnecessary casting
To:     paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

remove unnecessary castings, from "void *" to "struct kvmppc_xics *"

Signed-off-by: Nour-eddine Taleb <1337.noureddine@gmail.com>
---
 arch/powerpc/kvm/book3s_xics.c        | 2 +-
 arch/powerpc/kvm/book3s_xive.c        | 2 +-
 arch/powerpc/kvm/book3s_xive_native.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xics.c b/arch/powerpc/kvm/book3s_xics.c
index 303e3cb096db..9ae74fa551a6 100644
--- a/arch/powerpc/kvm/book3s_xics.c
+++ b/arch/powerpc/kvm/book3s_xics.c
@@ -1440,7 +1440,7 @@ static int kvmppc_xics_create(struct kvm_device
*dev, u32 type)

 static void kvmppc_xics_init(struct kvm_device *dev)
 {
-    struct kvmppc_xics *xics = (struct kvmppc_xics *)dev->private;
+    struct kvmppc_xics *xics = dev->private;

     xics_debugfs_init(xics);
 }
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index e7219b6f5f9a..05bcaf81a90a 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2242,7 +2242,7 @@ static void xive_debugfs_init(struct kvmppc_xive *xive)

 static void kvmppc_xive_init(struct kvm_device *dev)
 {
-    struct kvmppc_xive *xive = (struct kvmppc_xive *)dev->private;
+    struct kvmppc_xive *xive = dev->private;

     /* Register some debug interfaces */
     xive_debugfs_init(xive);
diff --git a/arch/powerpc/kvm/book3s_xive_native.c
b/arch/powerpc/kvm/book3s_xive_native.c
index 76800c84f2a3..2703432cea78 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -1265,7 +1265,7 @@ static void xive_native_debugfs_init(struct
kvmppc_xive *xive)

 static void kvmppc_xive_native_init(struct kvm_device *dev)
 {
-    struct kvmppc_xive *xive = (struct kvmppc_xive *)dev->private;
+    struct kvmppc_xive *xive = dev->private;

     /* Register some debug interfaces */
     xive_native_debugfs_init(xive);
-- 
2.30.2
