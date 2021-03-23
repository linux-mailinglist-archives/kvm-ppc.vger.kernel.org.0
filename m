Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108C6345474
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCWBEQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhCWBDv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:03:51 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACCCC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v186so10042831pgv.7
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pAmyop6LwM+4FDD1RxgDkC21dW+bikvsGlmlJj1lI8o=;
        b=PjOiyXfF+7iUXAE8OVjNkcy4hQhF3A1LfCRadGlw7i7n9joQxtsTYQct6lg9YgOwbE
         yvW1eTX9R2n1CG2Dj+N0dehT1rWXep1sDtCHNwB/XXcUZN5D8FokJKJMUWESWcG1BDU8
         r1g7Zzm8meMR0EwKiCt6pAWo6gj+iT9Ld5O4P3dK8be6FEULAN9CzG4sDi6tpwrrHnIW
         GBEfdQYlqAgzSpGtMh8C/56cGx/6828bc0h4so05GrofrV/o5GXuyusOi95G1NsKF3ae
         6Ar1HkfjJ9kqnRAJQ/JOUyJm3IMs58+jAwn/AX2A+WRXNzRce31zkPvSfdz4NwuSgjEm
         sXLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pAmyop6LwM+4FDD1RxgDkC21dW+bikvsGlmlJj1lI8o=;
        b=JF1fepytm+IDfCrLVs8cI878SeCjUdUO98BX/sqXPURV3XWJZmCDhL69TP1HpxB8C1
         nL2Emx6KeQpeSGca0x3GFn3lUGeFIgZ4Nv1eXFcrZPwwQEj2VU9XPyDfBuLWlhkE/PVq
         GfZgoAUaFhJeTNSej577ZcsbVcI1JhavJlRnAxsBy/zOKHJRLZl0NN0ZFqx1LlsAxFza
         4lGNdcoARKvsisW4yTQXG7BoYGRgebkrBrBAcS0MA/Q3O4wbYih0gnTfpz+MgrBmguya
         TyVeoTS1klTKoBg6J3hDO8GRi3b8DK/3ODYhuCF9YzyosZo6dXhaEeI8wzdCy3Khw19L
         t24A==
X-Gm-Message-State: AOAM530jWX1+bKIUj4MjirJehbc5Oq2JPLPwROAIP4lQjKCyOCnTUeOi
        rE8nAPuOCa6JJ1u55S6jvS8znY2q5iE=
X-Google-Smtp-Source: ABdhPJxihCf2xHLUgCEyFWk/daW/fvZ9JJ1/5SDgSc7y8eu/UO2AUIcujHd9jumg4R0PolkaebqikQ==
X-Received: by 2002:a17:902:b7c5:b029:e6:1a9f:5f55 with SMTP id v5-20020a170902b7c5b02900e61a9f5f55mr2171864plz.57.1616461430283;
        Mon, 22 Mar 2021 18:03:50 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:03:50 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 11/46] KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR
Date:   Tue, 23 Mar 2021 11:02:30 +1000
Message-Id: <20210323010305.1045293-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than clear the HV bit from the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to set the bit.

The HV clear is kept in guest entry for now, but a future patch will
warn if it's not present.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 4 ++--
 arch/powerpc/kvm/book3s_hv_nested.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 41cb03d0bde4..7a0e33a9c980 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,8 +662,8 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
-	/* Guest must always run with ME enabled. */
-	msr = msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	msr = (msr | MSR_ME) & ~MSR_HV;
 
 	/*
 	 * Check for illegal transactional state bit combination
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 886c7fa86add..d192e799c0af 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -329,8 +329,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
 	vcpu->arch.regs = l2_regs;
 
-	/* Guest must always run with ME enabled. */
-	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
+	/* Guest must always run with ME enabled, HV disabled. */
+	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
 
 	sanitise_hv_regs(vcpu, &l2_hv);
 	restore_hv_regs(vcpu, &l2_hv);
-- 
2.23.0

