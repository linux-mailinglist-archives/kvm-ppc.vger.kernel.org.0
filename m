Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2432EDBD
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEPHJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCEPGv (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:06:51 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153D2C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:06:51 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g20so1561268plo.2
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6LjsSzloyP6z/8C+JC71MAftuB7rIwr5/ezBY3FEAA=;
        b=bBHZ5bdetqHKoLGHXwk5nGk4F7R+OhyhV51ewZ7VQBoiTgnCsgufNA1cog9CHcN7y0
         hAl8xLa2HhwKS4WWbbLzyNLxEfwslhiOFyl8jmpEUCw4uZ1JtIarkpKmqiiffjl6Q4V8
         hJAlVuLfOXLzch9toNlWB11D77YjOwLIPLgdacpqXXCvzASTEoheXvLJPCLEN9S7V44A
         E3vQDplF/zXZJuJKeDbllzCtAijcV1kQEtW2YINNWMxIfGNVCVZkTuSgjtchR+E2ERSm
         wJW12hDNa5qyW3sorvLpsoZVAy58yypVq406R5U3b9oH2oX+C79DcDI4n2cBSXeTIcnM
         YZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6LjsSzloyP6z/8C+JC71MAftuB7rIwr5/ezBY3FEAA=;
        b=oEWMTjfPY62zzmXQq7VAs6s4eLcsSB5rgh0seBVRla+76WH/AVkqGEANHX5RQQCr7Z
         s5WZIKGIU0j2vaQavSVjIwbdRtN6bb60WAsTIIh+la5gLuHXOkbjOENx9npuKlOZL5Id
         rgSsHl+qWH+RZ/LLRBeWUQwjNOZAKuCtz8hUN5+7djIsxhPmqJwcnJ16HrITqkz6cFp5
         DDdYcm2HRprwO6Vn8rxVTMwCcyDefnw5m7WcMxWy+M9piTi1PD1man7rYF/r4FF9zCBq
         pwuqvPbnW1YKURDXh0PDwerG9Qvy5KRAApb1ZsA9WEIswR9Hujb4aJDnq5EVeFPfQw/5
         onog==
X-Gm-Message-State: AOAM530ujbIWrIJoA8NVsziL7r9+aNSdohCStHM/EDx61w7m3j3kOOfS
        miOqEu60auvMMT38Ree+G8RUKGAYrJ0=
X-Google-Smtp-Source: ABdhPJwN+h/R4bLaPqc/UWsl1EiPxqyJekNsCGj5Fk7zO+S2lov69pBNg4vIRMOIvbDKb6drJisY8g==
X-Received: by 2002:a17:902:7404:b029:e4:503b:f83d with SMTP id g4-20020a1709027404b02900e4503bf83dmr8938425pll.35.1614956809753;
        Fri, 05 Mar 2021 07:06:49 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:06:49 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 01/41] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
Date:   Sat,  6 Mar 2021 01:05:58 +1000
Message-Id: <20210305150638.2675513-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

These are already disallowed by H_SET_MODE from the guest, also disallow
these by updating LPCR directly.

AIL modes can affect the host interrupt behaviour while the guest LPCR
value is set, so filter it here too.

Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c        | 11 +++++++++--
 arch/powerpc/kvm/book3s_hv_nested.c |  7 +++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..c40eeb20be39 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -803,7 +803,10 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
 		vcpu->arch.dawrx1 = value2;
 		return H_SUCCESS;
 	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
-		/* KVM does not support mflags=2 (AIL=2) */
+		/*
+		 * KVM does not support mflags=2 (AIL=2) and AIL=1 is reserved.
+		 * Keep this in synch with kvmppc_set_lpcr.
+		 */
 		if (mflags != 0 && mflags != 3)
 			return H_UNSUPPORTED_FLAG_START;
 		return H_TOO_HARD;
@@ -1667,8 +1670,12 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 	 * On POWER8 and POWER9 userspace can also modify AIL (alt. interrupt loc.).
 	 */
 	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC;
-	if (cpu_has_feature(CPU_FTR_ARCH_207S))
+	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
 		mask |= LPCR_AIL;
+		/* LPCR[AIL]=1/2 is disallowed */
+		if ((new_lpcr & LPCR_AIL) && (new_lpcr & LPCR_AIL) != LPCR_AIL_3)
+			new_lpcr &= ~LPCR_AIL;
+	}
 	/*
 	 * On POWER9, allow userspace to enable large decrementer for the
 	 * guest, whether or not the host has it enabled.
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 2fe1fea4c934..b496079e02f7 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -139,9 +139,12 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 
 	/*
 	 * Don't let L1 change LPCR bits for the L2 except these:
+	 * Keep this in sync with kvmppc_set_lpcr.
 	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_AIL | LPCR_LD |
-		LPCR_LPES | LPCR_MER;
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_LD | LPCR_LPES | LPCR_MER;
+	/* LPCR[AIL]=1/2 is disallowed */
+	if ((hr->lpcr & LPCR_AIL) && (hr->lpcr & LPCR_AIL) != LPCR_AIL_3)
+		hr->lpcr &= ~LPCR_AIL;
 	hr->lpcr = (vc->lpcr & ~mask) | (hr->lpcr & mask);
 
 	/*
-- 
2.23.0

