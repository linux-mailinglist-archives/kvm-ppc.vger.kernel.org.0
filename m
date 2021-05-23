Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369DD38DBAB
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 May 2021 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEWPzP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 May 2021 11:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhEWPzO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 23 May 2021 11:55:14 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D53C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 08:53:47 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f22so17309514pgb.9
        for <kvm-ppc@vger.kernel.org>; Sun, 23 May 2021 08:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CZYTGLN3cT3mGmoQRmYoshqpeqrdB0sYRrg/DzBKXs=;
        b=ZKgCjfoRescEm/+SvJOsEK3pJc4N8F44LeZmyfsLrX3js6puXoKU8UmpqoYJ9ZUGiX
         mCkWt4u6CikDoHafAIYXcaBKnfRKOpr75Omv3pkAkvyVxareWgumVNlMQPVMyU1zH96G
         ZuaXeDKgHDQE/zpqzkTRZecXTnt6g2ybbByveUuIaFe+y+OOsvtvuGB/PkU2AePkc59F
         AXwBLwQZgtBve3jzqttyeW4EVlJxvCf+ZsEhI/ZNhM08ElyG4H17HAdOi1ekJXuXkpnv
         WlpMF4aQInUZ1t7SJN/WuTYxLtRHzT3BWZbI3ZHacVPIA9Yx9aTsTAn2WDnXAWKir9eh
         7YbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2CZYTGLN3cT3mGmoQRmYoshqpeqrdB0sYRrg/DzBKXs=;
        b=VhsA6VCMwMegQYNjbgcMCQCOpse1ks3qyRo3Pm2ntadK7bcb8Iqmfin1Tpd/HRxA8N
         orZRqsJxts9Zp8DJNVZoYBIqQ4B7hmebeEB08KoAgHlKELNjOTI8f4GTIvly8qJw7URr
         MI7M0f+E3fO6im4HaXNhuUK8kkwIdefNbF4SraWvyBSoO16j8oMbjEA1qhP4Szbsovbk
         S3n6xka/4E9jPkzNAVtRlU0kj0dU8qi07V+D5f1Q9R1llTasJjILXUqb7uBIJ74TTQZd
         rLHpHkFUd5mB4kpZ+rrcGGGGPKN2kmGSE9Nb5Od7LFdALq0Ts/y46lCnEVLbqohEBARy
         GP7w==
X-Gm-Message-State: AOAM531RKhXHWaq7o+ZXHZ6zGswBWC81TiRXHS4trobAs2BI4Uuy2xJs
        RxPnN5rcHuNNy3H6y6vC73+TjTY/to4=
X-Google-Smtp-Source: ABdhPJzTjGYHjl/Wj/BzUjLWWJzQyeCwmbGkLyb1ThECh5XievJRz2FS/nnhe8WCIblzQVPBVQxs4Q==
X-Received: by 2002:a63:5052:: with SMTP id q18mr9094289pgl.349.1621785226440;
        Sun, 23 May 2021 08:53:46 -0700 (PDT)
Received: from bobo.ibm.com ([210.185.78.224])
        by smtp.gmail.com with ESMTPSA id z19sm9720936pjq.11.2021.05.23.08.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 08:53:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] KVM: PPC: Book3S HV: Fix reverse map real-mode address lookup with huge vmalloc
Date:   Mon, 24 May 2021 01:53:38 +1000
Message-Id: <20210523155338.3254465-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

real_vmalloc_addr() does not currently work for huge vmalloc, which is
what the reverse map can be allocated with for radix host, hash guest.

Add huge page awareness to the function.

Fixes: 8abddd968a30 ("powerpc/64s/radix: Enable huge vmalloc mappings")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 7af7c70f1468..5f68cb5cc009 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -26,16 +26,23 @@
 static void *real_vmalloc_addr(void *x)
 {
 	unsigned long addr = (unsigned long) x;
+	unsigned long mask;
+	int shift;
 	pte_t *p;
+
 	/*
-	 * assume we don't have huge pages in vmalloc space...
-	 * So don't worry about THP collapse/split. Called
-	 * Only in realmode with MSR_EE = 0, hence won't need irq_save/restore.
+	 * This is called only in realmode with MSR_EE = 0, hence won't need
+	 * irq_save/restore around find_init_mm_pte.
 	 */
-	p = find_init_mm_pte(addr, NULL);
+	p = find_init_mm_pte(addr, &shift);
 	if (!p || !pte_present(*p))
 		return NULL;
-	addr = (pte_pfn(*p) << PAGE_SHIFT) | (addr & ~PAGE_MASK);
+	if (!shift)
+		shift = PAGE_SHIFT;
+
+	mask = (1UL << shift) - 1;
+	addr = (pte_pfn(*p) << PAGE_SHIFT) | (addr & mask);
+
 	return __va(addr);
 }
 
-- 
2.23.0

