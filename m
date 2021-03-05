Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999CD32EDD0
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCEPHn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhCEPHh (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:37 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B14C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:37 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s23so2210518pji.1
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qnuaLhIvNcDxadP1R7sRfbSj2oFquRN2q7dVwGfsUQo=;
        b=MlV0VC9awhEghGdvTuvWZ7waltwW9Bxwk3TuJg9J/0UPkODvqa7M49O7ybdElT/VDv
         i/20+QGEJFOsJ5V+OmBmUCJhMc2saCZTDC5IAbxK1irk+eQTC4gVTHQkUhDNR1T5BhJY
         Eb4Flg0YTslNJcnTNqfVNx2SgnRAVp8Bf7OD5uKCFhgq9YT3Sn/mu7LtgGOb/74aRgGz
         faUqpvIKZQntx4T2BypPudEhdzgUKsqLCJi5JV0WjvwFiJp//0MVG/QIFmrhWl74Qgnc
         CyUv4wByHiCIyeN3PMrZ5oOxsztVHpmcb6kzmZE8iD6odKK/dhPTMZvg6191ykHxV+Is
         qnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnuaLhIvNcDxadP1R7sRfbSj2oFquRN2q7dVwGfsUQo=;
        b=P2yjesO1DJreDVxt4VLqpD+t4eGeFEu73Bhjb76v9r8XOy+sjBy3WGN8eeOHuF17HH
         ZqYa/s/A+RbECFGg+CFE4DuoLT58BnsuMusKaAaGz+dgdfB7goLxyBomQ/4pdaJbz3+Q
         nFIcFc8lcd+BGtwR1e7EK3+TcMP8E4eGAtSe4eEf7cqEPsqJUHXvuKGP3EzxBAf7Xfta
         SNyxt9RzaqA0EaMD7h8ZjmwUBh5lRrBcT0wDDn4FngPlOd6WfatGRgLTiMSHhuTwxQuj
         7MkXB88UiJqcymiWxSioAz0ukCTNrhyTKFzxIezd1Dk8IJ7OcEI+zNXBw0HJxlQ32q2Z
         PsiA==
X-Gm-Message-State: AOAM5310Z6VdCcafJSBjU1zCC0rCwF4ZuH5rAD5pcEYhjKfJBL/K0ojn
        uwJ98DtTahh4CaQp5cacKgxmQ0NsVyE=
X-Google-Smtp-Source: ABdhPJwwgp2YdT1G8jH8Kzj19k+oQiNlUhzNIs918oBxcS/LzQi3EMUTWzJEUCVFn1MXapgcTpBkFw==
X-Received: by 2002:a17:90a:bd09:: with SMTP id y9mr6239209pjr.179.1614956856535;
        Fri, 05 Mar 2021 07:07:36 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:35 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 14/41] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Sat,  6 Mar 2021 01:06:11 +1000
Message-Id: <20210305150638.2675513-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index d06e81842368..7a6b060ceed8 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -78,11 +78,8 @@ do_kvm_interrupt:
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

