Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83F93E957C
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhHKQEo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbhHKQEn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:04:43 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E0C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so3274249plg.9
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3QBUGSojZU/2F66voz9vD6uLX52t4OFR1d+++ZFktyQ=;
        b=uAlKK3xLA0XXOw9+oAoJWPjs07GPGobgo6Ad29rNbl79s1ydF35+noIPh3w++xi0YX
         2DHoSru8IC4k9GMM9YTLJuFqTifBohHwwpVU9Sh1RTp6CTRJ6EK3R1f49BDusEfMC1mv
         2lAncF6TB5qzhZFY9zpWGmW1qhFoW/yue2kAkiAtlJgJc69Q3ELF2qvTcc34EKfsbnUu
         7pNvRStIjbDtf94RUJVsudFH0Nx9JWin/YmauWkgAmy1MML95P0MnM0mns7yFOsMARYg
         heablWWppHCP0OgnrpeOSyYvIWA8J/NpKfygXH16/Hd2AhFeXCR1Vdt+ywbtOZaaUUOt
         Ky6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3QBUGSojZU/2F66voz9vD6uLX52t4OFR1d+++ZFktyQ=;
        b=DVnDI8tMmItua9+F5UVQUfnY4idz9rMyw4BDdQSNmPqJzQJc1UYqJM5tvj38prMkxN
         GErcrAh5ipRTvv1iuK4YTg28sBU/34U6T6OfQOAhVvFr9zYWo+HcwCnnzMAJegISQYDp
         GfB39j2WZFCHnKGVOAvDtXIUyrYwUHmKBBpIjUy6TzMTBEg9gL1o2S8JYGlN2cSRyEO3
         YfTZtBNHCqW/TScEBxxXmnB1pV6XeEx2CIk5ADwB20n/QLPAUnAGW2Oh13DXv+CIzdzB
         6qcVq5Rda3GFrUHIFlfxlwv1v0+qXtTh2cIrw8/a07ecqMWzJLScjtFlZsG4k18Nbjbg
         0Tpw==
X-Gm-Message-State: AOAM53108u8BDuqhNZZuDpDKxdORyveb/tvcoF1kwFN9F6ktPJfmYhL4
        vHQndQm0VuJhBvqqkUcQ3OjgC+sv2mk=
X-Google-Smtp-Source: ABdhPJyXIa/Bg8LVAEd91Dk0/jabj5lRDr5fEFq6jRTG9TSgQa0tpZ3s0EQmsU93kHn7Wc4/uAJCXQ==
X-Received: by 2002:a62:b414:0:b029:317:52d:7fd5 with SMTP id h20-20020a62b4140000b0290317052d7fd5mr35108583pfn.30.1628697859398;
        Wed, 11 Aug 2021 09:04:19 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:04:19 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 60/60] KVM: PPC: Book3S HV P9: Remove subcore HMI handling
Date:   Thu, 12 Aug 2021 02:01:34 +1000
Message-Id: <20210811160134.904987-61-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
 arch/powerpc/include/asm/kvm_ppc.h    |  1 +
 arch/powerpc/kvm/book3s_hv.c          | 12 +++---
 arch/powerpc/kvm/book3s_hv_hmi.c      |  7 +++-
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  2 +-
 arch/powerpc/kvm/book3s_hv_ras.c      | 54 +++++++++++++++++++++++++++
 5 files changed, 67 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 2d88944f9f34..6355a6980ccf 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -760,6 +760,7 @@ void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu);
 void kvmppc_subcore_enter_guest(void);
 void kvmppc_subcore_exit_guest(void);
 long kvmppc_realmode_hmi_handler(void);
+long kvmppc_p9_realmode_hmi_handler(struct kvm_vcpu *vcpu);
 long kvmppc_h_enter(struct kvm_vcpu *vcpu, unsigned long flags,
                     long pte_index, unsigned long pteh, unsigned long ptel);
 long kvmppc_h_remove(struct kvm_vcpu *vcpu, unsigned long flags,
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e7f4525f2a74..f1f343307578 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4017,8 +4017,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
-	kvmppc_subcore_enter_guest();
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4071,8 +4069,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	kvmppc_subcore_exit_guest();
-
 	return trap;
 }
 
@@ -6054,9 +6050,11 @@ static int kvmppc_book3s_init_hv(void)
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
index 1e18c089478e..7d31ad3de723 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -934,7 +934,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		kvmppc_realmode_machine_check(vcpu);
 
 	} else if (unlikely(trap == BOOK3S_INTERRUPT_HMI)) {
-		kvmppc_realmode_hmi_handler();
+		kvmppc_p9_realmode_hmi_handler(vcpu);
 
 	} else if (trap == BOOK3S_INTERRUPT_H_EMUL_ASSIST) {
 		vcpu->arch.emul_inst = mfspr(SPRN_HEIR);
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6..3f94f4080d04 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -136,6 +136,60 @@ void kvmppc_realmode_machine_check(struct kvm_vcpu *vcpu)
 	vcpu->arch.mce_evt = mce_evt;
 }
 
+
+long kvmppc_p9_realmode_hmi_handler(struct kvm_vcpu *vcpu)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	long ret = 0;
+
+	/*
+	 * Unapply and clear the offset first. That way, if the TB was not
+	 * resynced then it will remain in host-offset, and if it was resynced
+	 * then it is brought into host-offset. Then the tb offset is
+	 * re-applied before continuing with the KVM exit.
+	 *
+	 * This way, we don't need to actualy know whether not OPAL resynced
+	 * the timebase or do any of the complicated dance that the P7/8
+	 * path requires.
+	 */
+	if (vc->tb_offset_applied) {
+		u64 new_tb = mftb() - vc->tb_offset_applied;
+		mtspr(SPRN_TBU40, new_tb);
+		if ((mftb() & 0xffffff) < (new_tb & 0xffffff)) {
+			new_tb += 0x1000000;
+			mtspr(SPRN_TBU40, new_tb);
+		}
+		vc->tb_offset_applied = 0;
+	}
+
+	local_paca->hmi_irqs++;
+
+	if (hmi_handle_debugtrig(NULL) >= 0) {
+		ret = 1;
+		goto out;
+	}
+
+	if (ppc_md.hmi_exception_early)
+		ppc_md.hmi_exception_early(NULL);
+
+out:
+	if (vc->tb_offset) {
+		u64 new_tb = mftb() + vc->tb_offset;
+		mtspr(SPRN_TBU40, new_tb);
+		if ((mftb() & 0xffffff) < (new_tb & 0xffffff)) {
+			new_tb += 0x1000000;
+			mtspr(SPRN_TBU40, new_tb);
+		}
+		vc->tb_offset_applied = vc->tb_offset;
+	}
+
+	return ret;
+}
+
+/*
+ * The following subcore HMI handling is all only for pre-POWER9 CPUs.
+ */
+
 /* Check if dynamic split is in force and return subcore size accordingly. */
 static inline int kvmppc_cur_subcore_size(void)
 {
-- 
2.23.0

