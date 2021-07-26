Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5073D51A5
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhGZDK3 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDK2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B176C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso12423092pjs.2
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wNummKPcVaVmiGYV9E4Z8BF0hMfr2KcTst4lEXRe9HM=;
        b=l/PcRICZkHQrE8/9m4QNi6nXKBBLHuoIBRevXCd+e7PEBXKLDhVibNhTQhIN67ap9s
         5uI/ro1xKX8jVrrFm/TwOCcUKXZcQYUWzBV7TjzCNfuD3gqAEzb/LOdF45sc9muFhZq8
         Fld6Cxf9VqhBC+i68T49k0jTt96K0ynqR94mWbkpBsw6YVx8YY1MPx3Cpwt80y5x+N+0
         a8P8QyzT2wuQZjoIS76VmK6aoXGUCec2Az+rMCyOqcDuzgfLqQ6fZg7nKKnefTQVRfI2
         s1o2jWbZA+2rQOHQAPyYc7HNIRn1IBOHYOJxkZdfd3NDJKnP+ov2FYLRwFy51CBThSB8
         nMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wNummKPcVaVmiGYV9E4Z8BF0hMfr2KcTst4lEXRe9HM=;
        b=LVLoJi4Bvx66lhzgunVqBfirNOVrXHb0WxhVbZbYj4z+FfYV+od1QYl00mI9q8jJki
         PC4NaoQUPqOITlpAzPJTqslkHxk3TzhSqWz/MQU0jAoJn6X1xUayPqUVJNCRigPsOyNj
         xNXunn6PcJ5P50XwjlsYqiiM67k2OLI2M7vI1gJv2ybAEyBKL19HQC/Kz7HObZFPoeb2
         x1gOv7k7wmVUn73E5/Ao6gYsGnpLE+uPRUBniu75A/hWONV2sAVPHfROy+l+vfV78oKQ
         vyCE9WkXdbhD3nVzy6leKgR2D0/L5uHDLVvF5Zrk28O8x1nvfrsALZxbSL9C9SrxliuU
         BOwQ==
X-Gm-Message-State: AOAM5321lQbw23u2nJODBBLBl9EAGH5embsAW/mShohG6aCzCPaYdojY
        jQnhC/SPYiOAKty27nxXg5Wu2cfKIks=
X-Google-Smtp-Source: ABdhPJxoiy+p1LoDS1VZilzKAgEuYia2n5b0397IJnz73YHJROVKs0FbtfxMxEwkOpLQ7w9zU7TpzQ==
X-Received: by 2002:a17:902:e54f:b029:12b:55c9:3b48 with SMTP id n15-20020a170902e54fb029012b55c93b48mr13016745plf.45.1627271456537;
        Sun, 25 Jul 2021 20:50:56 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 05/55] KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live
Date:   Mon, 26 Jul 2021 13:49:46 +1000
Message-Id: <20210726035036.739609-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/pmc.h |  7 +++++++
 arch/powerpc/kvm/book3s_hv.c   | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

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
index adac1a6431a0..c743020837e7 100644
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
@@ -3864,6 +3865,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	    cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST))
 		kvmppc_restore_tm_hv(vcpu, vcpu->arch.shregs.msr, true);
 
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		if (vcpu->arch.vpa.pinned_addr) {
+			struct lppaca *lp = vcpu->arch.vpa.pinned_addr;
+			get_lppaca()->pmcregs_in_use = lp->pmcregs_in_use;
+		} else {
+			get_lppaca()->pmcregs_in_use = 1;
+		}
+		barrier();
+	}
+#endif
 	kvmhv_load_guest_pmu(vcpu);
 
 	msr_check_and_set(MSR_FP | MSR_VEC | MSR_VSX);
@@ -3998,6 +4011,13 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	save_pmu |= nesting_enabled(vcpu->kvm);
 
 	kvmhv_save_guest_pmu(vcpu, save_pmu);
+#ifdef CONFIG_PPC_PSERIES
+	if (kvmhv_on_pseries()) {
+		barrier();
+		get_lppaca()->pmcregs_in_use = ppc_get_pmu_inuse();
+		barrier();
+	}
+#endif
 
 	vc->entry_exit_map = 0x101;
 	vc->in_guest = 0;
-- 
2.23.0

