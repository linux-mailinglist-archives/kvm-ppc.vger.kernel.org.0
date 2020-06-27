Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2543720C29E
	for <lists+kvm-ppc@lfdr.de>; Sat, 27 Jun 2020 17:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgF0PEs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 27 Jun 2020 11:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgF0PEs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 27 Jun 2020 11:04:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD28AC061794
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a6so12251595wrm.4
        for <kvm-ppc@vger.kernel.org>; Sat, 27 Jun 2020 08:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t2L1K2bV9m5JXikNSc3z683l0pkiswvncfWbyRpfKPA=;
        b=oLOeSZyoADa8Uzn4ECrco3+E28bJ3iIWgCZZpRW61lCMMCUtxbSmYoYz+WlsxZhgrM
         xzD/ApEKULR+rIDT5zVhZz1wEe6CclGTXjz/HE9raOzlBRPzkABq3XUz7aHTdTQjxuHy
         git1wMbeuO87z3sc4QfOsayDA+jjXnl20GktDoPspNsVLWLbCVphxlHMdjDivikPfW2e
         /14KSrdC6S9no/uqHYdRkOS84OaOdzQopRVxrOspfH1SwvVfurF1vGG2PB8hSeYrdYxs
         IGr+J0cOh1/85Q7ygULt+lKcDU/oQLVgj6JQeITJB1CwsQdIrNyYXx4fCaeA2lapGicF
         0lJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t2L1K2bV9m5JXikNSc3z683l0pkiswvncfWbyRpfKPA=;
        b=PoO25WQp620hrkpCKaGqK6AWgUGgtXqXcJ3uW2WFMGpejFLQl8urikxYYN1h2e4MbR
         teKjR/dwqtoiQzTLmdhLOkvpzwG+Pl6NAXwJPabe/cKnCuZpgpn8Cg2nVKdPB7zoCiaV
         hQ+tKFCQ6l8oJSXC5Tj0CJyig9jV+y1L+6KfRbU6d9iIT+zeh+ATUTG26Y1+1awUgGKI
         2J0F2PyCXudGRyXFx7PIK99MBBi6iq7vyFXhmuxEonUnlGyYGE+E6G/g1u8KDPtg1uAS
         2FPCEpnJFvRGkIHDsT+9dwnBKkivqZwWKDDMgii83qt2lrTzCwNcV5tJWSt6M4vNA3vw
         dtow==
X-Gm-Message-State: AOAM5310FLoyO4/lxQHmukciMqOSk1Tj3JeVJ0v2jHMZwjAsP1udsI82
        i1NEpAOVWPGX87WjbMIQ31+tEGb7
X-Google-Smtp-Source: ABdhPJw1pbtNANoOG/ZKHqn7vDo3vJRYMyn/JFl9oSRkRsdppvomcxOJioYU0V1MA+7LzbEYsqz1KQ==
X-Received: by 2002:adf:afc3:: with SMTP id y3mr9326461wrd.277.1593270286400;
        Sat, 27 Jun 2020 08:04:46 -0700 (PDT)
Received: from bobo.ibm.com (61-68-186-125.tpgi.com.au. [61.68.186.125])
        by smtp.gmail.com with ESMTPSA id d132sm21722029wmd.35.2020.06.27.08.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 08:04:45 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 1/3] powerpc: inline doorbell sending functions
Date:   Sun, 28 Jun 2020 01:04:26 +1000
Message-Id: <20200627150428.2525192-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200627150428.2525192-1-npiggin@gmail.com>
References: <20200627150428.2525192-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These are only called in one place for a given platform, so inline them
for performance.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/dbell.h | 59 ++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/dbell.c      | 55 -----------------------------
 2 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/include/asm/dbell.h b/arch/powerpc/include/asm/dbell.h
index 4ce6808deed3..5c9625e5070b 100644
--- a/arch/powerpc/include/asm/dbell.h
+++ b/arch/powerpc/include/asm/dbell.h
@@ -13,6 +13,7 @@
 
 #include <asm/ppc-opcode.h>
 #include <asm/feature-fixups.h>
+#include <asm/kvm_ppc.h>
 
 #define PPC_DBELL_MSG_BRDCAST	(0x04000000)
 #define PPC_DBELL_TYPE(x)	(((x) & 0xf) << (63-36))
@@ -87,9 +88,6 @@ static inline void ppc_msgsync(void)
 
 #endif /* CONFIG_PPC_BOOK3S */
 
-extern void doorbell_global_ipi(int cpu);
-extern void doorbell_core_ipi(int cpu);
-extern int doorbell_try_core_ipi(int cpu);
 extern void doorbell_exception(struct pt_regs *regs);
 
 static inline void ppc_msgsnd(enum ppc_dbell type, u32 flags, u32 tag)
@@ -100,4 +98,59 @@ static inline void ppc_msgsnd(enum ppc_dbell type, u32 flags, u32 tag)
 	_ppc_msgsnd(msg);
 }
 
+/*
+ * Doorbells must only be used if CPU_FTR_DBELL is available.
+ * msgsnd is used in HV, and msgsndp is used in !HV.
+ *
+ * These should be used by platform code that is aware of restrictions.
+ * Other arch code should use ->cause_ipi.
+ *
+ * doorbell_global_ipi() sends a dbell to any target CPU.
+ * Must be used only by architectures that address msgsnd target
+ * by PIR/get_hard_smp_processor_id.
+ */
+static inline void doorbell_global_ipi(int cpu)
+{
+	u32 tag = get_hard_smp_processor_id(cpu);
+
+	kvmppc_set_host_ipi(cpu);
+	/* Order previous accesses vs. msgsnd, which is treated as a store */
+	ppc_msgsnd_sync();
+	ppc_msgsnd(PPC_DBELL_MSGTYPE, 0, tag);
+}
+
+/*
+ * doorbell_core_ipi() sends a dbell to a target CPU in the same core.
+ * Must be used only by architectures that address msgsnd target
+ * by TIR/cpu_thread_in_core.
+ */
+static inline void doorbell_core_ipi(int cpu)
+{
+	u32 tag = cpu_thread_in_core(cpu);
+
+	kvmppc_set_host_ipi(cpu);
+	/* Order previous accesses vs. msgsnd, which is treated as a store */
+	ppc_msgsnd_sync();
+	ppc_msgsnd(PPC_DBELL_MSGTYPE, 0, tag);
+}
+
+/*
+ * Attempt to cause a core doorbell if destination is on the same core.
+ * Returns 1 on success, 0 on failure.
+ */
+static inline int doorbell_try_core_ipi(int cpu)
+{
+	int this_cpu = get_cpu();
+	int ret = 0;
+
+	if (cpumask_test_cpu(cpu, cpu_sibling_mask(this_cpu))) {
+		doorbell_core_ipi(cpu);
+		ret = 1;
+	}
+
+	put_cpu();
+
+	return ret;
+}
+
 #endif /* _ASM_POWERPC_DBELL_H */
diff --git a/arch/powerpc/kernel/dbell.c b/arch/powerpc/kernel/dbell.c
index f17ff1200eaa..52680cf07c9d 100644
--- a/arch/powerpc/kernel/dbell.c
+++ b/arch/powerpc/kernel/dbell.c
@@ -18,61 +18,6 @@
 
 #ifdef CONFIG_SMP
 
-/*
- * Doorbells must only be used if CPU_FTR_DBELL is available.
- * msgsnd is used in HV, and msgsndp is used in !HV.
- *
- * These should be used by platform code that is aware of restrictions.
- * Other arch code should use ->cause_ipi.
- *
- * doorbell_global_ipi() sends a dbell to any target CPU.
- * Must be used only by architectures that address msgsnd target
- * by PIR/get_hard_smp_processor_id.
- */
-void doorbell_global_ipi(int cpu)
-{
-	u32 tag = get_hard_smp_processor_id(cpu);
-
-	kvmppc_set_host_ipi(cpu);
-	/* Order previous accesses vs. msgsnd, which is treated as a store */
-	ppc_msgsnd_sync();
-	ppc_msgsnd(PPC_DBELL_MSGTYPE, 0, tag);
-}
-
-/*
- * doorbell_core_ipi() sends a dbell to a target CPU in the same core.
- * Must be used only by architectures that address msgsnd target
- * by TIR/cpu_thread_in_core.
- */
-void doorbell_core_ipi(int cpu)
-{
-	u32 tag = cpu_thread_in_core(cpu);
-
-	kvmppc_set_host_ipi(cpu);
-	/* Order previous accesses vs. msgsnd, which is treated as a store */
-	ppc_msgsnd_sync();
-	ppc_msgsnd(PPC_DBELL_MSGTYPE, 0, tag);
-}
-
-/*
- * Attempt to cause a core doorbell if destination is on the same core.
- * Returns 1 on success, 0 on failure.
- */
-int doorbell_try_core_ipi(int cpu)
-{
-	int this_cpu = get_cpu();
-	int ret = 0;
-
-	if (cpumask_test_cpu(cpu, cpu_sibling_mask(this_cpu))) {
-		doorbell_core_ipi(cpu);
-		ret = 1;
-	}
-
-	put_cpu();
-
-	return ret;
-}
-
 void doorbell_exception(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
-- 
2.23.0

