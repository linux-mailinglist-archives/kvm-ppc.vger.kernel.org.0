Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967EB2F99E9
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Jan 2021 07:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbhARG3e (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 01:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732387AbhARG3F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 01:29:05 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE30CC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 15so10316307pgx.7
        for <kvm-ppc@vger.kernel.org>; Sun, 17 Jan 2021 22:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRPSJD7+yRSMbzMAVOs56nCLOyY7wHWQSU/LgGBests=;
        b=rl9X0ucm6tIBSec+46Ft4KEBHhkqpMquh7iVCDgAPJMoa7pGKmIxqCEKI5wvvd3Ble
         CCaFitk/Yu0thY6dyCLpjrKUGzrVnXT8uP+WjKxQpNI+uUnv4z38KoiV33D3nU8ohpwi
         ZLE3x7JeyeyfdAScWQYAcTrme0S9ieWjhd0UaTrxXI+qG7seVEYfGveXsbXWoVxG+LR3
         gC4aSI/ba8N5sQNHft/izB5A/SHuvvtTsVt1J37EirLue4tQ4eWwzCmQJVWygtd6u+7a
         tpiw7Oq+y81cCShU0E1kWgednaKiJ+La6D8gfqdQ2IKbWAwaVTiShaOdwZNdkeO7oTJl
         hoIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRPSJD7+yRSMbzMAVOs56nCLOyY7wHWQSU/LgGBests=;
        b=ZLNSvaEoWRxjNDKGxvy0Dz7FOCnGa4crHvTQT7KJwI4yZ/FxmGE2t+jwE8bUCEvMMw
         NAQWhcgJ1WxzUQTP2+dI28fRkujNdAjRCwwZwFdbscv5kWy3zkr0bDqGvVsLJ5S2NwK1
         vqAf6k1tE7NCknP3Z4Qb/8InMKxKTZ9lNw+l1XmrdxUZh4LRemjSiUuL+hIonU6bXOa3
         FtEaZyabBGcyxDh7KAIWsz2k0d1NwmKq0NcQXfEg0WNDjMwR9DHc3EStqv0D6Ic2dpO1
         chsHEcY8lMiAlOEt1Y8DXMpI8VtNL3VFOEiFwEvxnhEvh2W1qVH8xlCdY8LKQvP2iDFQ
         c+jQ==
X-Gm-Message-State: AOAM5333SKX3+eEXcnpS7o/IOLQU9eHUAJaGTM5dtc1ILL3kQNe5lyWs
        gxllncxMr41Zo0sPcl10DNLqpByLmi8=
X-Google-Smtp-Source: ABdhPJzuDgOZ1yOV4nFB/Vn8Xa8D/e1LZ/1qZseMeKA2f9bOopinPfG3A1rS5nGTvN/PrE25ucqKxA==
X-Received: by 2002:a63:1f54:: with SMTP id q20mr24665084pgm.135.1610951304259;
        Sun, 17 Jan 2021 22:28:24 -0800 (PST)
Received: from bobo.ibm.com ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id w25sm8502318pfg.103.2021.01.17.22.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 22:28:23 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/4] KVM: PPC: Book3S HV: No need to clear radix host SLB before loading guest
Date:   Mon, 18 Jan 2021 16:28:08 +1000
Message-Id: <20210118062809.1430920-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210118062809.1430920-1-npiggin@gmail.com>
References: <20210118062809.1430920-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 0e1f5bf168a1..9f0fdbae4b44 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -888,15 +888,19 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	cmpdi	r3, 512		/* 1 microsecond */
 	blt	hdec_soon
 
-	/* For hash guest, clear out and reload the SLB */
 	ld	r6, VCPU_KVM(r4)
 	lbz	r0, KVM_RADIX(r6)
 	cmpwi	r0, 0
 	bne	9f
+
+	/* For hash guest, clear out and reload the SLB */
+BEGIN_MMU_FTR_SECTION
+	/* Radix host won't have populated the SLB, so no need to clear */
 	li	r6, 0
 	slbmte	r6, r6
 	slbia
 	ptesync
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_TYPE_RADIX)
 
 	/* Load up guest SLB entries (N.B. slb_max will be 0 for radix) */
 	lwz	r5,VCPU_SLB_MAX(r4)
-- 
2.23.0

