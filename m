Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3E351BAF
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhDASKo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbhDASCn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:02:43 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7920CC0F26D7
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:03:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c204so1682031pfc.4
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4shQOl+Q9zLkUpe6/3smaSERBWGUCH93NF6hRCaZmCU=;
        b=pct2ImT1yiWenCyRNDcBx5gHovrtH7YeC4F0c6w3+hqDDCbwtpAZ2iq7twhuqs1fT5
         NmoEaS3ycb37cBJmk9JD6tWer4GxHiQi07tgle3+n58ZraSEhbuD/EQzzopBCWJiDUqK
         1StjlRF/M67RlA9gHz0SCezERthZ6mJ34Dt34VG7QiEEr4eqpORSDdiigOKmRl7YJT04
         2AsABcsc0UIRHEGCi2xMCE2gHChhtHmcfaEgjBf8kasfvRFhiUAOqEqBWErGf1HX0D53
         DKRQSfReRWQsCvSIGDJ/jaSoA0GT3CPgZXRED/8lcVjTXoqBqiFtjyO8LQPH771MNDHe
         Bvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4shQOl+Q9zLkUpe6/3smaSERBWGUCH93NF6hRCaZmCU=;
        b=dynxEM4t5vqHJwTAx1UAKaW7nMRkz1WZuMVSLfv//y0Vd+SLzLgODnMdSw8gAaHLtU
         6YTIykGvenVc3oM+uxyiD+2++iC75r+SwEJyF0wIBfcPI6JJDRRx4Z9sDoAK7/GKdf+X
         MpsqRM7dbbXQc0UmRw6dTDXzi6ofa8KHLma0KPKCDjH6Xt0lMQtL/tzd+37/2WxYKqR7
         pBEqf+krrAwsN2ifd7UfTm6Zsovi3Sguht5ZQvYdH5+rmsblWs1qxkkM7Bff8BvBzZKr
         /wweyyILUomUyfU628ofJrP4Yd0BB0EDN3zMX8O8UxO6c0bHzRTQxYrnAlLCRf++Dy2u
         I9Mg==
X-Gm-Message-State: AOAM531LoFrRbYtR8jUaGang6+szujkWpjvO0YtH6fCmr+BawzNPL542
        a0798lrwPuw2ZC7zprvg7ZAiPAeAaiw=
X-Google-Smtp-Source: ABdhPJzPl/yo5H4hgvq329YoBqa1WpH5lszcyUFlMKvM7cfFE8/CBKync1+DQDPSW2q4elL8nvUKiA==
X-Received: by 2002:a63:ea50:: with SMTP id l16mr8009769pgk.70.1617289421904;
        Thu, 01 Apr 2021 08:03:41 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:03:41 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 02/48] KVM: PPC: Book3S HV: Add a function to filter guest LPCR bits
Date:   Fri,  2 Apr 2021 01:02:39 +1000
Message-Id: <20210401150325.442125-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Guest LPCR depends on hardware type, and future changes will add
restrictions based on errata and guest MMU mode. Move this logic
to a common function and use it for the cases where the guest
wants to update its LPCR (or the LPCR of a nested guest).

This also adds a warning in other places that set or update LPCR
if we try to set something that would have been disallowed by
the filter, as a sanity check.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |  2 +
 arch/powerpc/kvm/book3s_hv.c          | 68 ++++++++++++++++++++-------
 arch/powerpc/kvm/book3s_hv_nested.c   |  8 +++-
 3 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 2f5f919f6cd3..c58121508157 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -258,6 +258,8 @@ extern long kvmppc_hv_get_dirty_log_hpt(struct kvm *kvm,
 extern void kvmppc_harvest_vpa_dirty(struct kvmppc_vpa *vpa,
 			struct kvm_memory_slot *memslot,
 			unsigned long *map);
+extern unsigned long kvmppc_filter_lpcr_hv(struct kvm *kvm,
+			unsigned long lpcr);
 extern void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr,
 			unsigned long mask);
 extern void kvmppc_set_fscr(struct kvm_vcpu *vcpu, u64 fscr);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..d2c7626cb960 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1635,6 +1635,35 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Enforce limits on guest LPCR values based on hardware availability,
+ * guest configuration, and possibly hypervisor support and security
+ * concerns.
+ */
+unsigned long kvmppc_filter_lpcr_hv(struct kvm *kvm, unsigned long lpcr)
+{
+	/* On POWER8 and above, userspace can modify AIL */
+	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
+		lpcr &= ~LPCR_AIL;
+
+	/*
+	 * On POWER9, allow userspace to enable large decrementer for the
+	 * guest, whether or not the host has it enabled.
+	 */
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
+		lpcr &= ~LPCR_LD;
+
+	return lpcr;
+}
+
+static void verify_lpcr(struct kvm *kvm, unsigned long lpcr)
+{
+	if (lpcr != kvmppc_filter_lpcr_hv(kvm, lpcr)) {
+		WARN_ONCE(1, "lpcr 0x%lx differs from filtered 0x%lx\n",
+			  lpcr, kvmppc_filter_lpcr_hv(kvm, lpcr));
+	}
+}
+
 static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 		bool preserve_top32)
 {
@@ -1643,6 +1672,23 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 	u64 mask;
 
 	spin_lock(&vc->lock);
+
+	/*
+	 * Userspace can only modify
+	 * DPFD (default prefetch depth), ILE (interrupt little-endian),
+	 * TC (translation control), AIL (alternate interrupt location),
+	 * LD (large decrementer).
+	 * These are subject to restrictions from kvmppc_filter_lcpr_hv().
+	 */
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD;
+
+	/* Broken 32-bit version of LPCR must not clear top bits */
+	if (preserve_top32)
+		mask &= 0xFFFFFFFF;
+
+	new_lpcr = kvmppc_filter_lpcr_hv(kvm,
+			(vc->lpcr & ~mask) | (new_lpcr & mask));
+
 	/*
 	 * If ILE (interrupt little-endian) has changed, update the
 	 * MSR_LE bit in the intr_msr for each vcpu in this vcore.
@@ -1661,25 +1707,8 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 		}
 	}
 
-	/*
-	 * Userspace can only modify DPFD (default prefetch depth),
-	 * ILE (interrupt little-endian) and TC (translation control).
-	 * On POWER8 and POWER9 userspace can also modify AIL (alt. interrupt loc.).
-	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC;
-	if (cpu_has_feature(CPU_FTR_ARCH_207S))
-		mask |= LPCR_AIL;
-	/*
-	 * On POWER9, allow userspace to enable large decrementer for the
-	 * guest, whether or not the host has it enabled.
-	 */
-	if (cpu_has_feature(CPU_FTR_ARCH_300))
-		mask |= LPCR_LD;
+	vc->lpcr = new_lpcr;
 
-	/* Broken 32-bit version of LPCR must not clear top bits */
-	if (preserve_top32)
-		mask &= 0xFFFFFFFF;
-	vc->lpcr = (vc->lpcr & ~mask) | (new_lpcr & mask);
 	spin_unlock(&vc->lock);
 }
 
@@ -4641,8 +4670,10 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned long mask)
 		struct kvmppc_vcore *vc = kvm->arch.vcores[i];
 		if (!vc)
 			continue;
+
 		spin_lock(&vc->lock);
 		vc->lpcr = (vc->lpcr & ~mask) | lpcr;
+		verify_lpcr(kvm, vc->lpcr);
 		spin_unlock(&vc->lock);
 		if (++cores_done >= kvm->arch.online_vcores)
 			break;
@@ -4970,6 +5001,7 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 		kvmppc_setup_partition_table(kvm);
 	}
 
+	verify_lpcr(kvm, lpcr);
 	kvm->arch.lpcr = lpcr;
 
 	/* Initialization for future HPT resizes */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 3060e5deffc8..d14fe32f167b 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -151,7 +151,13 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	 */
 	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
 		LPCR_LPES | LPCR_MER;
-	hr->lpcr = (vc->lpcr & ~mask) | (hr->lpcr & mask);
+
+	/*
+	 * Additional filtering is required depending on hardware
+	 * and configuration.
+	 */
+	hr->lpcr = kvmppc_filter_lpcr_hv(vcpu->kvm,
+			(vc->lpcr & ~mask) | (hr->lpcr & mask));
 
 	/*
 	 * Don't let L1 enable features for L2 which we've disabled for L1,
-- 
2.23.0

