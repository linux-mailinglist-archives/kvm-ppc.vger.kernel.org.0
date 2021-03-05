Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C914332EDC2
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCEPHJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhCEPGx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:06:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE310C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:06:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id g4so1559506pgj.0
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPv7vttF4qjq/q76q1ncSjpRj4ayfKA2hIREWD2yQso=;
        b=AAYgT6Y1yrTgHS4UjzaoiCGxMA5GRGdgy7eoodbELMyQTUoEL/WxY8srajk4Kf7Kee
         GgnOtmP/X2bC3VDn4jE9xEh1FzTyMinUCnO41tAyeWda4Wc5vZwH1AAw5Phx3YkN6Amk
         /dJW5O5Tv3p6nFSz63chb61bbq1OjU+Nb7ANz6EH+V0Ow3KRgwsLwMctiY0Ea00+NSUz
         SbFz8u7JyUO8T8OPi38vkQ7A5GmPneG0yc5fp1qxwg5tYqjpB0IWoK2OMVGfo4Zu2Zow
         KiiAxF73uM5SzzzVxWbaJKuzgWdxzHC3cpq9y2v0FJvdH4hBdX/7wekiY9PfQuAfcgMe
         9cow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPv7vttF4qjq/q76q1ncSjpRj4ayfKA2hIREWD2yQso=;
        b=BYibdkNjrQAVn5smMiwTPMiK4jBK1B6o2J4XEjMnytIUQ1ArWPLPgz0EA1tyJ42Yy/
         fHPm/0pP6lOLydfvogx3kuVuvfvh1dgUJ6v3VdLpEQJZX6wU2UaLQEOE0eQL75nfSfcl
         on1axJuYUdNmQntjLVcFDX92+FlOZ/ExQsugWHk131tD0PaH2mXeYDhxcvtUbd6XSaT1
         8uTObKrRplqSSnHxkgpZXhqPgvbun/wfa40XwL81hcQBWghVntoAyK4afVQiY6Uiad1m
         dfrWEhH09+ggpx8WzkXwJ4K/rTBvF7KCUsyhBTCF4GuoYn7Ae30gx/J1GiEMgzQXLzzn
         H+6g==
X-Gm-Message-State: AOAM532Lq/eBk9bvK/x9UxnyMbvNgl5ClHXyzNsLpk59g+RwjTUSk4K4
        YXadotbfDWPPL6mxwcEEkBL/BXkEnkk=
X-Google-Smtp-Source: ABdhPJz45DHinj6rvq2JLWECHgH3+iSKAQdU0pPPSgTP3QzvRJtiiNNIY9lv4Jv5Gy1Y+/BWBV1CVQ==
X-Received: by 2002:a05:6a00:886:b029:1ed:b546:6d1f with SMTP id q6-20020a056a000886b02901edb5466d1fmr9685346pfj.22.1614956812962;
        Fri, 05 Mar 2021 07:06:52 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:06:52 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 02/41] KVM: PPC: Book3S HV: Prevent radix guests from setting LPCR[TC]
Date:   Sat,  6 Mar 2021 01:05:59 +1000
Message-Id: <20210305150638.2675513-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This bit only applies to hash partitions.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c        | 6 ++++--
 arch/powerpc/kvm/book3s_hv_nested.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index c40eeb20be39..2e29b96ef775 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1666,10 +1666,12 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
 
 	/*
 	 * Userspace can only modify DPFD (default prefetch depth),
-	 * ILE (interrupt little-endian) and TC (translation control).
+	 * ILE (interrupt little-endian) and TC (translation control) if HPT.
 	 * On POWER8 and POWER9 userspace can also modify AIL (alt. interrupt loc.).
 	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC;
+	mask = LPCR_DPFD | LPCR_ILE;
+	if (!kvm_is_radix(kvm))
+		mask |= LPCR_TC;
 	if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
 		mask |= LPCR_AIL;
 		/* LPCR[AIL]=1/2 is disallowed */
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index b496079e02f7..0e6cf650cbfe 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -141,7 +141,7 @@ static void sanitise_hv_regs(struct kvm_vcpu *vcpu, struct hv_guest_state *hr)
 	 * Don't let L1 change LPCR bits for the L2 except these:
 	 * Keep this in sync with kvmppc_set_lpcr.
 	 */
-	mask = LPCR_DPFD | LPCR_ILE | LPCR_TC | LPCR_LD | LPCR_LPES | LPCR_MER;
+	mask = LPCR_DPFD | LPCR_ILE | LPCR_LD | LPCR_LPES | LPCR_MER;
 	/* LPCR[AIL]=1/2 is disallowed */
 	if ((hr->lpcr & LPCR_AIL) && (hr->lpcr & LPCR_AIL) != LPCR_AIL_3)
 		hr->lpcr &= ~LPCR_AIL;
-- 
2.23.0

