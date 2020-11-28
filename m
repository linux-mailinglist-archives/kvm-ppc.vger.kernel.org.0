Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBC2C7228
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgK1VuZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732384AbgK1TAO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 14:00:14 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED26C09424F
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:40 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t8so6365124pfg.8
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3oWRMvHAa0retNOL9Z6Iu6Rm3CZHGga7R1WoN7izS8=;
        b=Xor/UKmvhmlqZm3VyydOKtoxX3Rck9mkU1XrQp8Ns6xarLl3R0uZQFQzwygwshq10T
         ieqKlYutE5COhEkTnCMXNriF5tRwoO+Dl6D20mhAeff4H6fyHL89ylAi16PS9jhj0w6w
         rn8q4pItuxPP8ZyaqgL6VW1i8Aq7jgRqNYfDnhd/wYwss37qGQm9VYjqI6rkx8BG01Bj
         FFRBRMOEvSEslexeMmXIkrxJOjaofRuulJhED4xACfONkMAmtfH8H82+76SxFYWF9V8c
         OOCj0SwOv8HXIL86CFzdXwxAHOkK7sDK8CO3uRviSRaSQC7Y8vVxf3P0NBisXTPptzIM
         Sqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3oWRMvHAa0retNOL9Z6Iu6Rm3CZHGga7R1WoN7izS8=;
        b=iv0Cb9cQID8AP9EVdemjSO1YhuY5+gLJLNlE+0IrprPjVX8K6VUfcy+lqDdRigR6cn
         xTssEDtiZRbHxwamK4nsFBH5byq1rplRrvSRebo7ITeRaloU+elaje/WKiQtPE1Y6G3m
         BLMV/oUxq+cB0iuG/MeuoboNBQGPt/ZXM5Yl2KqUi2VDXWyZXqFP7Du2Qg2oVNo+mdPT
         uKrPrAY/OHCqwOOrY4JDw+smLaJMDb20JrfnkkAz1stLs1wA6T9xKDyB6nq7Ov+Q/NLc
         GSKay6gbCfMXPOyc5KKFRXYExMpoMypa659oaumOU2z1wXyUTSj4Dw+t3pCBgMs4xoN4
         B73g==
X-Gm-Message-State: AOAM532siWv1q5Z8iLq+FtlK5nGP4CYYzOgGBtBjANB83L6zPN8Sy07E
        a8kwVheXm51HEo2xP8RiiV8=
X-Google-Smtp-Source: ABdhPJyG12KQon1LvVGV1FFKUrt1+uZon+BwxhIiJRZnCvXz4gTtLyYqrEGsI7Cp2uZ21EMwjNP7AA==
X-Received: by 2002:a63:4950:: with SMTP id y16mr8693669pgk.415.1606547259859;
        Fri, 27 Nov 2020 23:07:39 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:39 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 1/8] powerpc/64s/powernv: Fix memory corruption when saving SLB entries on MCE
Date:   Sat, 28 Nov 2020 17:07:21 +1000
Message-Id: <20201128070728.825934-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This can be hit by an HPT guest running on an HPT host and bring down
the host, so it's quite important to fix.

Fixes: 7290f3b3d3e66 ("powerpc/64s/powernv: machine check dump SLB contents")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/platforms/powernv/setup.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 46115231a3b2..4426a109ec2f 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -211,11 +211,16 @@ static void __init pnv_init(void)
 		add_preferred_console("hvc", 0, NULL);
 
 	if (!radix_enabled()) {
+		size_t size = sizeof(struct slb_entry) * mmu_slb_size;
 		int i;
 
 		/* Allocate per cpu area to save old slb contents during MCE */
-		for_each_possible_cpu(i)
-			paca_ptrs[i]->mce_faulty_slbs = memblock_alloc_node(mmu_slb_size, __alignof__(*paca_ptrs[i]->mce_faulty_slbs), cpu_to_node(i));
+		for_each_possible_cpu(i) {
+			paca_ptrs[i]->mce_faulty_slbs =
+					memblock_alloc_node(size,
+						__alignof__(struct slb_entry),
+						cpu_to_node(i));
+		}
 	}
 }
 
-- 
2.23.0

