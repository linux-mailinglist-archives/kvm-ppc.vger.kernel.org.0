Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A303E351AB2
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhDASCp (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbhDAR53 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:57:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE53C0F26E8
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bt4so1294050pjb.5
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KWJaCRXIq7/feMmpom+ln/HtX2aZcvMttDNOU/B0+No=;
        b=Umdbyta1RELonlt70ju8XP8sL/vUMhFF5y9sWE5I40qlLI2pFzQfYXJaJTeMkKnJZa
         zRtC+0IZQPq0xsLlqOpjwRqaxef0tj0bj5mx9jPIwjc58WGXAvva2xU0M81AElBsEZ15
         URrTmbgyoAUSgSgEEQTmO+KFmvDn73vMV2uesxnyFGr6lneadiSEER+y2bwZvWY9tIYe
         Wi74Ap7Vp+V0hxG33bVTB/tB4JpXd9EafxeflciElfIdXSgCeaokBu8BSpNXGAiPvkkF
         kzdZ8AACiXvhyT5hF3wtEjWJ3D6qwhQqgoGkLsYLfLgwL7dpgkzh5Os7neFuOTCYhLNp
         CUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KWJaCRXIq7/feMmpom+ln/HtX2aZcvMttDNOU/B0+No=;
        b=l8S14uDGULo2LtbKfJXXEeGz2ol5J+SsDhiLcAaWwbdfqEjD8D0hUmL0aJgrILeGBK
         A8RONIzON0B+VAqnVDVt0qMwxZmR4tHXCV+o44MEdpDIXefjIU1cIR875gBK7a4tiDBd
         Suwp0gTETOoXDr37xe+7T+1twc3oEtVgLUo+isrA8Zm32IxnpNsiLlVH62rT66vFVm50
         lhShDoH3naj7RHAtykT5WcbC31FkMdDjCpQ6KKBpznV+sNNplNjwCF3rjhbERrFe9wQQ
         V7ghHI4E0wak3ycoxXM2whxr7MEG8kmL35LL5cbnltDa7tdGYRuS5D3s1MxLjVndmi9+
         lBFg==
X-Gm-Message-State: AOAM532vwRj+AXE9I0/M2Yqi6J5A6vl3uu7zUErv0csp9+apsEtiQnJr
        9b0RbZXsF+C/3aH96ryf7XilMQ3RqAQ=
X-Google-Smtp-Source: ABdhPJyN8FgVsBy5q3uMcMp0tflQ9HG38pSDHdkWWHprul9Y22oapM35QMWgQDLpCLQMwtzw0SzhCA==
X-Received: by 2002:a17:902:f686:b029:e5:de44:af60 with SMTP id l6-20020a170902f686b02900e5de44af60mr8411834plg.64.1617289470876;
        Thu, 01 Apr 2021 08:04:30 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v5 17/48] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Fri,  2 Apr 2021 01:02:54 +1000
Message-Id: <20210401150325.442125-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is not used by PR KVM.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S      | 4 ----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
 arch/powerpc/kvm/book3s_segment.S       | 3 +++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 30acbfbd1875..0791eb2e3b81 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -107,16 +107,12 @@ do_kvm_interrupt:
 	beq-	.Lmaybe_skip
 .Lno_skip:
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
-	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
-	beq	kvmppc_bad_host_intr
 #ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 	cmpwi	r9,KVM_GUEST_MODE_GUEST
-	ld	r9,HSTATE_SCRATCH2(r13)
 	beq	kvmppc_interrupt_pr
 #endif
 	b	kvmppc_interrupt_hv
 #else
-	ld	r9,HSTATE_SCRATCH2(r13)
 	b	kvmppc_interrupt_pr
 #endif
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index f976efb7e4a9..75405ef53238 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1265,6 +1265,7 @@ hdec_soon:
 kvmppc_interrupt_hv:
 	/*
 	 * Register contents:
+	 * R9		= HSTATE_IN_GUEST
 	 * R12		= (guest CR << 32) | interrupt vector
 	 * R13		= PACA
 	 * guest R12 saved in shadow VCPU SCRATCH0
@@ -1272,6 +1273,8 @@ kvmppc_interrupt_hv:
 	 * guest R9 saved in HSTATE_SCRATCH2
 	 */
 	/* We're now back in the host but in guest MMU context */
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
+	beq	kvmppc_bad_host_intr
 	li	r9, KVM_GUEST_MODE_HOST_HV
 	stb	r9, HSTATE_IN_GUEST(r13)
 
@@ -3272,7 +3275,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
  * cfar is saved in HSTATE_CFAR(r13)
  * ppr is saved in HSTATE_PPR(r13)
  */
-.global kvmppc_bad_host_intr
 kvmppc_bad_host_intr:
 	/*
 	 * Switch to the emergency stack, but start half-way down in
diff --git a/arch/powerpc/kvm/book3s_segment.S b/arch/powerpc/kvm/book3s_segment.S
index 1f492aa4c8d6..202046a83fc1 100644
--- a/arch/powerpc/kvm/book3s_segment.S
+++ b/arch/powerpc/kvm/book3s_segment.S
@@ -164,12 +164,15 @@ kvmppc_interrupt_pr:
 	/* 64-bit entry. Register usage at this point:
 	 *
 	 * SPRG_SCRATCH0   = guest R13
+	 * R9              = HSTATE_IN_GUEST
 	 * R12             = (guest CR << 32) | exit handler id
 	 * R13             = PACA
 	 * HSTATE.SCRATCH0 = guest R12
+	 * HSTATE.SCRATCH2 = guest R9
 	 */
 #ifdef CONFIG_PPC64
 	/* Match 32-bit entry */
+	ld	r9,HSTATE_SCRATCH2(r13)
 	rotldi	r12, r12, 32		  /* Flip R12 halves for stw */
 	stw	r12, HSTATE_SCRATCH1(r13) /* CR is now in the low half */
 	srdi	r12, r12, 32		  /* shift trap into low half */
-- 
2.23.0

