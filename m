Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20879393F82
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbhE1JKs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbhE1JKl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:41 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76364C06138A
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:03 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d16so2733164pfn.12
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHRWFD3iHSSdLF286j0f1zwOIMoz2IhYKJedkP23IR8=;
        b=uIzWDRExF+mMuZJpu49jWvRvLa6ySttxup0OKUVyJUF9T0lljgvosGS9k/scr08htW
         ODhD+2U0V/0DktgEUsdUfxFgIyOasooUxIEVZ+jr/ws/E0D4MnUa0fetLcOdW4kIvCnU
         tjMRN3jzHzX+koWBOn1D8//XsoVa+GobCZ+6dmhG90kfrexmqvMszzypJ/6U8miB62UQ
         wWSB9Tg32Dk8oOtiTlP3RP838PEkMyiaLq3n61mFfDdF6AFB21EqqVWZLLQAP1UcObaI
         XAPLv0MZmFOOSZzfySwJXysHf3F4T+QaW2/DqG6VTEcdB8unuhVtomyEt1nF3A7vM1VA
         D7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHRWFD3iHSSdLF286j0f1zwOIMoz2IhYKJedkP23IR8=;
        b=QAfNSljqGGO+bhr/tbyniULcyrlSnsRdNwlm6nCTqyuWLioQBnpPIvT7BmbBfdMr54
         y4GpowGP90bE/QtNTlSc7aOtNYbdFyVrxzsetndsx8IW7kQw/vlT5JI9VZfS9aXuFfls
         s/CIihoqibwU+pRyUI1hD8CCmQsOWdT6t3r+1MbOboGM0/7hEFYebZ+m84T0ZyYyGlai
         adCcuzfzOJynqNgDCF8xmZ/8aYSAGfCarbYoWsJJqRL/gbC4ulV7HwbPUdARKbCRw45O
         2/YqUc3sdK6Nqedab+UdFLHRGRw5yPcMVp0oDcYbWnmB1mPCKkM1NUR2gIKSjT/vykLk
         POIA==
X-Gm-Message-State: AOAM533N92dsPqFEiIihOnFJAMlaRmS8+pM7KOSrbsGuBEZsOAZ4Ovqg
        djkOdK3d/H4BLZwA02TnR6Pqi7bbVZw=
X-Google-Smtp-Source: ABdhPJxpm8CmErfhXCF/EUxMKCqdijIeOa+v0YwZHt6ctcr7DgMX8/xaS1UcvGRuV1YT8cLTypy/0w==
X-Received: by 2002:aa7:8c4e:0:b029:2df:9b70:44e with SMTP id e14-20020aa78c4e0000b02902df9b70044emr2892995pfd.49.1622192942866;
        Fri, 28 May 2021 02:09:02 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:09:02 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH v7 25/32] KVM: PPC: Book3S HV: Remove unused nested HV tests in XICS emulation
Date:   Fri, 28 May 2021 19:07:45 +1000
Message-Id: <20210528090752.3542186-26-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Commit f3c18e9342a44 ("KVM: PPC: Book3S HV: Use XICS hypercalls when
running as a nested hypervisor") added nested HV tests in XICS
hypercalls, but not all are required.

* icp_eoi is only called by kvmppc_deliver_irq_passthru which is only
  called by kvmppc_check_passthru which is only caled by
  kvmppc_read_one_intr.

* kvmppc_read_one_intr is only called by kvmppc_read_intr which is only
  called by the L0 HV rmhandlers code.

* kvmhv_rm_send_ipi is called by:
  - kvmhv_interrupt_vcore which is only called by kvmhv_commence_exit
    which is only called by the L0 HV rmhandlers code.
  - icp_send_hcore_msg which is only called by icp_rm_set_vcpu_irq.
  - icp_rm_set_vcpu_irq which is only called by icp_rm_try_update
  - icp_rm_set_vcpu_irq is not nested HV safe because it writes to
    LPCR directly without a kvmhv_on_pseries test. Nested handlers
    should not in general be using the rm handlers.

The important test seems to be in kvmppc_ipi_thread, which sends the
virt-mode H_IPI handler kick to use smp_call_function rather than
msgsnd.

Cc: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 44 +++++-----------------------
 arch/powerpc/kvm/book3s_hv_rm_xics.c | 15 ----------
 2 files changed, 8 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 8d669a0e15f8..259492bb4153 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -199,15 +199,6 @@ void kvmhv_rm_send_ipi(int cpu)
 	void __iomem *xics_phys;
 	unsigned long msg = PPC_DBELL_TYPE(PPC_DBELL_SERVER);
 
-	/* For a nested hypervisor, use the XICS via hcall */
-	if (kvmhv_on_pseries()) {
-		unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
-
-		plpar_hcall_raw(H_IPI, retbuf, get_hard_smp_processor_id(cpu),
-				IPI_PRIORITY);
-		return;
-	}
-
 	/* On POWER9 we can use msgsnd for any destination cpu. */
 	if (cpu_has_feature(CPU_FTR_ARCH_300)) {
 		msg |= get_hard_smp_processor_id(cpu);
@@ -420,19 +411,12 @@ static long kvmppc_read_one_intr(bool *again)
 		return 1;
 
 	/* Now read the interrupt from the ICP */
-	if (kvmhv_on_pseries()) {
-		unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
-
-		rc = plpar_hcall_raw(H_XIRR, retbuf, 0xFF);
-		xirr = cpu_to_be32(retbuf[0]);
-	} else {
-		xics_phys = local_paca->kvm_hstate.xics_phys;
-		rc = 0;
-		if (!xics_phys)
-			rc = opal_int_get_xirr(&xirr, false);
-		else
-			xirr = __raw_rm_readl(xics_phys + XICS_XIRR);
-	}
+	xics_phys = local_paca->kvm_hstate.xics_phys;
+	rc = 0;
+	if (!xics_phys)
+		rc = opal_int_get_xirr(&xirr, false);
+	else
+		xirr = __raw_rm_readl(xics_phys + XICS_XIRR);
 	if (rc < 0)
 		return 1;
 
@@ -461,13 +445,7 @@ static long kvmppc_read_one_intr(bool *again)
 	 */
 	if (xisr == XICS_IPI) {
 		rc = 0;
-		if (kvmhv_on_pseries()) {
-			unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
-
-			plpar_hcall_raw(H_IPI, retbuf,
-					hard_smp_processor_id(), 0xff);
-			plpar_hcall_raw(H_EOI, retbuf, h_xirr);
-		} else if (xics_phys) {
+		if (xics_phys) {
 			__raw_rm_writeb(0xff, xics_phys + XICS_MFRR);
 			__raw_rm_writel(xirr, xics_phys + XICS_XIRR);
 		} else {
@@ -493,13 +471,7 @@ static long kvmppc_read_one_intr(bool *again)
 			/* We raced with the host,
 			 * we need to resend that IPI, bummer
 			 */
-			if (kvmhv_on_pseries()) {
-				unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
-
-				plpar_hcall_raw(H_IPI, retbuf,
-						hard_smp_processor_id(),
-						IPI_PRIORITY);
-			} else if (xics_phys)
+			if (xics_phys)
 				__raw_rm_writeb(IPI_PRIORITY,
 						xics_phys + XICS_MFRR);
 			else
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index c2c9c733f359..0a11ec88a0ae 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -141,13 +141,6 @@ static void icp_rm_set_vcpu_irq(struct kvm_vcpu *vcpu,
 		return;
 	}
 
-	if (xive_enabled() && kvmhv_on_pseries()) {
-		/* No XICS access or hypercalls available, too hard */
-		this_icp->rm_action |= XICS_RM_KICK_VCPU;
-		this_icp->rm_kick_target = vcpu;
-		return;
-	}
-
 	/*
 	 * Check if the core is loaded,
 	 * if not, find an available host core to post to wake the VCPU,
@@ -771,14 +764,6 @@ static void icp_eoi(struct irq_chip *c, u32 hwirq, __be32 xirr, bool *again)
 	void __iomem *xics_phys;
 	int64_t rc;
 
-	if (kvmhv_on_pseries()) {
-		unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
-
-		iosync();
-		plpar_hcall_raw(H_EOI, retbuf, hwirq);
-		return;
-	}
-
 	rc = pnv_opal_pci_msi_eoi(c, hwirq);
 
 	if (rc)
-- 
2.23.0

