Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EE934547A
	for <lists+kvm-ppc@lfdr.de>; Tue, 23 Mar 2021 02:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCWBER (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Mar 2021 21:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhCWBED (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Mar 2021 21:04:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB46C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bt4so9321757pjb.5
        for <kvm-ppc@vger.kernel.org>; Mon, 22 Mar 2021 18:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nXjI3MKqqUglifKQA8zc/gRtp5duBK6cOq58P6laAog=;
        b=aqI9464Zme0kXr32WJLOb/zEoPdK0nhlxWwYPwq5vecB6gvYmg5kC60lOU+QlwKh/y
         lIkT5staUjWjq7tRyw79OJhblZpJ8CX8AhIniFpQJhaP6XY6IGWMFR0IRPbUZM/inNqS
         tnw+GJ2WUdMgzTH4Jj0yoOZtNdWhIrqwBISSfUmIl+9fYRG23x0e+qi+WviphHSEA5ww
         KRNWUKQSJ8LqZ3v0XnKpZw1YELs4z3latiu9U+nLhhJGbm8g3PCVMmRUMGZfz4I/ZTUG
         N4cvHn7EWxhdqr0cUiYiwL2ntagfevV+4bParERp/QRVsjU47ipIijhKnhA1pEMR1uoQ
         7OKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nXjI3MKqqUglifKQA8zc/gRtp5duBK6cOq58P6laAog=;
        b=G3SZ+btEIxTk8lBEEc3Ja5Cr1unYAe1CkGKxtVuRdqoRUULJJoNOouVFrWQIPuf/G6
         sQ1/v1+ODWEM64cq1nn+bxPR7iqumr8/Rjyj/QlCSTBvQmGNtFmXCjN56KrUzZwVzK1j
         3UHEZrxFIIR5sLwop6DSthB1uDR0dStz7ndDmfYgdZsirsKVo4FrXD0DHjxsebHn7glC
         rfN1Le4G9rQk47imAxcmqofkAyP+2HXjINS08EVHDag5OttImO0iEMDpymOlcaxGgi1y
         UJQb9Aypfq59h0ngOJuKqFMfX1gP6lq8j63Scy9Ufn0TVWM5A1pcsekY2Uhqpg3IOYU4
         NL6A==
X-Gm-Message-State: AOAM532we6GQ6KTtkZcfZUqKcAe7yqS1kdjSstZmdvnn5BPs0vLnJNYE
        q1BEu9vx3EdqH5LaACD29YB7hsBP2eE=
X-Google-Smtp-Source: ABdhPJwb0n15uBxD82UyhDnIaLCRikVNz8wtZ22PFAMXF6fmq/QflfbK2LQWKBTeWtEK0bSh3SDALg==
X-Received: by 2002:a17:90a:1642:: with SMTP id x2mr1879263pje.88.1616461441940;
        Mon, 22 Mar 2021 18:04:01 -0700 (PDT)
Received: from bobo.ibm.com ([58.84.78.96])
        by smtp.gmail.com with ESMTPSA id e7sm14491894pfc.88.2021.03.22.18.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 18:04:01 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v4 14/46] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Tue, 23 Mar 2021 11:02:33 +1000
Message-Id: <20210323010305.1045293-15-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210323010305.1045293-1-npiggin@gmail.com>
References: <20210323010305.1045293-1-npiggin@gmail.com>
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
index a5412e24cc05..8cf5e24a81eb 100644
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

