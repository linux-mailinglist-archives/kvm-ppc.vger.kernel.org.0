Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDF638DB28
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 May 2021 14:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhEWMWf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 May 2021 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhEWMWf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 23 May 2021 08:22:35 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2787C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 05:21:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e17so7957410pfl.5
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 05:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LoUOrEkcp1WK5rmcxwsPUplBY6Kp7GqBB43eiXJMlg=;
        b=Yseywgl2rlML6LAYrKrgqhT9SYnPIoMW1d7YuNcjDhvBYkzHW1KtkKFBIk66nOj3oP
         bR2Jc1uetBvjBzzkG6a6Q4hn0U1mJnVU31m4zsiVL++r+9ZTNs1A+5Y82ThbRnkfJOKO
         ElkhoJoemCrgxpfZl34hTdg1U96n/MrkF7zIGdmnD4NlfP5V1CE2OmFibWo6e5OU5z3L
         ybDLDldN0kqlutqLrbmFVZqClM6moTbf4kFKpdF2l6wp56eHXvRPdaveRMNQtm/Udrru
         sj8Lc2bXlyWB8Y6DUBDIKF31kbUrk0jS4anzuMlqcGi7cabHNif+E5ZcSh/rw+jUXfMl
         lboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LoUOrEkcp1WK5rmcxwsPUplBY6Kp7GqBB43eiXJMlg=;
        b=YCQk5+UNUEuoPDiwCudglCIm19iaap+GqjHrKxzvlgNmpI0Lu6XrfiCQpS4/JHElzs
         0JlwZXHCi2xtotpfmC/qBka4LqmalkZpvNvWfsFt8xGbUPsRS8IpXrGCqZ5/ROIdfbbs
         pX4bLNyrEusJsvpIcxLb3l63NOR/iMWj/xi1Dsshr5yCU+3JYQCezBiomh9NBjzqZd/j
         yqqVhML6YsE3FtEE/TfSfWFYqMD4n4jAahi5EOq/ZQkSVoRi5uqAQ725Rne2leekja3n
         tXKlWs+7pS+joqSiuq/elZSdAiwHUGGSXcHvCZpiNH1Wt18B0U/g85L37c4IQa9QhVGY
         xw1Q==
X-Gm-Message-State: AOAM532/9e2Nf1umPtDTATGjzLSpyuAhQi6tXqxdVyGN1IXYaTPvrSBv
        7E5TMfQrvMgBp5SjCq3TExNpmd3Ra1bWPQ==
X-Google-Smtp-Source: ABdhPJwbP3GQmJLVnH783Xild7/zhg9XT1WRhcUQnpxJi1rzfzFZ5YXkDZY5jf57utEj+xukplv5Yg==
X-Received: by 2002:a63:5d18:: with SMTP id r24mr8583820pgb.94.1621772468237;
        Sun, 23 May 2021 05:21:08 -0700 (PDT)
Received: from bobo.ibm.com ([210.185.78.224])
        by smtp.gmail.com with ESMTPSA id j3sm8834663pfe.98.2021.05.23.05.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 05:21:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Neuling <mikey@neuling.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
Date:   Sun, 23 May 2021 22:21:01 +1000
Message-Id: <20210523122101.3247232-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
FSCR. The logic explained in that patch actually applies there to the
old path well: a context switch can be made before kvmppc_vcpu_run_hv
restores the host FSCR and returns.

Fixes: b005255e12a3 ("KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5e634db4809b..2b98e710c7a1 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -44,7 +44,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define NAPPING_UNSPLIT	3
 
 /* Stack frame offsets for kvmppc_hv_entry */
-#define SFS			208
+#define SFS			216
 #define STACK_SLOT_TRAP		(SFS-4)
 #define STACK_SLOT_SHORT_PATH	(SFS-8)
 #define STACK_SLOT_TID		(SFS-16)
@@ -59,8 +59,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_UAMOR	(SFS-88)
 #define STACK_SLOT_DAWR1	(SFS-96)
 #define STACK_SLOT_DAWRX1	(SFS-104)
+#define STACK_SLOT_FSCR		(SFS-112)
 /* the following is used by the P9 short path */
-#define STACK_SLOT_NVGPRS	(SFS-152)	/* 18 gprs */
+#define STACK_SLOT_NVGPRS	(SFS-160)	/* 18 gprs */
 
 /*
  * Call kvmppc_hv_entry in real mode.
@@ -686,6 +687,8 @@ BEGIN_FTR_SECTION
 	std	r6, STACK_SLOT_DAWR0(r1)
 	std	r7, STACK_SLOT_DAWRX0(r1)
 	std	r8, STACK_SLOT_IAMR(r1)
+	mfspr	r5, SPRN_FSCR
+	std	r5, STACK_SLOT_FSCR(r1)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 BEGIN_FTR_SECTION
 	mfspr	r6, SPRN_DAWR1
@@ -1663,6 +1666,10 @@ FTR_SECTION_ELSE
 	ld	r7, STACK_SLOT_HFSCR(r1)
 	mtspr	SPRN_HFSCR, r7
 ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
+BEGIN_FTR_SECTION
+	ld	r5, STACK_SLOT_FSCR(r1)
+	mtspr	SPRN_FSCR, r5
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	/*
 	 * Restore various registers to 0, where non-zero values
 	 * set by the guest could disrupt the host.
-- 
2.23.0

