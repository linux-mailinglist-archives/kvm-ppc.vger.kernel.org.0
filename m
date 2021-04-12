Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1470235B846
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbhDLBtn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236273AbhDLBtn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:43 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C1AC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h25so8180671pgm.3
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=O9RmOhIx1DGathnRcaSu5SzCxKQF+4Akj37mGf7GxOBJ2aolpsQpcJf4V8cL6B1fNj
         GC94N9CbP8C/qhgXDF8pmsdvl6snHX6gPwsgYMQyM+RwaJkOBGcj6Kx1hIA6YEEUvEBP
         oPzgOhAa5l+0Cweoi6smHaBtQCOhZ+gwN+2wRxxDERXLGo1TdOC/CMlhnGT8jKGRVVMd
         HfkpAFm+Hsur0zczwIK7+7HJlxq2kLgYQBfe4H5fCci60bnMp4Lf8EXB8amStM3NP5s6
         E2ufkJFuyKvHIrb84Ws6xOZOjCfNf01MFnXnVfR6sY178igVD7oYlQ5GGvM6SIfxu8sh
         L7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XTwV9xVlVat7TnR+O83IRQJ050ZVGX6uPq2CbLxvr5s=;
        b=eGK47KZSoBLy42NAPtPGKg4aDxk8Ve7zOAhHXSfHlfrpWnrFOawknWj+sMgMv7IVIt
         lbWxGAh/rtepnFi0DR2y8iyRtPnB6KF+PqTdpY4PLQ9+0Eh0p4SOSkHoq1S0GjlITxiR
         YyllJjP2v2SZF1ztbjcY04GtHRBMOCSzxH4q1eMoaKGMngqEOQmmomN04P4HfmQ9oG7n
         NJsgoDp9rgeTw8BFLCIm8TxW+W0bCYpYz9rQWPFeeE3eI1LR8EM3EATOQ23+eKHCU4Mt
         aV4w8vN8/Vt8trCqPkg9NLGEyc5Agm1XUPdOtz2ROmD08vzObaxQiNSVZIyjhhR00weM
         Pq5Q==
X-Gm-Message-State: AOAM531aRxBrgKn/WqnaJrX9C1+1TUiWi8s6Yv7p5lFozIzUBxx2jr7l
        i1e6DUuI8nwLhaPSg/Gdc0XYAuJcbUE=
X-Google-Smtp-Source: ABdhPJwbg6i98NNEeEozGYRCNdfJgCf4ho8JVlJw1369W45u2CmjNYrxCXfVbhdeh5NfWmvRoVwZvg==
X-Received: by 2002:aa7:864d:0:b029:24b:dd03:edec with SMTP id a13-20020aa7864d0000b029024bdd03edecmr4355468pfo.18.1618192165971;
        Sun, 11 Apr 2021 18:49:25 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 11/12] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Mon, 12 Apr 2021 11:48:44 +1000
Message-Id: <20210412014845.1517916-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
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

