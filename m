Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECB94523E
	for <lists+kvm-ppc@lfdr.de>; Fri, 14 Jun 2019 04:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbfFNC7W (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 13 Jun 2019 22:59:22 -0400
Received: from ozlabs.ru ([107.173.13.209]:57018 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfFNC7W (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 13 Jun 2019 22:59:22 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 0E00EAE807F0;
        Thu, 13 Jun 2019 22:59:18 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH kernel] powerpc/pci/of: Parse unassigned resources
Date:   Fri, 14 Jun 2019 12:59:16 +1000
Message-Id: <20190614025916.123589-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The pseries platform uses the PCI_PROBE_DEVTREE method of PCI probing
which is basically reading "assigned-addresses" of every PCI device.
However if the property is missing or zero sized, then there is
no fallback of any kind and the PCI resources remain undiscovered, i.e.
pdev->resource[] array is empty.

This adds a fallback which parses the "reg" property in pretty much same
way except it marks resources as "unset" which later makes Linux assign
those resources with proper addresses.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

This is an attempts to boot linux directly under QEMU without slof/rtas;
the aim is to use petitboot instead and let the guest kernel configure
devices.

QEMU does not allocate resources, it creates correct "reg" and zero length
"assigned-addresses" (which is probably a bug on its own) which is
normally populated by SLOF later but not during this exercise.

---
 arch/powerpc/kernel/pci_of_scan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 64ad92016b63..cfe6ec3c6aaf 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -82,10 +82,18 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 	const __be32 *addrs;
 	u32 i;
 	int proplen;
+	bool unset = false;
 
 	addrs = of_get_property(node, "assigned-addresses", &proplen);
 	if (!addrs)
 		return;
+	if (!addrs || !proplen) {
+		addrs = of_get_property(node, "reg", &proplen);
+		if (!addrs || !proplen)
+			return;
+		unset = true;
+	}
+
 	pr_debug("    parse addresses (%d bytes) @ %p\n", proplen, addrs);
 	for (; proplen >= 20; proplen -= 20, addrs += 5) {
 		flags = pci_parse_of_flags(of_read_number(addrs, 1), 0);
@@ -110,6 +118,8 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 			continue;
 		}
 		res->flags = flags;
+		if (unset)
+			res->flags |= IORESOURCE_UNSET;
 		res->name = pci_name(dev);
 		region.start = base;
 		region.end = base + size - 1;
-- 
2.17.1

