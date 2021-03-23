Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36A34547B
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhCWBET (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbhCWBEM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:12 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59CEC061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l1so10025511pgb.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2bUP4FUtzFKwI0jXFw1yCUnDtqI6ylC2E0n5jObkPIo=;
        b=Xs7s7Epj9+HO00xRfVMr8UMrcKKR+cxUb6lIjIqBba2O00TJreyJuhkhkNW5TPWqxe
         Yd27pbmnve+JrbTKAsqDPBgTgJN7AXmJS6ESqjGSL8opkEjm0/0bGLkWqzbm0F2xEu87
         W4IKpbwL0SsQ7bVOxr+zEQNOlM0KYjXPss3lArESnd8pUnmdmPrz4saEY3tczzniCs/B
         /F0M/aQ+i/ghXFqSle0lw9yHWlu46ouIwcFwJpT0xUaBy6rHZWGns8qtd5JgAkrbF0hV
         cLqrQqqTzxinrnUhQ1ImP7ZGs3oBmI4siSu51nj1Xk77IwS2lgX5ydAUO9+ubH9NvorR
         cFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2bUP4FUtzFKwI0jXFw1yCUnDtqI6ylC2E0n5jObkPIo=;
        b=lqrvFrdcNc1zCltYA+DXGnfqSxEL9CRcvtjGKKKnn99TAI+R8RK5JuUAoVNtu+v1cY
         Tg7Qq///0Wml2PhU8oaBpkxIRAVdAMxuwStjMOd0gCQBs9ZrGGlG3s6eLkIzSkCZBitB
         ZNAaSt/SmxV7jTjc9m40zPABcYZvnUNRcAc4pVBdDNE5ywpQVL9c3rbCr+Bn+5+b5I4t
         oibZcNZCE+EyAJ7mUgLrSe5vNrYQuFs90esJDbe3Bbydf01soNamruX2NjYtGGiZ2fcm
         E0jpkRdLBh2o5wMxADH8TNMkjqsINRf///o0675q41SbzXHNhjRcbsbsVkzmmlOPCq5V
         nx8g==
X-Gm-Message-State: AOAM531eAHqGpJqKyOo9DFppWTqz88jBZCe9Vn/M+4OjSWmywFzpZWEp
        8W31vUXMPSwg9rjKakI+FKj9pONLYoQ=
X-Google-Smtp-Source: ABdhPJxGrIk3tgHtzkYVTlenS22e07dMqllNkx93Hjcr20/xEIh7ptqupuI/DDp1gF+7FyW8f2VC5Q==
X-Received: by 2002:a63:5f0c:: with SMTP id t12mr1779832pgb.381.1616461451253;
        Mon, 22 Mar 2021 18:04:11 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v4 17/46] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Tue, 23 Mar 2021 11:02:36 +1000
Message-Id: <20210323010305.1045293-18-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is not used by PR KVM.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_64_entry.S      | 3 ---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 4 +++-
 arch/powerpc/kvm/book3s_segment.S       | 7 +++++++
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 642d5fdc641e..b6149df21de3 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -100,11 +100,8 @@ do_kvm_interrupt:
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

