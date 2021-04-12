Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968DA35BB46
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 09:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhDLHvr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 03:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbhDLHvn (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 03:51:43 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F9BC06138C
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso1335453pjg.2
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pC2qTGFkzvLQ8Tsmx3DFzjSLzq6d0gV2ldbXa8KfI3o=;
        b=AbyIcyypbuGb893VtwcHH4GW4mNYJ0rw+CCpcSgzem2b0ox5V5grOsmX7+j46WF/6/
         cKlWDULFF6bMwDOiMK/ySOeeFYQMDxoIjqOLp7UcAjxupQpqwTHWHiodWMtvxgOvOV5D
         yZhA9EAkAXCKVcqhH0yQbYgxTAZcsjaM40KTZPwR6f/D/PmlvRFgr2ODf4jY0h0NDd9B
         Zw1thcKMfunT3qe8WPL/rtLnhF8aq/bqRkykVgYXJM9pwmgZimu+9qNk7l0DTToFMiLr
         tmSsaaahgyzNcjvqGpQfXdUap+0l3+Tfd2OFAnDUK/0f9EGEpOuxLs9Vrm8RsgW16wp3
         oxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pC2qTGFkzvLQ8Tsmx3DFzjSLzq6d0gV2ldbXa8KfI3o=;
        b=Oh5Eindh60zEza0HMlzgd2JcaYORZduuvGBfugqCGlqx99sYTEgcEhqmPRYShW0Rwv
         YjxRn21NWw8299oX49gvvIueRteVSGUlsr4SvHfo8MIi/vP4rnzTzrkn+3PruKkdO+ey
         bUEu5Hg08PXoXLXvfy51I0dQce058SlWUfrX9SwouqwSDAmQAWOqmdvCKjMSMIMkkuUe
         xkM2zWO/cjEaLnzvoM2CU74v9FM4q/U6F0Fw0kZ1RfJgrPYRW+XG6MCnLnBZg3bNTeRP
         CnBgyEMFG0ma7ZkWFJQ35aaXyoOJt6DqmpriN095DHG+JPsyjjFPIHIdUPdGg62mHzO5
         nYyw==
X-Gm-Message-State: AOAM532TjUThX1KD33gBtTz2yYwvoikAM6N/agMRvVoyl6+EVJyY66N5
        CS0C3tBQXa8x2KqE50ghIgHJdzYu8UI=
X-Google-Smtp-Source: ABdhPJzk7JEbzC296dYrf18x/stFpLXeoLLFvQVx5MiQTQ6GvmikhNrOKWDwp7mUvbIFmGtfsTPsJQ==
X-Received: by 2002:a17:903:189:b029:e5:d7c3:a264 with SMTP id z9-20020a1709030189b02900e5d7c3a264mr25290696plg.6.1618213885357;
        Mon, 12 Apr 2021 00:51:25 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id i18sm606180pfq.168.2021.04.12.00.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 00:51:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1 6/7] KVM: PPC: Book3S 64: move bad_host_intr check to HV handler
Date:   Mon, 12 Apr 2021 17:51:02 +1000
Message-Id: <20210412075103.1533302-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412075103.1533302-1-npiggin@gmail.com>
References: <20210412075103.1533302-1-npiggin@gmail.com>
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

