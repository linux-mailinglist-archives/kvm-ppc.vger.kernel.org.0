Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F80835B839
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhDLBtS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtS (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C293CC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id p12so8168289pgj.10
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Lonny+8YXdFwRIoOFSgIHHCV4tfZl5PHVskAqriodI=;
        b=pI/M474dTooKHxk5/UB1/wWjIpzBcPplLtbL5Sef9zGP2pYoZJCdvxX1JnceZfj7bk
         xtFQA/TK10Rp802AY4DvvSp2KyqiEvQ2Y8oz6obGc9x/J+Jw/78mtsjvPJQdUP+vSbMn
         nRG+t+OjgJcPmGrS3lOS65fPKT0C5twID1WKgeymqEaXGnCB7IKVkqfmlbJXn6dv319J
         kFQYYIzqZMFVMYSbWQKfubCXlIpQ9yKRON5IG2bmJzwEY2eg6mIJ2yb66BpS8chVO+Dv
         0qoxVHuMNva5bENjw6HNZnotZrW0gCDZAKU3qdW1KBgSzj6SZcAGnEdbRNJJd65LR4Qc
         ObNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Lonny+8YXdFwRIoOFSgIHHCV4tfZl5PHVskAqriodI=;
        b=DUxXRoLKnH7yvqJwoXylYpoCfFEFYgLhE94hPFcOkGnsSQhIU8dvcyAQDFg+g5KmxA
         Udl/NloU9AglFADJzhn+jJJyWtfXhw02lgKVak04Bnx+3AUBgWLH5/qIVnSaVZ2trPu/
         EvshFOqFLxUUBqjLCWMdHuUxVmnWL8Ra/sz+r6J3iUts4f2hG0B0EGHSLauEC9whzsYg
         jT8R74Kc/6m5UC5wI5dJoidzcEzqd3m5sa31F5+YI4PVx8MHBNvzw6FmJS/OlhMQrN5h
         D8JCMFej2bwsQjaD7Hgi8PjlWjGEAvhWIS42iYyifxGCYNapXUeNt4rR9Xc/J7v9q8c+
         3tcw==
X-Gm-Message-State: AOAM530WwBzfXpYWtysB42hybwuvbLc6I7VFnt8JmOmifm9k3szuvshQ
        mwnMCF9S0UUKr69YiVW95TQSCiwqdkw=
X-Google-Smtp-Source: ABdhPJwpXA9j+XU3lCC53r8azGhRlTzJAgAoEnGX348wqbqec1vAUDur3kfcGLGJDF+1qh89i4E1/w==
X-Received: by 2002:a63:330b:: with SMTP id z11mr7260989pgz.32.1618192139254;
        Sun, 11 Apr 2021 18:48:59 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:48:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 02/12] KVM: PPC: Book3S HV: Nested move LPCR sanitising to sanitise_hv_regs
Date:   Mon, 12 Apr 2021 11:48:35 +1000
Message-Id: <20210412014845.1517916-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This will get a bit more complicated in future patches. Move it
into the helper function.

This change allows the L1 hypervisor to determine some of the LPCR
bits that the L0 is using to run it, which could be a privilege
violation (LPCR is HV-privileged), although the same problem exists
now for HFSCR for example. Discussion of the HV privilege issue is
ongoing and can be resolved with a later change.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 0cd0e7aad588..3060e5deffc8 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -132,8 +132,27 @@ static void save_hv_return_state(struct kvm_vcpu *vcpu, int trap,
 	}
 }
 
+/*
+ * This can result in some L0 HV register state being leaked to an L1
+ * hypervisor when the hv_guest_state is copied back to the guest after
+ * being modified here.
+ *
+ * There is no known problem with such a leak, and in many cases these
+ * register settings could be derived by the guest by observing behaviour
+ * and timing, interrupts, etc., but it is an issue to consider.
+ */
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
@@ -271,8 +290,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	u64 hv_ptr, regs_ptr;
 	u64 hdec_exp;
 	s64 delta_purr, delta_spurr, delta_ic, delta_vtb;
-	u64 mask;
-	unsigned long lpcr;
 
 	if (vcpu->kvm->arch.l1_ptcr == 0)
 		return H_NOT_AVAILABLE;
@@ -321,9 +338,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
 	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
-	lpcr = (vc->lpcr & ~mask) | (l2_hv.lpcr & mask);
+
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
 
@@ -335,7 +350,7 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 			r = RESUME_HOST;
 			break;
 		}
-		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
+		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
 	/* save L2 state for return */
-- 
2.23.0

