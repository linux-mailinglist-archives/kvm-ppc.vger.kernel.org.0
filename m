Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E268F999
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Aug 2019 06:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfHPEHy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 16 Aug 2019 00:07:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42155 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPEHy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 16 Aug 2019 00:07:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so2267218pgb.9
        for <kvm-ppc@vger.kernel.org>; Thu, 15 Aug 2019 21:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XFeI3MMdw+vLf2h/eQPceYAz2jMEXM4TlUoQFqFFVos=;
        b=Q7DanO/tyoXZpvkxgVZBBGnnNFAk3gBkKb6duBHkXlR3rt3Iw7VwMetiZO1Rfo3pZf
         7db9vZq0qNs47Ne0UWKWDuzvStmr+L3x8gizJv4A0OreGoi+ryiq5pHnXX5Qajzbuv0p
         Q35Dqo9m2hYMu+9rggPRt+C1q66xPMCa8J6cj1V8n/OhsbP88/oYAzdPO4OyoickeOsP
         zyP6GFknff3K0gyBHfiRNqKPWRgCOos3dqhQK35vP4gSuPCYkPbqmVAJvdgdSRqDIA2g
         jnmOOOwDbg1IDMyqXpr1AEwk+6iXyDgr0oyOqRSU4vDvCL2BWt+gE8QwVJoD1KfPZsmT
         o8Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XFeI3MMdw+vLf2h/eQPceYAz2jMEXM4TlUoQFqFFVos=;
        b=Hr9B9YPbLIJhowXuk+MTL1Itg6jKT3JOc17lMpdVRhwV0eFsVNB+uRdN94EQHhSF8F
         zD5KryYMXj4QBOcWYnWPxhugnLCcqZtDQCWqdiOO3iYSLtXhaUuXisY7oXH/1hSLdtkG
         qclfGwSynKDbKkUPN75/H7Gi9N7eFdcBsal+VMXbyBv6mDOAFV+Uy+0P12TohTPq20wf
         KCivW67tQRsHXF2n4lXFxFDv133W1lxLbvTxT2iYcG/YQSxeVYE3K3JwMAOgkT5liu3o
         S2pfbMwZk3OfF3pjSIWM3hVpvbOOsgj1AbGzSOF4nC+zBElu4j75A3tkuZUUDB39kFFy
         U7dQ==
X-Gm-Message-State: APjAAAXRXCzZN7TFXZ3rafV9kHzOQ1m+KMv1cGgTeqZUEbcmIjsA7Tl2
        NRcNI99x9+VfK+7h2+fPXG0=
X-Google-Smtp-Source: APXvYqypvWxkK795DVau1RqIoQIFof/e8f6iHZkDn4IUiEUphR6q+HTEg+ZgpneyfKuR2HCnfq76oQ==
X-Received: by 2002:a62:8344:: with SMTP id h65mr8834139pfe.85.1565928473779;
        Thu, 15 Aug 2019 21:07:53 -0700 (PDT)
Received: from bobo.local0.net (61-68-63-22.tpgi.com.au. [61.68.63.22])
        by smtp.gmail.com with ESMTPSA id j187sm4994850pfg.178.2019.08.15.21.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 21:07:53 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Anton Blanchard <anton@ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH 2/3] powerpc/64s/radix: all CPUs should flush local translation structure before turning MMU on
Date:   Fri, 16 Aug 2019 14:07:32 +1000
Message-Id: <20190816040733.5737-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190816040733.5737-1-npiggin@gmail.com>
References: <20190816040733.5737-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Rather than sprinkle various translation structure invalidations
around different places in early boot, have each CPU flush everything
from its local translation structures before enabling its MMU.

Radix guests can execute tlbie(l), so have them tlbiel_all in the same
place as radix host does.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index d60cfa05447a..839e01795211 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -382,11 +382,6 @@ static void __init radix_init_pgtable(void)
 	 */
 	register_process_table(__pa(process_tb), 0, PRTB_SIZE_SHIFT - 12);
 	pr_info("Process table %p and radix root for kernel: %p\n", process_tb, init_mm.pgd);
-	asm volatile("ptesync" : : : "memory");
-	asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
-		     "r" (TLBIEL_INVAL_SET_LPID), "r" (0));
-	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
-	trace_tlbie(0, 0, TLBIEL_INVAL_SET_LPID, 0, 2, 1, 1);
 
 	/*
 	 * The init_mm context is given the first available (non-zero) PID,
@@ -633,8 +628,7 @@ void __init radix__early_init_mmu(void)
 	radix_init_pgtable();
 	/* Switch to the guard PID before turning on MMU */
 	radix__switch_mmu_context(NULL, &init_mm);
-	if (cpu_has_feature(CPU_FTR_HVMODE))
-		tlbiel_all();
+	tlbiel_all();
 }
 
 void radix__early_init_mmu_secondary(void)
@@ -653,8 +647,7 @@ void radix__early_init_mmu_secondary(void)
 	}
 
 	radix__switch_mmu_context(NULL, &init_mm);
-	if (cpu_has_feature(CPU_FTR_HVMODE))
-		tlbiel_all();
+	tlbiel_all();
 }
 
 void radix__mmu_cleanup_all(void)
-- 
2.22.0

