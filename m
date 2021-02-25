Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B3C3250BE
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBYNsa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhBYNs3 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:48:29 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C833C061793
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:33 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o63so3811135pgo.6
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWnzQkuEUPMoWm/4qDOGdHuIkxWe5CpH2emCUPPeV1U=;
        b=aCwoSEX3CLiQ454/HcUwBUvX4+4SdXsdFI7ce0eGhYjN7OO6qXwC8Zpv30cSV3NsN+
         xN58WSX4Mp50JLz1QtcjNVuA3YOeONO6rzxaQUp5KLZM3KbVDY1iwMRQSnUhCtqbxb+C
         KKIUuUyjjzvnd2//gHKsW0eN/UB6FJg1Qm2lCVrXfMlEVmJLqV+XZvDdkSEhetgGmsDf
         iKrSVGVsSFJqR79TrKrZbgl+HnU8/6czzDuGqUYxb7h9gL/ZireF8m2Dcld6tfh4Qnq2
         CHLsIwppPaqa0Wf8v/0uMej+HhKGkXU977LRRyiDZKMOSqJYXlBL6fjfrjzkIhdSLTLU
         lTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWnzQkuEUPMoWm/4qDOGdHuIkxWe5CpH2emCUPPeV1U=;
        b=P+pgOoGN5tRIIOBXf5+la8C8njv222ec5T3LCJqjwvBl+5nTtlr3QiVG/lnH1RxK1G
         jDVqCdAIoBZBA3j29MD1UsHHh6z0VvNIA5P00B06BVMjAYNU+whN14zgHLWq8NYxs0R/
         BHh5Bqin1LhwdEjoac71hdOI9Xb9P6maF6fDjebN/IiKWENhvVngRKykfIYAgJQxgsTD
         RO+BfenhzGS+B8OhCKRoNSTbpVRNl4sJCjzhRSI5bCYo3qpHcXQmKpw+vNymNYlY6StA
         XLTOLPO2LehaAxO8xGR3cAdc1FdtxQaIxyR76ljz/tQRMasHCBX06d+DDvPR+tSwTn8v
         9pIQ==
X-Gm-Message-State: AOAM533wWFjT5QsSgZQDuhOrSTBzE4XuN6M7kQOhReUQ/rWwveNgwYIj
        pyCVR/kRCy682VRJKFpLA0CIwfl0k0Q=
X-Google-Smtp-Source: ABdhPJwEMI7Log06mCQHoCSRxy9UFT2J7w4Jc1vzc5d7sNcJknEZi9OvrFEJZxi8S0j9BRjhUpvJwQ==
X-Received: by 2002:a63:1350:: with SMTP id 16mr3031040pgt.85.1614260852602;
        Thu, 25 Feb 2021 05:47:32 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:31 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v2 08/37] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Thu, 25 Feb 2021 23:46:23 +1000
Message-Id: <20210225134652.2127648-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a separate hcall entry point. This can be used to deal with the
different calling convention.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 4 ++--
 arch/powerpc/kvm/book3s_64_entry.S   | 6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index d956dd9ed61f..9ae463e8522b 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1992,13 +1992,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * Requires __LOAD_FAR_HANDLER beause kvmppc_interrupt lives
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
index c1276f616af4..9572f759255c 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -7,9 +7,13 @@
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

