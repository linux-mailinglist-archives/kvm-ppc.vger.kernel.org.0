Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B60351DB5
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhDASbo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239169AbhDASUm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:20:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5063C0F26F0
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:52 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so4860082pjb.0
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AnRl8WcjklbuN1r+S8ezp+J4WnoJSRYIUkLRybU4A+c=;
        b=hjJLJ58xCqw2n9W1fAgQE1ENpJtJC7yCoPw5A0p2EBEuhBjewx3PWPMaLnqpY98jt6
         4WkKuIOarNHMQ1EgYxvWLc60OmRhOx2AoOcezeYukUj8tQQHxIPLENXiFA/3urOPxLAC
         CHfv38uht2lfOp0LvCE4phMrcfCKJKWAVCq8UM/AEt7vyUmc3xlk6GcnPOtnYeus9D7j
         na87EpL7T/L51RQ5B9+xZ93Y9W08GyJOljilv1j8tMAEh6O0v10MLq3xf4s6Tr3gq95r
         tCZ6WMl4vdXHjnT+VGq8Y+PxKqzcJ5y9dYMcLK6cgjSQOQkAF/XAVISTjNeGsJi0JNRd
         qLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AnRl8WcjklbuN1r+S8ezp+J4WnoJSRYIUkLRybU4A+c=;
        b=tVnT97g0CbtcEQHjT5QDtVATssaZp+CiZHVi+uJBL94sNx0cNR3bFztauIZ78OkIQQ
         mQowV2cgR9tY94UKcbJpRZJtASakgPpWRYPimEcM5qGpT8mQK886unfvrdskWqyeNJ0T
         +8Cpvt0rRRFpBZIw/AW+bJ1qq5lIalCVqAqhlmZEAhJKfyLQxrZNrsOP24OWaLjGosDv
         9rcWm0yejoNV4+fmfiQ+oXrKc6gy0brOBFcvLDVbXhr49rs2eZf+ouSXvc7SHOcUDeA2
         uPlI37TpLoguOWcSI4IdQKimz8iUxof/uipthGkIUmtrWDwEkcKTYyi9KaAn1S22KpVb
         HlSQ==
X-Gm-Message-State: AOAM530NnN2zpdD5N5kH4ZEkIXFPIRWkbxYRI45ADRX9uJx2kGb+SGYz
        BbULQaIif1NHNRP4FKe/znUgWxv6U+Q=
X-Google-Smtp-Source: ABdhPJzWqS+fN/xNOWDjumhfmHUsxgAtzyt4D9N40suRo2G0aQuekZDB9ZNXHBOdbMAMNbbncGPFtQ==
X-Received: by 2002:a17:902:a415:b029:e7:137b:ef9c with SMTP id p21-20020a170902a415b02900e7137bef9cmr8184075plq.28.1617289492221;
        Thu, 01 Apr 2021 08:04:52 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:52 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 24/48] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Fri,  2 Apr 2021 01:03:01 +1000
Message-Id: <20210401150325.442125-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/time.h | 2 ++
 arch/powerpc/kernel/time.c      | 1 +
 arch/powerpc/kvm/book3s_hv.c    | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

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
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b67d93a609a2..fc42594c8223 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase = {
 
 #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
 u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max); /* for KVM HDEC */
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c249f77ea08c..7afa2e7a2867 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3669,7 +3669,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
-- 
2.23.0

