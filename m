Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE89C42134E
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhJDQDL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhJDQDK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:03:10 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9542AC061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:21 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id r2so16968017pgl.10
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6PeeoMt4W4XFn9V2VfFg4Edyu34SbX1NSkfz7A99z94=;
        b=lAVDfCEPocM8um2kUJzsls5OFEbkcHeWvtz99SsEikKpioduRotj/qOTgvc9L7Oi6b
         eaYbNrAxf3Z1e1JpJ+o1pp4J3DGxMiUeCdA1QCURdsYCoq+T6RTKZxz+1yRcodbEFVb8
         7LSwCb+Y6huuB20ZE2spNNx+keSsrShU/keBRhJMZTjopgDcgde/Smm2VE2O5Os8uYjw
         1nh2B8FbnXrKMyvcH/TvJKmXn43/WLD+RyJOKa5P+GL3pXdn8Qf7f7YRMxmXN7UIAWfX
         4oTunS9RckNoGZc4AxDBL6kn7kdxklc6cvhE9ceOyeuhq0Neg8zoqPJFqzkiSB0EK6Cw
         zkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6PeeoMt4W4XFn9V2VfFg4Edyu34SbX1NSkfz7A99z94=;
        b=Sh0lZmyz8K3X4Dk58jF1smtfbpKjbbdoRjuW+7oePvxXD4kf1eWKYNI5zCJ1qKkApu
         8FMbkrHIqidD4b7urQB/ZftVqjpwqCuKbw5zxMOB+1fC9TB/QOW5vi/eq6c80ZJtEArs
         OIc2jBDicxqqdzp2tOIp+eVe2GBc6DtsL8+mb48OBx96nh3wf04zRnYVJalYsbk0zypZ
         aY6m9dqN5lqaOx4598Lb+9S2l+gQTiBJQtO8Z7JVgQmViTAXWyBcfeer/T3dsJ0TlTtc
         WDR/CUKQ8yMVbauCVWgo57Yoik3uzjrmYZKuve4qrCegC9i6918umyW8WlDfBNxS7njO
         UquQ==
X-Gm-Message-State: AOAM531fHPw1XcAvZklQa0YtMPvkWaMMFdJTrZLiRED1TGlsv7Tv7TgR
        hKV5R6C5Vh5mrYW9ES94L7Pi5cdEaLI=
X-Google-Smtp-Source: ABdhPJzFi8aVzvJ0az0svpFGY4o9SjVSZ3fjMU+6MJlYUE22BC3r6kMNvuLjEeOCIuNRfljIABI87w==
X-Received: by 2002:a63:e10:: with SMTP id d16mr11465052pgl.438.1633363280995;
        Mon, 04 Oct 2021 09:01:20 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: [PATCH v3 08/52] KVM: PPC: Book3S HV: POWER10 enable HAIL when running radix guests
Date:   Tue,  5 Oct 2021 02:00:05 +1000
Message-Id: <20211004160049.1338837-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

HV interrupts may be taken with the MMU enabled when radix guests are
running. Enable LPCR[HAIL] on ISA v3.1 processors for radix guests.
Make this depend on the host LPCR[HAIL] being enabled. Currently that is
always enabled, but having this test means any issue that might require
LPCR[HAIL] to be disabled in the host will not have to be duplicated in
KVM.

This optimisation takes 1380 cycles off a NULL hcall entry+exit micro
benchmark on a POWER10.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index e83c7aa7dbba..463534402107 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5047,6 +5047,8 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
  */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
+
 	if (nesting_enabled(kvm))
 		kvmhv_release_all_nested(kvm);
 	kvmppc_rmap_reset(kvm);
@@ -5056,8 +5058,13 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 	kvm->arch.radix = 0;
 	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_radix(kvm);
-	kvmppc_update_lpcr(kvm, LPCR_VPM1,
-			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
+
+	lpcr = LPCR_VPM1;
+	lpcr_mask = LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		lpcr_mask |= LPCR_HAIL;
+	kvmppc_update_lpcr(kvm, lpcr, lpcr_mask);
+
 	return 0;
 }
 
@@ -5067,6 +5074,7 @@ int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
  */
 int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 {
+	unsigned long lpcr, lpcr_mask;
 	int err;
 
 	err = kvmppc_init_vm_radix(kvm);
@@ -5078,8 +5086,17 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 	kvm->arch.radix = 1;
 	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_hpt(&kvm->arch.hpt);
-	kvmppc_update_lpcr(kvm, LPCR_UPRT | LPCR_GTSE | LPCR_HR,
-			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
+
+	lpcr = LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	lpcr_mask = LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+	if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+		lpcr_mask |= LPCR_HAIL;
+		if (cpu_has_feature(CPU_FTR_HVMODE) &&
+				(kvm->arch.host_lpcr & LPCR_HAIL))
+			lpcr |= LPCR_HAIL;
+	}
+	kvmppc_update_lpcr(kvm, lpcr, lpcr_mask);
+
 	return 0;
 }
 
@@ -5243,6 +5260,10 @@ static int kvmppc_core_init_vm_hv(struct kvm *kvm)
 		kvm->arch.mmu_ready = 1;
 		lpcr &= ~LPCR_VPM1;
 		lpcr |= LPCR_UPRT | LPCR_GTSE | LPCR_HR;
+		if (cpu_has_feature(CPU_FTR_HVMODE) &&
+		    cpu_has_feature(CPU_FTR_ARCH_31) &&
+		    (kvm->arch.host_lpcr & LPCR_HAIL))
+			lpcr |= LPCR_HAIL;
 		ret = kvmppc_init_vm_radix(kvm);
 		if (ret) {
 			kvmppc_free_lpid(kvm->arch.lpid);
-- 
2.23.0

