Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7618E1D15EB
	for <lists+kvm-ppc@lfdr.de>; Wed, 13 May 2020 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388634AbgEMNje (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 13 May 2020 09:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388350AbgEMNjd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 13 May 2020 09:39:33 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A64C061A0E
        for <kvm-ppc@vger.kernel.org>; Wed, 13 May 2020 06:39:32 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b6so16197819qkh.11
        for <kvm-ppc@vger.kernel.org>; Wed, 13 May 2020 06:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFXyl8bLGTgB36EioVmpcCnHThDdGncqsiu7Ha+l9Ck=;
        b=G/AjTLfR29lUROPs7vr/JubE1o3ERsvq3GIxpEXg/6FSWKOZGnX/UGQQcX/n8lVw0B
         fHGsnL+Lfm7YVzme+LYrVHFLtxPpW5P/nC3Rcun7ro/HuZw9IA1ThTI9Cv0Bd3XaPaOb
         hfxs7LJ5S7XexlyfuZQe8kq9jQnT/x41r/7ch+b7VfEeWsJmq006VVWtqNHFgncF5Qsn
         l13nizIigZl/8GX2AGztE44wnPM4n4lxORVaaiq0VfqtQnW5fgp3Rr5T/Oa+4yEjB0fx
         yISMxpHi7KbbbtbliLwsmTHBlbLfVtA7Gxjz/N7tmyVxsp86FSmvO2ndcDF5wsna/ks2
         h/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XFXyl8bLGTgB36EioVmpcCnHThDdGncqsiu7Ha+l9Ck=;
        b=IAueEiHHFF0ITFOQxXGslW6EK6CDumj73onN4+iHRzpWAiQo4S0nh2j48ops5ANoWU
         db1OMt6XB7Ahl8wzBSihn2nxkbYv/UPKhdSzRR91roNIpiqesJm8GweGBQoCAZfUJX4C
         cufT5nQ+fq93DeT7RSh6Oz/uqCt6qsv3EYX4Gl3bED8XZsh7jIb4h+LQ6/k08lo1OaBl
         hF/dSeKofKBUEeaG9TQmf0k7DkQRTn+SWJzj0hd8/la7FawmAsbAlNk32SBMHySpDQGK
         /l5x2REghPT12v/o+G9lKbbofa/ep8prm92i13ZLfC2EipjU3ZqNu5IMmBh3E/REzppj
         UXAQ==
X-Gm-Message-State: AGi0PubSeH3MlMOawwTV9Groc2BazIJpntYrgcrOk/2niYvZeIVsK9MB
        vVz/QLjStOFLB1zBGWl2YcxELg==
X-Google-Smtp-Source: APiQypJIQ7dwxyjjoiFv01S4nCAvfLANCzyEfKoU8HTELxdOu2uR63fRzhoB7b8epU3HG++PT2s7MA==
X-Received: by 2002:a37:b4c7:: with SMTP id d190mr24934971qkf.432.1589377171712;
        Wed, 13 May 2020 06:39:31 -0700 (PDT)
Received: from ovpn-66-156.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id h9sm4292783qtu.28.2020.05.13.06.39.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 06:39:31 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     paulus@ozlabs.org, mpe@ellerman.id.au
Cc:     benh@kernel.crashing.org, catalin.marinas@arm.com,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH] powerpc/kvm/radix: ignore kmemleak false positives
Date:   Wed, 13 May 2020 09:39:15 -0400
Message-Id: <20200513133915.1040-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kvmppc_pmd_alloc() and kvmppc_pte_alloc() allocate some memory but then
pud_populate() and pmd_populate() will use __pa() to reference the newly
allocated memory.

Since kmemleak is unable to track the physical memory resulting in false
positives, silence those by using kmemleak_ignore().

unreferenced object 0xc000201c382a1000 (size 4096):
 comm "qemu-kvm", pid 124828, jiffies 4295733767 (age 341.250s)
 hex dump (first 32 bytes):
   c0 00 20 09 f4 60 03 87 c0 00 20 10 72 a0 03 87  .. ..`.... .r...
   c0 00 20 0e 13 a0 03 87 c0 00 20 1b dc c0 03 87  .. ....... .....
 backtrace:
   [<000000004cc2790f>] kvmppc_create_pte+0x838/0xd20 [kvm_hv]
   kvmppc_pmd_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:366
   (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:590
   [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
   [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
   [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
   [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
   [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
   [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
   [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
   [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
   [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
   [<000000004afc4310>] system_call_exception+0x114/0x1e0
   [<00000000fb70a873>] system_call_common+0xf0/0x278
unreferenced object 0xc0002001f0c03900 (size 256):
 comm "qemu-kvm", pid 124830, jiffies 4295735235 (age 326.570s)
 hex dump (first 32 bytes):
   c0 00 20 10 fa a0 03 87 c0 00 20 10 fa a1 03 87  .. ....... .....
   c0 00 20 10 fa a2 03 87 c0 00 20 10 fa a3 03 87  .. ....... .....
 backtrace:
   [<0000000023f675b8>] kvmppc_create_pte+0x854/0xd20 [kvm_hv]
   kvmppc_pte_alloc at arch/powerpc/kvm/book3s_64_mmu_radix.c:356
   (inlined by) kvmppc_create_pte at arch/powerpc/kvm/book3s_64_mmu_radix.c:593
   [<00000000d123c49a>] kvmppc_book3s_instantiate_page+0x2e0/0x8c0 [kvm_hv]
   [<00000000bb549087>] kvmppc_book3s_radix_page_fault+0x1b4/0x2b0 [kvm_hv]
   [<0000000086dddc0e>] kvmppc_book3s_hv_page_fault+0x214/0x12a0 [kvm_hv]
   [<000000005ae9ccc2>] kvmppc_vcpu_run_hv+0xc5c/0x15f0 [kvm_hv]
   [<00000000d22162ff>] kvmppc_vcpu_run+0x34/0x48 [kvm]
   [<00000000d6953bc4>] kvm_arch_vcpu_ioctl_run+0x314/0x420 [kvm]
   [<000000002543dd54>] kvm_vcpu_ioctl+0x33c/0x950 [kvm]
   [<0000000048155cd6>] ksys_ioctl+0xd8/0x130
   [<0000000041ffeaa7>] sys_ioctl+0x28/0x40
   [<000000004afc4310>] system_call_exception+0x114/0x1e0
   [<00000000fb70a873>] system_call_common+0xf0/0x278

Signed-off-by: Qian Cai <cai@lca.pw>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index aa12cd4078b3..bc6c1aa3d0e9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -353,7 +353,13 @@ static struct kmem_cache *kvm_pmd_cache;
 
 static pte_t *kvmppc_pte_alloc(void)
 {
-	return kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
+	pte_t *pte;
+
+	pte = kmem_cache_alloc(kvm_pte_cache, GFP_KERNEL);
+	/* pmd_populate() will only reference _pa(pte). */
+	kmemleak_ignore(pte);
+
+	return pte;
 }
 
 static void kvmppc_pte_free(pte_t *ptep)
@@ -363,7 +369,13 @@ static void kvmppc_pte_free(pte_t *ptep)
 
 static pmd_t *kvmppc_pmd_alloc(void)
 {
-	return kmem_cache_alloc(kvm_pmd_cache, GFP_KERNEL);
+	pmd_t *pmd;
+
+	pmd = kmem_cache_alloc(kvm_pmd_cache, GFP_KERNEL);
+	/* pud_populate() will only reference _pa(pmd). */
+	kmemleak_ignore(pmd);
+
+	return pmd;
 }
 
 static void kvmppc_pmd_free(pmd_t *pmdp)
-- 
2.21.0 (Apple Git-122.2)

