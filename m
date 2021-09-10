Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67F406275
	for <lists+kvm-ppc@lfdr.de>; Fri, 10 Sep 2021 02:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhIJApb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Sep 2021 20:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhIJAUT (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92D4611C2;
        Fri, 10 Sep 2021 00:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233147;
        bh=EzVc4+9z8jJm3006a4PiHOFkM6wMDw2uoZJqKWC7Rz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjK8XoY61T71LIr3dIYYdc01p6UJMuamzPA6uha8dgRoRgcp3vanJrY3HKnegvV/C
         ngLva2mWvFNYmfuuL8PIcgCVgIywlocDI0a8Lt1ihT+UU/9wyeY57e4iMNuPnuwP3d
         oqToHElSyqnHkmajCHnDDybvP1QuI+aDRRM26urT8yClQEuloNwnrAaOOxxdC+ZAGs
         EZFr4WkFB+OYYk7xhX4CLKJbNyJq7eK3TQ/uxhPNB314Yhz9FLdcvVbToSx+R0abn2
         EEYcqGKGDuCKOXA/WZuyDsBzZpmYt1agm4qruW1BusJRbU8RyI+lrYTD8ZQ8hrK03Z
         F/JAQ0y6JkKQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 32/88] KVM: PPC: Book3S HV: XICS: Fix mapping of passthrough interrupts
Date:   Thu,  9 Sep 2021 20:17:24 -0400
Message-Id: <20210910001820.174272-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 1753081f2d445f9157550692fcc4221cd3ff0958 ]

PCI MSIs now live in an MSI domain but the underlying calls, which
will EOI the interrupt in real mode, need an HW IRQ number mapped in
the XICS IRQ domain. Grab it there.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210701132750.1475580-31-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 395f98158e81..a284999a3171 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5170,6 +5170,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	struct kvmppc_passthru_irqmap *pimap;
 	struct irq_chip *chip;
 	int i, rc = 0;
+	struct irq_data *host_data;
 
 	if (!kvm_irq_bypass)
 		return 1;
@@ -5234,7 +5235,14 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	 * the KVM real mode handler.
 	 */
 	smp_wmb();
-	irq_map->r_hwirq = desc->irq_data.hwirq;
+
+	/*
+	 * The 'host_irq' number is mapped in the PCI-MSI domain but
+	 * the underlying calls, which will EOI the interrupt in real
+	 * mode, need an HW IRQ number mapped in the XICS IRQ domain.
+	 */
+	host_data = irq_domain_get_irq_data(irq_get_default_host(), host_irq);
+	irq_map->r_hwirq = (unsigned int)irqd_to_hwirq(host_data);
 
 	if (i == pimap->n_mapped)
 		pimap->n_mapped++;
@@ -5242,7 +5250,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	if (xics_on_xive())
 		rc = kvmppc_xive_set_mapped(kvm, guest_gsi, desc);
 	else
-		kvmppc_xics_set_mapped(kvm, guest_gsi, desc->irq_data.hwirq);
+		kvmppc_xics_set_mapped(kvm, guest_gsi, irq_map->r_hwirq);
 	if (rc)
 		irq_map->r_hwirq = 0;
 
-- 
2.30.2

