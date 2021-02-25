Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC69C3250F1
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhBYNtu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBYNtq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:49:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E4DC061793
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:49:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d12so1108992pfo.7
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/d8HsRevOUAthNw1fJ9lQVtVP6HhjoYaa+NO0SoIY3c=;
        b=M2IA6lAXNli1kQg+PS6A/2dAZxaIQ3h50JKVW0pDdSSnm2OgTFr0UinELigHncu6vb
         rx6umZeJ0/v2NA3svwU7JHJ/hr/su59OXdh2+q0maBRejgMz42m99o/PdlMrH/SfUJ0n
         JUMmwgZr0nFYknRklSq+zA2RxFlsxr/WUfxPpozxWQ1rYRcSs2u1nPCBMwy/jhQFhaMk
         arGzIP5Ct4btdKarOx1Mx9qk7746mpkYTDhXktGyvLLHQm8HeRgS3Dr6Ofx8lXN+x6j9
         9zYFFF1ZfzMkhRi6nZRW5Rw034g/d9ywe7R2hZIc6rM5Df8jKd79s3A8Z3zwN6QbEZzW
         OKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/d8HsRevOUAthNw1fJ9lQVtVP6HhjoYaa+NO0SoIY3c=;
        b=R48f0mbSraXL0/pmH966ofK99bIAu50ceCtZL/IpW7fnTpNFnMuf4Mifvj8aUtNvcM
         b5mGjsQhEQtARTCAjVE0ZvCEoOGqteLjAW+J8yklnfeq2FQhpz6vMvFeds86iyqHMgkq
         MS65iW4mRs8XihLPXRsEsq6CLcUvhGkVc4O9VzXX0jly8un5QrQL5/B2DseQabaixCqZ
         vUL0EMU1tHzJ8YwJ2AE7X2lnGHhhzM6Z7GaKn1dUA0aPyllTjwScN6kcDVhWbWCGgmq6
         +3wJ9AcBXFFIMi8QZgEmWuqMkx428OTmFVjOwOyUN7JyWYqSr+BLK0qYzfbaC1j1Ycgx
         NGvw==
X-Gm-Message-State: AOAM532Aeauy9/8D9fnR6N5rQl98OBvWJeggKYFbcZEBHNOfHdJmFWxu
        LFucUyj35BdOvzpxUfoN7t5tvN8JSqg=
X-Google-Smtp-Source: ABdhPJx9GutxHKPn6nwNeeltugDeXxOtwMZO1Xkh8v+cvO3T43BAiOeR/hDF3Ae4FQVT1rax4dOQjQ==
X-Received: by 2002:a05:6a00:22ca:b029:1ed:f915:ca98 with SMTP id f10-20020a056a0022cab02901edf915ca98mr3317549pfj.68.1614260944724;
        Thu, 25 Feb 2021 05:49:04 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:49:04 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 36/37] KVM: PPC: Book3S HV P9: implement hash host / hash guest support
Date:   Thu, 25 Feb 2021 23:46:51 +1000
Message-Id: <20210225134652.2127648-37-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c           |  2 +-
 arch/powerpc/kvm/book3s_hv_interrupt.c | 75 ++++++++++++++++----------
 2 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 97320531f37c..10d5c7ea80ca 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4403,7 +4403,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		 * The TLB prefetch bug fixup is only in the kvmppc_run_vcpu
 		 * path, which also handles hash and dependent threads mode.
 		 */
-		if (radix_enabled())
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
 			r = kvmhv_run_single_vcpu(vcpu, ~(u64)0,
 						  vcpu->arch.vcore->lpcr);
 		else
diff --git a/arch/powerpc/kvm/book3s_hv_interrupt.c b/arch/powerpc/kvm/book3s_hv_interrupt.c
index d79c6f4f330c..af4772755e5d 100644
--- a/arch/powerpc/kvm/book3s_hv_interrupt.c
+++ b/arch/powerpc/kvm/book3s_hv_interrupt.c
@@ -140,12 +140,51 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 }
 
 
-static void switch_mmu_to_host_radix(struct kvm *kvm, u32 pid)
+static void switch_mmu_to_host(struct kvm *kvm, u32 pid)
 {
 	mtspr(SPRN_PID, pid);
 	mtspr(SPRN_LPID, kvm->arch.host_lpid);
 	mtspr(SPRN_LPCR, kvm->arch.host_lpcr);
 	isync();
+
+	/* XXX: could save and restore host SLBs to reduce SLB faults */
+	if (!radix_enabled())
+		slb_restore_bolted_realmode();
+}
+
+static void save_host_mmu(struct kvm *kvm)
+{
+	if (!radix_enabled()) {
+		mtslb(0, 0, 0);
+		slb_invalidate(6);
+	}
+}
+
+static void save_guest_mmu(struct kvm *kvm, struct kvm_vcpu *vcpu)
+{
+	if (kvm_is_radix(kvm)) {
+		radix_clear_slb();
+	} else {
+		int i;
+		int nr = 0;
+
+		/*
+		 * This must run before switching to host (radix host can't
+		 * access all SLBs).
+		 */
+		for (i = 0; i < vcpu->arch.slb_nr; i++) {
+			u64 slbee, slbev;
+			mfslb(i, &slbee, &slbev);
+			if (slbee & SLB_ESID_V) {
+				vcpu->arch.slb[nr].orige = slbee | i;
+				vcpu->arch.slb[nr].origv = slbev;
+				nr++;
+			}
+		}
+		vcpu->arch.slb_max = nr;
+		mtslb(0, 0, 0);
+		slb_invalidate(6);
+	}
 }
 
 int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpcr)
@@ -252,15 +291,16 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	mtspr(SPRN_AMOR, ~0UL);
 
+	if (!radix_enabled() || !kvm_is_radix(kvm) || cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
+		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
+
+	save_host_mmu(kvm);
 	if (kvm_is_radix(kvm)) {
-		if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
-			__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_radix(kvm, vcpu, lpcr);
 		if (!cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
 			__mtmsrd(0, 1); /* clear RI */
 
 	} else {
-		__mtmsrd(msr & ~(MSR_IR|MSR_DR|MSR_RI), 0);
 		switch_mmu_to_guest_hpt(kvm, vcpu, lpcr);
 	}
 
@@ -437,31 +477,8 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	/* HDEC must be at least as large as DEC, so decrementer_max fits */
 	mtspr(SPRN_HDEC, decrementer_max);
 
-	if (kvm_is_radix(kvm)) {
-		radix_clear_slb();
-	} else {
-		int i;
-		int nr = 0;
-
-		/*
-		 * This must run before switching to host (radix host can't
-		 * access all SLBs).
-		 */
-		for (i = 0; i < vcpu->arch.slb_nr; i++) {
-			u64 slbee, slbev;
-			mfslb(i, &slbee, &slbev);
-			if (slbee & SLB_ESID_V) {
-				vcpu->arch.slb[nr].orige = slbee | i;
-				vcpu->arch.slb[nr].origv = slbev;
-				nr++;
-			}
-		}
-		vcpu->arch.slb_max = nr;
-		mtslb(0, 0, 0);
-		slb_invalidate(6);
-	}
-
-	switch_mmu_to_host_radix(kvm, host_pidr);
+	save_guest_mmu(kvm, vcpu);
+	switch_mmu_to_host(kvm, host_pidr);
 
 	/*
 	 * If we are in real mode, don't switch MMU on until the MMU is
-- 
2.23.0

