Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB2332EDE9
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Mar 2021 16:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCEPJR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 5 Mar 2021 10:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhCEPIr (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 5 Mar 2021 10:08:47 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A854FC061574
        for <kvm-ppc@vger.kernel.org>; Fri,  5 Mar 2021 07:08:47 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 192so2397817pfv.0
        for <kvm-ppc@vger.kernel.org>; Fri, 05 Mar 2021 07:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S/DUE40RK4gU0/+NVZijbFIZ6kbSjf09QK2Bu2ltn+w=;
        b=oUdmbY8Fzor1N4SEFg41h8+9pu0Kr2PQCf605rR21tCsA+uLTwlmMQl2SYjGDLGfJ7
         94Y3PKd2xkjxwkB3+eW5fOiTz+/9mDIqxV1LxE2Mo9YroIsXRG9vokev2qR+9n9SjaQ5
         YDw+jOR9RXVtbdNNZ0euJkgOgKlo95DtTyRbo+prUro04j3vVSTfzD3wahJwzVMXK3BC
         4bFb1G3vaUL2iLjQox+EA/yiyAagNwjBR4dchE8YpQ5f0aLx2vtZ3w0cAXqW8bgfK3m8
         zc+K6e57V85jLp/3ocdmLRKMaVQC8M+P6JMUTtWlwWOt8JfpGftHW0qEu7BrLhfq/FPB
         899A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S/DUE40RK4gU0/+NVZijbFIZ6kbSjf09QK2Bu2ltn+w=;
        b=kVV/igoQGKJytxor2+kWFVlaoLxeB2pn5/ZXTL/Ma2KIXF/inm3WfR7HUkl0PGMLCP
         6gcq2D4umH0NhaVPtx1BuTY9wIF/JUXDngDH3q022K5srCZX7FmgGkSRK/XLAmus8Smp
         650FmqXBeRHJgrEQTBL9wxqi6bGV4RXts0L1jgj3Hkkkwa7CRJsCUn/uIMIrTwr506Zc
         /sIbUylBz0o0Ibx2Fn+BZHuoVdwr+0AEWtcC+rxukDsGgpuaRygcrq/EAHj/dzZ64obz
         wOfsnaLguh+B3FpzBFVkeE4X7/p2OVkaauQrU3H0yYuTrq0M5Ms8TCmBqIl2WTkFOjn/
         KjsA==
X-Gm-Message-State: AOAM531VEMiO1O2ogmWy/aVF9YAg+rPEf542WThPryKZ5oMn2e1yqYwd
        +0/IhUcEvS578O9O88zv851B44Gm1lw=
X-Google-Smtp-Source: ABdhPJzc9DRMywKc8PWIT5AaYjMv0CwZfqYKBDMFwZVs2iKnfSdC3ddIT2FmD2FEH55xhF3NUW+0hQ==
X-Received: by 2002:a05:6a00:1356:b029:1ca:9a78:b2ae with SMTP id k22-20020a056a001356b02901ca9a78b2aemr9231677pfu.64.1614956926879;
        Fri, 05 Mar 2021 07:08:46 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id m5sm1348982pfd.96.2021.03.05.07.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:08:45 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 32/41] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Sat,  6 Mar 2021 01:06:29 +1000
Message-Id: <20210305150638.2675513-33-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210305150638.2675513-1-npiggin@gmail.com>
References: <20210305150638.2675513-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Move MMU context switch as late as reasonably possible to minimise code
running with guest context switched in. This becomes more important when
this code may run in real-mode, with later changes.

Move WARN_ON as early as possible so program check interrupts are less
likely to tangle everything up.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_interrupt.c | 40 +++++++++++++-------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index d81aef6c69d9..48e07cd1b46c 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -143,8 +143,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	if (hdec < 0)
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 
+	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
+	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
+
 	start_timing(vcpu, &vcpu->arch.rm_entry);
 
+	vcpu->arch.ceded = 0;
+
 	if (vc->tb_offset) {
 		u64 new_tb = tb + vc->tb_offset;
 		mtspr(SPRN_TBU40, new_tb);
@@ -193,26 +198,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_HFSCR, vcpu->arch.hfscr);
 
-	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
-	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
-	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
-	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
-
-	mtspr(SPRN_AMOR, ~0UL);
-
-	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
-
-	/*
-	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
-	 * so set guest LPCR (with HDICE) before writing HDEC.
-	 */
-	mtspr(SPRN_HDEC, hdec);
-
-	vcpu->arch.ceded = 0;
-
-	WARN_ON_ONCE(vcpu->arch.shregs.msr & MSR_HV);
-	WARN_ON_ONCE(!(vcpu->arch.shregs.msr & MSR_ME));
-
 	mtspr(SPRN_HSRR0, vcpu->arch.regs.nip);
 	mtspr(SPRN_HSRR1, (vcpu->arch.shregs.msr & ~MSR_HV) | MSR_ME);
 
@@ -231,6 +216,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 */
 	mtspr(SPRN_HDSISR, HDSISR_CANARY);
 
+	mtspr(SPRN_SPRG0, vcpu->arch.shregs.sprg0);
+	mtspr(SPRN_SPRG1, vcpu->arch.shregs.sprg1);
+	mtspr(SPRN_SPRG2, vcpu->arch.shregs.sprg2);
+	mtspr(SPRN_SPRG3, vcpu->arch.shregs.sprg3);
+
+	mtspr(SPRN_AMOR, ~0UL);
+
+	switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
+
+	/*
+	 * P9 suppresses the HDEC exception when LPCR[HDICE] = 0,
+	 * so set guest LPCR (with HDICE) before writing HDEC.
+	 */
+	mtspr(SPRN_HDEC, hdec);
+
 	__mtmsrd(0, 1); /* clear RI */
 
 	mtspr(SPRN_DAR, vcpu->arch.shregs.dar);
-- 
2.23.0

