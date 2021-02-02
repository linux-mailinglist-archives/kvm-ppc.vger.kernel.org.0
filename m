Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105DE30B597
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhBBDE4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhBBDEx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:53 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40513C06178B
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:43 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id c132so13961537pga.3
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T2Cf0Dea5IVu8wyZcNFokAipIIQ+cvVbnC5vSCAngNg=;
        b=buJIVIpfFuqgrxAee8RQsZT4y7UQXj9NHK5s0INu0VdlKgxTqN8UzA1KWyJpCqLUqG
         dgEL9YzcDjmvr2BUoSRtOyP3U191ip8o1VD+Kkqj8ii8WFCYfYqtZ7/M5TT2Azfg5H2n
         vqHH+0VMyUj5WKgG93+TvkColwN9vinKHMNOvT+JO0lUpW7nSdCXoXko+FzO5a72yhAB
         AYBxF0igX+KGxGoxR+udkXa2BukpZutlRtr++hjvyWkF97tq5xto1bwoEi/d8ebFHg3L
         34cjrjW2hqJIOiQmGq0V633iDd12aM9DynPhHGPG4p/uWXSD9LIxNUs4kmMmL3CiJopM
         y8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T2Cf0Dea5IVu8wyZcNFokAipIIQ+cvVbnC5vSCAngNg=;
        b=jStIYrLM33I4vlrQvqa4cMGTk0M8Xk0j+MqggMIn909JAUvv+SC6Ufa/piY1LFILlf
         veunwkH1Rovfsa6R3DuZDQ8yRZztluTCxMFqlIYBhrBX9+7/b827tZqcjB7m2Es1C3ex
         lH9H1QhEZ1gsy6109HuCVq90D7xlLhljbbxUi/yl2vsEBXrFT+VobYYrbaHLmZ0/Sy6A
         LVwOqZXAqwINqiviYfBGXscDGnsIMkCcopSOdWAOo79pQu/hV5WWghoVV/zz17F/2hoi
         zO5vPxXMma+1Gr57n8IDlvhW+u+F+qiy8KHxzOWfJvtzDAuL2Rif00lKxOMH1fytWV5S
         HJNg==
X-Gm-Message-State: AOAM532oNMyLhXGaDk4a836SRhHmi/RPKZH//TLFvK0/OV82Blrg8E0P
        uNz3hw1xFMDenpdLTHVH/o8QmxZUxtc=
X-Google-Smtp-Source: ABdhPJyzr7S0bUxb0POQmg1pXJj1IkWSkMSEdIMKyfMiqyWGuZ/0bMWyT906VhQAKF1Ex1ewyV7PHA==
X-Received: by 2002:a65:5b47:: with SMTP id y7mr19646725pgr.221.1612235022648;
        Mon, 01 Feb 2021 19:03:42 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:42 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 7/9] KVM: PPC: Book3S HV: move bad_host_intr check to HV handler
Date:   Tue,  2 Feb 2021 13:03:11 +1000
Message-Id: <20210202030313.3509446-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
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
index 5db76c8d4012..0d9e1e55c24d 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -73,11 +73,8 @@ do_kvm_interrupt:
 	beq	maybe_skip
 no_skip:
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
index b9c4acd747f7..8144c1403203 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1251,6 +1251,7 @@ hdec_soon:
 kvmppc_interrupt_hv:
 	/*
 	 * Register contents:
+	 * R9		= HSTATE_IN_GUEST
 	 * R12		= (guest CR << 32) | interrupt vector
 	 * R13		= PACA
 	 * guest R12 saved in shadow VCPU SCRATCH0
@@ -1258,6 +1259,8 @@ kvmppc_interrupt_hv:
 	 * guest R9 saved in HSTATE_SCRATCH2
 	 */
 	/* We're now back in the host but in guest MMU context */
+	cmpwi	r9,KVM_GUEST_MODE_HOST_HV
+	beq	kvmppc_bad_host_intr
 	li	r9, KVM_GUEST_MODE_HOST_HV
 	stb	r9, HSTATE_IN_GUEST(r13)
 
@@ -3245,7 +3248,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
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

