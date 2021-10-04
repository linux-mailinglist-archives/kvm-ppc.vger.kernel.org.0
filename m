Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328CF421376
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhJDQES (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbhJDQEQ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0450BC061753
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t4so242467plo.0
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c2h6hidknEDcFoUX05/j1Ej4Ouz2ogn73Ns94+r0eEk=;
        b=dD75TwsVYQlxNjW1EDlQhUGoyN0jlOo8DSumQUxFoahJxXp8/4MPPZwf95QCrPCOg5
         +rqYR8KqqRmaOsxHAWBXZJtLUuD8zapKuaIzMvFKn+7aIV1emSlI/o3hcQqInWifIglg
         uP33nV2itQqwov7m80bjBinG6BFzidypSKd3le0MueteljlZqX9MCbrULoo0CsZQuvOD
         NnbRZ0dsiXBe02o21uhKI486CpWUeWEpHDU2TmkAqnti9KQGaKYW7+mjzY0eraL89hoS
         79AL356P7sAo/qRnw3tk+W6va26ko52A8Zi9TzSEl2K596O999L/VKMmtPTcHxnArNty
         AS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c2h6hidknEDcFoUX05/j1Ej4Ouz2ogn73Ns94+r0eEk=;
        b=e/T3ntFc8n4W6zAY4N/tF5ERjiyCoWE3SfUfcTc7FgnUPD2ZH9U3CZj/cpYuZ8JLnZ
         +6ByTQLVbHN3zbT0GLAm8dWRB7E5eJAUzP0aiHN4sxTklINiqW6/8+gfagdkedeDf/Mt
         pGqZYzgj7iu7rimHIASZZy1c2JMEdTXU3TfoMouRupVHahDdtDetTjtJ5gzDmLTHGRwB
         SCIWqjNoEUJhc9bx4UloMiBDKBAifg2QBs8gd3hVXgnh/0SZZo7rr9tjcuEivhBSI+YE
         pyOn0xv/sZdqI+TjyQWuH+8GSZa2ln8h61jJCXx5OHjE23uIt35On7gydpOAfWF54t2g
         yKfg==
X-Gm-Message-State: AOAM530RxIEYSvnMS+W5rwED/ZgfzywV+Hzj2YN7geYTPb0zESXgmL7m
        7GQ1vUvoCT5Vw78K0dBoFpaxhETodUE=
X-Google-Smtp-Source: ABdhPJzuLrGXs46c3TVnrZtvSmM5Np40Qc40RJxs/U84mvaQ1xhPfmn1OH7uneOvZx+5B9hYrMpkpA==
X-Received: by 2002:a17:902:8214:b0:13e:c554:6b55 with SMTP id x20-20020a170902821400b0013ec5546b55mr430735pln.80.1633363346386;
        Mon, 04 Oct 2021 09:02:26 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 35/52] KVM: PPC: Book3S HV P9: More SPR speed improvements
Date:   Tue,  5 Oct 2021 02:00:32 +1000
Message-Id: <20211004160049.1338837-36-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This avoids more scoreboard stalls and reduces mtSPRs.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 73 ++++++++++++++++-----------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 67f57b03a896..a23f09fa7d2d 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -645,24 +645,29 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = vc->tb_offset;
 	}
 
-	if (vc->pcr)
-		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
-	mtspr(SPRN_DPDES, vc->dpdes);
 	mtspr(SPRN_VTB, vc->vtb);
-
 	mtspr(SPRN_PURR, vcpu->arch.purr);
 	mtspr(SPRN_SPURR, vcpu->arch.spurr);
 
+	if (vc->pcr)
+		mtspr(SPRN_PCR, vc->pcr | PCR_MASK);
+	if (vc->dpdes)
+		mtspr(SPRN_DPDES, vc->dpdes);
+
 	if (dawr_enabled()) {
-		mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
-		mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
+		if (vcpu->arch.dawr0 != host_dawr0)
+			mtspr(SPRN_DAWR0, vcpu->arch.dawr0);
+		if (vcpu->arch.dawrx0 != host_dawrx0)
+			mtspr(SPRN_DAWRX0, vcpu->arch.dawrx0);
 		if (cpu_has_feature(CPU_FTR_DAWR1)) {
-			mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
-			mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
+			if (vcpu->arch.dawr1 != host_dawr1)
+				mtspr(SPRN_DAWR1, vcpu->arch.dawr1);
+			if (vcpu->arch.dawrx1 != host_dawrx1)
+				mtspr(SPRN_DAWRX1, vcpu->arch.dawrx1);
 		}
 	}
-	mtspr(SPRN_CIABR, vcpu->arch.ciabr);
-	mtspr(SPRN_IC, vcpu->arch.ic);
+	if (vcpu->arch.ciabr != host_ciabr)
+		mtspr(SPRN_CIABR, vcpu->arch.ciabr);
 
 	mtspr(SPRN_PSSCR, vcpu->arch.psscr | PSSCR_EC |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
@@ -881,20 +886,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	vc->dpdes = mfspr(SPRN_DPDES);
 	vc->vtb = mfspr(SPRN_VTB);
 
-	save_clear_guest_mmu(kvm, vcpu);
-	switch_mmu_to_host(kvm, host_pidr);
-
-	/*
-	 * If we are in real mode, only switch MMU on after the MMU is
-	 * switched to host, to avoid the P9_RADIX_PREFETCH_BUG.
-	 */
-	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
-			vcpu->arch.shregs.msr & MSR_TS_MASK)
-		msr |= MSR_TS_S;
-	__mtmsrd(msr, 0);
-
-	store_vcpu_state(vcpu);
-
 	dec = mfspr(SPRN_DEC);
 	if (!(lpcr & LPCR_LD)) /* Sign extend if not using large decrementer */
 		dec = (s32) dec;
@@ -912,6 +903,22 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 		vc->tb_offset_applied = 0;
 	}
 
+	save_clear_guest_mmu(kvm, vcpu);
+	switch_mmu_to_host(kvm, host_pidr);
+
+	/*
+	 * Enable MSR here in order to have facilities enabled to save
+	 * guest registers. This enables MMU (if we were in realmode), so
+	 * only switch MMU on after the MMU is switched to host, to avoid
+	 * the P9_RADIX_PREFETCH_BUG or hash guest context.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
+			vcpu->arch.shregs.msr & MSR_TS_MASK)
+		msr |= MSR_TS_S;
+	__mtmsrd(msr, 0);
+
+	store_vcpu_state(vcpu);
+
 	mtspr(SPRN_PURR, local_paca->kvm_hstate.host_purr);
 	mtspr(SPRN_SPURR, local_paca->kvm_hstate.host_spurr);
 
@@ -919,15 +926,21 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	mtspr(SPRN_PSSCR, host_psscr |
 	      (local_paca->kvm_hstate.fake_suspend << PSSCR_FAKE_SUSPEND_LG));
 	mtspr(SPRN_HFSCR, host_hfscr);
-	mtspr(SPRN_CIABR, host_ciabr);
-	mtspr(SPRN_DAWR0, host_dawr0);
-	mtspr(SPRN_DAWRX0, host_dawrx0);
+	if (vcpu->arch.ciabr != host_ciabr)
+		mtspr(SPRN_CIABR, host_ciabr);
+	if (vcpu->arch.dawr0 != host_dawr0)
+		mtspr(SPRN_DAWR0, host_dawr0);
+	if (vcpu->arch.dawrx0 != host_dawrx0)
+		mtspr(SPRN_DAWRX0, host_dawrx0);
 	if (cpu_has_feature(CPU_FTR_DAWR1)) {
-		mtspr(SPRN_DAWR1, host_dawr1);
-		mtspr(SPRN_DAWRX1, host_dawrx1);
+		if (vcpu->arch.dawr1 != host_dawr1)
+			mtspr(SPRN_DAWR1, host_dawr1);
+		if (vcpu->arch.dawrx1 != host_dawrx1)
+			mtspr(SPRN_DAWRX1, host_dawrx1);
 	}
 
-	mtspr(SPRN_DPDES, 0);
+	if (vc->dpdes)
+		mtspr(SPRN_DPDES, 0);
 	if (vc->pcr)
 		mtspr(SPRN_PCR, PCR_MASK);
 
-- 
2.23.0

