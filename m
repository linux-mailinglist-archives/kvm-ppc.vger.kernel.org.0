Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237A7AFBFE
	for <lists+kvm-ppc@lfdr.de>; Wed, 11 Sep 2019 13:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfIKL6f (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 11 Sep 2019 07:58:35 -0400
Received: from ozlabs.org ([203.11.71.1]:51417 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfIKL6f (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 11 Sep 2019 07:58:35 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46T0m90xyXz9sNF; Wed, 11 Sep 2019 21:58:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1568203113;
        bh=fq8fQ22sZ/nyxorllJO6Q77Ryp80lsBaQrxTm1scNks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSYcB3p8kSf3w4axofVVHUqrTb7pKuCteerz4+YKYzIs2aOzNEa6HapIdArGixeL2
         B99z8jtMAVgFBx3j0v8NL9rYN1DVnAxWGyoS3XJY6wbrjTMnnHrfmw4l1mld9QNKNq
         3KBfCjjFwz90iNMfkgg4oRkxqUGO19N8ddomkVgvPmHMcD0d0DFUY7Rx8nfnwJVhWU
         A/9+LlNqg09vNoVwUl1+T5N0tNkmAM7uxC49P572rLG7s3QK1P3AH1cd1+EniK2jrw
         fNICh3zRufz2l+gq8qjSadpxpyON9YkoNauS4efy0QprR5Kw7LmqNJqaXgjCBzTaDx
         XdkBidtk2zGEw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     linuxppc-dev@ozlabs.org
Cc:     cai@lca.pw, kvm-ppc@vger.kernel.org
Subject: [PATCH 2/4] powerpc/64s: Remove overlaps_kvm_tmp()
Date:   Wed, 11 Sep 2019 21:57:44 +1000
Message-Id: <20190911115746.12433-2-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911115746.12433-1-mpe@ellerman.id.au>
References: <20190911115746.12433-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvm_tmp is now in .text and so doesn't need a special overlap check.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/sections.h   | 11 -----------
 arch/powerpc/mm/book3s64/hash_utils.c |  4 ----
 2 files changed, 15 deletions(-)

diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 4a1664a8658d..5a9b6eb651b6 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -61,17 +61,6 @@ static inline int overlaps_kernel_text(unsigned long start, unsigned long end)
 		(unsigned long)_stext < end;
 }
 
-static inline int overlaps_kvm_tmp(unsigned long start, unsigned long end)
-{
-#ifdef CONFIG_KVM_GUEST
-	extern char kvm_tmp[];
-	return start < (unsigned long)kvm_tmp &&
-		(unsigned long)&kvm_tmp[1024 * 1024] < end;
-#else
-	return 0;
-#endif
-}
-
 #ifdef PPC64_ELF_ABI_v1
 
 #define HAVE_DEREFERENCE_FUNCTION_DESCRIPTOR 1
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index b8ad14bb1170..1be0622a1f38 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -271,10 +271,6 @@ int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 		if (overlaps_kernel_text(vaddr, vaddr + step))
 			tprot &= ~HPTE_R_N;
 
-		/* Make kvm guest trampolines executable */
-		if (overlaps_kvm_tmp(vaddr, vaddr + step))
-			tprot &= ~HPTE_R_N;
-
 		/*
 		 * If relocatable, check if it overlaps interrupt vectors that
 		 * are copied down to real 0. For relocatable kernel
-- 
2.21.0

