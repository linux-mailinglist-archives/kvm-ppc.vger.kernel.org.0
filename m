Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D1F31F51C
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSGgk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhBSGgj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:36:39 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84AEC061788
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:59 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p21so3028606pgl.12
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZhKElMmAcxWKYLVW6gD2OsH4YAnkNF8CvR9dzFQpDY=;
        b=Awp7d0SzPgQ6XK5hl6dIzWewPmyPCyCOOYqfEnzVJh5aAiuWfrKaht8+jsNmKZpPXj
         1Q8RpGrWb2jAusPRuw4j8ugExyWeSnLAsKXvQCgFa0npjAB50qUmfABVGe0ZsqCteNaW
         VdVBjlEAZ1x2oUsY7/7IB+XIbK3Sqf2k522XQ1sZHyuEHGwkEw3mIpIwdPQSEP+fEs3a
         55zOecmfvNEDVeEw436tj1tafCGAMyuuR+JWRDh7pmYTcmgF+FvDM6f11jmuZR8fOZy8
         ymiK9i54fl7prn41OP5QHhjKD+MkIVABT10VOONITAlLg77CMq0frTLKi4NWVHTRzRjV
         jtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZhKElMmAcxWKYLVW6gD2OsH4YAnkNF8CvR9dzFQpDY=;
        b=ZZbhldkfrR8PBf+UeEi5wlGjX29Wwznn449XIwDQAmWfflgYsCZxGTm84qr5Onfbru
         ywl3cD2EpVMGl/l4OX8QdtGBjfqjjzvgHpca4V4ylAuPFkS6GwGhMk945r4JUU16jSiw
         bSmqc8MfJVXC2l3nE3h14SSWaEJ53LofK+5vQhVVupqyEPFf94ep2/fvWqxjTY4EbV6b
         Ibeqit8nbmxURIpkdQuUGoEN2gBdFdF7SX0t0qj2+m4/bfJmcA9HP+XK7/7iCXLMXCEh
         FGWFyksaiF+ttpdhG6XngBleq1oRMgVfIKCvJgkmg+ZIZigja9E2iHNm0bbra3eHxJRp
         JsIw==
X-Gm-Message-State: AOAM530RHHnsozpSJ2rAOCIrlZ29+oNWuzoCA+Fs00aA4FrRRFqgUHrb
        B76yO0/RGGlwhrL2JCX64sir4Z4XCIo=
X-Google-Smtp-Source: ABdhPJz4aYnevNUuieq8Zho6aComunXfjgCrXGaoUj2A1QT9k8k2kQz8VCpjG4hC7hDEunbibjCnng==
X-Received: by 2002:a63:510:: with SMTP id 16mr7162825pgf.42.1613716558890;
        Thu, 18 Feb 2021 22:35:58 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:35:58 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 03/13] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
Date:   Fri, 19 Feb 2021 16:35:32 +1000
Message-Id: <20210219063542.1425130-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than add the ME bit to the MSR when the guest is entered, make
it clear that the hypervisor does not allow the guest to clear the bit.

The ME addition is kept in the code for now, but a future patch will
warn if it's not present.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_builtin.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index dad118760a4e..ae8f291c5c48 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -661,6 +661,13 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
 
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

