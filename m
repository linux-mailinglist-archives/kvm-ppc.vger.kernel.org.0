Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7103250BA
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBYNs1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBYNs0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:26 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63BDC06178A
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:22 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t25so3819110pga.2
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OagdvsHRZnah4S5WUxjULUBGe/jVBE2xruZ6F/aPWm4=;
        b=eDa097mPBQ2HN5Wk6JrVBt8+mc8GSBtE/2ml74f0TmQVw5xhfZY3Do9HNUqn8rz7Oy
         FCWDL5OG79mQr9q8ho0/lM93W0xsPP9ZgXp6O4Z/67t3oSZVb8EVV/w+BbqcJzH1HOy0
         VL3c7uLbqzofxXGCv0Kqs0Ypq0OsHj9oAFRHbVOXDJDT04lI6enOnD0he1Y5nUXH0+zp
         Kzl6/6bHFyFcgzhzePL7UjpGWJY3YmNO0QSycY/Lh/kZNYWmc3WWI5nAax+gkmOiJFXz
         33pxbYlZyxz5v82Inqc8ig8xUAFVktR0KfPJfxzMcMF0peJG0YCezrnCIEnlkUgpbPi5
         8mFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OagdvsHRZnah4S5WUxjULUBGe/jVBE2xruZ6F/aPWm4=;
        b=N0EkXdy5R3KgjECMXXL32b5z9dWGRJ0kzRyboSOBz9ayQc80aP6WWzqC5OqDEotMYC
         KdPZmuyaOy8UU4LaWDs8sefpXSfl/z+0+f8LRkqQd0KV8dKECtQnR4Z6F3tP6Ndaz/68
         ZItlc7Yv9FvMbLUoC6P2hRGQfydv5iYJnq6YPFkgjxipQv87FRxl4WV3el15+IHv1oe4
         ZfgIeEhqq+R3ZlZmu8yBPbX1o7Et/+UzyJPtvTNMjI5zMcnl2wghkGw5yoWCVL20RJLN
         j6JCHoyQOjaEGnUcesHsz5LocFGOdn9xtb+c1bg1a+GcELRHxinVoP8TnWgBfOTuxbud
         iHDQ==
X-Gm-Message-State: AOAM532etgJflZwHyO64uw0HKocN53lPvtVpClD4hSISv1zKCn34MCI7
        2JCFLm4H3hv2HeHbJklkxpOZ01isYbE=
X-Google-Smtp-Source: ABdhPJy8fbq/xLrcGgmcY7flvo9j52FHjYt9Qm3IAbEWt0os+CsKbepaRJ5n9rqP6jX4L8W97RCXYw==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr2925019pgc.359.1614260841901;
        Thu, 25 Feb 2021 05:47:21 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:21 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 05/37] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Thu, 25 Feb 2021 23:46:20 +1000
Message-Id: <20210225134652.2127648-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR when the guest is entered, make
it clear that the hypervisor does not allow the guest to clear the bit.

The ME addition is kept in the code for now, but a future patch will
warn if it's not present.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 158d309b42a3..1ca484160636 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -662,6 +662,13 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
 void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
 {
+	/*
+	 * Guest must always run with machine check interrupt
+	 * enabled.
+	 */
+	if (!(msr & MSR_ME))
+		msr |= MSR_ME;
+
 	/*
 	 * Check for illegal transactional state bit combination
 	 * and if we find it, force the TS field to a safe state.
-- 
2.23.0

