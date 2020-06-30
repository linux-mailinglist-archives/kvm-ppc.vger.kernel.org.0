Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD52B20F3D6
	for <lists+kvm-ppc@lfdr.de>; Tue, 30 Jun 2020 13:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733147AbgF3LvH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 30 Jun 2020 07:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbgF3LvF (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 30 Jun 2020 07:51:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF8BC061755
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:51:04 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z15so8540161wrl.8
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Jun 2020 04:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ZvoHqaUW6Z01Z7DFD/cW0QsTS+b1yJKdzwareCSkvw=;
        b=UFTQXMvwLVHO1kNl3Rry/GdrxedirPtrLvrs6nNuKtiR3A2zpWLeM2X/gbvgkMI175
         7junVDkpGxxG9f3b6FItmnHg2tx7XatfU1YGqOuL79Yk5wCsL76ybu1wVxExM78ZItdF
         i366yaTG90HiATBliZCYyHuOnieAYeNXzUKtpCqqi0qaFly416UR/lqKdnsjQWIy+jgh
         5SUCEKFS/fM37hDaE8cTJdSasI3MVN7XsVadbBaq655k4YhEz8ZpPb1AjeExyXR5jb18
         /Qioparz3SJbia9I0qhZO/V7SQLLxtmmyAN9GDtW9LnFno0nOg0iJuo42wvMyUCAEWzJ
         utiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ZvoHqaUW6Z01Z7DFD/cW0QsTS+b1yJKdzwareCSkvw=;
        b=AMOPjWVgOXCCYbbq886u1GnOgUMnX5lhPtzxfGnWigggi3Cv57zTGTcbU8pW/uoyi+
         hgWdmj9bW0wDWqwzsVhGIVzJ+JPPPBtKdjCj9IrygLzAYi8l256pEtHGEOiV8KYUaC7s
         ez9Acc5bIiGELOc1ut1tozqbJkOZBN15bDtZkZbB7YfV4L2YFh4Kzufm9aJowobPrLOe
         7cn4LMIxEb1hwJKSLPSQYjDVT0mLIV6IHmx622yKxHUXQ+5yU7Pw71FiWmRV4sMF6gjY
         /sERTqyIx03pt38JY236lhfJJWYmXlGXQTy3h0/SlIh/2FGqXVT8V0YAV93/ClSCLEf+
         B3gA==
X-Gm-Message-State: AOAM530NtUlBztbfmKzb6jHgo4/lM6u+V7ZEq3EM3y+qCi30KtgAVpDP
        ge+gXrY7QkPJhtvnvP8CeyA=
X-Google-Smtp-Source: ABdhPJwrMWQUzc6lbQklBcL5rkYLMNe0pz8zwpFEx0i1mU0oWoLLGWl3ye0Ck3Scq1afFphqMxNEQw==
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr23047565wrx.73.1593517863466;
        Tue, 30 Jun 2020 04:51:03 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id c25sm3133673wml.46.2020.06.30.04.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:51:03 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v2 3/3] powerpc/pseries: Add KVM guest doorbell restrictions
Date:   Tue, 30 Jun 2020 21:50:33 +1000
Message-Id: <20200630115034.137050-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200630115034.137050-1-npiggin@gmail.com>
References: <20200630115034.137050-1-npiggin@gmail.com>
MIME-Version: 1.0
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

