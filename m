Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E5C42138B
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhJDQEz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbhJDQEy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1170C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:03:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j4so210903plx.4
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDapZeq+Cy3m4K/ha0FiUOzYZwT+p/FpOvrkM+uM8lQ=;
        b=Iwuc5/BeQEGbDH9HFCxyQmkwx/v0mQd/vNNky/r0eKdQSWoFzgcR4n+X0nDvL8MBRv
         CIjt1+IriqKuBXtUXpgffvMClEU9Q35eLHLNiZqQ43J5pdDej5gbZIf53pHJ9No8IEpG
         5bRL8Y0fs9foTn1QU3wunMaW6VpjcTWoTeG+Dd1RAaT9MtZWHIJ0WqgbyMKS7QGbgxlF
         ADHwsTp8MgUztZ5GucriEPyyfU1H9wbb8VECM12iN7Wyjss1j6P+xRoOJH8ExBmjk9wD
         vA/t8nydvb7HiDUR2iFDyMkyLEKwKc8LJ/5W0FLIljO6zxWuDYgYBdSAkU5jryzIIdx+
         UxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDapZeq+Cy3m4K/ha0FiUOzYZwT+p/FpOvrkM+uM8lQ=;
        b=YRr4QpN9xzSu56KwTtjWT9MyuT8y5+Qb6bge5zG8qB/S92IPkLAO/IsbCO4th29rAB
         AsQW5CK07UJji0UuXRmJpFRzAAiFU26BOzbN9vieORxUKBs93DA/QUXFnW+AJQqJLeQK
         MfDwQ6cCMC2eNcHJODhqy6rEcjra/dRVXD+FbHvocPsCPlwgNuWPnq58pm+bzIIomNZV
         z392PhrJRYnWgjEjSXCBA+EHHd3uTZurEa0hYWW5OowJfutOAf7hez3tRhg+JZ8VVnfs
         DsBpdsuaNva/6QiijdgHRFTCdZZyTgg6tSn6xopfirDS2TwBEThzrDIXveZHM15ViNf5
         avjg==
X-Gm-Message-State: AOAM531iSHksiJFRKzSBQ3/1HOZ900BANQxWWEP/JIGx9jO49rPVxopR
        NmB0s+kyClyaDPU+L3+t1RyTpe7D2Ms=
X-Google-Smtp-Source: ABdhPJy/apREgMGxV3J8KWmaYig1di0dorNMqQ75JWm2ocp7vQ9l8cznQW55+rHuzKVb+Y7THN9n9A==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr33340553pjn.214.1633363384700;
        Mon, 04 Oct 2021 09:03:04 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:03:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 52/52] KVM: PPC: Book3S HV P9: Remove subcore HMI handling
Date:   Tue,  5 Oct 2021 02:00:49 +1000
Message-Id: <20211004160049.1338837-53-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index 671fbd1a765e..70ffcb3c91bf 100644
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
index 351018f617fb..449ac0a19ceb 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4014,8 +4014,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu->arch.ceded = 0;
 
-	kvmppc_subcore_enter_guest();
-
 	vcpu_vpa_increment_dispatch(vcpu);
 
 	if (kvmhv_on_pseries()) {
@@ -4068,8 +4066,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 
 	vcpu_vpa_increment_dispatch(vcpu);
 
-	kvmppc_subcore_exit_guest();
-
 	return trap;
 }
 
@@ -6069,9 +6065,11 @@ static int kvmppc_book3s_init_hv(void)
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
index fbecbdc42c26..86a222f97e8e 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -938,7 +938,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		kvmppc_realmode_machine_check(vcpu);
 
 	} else if (unlikely(trap == BOOK3S_INTERRUPT_HMI)) {
-		kvmppc_realmode_hmi_handler();
+		kvmppc_p9_realmode_hmi_handler(vcpu);
 
 	} else if (trap == BOOK3S_INTERRUPT_H_EMUL_ASSIST) {
 		vcpu->arch.emul_inst = mfspr(SPRN_HEIR);
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6..ccfd96965630 100644
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
+	 * This way, we don't need to actually know whether not OPAL resynced
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

