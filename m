Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631703D51E4
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhGZDMW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhGZDMW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85219C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m1so11127036pjv.2
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7tzAmHt9KFCtjyh0DlOhYXuEQ09+ToK2o7s2d30wi4=;
        b=T4Qgip1KmTTvnYJO1orXDsbOKQ2HY5MjVPhZr3mE8waj56Ds3xJLVFSGfRv7Szdn1y
         QEzBi1loDZwMIy49XVPf8h/N1fXKHBhgcHelSVF0/AyF2h+2AOjgeWJ4muenI4CbdSqC
         PvUrTx7RF19wifBUACpAviUfXSzAwe/ZNK0ysFv9S9SpSfVVngyJDrbiZIvfJ3+zvHLo
         fDBxmKlxQxE14P5J5dsSNY/5p7Mk+7zxjCqagaSpqQWdgGUy3oQ/E3sG9o6w6nrXZiQr
         rwaARkvRIC259z375gg2N3HbUA2XXq6FvPckc9qiQ+HENWTGj78+lM+7wXhJb2GLk05M
         aqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7tzAmHt9KFCtjyh0DlOhYXuEQ09+ToK2o7s2d30wi4=;
        b=j0p+Otxvdcy0O7I/uWmoRG94zhQjLjlBT6sVE8qtNSCQ04APlb4NqIQ591DiIqeiZA
         /AWPH/2o9pov+YrGU4fXiyil6skRHxsT9G+W5qP9NTlSOBkkSIXFbDKwrQny8aetiLGu
         mGuJQeNxtKrar3b7NYmuU8MNOagJzsxvuLG8rPx+0RE9MKlMKtmyel3aw51YIv9lH92J
         hhEQe4mxmTnAG9iqqJWdSUkKosicXnhcsLYYTuQqmkN/8ysMqPS/5lTX3BK/z5UxGPni
         KvqdSRzSA+1PICzcB91T9jzcUNdzto9i40j3J1MXYs8x7RfcpT+Qlv8lTXJ6HGbmXfU3
         cT2Q==
X-Gm-Message-State: AOAM530il2dBQ5i5CtVijuXU77ADQ4O85ESMvMSOjaU/WAoQtKsgx3NC
        3wj73PNDsvlOpT2iLlUVYa/ta15DjBM=
X-Google-Smtp-Source: ABdhPJzwIM7O9OUMjHW7iRnCSulR7E5dYl4iqmmFRRUkU6vIcCXmbFuSo8vKOF91kEH2jrCedJc7DQ==
X-Received: by 2002:a17:90a:f40f:: with SMTP id ch15mr3517977pjb.32.1627271571042;
        Sun, 25 Jul 2021 20:52:51 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 55/55] KVM: PPC: Book3S HV P9: Remove subcore HMI handling
Date:   Mon, 26 Jul 2021 13:50:36 +1000
Message-Id: <20210726035036.739609-56-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
 arch/powerpc/kvm/book3s_hv.c          | 12 +++++-----
 arch/powerpc/kvm/book3s_hv_hmi.c      |  7 +++++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 32 ++++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s_hv_ras.c      |  4 ++++
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b727b2cfad98..3f62ada1a669 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3994,8 +3994,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
-	kvmppc_subcore_enter_guest();
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4048,8 +4046,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	kvmppc_subcore_exit_guest();
-
 	return trap;
 }
 
@@ -6031,9 +6027,11 @@ static int kvmppc_book3s_init_hv(void)
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
index 032ca6dfd83c..d23e1ef2e3a7 100644
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
@@ -927,7 +928,36 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
+
+		hmi_exception_realmode(NULL);
+
+		if (vc->tb_offset) {
+			u64 new_tb = mftb() + vc->tb_offset;
+			mtspr(SPRN_TBU40, new_tb);
+			if ((mftb() & 0xffffff) < (new_tb & 0xffffff)) {
+				new_tb += 0x1000000;
+				mtspr(SPRN_TBU40, new_tb);
+			}
+			vc->tb_offset_applied = vc->tb_offset;
+		}
 
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

