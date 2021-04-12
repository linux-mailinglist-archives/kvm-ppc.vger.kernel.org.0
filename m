Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B532635B83A
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDLBtT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:19 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1EFC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id z16so8178982pga.1
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bHMMJ1bBn1zkHC5+ylovzEBfrAxZyP46YygKZ7eOaes=;
        b=oEWyQKid7q2UrUYlKoo1kKPGZ1P4xmq0Ou2ZE5nEt8906/mb9y68BDahSuPKkH0Mq7
         20TgZwz0R+xHFeTTHwxbgw2ZAQhxmVm105cCjTlvtdSlS1jWv3+9nPijrp2dqaKcEDwy
         hubzVWkloMYyw55PCxA/IDcdnnNxj9m9ihS6qcdoDebQhzl2Q3TueWbit9dBdiNAU1NQ
         nhvVZShQ/LI4CHxmy4ugjQmRXqlJd5sZ3TR0wnYKc1GUcKaB9RiHkiXTv6FaN3sZMrDK
         ddx7072tkpb7WWKdHdbSIsL6rDiHkDjYsALmTyu0GT8VmXRiNJYmj5aDeZfpf47iXpbV
         RvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bHMMJ1bBn1zkHC5+ylovzEBfrAxZyP46YygKZ7eOaes=;
        b=NCAettFFQ1Wof2cJg7KItw2cMc+PP28Rp0yULeqei59SnL6C3HByUrUm2HFpV8WZi5
         SC7bXeFfEZX2s8lEEFAbLCLd8XR25KZulDhiIO+K/jGBSBk1M2qREx0NLiTU2SVUTuqw
         oGYjtW2DY2tDMncMduv9NFQ5tRlpzO2XxZjbhfX9j1ZpfIb9EQV3xJD2a4jt48VafJfZ
         44Cd2RsfOBumfpk8I1q21TanZr/TJk2QK2znedQSiTHVISqY6ByHwA8PoNmcWEKsKXOu
         2b/6Obkl5ovi4ehlTMRJdXbPm2DzQ72AIfOCueZKv3NVZU+XgstLeZSxBXBZN3wK/zWx
         wSiw==
X-Gm-Message-State: AOAM530enFYjjwUjyicSGRbeR3gGvjMPJjZNxsluEjdt/rYyiO11m+v2
        FYj4LrRhmixIgnlYzQxrR57q16uZj6M=
X-Google-Smtp-Source: ABdhPJzao+p6qJTLxrT6zgF943n7L1u4OwFDjcAq7G9obKRcYVjADV2oV3eWhwI+vyeqh9VeTJX3aA==
X-Received: by 2002:a63:d50c:: with SMTP id c12mr6648720pgg.145.1618192141836;
        Sun, 11 Apr 2021 18:49:01 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 03/12] KVM: PPC: Book3S HV: Add a function to filter guest LPCR bits
Date:   Mon, 12 Apr 2021 11:48:36 +1000
Message-Id: <20210412014845.1517916-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
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
index 208a053c9adf..268e31c7e49c 100644
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
 
@@ -4644,8 +4673,10 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned long mask)
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
@@ -4973,6 +5004,7 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
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

