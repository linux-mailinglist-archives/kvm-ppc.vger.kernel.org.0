Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E2120F3D4
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 13:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732251AbgF3LvA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 07:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbgF3LvA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Jun 2020 07:51:00 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA0EC061755
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:50:59 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so19784829wrs.11
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kcYsmTzhEp8xx6FEht3XE+3X/L1jPFAQ52+7Dv3gK8g=;
        b=L0USudyektF2Cc8Oup2k3fOqJKuxbgAL6rtTM3p5xDeRowJaRXpKY/T8KI426Sp1jE
         2PR54w14o8dItuxcEdBI0+BQYsiOyKKNX2EOL0RfyLq5WQnp9w6FW2H2ztBg/OxwqAx/
         uL/y8tgrdyyth8wqHhXWm1fk+KS7Wrisj0IQ9T92S1d+jcQ+NBDHhjjfC168APoHxugz
         x+i4/WVZltTEReZHuyRj5BeSKdiBbMX39pgfaitRG2QbGV6XxkJ6M2nVpPGjqXdbZd01
         B+S7FP4p9/6a3HfFhmlPMo5BBsXvBdXXU9s/SgwdlG/+wAFOGqojiSWdEPy2aq3a7IkL
         OPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kcYsmTzhEp8xx6FEht3XE+3X/L1jPFAQ52+7Dv3gK8g=;
        b=id0Zrajk/3aFUFbxj9jIR1V6BdFfPVEfXkrke5qyu74J4SxuJcDMXVYujeLeDOWzIL
         ZXQWOQqddrjV1/L1C742+QgFKV1wuBnE0x8me5TLnAjEDwZyIqiu/TNSQiow6CGZXu4a
         1hviDXE/paeq4O9qBaO0K13ROKOPISBTj9BdP6nuSnJHJWFyd7lLHfFgB6apWAXKHqEJ
         C8rl/FvyKzcLihPAQUJYftmwwM+BIJDdDUAE0GzQiHlUbmmllwoGev1wfsQq2CbOTHuN
         92cgg+RsX3yGS2h3xxARm5SC71kjNii/yqKT5RKojYyVbQS7wtCG8Qq0d9Bwq186IMdy
         yhKA==
X-Gm-Message-State: AOAM531pmeK4lFY9xr+3i+9BxyEmufPPwXd5QOjy3oZ+no2pgpFWpHzm
        jTvJyPUTm61lDK+Py8lauai1/IqJ
X-Google-Smtp-Source: ABdhPJxsML2kYOdlBwOJzT3J7t3FBvtGvblzJuhLM37QcRd+9XTNE9Km6/om/xujUR3CzYW4TeJ8BA==
X-Received: by 2002:adf:dfd1:: with SMTP id q17mr20337495wrn.94.1593517858603;
        Tue, 30 Jun 2020 04:50:58 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id c25sm3133673wml.46.2020.06.30.04.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:50:58 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v2 2/3] powerpc/pseries: Use doorbells even if XIVE is available
Date:   Tue, 30 Jun 2020 21:50:32 +1000
Message-Id: <20200630115034.137050-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200630115034.137050-1-npiggin@gmail.com>
References: <20200630115034.137050-1-npiggin@gmail.com>
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

