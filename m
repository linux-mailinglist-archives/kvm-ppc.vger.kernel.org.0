Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7A345468
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhCWBDn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhCWBDX (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C28C061756
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so348797pjb.1
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LBaKXTT6tqcmaGc11EoTMESopxHECp8yTZkMjkgVdLc=;
        b=Izxu2cY+h1HMwlVPhSf7n1rDjX3J7yv3/47wGc/tPq02fFj3fMf6i7k88nzt2PBf8z
         UfcYoP4Eb1/xo9e8kix2dNRJ2dAw0V04HgKEyYhSE1wRXAF2f8dnBnHXANIkKl2Y6vVZ
         F4Vp6MjoUUbUgGWO0bemSdNTjJLid3eOmF3kY59ZRD/PpvB9bp1iZhqq1qUVz+inPMx1
         q988gLOjSHZhzu2GCQANkUb8yN2+QlwZVFafjUxXrvIg8m0qZWWvQ3laiBA34ZmbcWPQ
         0n1VxX90OKOKW78cgI7Ahjoq9bYRQsnMXQKjXogfQi5DmjEyv+S7cBXPBY25SCXRvAmD
         V+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LBaKXTT6tqcmaGc11EoTMESopxHECp8yTZkMjkgVdLc=;
        b=QNHdSx3qA6vH+UGQOsgF+3+R5awEnB4f4W3jVniZL0azxNOeMTh7iSWL7eX5fbP7+M
         TcfILcmSMo/EC0qWhE85r1uB+m844wD+/PydjecJDUgEN+IgftuQAOh7/K+nx5yTorU8
         iI+jB2XgcI+iGaKBoTwtrigsemUsj/5uVy31UxTIFGM4SWj+ASp+x72q4C6I9ye509JY
         FjnGjphVforZaeAAHeSbqkl8ZJlXb1feuXyMgGCk80pgWaVLwxwydp6Mv3/7odn/X+6m
         XsxzWHKfbaRVcvZ7+rgynJYGemHzWOnN+NdqJbDjzH2PUDebPl/IY6LnONSUgP6Fv6cX
         0o7A==
X-Gm-Message-State: AOAM532YNJRmAQO2liM+dY1IJtpxWln2cW2WRCS6q+wwrI9GwpZVdbAl
        kmsktt7izJNQ0GPujQIFK0Rqib8nd7c=
X-Google-Smtp-Source: ABdhPJxPrJAxqYsh/kdROFwhwjRfieZjHzAssNiKzOsvkTUuAlj+IB/4tEwgnNKY418GpysusHsshg==
X-Received: by 2002:a17:90a:ba05:: with SMTP id s5mr1806215pjr.194.1616461401004;
        Mon, 22 Mar 2021 18:03:21 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 01/46] KVM: PPC: Book3S HV: Nested move LPCR sanitising to sanitise_hv_regs
Date:   Tue, 23 Mar 2021 11:02:20 +1000
Message-Id: <20210323010305.1045293-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This will get a bit more complicated in future patches. Move it
into the helper function.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..2fe1fea4c934 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -134,6 +134,16 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 
 static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 {
+	struct kvmppc_vcore *vc = vcpu->arch.vcore;
+	u64 mask;
+
+	/*
+	 * Don't let L1 change LPCR bits for the L2 except these:
+	 */
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
+		LPCR_LPES | LPCR_MER;
+	hr->lpcr = (vc->lpcr & ~mask) | (hr->lpcr & mask);
+
 	/*
 	 * Don't let L1 enable features for L2 which we've disabled for L1,
 	 * but preserve the interrupt cause field.
@@ -271,8 +281,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	u64 hv_ptr, regs_ptr;
 	u64 hdec_exp;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
-	u64 mask;
-	unsigned long lpcr;
 
 	if (vcpu->kvm->arch.l1_ptcr == 0)
 		return H_NOT_AVAILABLE;
@@ -321,9 +329,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
-	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
+
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
 
@@ -335,7 +341,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
+		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.23.0

