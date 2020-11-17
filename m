Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680032B6590
	for <lists+kvm-ppc@lfdr.de>; Tue, 17 Nov 2020 14:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgKQN4a (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Nov 2020 08:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731995AbgKQN42 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Nov 2020 08:56:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02AC0613CF
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Nov 2020 05:56:27 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 62so16111535pgg.12
        for <kvm-ppc@vger.kernel.org>; Tue, 17 Nov 2020 05:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4SJB4YbRl5B4MeSiy1HFdk1USDyn/nEsoq1u8bjNIo=;
        b=PmLjpiBQuy/dWIkb1kpYuV9XtHFFZg7Qosc6YZ7mcWTdXLIU5CkkVhg5D0YEIxdlHK
         OcatU2VPPlZZlpDD1Lr310UjbB5FY93+H8/wBBswbWW95RD8esZ87r3PvFk/GAvGEAzX
         rG3iBZSoFnKzYgcBFpOnn406iiWWjufjS8a3GxnvZudS64WggpxyLFbdcELenjNwB8uS
         TIs/llb+TmzETNqfbUOvUjrJUyckPbaVFno354a4uR4RSg/pAL5agi7XJCGAOV5SiCTD
         n7heo1oQApPtB8gEwvSK+8dgKc57SjC776RnJtS4OvRxCZA8nzkf+unikxZwjsn35Btp
         JIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t4SJB4YbRl5B4MeSiy1HFdk1USDyn/nEsoq1u8bjNIo=;
        b=tvC0qTjhTF5x8XwdHkQnkKVNM/Gwn1gH3A1LNTD8MN38yWYJOuUOWuIvP8wD3b1RLD
         Z19izY4eO+BLwxlNHqbnL4+8AJZM0FUvnmSkF/yQLGo96bAbVAXPiCr+wuwbubaYNr+H
         1ccgC7N0wAeh+5TJc4IySGoxt+73b4O2xL4j33nt1Z/V9PMB5Fkm1QGa4fcLVrX/vCGv
         o9pw+xCucR4z9d/T6+5MHWeh1H06KufPJ6JdjNocnJ5mxrK0QNJ9RTM9BCOoTlL4O0sa
         OigYZA1B2tEp1g1zkxGKC9WDHj2Ox/mD0ZpvENpN9E6bXd+TWzbUHi56kyFvZ7RJo91E
         dn4Q==
X-Gm-Message-State: AOAM532eEuKUVprV2EAm5tWwlDxw+BzXLZ5Mgj+43OwwHlDapoTSqmG8
        z4+5sDDffV5CDR5PRsNRGFBkR5YI7SU=
X-Google-Smtp-Source: ABdhPJyECMDo82Nu+OwdOhisuYPhda2UPM3DJ35r6/6BMeDv9ttUKUrgGuVVUsfsHJqHqPkDFGk8ew==
X-Received: by 2002:a63:cc50:: with SMTP id q16mr3790165pgi.246.1605621386711;
        Tue, 17 Nov 2020 05:56:26 -0800 (PST)
Received: from bobo.ozlabs.ibm.com (27-32-36-31.tpgi.com.au. [27.32.36.31])
        by smtp.gmail.com with ESMTPSA id q12sm21965535pfc.84.2020.11.17.05.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:56:26 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Subject: [PATCH] powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context
Date:   Tue, 17 Nov 2020 23:56:17 +1000
Message-Id: <20201117135617.3521127-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Commit 2284ffea8f0c ("powerpc/64s/exception: Only test KVM in SRR
interrupts when PR KVM is supported") removed KVM guest tests from
interrupts that do not set HV=1, when PR-KVM is not configured.

This is wrong for HV-KVM HPT guest MMIO emulation case which attempts
to load the faulting instruction word with MSR[DR]=1 and MSR[HV]=1 with
the guest MMU context loaded. This can cause host DSI, DSLB interrupts
which must test for KVM guest. Restore this and add a comment.

Fixes: 2284ffea8f0c ("powerpc/64s/exception: Only test KVM in SRR interrupts when PR KVM is supported")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/exceptions-64s.S | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index f7d748b88705..b67892e2c9f5 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1412,6 +1412,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
  *   If none is found, do a Linux page fault. Linux page faults can happen in
  *   kernel mode due to user copy operations of course.
  *
+ *   KVM: The KVM HDSI handler may perform a load with MSR[DR]=1 in guest
+ *   MMU context, which may cause a DSI in the host, which must go to the
+ *   KVM handler. MSR[IR] is not enabled, so the real-mode handler will
+ *   always be used regardless of AIL setting.
+ *
  * - Radix MMU
  *   The hardware loads from the Linux page table directly, so a fault goes
  *   immediately to Linux page fault.
@@ -1422,10 +1427,8 @@ INT_DEFINE_BEGIN(data_access)
 	IVEC=0x300
 	IDAR=1
 	IDSISR=1
-#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 	IKVM_SKIP=1
 	IKVM_REAL=1
-#endif
 INT_DEFINE_END(data_access)
 
 EXC_REAL_BEGIN(data_access, 0x300, 0x80)
@@ -1464,6 +1467,8 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
  *   ppc64_bolted_size (first segment). The kernel handler must avoid stomping
  *   on user-handler data structures.
  *
+ *   KVM: Same as 0x300, DSLB must test for KVM guest.
+ *
  * A dedicated save area EXSLB is used (XXX: but it actually need not be
  * these days, we could use EXGEN).
  */
@@ -1472,10 +1477,8 @@ INT_DEFINE_BEGIN(data_access_slb)
 	IAREA=PACA_EXSLB
 	IRECONCILE=0
 	IDAR=1
-#ifdef CONFIG_KVM_BOOK3S_PR_POSSIBLE
 	IKVM_SKIP=1
 	IKVM_REAL=1
-#endif
 INT_DEFINE_END(data_access_slb)
 
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x80)
-- 
2.23.0

