Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591413D51B1
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhGZDK4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhGZDKz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA23C061765
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d17so9978944plh.10
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7DsHP7bEgsQeWVqOdKD4J0H7e5jZZDtouJKkt2bv9y4=;
        b=q80DHRZ+j/5oGFd8p2r+7t8/6URh2MCVRukwkrr2FzTHLY8A+Wb4PzUUB4J6jiy+QQ
         YtZztDSSuGAVZDm+XbyiyhTd+6s+r/DY2u8vbCpWxZ5x+Pl7FevjgYigP3Ueo3CvqGyk
         dV1CXHddFIvgDfoZ3eASIqmrJjux3ZweQNo7DGKUGBXiJpWX8m7k8vigYc7m9+ulAIGM
         g7l+2RYNBg2L+F+YI7oVxoXvuAL5uucY7l44KRaVl2973NZzevssOJ/xcILM+37OTZ5e
         mb51zJ+7YYffOWBV/TzukzhczHN5Yc06x885Pwe223fLCPJy7xcBZf5awVU0L8+QJE7+
         +xyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DsHP7bEgsQeWVqOdKD4J0H7e5jZZDtouJKkt2bv9y4=;
        b=KgjNRpDGVhGOeZA0GMGHnTUhqt5OA+usy/SNSJxhFwhAHVuVTM/kOaO+cACGJ11w/A
         mCjV1gHyY5p9s7UeqML05948/odoB6IsvNj5yBTDO6X3NfzB3CpSW9VME9D/v6OVeBOK
         gEOUu2RAJKjJo9NnaFP+UdIhphCG8eqMfQnan/8Rbl5HVRPDL/OsHSrQeoeW5Jb0ou2y
         9pQ5clGeL8KK59hII+nSuvSAXuafIIyinXHe0/Hra/HJlpokNqxVi/KgVizRiO+XOp32
         CnCB/Qkax2/4YRpOwPTCX4VzalbYAa5Y/SCDgX1cHYfIQlq3Z/xEeoPf51QtyI2eczSL
         nm8Q==
X-Gm-Message-State: AOAM531ebt9v1JvA6/CDDPYmJguXgYQKxR7oyjOEIZditmWvHZBKe8p+
        H83nGICEYmA5FMZanjJeI3VXE8c4Xnk=
X-Google-Smtp-Source: ABdhPJz61NMHUJ9SfTGmWPSMM0Xm/MVj7Ndh+xqpp743u8kDhk9xa9Ov9ISIxt7fs+xvDXooV0LwUg==
X-Received: by 2002:aa7:804f:0:b029:334:4951:da88 with SMTP id y15-20020aa7804f0000b02903344951da88mr15789879pfm.29.1627271483402;
        Sun, 25 Jul 2021 20:51:23 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:51:23 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 16/55] powerpc/64s: Implement PMU override command line option
Date:   Mon, 26 Jul 2021 13:49:57 +1000
Message-Id: <20210726035036.739609-17-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

It can be useful in simulators (with very constrained environments)
to allow some PMCs to run from boot so they can be sampled directly
by a test harness, rather than having to run perf.

A previous change freezes counters at boot by default, so provide
a boot time option to un-freeze (plus a bit more flexibility).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++++
 arch/powerpc/perf/core-book3s.c               | 35 +++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index bdb22006f713..96b7d0ebaa40 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4089,6 +4089,13 @@
 			Override pmtimer IOPort with a hex value.
 			e.g. pmtmr=0x508
 
+	pmu=		[PPC] Manually enable the PMU.
+			Enable the PMU by setting MMCR0 to 0 (clear FC bit).
+			This option is implemented for Book3S processors.
+			If a number is given, then MMCR1 is set to that number,
+			otherwise (e.g., 'pmu=on'), it is left 0. The perf
+			subsystem is disabled if this option is used.
+
 	pm_debug_messages	[SUSPEND,KNL]
 			Enable suspend/resume debug messages during boot up.
 
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 65795cadb475..e7cef4fe17d7 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2428,8 +2428,24 @@ int register_power_pmu(struct power_pmu *pmu)
 }
 
 #ifdef CONFIG_PPC64
+static bool pmu_override = false;
+static unsigned long pmu_override_val;
+static void do_pmu_override(void *data)
+{
+	ppc_set_pmu_inuse(1);
+	if (pmu_override_val)
+		mtspr(SPRN_MMCR1, pmu_override_val);
+	mtspr(SPRN_MMCR0, mfspr(SPRN_MMCR0) & ~MMCR0_FC);
+}
+
 static int __init init_ppc64_pmu(void)
 {
+	if (cpu_has_feature(CPU_FTR_HVMODE) && pmu_override) {
+		printk(KERN_WARNING "perf: disabling perf due to pmu= command line option.\n");
+		on_each_cpu(do_pmu_override, NULL, 1);
+		return 0;
+	}
+
 	/* run through all the pmu drivers one at a time */
 	if (!init_power5_pmu())
 		return 0;
@@ -2451,4 +2467,23 @@ static int __init init_ppc64_pmu(void)
 		return init_generic_compat_pmu();
 }
 early_initcall(init_ppc64_pmu);
+
+static int __init pmu_setup(char *str)
+{
+	unsigned long val;
+
+	if (!early_cpu_has_feature(CPU_FTR_HVMODE))
+		return 0;
+
+	pmu_override = true;
+
+	if (kstrtoul(str, 0, &val))
+		val = 0;
+
+	pmu_override_val = val;
+
+	return 1;
+}
+__setup("pmu=", pmu_setup);
+
 #endif
-- 
2.23.0

