Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00682074DC
	for <lists+kvm-ppc@lfdr.de>; Wed, 24 Jun 2020 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391100AbgFXNri (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 24 Jun 2020 09:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389590AbgFXNrh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 24 Jun 2020 09:47:37 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1A5C061573
        for <kvm-ppc@vger.kernel.org>; Wed, 24 Jun 2020 06:47:37 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q15so2385199wmj.2
        for <kvm-ppc@vger.kernel.org>; Wed, 24 Jun 2020 06:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lHfk96B0+ihglAFlrm1FT6zDDI3xWocJzEidZ1THNGo=;
        b=tpf/dcq4PAzW3T54HKNZWmByjNJgL82k45veKEeoYnLdGkSoRmUdwKRSHvfBLDHOG9
         FEP1fA1ZoqptL6kpfglTgJE1SIQOQRVDZgGpauAwOTppto0B5vDaQsixBq+xxkWeqHtP
         xeENTkgnV8AZLBR/oycfN8ZuB3EZqbDUo3EhSS9zettNixoVNKhGPcHB21EvWNFgOb2+
         C5XEZ+6hCIoGhCf8PEWc4/12oNrfC/o2W5x9YkuNlp3lVoe6vwltOgSl2pFpjVjUoBT5
         zh0VaRnuyMm3j1ejVdDsdsnx+FI5hdkAHB5gVGJQTYaKnK7Lc5XwbCHBIxn2791yYQ8b
         MVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lHfk96B0+ihglAFlrm1FT6zDDI3xWocJzEidZ1THNGo=;
        b=Wbi/XcfpWm4Q+LbTE1OFpQwHnGL4SMKxIKR/OJ08bhKhkGA1J/UxeubMY4Ofr4krXM
         SPDcPZIbBj9udWSmlsxLp9cbvnw4T6zYykjnsMZvoPyGlK1Z+H7dDSNYjB5evXKBXILH
         p5WhvO+x9PXaoBdg0tIWGvSLPMJRvbbfmzDikucwra5bQYdBUD5UAcz5rorC3YQJY4bq
         IFDoE8Wtuw3W++jXGE4DxjAKdSrCGZ0+GPqEzOo/ryDsa/B/aEXtBanus9wt1PVkH9Oo
         32CJ/dRFC9INrrexx8I32d9yJXbtLHD9rPDwDpG9Rcz2KKiV3lP/V3TTp/hYrfMBpCNG
         3PeQ==
X-Gm-Message-State: AOAM532km4CnPzlBE/VK4VfiKLj3TqvNWkqOWOJFtVkrgE8ma75X4l5q
        rIpLzr4U1bTmUr3hc4Wtt+g=
X-Google-Smtp-Source: ABdhPJzx6K1kek4etHgRf3uNsg3tPsTriU2IDEDRlnOtTzqm2BUNEFWMTc0jAGsTCRsYQMA+ql0v5g==
X-Received: by 2002:a1c:154:: with SMTP id 81mr29460084wmb.23.1593006456220;
        Wed, 24 Jun 2020 06:47:36 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id h14sm11284298wrt.36.2020.06.24.06.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:47:35 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Anton Blanchard <anton@linux.ibm.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH] powerpc/pseries: Use doorbells even if XIVE is available
Date:   Wed, 24 Jun 2020 23:47:24 +1000
Message-Id: <20200624134724.2343007-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
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
 arch/powerpc/platforms/pseries/smp.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 6891710833be..a737a2f87c67 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -188,13 +188,14 @@ static int pseries_smp_prepare_cpu(int cpu)
 	return 0;
 }
 
+static void  (*cause_ipi_offcore)(int cpu) __ro_after_init;
+
 static void smp_pseries_cause_ipi(int cpu)
 {
-	/* POWER9 should not use this handler */
 	if (doorbell_try_core_ipi(cpu))
 		return;
 
-	icp_ops->cause_ipi(cpu);
+	cause_ipi_offcore(cpu);
 }
 
 static int pseries_cause_nmi_ipi(int cpu)
@@ -222,10 +223,7 @@ static __init void pSeries_smp_probe_xics(void)
 {
 	xics_smp_probe();
 
-	if (cpu_has_feature(CPU_FTR_DBELL) && !is_secure_guest())
-		smp_ops->cause_ipi = smp_pseries_cause_ipi;
-	else
-		smp_ops->cause_ipi = icp_ops->cause_ipi;
+	smp_ops->cause_ipi = icp_ops->cause_ipi;
 }
 
 static __init void pSeries_smp_probe(void)
@@ -238,6 +236,18 @@ static __init void pSeries_smp_probe(void)
 		xive_smp_probe();
 	else
 		pSeries_smp_probe_xics();
+
+	/*
+	 * KVM emulates doorbells by reading the instruction, which
+	 * can't be done if the guest is secure. If a secure guest
+	 * runs under PowerVM, it could use msgsndp but would need a
+	 * way to distinguish.
+	 */
+	if (cpu_has_feature(CPU_FTR_DBELL) &&
+	    cpu_has_feature(CPU_FTR_SMT) && !is_secure_guest()) {
+		cause_ipi_offcore = smp_ops->cause_ipi;
+		smp_ops->cause_ipi = smp_pseries_cause_ipi;
+	}
 }
 
 static struct smp_ops_t pseries_smp_ops = {
-- 
2.23.0

