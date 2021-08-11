Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8793E9548
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhHKQCm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhHKQCm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CEEC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so4189249pjv.3
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kGMO3KzFWfaiWdxRFMMRg8fmrR2Jvox/ePS+dlDySeM=;
        b=GBHq1AcepfNTDrAR75+JWS/sN0/dqJ8bw/Rvp6fGzw1okqZFnlW8Qnbgt7Y6iwmIyZ
         Xt7vq6puT2R4K2uxhtFwtKq7ABnWTgYwz6CxtgDDokY1YaJA0OhHUKa6o2/BIxh07+qM
         yCpDwJ67cX6FF5PeU2Q4rHFGh1BjAk0+HhppMLUWYMVckZbZskLUl7k83JWLggiTlu/V
         Gc3DhoM0bUHyZk6hPHwrU+k6Cq1JWlSbMQmh/jpBKvGWq4TWtaXg+PgLZY84ExDUvghJ
         NFTNlbvQBx6pYdJKcJFgUZyHdcrYuuUysBq+pzApJcsQcnTwFUQubx65mOk9E28e4PlI
         9n+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kGMO3KzFWfaiWdxRFMMRg8fmrR2Jvox/ePS+dlDySeM=;
        b=SdPrd5pYcMRgkxRstJIq1xSgChs379RY5BScnfz1Iq1c1EtADfrHRN5q5QjGGzZcjC
         0tqTc5YRQzpAuJK6PQnGZn+TtfrKxlRiDjyay51ChoXf+tuS6xzFLOgC1ojz5GPco5vZ
         ux3TuvZh6KnJrbHbvJhqE4neIe8DaQTK7CVGJBFdZHWs73zj1wEn5LfTldsfeZlgB2Lr
         ZvAvXeVd9EH4Bkcr43LrJ3Rjk1gxJzaNM/+Dageg0CaGTPWkjH9Zh5QS8F2QqjxHSbtb
         9iNvYZCkk8KnLJNbcBWXVexQg3kWfMBtL19lBy1c8nZWMxRSVBwc+ZurA6apvyTNAbSh
         +/BQ==
X-Gm-Message-State: AOAM532CajCMDrfZdy1kdxFePIBXFm5Wra96g1A7sgEBXQs+aLvfsPmV
        dKilW50YyVUwi34jmLV837rmd7cLa6U=
X-Google-Smtp-Source: ABdhPJzups4vB4lpN4PHX/B6Vj+o5rtr93EsL4hB0BC1sN6/y7NvThkPJ47sQLjPnBOHYgkBnFRH7g==
X-Received: by 2002:a05:6a00:a0d:b029:38d:6310:36ab with SMTP id p13-20020a056a000a0db029038d631036abmr34383437pfh.34.1628697738182;
        Wed, 11 Aug 2021 09:02:18 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:17 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v2 13/60] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Thu, 12 Aug 2021 02:00:47 +1000
Message-Id: <20210811160134.904987-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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

