Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0AA2513A4
	for <lists+kvm-ppc@lfdr.de>; Tue, 25 Aug 2020 09:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgHYHzr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 25 Aug 2020 03:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgHYHzp (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 25 Aug 2020 03:55:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFCCC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 25 Aug 2020 00:55:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y206so6669328pfb.10
        for <kvm-ppc@vger.kernel.org>; Tue, 25 Aug 2020 00:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xWZCcKXp7dQkLY1ua1N7VSvKv+b8YJkHyth4+PNi84E=;
        b=WzLcj8UvBir/fg2DWzThgI9VWnwFAbE0SDTvc/ZiOVRoPJX+Q67bzfhP/0T7lC5gAm
         z/97UrVQ/iJ/1pTiPD72shcvMX4G2r867cPp5Ezib3VX074fiQxFPZShBQSO78gGk0oC
         uOHa0PdRQ/5m3aMxkZSsNHwSQHL1pwh0/x1QBAfvslMHkMfDKTXUhEHEyptmC6Q0gNWR
         mcVQiXl4lqaSVo/ltgbeGPrFVNUk2KFciSAozFNnAX0sczVHFWd2GJEcNYTB8mRIZqiq
         YPIuPqDIGR2lnF5TrtQ04qgpRrbIb1Lz4QSpGsBNGlvd4douwRt/Sk9AEjtr2WLurFVW
         SfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xWZCcKXp7dQkLY1ua1N7VSvKv+b8YJkHyth4+PNi84E=;
        b=O54crB9Z9Vfft7cihJXCeHjXEWI67y9Jcm72vf/gAVHimS02dxnCuVlxS+rQD9RnVf
         Nc6yLCXnbe5g9i9sHOUqyOMJ8DyD5X2qDwSsRoGmyA2yXnd9C+k0unnwCKILtLe9rt8A
         w2yJsXwDyDjUXB/RuZYNWv4FdSYT+Ig5JOz6S3qheoLVaff0OxcI4CcERZo+2v/vvlQ3
         lPGu04Scw6qZEHescsgfvOliyOkRK8fOaZoP/jmlr/C1LXbFDIrx7R+K+cYshZFgmobI
         epafxwjI5e+NWJXcAJnLC58/nKUytMxZGMkE4TKrzvIs5BIykqq+W+g2xMd+/OOEJg02
         bxag==
X-Gm-Message-State: AOAM533Dj6bUUem4dBULrP2Wc+6JVOe9D/2aDTlWb2tKeqhhD8ef1xWT
        41TECluiZ1mJH44BTgaQQ2M=
X-Google-Smtp-Source: ABdhPJzf+BaXZmZz+oBdRtibxl2pb0ox4A4t3T7MMCXGbbK+TiqjEgQT0VCLsFW65M/6iBDdvL8CGw==
X-Received: by 2002:a63:ef47:: with SMTP id c7mr5778379pgk.249.1598342144450;
        Tue, 25 Aug 2020 00:55:44 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (61-68-212-105.tpgi.com.au. [61.68.212.105])
        by smtp.gmail.com with ESMTPSA id z1sm1802577pjn.34.2020.08.25.00.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 00:55:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH] powerpc/64s: handle ISA v3.1 local copy-paste context switches
Date:   Tue, 25 Aug 2020 17:55:35 +1000
Message-Id: <20200825075535.224536-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

The ISA v3.1 the copy-paste facility has a new memory move functionality
which allows the copy buffer to be pasted to domestic memory (RAM) as
opposed to foreign memory (accelerator).

This means the POWER9 trick of avoiding the cp_abort on context switch if
the process had not mapped foreign memory does not work on POWER10. Do the
cp_abort unconditionally there.

KVM must also cp_abort on guest exit to prevent copy buffer state leaking
between contexts.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kernel/process.c           | 16 +++++++++-------
 arch/powerpc/kvm/book3s_hv.c            |  7 +++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  8 ++++++++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 016bd831908e..1a572c811ca5 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1250,15 +1250,17 @@ struct task_struct *__switch_to(struct task_struct *prev,
 		restore_math(current->thread.regs);
 
 		/*
-		 * The copy-paste buffer can only store into foreign real
-		 * addresses, so unprivileged processes can not see the
-		 * data or use it in any way unless they have foreign real
-		 * mappings. If the new process has the foreign real address
-		 * mappings, we must issue a cp_abort to clear any state and
-		 * prevent snooping, corruption or a covert channel.
+		 * On POWER9 the copy-paste buffer can only paste into
+		 * foreign real addresses, so unprivileged processes can not
+		 * see the data or use it in any way unless they have
+		 * foreign real mappings. If the new process has the foreign
+		 * real address mappings, we must issue a cp_abort to clear
+		 * any state and prevent snooping, corruption or a covert
+		 * channel. ISA v3.1 supports paste into local memory.
 		 */
 		if (current->mm &&
-			atomic_read(&current->mm->context.vas_windows))
+			(cpu_has_feature(CPU_FTR_ARCH_31) ||
+			atomic_read(&current->mm->context.vas_windows)))
 			asm volatile(PPC_CP_ABORT);
 	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4ba06a2a306c..3bd3118c7633 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3530,6 +3530,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 */
 	asm volatile("eieio; tlbsync; ptesync");
 
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		asm volatile(PPC_CP_ABORT);
+
 	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
 	isync();
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 799d6d0f4ead..cd9995ee8441 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1830,6 +1830,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_RADIX_PREFETCH_BUG)
 2:
 #endif /* CONFIG_PPC_RADIX_MMU */
 
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+BEGIN_FTR_SECTION
+	PPC_CP_ABORT
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_31)
+
 	/*
 	 * POWER7/POWER8 guest -> host partition switch code.
 	 * We don't have to lock against tlbies but we do
-- 
2.23.0

