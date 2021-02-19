Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EBD31F52A
	for <lists+kvm-ppc@lfdr.de>; Fri, 19 Feb 2021 07:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBSGhR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Feb 2021 01:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBSGhR (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 19 Feb 2021 01:37:17 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7865C0617A7
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lw17so3909808pjb.0
        for <kvm-ppc@vger.kernel.org>; Thu, 18 Feb 2021 22:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=51fSnKE1F6582ktYAIsvzBpB1la/Rt8bTnqFIVhnkeU=;
        b=bHwu0aEiy3tvN/kzzUrvc//U0r+Xm9CvaZQP1I+TvjapG9j5IdgWh5AKxZHg2gzCBo
         zG8DeszMsdas1OTRuYExGKzXHWRsiIy2PrL0c2DhWS6kTnfwLk3tAb7Q6M4ic41pIWt8
         hFjGcQRxrbJzkBMUYjV7KBS/iooYlAHvyLcT4c2zR4j6fBYKP4w/exqy/TNXHj/jNfYY
         8xZLhVLGujmiiJfW0jNvPOZSYIVV1hq7bLb1WOtoYfNA01yv6hLe+GG5geCLf1WizIaN
         T+TnaBbJ8jdGIKz+kUDjfttLXNgUytuG8oNkHadmAg70s9aX3DzHQfl7UjNWqrMk8McN
         zPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=51fSnKE1F6582ktYAIsvzBpB1la/Rt8bTnqFIVhnkeU=;
        b=PSwxEPL1KfsJxOKW2lxOWWGL+Z4aYGzqmttRO00a1r6juR0npX1ZAA7oOiCxcfYJSv
         tXt+lX6FBMrCAGa45YKmnGc7KnisoYwJiFHZxNJLeYmflyKnpqLsd0qLqK+iHY/5QNaB
         3HlNCkJikUAKFnSktf5JCC1N3XdC+ccLyJCoSI655FjvBkYQVBHno93HGi2uD5L6hiWp
         B4PDonk8Hg6fz3pV4RaFVMlESC2QpKztQNhS3t82P/SXhdyXeMkuyO2xHlGOEY65ayej
         mhLQRuL4qXA6L0wGq2vlDjdBIiGGuytBvkipRdD9+4lsmNUvIM7NqBS4W/PMXVrJ9dok
         XM5A==
X-Gm-Message-State: AOAM533UiasRyM20olbMXjYedbwr63IqoBQdN+vbE0BI3k2ZhgSamKC5
        meieGzgFY2OrXJyYqGuX5QaX/JBAGko=
X-Google-Smtp-Source: ABdhPJy4bK8JS7XHnotZbYxFaM4Q4XkpTTIkvkK1riWDg4Iyh2+xqTuwOdTF8Df9tWAC2An/IAAQUA==
X-Received: by 2002:a17:902:860a:b029:e3:5d18:29af with SMTP id f10-20020a170902860ab02900e35d1829afmr7961113plo.64.1613716578962;
        Thu, 18 Feb 2021 22:36:18 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (14-201-150-91.tpgi.com.au. [14.201.150.91])
        by smtp.gmail.com with ESMTPSA id v16sm7813099pfu.76.2021.02.18.22.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 22:36:18 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 10/13] KVM: PPC: Book3S HV: move bad_host_intr check to HV handler
Date:   Fri, 19 Feb 2021 16:35:39 +1000
Message-Id: <20210219063542.1425130-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210219063542.1425130-1-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
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
index ef946e202773..6b2fda5dee38 100644
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
index bbf786a0c0d6..eff4437e381c 100644
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
 
@@ -3254,7 +3257,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_ASSIST)
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

