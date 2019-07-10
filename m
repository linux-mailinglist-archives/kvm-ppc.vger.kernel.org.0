Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7BC664087
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Jul 2019 07:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfGJFU1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 Jul 2019 01:20:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44032 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfGJFU1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 Jul 2019 01:20:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so581164plr.11
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Jul 2019 22:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5rUyUi+/bd+6qEVO/sl11sgtfPyle5F8fJNWxg2iDIg=;
        b=uKB8N6ETap6aNkS+sTFnPn4HWE6ZnQ3a7IWljWoKb6m1To9GeAGIkK0SNI9A+p0lGc
         ybG/XXTupfcuVBhLSQ6kgfssbsu9T82+XqxRvX41y2RIxETiw6DvEuAgCdSnGiOoQhSq
         teFxTJJ/FCBG8JSFybROewCfrnbid5Yozb2nPqhtwNSI7hqEJOfYxG83aBa9+9wym3p6
         noIu3wIrWISaniP4DVhQuEMkBCjssSH1JhodSn6Hmxv591WTjsmQeCdFOW4+JUkYhLAg
         07/pbrNyXRWgSFQ4PFVaOd46CQ4sIGFgmUNd8Nju3aQ7pqPFHOy/ycUZ4DfICJ9H2Neb
         Cixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5rUyUi+/bd+6qEVO/sl11sgtfPyle5F8fJNWxg2iDIg=;
        b=jochRsyLwI6G4GF9/HNpOh6ya41cYXUjz1Q3e7EpHeun7z13Q8xHswQpYZ9+CuWVXK
         RZfJwgYvLif0b03cS8Iex/4NJ5LVpfTZtKARIbjTGPLY/mPq8y+UT/iko0auT5/kTfPQ
         n3CKoTEtdGEJoR7AYwnwFRaZ35ru5Gf8/wjOADdAhJ6NsjTIt+ULMcd/nwmh2fxwE2OZ
         A0guaFbVvjJzfkjavN7XmrN+NLu86Q3Ml9wxO7BS+niQPuqemV8dZDGd1g3NywcPlRt2
         qpzAxe5zd+n4gY7cCjY+ykQFQnBU4sSVWZcCDEgJxaJyrzqLy1nB2xeErmFKRIXQuFSI
         WBHA==
X-Gm-Message-State: APjAAAXtCJC7o2F9S2bAsHpRV8iB7dtAfg3BtH2sK07SIqRyHB+sjc5y
        G94Sy6Xg3dBMc5bemiC3Qrw=
X-Google-Smtp-Source: APXvYqyBNAjrPuoGsI7fRrsFWqSydS9GzPahdqbMQBXIzD2zBI0rP093rtvFKGcIDkwhju+2uXMt+Q==
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr35291638plb.114.1562736026842;
        Tue, 09 Jul 2019 22:20:26 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id l31sm1410899pgm.63.2019.07.09.22.20.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Jul 2019 22:20:26 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, mpe@ellerman.id.au,
        david@gibson.dropbear.id.au, sjitindarsingh@gmail.com
Subject: [PATCH] powerpc: mm: Limit rma_size to 1TB when running without HV mode
Date:   Wed, 10 Jul 2019 15:20:18 +1000
Message-Id: <20190710052018.14628-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The virtual real mode addressing (VRMA) mechanism is used when a
partition is using HPT (Hash Page Table) translation and performs
real mode accesses (MSR[IR|DR] = 0) in non-hypervisor mode. In this
mode effective address bits 0:23 are treated as zero (i.e. the access
is aliased to 0) and the access is performed using an implicit 1TB SLB
entry.

The size of the RMA (Real Memory Area) is communicated to the guest as
the size of the first memory region in the device tree. And because of
the mechanism described above can be expected to not exceed 1TB. In the
event that the host erroneously represents the RMA as being larger than
1TB, guest accesses in real mode to memory addresses above 1TB will be
aliased down to below 1TB. This means that a memory access performed in
real mode may differ to one performed in virtual mode for the same memory
address, which would likely have unintended consequences.

To avoid this outcome have the guest explicitly limit the size of the
RMA to the current maximum, which is 1TB. This means that even if the
first memory block is larger than 1TB, only the first 1TB should be
accessed in real mode.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 28ced26f2a00..4d0e2cce9cd5 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1901,11 +1901,19 @@ void hash__setup_initial_memory_limit(phys_addr_t first_memblock_base,
 	 *
 	 * For guests on platforms before POWER9, we clamp the it limit to 1G
 	 * to avoid some funky things such as RTAS bugs etc...
+	 * On POWER9 we limit to 1TB in case the host erroneously told us that
+	 * the RMA was >1TB. Effective address bits 0:23 are treated as zero
+	 * (meaning the access is aliased to zero i.e. addr = addr % 1TB)
+	 * for virtual real mode addressing and so it doesn't make sense to
+	 * have an area larger than 1TB as it can't be addressed.
 	 */
 	if (!early_cpu_has_feature(CPU_FTR_HVMODE)) {
 		ppc64_rma_size = first_memblock_size;
 		if (!early_cpu_has_feature(CPU_FTR_ARCH_300))
 			ppc64_rma_size = min_t(u64, ppc64_rma_size, 0x40000000);
+		else
+			ppc64_rma_size = min_t(u64, ppc64_rma_size,
+					       1UL << SID_SHIFT_1T);
 
 		/* Finally limit subsequent allocations */
 		memblock_set_current_limit(ppc64_rma_size);
-- 
2.13.6

