Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647A5393F6B
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhE1JKM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbhE1JJt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:09:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B91C06134F
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k5so2168667pjj.1
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LqaydJ3jpxClMBPlT2JOHwW8d3UiSbtXfV80KYjNSlU=;
        b=CjACEkTmluJsfh+1wfIRUo/mACPvNwrua8PAExfuQmggq1CeLfAGIsS1kW2eSfdQFj
         uT93e3Bx/D9fEI2KB8z6oySz+lFLEq8wlIzN0/cdjg41qiJWEBTGz+yGEb77DF7tK1c1
         RKgf/92l3FLpWZ6TrYJAau8bJWPCp5rbjXfg0Ug3ktH8VfdTKoJ5aHinvImyCwkrTAzN
         MN8BHDJ9v88p7YwPLtomznSwet+FsCBEwuv8UktdVUqnrfjPEcUonZPBCOYAYRfiRIvz
         iGe35E1ZsHVJ6P7IQRaMRchR6DjyvWJJwqr0jqi6gftZrdv1WpitxWc2C3WHRy+Gvdtu
         TXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LqaydJ3jpxClMBPlT2JOHwW8d3UiSbtXfV80KYjNSlU=;
        b=IsjKIGpxugIHpajhg4jmM9ffJD6jljdWik1xMCD7trXXgysb/Ggu+Anq3CSqqIuxEF
         n8L/XeBSVchf7TKdTp4pAG62uiMvvGFfPZKz1naGslTl6R66u0zDhyYoYIw3b5VSm5ls
         l5L/oMI1imUiV7hr7/Cy4YzOi/nv18BtFmF8m104Uo5CksBO+XNNQuRv43q8lHgRTut5
         TayB5iP1BEP0dmnrcslYaglEbnJStDs5VBKNYi15BGEtZyzTzcR77WdTuid1+88G9q4i
         powJk/EhC7+/5n3hnYuIGMpd9QkSB8V2bVwza904n/NGh5kbiBTmO8O5Ib2VThHPw24S
         cZ9Q==
X-Gm-Message-State: AOAM533cmb3zYXOd3ZVIQ9+Xrxfmtqvq/4tMe2tomYBxtQtQm4wZhZW6
        yo6mn2obPSzekjbzD+bwYeQtOvzkHIw=
X-Google-Smtp-Source: ABdhPJxyBBYYMSIuNw9JDjeXUxDGin1pu7KuNUaov/hGk3ENOzYCkWSjk4xl9BeaBcPn/fGFUS7i6w==
X-Received: by 2002:a17:90a:c217:: with SMTP id e23mr3297219pjt.43.1622192887123;
        Fri, 28 May 2021 02:08:07 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:06 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v7 03/32] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Fri, 28 May 2021 19:07:23 +1000
Message-Id: <20210528090752.3542186-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
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
index 192b927b429e..4819bf60324c 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1966,16 +1966,16 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
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

