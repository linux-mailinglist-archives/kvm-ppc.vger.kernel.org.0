Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4B93519EB
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhDAR45 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 13:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbhDARwb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 1 Apr 2021 13:52:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D49C00F7C6
        for <kvm-ppc@vger.kernel.org>; Thu,  1 Apr 2021 08:05:27 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v10so1680194pfn.5
        for <kvm-ppc@vger.kernel.org>; Thu, 01 Apr 2021 08:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5fNmtzqht80cGykBgqYZ3mo5Aw4QFt+HIs8nI/NOKw=;
        b=F/yFcSMlnu3Iqfcaj5GGDh6etp62rZlPCp0syFoBpFGfuW1OYPWOLNRJJ0S5LVe7w4
         8XuyJNQkXC7RLIFngC3mSgx0Bh/znlc/nL/P+o1N3ZVfYNM+kB7IEzxfCwOeBVYF6eoF
         G83gQvEj+AWcJv/yZy8fR14EhKjEVI2lqK11kimOvd+1DZ5HcYHfB2BjVVqKAER8Q8wI
         to45O86mABPIZ2FJNDdIbph+0i3SZwCAK8BbDa0A9zO8n93Enx2MQaT2cdgQjEdkOvPs
         8SUTe/DjGmBu/ldBkzFBdvrcqgfMCYjLUPIFIIAn7UBT+L1ouBDGQlvRcpGUQdDDyqUv
         mbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5fNmtzqht80cGykBgqYZ3mo5Aw4QFt+HIs8nI/NOKw=;
        b=hdn/CTr3tYXAvLyOYVMff5SoN2TVR3sHu2b1qrs1V3FgIwSk7MPxdNMFYPIfuPgLQz
         00F2i/+3q4qn4GG9tRAvLfv5RJ789+GM/Qhuro/yUxJVfVTZaaE5hb6FvPotmywrXxMb
         QKhwng132iEvKTP3PBHeimO5OWDO/drJ3bFtuMgZsgEdvyBnAbxZrfPfKCJSfQDj5Y5x
         SZ0U/16VPkPWCPhVna3PFdbqzPAz+WGmNQMQ5Os4vV8tPlQXrfe32z9009cx+OueNPlM
         p1ng9Qwg6N5mpiGBX3AoR0fhAJod6u7hmJqpzaiPUFKWlMh1LFxhy2bJTiP+g0N0cBOD
         y+9Q==
X-Gm-Message-State: AOAM5331StQEAAZXVSxTkM0kn6goqz4mkfUxzI3oHqwVumyEe3706LaZ
        z4DBi0hrtaGZKBvptNsGZeb/31L4B4o=
X-Google-Smtp-Source: ABdhPJxk5C9Sfw2Gb2LGCgt2JRNom+kU9QUFHZbadaeP1FJfUDY5i10wd8qepcX+C/VLFtDFsYSjRQ==
X-Received: by 2002:a62:2c12:0:b029:22b:2c97:15a0 with SMTP id s18-20020a622c120000b029022b2c9715a0mr8121227pfs.77.1617289526686;
        Thu, 01 Apr 2021 08:05:26 -0700 (PDT)
Received: from bobo.ibm.com ([1.128.218.207])
        by smtp.gmail.com with ESMTPSA id l3sm5599632pju.44.2021.04.01.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 08:05:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v5 36/48] KVM: PPC: Book3S HV P9: Switch to guest MMU context as late as possible
Date:   Fri,  2 Apr 2021 01:03:13 +1000
Message-Id: <20210401150325.442125-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210401150325.442125-1-npiggin@gmail.com>
References: <20210401150325.442125-1-npiggin@gmail.com>
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
index 29e2ae04b8d5..4f3edf68d97b 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -149,8 +149,13 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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
@@ -199,26 +204,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
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
 
@@ -237,6 +222,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
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

