Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9A351BB1
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhDASKs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 14:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236613AbhDASCp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 14:02:45 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7147BC0F26E4
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:04:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h8so1156005plt.7
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zOAiamWMgrw1baxcdY0dJUnntq33efqmQWLjD5VB7U8=;
        b=kiujaPtad+vbuFz+4WCu8NH6R9+hfpqBlKdQcrt5E6okV6KDpl5zswH/wgWWW+I0rK
         iheXOMibKHJHj+WClY0StMVFFcJaYhspvyMZuDO22hdoVcafptI4L2WpveoL/lsAwmpB
         a30MhoGQnT39OWC/XuaCBvbcZEqSjRt1W5/kz/kWZrt0TnFw+EzFjPmXtUemMUXylmjR
         LSN34VnrKPZ5ziWHLMhM7JPHHmKM6maF8epojPMYvFJMu28E1328p4L+mOrs8AdwqmnJ
         pYNeafUpSkTR8vYUkfrj5bQrh0hZTZ6TkmPVSPKoqbT9YG8HAZzoiDcO/2YIxKAdxrDv
         s14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zOAiamWMgrw1baxcdY0dJUnntq33efqmQWLjD5VB7U8=;
        b=IKhpJf1tA/04o6HhfoBYLQ94iGkYKnBB3NxBP757enYvUyqtZN+lxF7fzszrC7UE81
         ydNOhonv+zCGyVS3DYWM00yQk+x+4kDtFqPMe1MUD3s14vYO3C/PxAsjWhLUvFpW0qyD
         UKba8hh7U15hem8Qu+rhU9Hw4B9/T37LTk+UM37AyeOcjEufAwKD0B09rPG2DwndoY93
         pnycq6befAt9qJF5EVY+zJY93HcYVF9E7MI1+Aip3tJHX0eVzRIDq9Z3fScmuXIAhxIL
         2GW6VupKztKCy5DXit0RHF7SCfxmQkfl8TM0rGNcO0/SKqKzGVzTD2XEOKIf+1w4B+8w
         6H8Q==
X-Gm-Message-State: AOAM531IyRZB+IgIGc0u0V1kXOGy+AbqqempVLjycFvcHaTxpwF5vMsw
        o75DokTSNp+6Bg000trROagE9wlZ1s0=
X-Google-Smtp-Source: ABdhPJzg0JwHkpM7ONiumdAw8sjYpPghiZlF7UrseW2F1hrxg3nHi3cwqrcnxdxmXLk+2c5PverHvA==
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr9448344pjr.228.1617289462955;
        Thu, 01 Apr 2021 08:04:22 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:04:22 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v5 14/48] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Fri,  2 Apr 2021 01:02:51 +1000
Message-Id: <20210401150325.442125-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a separate hcall entry point. This can be used to deal with the
different calling convention.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 6 +++---
 arch/powerpc/kvm/book3s_64_entry.S   | 6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 16fbfde960e7..98bf73df0f57 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1989,16 +1989,16 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	ori	r12,r12,0xc00
 #ifdef CONFIG_RELOCATABLE
 	/*
-	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
+	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
 	 * outside the head section.
 	 */
-	__LOAD_FAR_HANDLER(r10, kvmppc_interrupt)
+	__LOAD_FAR_HANDLER(r10, kvmppc_hcall)
 	mtctr   r10
 	ld	r10,PACA_EXGEN+EX_R10(r13)
 	bctr
 #else
 	ld	r10,PACA_EXGEN+EX_R10(r13)
-	b       kvmppc_interrupt
+	b       kvmppc_hcall
 #endif
 #endif
 
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index a99c5d9891c0..5b177c6d495b 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -8,9 +8,13 @@
 #include <asm/reg.h>
 
 /*
- * This is branched to from interrupt handlers in exception-64s.S which set
+ * These are branched to from interrupt handlers in exception-64s.S which set
  * IKVM_REAL or IKVM_VIRT, if HSTATE_IN_GUEST was found to be non-zero.
  */
+.global	kvmppc_hcall
+.balign IFETCH_ALIGN_BYTES
+kvmppc_hcall:
+
 .global	kvmppc_interrupt
 .balign IFETCH_ALIGN_BYTES
 kvmppc_interrupt:
-- 
2.23.0

