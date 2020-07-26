Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4122DB95
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jul 2020 05:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgGZDwV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Jul 2020 23:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZDwV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Jul 2020 23:52:21 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20713C0619D2
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id t11so7288133pfq.11
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mP8fwMzDz+zf7SJGclqA6IKQezLUGhUA0/W1tyd1LDQ=;
        b=kc5uO4cr2sX40sV0z9EylrlZXXvHQRrh7drF1njZfhDbZKV2Z9kBAYZzBPfEja9Cad
         RMqlcpGjYZhCOP9szSt44B/XTtw9TfbykZnHdmPLlw8VhQkI3y98YAgmUOf+PeZn801y
         L/lFx/1T5byIQbw8jOLrc2vNlPT6eqDCQqfzguyo3LaCvBOE+Xy0I3E99g2OasQpTGwk
         tSQ+fUvUTJWRhA5K7ZjLxLxL4gfx7cShbcbTecYv6PqHoJZYJ8UNkNBGEWBrkrRiT89S
         Wp5Ig7epW9TFAB502lHaAT52qVfVSnj5c7kQDAy0cOa19GZmyjOJCIgtTlSeCWOx/8gP
         IYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mP8fwMzDz+zf7SJGclqA6IKQezLUGhUA0/W1tyd1LDQ=;
        b=DQcJ6wi9lYuBz9RCSrpA1biU3KatvzAFbkdpmGKKg+aLwxpN0jIk+n/ng6/p4+3PDr
         FjUDuvMB14CqzvTgpIXx/R0vL2bF6FI+aMIs5+avdDOi9MDI5ZKGmlRXGgE751or+HsY
         77yjszPDO+4589FxFTS7dfgB79XaWmablIvyZHoXWyLOCyCkRN5blIG9RYCFiDLIKLvO
         1eV2Zc6R8lWerrNgvEmEOss49/KyDwhb+H4ugGTYvy/3W7t8pFMahOy0ldcyNdp5aeee
         PmsUTlAVrAv/NsvgTtOv++QwPpLvvk0QBCc9zKfdwJkoz868f50WBlzPYBM3ULHjhhSl
         K/eQ==
X-Gm-Message-State: AOAM530A1/d6/70a7P/qWyKVHn1zNUKj9tFGBp63dRII9oDEFEMash0B
        xkgpP+rpk1WrVFkBbSmC4hs=
X-Google-Smtp-Source: ABdhPJwQZvL4gPT4jiHhrKX5YH6mvIWXl5tvzq7dcrp/yDRkLTuIppEmEMVEmpCxh8r0sUqKuU155A==
X-Received: by 2002:a63:531e:: with SMTP id h30mr13921733pgb.165.1595735540686;
        Sat, 25 Jul 2020 20:52:20 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (110-174-173-27.tpgi.com.au. [110.174.173.27])
        by smtp.gmail.com with ESMTPSA id p1sm3638860pjp.10.2020.07.25.20.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:52:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v3 3/3] powerpc/pseries: Add KVM guest doorbell restrictions
Date:   Sun, 26 Jul 2020 13:51:55 +1000
Message-Id: <20200726035155.1424103-4-npiggin@gmail.com>
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

KVM guests have certain restrictions and performance quirks when using
doorbells. This patch moves the EPAPR KVM guest test so it can be shared
with PSERIES, and uses that in doorbell setup code to apply the KVM
guest quirks and  improves IPI performance for two cases:

 - PowerVM guests may now use doorbells even if they are secure.

 - KVM guests no longer use doorbells if XIVE is available.

There is a valid complaint that "KVM guest" is not a very reasonable
thing to test for, it's preferable for the hypervisor to advertise
particular behaviours to the guest so they could change if the
hypervisor implementation or configuration changes. However in this case
we were already assuming a KVM guest worst case, so this patch is about
containing those quirks. If KVM later advertises fast doorbells, we
should test for that and override the quirks.

Tested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/firmware.h  |  6 +++++
 arch/powerpc/include/asm/kvm_para.h  | 26 +++----------------
 arch/powerpc/kernel/Makefile         |  5 ++--
 arch/powerpc/kernel/firmware.c       | 19 ++++++++++++++
 arch/powerpc/platforms/pseries/smp.c | 38 +++++++++++++++++-----------
 5 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index 6003c2e533a0..f67efbaba17f 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -132,6 +132,12 @@ extern int ibm_nmi_interlock_token;
 
 extern unsigned int __start___fw_ftr_fixup, __stop___fw_ftr_fixup;
 
+#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
+bool is_kvm_guest(void);
+#else
+static inline bool is_kvm_guest(void) { return false; }
+#endif
+
 #ifdef CONFIG_PPC_PSERIES
 void pseries_probe_fw_features(void);
 #else
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 9c1f6b4b9bbf..744612054c94 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -8,35 +8,15 @@
 #ifndef __POWERPC_KVM_PARA_H__
 #define __POWERPC_KVM_PARA_H__
 
-#include <uapi/asm/kvm_para.h>
-
-#ifdef CONFIG_KVM_GUEST
-
-#include <linux/of.h>
-
-static inline int kvm_para_available(void)
-{
-	struct device_node *hyper_node;
-
-	hyper_node = of_find_node_by_path("/hypervisor");
-	if (!hyper_node)
-		return 0;
+#include <asm/firmware.h>
 
-	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
-		return 0;
-
-	return 1;
-}
-
-#else
+#include <uapi/asm/kvm_para.h>
 
 static inline int kvm_para_available(void)
 {
-	return 0;
+	return IS_ENABLED(CONFIG_KVM_GUEST) && is_kvm_guest();
 }
 
-#endif
-
 static inline unsigned int kvm_arch_para_features(void)
 {
 	unsigned long r;
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 244542ae2a91..852164439dcb 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -45,11 +45,10 @@ obj-y				:= cputable.o syscalls.o \
 				   signal.o sysfs.o cacheinfo.o time.o \
 				   prom.o traps.o setup-common.o \
 				   udbg.o misc.o io.o misc_$(BITS).o \
-				   of_platform.o prom_parse.o
+				   of_platform.o prom_parse.o firmware.o
 obj-y				+= ptrace/
 obj-$(CONFIG_PPC64)		+= setup_64.o \
-				   paca.o nvram_64.o firmware.o note.o \
-				   syscall_64.o
+				   paca.o nvram_64.o note.o syscall_64.o
 obj-$(CONFIG_COMPAT)		+= sys_ppc32.o signal_32.o
 obj-$(CONFIG_VDSO32)		+= vdso32/
 obj-$(CONFIG_PPC_WATCHDOG)	+= watchdog.o
diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
index cc4a5e3f51f1..fe48d319d490 100644
--- a/arch/powerpc/kernel/firmware.c
+++ b/arch/powerpc/kernel/firmware.c
@@ -11,8 +11,27 @@
 
 #include <linux/export.h>
 #include <linux/cache.h>
+#include <linux/of.h>
 
 #include <asm/firmware.h>
 
+#ifdef CONFIG_PPC64
 unsigned long powerpc_firmware_features __read_mostly;
 EXPORT_SYMBOL_GPL(powerpc_firmware_features);
+#endif
+
+#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
+bool is_kvm_guest(void)
+{
+	struct device_node *hyper_node;
+
+	hyper_node = of_find_node_by_path("/hypervisor");
+	if (!hyper_node)
+		return 0;
+
+	if (!of_device_is_compatible(hyper_node, "linux,kvm"))
+		return 0;
+
+	return 1;
+}
+#endif
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index 67e6ad5076ce..7af0003b40b6 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -236,24 +236,32 @@ static __init void pSeries_smp_probe(void)
 	if (!cpu_has_feature(CPU_FTR_SMT))
 		return;
 
-	/*
-	 * KVM emulates doorbells by disabling FSCR[MSGP] so msgsndp faults
-	 * to the hypervisor which then reads the instruction from guest
-	 * memory. This can't be done if the guest is secure, so don't use
-	 * doorbells in secure guests.
-	 *
-	 * Under PowerVM, FSCR[MSGP] is enabled so doorbells could be used
-	 * by secure guests if we distinguished this from KVM.
-	 */
-	if (is_secure_guest())
-		return;
+	if (is_kvm_guest()) {
+		/*
+		 * KVM emulates doorbells by disabling FSCR[MSGP] so msgsndp
+		 * faults to the hypervisor which then reads the instruction
+		 * from guest memory, which tends to be slower than using XIVE.
+		 */
+		if (xive_enabled())
+			return;
+
+		/*
+		 * XICS hcalls aren't as fast, so we can use msgsndp (which
+		 * also helps exercise KVM emulation), however KVM can't
+		 * emulate secure guests because it can't read the instruction
+		 * out of their memory.
+		 */
+		if (is_secure_guest())
+			return;
+	}
 
 	/*
-	 * The guest can use doobells for SMT sibling IPIs, which stay in
-	 * the core rather than going to the interrupt controller. This
-	 * tends to be slower under KVM where doorbells are emulated, but
-	 * faster for PowerVM where they're enabled.
+	 * Under PowerVM, FSCR[MSGP] is enabled as guest vCPU siblings are
+	 * gang scheduled on the same physical core, so doorbells are always
+	 * faster than the interrupt controller, and they can be used by
+	 * secure guests.
 	 */
+
 	ic_cause_ipi = smp_ops->cause_ipi;
 	smp_ops->cause_ipi = dbell_or_ic_cause_ipi;
 }
-- 
2.23.0

