Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6262351A2D
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhDAR6d (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236874AbhDARzb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:55:31 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3A5C0F26F7
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:07 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w10so113866pgh.5
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYbqEsaUakOZcKDP44CXSbuy6ADhIURwrH6b8BRzEWY=;
        b=ORq9FguWtspkdfF7k9WGUjDQfLSMFX3skUDySAnG7YiEPuR/E96Ub8MmE60MO7tiGR
         kfCxnMph/r1rdY3odBP6Pe4zWC5WrZnwmXjerW5ZXCuzI26zCQ2i1NQGWFxVR2vX1Qqq
         GVbUzxFJP/ZTRI6atTheagKyjIgYBu/JPvd1MG1ejE1XBk8yJS+I3wsslWXXyJoE0/m7
         zH9X2MmiJIXnafk12lcti8WGB2Op7p72CG5iqZ7tTBBDSzDo+F0+2WbvNlsyHI53L1Hx
         3rOFOPKaS3RffeOw13b+pHoyWKYarc1grPFD3Z8UroJAO5cFL7KVB5HPk8O6LZoRg8OV
         ZymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vYbqEsaUakOZcKDP44CXSbuy6ADhIURwrH6b8BRzEWY=;
        b=a0hwn7yEMgXYNQzecEE1UgNKVSD4vkQwd9etn3KOO1pKsNBcfC1Vl+2nmmJv3Nj+dA
         zXkAA8YftrzNfH2TILGjlGdzrXEMSqHAtnEJZ2iD1Fm4vLKlBLA5Ou0Y3NdtLizgOLEn
         sUuLjyChk0Ox9gEQCLO+GqcPyQqUlJkcPUwlLEeEDqWvArCJQ7sWIZR0upEYWzQ17eTi
         BKitd5dOuc5rqs9SAi433ETURGwl83RmOUS4NjQapTPsMu2clIgtx80kU/RTpwTY/sO7
         n/L/gwxzG44t1jX+Jmes4h14jclC90u6ILoHqH6Kv6KjF4OdylyygCuSJwf1JQh4mYd4
         +43Q==
X-Gm-Message-State: AOAM532F2nCwkgtAOIZ/mbq66s33UyKQurWZOSQFxovuElnf3TmYoa0J
        N9kw2qy8TOvO40aZo4RxZKlwYBXngHE=
X-Google-Smtp-Source: ABdhPJz+phMWQqFOhwgenjWJWyz7hHbeXIeobGcIgLJQc7XyKN7y0XZrOHPxFh4Kp6ud9R70Z7U1Qw==
X-Received: by 2002:a63:de46:: with SMTP id y6mr7960471pgi.295.1617289506879;
        Thu, 01 Apr 2021 08:05:06 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 29/48] powerpc: add set_dec_or_work API for safely updating decrementer
Date:   Fri,  2 Apr 2021 01:03:06 +1000
Message-Id: <20210401150325.442125-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/time.h |  4 ++++
 arch/powerpc/kernel/time.c      | 41 +++++++++++++++++++++++++--------
 arch/powerpc/kvm/book3s_hv.c    |  6 +----
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 0128cd9769bc..924b2157882f 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -106,6 +106,10 @@ static inline u64 timer_get_next_tb(void)
 	return __this_cpu_read(decrementers_next_tb);
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+void timer_rearm_host_dec(u64 now);
+#endif
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 8b9b38a8ce57..8bbcc6be40c0 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -563,13 +563,43 @@ void arch_irq_work_raise(void)
 	preempt_enable();
 }
 
+static void set_dec_or_work(u64 val)
+{
+	set_dec(val);
+	/* We may have raced with new irq work */
+	if (unlikely(test_irq_work_pending()))
+		set_dec(1);
+}
+
 #else  /* CONFIG_IRQ_WORK */
 
 #define test_irq_work_pending()	0
 #define clear_irq_work_pending()
 
+static void set_dec_or_work(u64 val)
+{
+	set_dec(val);
+}
 #endif /* CONFIG_IRQ_WORK */
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+void timer_rearm_host_dec(u64 now)
+{
+	u64 *next_tb = this_cpu_ptr(&decrementers_next_tb);
+
+	WARN_ON_ONCE(!arch_irqs_disabled());
+	WARN_ON_ONCE(mfmsr() & MSR_EE);
+
+	if (now >= *next_tb) {
+		now = *next_tb - now;
+		set_dec_or_work(now);
+	} else {
+		local_paca->irq_happened |= PACA_IRQ_DEC;
+	}
+}
+EXPORT_SYMBOL_GPL(timer_rearm_host_dec);
+#endif
+
 /*
  * timer_interrupt - gets called when the decrementer overflows,
  * with interrupts disabled.
@@ -630,10 +660,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
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
 
@@ -875,11 +902,7 @@ static int decrementer_set_next_event(unsigned long evt,
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
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8c8df88eec8c..287042b4afb5 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3901,11 +3901,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	next_timer = timer_get_next_tb();
-	set_dec(next_timer - tb);
-	/* We may have raced with new irq work */
-	if (test_irq_work_pending())
-		set_dec(1);
+	timer_rearm_host_dec(tb);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

