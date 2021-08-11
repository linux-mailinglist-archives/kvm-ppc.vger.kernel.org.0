Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC7C3E953D
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Aug 2021 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhHKQC0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Aug 2021 12:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhHKQC0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 11 Aug 2021 12:02:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E908C061765
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e15so3268223plh.8
        for <kvm-ppc@vger.kernel.org>; Wed, 11 Aug 2021 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=STNMxjwluTp9JCjXfe5D1Foa+DbrQm4yTFYqQb0u6iw=;
        b=U9nD7EKjgZigih/6AsSLpz0XDgyYMH4IlfEfteUP5xafhmgzlhBqrwJiuj/wsKiR49
         feyoFauiS5xDdsOnrIks4DWXzYqb8uo7iKChsk/6XkNTy3GouoK1+7jZ4k/sL2kXbcN8
         bkflCMbG89qNaEVTzTPSyn16HAGZ1lDmmRA7aywbZBzKlzqqZ27g/ZuTkz4+eqtRG/ZS
         +E9ttM8XltubyOZZSbFnmFkE4CCp3o90h3DErv8B9xVIarVednpVBBh9Jcl/EFU7himx
         lmeQimEm+X0zwY+Dp4AJqgXme4jvYyNFw3Z1t5EhW696D4vnezQjFQTvaKqCzAnDnFEC
         DYZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=STNMxjwluTp9JCjXfe5D1Foa+DbrQm4yTFYqQb0u6iw=;
        b=EOkICJMhPgTavzpa5U7CCmK+i0L3yw8qaEd0/AFVMdL068EXEBgc8aCjsUe7s1KKPI
         yr5paveiL1mD/ami6RGYMhinwOQDSfKMwuSV7sz+sswmMCHNuIZKJVErFFBLqXeXogdx
         /f4ch1vT4u7l/2QOYVj1R+4NzbqYs7TAYhPzrzMklgoElhT9d0ODDjRzWGhNQ8McovWO
         cfF9f3v5+NjFutklcShZEogR85TpAqp/bkX9Hz3os/LPNicYPFh0L0SB8v3MpYGwTpME
         C3HgYv91YSDOgjlvTvXJluvkZeSzQ6Ph6gYsk34XqZaqVsN9miDoOwPrL6rMWeTvBFfy
         DIlQ==
X-Gm-Message-State: AOAM530Epdu6uo5yg5Kh+BmF5nh+iWoHMoLxjAoihBcA1ChuSFHzCu7T
        V7qBFxpPVNrX1mUx7PkfESQgIzeppY4=
X-Google-Smtp-Source: ABdhPJxUngZExe9nTPF1RaK2X4z2XGC4lH8WAX8beuILcEuopbMdfmlOnh9YyeCt7nWalfEL7syZWw==
X-Received: by 2002:a65:6248:: with SMTP id q8mr618569pgv.279.1628697721998;
        Wed, 11 Aug 2021 09:02:01 -0700 (PDT)
Received: from bobo.ibm.com ([118.210.97.79])
        by smtp.gmail.com with ESMTPSA id k19sm6596494pff.28.2021.08.11.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 09:02:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 07/60] KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1
Date:   Thu, 12 Aug 2021 02:00:41 +1000
Message-Id: <20210811160134.904987-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
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
[np: move handling into kvmppc_handle_nested_exit]
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c65bd8fa4368..7bc9d487bc1a 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1733,6 +1733,7 @@ XXX benchmark guest exits
 
 static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 {
+	struct kvm_nested_guest *nested = vcpu->arch.nested;
 	int r;
 	int srcu_idx;
 
@@ -1822,9 +1823,35 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		fallthrough; /* go to facility unavailable handler */
 #endif
 
-	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
-		r = RESUME_HOST;
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL: {
+		u64 cause = vcpu->arch.hfscr >> 56;
+
+		/*
+		 * Only pass HFU interrupts to the L1 if the facility is
+		 * permitted but disabled by the L1's HFSCR, otherwise
+		 * the interrupt does not make sense to the L1 so turn
+		 * it into a HEAI.
+		 */
+		if (!(vcpu->arch.hfscr_permitted & (1UL << cause)) ||
+					(nested->hfscr & (1UL << cause))) {
+			vcpu->arch.trap = BOOK3S_INTERRUPT_H_EMUL_ASSIST;
+
+			/*
+			 * If the fetch failed, return to guest and
+			 * try executing it again.
+			 */
+			r = kvmppc_get_last_inst(vcpu, INST_GENERIC,
+						 &vcpu->arch.emul_inst);
+			if (r != EMULATE_DONE)
+				r = RESUME_GUEST;
+			else
+				r = RESUME_HOST;
+		} else {
+			r = RESUME_HOST;
+		}
+
 		break;
+	}
 
 	case BOOK3S_INTERRUPT_HV_RM_HARD:
 		vcpu->arch.trap = 0;
-- 
2.23.0

