Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8A353AB3
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhDEBW1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbhDEBWZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:22:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608E1C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:22:20 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ha17so5270968pjb.2
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHRWFD3iHSSdLF286j0f1zwOIMoz2IhYKJedkP23IR8=;
        b=JvJIGJzomKpzMbmRIRPSXtRrRHIxLRz5l/L5tuzTn38pX8rVLd1Kro+AiOuze3gKWh
         9KcYPQT3CQeNHuvKguiIooQV9u/Cxpfo6j0Hxez3tsNW1KM6l95i/IM0KoYLvdbhsM37
         5qEHzRZYEYDmVIcJRzgmAGlLlOBnRmSd8VFoxrjVJPbURN64k8OlMeail2+HCP/DO1Up
         4s/OT7vuqtWP6MBNNDUzYhIcEhuY02Bf9foRfUqaY7s3NgDrSmv982BFBi9yjrSqS0Tz
         Ynyqn204HCaq5tx4EL9wa9ZyZYSU9ioSHKuniD9l4yi8UBYpOCK2shslRwzWJv28OmOv
         bUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHRWFD3iHSSdLF286j0f1zwOIMoz2IhYKJedkP23IR8=;
        b=n9Vv23SwnUvayXrtopEWuH0xQdjlQSHAuG5P7iWNMKdHVSZ38vq63XWSNV1cVusU2h
         Su9Mv8zM9U8FgR1OECUjdhPX+4nDnotqQATzM19BNgH+W9uiqfkfsVGOy/dpwvjUDWgN
         L+HzLdCZ7ghsipoMBqtuC/JuTv5R+H5j8G8md/ZFc/lv31uHWTy6/qXRsmAYnoYbjKrb
         D1rAetGcy2u4CBdjqOTif1P5YCujo2n3V9Y5C0901UDRFxpGjDvals7M0G/nrEfCApVY
         Q4aZXlHWErgh5/HJgBbQ7zDK+rBKSkukZDe2JMs3h4dZ6B70cvBt6XwHbB71CTbqwj7t
         zdhQ==
X-Gm-Message-State: AOAM531Xo3ABxVSR5+RjPY6NQqPQlAYRxiUVIWYCog7vtf6Q54sYWVe2
        s7DBxT8iP+dRLkRcOghnczpTvcwAJ3B70Q==
X-Google-Smtp-Source: ABdhPJxAjwm6qLDiYzk1zZD0bQiuwzBDB0BDdHsYixr0VCHB7L9/1GoyZnnAVX/pEb6veMAcbjlFBQ==
X-Received: by 2002:a17:90b:f93:: with SMTP id ft19mr3828835pjb.135.1617585739856;
        Sun, 04 Apr 2021 18:22:19 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:22:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH v6 41/48] KVM: PPC: Book3S HV: Remove unused nested HV tests in XICS emulation
Date:   Mon,  5 Apr 2021 11:19:41 +1000
Message-Id: <20210405011948.675354-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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

