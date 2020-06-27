Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1374820C29F
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Jun 2020 17:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgF0PEx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 27 Jun 2020 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgF0PEx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 27 Jun 2020 11:04:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0199C061794
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so11375898wmg.1
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcYsmTzhEp8xx6FEht3XE+3X/L1jPFAQ52+7Dv3gK8g=;
        b=BpT4/FNx/etJ//DvyDsL3xQ8EMx/6WOSdzy0U3kj60HjYtYDdwEz6GSYvD7hC4kXEV
         EP2xX6uJptQIaxwNrX4HSj0hVe8VAVSByyZgmTWtVRiD/x5KcElJkA0/gjisoQ40ZVlG
         2LFBc1uLiRlsNlY1rElBp6Mz1qwc5bLJ+CBuMll3oUDCCkbqUhapTjCgbkdV5XTsM7lR
         PBxVFLSetCp1v+6amG+jiEoxAYrB1VlB1Ah+4dGabhYcxhbHd82ac6AmJKm2V7H85aNN
         uEs+KfzWvkQrsyTEzItviN6gc8M7KySEsfDu8Y0wcO/RdeErbawEB3C+BT6QCEjCqV2V
         FP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcYsmTzhEp8xx6FEht3XE+3X/L1jPFAQ52+7Dv3gK8g=;
        b=UXlWogKC4FLbfIr++/L4O0kc34575kzsxcEb2eTbdKXBPQqFSz2JP8KB6oiDNwN3vm
         UvGWWj+1ttj1K6C6t6DhTNiCwMpxMw2He8hYTduQRy5KvZPY4QUZ59eDg2wphhVqDuu+
         ibUi7PXuteHNGBwYKJZnjINgEfF7e1jJfXnZ3Hv5nhDDm6AvH9wuKaDrib5UJ5jDqfFp
         Et9ql4z5UxQrPEyZ5DZCuwv2/sAeFfFvBmwO2BFYYDhtC4otZh2D3GDQfjskGi3FLMg1
         SfEQDbM4Tl+KmuvWLRcdRn5lgo2/RslrbOecNLVrbv0pNHSYd5igj8vgpJTW8wuE40zO
         krLA==
X-Gm-Message-State: AOAM5308WsmssIyZobhkKGkwWyfci5wnj90UDiOj/Szbik4QeHSOebUi
        j9ks763gwdShZZI75sTG79w=
X-Google-Smtp-Source: ABdhPJzayRlbE2c61cAd22ablp2wLNu6moYY/lO7NxFkLoDNKj25ezzEFbh69aUCYHixk0AEfkoq9Q==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr8512913wmg.74.1593270291394;
        Sat, 27 Jun 2020 08:04:51 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id d132sm21722029wmd.35.2020.06.27.08.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 08:04:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 2/3] powerpc/pseries: Use doorbells even if XIVE is available
Date:   Sun, 28 Jun 2020 01:04:27 +1000
Message-Id: <20200627150428.2525192-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200627150428.2525192-1-npiggin@gmail.com>
References: <20200627150428.2525192-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

KVM supports msgsndp in guests by trapping and emulating the
instruction, so it was decided to always use XIVE for IPIs if it is
available. However on PowerVM systems, msgsndp can be used and gives
better performance. On large systems, high XIVE interrupt rates can
have sub-linear scaling, and using msgsndp can reduce the load on
the interrupt controller.

So switch to using core local doorbells even if XIVE is available.
This reduces performance for KVM guests with an SMT topology by
about 50% for ping-pong context switching between SMT vCPUs. An
option vector (or dt-cpu-ftrs) could be defined to disable msgsndp
to get KVM performance back.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/platforms/pseries/smp.c | 54 ++++++++++++++++++----------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 6891710833be..67e6ad5076ce 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -188,13 +188,16 @@ static int pseries_smp_prepare_cpu(int cpu)
 	return 0;
 }
 
-static void smp_pseries_cause_ipi(int cpu)
+/* Cause IPI as setup by the interrupt controller (xics or xive) */
+static void (*ic_cause_ipi)(int cpu) __ro_after_init;
+
+/* Use msgsndp doorbells target is a sibling, else use interrupt controller */
+static void dbell_or_ic_cause_ipi(int cpu)
 {
-	/* POWER9 should not use this handler */
 	if (doorbell_try_core_ipi(cpu))
 		return;
 
-	icp_ops->cause_ipi(cpu);
+	ic_cause_ipi(cpu);
 }
 
 static int pseries_cause_nmi_ipi(int cpu)
@@ -218,26 +221,41 @@ static int pseries_cause_nmi_ipi(int cpu)
 	return 0;
 }
 
-static __init void pSeries_smp_probe_xics(void)
-{
-	xics_smp_probe();
-
-	if (cpu_has_feature(CPU_FTR_DBELL) && !is_secure_guest())
-		smp_ops->cause_ipi = smp_pseries_cause_ipi;
-	else
-		smp_ops->cause_ipi = icp_ops->cause_ipi;
-}
-
 static __init void pSeries_smp_probe(void)
 {
 	if (xive_enabled())
-		/*
-		 * Don't use P9 doorbells when XIVE is enabled. IPIs
-		 * using MMIOs should be faster
-		 */
 		xive_smp_probe();
 	else
-		pSeries_smp_probe_xics();
+		xics_smp_probe();
+
+	/* No doorbell facility, must use the interrupt controller for IPIs */
+	if (!cpu_has_feature(CPU_FTR_DBELL))
+		return;
+
+	/* Doorbells can only be used for IPIs between SMT siblings */
+	if (!cpu_has_feature(CPU_FTR_SMT))
+		return;
+
+	/*
+	 * KVM emulates doorbells by disabling FSCR[MSGP] so msgsndp faults
+	 * to the hypervisor which then reads the instruction from guest
+	 * memory. This can't be done if the guest is secure, so don't use
+	 * doorbells in secure guests.
+	 *
+	 * Under PowerVM, FSCR[MSGP] is enabled so doorbells could be used
+	 * by secure guests if we distinguished this from KVM.
+	 */
+	if (is_secure_guest())
+		return;
+
+	/*
+	 * The guest can use doobells for SMT sibling IPIs, which stay in
+	 * the core rather than going to the interrupt controller. This
+	 * tends to be slower under KVM where doorbells are emulated, but
+	 * faster for PowerVM where they're enabled.
+	 */
+	ic_cause_ipi = smp_ops->cause_ipi;
+	smp_ops->cause_ipi = dbell_or_ic_cause_ipi;
 }
 
 static struct smp_ops_t pseries_smp_ops = {
-- 
2.23.0

