Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B843C9F3C
	for <lists+kvm-ppc@lfdr.de>; Thu, 15 Jul 2021 15:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhGONSe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 15 Jul 2021 09:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhGONSe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 15 Jul 2021 09:18:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6FEC06175F
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:40 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso5555560pjx.1
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Jul 2021 06:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Nnq2tW9Cjq/DhRE4HH4kRNi6d38rHtNf1hfbltAJ14=;
        b=tjL58WDWUl+RJU0o0zl4IHc4mDYYKa9FUMKSrioX6ntqLkxRD3TXrc0Win5jf26ns4
         O1G7l6XSgCl6FKbcCoKfaVERtu0aLznA5mnj07oTRg499O2Aaoz6LFJVJx/Vrizv3Om5
         mVmIjRibIzktvzxsGyvs4bJSn1PF+YsJ98LR7O1aSXsUpXwPGo0mEVLOlvCHuewMdXbW
         UulxPa2b812Qd8tFMKJUuj50Mv1izAU664jMotO6irjtx67Bg8A2ZFjfE3QZ8Jn9UHb/
         sJEJvxftXxuIf+M4I0VALNrqMzZRNBcifiYO6Fuz+kKuwzpdQL/b1bbyPE9eJQZXXUud
         MXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Nnq2tW9Cjq/DhRE4HH4kRNi6d38rHtNf1hfbltAJ14=;
        b=YumtSfHnKfsLT+zxi9oyq+XaHuVxveA6TGc4qkJ74tGMcbqEhPD/zWYeJyAukNQeQs
         Xg14MSAqzj6i/SyLiUeS+Q+7Zpfa2m1x8WgjsqItRB3BizlSBFkkKSIYiiGU+RwiUgp3
         ZDKmyYTL4FvXWhZi4HXaBkFTT9Jdz9V5LskhLLJrnvdZa4SJ4gdVg4xZv5858hyklOBN
         aWTV6WWzd/BWNdBdxB46WlVTz/4cNC7F1pTyDe2qoQHs7MEFNfeCCGXAfrNqvnRuQ9dO
         xf6+xoaE0Tyt/EmuFSqS0YXfnWpQZjIrkUu9vuBO1uqJEzj12jkRdqQb3EhEN9wVUV0F
         GXqA==
X-Gm-Message-State: AOAM530RoR/CFcC1KwTHn8MNuBO2yeVeKwRCkJavtuYQfQ8bJs+fRlra
        EQ8sWSUvUqA2pWxsH8QME9rw0xhcuND4Aw==
X-Google-Smtp-Source: ABdhPJzQJbG9TZ4Mdi0O8WATkk+L5cO1prDMgUyT/yBbImp+Eg5gaEGjZgvprokb3w3MNOPKrJ52NQ==
X-Received: by 2002:a17:90a:e611:: with SMTP id j17mr10042010pjy.48.1626354939561;
        Thu, 15 Jul 2021 06:15:39 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (27-33-83-114.tpgi.com.au. [27.33.83.114])
        by smtp.gmail.com with ESMTPSA id k6sm4864216pju.8.2021.07.15.06.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 06:15:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 6/6] KVM: PPC: Book3S HV P9: Remove subcore HMI handling
Date:   Thu, 15 Jul 2021 23:15:18 +1000
Message-Id: <20210715131518.146917-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210715131518.146917-1-npiggin@gmail.com>
References: <20210715131518.146917-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On POWER9 and newer, rather than the complex HMI synchronisation and
subcore state, have each thread un-apply the guest TB offset before
calling into the early HMI handler.

This allows the subcore state to be avoided, including subcore enter
/ exit guest, which includes an expensive divide that shows up
slightly in profiles.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 12 +++++-------
 arch/powerpc/kvm/book3s_hv_hmi.c      |  7 ++++++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 21 ++++++++++++++++++++-
 arch/powerpc/kvm/book3s_hv_ras.c      |  4 ++++
 4 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 957efde59014..7d5c31537a79 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3985,8 +3985,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
-	kvmppc_subcore_enter_guest();
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4039,8 +4037,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	kvmppc_subcore_exit_guest();
-
 	return trap;
 }
 
@@ -6022,9 +6018,11 @@ static int kvmppc_book3s_init_hv(void)
 	if (r)
 		return r;
 
-	r = kvm_init_subcore_bitmap();
-	if (r)
-		return r;
+	if (!cpu_has_feature(CPU_FTR_ARCH_300)) {
+		r = kvm_init_subcore_bitmap();
+		if (r)
+			return r;
+	}
 
 	/*
 	 * We need a way of accessing the XICS interrupt controller,
diff --git a/arch/powerpc/kvm/book3s_hv_hmi.c b/arch/powerpc/kvm/book3s_hv_hmi.c
index 9af660476314..1ec50c69678b 100644
--- a/arch/powerpc/kvm/book3s_hv_hmi.c
+++ b/arch/powerpc/kvm/book3s_hv_hmi.c
@@ -20,10 +20,15 @@ void wait_for_subcore_guest_exit(void)
 
 	/*
 	 * NULL bitmap pointer indicates that KVM module hasn't
-	 * been loaded yet and hence no guests are running.
+	 * been loaded yet and hence no guests are running, or running
+	 * on POWER9 or newer CPU.
+	 *
 	 * If no KVM is in use, no need to co-ordinate among threads
 	 * as all of them will always be in host and no one is going
 	 * to modify TB other than the opal hmi handler.
+	 *
+	 * POWER9 and newer don't need this synchronisation.
+	 *
 	 * Hence, just return from here.
 	 */
 	if (!local_paca->sibling_subcore_state)
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 44150a29f6e0..3c9e7a500264 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -3,6 +3,7 @@
 #include <linux/kvm_host.h>
 #include <asm/asm-prototypes.h>
 #include <asm/dbell.h>
+#include <asm/interrupt.h>
 #include <asm/kvm_ppc.h>
 #include <asm/pmc.h>
 #include <asm/ppc-opcode.h>
@@ -900,7 +901,25 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		kvmppc_realmode_machine_check(vcpu);
 
 	} else if (unlikely(trap == BOOK3S_INTERRUPT_HMI)) {
-		kvmppc_realmode_hmi_handler();
+		/*
+		 * Unapply and clear the offset first. That way, if the TB
+		 * was fine then no harm done, if it is corrupted then the
+		 * HMI resync will bring it back to host mode. This way, we
+		 * don't need to actualy know whether not OPAL resynced the
+		 * timebase. Although it would be cleaner if we could rely
+		 * on that, early POWER9 OPAL did not support the
+		 * OPAL_HANDLE_HMI2 call.
+		 */
+		if (vc->tb_offset_applied) {
+			u64 new_tb = mftb() - vc->tb_offset_applied;
+			mtspr(SPRN_TBU40, new_tb);
+			if ((mftb() & 0xffffff) < (new_tb & 0xffffff)) {
+				new_tb += 0x1000000;
+				mtspr(SPRN_TBU40, new_tb);
+			}
+			vc->tb_offset_applied = 0;
+		}
+		hmi_exception_realmode(NULL);
 
 	} else if (trap == BOOK3S_INTERRUPT_H_EMUL_ASSIST) {
 		vcpu->arch.emul_inst = mfspr(SPRN_HEIR);
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6..a49ee9bdab67 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -136,6 +136,10 @@ void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu)
 	vcpu->arch.mce_evt = mce_evt;
 }
 
+/*
+ * This subcore HMI handling is all only for pre-POWER9 CPUs.
+ */
+
 /* Check if dynamic split is in force and return subcore size accordingly. */
 static inline int kvmppc_cur_subcore_size(void)
 {
-- 
2.23.0

