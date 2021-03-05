Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D614C32EDCB
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhCEPHm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhCEPH1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:07:27 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC939C061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:07:26 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id r5so2188310pfh.13
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=97vKqpXzP/s6j2Q2X9DDNv6PS4Ig8ESJY15d7Gu3sgg=;
        b=DgmaHg12XvVXsQa3Ty/c8OBT8FRMP6qD+6/ttD4My3RCZ7iPmr77XEGPMEJEEO4qEl
         sQkipv385RES9mE1bhyjZql0a7tes4bjhKBRxjna4tgrP+pwzxcuF0vikCPpXtLmaW92
         K1NcQ8XPS+xoGDoMd4zgfu+UpOa9vkEKD8UqFW1d0/4CRQRhSX6Q69JSXSROjMWthUoN
         lbqYiiHe2YQnybtwcf4FOYpffo1xvDj1iufzGx7gJ7T1SWaeBqQH8yKFuGWxCxrDxTfS
         cz2DejDeZwh12O4EYxUfs2904o+Qm4Cw+kfjBZzw2R6X9B8SzyIU0zXvMahHRTCL/C1R
         urTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=97vKqpXzP/s6j2Q2X9DDNv6PS4Ig8ESJY15d7Gu3sgg=;
        b=Ae+uiTz7ZmSV2iyIMRlP/rC/npnWSrUggfAb3JDAJD4/MIkaQua5d1OvwVhzc7EH0q
         Vglu35+lbGpQsOTs2r+DBowYgzOZ8aGUI3Sa4lwHq+k3WAojqIdKEq8I70YfNku0SAh7
         Brp7H97PG61wNdL3ROVnA/t+f7xFmJ/Hnw95u1YWFu5eP2vHk05QE1jK3hUp2WX4zo/7
         O+n8Y3MnRNF1vVOSlDQzlT2ZteLtlgwbwhpz6I21Bi2BHS7gXtwqtHVPLYEdWByLBXoW
         NzsJxcn2s1GRzYb5N36DQM8iPFHQmDkpfn+uBfPP90WM+nI1WowMsBv1SIAEQZqxblYZ
         58lg==
X-Gm-Message-State: AOAM532O3gP6uD35lRqcr6apWZ8ydPV1yZDzjLDf7CsO2QDQMFxwo3Qp
        YHrF7oOjP5IdGLLZMhNXHQ392DtoXLY=
X-Google-Smtp-Source: ABdhPJzNDeydZpTk6fW6ICChZLmpKRyyF3ATVReo+I6OF7xxLv3moPgsFeWWX8zL5qfHhaC0q+D8iQ==
X-Received: by 2002:a63:1725:: with SMTP id x37mr9125283pgl.48.1614956846174;
        Fri, 05 Mar 2021 07:07:26 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:07:25 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 11/41] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Sat,  6 Mar 2021 01:06:08 +1000
Message-Id: <20210305150638.2675513-12-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
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
index d956dd9ed61f..292435bd80f0 100644
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

