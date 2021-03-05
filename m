Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61EE32EDDB
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhCEPIp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhCEPIS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:18 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317C3C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:18 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s23so2211903pji.1
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jk8vfy/yd/4qy8LE9BxE9tg9OnF6uS84O1SR+0v77vw=;
        b=WgjQLPaqu6aoKNSDRXtz8B18qbOh+7UvJgCd8fmmdBE2xEQNRWESSqnDEm2wCP3e23
         CPQq/BF7KwJhQujm8ylYnF74PEhzyxcKuaDw4sJNDeRMmz4PegRqku4QqCqmIX6UEeZZ
         78wgfGf/LSHagSETh+t9t5uI5RWrLGnPVn1WYy2SUZElHj/DUIwsIt0Rtv6JJ8ZxrxIO
         yHfNWdeTxRsHEmFhMycHpl1BoncOnw+iVpLxevDXNn6GYhd2c0bFmAM1lx1mxdEywzSg
         GrPiqzhTEWNi5vR5JqQ3yEVyNVtwRgWlWh490LjLhqjQoCkJVwyYKUnB4bn6CPDD3tc8
         OKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jk8vfy/yd/4qy8LE9BxE9tg9OnF6uS84O1SR+0v77vw=;
        b=SIHoEqZBC8UXcaXbIi9lLlSQI230oow/NChIJwxXKxLTK9Qhs8OBWH06U4k4o5+CiR
         rV3zbEVZ1boogU63aBQ6N2vE85+j0AUEzUcMlhNh7XkDXLoXcsuy8tzFDznHGjUjVU/Q
         72FR9LxyvZ1VI45VOlE5flRFHchmp4L7zRViyPmEg3HK+P244gNT3NAhb2rR7Oc1SO44
         2eROfRpgu/lKB9PwttAbnILV6k6H0eFr+BNCms+/g27yBPm5bqgiSAUMwhNYm7I/fd8Q
         P/icaPievf5ZBTi7Abb640jnt6Lp2Rf8vaWKEb0UOIF1RfxkdLoJjrgPwjfAQJrCE2dh
         dR6w==
X-Gm-Message-State: AOAM532FQan6crDQkXN+ZrgZt7oWz2Twro9vJrqOJdUYSvhBiv83Mncp
        Z0a1+aA15Kr6k9Z/9VmijpKNb2J6E5c=
X-Google-Smtp-Source: ABdhPJx5amxiiOZmSQTIOQLyBrW/VZXIOOtAOqAsBhKIbOG3wYYvK9tDB1FhuAbm+vzGhxsjgCJftg==
X-Received: by 2002:a17:90a:f403:: with SMTP id ch3mr9074018pjb.126.1614956897305;
        Fri, 05 Mar 2021 07:08:17 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:16 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 24/41] powerpc: add set_dec_or_work API for safely updating decrementer
Date:   Sat,  6 Mar 2021 01:06:21 +1000
Message-Id: <20210305150638.2675513-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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

