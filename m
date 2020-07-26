Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B353522DB94
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jul 2020 05:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGZDwR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Jul 2020 23:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZDwR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Jul 2020 23:52:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299CFC0619D2
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ha11so160929pjb.1
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nEol4cg4fgvYnjxLbZL4ZZXX5iG5npgMKo8J5imOzG8=;
        b=bSjbGYSnE0c6uodbKuTJew7DPC0iLZFIBduu4kDh9uI3sy6vjNxGnx6QdkC1c1ug1N
         OH8CU0Z5ZgTJgseJAheGcdfzVk+uDBSSYEO5j8W04uLAZmYmA/JyvjU/kOAuG+Pe7c84
         qyjxk5sSdGhOXJr3khHASMGhU2OhVZQYbhnq62dKkvhE82xbqkKR0IPDJMz6KXURTbj5
         Kw/oboHpfgBxdTVZ38uQBGl8RK7xY0ARuS3IcUPrR4UeCVfwy+yxudfziCosbCWzOfGA
         ofKJsePkjIjv2vdGQfJwzrIW0nrdHmW3GIAfpyuQbjQfrg1KlfQBR3DmS9G3cJkyciWS
         1ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nEol4cg4fgvYnjxLbZL4ZZXX5iG5npgMKo8J5imOzG8=;
        b=m+j4FOq6pzHbEs/Lvt4jZuEGY/LlwCmb3SFMKbd1LTdOnE/CNgZVZ0A7iXMVFVUXNN
         Il13Gs15YLOh4Tb/Db6/07CkaMq/ddL3nuTHEZUV9GW4CwL3107Rl5yD6UFCEZ//9Ipq
         tHwCNBVxzfxiooYqi7s2p4tRNUpaEPl4SHz08/RShyqLrX99mW9FrVCIypZEj89yHxpu
         iv8HRs8aPyjkE5BTWT8zCYzwHmmXNIwY1favp3aZ6eh3O9yF0zgCmdziqDvtqWlGP79x
         LiH2ffE1OtRdY2YOwAVKKwJXfnDBYbM+2W8Ih2GjZO2AZytTmnLgUrLjuHyjw5bmLwMw
         f40A==
X-Gm-Message-State: AOAM533XJGb339IF+Rgu0SoFHj/M8arq/njqHD8QwFEYx9wYlZUgk7RD
        yy+jn4fE1EDKZ72Km2noIlE=
X-Google-Smtp-Source: ABdhPJzj54leH9G5iKBA/zYgqNMa7RQaCOX/mGUoo3HpPpgcSaU7as8b6XNMoZ8WlhhRsu+rBzAbKw==
X-Received: by 2002:a17:90b:692:: with SMTP id m18mr1788644pjz.56.1595735536760;
        Sat, 25 Jul 2020 20:52:16 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (110-174-173-27.tpgi.com.au. [110.174.173.27])
        by smtp.gmail.com with ESMTPSA id p1sm3638860pjp.10.2020.07.25.20.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:52:16 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v3 2/3] powerpc/pseries: Use doorbells even if XIVE is available
Date:   Sun, 26 Jul 2020 13:51:54 +1000
Message-Id: <20200726035155.1424103-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200726035155.1424103-1-npiggin@gmail.com>
References: <20200726035155.1424103-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Tested-by: Cédric Le Goater <clg@kaod.org>
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

