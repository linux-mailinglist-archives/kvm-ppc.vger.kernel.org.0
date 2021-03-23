Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47C4345487
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhCWBEx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhCWBEj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422C1C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so4146421pjb.0
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpgAHr4lPncc4R5huY2gufv6w8hrEYHtSJr/paKKtqw=;
        b=uWtFeu8Es0RvfJMJsETLxXicV1fOHor2vBEazg2o60jHN95FbgAlb2rG2+abqUWy8a
         tEArAF/jorgkSJ/X7iIOBfJH6Ex4KcYaz5fUcOXUNJBatWBge7JohZ0x+By5bydsdZjR
         gZuBuc/kOxszUp5NfliajaEpkRleSU+wiHEqD96q9/GauxEHXEE/Db7u36HT5sgrnwC0
         8MoOMMv90ZQKgiIE7qgg0gYzG9f5+/Hg+2pV8TSPaMdfQeeBTtyGJrFODytvesXQS3NS
         TXFWzksRh+zmpt/v/yr8yfb5A+7UJktHiw+vx1ZuvpJZffTEBgT5/XjpHVRB+T9yihJS
         1W7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpgAHr4lPncc4R5huY2gufv6w8hrEYHtSJr/paKKtqw=;
        b=RpIqlgMIVJv8Ey1tZh1EvFuWfmjmrOf95bugswdsAhPLaTMcj3qIg2v6xb5GbpX9b1
         7YLYWiPZ6JeV/NV5Rmqe0FuEX83Xa2ME9gDQXxJQssolJzFU5EWkA637w1C/T3n2Ufkl
         nftNvbCAK4B9veVNDexAYQgf2HnQ53hs8UjSwT1fBNODIMQuizNkF55yNGwVo8Ilwham
         Nlt+LQ7cage6DzgOvQbP1ZF+oIZpk/iyAZTa4KrkqFdTafTCgQ7A+iFUMnIdT2Eg3UvU
         gmCBvOnzLugo/JfIOyr45NeTWb51woTIZLamQvlSR0iD77Ckizue6wDQxE8E89LNo5Ze
         z7tw==
X-Gm-Message-State: AOAM532SsnkOkOTS+ZJW7sRnmt/V7sHwZUklbwdhDq6jnLMp1nKm8l29
        She//Sofm4TUPe1NkOjaE7GEIYkgaQc=
X-Google-Smtp-Source: ABdhPJw1pEYA6GuXuGP0ehPlfFkdfhUHwMNPJ68hNEODejRzOlO7ltmQoR1bkvqKc2pNqR1xw/+ygQ==
X-Received: by 2002:a17:90a:bb81:: with SMTP id v1mr1803111pjr.123.1616461478726;
        Mon, 22 Mar 2021 18:04:38 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 27/46] powerpc: add set_dec_or_work API for safely updating decrementer
Date:   Tue, 23 Mar 2021 11:02:46 +1000
Message-Id: <20210323010305.1045293-28-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Decrementer updates must always check for new irq work to avoid an
irq work decrementer interrupt being lost.

Add an API for this in the timer code so callers don't have to care
about details.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h |  9 +++++++++
 arch/powerpc/kernel/time.c      | 20 +++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 0128cd9769bc..d62bde57bf02 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -78,6 +78,15 @@ static inline void set_dec(u64 val)
 		mtspr(SPRN_DEC, val - 1);
 }
 
+#ifdef CONFIG_IRQ_WORK
+void set_dec_or_work(u64 val);
+#else
+static inline void set_dec_or_work(u64 val)
+{
+	set_dec(val);
+}
+#endif
+
 static inline unsigned long tb_ticks_since(unsigned long tstamp)
 {
 	return mftb() - tstamp;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index c5d524622c17..341cc8442e5e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -562,6 +562,15 @@ void arch_irq_work_raise(void)
 	preempt_enable();
 }
 
+void set_dec_or_work(u64 val)
+{
+	set_dec(val);
+	/* We may have raced with new irq work */
+	if (unlikely(test_irq_work_pending()))
+		set_dec(1);
+}
+EXPORT_SYMBOL_GPL(set_dec_or_work);
+
 #else  /* CONFIG_IRQ_WORK */
 
 #define test_irq_work_pending()	0
@@ -629,10 +638,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
 	} else {
 		now = *next_tb - now;
 		if (now <= decrementer_max)
-			set_dec(now);
-		/* We may have raced with new irq work */
-		if (test_irq_work_pending())
-			set_dec(1);
+			set_dec_or_work(now);
 		__this_cpu_inc(irq_stat.timer_irqs_others);
 	}
 
@@ -874,11 +880,7 @@ static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev)
 {
 	__this_cpu_write(decrementers_next_tb, get_tb() + evt);
-	set_dec(evt);
-
-	/* We may have raced with new irq work */
-	if (test_irq_work_pending())
-		set_dec(1);
+	set_dec_or_work(evt);
 
 	return 0;
 }
-- 
2.23.0

