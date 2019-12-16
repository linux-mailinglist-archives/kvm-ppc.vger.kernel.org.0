Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B811FD8C
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Dec 2019 05:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLPETh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 15 Dec 2019 23:19:37 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:34788 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfLPETg (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 15 Dec 2019 23:19:36 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id A65E2AE80805;
        Sun, 15 Dec 2019 23:18:27 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 4/4] powerpc/pseries/svm: Allow IOMMU to work in SVM
Date:   Mon, 16 Dec 2019 15:19:24 +1100
Message-Id: <20191216041924.42318-5-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191216041924.42318-1-aik@ozlabs.ru>
References: <20191216041924.42318-1-aik@ozlabs.ru>
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

H_PUT_TCE_INDIRECT uses a shared page to send up to 512 TCE to
a hypervisor in a single hypercall. This does not work for secure VMs
as the page needs to be shared or the VM should use H_PUT_TCE instead.

This disables H_PUT_TCE_INDIRECT by clearing the FW_FEATURE_PUT_TCE_IND
feature bit so SVMs will map TCEs using H_PUT_TCE.

This is not a part of init_svm() as it is called too late after FW
patching is done and may result in a warning like this:

[    3.727716] Firmware features changed after feature patching!
[    3.727965] WARNING: CPU: 0 PID: 1 at (...)arch/powerpc/lib/feature-fixups.c:466 check_features+0xa4/0xc0

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2
* new in the patchset
---
 arch/powerpc/platforms/pseries/firmware.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
index d3acff23f2e3..3e49cc23a97a 100644
--- a/arch/powerpc/platforms/pseries/firmware.c
+++ b/arch/powerpc/platforms/pseries/firmware.c
@@ -22,6 +22,7 @@
 #include <asm/firmware.h>
 #include <asm/prom.h>
 #include <asm/udbg.h>
+#include <asm/svm.h>
 
 #include "pseries.h"
 
@@ -101,6 +102,12 @@ static void __init fw_hypertas_feature_init(const char *hypertas,
 		}
 	}
 
+	if (is_secure_guest() &&
+	    (powerpc_firmware_features & FW_FEATURE_PUT_TCE_IND)) {
+		powerpc_firmware_features &= ~FW_FEATURE_PUT_TCE_IND;
+		pr_debug("SVM: disabling PUT_TCE_IND firmware feature\n");
+	}
+
 	pr_debug(" <- fw_hypertas_feature_init()\n");
 }
 
-- 
2.17.1

