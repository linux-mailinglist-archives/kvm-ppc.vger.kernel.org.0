Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E8D2C722D
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733224AbgK1VuY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbgK1S52 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 13:57:28 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAABBC094254
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:55 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id v21so3685976plo.12
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wFKWODpGu/PubPvfRrSmS5+gQNDkwPMyPfZCkrp8It0=;
        b=Fpn8G7kdWEIhdOiroQ//FL7vCrlUPWHCFn7U/aQveam1mvDa931KJrceH+zmbT162l
         7cWVgUtaLyhr/Bv/iJ21MWBLwllY0eIcWM+64Eeng/LoORDEx2dkEK9GzwK4aSc68fZV
         YIDL5sEn/nYaTwymCIxiJzia42gVr2s4MrcuI7ezX57k7Y6pjpeCimXu/bx69hVnghI0
         am3pOB3hyaviYAWmXhDV9nlevGoXlEbHnXyf8kUS2m8tRJaggumx+6ZyVtrQFVYk3QCg
         y5QL/D3RhP0EqKQaTA8Um3iGzZYx7fBf3UTNwCpheXvfe2vhGU96PRoUTo+DXcOZCLCr
         nsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFKWODpGu/PubPvfRrSmS5+gQNDkwPMyPfZCkrp8It0=;
        b=RS/X4FOdbQKzGDkEswTKMnv7I0S74V4+2B5uZjXqu5ftmV3MaxRymGrwUYHtvqdL3Y
         tIKnsDkWPpp3PAl/XWkL6ZSu00VcXcRJSqF++Y5MeB2RWqs4WHETT8NqwSMlWZQ8waNp
         Nw/U9ZvZSY0R1v/95jYvmLcJHYn4KVYfl7qAKluKym91/GnmBM1jQDfb+RUfGGRyWZlM
         FeMt9CPtQfp/R0Grb90r9Ps6ZENYe/hmqCP/UZrFyqlXYembm7+7zUh7dT7sf9Z3gLhF
         W9cVIjjnEGMHf1PkqcQW1QFqj0ii6p2Z0C5JwS9/sb5UxFXqz6wcK4oCcPp1ByLAgpCN
         N8MA==
X-Gm-Message-State: AOAM531hJe685fqjq2K2nKMI25BdfkwrazMpcJRljzw6N2X+jgn5HRY5
        GdROErYmS+NnC8i5I4MwBkhuu/O+P5A=
X-Google-Smtp-Source: ABdhPJyWNXOhiyXRWScL1SC7/bU+CgYAQJVy2HytEDXfzkvUbvMXuNycwtUOD6sQzoClX0UwwJpUgg==
X-Received: by 2002:a17:902:8691:b029:d7:e0f9:b1b with SMTP id g17-20020a1709028691b02900d7e0f90b1bmr10451568plo.37.1606547275503;
        Fri, 27 Nov 2020 23:07:55 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:54 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 6/8] powerpc/64s/pseries: Add ERAT specific machine check handler
Date:   Sat, 28 Nov 2020 17:07:26 +1000
Message-Id: <20201128070728.825934-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Don't treat ERAT MCEs as SLB, don't save the SLB and use a specific
ERAT flush to recover it.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/mce.h       | 1 +
 arch/powerpc/kernel/mce_power.c      | 2 +-
 arch/powerpc/platforms/pseries/ras.c | 5 ++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/mce.h b/arch/powerpc/include/asm/mce.h
index 89aa8248a57d..e6c27ae843dc 100644
--- a/arch/powerpc/include/asm/mce.h
+++ b/arch/powerpc/include/asm/mce.h
@@ -228,6 +228,7 @@ int mce_register_notifier(struct notifier_block *nb);
 int mce_unregister_notifier(struct notifier_block *nb);
 #ifdef CONFIG_PPC_BOOK3S_64
 void flush_and_reload_slb(void);
+void flush_erat(void);
 long __machine_check_early_realmode_p7(struct pt_regs *regs);
 long __machine_check_early_realmode_p8(struct pt_regs *regs);
 long __machine_check_early_realmode_p9(struct pt_regs *regs);
diff --git a/arch/powerpc/kernel/mce_power.c b/arch/powerpc/kernel/mce_power.c
index 1372ce3f7bdd..667104d4c455 100644
--- a/arch/powerpc/kernel/mce_power.c
+++ b/arch/powerpc/kernel/mce_power.c
@@ -97,7 +97,7 @@ void flush_and_reload_slb(void)
 }
 #endif
 
-static void flush_erat(void)
+void flush_erat(void)
 {
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (!early_cpu_has_feature(CPU_FTR_ARCH_300)) {
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index b2b245b25edb..149cec2212e6 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -526,8 +526,11 @@ static int mce_handle_err_realmode(int disposition, u8 error_type)
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (disposition == RTAS_DISP_NOT_RECOVERED) {
 		switch (error_type) {
-		case	MC_ERROR_TYPE_SLB:
 		case	MC_ERROR_TYPE_ERAT:
+			flush_erat();
+			disposition = RTAS_DISP_FULLY_RECOVERED;
+			break;
+		case	MC_ERROR_TYPE_SLB:
 			/*
 			 * Store the old slb content in paca before flushing.
 			 * Print this when we go to virtual mode.
-- 
2.23.0

