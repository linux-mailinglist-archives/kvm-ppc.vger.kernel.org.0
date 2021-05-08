Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38D377430
	for <lists+kvm-ppc@lfdr.de>; Sat,  8 May 2021 23:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHVqS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 8 May 2021 17:46:18 -0400
Received: from 64.52.23.98.static.skysilk.com ([64.52.23.98]:35898 "EHLO
        mail.noureddine.xyz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHVqS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 8 May 2021 17:46:18 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 May 2021 17:46:18 EDT
Received: from [192.168.1.102] (unknown [105.191.3.241])
        by mail.noureddine.xyz (Postfix) with ESMTPSA id 770C01405F9;
        Sat,  8 May 2021 21:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=noureddine.xyz;
        s=mail; t=1620509858;
        bh=CdBDoEVxNcdj1d8lrKJjyhicLwdsZOU5WWW/useIVxo=;
        h=To:Cc:From:Subject:Date:From;
        b=OtaRo+vbhf+UMfP+nypWu+bKwcZ4k8T2hND0VloPMvbgI76VuGvP4dZDdeDCMykLw
         17U0EZ18DkAmQBjUaeUDhUMCTRbaWzRuIT9b/jB0z8lvjnjOGfjYwlLfy8mBHXG79V
         Cz2mGHJtXg/5wz7Y5R1lppjh+hummjpW6d4L9uVqq4MO+nsLwzwKr6b6ei09dMjqVf
         BHX+RwlHSOJVyX2lagFUFg90lUcr7zyyQ2S0SL90F/5c60XeGXRJupoediDhFvRWjW
         AgGklFcrv6wMJVVVOG3/PqeQ7IODX6bAEqSwbn1SexN8qGoeNtT+iaUZF7TuB4NuTE
         9Vf0MhEPSyCbQ==
To:     paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, noureddine <contact@noureddine.xyz>
From:   Nour-eddine Taleb <contact@noureddine.xyz>
Subject: [PATCH] arch: powerpc: kvm: remove unnecessary casting
Message-ID: <34d93da2-4b0c-8806-54e7-5bcaeab4f2d5@noureddine.xyz>
Date:   Sat, 8 May 2021 21:37:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

remove unnecessary castings, from "void *" to "struct kvmppc_xics *"

Signed-off-by: Nour-eddine Taleb <contact@noureddine.xyz>
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
-	struct kvmppc_xics *xics = (struct kvmppc_xics *)dev->private;
+	struct kvmppc_xics *xics = dev->private;

  	xics_debugfs_init(xics);
  }
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index e7219b6f5f9a..05bcaf81a90a 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -2242,7 +2242,7 @@ static void xive_debugfs_init(struct kvmppc_xive 
*xive)

  static void kvmppc_xive_init(struct kvm_device *dev)
  {
-	struct kvmppc_xive *xive = (struct kvmppc_xive *)dev->private;
+	struct kvmppc_xive *xive = dev->private;

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
-	struct kvmppc_xive *xive = (struct kvmppc_xive *)dev->private;
+	struct kvmppc_xive *xive = dev->private;

  	/* Register some debug interfaces */
  	xive_native_debugfs_init(xive);
-- 
2.30.2

