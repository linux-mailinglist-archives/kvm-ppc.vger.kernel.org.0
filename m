Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591613D51DB
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhGZDMD (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhGZDMC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A7CC061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n10so10142241plf.4
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lXIv8+mtVkMgsv+PEpjVCTZ/uwGBbTyFBO8PdcIpTk0=;
        b=EMPYL54EwTFULzHCsxaN9dj8RhCUGi3pxeswB+2CG7oKsXJ+7ZZn7y5YXq3ufooioL
         lGc/lgHe9jEaR4BmzjL9dgtpTe3S8YX/+LjVGy3onWxV47BYuBQ0Yaz9Q+b+Od60QBwA
         axWvrEHWh4R4q1w5tMi8nLSX5hyVUnkhbpSLNhWa4AU1lg/OZfNm6f+NgoctHmKjkv9J
         tfXyZ7NffhixUJqTWo4uDMtUdkrqYUJSxerikMnzVuqknbNTteKvYYJ02TB6WLqsr45l
         cCcjyF96u/7PTfeVfsT0VA3xRUoHchhx6dBTUivhCRvsmxTT9g3RthfzuP4wgDJO2Xny
         +opA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lXIv8+mtVkMgsv+PEpjVCTZ/uwGBbTyFBO8PdcIpTk0=;
        b=m2aiqcE2o+ptsTBgh6b5StmOvYXS0XWMsd4mH7fHPWHIQJhQ96z7T1MmcmuMVhqf8N
         8eZgTnToGkfxd4ToZc3Qimy9PrgNzT2/fHRMU6MhjIlb2CLgQ8ph9JNc5q01PK6dzEdt
         ctXiMDOfg43oVBWCbxiH0h851b7+fGc60wZbUsKU/QXkPtOtdMrbz/wi8HkbgwuqFpVA
         kKWRf01DJZIm4KztLUo0mnnCCJ+ld8YJJAlfn6xoe70wvvm1rCrRzD/6HvdOGSWpo4ey
         QzIvC9KP5Yv343OcuGoecdOuopaPMOXEj68aEwoY4m5GyHMInR/Cao+ntv80NX1mOhJR
         9IJw==
X-Gm-Message-State: AOAM530cJscu0/UsHFqQ3+xcjHEDulMD8PUcyMtFOApkuMbfu5Vj5d05
        hTgTI3hcqFFQr/wVNdHhNWdfqpFFIJU=
X-Google-Smtp-Source: ABdhPJwqtCO47R6gTVGnL6uw3vwhx0CNGShT1EDzg4B1ve2x0F307g9FK9O8aY1/rNRYsxXpHeYiFw==
X-Received: by 2002:aa7:874c:0:b029:39a:56d1:6d42 with SMTP id g12-20020aa7874c0000b029039a56d16d42mr2015069pfo.58.1627271551083;
        Sun, 25 Jul 2021 20:52:31 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:30 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 46/55] KVM: PPC: Book3S HV P9: Avoid tlbsync sequence on radix guest exit
Date:   Mon, 26 Jul 2021 13:50:27 +1000
Message-Id: <20210726035036.739609-47-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Use the existing TLB flushing logic to IPI the previous CPU and run the
necessary barriers before running a guest vCPU on a new physical CPU,
to do the necessary radix GTSE barriers for handling the case of an
interrupted guest tlbie sequence.

This results in more IPIs than the TLB flush logic requires, but it's
a significant win for common case scheduling when the vCPU remains on
the same physical CPU.

-522 cycles (5754) POWER9 virt-mode NULL hcall

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c          | 31 +++++++++++++++++++++++----
 arch/powerpc/kvm/book3s_hv_p9_entry.c |  9 --------
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index a37ab798eb7c..3e5c6b745394 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3005,6 +3005,25 @@ static void radix_flush_cpu(struct kvm *kvm, int cpu, struct kvm_vcpu *vcpu)
 			smp_call_function_single(i, do_nothing, NULL, 1);
 }
 
+static void do_migrate_away_vcpu(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	struct kvm *kvm = vcpu->kvm;
+
+	/*
+	 * If the guest has GTSE, it may execute tlbie, so do a eieio; tlbsync;
+	 * ptesync sequence on the old CPU before migrating to a new one, in
+	 * case we interrupted the guest between a tlbie ; eieio ;
+	 * tlbsync; ptesync sequence.
+	 *
+	 * Otherwise, ptesync is sufficient.
+	 */
+	if (kvm->arch.lpcr & LPCR_GTSE)
+		asm volatile("eieio; tlbsync; ptesync");
+	else
+		asm volatile("ptesync");
+}
+
 static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 {
 	struct kvm_nested_guest *nested = vcpu->arch.nested;
@@ -3032,10 +3051,14 @@ static void kvmppc_prepare_radix_vcpu(struct kvm_vcpu *vcpu, int pcpu)
 	 * so we use a single bit in .need_tlb_flush for all 4 threads.
 	 */
 	if (prev_cpu != pcpu) {
-		if (prev_cpu >= 0 &&
-		    cpu_first_tlb_thread_sibling(prev_cpu) !=
-		    cpu_first_tlb_thread_sibling(pcpu))
-			radix_flush_cpu(kvm, prev_cpu, vcpu);
+		if (prev_cpu >= 0) {
+			if (cpu_first_tlb_thread_sibling(prev_cpu) !=
+			    cpu_first_tlb_thread_sibling(pcpu))
+				radix_flush_cpu(kvm, prev_cpu, vcpu);
+
+			smp_call_function_single(prev_cpu,
+					do_migrate_away_vcpu, vcpu, 1);
+		}
 		if (nested)
 			nested->prev_cpu[vcpu->arch.nested_vcpu_id] = pcpu;
 		else
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 52690af66ca9..1bb81be09d4f 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -1039,15 +1039,6 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 
 	local_paca->kvm_hstate.in_guest = KVM_GUEST_MODE_NONE;
 
-	if (kvm_is_radix(kvm)) {
-		/*
-		 * Since this is radix, do a eieio; tlbsync; ptesync sequence
-		 * in case we interrupted the guest between a tlbie and a
-		 * ptesync.
-		 */
-		asm volatile("eieio; tlbsync; ptesync");
-	}
-
 	/*
 	 * cp_abort is required if the processor supports local copy-paste
 	 * to clear the copy buffer that was under control of the guest.
-- 
2.23.0

