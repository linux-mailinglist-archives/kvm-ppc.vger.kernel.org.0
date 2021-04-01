Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6FD35181B
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbhDARoC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhDARhf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:37:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E847FC0F26E1
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:13 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id l123so157248pfl.8
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ocK5Yj4V6zWz31hzBzslA9cG5h0MlbgFIped0AK4ODc=;
        b=GdkJQx9spOFFcxE2CC3tfo7++LldwXZuoRpuCpO0i9gfDP7LorEwp1S0Io+MbGhfTI
         Rl9GCU23NUBr3F8obxfhuLOPg9shvnjv92DFVr2RzNqI3BSsMOyXMM1LH70WaJyiI9E5
         9MGEsahxc1Lt8Y6/fRsxqHiEuFAggZoayvmcXSYWZROuW4Y+MbKLv3aH/RroWHq09ZVv
         c2Jqu0VEYyvpOO9dFHBDEpEh2HjU41jRw1/oLwlXozJ1g2IZO+CnpXNijVBNimXrsXcp
         s3TiHoL07CVbLvbQ+YpSg5rOiewXBS7R553w8ZSkwQJG6rZJWMkSPLVmqQauf8aKtmBw
         a6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ocK5Yj4V6zWz31hzBzslA9cG5h0MlbgFIped0AK4ODc=;
        b=UFhMGflSOOQM1Z17pamJr/KyJk/nPyHCd9SZ1N6zzDj/n1uja/4CIVWTOqio3i+5mG
         FFJK1r0PjDRNT9Ghq20ruE7hUrNg6t/4tFh+kBSpQG5OLlXVnQrmPGIW2AlpOQ4mPfN7
         aavenmNtHcABiPdLNnkYQo2Zp1RWr9Ug34s8mVAitrGNh592PTJdQpNbctupFuH9QsS4
         T4x+z6a+BEH+RoYigS3K528L0bNd/csd2xdeLPRDq7KQbBYlbuu+mxOz8HsmrJEIIUkd
         e/jURyOIu6JGcq9EFPaOMaB0tToeI8fY8eWivk3k3Wq+57WHubZbNKMyGtAi6QqlI0PG
         j9kg==
X-Gm-Message-State: AOAM533SN3CrNKxoxB3GlHbWqnyg9C+SUsERHJdH/jZigXDp/jgA3A10
        YqPvOP+CPw6UdvaFNEg7Np9Xx4Eoo6I=
X-Google-Smtp-Source: ABdhPJzqDZWMnnEUOqNw+ciJtfQN5aGcnLgdUdfS5EX2zmqvx19FJY7/qxH35JIhv3UeF62ymFzW6g==
X-Received: by 2002:a65:4c43:: with SMTP id l3mr7736960pgr.327.1617289453409;
        Thu, 01 Apr 2021 08:04:13 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH v5 11/48] KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR
Date:   Fri,  2 Apr 2021 01:02:48 +1000
Message-Id: <20210401150325.442125-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than clear the HV bit from the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to set the bit.

The HV clear is kept in guest entry for now, but a future patch will
warn if it is present.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
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
index fb03085c902b..60724f674421 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -344,8 +344,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
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

