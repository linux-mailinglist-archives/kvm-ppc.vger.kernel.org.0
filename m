Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410A13250C3
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhBYNsj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhBYNsh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114A0C0617A7
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:43 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t5so5068339pjd.0
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/KksQ3NoTja4HR9q6bStGFmmuukVXyNVWmRp3h0EkF4=;
        b=oN/KqaNurMawdiWHffSoWaWasXoxM0KkFY2RzTaxl0tQoQsqV/XKeu55fOlkpLafvq
         t1Kr+vg5b5tMjNHBUS6hAqlABB+hpOdvinrTNUj1jVZU6qMH/vPag8Pgpz/ketWram/X
         H+89HwZUmYDpJFzxSl4bWIVDj/hNlgvRvnCEvYhAF+NIkcLlRuhLyIvJuhWvUa8YNbq2
         MBsJmkCVtJC+QDaFvKmeGy85V0MPI+xjM2M1tFluyakhZbYw4bz5HyuNN8rI+izRGFEm
         jgBfKLhcvs4h35DPgAQ90PhKNKIj0jBHPVC+r6TjoPfm0kfRTZOWfZ7hKLW/uccnFG4u
         m6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/KksQ3NoTja4HR9q6bStGFmmuukVXyNVWmRp3h0EkF4=;
        b=XQrKXWY+eVy9r+SdDypCGR9vG4F7FCxI0/LJ92iQjCROMlNb6lX3vKpIjsl+7evkyp
         fWPFLuILYF2WqQRGpJmK35okBSQNDtxYhvnk8liOfMqS8qNlUjqwb2cOC7Ya1S6nCx9R
         OEb4ihSFFhMupEihHcF0UHNAqB9mZT42EtxlVWLPLtsQ2sRZ79dI5YNxjKEl4NtMey7/
         IH8T/+3ZjuI0UbZomT630SW9jXkzV0p1a87u87VbAh4mrXAkEv1aBWRvBlNvafaN3tVc
         n6Hxyo9IEXxpE/F7YpjQywJ4tOVwj5LXFgqdEY2FSBV1jI5ddlA+M7uBXaH6CBlFkgS/
         JhqA==
X-Gm-Message-State: AOAM531qibpJI49VtRBkmaf5iToLbCOCBhFoFULaoKfePu2kuNBhdHxl
        74AxIO1YOMHgaxC1Dt/GS15FQFGfX8U=
X-Google-Smtp-Source: ABdhPJylqeBoTtCQhFBwmeRqFOcRawDo/ooewyuCSswjXpp1ZIYz5XY+O9HoV7jNNDlAzLZFqxoX5g==
X-Received: by 2002:a17:90a:b782:: with SMTP id m2mr3378164pjr.220.1614260862150;
        Thu, 25 Feb 2021 05:47:42 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:41 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 11/37] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Thu, 25 Feb 2021 23:46:26 +1000
Message-Id: <20210225134652.2127648-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is not used by PR KVM.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S      | 3 ---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
 arch/powerpc/kvm/book3s_segment.S       | 7 +++++++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 4603c0709ae3..75accb1321c9 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -77,11 +77,8 @@ do_kvm_interrupt:
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
index 1f492aa4c8d6..ef1d88b869bf 100644
--- a/arch/powerpc/kvm/book3s_segment.S
+++ b/arch/powerpc/kvm/book3s_segment.S
@@ -167,8 +167,15 @@ kvmppc_interrupt_pr:
 	 * R12             = (guest CR << 32) | exit handler id
 	 * R13             = PACA
 	 * HSTATE.SCRATCH0 = guest R12
+	 *
+	 * If HV is possible, additionally:
+	 * R9              = HSTATE_IN_GUEST
+	 * HSTATE.SCRATCH2 = guest R9
 	 */
 #ifdef CONFIG_PPC64
+#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
+	ld	r9,HSTATE_SCRATCH2(r13)
+#endif
 	/* Match 32-bit entry */
 	rotldi	r12, r12, 32		  /* Flip R12 halves for stw */
 	stw	r12, HSTATE_SCRATCH1(r13) /* CR is now in the low half */
-- 
2.23.0

