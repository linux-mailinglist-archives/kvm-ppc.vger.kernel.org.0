Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AADF22DB93
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jul 2020 05:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgGZDwN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 25 Jul 2020 23:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgGZDwN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 25 Jul 2020 23:52:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5438CC0619D2
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t6so6442107plo.3
        for <kvm-ppc@vger.kernel.org>; Sat, 25 Jul 2020 20:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SXPByRIVOtgNt4fMOsCOaJfTq9bG9oPqav6sJdrUadY=;
        b=m15VKaboVQJmAQHrn6KJ1HP3h3LphbkWpyhVro6MPtvNFqzIbC2kAQM5SRy6s7h9Lp
         QdvumwCny0OLDOCGHq2VrDyN3O98IkKicJUMPf5Z6JesVkztDtmS7UsNXa1poL130I4/
         DXpBflhsoERwO1KgX33DGrWhU9zBTBVF9UUryxwYDs/PhH9WzUKdt2u9jn0yRIhRaOo/
         YT9lBTsn5kU/yzBuWjyvWLExHp7u7l/K5O5vsWjeC0QSO6lmHRIkxNLZtoc85Ir57q6O
         ylfgp0XjnO6bhZh5P7w0CiiTyREINrb612ZrbxBnjBXtK1o8kF5Z2Zn4e1Bjq0IAkTfR
         tXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SXPByRIVOtgNt4fMOsCOaJfTq9bG9oPqav6sJdrUadY=;
        b=icl6g4PYDf3Ffcxb2bWGJOIc4XJ5BPplLDnpgt+K9IIJyqDyn2MV7xAo79k84Rvb6x
         nG6eFqoJh9Su1ERdaExoXjBdiLaGLgKGE7/o5DZIWdSJZTkloc3VBTFhjz466qRuwl2Y
         0XpYv7o0YXoYrw8U5iBRP8F7jbDMyR8FVtNw6L4CnXIH9lztuAVc3tBRj+/qKM7EJZ/T
         mHlzViCxhS7YUkstuZkJHZPOQ7SAJ1WIWGsvuleIpop1rxdeQHX+FWg8fCExQra+NLSM
         f0/bZI9jnC/fcHsAFktJFnzHJ+tMVuwGiKaq2x59aITaVt4ItWSJVoN3iijl5tRDPrTC
         3cKw==
X-Gm-Message-State: AOAM530DQEd1+XU5HmViYffZ3x4BgE2iSLkI/HOzDdRRgiqF4pz6qqRF
        3mdz6QrguYWKA51f08LA++Y=
X-Google-Smtp-Source: ABdhPJwEIYxDT5P7kEhC+9qHveHOg/MSxwiF9nsRVj+dQID8OmnH2MVLj85A9WF2p8hTRYlWB2BQUg==
X-Received: by 2002:a17:902:9f88:: with SMTP id g8mr14192485plq.126.1595735532895;
        Sat, 25 Jul 2020 20:52:12 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (110-174-173-27.tpgi.com.au. [110.174.173.27])
        by smtp.gmail.com with ESMTPSA id p1sm3638860pjp.10.2020.07.25.20.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:52:12 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Anton Blanchard <anton@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>, kvm-ppc@vger.kernel.org
Subject: [PATCH v3 1/3] powerpc: inline doorbell sending functions
Date:   Sun, 26 Jul 2020 13:51:53 +1000
Message-Id: <20200726035155.1424103-2-npiggin@gmail.com>
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

These are only called in one place for a given platform, so inline them
for performance.

Tested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/dbell.h | 67 ++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/dbell.c      | 55 --------------------------
 2 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/include/asm/dbell.h b/arch/powerpc/include/asm/dbell.h
index 4ce6808deed3..1f04f3de96ba 100644
--- a/arch/powerpc/include/asm/dbell.h
+++ b/arch/powerpc/include/asm/dbell.h
@@ -13,6 +13,11 @@
 
 #include <asm/ppc-opcode.h>
 #include <asm/feature-fixups.h>
+#ifdef CONFIG_KVM
+#include <asm/kvm_ppc.h>
+#else
+static inline void kvmppc_set_host_ipi(int cpu) {}
+#endif
 
 #define PPC_DBELL_MSG_BRDCAST	(0x04000000)
 #define PPC_DBELL_TYPE(x)	(((x) & 0xf) << (63-36))
@@ -87,9 +92,6 @@ static inline void ppc_msgsync(void)
 
 #endif /* CONFIG_PPC_BOOK3S */
 
-extern void doorbell_global_ipi(int cpu);
-extern void doorbell_core_ipi(int cpu);
-extern int doorbell_try_core_ipi(int cpu);
 extern void doorbell_exception(struct pt_regs *regs);
 
 static inline void ppc_msgsnd(enum ppc_dbell type, u32 flags, u32 tag)
@@ -100,4 +102,63 @@ static inline void ppc_msgsnd(enum ppc_dbell type, u32 flags, u32 tag)
 	_ppc_msgsnd(msg);
 }
 
+#ifdef CONFIG_SMP
+
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
+#endif /* CONFIG_SMP */
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

