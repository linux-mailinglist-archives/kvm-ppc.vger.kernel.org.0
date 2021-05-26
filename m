Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602D6391839
	for <lists+kvm-ppc@lfdr.de>; Wed, 26 May 2021 14:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhEZNAf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 26 May 2021 09:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbhEZNAe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 26 May 2021 09:00:34 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0018C061574
        for <kvm-ppc@vger.kernel.org>; Wed, 26 May 2021 05:59:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso311436pji.0
        for <kvm-ppc@vger.kernel.org>; Wed, 26 May 2021 05:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxiCQ/dRV0Krfx+r0SoICDlOrL4kF9ou2YVb/r4kcAg=;
        b=Qi4KZV+Fz1jfZwmQQLjz7Y9pTXAWcB4Nhpbi8tMbkb6Bzf0IV5ZhhaKgJWsbPPqr63
         JVt4FW7AfN6fg59WAJ1sHHG2krzZwsM7VGfeiPKHo/GQB6ET+uYvuqb99TSASm8nDYqO
         wwTdClSGlH1/+55PQ5dOcB2bRS7n3P/wJInBz34URqpqYkY6qsiBz5xmXIgdtHdFNuWe
         A+p6wFFanHVsFWUmbzIHo2r7L9agnkX2k7ZH4/sN/W3uLF1GQzQu83IE3ULaEZ6QRrZ+
         6A1YSvTGWsIZHQGF6zvAesxYVgk/sKzBbkjgKl4QAiZd40Amvuvimckrp2T8m3rwpZrU
         X6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxiCQ/dRV0Krfx+r0SoICDlOrL4kF9ou2YVb/r4kcAg=;
        b=NkQnATXHspjREcU7xeH8l1Xl0CKYHl1B1oVwMw9epFr3WZryDfJnn7rB3mvrHf9HRW
         JA65o7SX2Y7MiBq+Tc55bCTXZ6KgdMkMxsZWCyogYihbWnMTRK5550259o8hmZJc6Ek5
         EIRBE/i8ayRcKyOPPUVgyAdG/BGxKXMBg4LP5GOv84fSP8t3Clw/to/t6CdXGwY2YaLI
         K7fA6dD9bHgp4zVzUgixmnJdjoc+zBb/SLamTpldIHMZbUs+zRCqXTp5OxF2/3psbtvU
         AQi5pGhczSz6WfvuPQpAcYqAF4SDemG+5yjV7pRty+BtAiFAuCfCr6Cj6WQyDZSSO/8D
         lkDA==
X-Gm-Message-State: AOAM5314bfDbhOMrZwaaRAJiWS4vekv6s74WNkPqUgA82ASajJHQFYVQ
        oR4h37TGqdEniOOfb+fsQy9P9eE0aGM=
X-Google-Smtp-Source: ABdhPJz0fzfxG6UiWQFqptNQ7oK7usGFx8c4WW0LrwbKAvBiW4ou/lDvYpmuH4Uv2LyAc9VyNxj6tA==
X-Received: by 2002:a17:90a:3948:: with SMTP id n8mr36896088pjf.32.1622033941300;
        Wed, 26 May 2021 05:59:01 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id e6sm4364773pjt.1.2021.05.26.05.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:59:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
Date:   Wed, 26 May 2021 22:58:51 +1000
Message-Id: <20210526125851.3436735-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
FSCR. The logic explained in that patch actually applies there to the
old path well: a context switch can be made before kvmppc_vcpu_run_hv
restores the host FSCR and returns.

Now both the p9 and the p7/8 paths now save and restore their FSCR, it
no longer needs to be restored at the end of kvmppc_vcpu_run_hv

Fixes: b005255e12a3 ("KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v1:
- Remove the now unnecessary FSCR restore at vcpu_run exit [Fabiano]
 arch/powerpc/kvm/book3s_hv.c            | 1 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d240b76..13728495ac66 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4455,7 +4455,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		mtspr(SPRN_EBBRR, ebb_regs[1]);
 		mtspr(SPRN_BESCR, ebb_regs[2]);
 		mtspr(SPRN_TAR, user_tar);
-		mtspr(SPRN_FSCR, current->thread.fscr);
 	}
 	mtspr(SPRN_VRSAVE, user_vrsave);
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5e634db4809b..004f0d4e665f 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -59,6 +59,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_UAMOR	(SFS-88)
 #define STACK_SLOT_DAWR1	(SFS-96)
 #define STACK_SLOT_DAWRX1	(SFS-104)
+#define STACK_SLOT_FSCR		(SFS-112)
 /* the following is used by the P9 short path */
 #define STACK_SLOT_NVGPRS	(SFS-152)	/* 18 gprs */
 
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

