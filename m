Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19311345476
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCWBEQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhCWBDt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77007C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:48 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v2so10038767pgk.11
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dk5Q5Z4e+foxwg9SPWLW5LDYDiqB75zP/uAAU3KLgnA=;
        b=fEe7AiMuG1FIkoWcu4L+4anvLSLgY+yjfbjBl/lzSpiQQXdc0F8IqCW77bWnvpZSeE
         ZQfIf32wfKhP2ySEXq/ZdXQV2OKwleN4cSL/VMwqps1Xojy2oxhJ1ytk8wbKuGs+TDsg
         aZY28A+Jn+NHudCcAunZyyYgCB+Q/cL3+L0IQ9tTL6OHmIcYpjh+B9/QVW8bFTkJo0em
         rXR/1pjF86+jP+DwLgG99SMjCVh43IyC82NH1HWFD3AAZD92UR9M50Wz2U1cfsMCizbF
         STKovOnHy3gdCUoBxcfARiM6ZlsH0h6U+zv3o0nQrEcjAFY9dltyqtl8iD65nBc0C1Uy
         cRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dk5Q5Z4e+foxwg9SPWLW5LDYDiqB75zP/uAAU3KLgnA=;
        b=T1S/ER68lfZrt97p/YWk9JMH3oMTwIb6V5cQYqAf4SzjnivABNc3hobgOLrbBXKyem
         J0/DUqfOYWd2covRu8KAZCPFZv7B270s2VOkkNuGbTwBb5MmaWP0DyvXOJvSfHn/leGg
         g4XiPfBPavqrWSne01j0nQ3ASups00vBCCwTL/6n7SopjwbUF1EOfxxucTqK84u6rPu4
         /QQJ/NG+oFg8oxKOYP2+SYNkGc3yChP3Ojxf589i80nxckdCSqdSMz3EXkHM0bl7p/Ze
         +gMNUUyoiKYUawf8/xqkYYR6P6KXfRjfkFWUi32EliZ5KRyVGnW5EUXgMTf02ZehidM/
         CE8w==
X-Gm-Message-State: AOAM531E2UB4s2vPNia0+pQIo4iz83/K0DIKv42jO5D7qWW7t1umU2Ev
        BsD6aFptqSw5BNIIgJSAoEBGOu0r9Q4=
X-Google-Smtp-Source: ABdhPJx9lnGWRstc9BoZOXUBhW15S6WU7QZT+WTC+goDI3pnELMtfe4iVK2v8gRhqUZGibilij/EYQ==
X-Received: by 2002:a17:902:bd96:b029:e6:3d73:f90e with SMTP id q22-20020a170902bd96b02900e63d73f90emr2221997pls.63.1616461427921;
        Mon, 22 Mar 2021 18:03:47 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:47 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 10/46] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Tue, 23 Mar 2021 11:02:29 +1000
Message-Id: <20210323010305.1045293-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to clear the bit.

The ME set is kept in guest entry for now, but a future patch will
warn if it's not present.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 3 +++
 arch/powerpc/kvm/book3s_hv_nested.c  | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 158d309b42a3..41cb03d0bde4 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,6 +662,9 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
+	/* Guest must always run with ME enabled. */
+	msr = msr | MSR_ME;
+
 	/*
 	 * Check for illegal transactional state bit combination
 	 * and if we find it, force the TS field to a safe state.
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 851e3f527eb2..886c7fa86add 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -328,7 +328,9 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested = l2;
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
-	vcpu->arch.shregs.msr = vcpu->arch.regs.msr;
+
+	/* Guest must always run with ME enabled. */
+	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
 
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

