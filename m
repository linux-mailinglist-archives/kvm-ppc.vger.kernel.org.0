Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A39D30B59E
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBBDEz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhBBDEu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:50 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501AEC061788
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:38 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s15so11640489plr.9
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ye4rWrswKagx8tGr0mJPjZ2bjOD6zfWGQw0pHYQImY=;
        b=CEUyru6Qa/aGvIoSwUBAH62ICmV6uTUGryVz8jOGYxm5+AANyR5vWe/zUfJ4NVuRBY
         NxU5A4HpX+jydcf7KJz3yu9OJPw2eAwJ3FPcu3jxKb1AoMsZaNgWbUDZnuLmNj94W1fq
         20aRDN4sqkYggd7fAxgyjzG2woM2ToJe/BbbVBmKARR0v9Elp72I5OEiqBVI5DxsBdAC
         8mv8mo+1SBY20Aw4V7loI1qkKygf5tfrsKPXFq/HpGkJRVONH3F50hwsMpKKllYJic90
         1z0Ou9psp99zi7l+E3bOuiR6wsDm7lnVM7zvrbgeyeW1rd5RZ2MakG96J/Vh3gk52LNz
         u4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ye4rWrswKagx8tGr0mJPjZ2bjOD6zfWGQw0pHYQImY=;
        b=oKtn+KSy/jyZtLxYmM2X2fbXJW2mP5zPkdU+QLlYlqrva/8ywHWwe+b91Q/Hnk2IjR
         PZbHleWeZd3vFZEcRopFa0c6uYf3hRzbmDUtSmRl+mRNtj+At/WeFUNakkp/0PtVCNqG
         QSKtnBNi4tX9cPpfX1SLZYijNgURxnNehO6HXCcOJUip3M0UAZ97yjrP1ela3iVSiGmh
         8iI4N4i6gCPAD5GR/u7XZ3ZMBs4YhklxCBVw8O7io/WLb39aanz6oyKRRbjEpbyHM90l
         8+IzHnJx+3k+dI/g6+op9up14X/lTXJP0uzRHlvmLy0mPDv/N7LjIw8fuEGymTmPHDsC
         2F0A==
X-Gm-Message-State: AOAM532IT6pdUNHyFtKx01NoZYDiUy5FwOatG+E+AYVvDCQeLnguNkVm
        mlw6SQ7SCDQqKzN3Xkr+K2ztqmA7wkg=
X-Google-Smtp-Source: ABdhPJz3ZezmcrSIHmW3tiOEycfUi1fUcI3ESd3IsW/BTlLZBmhChsB9/iYxeUovadT4Hn1h0D2RHA==
X-Received: by 2002:a17:90a:9ac:: with SMTP id 41mr1969819pjo.136.1612235017666;
        Mon, 01 Feb 2021 19:03:37 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:37 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 5/9] powerpc/64s: Remove EXSLB interrupt save area
Date:   Tue,  2 Feb 2021 13:03:09 +1000
Message-Id: <20210202030313.3509446-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

SLB faults should not be taken while the PACA save areas are live, so
EXSLB is not be required.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/paca.h      | 3 +--
 arch/powerpc/kernel/asm-offsets.c    | 1 -
 arch/powerpc/kernel/exceptions-64s.S | 5 -----
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index 9454d29ff4b4..be0b00cb9fbb 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -108,8 +108,7 @@ struct paca_struct {
 	 */
 	/* used for most interrupts/exceptions */
 	u64 exgen[EX_SIZE] __attribute__((aligned(0x80)));
-	u64 exslb[EX_SIZE];	/* used for SLB/segment table misses
- 				 * on the linear mapping */
+
 	/* SLB related definitions */
 	u16 vmalloc_sllp;
 	u8 slb_cache_ptr;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 489a22cf1a92..51302fb74d14 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -255,7 +255,6 @@ int main(void)
 #endif /* CONFIG_PPC_MM_SLICES */
 	OFFSET(PACA_EXGEN, paca_struct, exgen);
 	OFFSET(PACA_EXMC, paca_struct, exmc);
-	OFFSET(PACA_EXSLB, paca_struct, exslb);
 	OFFSET(PACA_EXNMI, paca_struct, exnmi);
 #ifdef CONFIG_PPC_PSERIES
 	OFFSET(PACALPPACAPTR, paca_struct, lppaca_ptr);
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index e964ea5149e8..c893801eb1d5 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1412,13 +1412,9 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
  *   on user-handler data structures.
  *
  *   KVM: Same as 0x300, DSLB must test for KVM guest.
- *
- * A dedicated save area EXSLB is used (XXX: but it actually need not be
- * these days, we could use EXGEN).
  */
 INT_DEFINE_BEGIN(data_access_slb)
 	IVEC=0x380
-	IAREA=PACA_EXSLB
 	IRECONCILE=0
 	IDAR=1
 	IKVM_REAL=1
@@ -1507,7 +1503,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
  */
 INT_DEFINE_BEGIN(instruction_access_slb)
 	IVEC=0x480
-	IAREA=PACA_EXSLB
 	IRECONCILE=0
 	IISIDE=1
 	IDAR=1
-- 
2.23.0

