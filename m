Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7228E30B59C
	for <lists+kvm-ppc@lfdr.de>; Tue,  2 Feb 2021 04:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBBDEX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Feb 2021 22:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhBBDEN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Feb 2021 22:04:13 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D195C0613D6
        for <kvm-ppc@vger.kernel.org>; Mon,  1 Feb 2021 19:03:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nm1so1362497pjb.3
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Feb 2021 19:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8TVajqYLB/Li99OMhp5OhsGulAlbbfY7jMeRUpSx/E0=;
        b=h9xEao17YffqKMp8ERSFryBsfTuUiNZevfY4JojDOcdLcImSBkv+Mab6d88h0tm81W
         0XoenOSTtknkSvhF1fzoObhMjCzR1sM0UevcLIBxw+rZ1y24VIHVY0/cLVF0TkkZZ7S1
         eDZfAI9Q2tuNIaY3x4SjaM1PqVYu3KmmK01DSPceHthOUG4vYpfiqbK+eclJ719Yo7Pj
         RcGZKqhgh2bQPTuG2hgHtnA+Fm0yEgqGCOcfX/TjjtF1iqbePh/Y/B0HUnDIH6VlIt7B
         aHUyIKe1to+Vyy1u48yfHRMcq/xD+FDAejzUXz8jBgeIULrRD2YAq1fWii9wNClESHiQ
         8Yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8TVajqYLB/Li99OMhp5OhsGulAlbbfY7jMeRUpSx/E0=;
        b=RkNcjOP9R9ArWTTBQYQzznC9H91AYDNOVmuo/iRT8Zgw+zIbxdb8nvJoId288XSUBs
         k3BUijQi2uwKMMVDk9LCm7ParTahNiYvyIh93CX4eRQ0R3HVwBhgxJ0edzX/2PnJoLM/
         1IEpnfIEdm+0bPUY0Un8A+dgMEYr7pI7FD7nkZB4IRG+3lG7rvrj9s9Ga/lp6jmCk5xw
         GHzsCAtpzPENj981TA56MJwpM7dk+Kd+n2BYvQAicdHiPnxdGt2xRW2PtIY5FpEcakdI
         iL0AjHi8bNGugzedY9xTFmz5fmTAX7tRA75VXHJb5N7E3P4rSuxIZgCQd2eiSjAqq9Vu
         TWjQ==
X-Gm-Message-State: AOAM531umUCq4WJh7mRiEzoPLYOeRZcXu4cGbyKGCdfh9X4bzBa7v7nB
        LhU1uv6LAjO4vgBeYKo1Z7Y1hVJ7Kok=
X-Google-Smtp-Source: ABdhPJw5P8lmgnELllwG3rGxVL6XBuUcG+jjRNUoRltcg0DyXouWXyjpwnYfWCujFFYNtuns1sBTRQ==
X-Received: by 2002:a17:902:c410:b029:dd:7d4a:e50 with SMTP id k16-20020a170902c410b02900dd7d4a0e50mr20523765plk.36.1612235012822;
        Mon, 01 Feb 2021 19:03:32 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (192.156.221.203.dial.dynamic.acc50-nort-cbr.comindico.com.au. [203.221.156.192])
        by smtp.gmail.com with ESMTPSA id a24sm20877337pff.18.2021.02.01.19.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 19:03:32 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 3/9] KVM: PPC: Book3S 64: add hcall interrupt handler
Date:   Tue,  2 Feb 2021 13:03:07 +1000
Message-Id: <20210202030313.3509446-4-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210202030313.3509446-1-npiggin@gmail.com>
References: <20210202030313.3509446-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Add a separate hcall entry point. This can be used to deal with the
different calling convention.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 4 ++--
 arch/powerpc/kvm/book3s_64_entry.S   | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index e6f7fc7c61a1..c25395b5921a 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -2028,13 +2028,13 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
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
index 8e7216f3c3ee..3b894b90862f 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -9,6 +9,10 @@
 /*
  * We come here from the first-level interrupt handlers.
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

