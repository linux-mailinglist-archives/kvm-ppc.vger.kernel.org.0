Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11E7353A94
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhDEBVC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhDEBVA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:00 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD94C0613E6
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:54 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b17so3514324pgh.7
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ed2GXWlaCaSp80Tc/mRVZswGXqjaQmSEJ2I3FJJrKHY=;
        b=e73LpyIJznudnCnZPgrkOx35aNoogsvfvId8gLSOXX8i9H0929f2Y321Dr7ONmL4p3
         XFmd+Oteke/GyqaIXgHEo+dEPB1rpdcETZxXKemfK+yp30Jxq/gYTswMsy3kZTMX8zJ7
         p6HyxTMyFjFWg39qIFjAuAEn6fZvz2fxXNhglAzE0O5Tpw6kRXxCMfRYhBXbIaP9Luj3
         RBXq83fK9deVMfF71PF3nup3vRJ8E5A7fIwV6PnpuWLMNaol07REV8M+PW4/2u3XzZ0/
         fCMcba3Ux9wgC+DDVs8+OgSCVmWlHKjxn0hJth7RSTmsiv53WnEkGsMlxkD16u9yIQDN
         ntlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ed2GXWlaCaSp80Tc/mRVZswGXqjaQmSEJ2I3FJJrKHY=;
        b=H+qgwvvadg4LaW613o83wfRoAI1Tkq1NMKAE+JUIYbeHDt5c4VNZsf3hIgu3RiAJj9
         zhAZJIMo9dutQJYRlvMmqS/4bAtIC8LPT+ES8Bn2KCtPTtRhFldaGQnZ+zZawPYTy6Ln
         ZzGMdiLyruLV05JWEduysVPT7NC4cuvSklPobpXqNoQKfyx/uoPecWmlcl3z5Xe5kzeK
         5oUjmj4wXD7nIWXg3Pi3dVdWTSnTdBUhdqtnjIU3TrXRgxaS/0UczEK/yq4z7O13C7fX
         Rqo1q2KoYIaEYHNturWyg+uGft5uWbBNXsJUmJCqv+ywQ8wKVP2ctGrte/hKe+CwNRFf
         4NBQ==
X-Gm-Message-State: AOAM533p9SWCgS7xLEmyDoq/p3fO34wFi2s8BDvRIKVHhVo6y57/Th4X
        mIdXUEuUo8gx6Ibow1RaJ0XOn1chu9Pc4g==
X-Google-Smtp-Source: ABdhPJxXoU7kKdyUv7+TwJCZznBqV0rzxxPEglGyclVPCRi9MLLoA/a3wHM3mZvQuwuDW+M77gnT+Q==
X-Received: by 2002:a63:c145:: with SMTP id p5mr14876597pgi.451.1617585653647;
        Sun, 04 Apr 2021 18:20:53 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v6 14/48] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Mon,  5 Apr 2021 11:19:14 +1000
Message-Id: <20210405011948.675354-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index bf927e7a06af..c21fa64059ef 100644
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

