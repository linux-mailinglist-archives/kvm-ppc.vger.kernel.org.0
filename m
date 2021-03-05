Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E404432EDD6
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCEPIO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhCEPIA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4641C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id fu20so2030917pjb.2
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KLeUPsdctybSg2LQNs7cshVt2UuNsiXHqJBvkSSAal8=;
        b=JFn/+97GXyXnDEm4h4yTjgjwYVMImuNQOP8+vVZDJ4gkPaSr9jgoLQomYKDHkdqPEc
         YPfyhU8D7V2NATin2v44YwkhCwUpXxjxsBF/NzTTqcTeeI0TevU4mSJY2tDHL9ckmvAO
         Je3mBxQMpw9/NJv0veg//jsn8p1LTU8V8gjsqUQTIuR07OgyvQ8e6h3GXM1dh/6nCgul
         YT1YMwzUWhaN68caUfNexvgSPUGYnoqF8EFYhflsL6tfrTLjYCH3NBZDrSLtdvaz4QZK
         Pv9krzHxUtVc8phbwcoun9bATGs9GTs0Ya6drVoN81eGxCGZx2wnwcAJbohQqsfGIvxZ
         OBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLeUPsdctybSg2LQNs7cshVt2UuNsiXHqJBvkSSAal8=;
        b=Anm2JfhjdAxUxu1iB2i2WKZrftjFMNMud5nPuSCaf5wz/2Es+X3fp22xfZR7pACEet
         lQJbZXWz4660+yCb7SzXKdHu6DO8olBfw/EhYQp1TFCqcn75OTp4Iibfa554/hxgz1rL
         1VQufmML6WmKZ982oOn8zrJ8xnxiLhNXO2yl7Ilh1KSs82gnHOX1a2gZZD5NdwJ0/vdQ
         gpb18088x0eYpBcZcr40/HsOYp5oo0NfhpZjLc83lDL/RWfze96mQ/u+mKCV8tMa51U4
         v3osg0vQb6AZiY1wFB4/3mgnZPDo/xG87e9YwlNITfDNbaXyAoF3zgZ3LkcTpl6BkjNu
         caKg==
X-Gm-Message-State: AOAM532monXkWGeszaWXIMLJg750LGdCGEO6hXbpLO+D+74RM4FKU7dA
        MV4ssWcANuw4Jy8c1BEbTT7dWj3Ji4I=
X-Google-Smtp-Source: ABdhPJwOg6s7IBKtqWNobCU4bQx492QUr5/06k3x0MhIMP/UMbq+0XgfAza3OuPILnEHezXhRM2eWQ==
X-Received: by 2002:a17:90b:1216:: with SMTP id gl22mr10876391pjb.99.1614956880025;
        Fri, 05 Mar 2021 07:08:00 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:59 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 21/41] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Sat,  6 Mar 2021 01:06:18 +1000
Message-Id: <20210305150638.2675513-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 2 ++
 arch/powerpc/kvm/book3s_hv.c    | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8dd3cdb25338..68d94711811e 100644
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
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index ffde1917ab68..24b0680f0ad7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3623,7 +3623,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
-- 
2.23.0

