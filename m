Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3E22F99EB
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 07:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbhARGaD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 01:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732389AbhARG3H (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 01:29:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868E3C0613C1
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:27 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id e9so3921594plh.3
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UiAmv+Y6nRSowY9FUmRqMjFf96IEIuV+ew6LphQamhM=;
        b=N0eb0hKejT3cF5qk+iys/MlopNKWN6fTNAyXS5tzBZ9o6kiIOH7SPkQGqfW9G1jPEL
         XBsRMx/rbAIq2ZNtH6cx3VA2h94/5YnaJWhH6Ca1MHuPFGI+/4cBi+s9qvLAGwyc6pHW
         EGcXEAsku6Y8qx+sa6WxHS6uaxO/eVS747bLJ+33dx0Wkac69eeoVkhlEedBGDx3I/K2
         3E+Par39Phq9+NtG85LbR/IhzERxsjUQVW8CZkK7l3eWkN8kG9BThxj1rIMMqJIRuZiC
         HwbblkJfjCL9Uch6JzlJNmb+4EYlYNr2INLmKQK3A95xURwxPdW6/PL6nHzn3SpMRACa
         cvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UiAmv+Y6nRSowY9FUmRqMjFf96IEIuV+ew6LphQamhM=;
        b=s2j/aKfQkq2CNhxyg3OYrFPfhwykSjRZIR6K0Ousc0Fc8ikt4rGnKKCFiyjCNGf35+
         EMS/0j7OrRcwLrg8BRUMZelbYmYQ1p9h+76LdtBlJbaXBYHXivJ/+osLFUh16C3cT9Br
         KE+VnNadmPbaOuE/hEzp+zdBgwO28Aw5vlWdR/S3XeGq7y4mPFUehZh80uiSPQ+kwmy5
         Yq5/zhYNPghMYUoUTKsCQZopG5c5Po4X7Bvk92sydD4SsEPRLjJjom8DwJczF8Q4pxpq
         p2uGc8AXv8Jxnp+2Enk+24EceeqG5rMI3uUDTI3XxrPPK593P/UZxR8WYe8HQ7nuKhtq
         Gicg==
X-Gm-Message-State: AOAM532S21YL3o4KbmEPnbJOmoNpClp/hbcQICkmHflwkDFCV7iG4A3K
        Sdn3vvcu25lyWgcHLY0KCO2L4wngya8=
X-Google-Smtp-Source: ABdhPJy8axW3TJYhPYIy4ERbkxXXE2ScyvW18xHdn1mnhayeW21IiVY99Gm9u6CdAigBEAXn93qPRg==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr20972704pjb.62.1610951307059;
        Sun, 17 Jan 2021 22:28:27 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id w25sm8502318pfg.103.2021.01.17.22.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:28:26 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 4/4] KVM: PPC: Book3S HV: Use POWER9 SLBIA IH=6 variant to clear SLB
Date:   Mon, 18 Jan 2021 16:28:09 +1000
Message-Id: <20210118062809.1430920-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210118062809.1430920-1-npiggin@gmail.com>
References: <20210118062809.1430920-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

IH=6 may preserve hypervisor real-mode ERAT entries and is the
recommended SLBIA hint for switching partitions.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 9f0fdbae4b44..8cf1f69f442e 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -898,7 +898,7 @@ BEGIN_MMU_FTR_SECTION
 	/* Radix host won't have populated the SLB, so no need to clear */
 	li	r6, 0
 	slbmte	r6, r6
-	slbia
+	PPC_SLBIA(6)
 	ptesync
 END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 
@@ -1506,7 +1506,7 @@ guest_exit_cont:		/* r9 = vcpu, r12 = trap, r13 = paca */
 	/* Finally clear out the SLB */
 	li	r0,0
 	slbmte	r0,r0
-	slbia
+	PPC_SLBIA(6)
 	ptesync
 	stw	r5,VCPU_SLB_MAX(r9)
 
@@ -3329,7 +3329,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 
 	/* Clear hash and radix guest SLB, see guest_exit_short_path comment. */
 	slbmte	r0, r0
-	slbia
+	PPC_SLBIA(6)
 
 BEGIN_MMU_FTR_SECTION
 	b	4f
-- 
2.23.0

