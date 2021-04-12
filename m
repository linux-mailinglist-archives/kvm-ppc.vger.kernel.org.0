Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB035BB43
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 09:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhDLHvg (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Apr 2021 03:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhDLHvg (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Apr 2021 03:51:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D86C061574
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso1335318pjg.2
        for <kvm-ppc@vger.kernel.org>; Mon, 12 Apr 2021 00:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mg2dHjlwZoN3pi8JCtfCf425RB7yPpz2gT1HyGLlh2I=;
        b=iBn5ujPuI5kNsZwQnALbNC28LHRZt22xXtKjg1GvD18y94uMZfVBHeK1rBUtMmK474
         Jse75tNDJlsYUoygPavVNIAJM/DkRLUoDHgfvoQ4viVzKIizKnHcwwcH6WyIjg10kVTp
         a71naeb+4L+BBygsA7QcYySUYM2lLW96/uEOpkmnVSfzIGFavgMSIIirdQfc85Td3/R1
         scf5G1fqEISvTNX0gEgY0dis8KELNG3Gb+Hr69ro7DDuKCrG3235ca8LzXimj8Bgtmyw
         nBehmi7AN9GP+gETfhCoT5ufeUes00Mb+RGvy5tEq8rOq9IpGyV9VsMP1OAqKZIwZtd7
         4ZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mg2dHjlwZoN3pi8JCtfCf425RB7yPpz2gT1HyGLlh2I=;
        b=W+ef8YXwOoUqujEj8jjT96ja3qkBjih1vpmlWdClohtT9QWurMh/7wFFVthBsCxZRY
         /9lNSlSXmvA4pEN3MkS9EPDO2rSZJATRjpO0BwUML5aZtz4Ns9ZgP2nMzuUdnn1TXrIj
         JWzId5kTuEJ8/gl9G7WdQouv+sJVsnckMU4cJD6XQgAkjYfneKKv+TL3787vm4RCVF8N
         IZWLj9I00xejCc5Tyx/jTbP8L9AJslkKoTb3RoZA1V5jZwC8JfYQou+jp8aYR0qwuZGy
         Zgv20z3ONBhp7XKb7kqBJoydl6/hBnPUoIv8TWXH+3zSa+1kRRwsiG/D5UTfhc7BrQ77
         VZpA==
X-Gm-Message-State: AOAM530uM1mIoKz3DRzzwIpFOVM9csEJpiAlZFmqSMbxhN1xlZc5Pln2
        9eaExDmE+idatpmkB44KZ5Avc0N6kJQ=
X-Google-Smtp-Source: ABdhPJw3swWa4IzDbn5eBRXYfU7wvJRl83L7SBZKaSrNo4Jz/s3JSMirvJrRSM8qRLQRlPzG/r51+A==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr13025777pjq.187.1618213878181;
        Mon, 12 Apr 2021 00:51:18 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id i18sm606180pfq.168.2021.04.12.00.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 00:51:17 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v1 3/7] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Mon, 12 Apr 2021 17:50:59 +1000
Message-Id: <20210412075103.1533302-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412075103.1533302-1-npiggin@gmail.com>
References: <20210412075103.1533302-1-npiggin@gmail.com>
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
index 5842cc3ebbbb..9467fd1038f9 100644
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

