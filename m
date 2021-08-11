Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA63E953B
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbhHKQCV (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQCV (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:21 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C8EC061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u15so1137572ple.2
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNmXb4V9H5CVPboFqQ74PeD5qalgG4Hrmthz0rtVqMU=;
        b=uYzPC1nWCpHz1kstVbV67ejMEIdI05TwO0kMqsuxfQBvYMPsiQPakSZpVM0CUnfQKM
         sX92OYRntLysWGxwqrFyNK9PPpY1SFA8n4vDGlce34N14jzpnp74MgYDa/ZReRqcYF2h
         f9x9yhd69QVoR/TqaMz110p/rIc75A0ZT99s1ygylLY6D20y3IM53AmGOEzL4A0c7VOG
         HVsDsg0k2q0Rf1rzPB/d+0w6Bo4ObbjusDYJHBbGwqd3CN9LpUHVCKYvwQqkGnAQjx9Y
         0LKXpS5Z8x++qkKSzAE4imEnAlYI2zyme8DUw77Mvdl0xIK183XG8m8kNFMXryyo2QGd
         XtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNmXb4V9H5CVPboFqQ74PeD5qalgG4Hrmthz0rtVqMU=;
        b=XEJf8k/Owj7HzZ0RRUOfg2VFKKN0UtOqvwbRN0cJOq6KiqpBpBXcrI9LaxiTuFBBZR
         iYyPWUzTegg+tCfIkQx6Wv8O04NeJ1lcX45MmeP2xKDMLxUJMrSQrQgevr1s1Ge5br72
         CyMU+IS9hkaw6LU9g4NT0laTF4i6N9ozB3FsHeQILZ4l5QOOuDx83kFPN5GLfOZXuhts
         doZ8YK6lh3sOHFXD3UPHxZ0LmerG5d82/ilDP0kapAuHu2ffz5vKpB/ZVbN0JOxXVutA
         YgqM2apZgNF3mf0TJYb7LavcfnYmkC2n2vlnzmaiesbApVtMGxoDRlkiki+NdzhrseXM
         KCbg==
X-Gm-Message-State: AOAM533RHuveA8W73JimhtV0ijC5Lwy66CnPjiNq52NFWXDziap/5jcx
        Hn8JqCb5t8Xiy8WEiGQQWC8+of6MTd0=
X-Google-Smtp-Source: ABdhPJwF47g3yw89T7Kmjw3yhTbkLIQYlhDJh0c8CACCi602e+TOi3+MPJRMFuT56BWUwlHSM1/zjw==
X-Received: by 2002:a05:6a00:1984:b029:3cd:c2ed:cd5a with SMTP id d4-20020a056a001984b02903cdc2edcd5amr9844299pfl.12.1628697717079;
        Wed, 11 Aug 2021 09:01:57 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:01:56 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 05/60] KVM: PPC: Book3S HV Nested: Sanitise vcpu registers
Date:   Thu, 12 Aug 2021 02:00:39 +1000
Message-Id: <20210811160134.904987-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

As one of the arguments of the H_ENTER_NESTED hypercall, the nested
hypervisor (L1) prepares a structure containing the values of various
hypervisor-privileged registers with which it wants the nested guest
(L2) to run. Since the nested HV runs in supervisor mode it needs the
host to write to these registers.

To stop a nested HV manipulating this mechanism and using a nested
guest as a proxy to access a facility that has been made unavailable
to it, we have a routine that sanitises the values of the HV registers
before copying them into the nested guest's vcpu struct.

However, when coming out of the guest the values are copied as they
were back into L1 memory, which means that any sanitisation we did
during guest entry will be exposed to L1 after H_ENTER_NESTED returns.

This patch alters this sanitisation to have effect on the vcpu->arch
registers directly before entering and after exiting the guest,
leaving the structure that is copied back into L1 unchanged (except
when we really want L1 to access the value, e.g the Cause bits of
HFSCR).

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 94 ++++++++++++++---------------
 1 file changed, 46 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 898f942eb198..1eb4e989edc7 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -105,7 +105,6 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
 	hr->dpdes = vc->dpdes;
-	hr->hfscr = vcpu->arch.hfscr;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
 	hr->ic = vcpu->arch.ic;
@@ -128,55 +127,17 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	case BOOK3S_INTERRUPT_H_INST_STORAGE:
 		hr->asdr = vcpu->arch.fault_gpa;
 		break;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+		hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
+			     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
+		break;
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
 		hr->heir = vcpu->arch.emul_inst;
 		break;
 	}
 }
 
-/*
- * This can result in some L0 HV register state being leaked to an L1
- * hypervisor when the hv_guest_state is copied back to the guest after
- * being modified here.
- *
- * There is no known problem with such a leak, and in many cases these
- * register settings could be derived by the guest by observing behaviour
- * and timing, interrupts, etc., but it is an issue to consider.
- */
-static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	u64 mask;
-
-	/*
-	 * Don't let L1 change LPCR bits for the L2 except these:
-	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
-
-	/*
-	 * Additional filtering is required depending on hardware
-	 * and configuration.
-	 */
-	hr->lpcr = kvmppc_filter_lpcr_hv(vcpu->kvm,
-			(vc->lpcr & ~mask) | (hr->lpcr & mask));
-
-	/*
-	 * Don't let L1 enable features for L2 which we've disabled for L1,
-	 * but preserve the interrupt cause field.
-	 */
-	hr->hfscr &= (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
-
-	/* Don't let data address watchpoint match in hypervisor state */
-	hr->dawrx0 &= ~DAWRX_HYP;
-	hr->dawrx1 &= ~DAWRX_HYP;
-
-	/* Don't let completed instruction address breakpt match in HV state */
-	if ((hr->ciabr & CIABR_PRIV) == CIABR_PRIV_HYPER)
-		hr->ciabr &= ~CIABR_PRIV;
-}
-
-static void restore_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
+static void restore_hv_regs(struct kvm_vcpu *vcpu, const struct hv_guest_state *hr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
@@ -288,6 +249,43 @@ static int kvmhv_write_guest_state_and_regs(struct kvm_vcpu *vcpu,
 				     sizeof(struct pt_regs));
 }
 
+static void load_l2_hv_regs(struct kvm_vcpu *vcpu,
+			    const struct hv_guest_state *l2_hv,
+			    const struct hv_guest_state *l1_hv, u64 *lpcr)
+{
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	u64 mask;
+
+	restore_hv_regs(vcpu, l2_hv);
+
+	/*
+	 * Don't let L1 change LPCR bits for the L2 except these:
+	 */
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
+		LPCR_LPES | LPCR_MER;
+
+	/*
+	 * Additional filtering is required depending on hardware
+	 * and configuration.
+	 */
+	*lpcr = kvmppc_filter_lpcr_hv(vcpu->kvm,
+				      (vc->lpcr & ~mask) | (*lpcr & mask));
+
+	/*
+	 * Don't let L1 enable features for L2 which we've disabled for L1,
+	 * but preserve the interrupt cause field.
+	 */
+	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | vcpu->arch.hfscr);
+
+	/* Don't let data address watchpoint match in hypervisor state */
+	vcpu->arch.dawrx0 = l2_hv->dawrx0 & ~DAWRX_HYP;
+	vcpu->arch.dawrx1 = l2_hv->dawrx1 & ~DAWRX_HYP;
+
+	/* Don't let completed instruction address breakpt match in HV state */
+	if ((l2_hv->ciabr & CIABR_PRIV) == CIABR_PRIV_HYPER)
+		vcpu->arch.ciabr = l2_hv->ciabr & ~CIABR_PRIV;
+}
+
 long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 {
 	long int err, r;
@@ -296,7 +294,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	struct hv_guest_state l2_hv = {0}, saved_l1_hv;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 hv_ptr, regs_ptr;
-	u64 hdec_exp;
+	u64 hdec_exp, lpcr;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
 
 	if (vcpu->kvm->arch.l1_ptcr == 0)
@@ -369,8 +367,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* Guest must always run with ME enabled, HV disabled. */
 	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
 
-	sanitise_hv_regs(vcpu, &l2_hv);
-	restore_hv_regs(vcpu, &l2_hv);
+	lpcr = l2_hv.lpcr;
+	load_l2_hv_regs(vcpu, &l2_hv, &saved_l1_hv, &lpcr);
 
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
@@ -380,7 +378,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
+		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.23.0

