Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA713ADA22
	for <lists+kvm-ppc@lfdr.de>; Sat, 19 Jun 2021 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhFSNgv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 19 Jun 2021 09:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbhFSNgv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 19 Jun 2021 09:36:51 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B07C061574
        for <kvm-ppc@vger.kernel.org>; Sat, 19 Jun 2021 06:34:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x73so9979716pfc.8
        for <kvm-ppc@vger.kernel.org>; Sat, 19 Jun 2021 06:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nESXQM1OExvqD9HHBb9R8J2/RbX6a61t5CJT6KMY5pc=;
        b=kxsDGqDKuMnZFzVOF+OUzJu5qMix3IYf6FeStGOiQ54lyslyq/9rh+n5jq26aEMllX
         lYjAkVXjNCxHCSDqZQiBxC58+A2rTX1ynvt3asNjKbYE00dkEIRhT0/jWWa46jqHbhew
         xifmOw7xch5iRxFy2BpfN8hjzKzo6s61NKixi5zV8PCDD870djUIWTScibKg9mr+KIXn
         3Yhvbd35bCA+Z+ag+L8lIXyC0Tzx5MH7cKR4ZtEkrYFCj1SeVpZUZZPaqkHMgHkVHr/h
         4gyqWRd1Fgh4VTsO+iAp9w+B+xlsy45LudrpR6YGejMTUgJS50W3AeqZHhs7NMETj32T
         mujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nESXQM1OExvqD9HHBb9R8J2/RbX6a61t5CJT6KMY5pc=;
        b=KTKhNxMsxV/mwLXwJBYU2ub4SfSPEr88jFTJDRrwataWlGv/lF1Aq3zJ1RzvvaWH6t
         OIz4v2daOoCWQmbTVU2i4u73LEgohM4vo23UiSX/97rMp65L7YdZfGXbkrjZcW8QClpN
         tH0lxrOAhR6+Eo5yY9cavLK9kQEX5WrbsyNqqjVW8tfzoZy2KmGCl/I0kWtnxlBZWcfM
         yFQ2i2CACosg+o9RQXV2Ue17olVFNqpACEOSrd82IGNFURRVLjueV8XQ1Wt2WizjVl39
         8qWLAoeUR1+wwY+ACvsvkzvmtPX5AtroyxVb0IXGHaITN+rwknEVlzWKYFhNeR4fSxZ7
         OIfw==
X-Gm-Message-State: AOAM530fujCY+HBxeU+79zg9xwQjB+EG/WWFniryhinqOrck8VpRPgG9
        McppplL/p8MZ3NvWvwM4bEzmJ7oPmB8=
X-Google-Smtp-Source: ABdhPJxfDfoMDsKeOQ8j3Fi11PqLOhOyZFAMOPGc5FgUKMzEfPBAreZkFWhZoMBRFsCUc3RBLGjD9g==
X-Received: by 2002:a65:6243:: with SMTP id q3mr15256616pgv.297.1624109678900;
        Sat, 19 Jun 2021 06:34:38 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id t13sm10850920pfh.97.2021.06.19.06.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 06:34:38 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] KVM: PPC: Book3S HV Nested: Reflect L2 PMU in-use to L0 when L2 SPRs are live
Date:   Sat, 19 Jun 2021 23:34:15 +1000
Message-Id: <20210619133415.20016-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

After the L1 saves its PMU SPRs but before loading the L2's PMU SPRs,
switch the pmcregs_in_use field in the L1 lppaca to the value advertised
by the L2 in its VPA. On the way out of the L2, set it back after saving
the L2 PMU registers (if they were in-use).

This transfers the PMU liveness indication between the L1 and L2 at the
points where the registers are not live.

This fixes the nested HV bug for which a workaround was added to the L0
HV by commit 63279eeb7f93a ("KVM: PPC: Book3S HV: Always save guest pmu
for guest capable of nesting"), which explains the problem in detail.
That workaround is no longer required for guests that include this bug
fix.

Fixes: 360cae313702 ("KVM: PPC: Book3S HV: Nested guest entry via hypercall")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
I have a later performance patch that reverts the workaround, but it
would be good to fix the nested HV first so there is some lead time for
the fix to percolate.

Thanks,
Nick

 arch/powerpc/include/asm/pmc.h |  7 +++++++
 arch/powerpc/kvm/book3s_hv.c   | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/powerpc/include/asm/pmc.h b/arch/powerpc/include/asm/pmc.h
index c6bbe9778d3c..3c09109e708e 100644
--- a/arch/powerpc/include/asm/pmc.h
+++ b/arch/powerpc/include/asm/pmc.h
@@ -34,6 +34,13 @@ static inline void ppc_set_pmu_inuse(int inuse)
 #endif
 }
 
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+static inline int ppc_get_pmu_inuse(void)
+{
+	return get_paca()->pmcregs_in_use;
+}
+#endif
+
 extern void power4_enable_pmcs(void);
 
 #else /* CONFIG_PPC64 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0d6edb136bd4..e66f96fb6eed 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -59,6 +59,7 @@
 #include <asm/kvm_book3s.h>
 #include <asm/mmu_context.h>
 #include <asm/lppaca.h>
+#include <asm/pmc.h>
 #include <asm/processor.h>
 #include <asm/cputhreads.h>
 #include <asm/page.h>
@@ -3761,6 +3762,16 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		if (vcpu->arch.vpa.pinned_addr) {
+			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
+		} else {
+			get_lppaca()->pmcregs_in_use = 1;
+		}
+	}
+#endif
 	kvmhv_load_guest_pmu(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
@@ -3895,6 +3906,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries())
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+#endif
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
-- 
2.23.0

