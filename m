Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E784C3D51A4
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhGZDK0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhGZDKZ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:10:25 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE58C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt6so11146207pjb.1
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8UBTM45PptEgGbJ6eGLIibMu8Q6Rsmel7GFQgZufaPE=;
        b=ZZgsfapa4LOcRIARu+vtQhK/XfomCmdBHNAdRZ7FFxh1y0vUuyc4F54Pt0xv3aXqcG
         +9OLJea0LQQttph5g54UKKcYZLlu/ZJTrheWz1tqJ3aCfSoLFDMM39ShhmDdDRS1HeU5
         3YkNpynzrSlqs/nmc5jwqGywnJCJbrwzBI+nzMMUaWznKlbxyvceap2yGOQgJuNx5R2y
         Mfdu34B8nR5X5+gtPJ8WYKSwXxwmjs4IlhwVQC0QkMxPDAU80vbo2yWHZQnFdBE1UeKu
         H1YwKzEBx6G6UmltaQsLz8dpP8DD//tE9f0xYlWx64q7ws0uihyhAv+xfjEUMT/6MpG4
         kbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8UBTM45PptEgGbJ6eGLIibMu8Q6Rsmel7GFQgZufaPE=;
        b=odVMmPqXq/qAIF8nAzq9d5+n4Mx8c8Zf3ifT5yueQLiyW718ZG1xkTWB9pY13zFTz9
         Qm/UnnGz1HE7DPtwWLiAYEEPTNOehRCtxpzz7uj5PrMVxjfvN8L9/KRL//XoW591gVuC
         HjVuNyc3Zj1weL/l8Emg338q9+gJYTZbZG/oKnr6Xxkp1WFg2VS77iYc7koqnVA6S+ou
         uBOh7iutgnHvY4H7tMdhOLmg2S8CndldzNFacQ9zB0HOJ7iWh+iWCkXm98BFfN/WpxB6
         GFcME2NUsmb5KXCGB71kr/YamzOr2/pLrgrb25IHnUu74Mul79cThpkXYq6BN5b7j7Vp
         PiGw==
X-Gm-Message-State: AOAM53026n/oh4yM4Y5vaZmhOAIL2/pmWl0tddvBcgsYlsHmbOdgssLr
        XI4bEskBkT45yq+NnFa4NhTjCcVckIM=
X-Google-Smtp-Source: ABdhPJwrtE0BBzK/PPlVzKAFYKj6zEVYkcJdteKsLPBHCq8pIQR9UR7baOjBCzAtyc1nI7BeVgstzA==
X-Received: by 2002:a17:90b:4b08:: with SMTP id lx8mr15404083pjb.66.1627271454050;
        Sun, 25 Jul 2021 20:50:54 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:50:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 04/55] KVM: PPC: Book3S HV: Stop forwarding all HFUs to L1
Date:   Mon, 26 Jul 2021 13:49:45 +1000
Message-Id: <20210726035036.739609-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

If the nested hypervisor has no access to a facility because it has
been disabled by the host, it should also not be able to see the
Hypervisor Facility Unavailable that arises from one of its guests
trying to access the facility.

This patch turns a HFU that happened in L2 into a Hypervisor Emulation
Assistance interrupt and forwards it to L1 for handling. The ones that
happened because L1 explicitly disabled the facility for L2 are still
let through, along with the corresponding Cause bits in the HFSCR.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 9bb0788d312c..983628ed4376 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -99,7 +99,7 @@ static void byteswap_hv_regs(struct hv_guest_state *hr)
 	hr->dawrx1 = swab64(hr->dawrx1);
 }
 
-static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
+static void save_hv_return_state(struct kvm_vcpu *vcpu,
 				 struct hv_guest_state *hr)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -128,7 +128,7 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	hr->pidr = vcpu->arch.pid;
 	hr->cfar = vcpu->arch.cfar;
 	hr->ppr = vcpu->arch.ppr;
-	switch (trap) {
+	switch (vcpu->arch.trap) {
 	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
 		hr->hdar = vcpu->arch.fault_dar;
 		hr->hdsisr = vcpu->arch.fault_dsisr;
@@ -137,6 +137,27 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	case BOOK3S_INTERRUPT_H_INST_STORAGE:
 		hr->asdr = vcpu->arch.fault_gpa;
 		break;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+	{
+		u8 cause = vcpu->arch.hfscr >> 56;
+
+		WARN_ON_ONCE(cause >= BITS_PER_LONG);
+
+		if (!(hr->hfscr & (1UL << cause)))
+			break;
+
+		/*
+		 * We have disabled this facility, so it does not
+		 * exist from L1's perspective. Turn it into a HEAI.
+		 */
+		vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
+		kvmppc_load_last_inst(vcpu, INST_GENERIC, &vcpu->arch.emul_inst);
+
+		/* Don't leak the cause field */
+		hr->hfscr &= ~HFSCR_INTR_CAUSE;
+
+		fallthrough;
+	}
 	case BOOK3S_INTERRUPT_H_EMUL_ASSIST:
 		hr->heir = vcpu->arch.emul_inst;
 		break;
@@ -394,7 +415,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	delta_spurr = vcpu->arch.spurr - l2_hv.spurr;
 	delta_ic = vcpu->arch.ic - l2_hv.ic;
 	delta_vtb = vc->vtb - l2_hv.vtb;
-	save_hv_return_state(vcpu, vcpu->arch.trap, &l2_hv);
+	save_hv_return_state(vcpu, &l2_hv);
 
 	/* restore L1 state */
 	vcpu->arch.nested = NULL;
-- 
2.23.0

