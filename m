Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782C3D51A3
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGZDKY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B501C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mt6so11146099pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kEqA7vOEeKgJgAq14VGJCgRh3U53BtCOszjkng3J0z0=;
        b=noIJf7ZlBDB+Bu1tHe5pndp5cWC49V8fxdqm+W2ebEdHIBIldnDHsz4fIf0sFtXOiI
         fYNUocu+P87fc1Ef4FIXHhoZwYK19R5zAvPTnZdLDHAHQuOu2Hcxg/gmvN0Aa1V6BI0Q
         iH6b9mrhH0HfbNQLcLUDU9sO0nBUnXIvcq2AoIM7kD3o81MbqSXz1S387a3tXNpiHrbl
         oqFeyT8bCO9ywxdagRv6N2HKzgLmNU8TXWKr4uOr2QGAGeVmV480wm6F5TXDptbgGTRG
         Zve+BSWD1hqgExhPh2m5uxioPecd9wkmdccQ5gLrpFvxxAEoYyjLKTUFpoP1nuMXwUKJ
         eETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kEqA7vOEeKgJgAq14VGJCgRh3U53BtCOszjkng3J0z0=;
        b=ttTbo/YMFsizuM9KzsESvzg0FcjWLCa/oyxodTKIk9bvuUJFnm5wCdNyC4WWAFFOHr
         tMbAxC4MijdZP8RxbvFrvBM1II1hfC4blzuqq6wz9VS7+ItVRI88B5ER67OEMC+NtJUM
         CJ9lxf4wBl0QTZEV5BsP+zSVKk3loet3rbiU9L2s7jw2zcKExu7/VfPRlEw+d7WhOtkX
         OV61l+wO/hiXMXRsTbtkf523kCacyWTXxY0qQYSw3I/34ItQir2pLBvZykFbI1qRbY7U
         4pKfUV0P1XRuGYfoBl1ky6efPJZ0FZwe/ne2kKK5Jg9MgrG7uvAMGer21q8w6Zh48XaB
         r7Fw==
X-Gm-Message-State: AOAM532VJc1gFgUJ0LV/Yc6Otld5+mTlXHSrKIWkCOOo0wujv2puQjYG
        xBVEE2ZI2k+vLRBiwfPtGzLHxmS6u0A=
X-Google-Smtp-Source: ABdhPJxaQVBhbrGsaoMcpf5xUTpTHJmnZ8sxLi2eKmsYWcdr/05Hx9NuWp+m00WUMo8fOSTym2xtYw==
X-Received: by 2002:a65:63d0:: with SMTP id n16mr6254047pgv.432.1627271451548;
        Sun, 25 Jul 2021 20:50:51 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 03/55] KVM: PPC: Book3S HV: Sanitise vcpu registers in nested path
Date:   Mon, 26 Jul 2021 13:49:44 +1000
Message-Id: <20210726035036.739609-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
---
 arch/powerpc/kvm/book3s_hv_nested.c | 100 +++++++++++++++-------------
 1 file changed, 52 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 898f942eb198..9bb0788d312c 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -104,8 +104,17 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 
+	/*
+	 * When loading the hypervisor-privileged registers to run L2,
+	 * we might have used bits from L1 state to restrict what the
+	 * L2 state is allowed to be. Since L1 is not allowed to read
+	 * the HV registers, do not include these modifications in the
+	 * return state.
+	 */
+	hr->hfscr = ((~HFSCR_INTR_CAUSE & hr->hfscr) |
+		     (HFSCR_INTR_CAUSE & vcpu->arch.hfscr));
+
 	hr->dpdes = vc->dpdes;
-	hr->hfscr = vcpu->arch.hfscr;
 	hr->purr = vcpu->arch.purr;
 	hr->spurr = vcpu->arch.spurr;
 	hr->ic = vcpu->arch.ic;
@@ -134,49 +143,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
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
 
@@ -288,6 +255,43 @@ static int kvmhv_write_guest_state_and_regs(struct kvm_vcpu *vcpu,
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
+	vcpu->arch.hfscr = l2_hv->hfscr & (HFSCR_INTR_CAUSE | l1_hv->hfscr);
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
@@ -296,7 +300,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	struct hv_guest_state l2_hv = {0}, saved_l1_hv;
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
 	u64 hv_ptr, regs_ptr;
-	u64 hdec_exp;
+	u64 hdec_exp, lpcr;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
 
 	if (vcpu->kvm->arch.l1_ptcr == 0)
@@ -369,8 +373,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* Guest must always run with ME enabled, HV disabled. */
 	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
 
-	sanitise_hv_regs(vcpu, &l2_hv);
-	restore_hv_regs(vcpu, &l2_hv);
+	lpcr = l2_hv.lpcr;
+	load_l2_hv_regs(vcpu, &l2_hv, &saved_l1_hv, &lpcr);
 
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
@@ -380,7 +384,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
+		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.23.0

