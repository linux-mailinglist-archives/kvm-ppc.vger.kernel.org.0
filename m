Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215D0353AA5
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhDEBVu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhDEBVs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:48 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4C2C0613E6
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:43 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t20so4905745plr.13
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cd6t9aTE+ivLiFaiPdzeNP2ex++q6hisetNhEX3OXsw=;
        b=LREuIrsaCjYT8AboqP4MfBoV3/XCl++F7ttb+RX3mwsD7vP8v3Oi5X4r2DkyjSN431
         kWuZhm87hRLZoDBzJ7Qk3mAS5tUITmf0Bx7rCWjlkNinF1Icsvp1y4Cm1+duLvyGJ8Q9
         MIFUrWTaBhIaerG22AxSTpmupYLeDBIF0JE9R73FN6YUW8Nx4TfmTQ3928+YarBHemHH
         LQvAyO77o/tu+Ujdq/B3mjz7jmTmtT9LojRX93w4HFU5LB2EkW024lWque8r28DP9pEs
         LU6R5QthVPPq51WFAI7UnKjnuz3btLRbw22aQulnkrOBvV9Iy37OiZLnDMVGGezxxgQK
         p6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cd6t9aTE+ivLiFaiPdzeNP2ex++q6hisetNhEX3OXsw=;
        b=ozuLVaI0oyjeFHDaXUp9bi0vnDw8X0xul8UecE+uy5klGzmB/WpN4e7/5YJuF+FOjB
         np2LAaPYlCHyvKtZZcFDuUS5qDQlI6uizOy1JiqUhtC/lo2YIMz2WQHNtimavHeYBlqs
         q2INGDteG7nKpwGjZeF1FafkZmZacQrx2dpGj2WFdFRMYLY4r7vxms6W/aXiq+8d6J4K
         LSqtp5vs7GsvORa1JMWQ3YviTXU2QglKBhvcXoHej/Py8TRudywLR1oTTOf+XVuZ9JH5
         GE8AJu7HP/iPpzyvurLe1OKRyzx4SFf+ELVGxTyl4meLfXIQ2WAhLti5cqfE9zCfErQN
         dLUQ==
X-Gm-Message-State: AOAM531a8IouN/PfTgQDUjRBhvmL3CDssG2O1e4/vMYCF6uGCdnGAP+w
        tRkHy9YVwEJnuzCiUsDGtS8FHEyvpwVPNw==
X-Google-Smtp-Source: ABdhPJy6xdTPqpr/7ODLjZgW9V1v5ekNi6yVVZF4iPqdbpjZdSsV1KfahPb5OxVnyQg0k3af88ZEyg==
X-Received: by 2002:a17:90b:4d0f:: with SMTP id mw15mr24363649pjb.92.1617585702565;
        Sun, 04 Apr 2021 18:21:42 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:42 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 29/48] powerpc/time: add API for KVM to re-arm the host timer/decrementer
Date:   Mon,  5 Apr 2021 11:19:29 +1000
Message-Id: <20210405011948.675354-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index 65ddae3958ab..353a0c8b79fa 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3907,11 +3907,7 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
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

