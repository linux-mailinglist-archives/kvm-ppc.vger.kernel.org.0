Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549813D51A9
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhGZDKi (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AB6C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so12487604pjd.0
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGMO3KzFWfaiWdxRFMMRg8fmrR2Jvox/ePS+dlDySeM=;
        b=T4JDfWBFUi5OWwQq4UEJXRpK2IbKJs+ukhR/hf+kauIbzD2aPqKEOVbgZhsFvBh+JX
         RUB/cueg7stI0g0lVEr44BhZ9g2exoOzev9rG4PVl9G7z99TF4FXpinMtBt0RCfYSktX
         S8ugeHUqJ8sS7HQkbyQl6Go9yuFOyKodhq17sRR62ijrc7aY4jSsgQBLehJ+sdyovj2E
         Efwt3iCTkPxucLqHM+NCszZM5/7n+NeGMl3XFJfspJfEKcYFa9w3yOaayonDWr2efAy0
         ProqW08pW75r3xoSuAu18ttes0P1GX+/yoL+fnULmsruHzLEY3CgA5GpdHGdYtBgvIEg
         6OMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGMO3KzFWfaiWdxRFMMRg8fmrR2Jvox/ePS+dlDySeM=;
        b=ck+pUgGQ4BQ3Xn/I0heQ1u+voeOvJnNNAErEaqOXCZ6kuTOsLkybaQfhCeYdeVQPeX
         dIS+4ah/0fBse+jRw+oMQ/EZlRgybmG+0GQd9DqrvDBv3q9yjf6Zu3m10wtMTQpJgsLI
         7cuftXOBeFRAfwaiHoBhW6lHOiuW1L+FmEiiRrIFIV3/QrzHRGmfjCIIYRexRLQhkdS3
         7kpCXuqYayhvvPeqUPPSBYdmCUa1wY5yHsIYTv4TM9wkxVBmG+tkUG0uCRnYO2Ar8uPd
         hSB42R3SpHk7hyLOCjooNPfl/Jws2SxE6Pzl2UJWoMVfqcQ7UlGeMxrp/TKyk8/fmG9d
         fIkA==
X-Gm-Message-State: AOAM532TUsm2L8/3cC9S+LtojK77YehVvF2XV4iAqhRQMSITn0qGCYi+
        VeZGwAXx+ja7lab9upYgykPqqeZtKDI=
X-Google-Smtp-Source: ABdhPJwEJ+Et8P+gZNwFbeoqExsDuLzIlB7g/K+Y2zrsv2h1lyvvqSoiCwxddrMfMn7eS3fbGtCJ3Q==
X-Received: by 2002:a17:90b:11d4:: with SMTP id gv20mr15488659pjb.200.1627271466497;
        Sun, 25 Jul 2021 20:51:06 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1 09/55] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Mon, 26 Jul 2021 13:49:50 +1000
Message-Id: <20210726035036.739609-10-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h       | 2 ++
 arch/powerpc/kernel/time.c            | 1 +
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index fd09b4797fd7..69b6be617772 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -18,6 +18,8 @@
 #include <asm/vdso/timebase.h>
 
 /* time.c */
+extern u64 decrementer_max;
+
 extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 01df89918aa4..72d872b49167 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase = {
 
 #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
 u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max); /* for KVM HDEC */
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 961b3d70483c..0ff9ddb5e7ca 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -504,7 +504,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	save_clear_guest_mmu(kvm, vcpu);
 	switch_mmu_to_host(kvm, host_pidr);
-- 
2.23.0

