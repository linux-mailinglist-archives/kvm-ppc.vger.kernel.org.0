Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFBE32EDCA
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhCEPHl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhCEPHP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:15 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFD4C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:15 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id s23so2209800pji.1
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XvUmT8dwL13269YYxdxnzVZ4ABcP2U76detfFQqFeVM=;
        b=Xv7V73kemdoPyDBu2UARrRC4OQvnQHmcJ9j6kh0frRowTctCI420YeTWOUDjOVF99I
         d2bwRxc0i6NUmkpbIRGnwUpItM5PBpzIEDiUOo2EwjMNjJBFmqfMT9eTp/dYFAp4hemm
         a+xo5VIrH5+MPwf2igac4knx9zpQg3aFnf1Jl38NCZdc67ZwtubrJE8wzjfCtbE5j31Y
         TgM4G4jReXN8u5c7diNzhnmoJuiGhj+iuOcr0EiGtD8gE3ZVFqkV93pUsCuDHvGh4n52
         u+KeCf5sSbw8qg6/7c6nlnlOyJhD7BOqj8/qkdmLsebzLrgw8Xil9sG28GyKGwIR4jXE
         2uCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XvUmT8dwL13269YYxdxnzVZ4ABcP2U76detfFQqFeVM=;
        b=n+IAtj05MI5dBogg2QXMkFTzjwmjkli+4r/VBE1/l99trII0HBoMrs1j4FqQTvRujR
         6bYUFhtieSQMGLcxa2McMIDxW2Ns9lyRIV6BnR9KdXeJHl6vH2DACP/sj8EOHh1lWwfv
         A3qJdIt3S2sGLVzbubCNx1WYNnKCICvCLSu/ZHVmJO4+9dMDr48hvH1qGYIe9hbPOZ7v
         7c4ZubS4TXehQcZBBGXWmMnLUcpxERRZYis7U04wuNIxvcVDDWjCAdHWDb9YUUacFyZT
         Gc+bGpGiwgEMYZzDf1UU51gMjMnRh7Bo6QjyYFwbQy7qxSHURqcYygPJ+RZZOorPuZDd
         PT7A==
X-Gm-Message-State: AOAM530qjIbID87QuD3s9dtaa1wpDWb6PPR2s1eW6FXhjqmrjWa8GrRD
        vPKUshRDJi2/v0pi35sTohBjfpAeKk0=
X-Google-Smtp-Source: ABdhPJztJBg5vturchwCfFqMhtteseIp6OdJYmM0grAxUt44rQ+GdwjjgZ6ZR6MUqRp5UCmoDlCAqw==
X-Received: by 2002:a17:90a:20c:: with SMTP id c12mr10626988pjc.224.1614956834977;
        Fri, 05 Mar 2021 07:07:14 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:14 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 08/41] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Sat,  6 Mar 2021 01:06:05 +1000
Message-Id: <20210305150638.2675513-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR when the guest is entered, make
it clear that the hypervisor does not allow the guest to clear the bit.

The ME addition is kept in the code for now, but a future patch will
warn if it's not present.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 158d309b42a3..5e199fd6769a 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,6 +662,12 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
+	/*
+	 * Guest must always run with machine check interrupt
+	 * enabled.
+	 */
+	msr |= MSR_ME;
+
 	/*
 	 * Check for illegal transactional state bit combination
 	 * and if we find it, force the TS field to a safe state.
-- 
2.23.0

