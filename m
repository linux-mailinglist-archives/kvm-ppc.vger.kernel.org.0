Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE3F42134D
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhJDQDI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQDI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B054C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id l6so190188plh.9
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LQhPOKpl3GkDq6Ycw92AS+eSUqd4zxHUUEoaeQSTY5Q=;
        b=lof2rgwz1vy9wv3Y0An3iEwB579gF1PViDlOu+ZUhifJdlvZve8lSb1UA9sPFRsap3
         wMNEj0oocaNAQ9lWXfSoyMoxRO3ASZOdiFvjgIVVyZvOn79qfzGWCkMRP+O7nzcWU93y
         ga9gjZwS6uAHf0F/dzbkFvsAc20oIxd9OvbMroYs2g1a5WgrIwK/N9B+CQkoQZ4xNUd6
         1C8pe/wiKYB2IE6cVtUw7nyJVadDC+s8m593XWS2CMz1Pjuqlwg+6O9DQO/PQHcsz0rd
         DkDJ7P++uRKmbm0bMHHf9RwOCTysjOoBZ9mxKae8pwpPI5s0h7xBhaU4bT6U30sli8rD
         EQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LQhPOKpl3GkDq6Ycw92AS+eSUqd4zxHUUEoaeQSTY5Q=;
        b=22y+V+AwYlJx77aycyTb0MMfaNWUx+iS1VAtB4VkYTpzdLee61OdvYnlqSboO5hCqE
         6+ABKOld8Dha+34Eg6bBXAJHg9W4NQKikjWr7PFVRAK6VxXYh1JHfwJw/EBHbzN6BLqM
         mOcPk9VSMLsDwoW6QxdNXTvv6RGbHYhYfcTbcIgXZmNZh3W/NOxkbVFgLgFuR6X2RIld
         wSfq+/EHeBKcF7F/pM079GigMGWEq1EATZ7mzRNB0HiojHG6/6hnHqkpi97zSSeW6F1U
         xHbo/i8VRMYr0iJr/i39ToH5J/VekrOKe4gz2DFrqq5HRw6RtSTAv8OJ0X9DO9MuJnbV
         ZRlg==
X-Gm-Message-State: AOAM533BayDNVRZYNOTlZ3rSOyfb60nlp3kLmJXQXDmKH0J0PHo/SHpo
        x112hsLplajoe9jSZw3R3OnW4lg7vII=
X-Google-Smtp-Source: ABdhPJyKBZmqCEQvKUFl4I6ASPt21mQNAKY5FJhVPYwKHKUUS3NLUMqpnb1n08wFKEBYLNNrPJk3Zw==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr38334813pjs.48.1633363278547;
        Mon, 04 Oct 2021 09:01:18 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:18 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 07/52] powerpc/time: add API for KVM to re-arm the host timer/decrementer
Date:   Tue,  5 Oct 2021 02:00:04 +1000
Message-Id: <20211004160049.1338837-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 6ce40d2ac201..2a6c118a43fb 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -498,6 +498,16 @@ EXPORT_SYMBOL(profile_pc);
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
@@ -541,13 +551,44 @@ void arch_irq_work_raise(void)
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
@@ -608,10 +649,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
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
 
@@ -853,11 +891,7 @@ static int decrementer_set_next_event(unsigned long evt,
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
index e4482bf546ed..e83c7aa7dbba 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4049,11 +4049,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

