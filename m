Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075453250CA
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhBYNsr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhBYNsp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:45 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF4CC06121D
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:16 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u11so3198591plg.13
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxpw7NhXAqb/o/SA9VUSgxQVhLanI9uq2XV1Nk13yao=;
        b=IUX2I6OTL090eZq9oSuMpuIzDkT/w0BAUY9dM4H/gj8fOb1/0snrh1axsLvw7P0TY+
         +Ee8uqBb8mHfvPTSBnOXJ0Oqg/56xDgKtlV3wtBwexeyFoUbn8leVkYvYqYP8wZAXJZI
         Iod6zIfWQrSzZqcQFrrCcqEwP4GNhRoJ/XiOauKwDqhHA4cpZUnXF8INaqtBzMBmEG9a
         p4tR3H+wbQGidMvLF/Wd215bSCbbLPrjQiVTNsHSgqPc5XDLGqvEmEB11k4Jqd9h+2YA
         ITImTlSSyJoZTxeRQSq1WNzRtBgw2cOWnyDuQlKYashzkv3qHwjaz+Pc/UiGr2NvT77O
         DzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxpw7NhXAqb/o/SA9VUSgxQVhLanI9uq2XV1Nk13yao=;
        b=oWVramweRpN128QL3ExRuqQMBP4c8HjzZQMKeewlM6cXZAc0O4pnIevm7E4E0HbVPk
         S6r7B0sVg3PFnTWHFPurKoHrfQe9hkjYkuR1BNKykKdezJEzPKF3Tt8jKUUDPthAVpEi
         hzn6R5Jz1GNjQkz8X1u88LdD2Z8ehynAOmlVkY2xKPA7vXxfOK+eCUmAyGLGSM7WhYuQ
         ba/N7jsCup1v3qpclzGajc6jOshIEpBsGyrXNdWpfFZjn1/j+hkUM3z1PiLRo2wbiKYu
         vo+KPgmJT4pVTFcLikhkfYuLiCPCNobFcJeaiFKn6gAzSygy8W9DHCeiBWPlbGHzeeea
         r/PA==
X-Gm-Message-State: AOAM533qSAEoQ0I+lOZhr4WLf3WbCSCCJprLpgBYNoV0nba68UvMn3Xu
        CdnFde65QfvoRYhcAZuNrd4G8pVx9Xc=
X-Google-Smtp-Source: ABdhPJzWKocZMPhw3t5VEokOjJwf9KuPQSGR3JgqR13o4xrBqpGbZyYOou3wP+GEte7t6dMLVwz5VA==
X-Received: by 2002:a17:902:eccb:b029:e3:b2e3:a21b with SMTP id a11-20020a170902eccbb02900e3b2e3a21bmr3149912plh.41.1614260895676;
        Thu, 25 Feb 2021 05:48:15 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:48:15 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 21/37] powerpc: add set_dec_or_work API for safely updating decrementer
Date:   Thu, 25 Feb 2021 23:46:36 +1000
Message-Id: <20210225134652.2127648-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Decrementer updates must always check for new irq work to avoid an
irq work decrementer interrupt being lost.

Add an API for this in the timer code so callers don't have to care
about details.

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
index b67d93a609a2..e35156858e6e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -561,6 +561,15 @@ void arch_irq_work_raise(void)
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
@@ -628,10 +637,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
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
 
@@ -873,11 +879,7 @@ static int decrementer_set_next_event(unsigned long evt,
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

