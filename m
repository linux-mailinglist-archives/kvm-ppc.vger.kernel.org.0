Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3543D51AB
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhGZDKn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A5DC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:11 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ch6so2114925pjb.5
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U+hxFadF7rDD737thjtwTXg1szqkFi6egNx7RN8wOw8=;
        b=lBOAk8ysarc37c5RgJdg+ncx9+W7XJTFZnI0pdmZH5q/UvOOHorvI48Z5LsZ1UaQiU
         rjKl2iMAy+n5Cy2T93ZKIckWqIHl4I4afXgLtgC1YgdMPkfF8Eq5lC6NlY8QJgMYihHL
         LnbOlEDw+BlpFHcyo6wvdFC/fE+wrcOfp3WNnrgsg8aHR5QYLwFYJ0VKg2cCHvgsYsN6
         9L2vqPXOZoRLWTWm8pH8G0+x75lor/VzFieUdoV0Sl4WYrlbqrmJ8ItbY3jDw8rgjEXJ
         0Dxe48kPj1l1uKDn4zsw1wgYl4hZO1rjATeZCePf3Abb3vfgh4mCvs9+IaCK1qtPO8Y4
         nT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+hxFadF7rDD737thjtwTXg1szqkFi6egNx7RN8wOw8=;
        b=aVcjj/7nu5K7/Oiv18eMk6uMR0bPDlrtGdbEzk1+hAJoOIgQe9HtUKTMQCHb1o5/mO
         OhqCS1ik54ShPKrmXb6Z4sl1hDID0C4nE/rOvEWjFVRgvzZ+r/oijkxuZvnpSMwb2OMf
         VPh89GUngX/ZNAjLYPnCBju18dRgy3w5AO9i2L2IUngLSym9uTYBdT2EJjLXTdH+s80k
         US+pNYMpW/u0eScbmPr6iD7ksRMk6VBeQrSHOjcbkEJBFbnKTY6ANIXdy9trUrEq4ViE
         zVrJFuT0VeYDv4EWI1Mc2jQC5dFWrmKws5ZZCUVu5VFC+i1uvaf8//9NlqmKXvWKdAUk
         fWTQ==
X-Gm-Message-State: AOAM532khtyWNW5ybOOKzJjSO4ZjDwKcX1k9WSHVoD4XOeLIR//YAFf0
        uHZ2AWBgfM8VMAjv2HoJCBAmeH+vSzQ=
X-Google-Smtp-Source: ABdhPJyERyuOio4qvoqLtz/rUqcHpCZaHWROFblTuPaA1JSruI9r5uXy4KMCWGiK/KExivVaqPDNZw==
X-Received: by 2002:a65:61ab:: with SMTP id i11mr16390663pgv.168.1627271471238;
        Sun, 25 Jul 2021 20:51:11 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:11 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 11/55] powerpc/time: add API for KVM to re-arm the host timer/decrementer
Date:   Mon, 26 Jul 2021 13:49:52 +1000
Message-Id: <20210726035036.739609-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than have KVM look up the host timer and fiddle with the
irq-work internal details, have the powerpc/time.c code provide a
function for KVM to re-arm the Linux timer code when exiting a
guest.

This is implementation has an improvement over existing code of
marking a decrementer interrupt as soft-pending if a timer has
expired, rather than setting DEC to a -ve value, which tended to
cause host timers to take two interrupts (first hdec to exit the
guest, then the immediate dec).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 16 +++-------
 arch/powerpc/kernel/time.c      | 52 +++++++++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv.c    |  7 ++---
 3 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 69b6be617772..924b2157882f 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -99,18 +99,6 @@ extern void div128_by_32(u64 dividend_high, u64 dividend_low,
 extern void secondary_cpu_time_init(void);
 extern void __init time_init(void);
 
-#ifdef CONFIG_PPC64
-static inline unsigned long test_irq_work_pending(void)
-{
-	unsigned long x;
-
-	asm volatile("lbz %0,%1(13)"
-		: "=r" (x)
-		: "i" (offsetof(struct paca_struct, irq_work_pending)));
-	return x;
-}
-#endif
-
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
 static inline u64 timer_get_next_tb(void)
@@ -118,6 +106,10 @@ static inline u64 timer_get_next_tb(void)
 	return __this_cpu_read(decrementers_next_tb);
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+void timer_rearm_host_dec(u64 now);
+#endif
+
 /* Convert timebase ticks to nanoseconds */
 unsigned long long tb_to_ns(unsigned long long tb_ticks);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 72d872b49167..016828b7401b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -499,6 +499,16 @@ EXPORT_SYMBOL(profile_pc);
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
  */
 #ifdef CONFIG_PPC64
+static inline unsigned long test_irq_work_pending(void)
+{
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, irq_work_pending)));
+	return x;
+}
+
 static inline void set_irq_work_pending_flag(void)
 {
 	asm volatile("stb %0,%1(13)" : :
@@ -542,13 +552,44 @@ void arch_irq_work_raise(void)
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
+		local_paca->irq_happened |= PACA_IRQ_DEC;
+	} else {
+		now = *next_tb - now;
+		if (now <= decrementer_max)
+			set_dec_or_work(now);
+	}
+}
+EXPORT_SYMBOL_GPL(timer_rearm_host_dec);
+#endif
+
 /*
  * timer_interrupt - gets called when the decrementer overflows,
  * with interrupts disabled.
@@ -609,10 +650,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
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
 
@@ -854,11 +892,7 @@ static int decrementer_set_next_event(unsigned long evt,
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
index 6e6cfb10e9bb..0cef578930f9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4018,11 +4018,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
 
-	next_timer = timer_get_next_tb();
-	set_dec(next_timer - tb);
-	/* We may have raced with new irq work */
-	if (test_irq_work_pending())
-		set_dec(1);
+	timer_rearm_host_dec(tb);
+
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

