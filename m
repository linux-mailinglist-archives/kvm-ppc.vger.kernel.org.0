Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B779393F6E
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhE1JKT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbhE1JJ4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:09:56 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E45C06138E
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:15 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m124so2023635pgm.13
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U/JcnlCtAMxSYUY04r4LfF3kj2cQw1ve9RclgS2qwxc=;
        b=bC/QtKAxSV1H++gR8WxPHc11T7Wqpw7qPzYLPGvxFgBORBWwmcyyL1UZEg8ys0BX1z
         nLYZiYSCnFXa3lC3A5RWPuQzjMb1BBPow8Mc4Z9TQJMGTDbyCY44JrPIqgzGZBSJoQfE
         tI8NgunWULBhvzE8tTMs0zJse5iSTFbYd9v2++IKsUcm8sctioGeo/1xMbReqPKv0pUT
         5Q2KA2webld35hhSOpmrt6OcrLGkjzCfdYUx8zdKH+vg4Yf6Z7hK3HSMMGnvMJ9SxPAe
         U2ys3JSpL3DRkqIHoh+3wepgtUHtp3lp8cvCbEP95QpEPPM4DeRGaCEi43DO2z4czO2T
         qNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/JcnlCtAMxSYUY04r4LfF3kj2cQw1ve9RclgS2qwxc=;
        b=Y4GlPBcr1ikas3s16gykyZP8IHrjcgxQ9cQHBvUe4Yqle9q9ufS830oPdnzE/zaYM0
         QaI4kXcTNHCQ191LwwNcuOSBwQ7ShdSN/hEm9Q/BK+lbMxxlXspN23xkUjryKbz07luS
         KBsrOxKgo2Y6XbqiQv98Pzi6EdAOOcurRcw3Z9l/SncJTlcnP4SwoVbOUkak0tVpymLI
         9CfvoYEL9N6tad4KkV75FaFTVjLvZVzuBC5syYxKgpH4MdeJF5oYTAerPRYXEK+eyB1E
         EAWhUmjE944le757Jy+ixjSP1b9w0nb3cAB+Fyk1c82EQaSA32YMJxh2zfW6IWNotawL
         bNOw==
X-Gm-Message-State: AOAM533gxaUHxU2FWXvpuek+VOLG53b3fd/ZsKgDYVhrEr92LJLFyaQJ
        0uIIC3OQmxKaDMVMIoSOpzwPKJwVrSs=
X-Google-Smtp-Source: ABdhPJwGkQSjdR7Ai4qg8hx4cdgmelH/SGRl/HxjzJgSqm9z1ywy52KQ7OdEKiS2jUkUSG8ze1tKPg==
X-Received: by 2002:a63:6387:: with SMTP id x129mr7921898pgb.58.1622192895003;
        Fri, 28 May 2021 02:08:15 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:14 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v7 06/32] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Fri, 28 May 2021 19:07:26 +1000
Message-Id: <20210528090752.3542186-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The bad_host_intr check will never be true with PR KVM, move
it to HV code.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S      | 4 ----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
 arch/powerpc/kvm/book3s_segment.S       | 3 +++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 2c9d106145e8..66170ea85bc2 100644
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
index a28b41b1bb38..a8abe79bcb99 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1268,6 +1268,7 @@ hdec_soon:
 kvmppc_interrupt_hv:
 	/*
 	 * Register contents:
+	 * R9		= HSTATE_IN_GUEST
 	 * R12		= (guest CR << 32) | interrupt vector
 	 * R13		= PACA
 	 * guest R12 saved in shadow VCPU SCRATCH0
@@ -1275,6 +1276,8 @@ kvmppc_interrupt_hv:
 	 * guest R9 saved in HSTATE_SCRATCH2
 	 */
 	/* We're now back in the host but in guest MMU context */
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
+	beq	kvmppc_bad_host_intr
 	li	r9, KVM_GUEST_MODE_HOST_HV
 	stb	r9, HSTATE_IN_GUEST(r13)
 
@@ -3279,7 +3282,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
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

