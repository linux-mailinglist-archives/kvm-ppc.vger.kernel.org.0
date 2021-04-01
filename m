Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212993518DF
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 19:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbhDARsB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbhDARlj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:41:39 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2A4C0F26E0
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c17so1669671pfn.6
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=Lb1CdsK4K7L+NG4t6H4dCnYoWNK9DTcjr5m6PiMNuuuqbj4G60ggiKUIjX6Shdwb5N
         J/3kTXgufsuimpOHE/vQGMsmXf4nugL7YKyf3qBuzSmkex4K5Aw+gD848QAd5lbUmewi
         fRKdnmE07x4QYEK/ia5+AF45EKerK/pQTZe2J8QzOTLygJOv/591trgaFHh+6KM8vrpq
         Kvfty50OZmzUYqlXEfyiaQtlEWZ1kuJgTCxkFDTvKw/ar7DQMuLLCEHv7KmkkWnrxbL5
         4mGgHniRZBn10RuM1MGeN/vDUAe47pWloo06oGFwEBOZYfrRYzmLqSSqe4uFHBcvXWZ5
         XHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=ueOdyPW4W+6/xOXZOg+eZ0Y/WN/rK1PhEzw5djGz4KwjMMH8HBdgGo3+APkxbWnzpG
         xl4r91OVT5uBlsE1Rh/ls8UdaYvlj11dmfQc8tkdtYshvJAvLM503rTbzjCY9uBahdpa
         0OLt1c/9v8EcG6kfMwQjK0YhSF1c9jMx5ntRZvLLwEzH/vB9vnmOO9mdnjUBDSWjAIGy
         IZEdzOLWSQeZ1HrPbHhEquBx91KkBzOh/SrrhfxEnTrhntYtZnZoWue+RzsHJQvlvH3i
         51P6F7PlzEUKYYvswcJgbqQ0aH7xy92pXRVBkFB7Vzx6vR4GFVi+Eel+6oRwGjviWtQA
         3W5g==
X-Gm-Message-State: AOAM533CbUbkwI6hECYrELGA0WN4pIRdeSNrbf1KmPgx3Nptrx+QG7XZ
        +EEWGIazb2N3Ds/odHj27XHJk1ccqjU=
X-Google-Smtp-Source: ABdhPJwjNIHlp0wQu+W5Vkhh7Mq9Nfx/IAjZZueBWbxX+Y7adiW+cj3XC+/5QsTNxx/UNyhUpssqDw==
X-Received: by 2002:a65:5688:: with SMTP id v8mr7910382pgs.78.1617289450250;
        Thu, 01 Apr 2021 08:04:10 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:09 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 10/48] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Fri,  2 Apr 2021 01:02:47 +1000
Message-Id: <20210401150325.442125-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR at guest entry, make it clear
that the hypervisor does not allow the guest to clear the bit.

The ME set is kept in guest entry for now, but a future patch will
warn if it's not present.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
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
index d14fe32f167b..fb03085c902b 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -343,7 +343,9 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
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

