Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB3735E05C
	for <lists+kvm-ppc@lfdr.de>; Tue, 13 Apr 2021 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245433AbhDMNnE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 13 Apr 2021 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbhDMNnA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 13 Apr 2021 09:43:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA4BC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:40 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r13so4699579pjf.2
        for <kvm-ppc@vger.kernel.org>; Tue, 13 Apr 2021 06:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5DdIb7caJKIVHR38EDEC3oy5CdMMDVm1Jnwd54EA0OE=;
        b=Zc1rpsmepHixbpGPdvl3C7xqe+seW/GCoFmahZd+nUAD59TN5iVH6daSR+jGW9DB4D
         UzKHAbXllfuBrxpYlSqN+/x2PjuKFcONRJ3DJvGU6EXLakzbIXugWWB9VokQO52Tzik/
         ATBI9bwV4etsz4+/kpZuBEjMPS5jcLm/m7bCq0XEI2SiPHPIh1Bl3sUirMsbpZTw/BJz
         MqAnrdqYQK/3FG3g8DYA7EJ4Z0lq8ln8q2PaQPDp/4FDcYEApXA+99+i0Wo5p06xb3sW
         qYjczrrNJpfMt0e1q6PiFl6kjhIIRs/1ydksnsyyVbTJnt0xCEuJbXG/bvE/YlwS4TK5
         92CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5DdIb7caJKIVHR38EDEC3oy5CdMMDVm1Jnwd54EA0OE=;
        b=tRJPBXoHfIFFwKvuzXeF3wyvCdl+KbXd8EYwEb1gfPeYzw+eie5ChPY9zlm20+zcoa
         HIOR5Zy52LdQT6rS7c7oKzv+opWZnIyXCbWmeKL5YplG3t4yCyxbUTpev+MyN11C2BWD
         ZAe+PKLR8quXXpM9qIUGGKH3tvJFKHQVXi63dhd3ot9skFSozkzO/B/5VxwQO7XLo+XI
         O+Mm03EMXPm4Q3By6K2/FVAz8XtZgdRWvSgZDImYNJHw97zu3CpMHeSdq6Y7we04eEgN
         bDqg3dId5Xk/SRw6ZU2AgxRCaj4DY6uccl7IJzK7ZMLs+t5WeLSE9jr1WYyKHGT1Yji4
         QK1w==
X-Gm-Message-State: AOAM532PsFWSJd/1P1xMYXvgbX1Jp8r9PIZQZ7t5JMYl0lbZn1UBAYK0
        O6NrmOcC7lf1WlDsE4h/E//SN8poHKM=
X-Google-Smtp-Source: ABdhPJwJM71Lnf5SNTjBV9O13f5FVFZ2EFgpom4FI3mZ3owzvtOIxgSYvi52ogjmu4pNa1yDdIoRSw==
X-Received: by 2002:a17:90b:4c47:: with SMTP id np7mr122192pjb.26.1618321359681;
        Tue, 13 Apr 2021 06:42:39 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id l22sm100465pjc.13.2021.04.13.06.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:42:39 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 2/2] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Tue, 13 Apr 2021 23:42:23 +1000
Message-Id: <20210413134223.1691892-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210413134223.1691892-1-npiggin@gmail.com>
References: <20210413134223.1691892-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

irq_work's use of the DEC SPR is racy with guest<->host switch and guest
entry which flips the DEC interrupt to guest, which could lose a host
work interrupt.

This patch closes one race, and attempts to comment another class of
races.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 12 ++++++++++++
 arch/powerpc/kernel/time.c      | 10 ----------
 arch/powerpc/kvm/book3s_hv.c    | 15 +++++++++++++++
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8dd3cdb25338..8c2c3dd4ddba 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -97,6 +97,18 @@ extern void div128_by_32(u64 dividend_high, u64 dividend_low,
 extern void secondary_cpu_time_init(void);
 extern void __init time_init(void);
 
+#ifdef CONFIG_PPC64
+static inline unsigned long test_irq_work_pending(void)
+{
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, irq_work_pending)));
+	return x;
+}
+#endif
+
 DECLARE_PER_CPU(u64, decrementers_next_tb);
 
 /* Convert timebase ticks to nanoseconds */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b67d93a609a2..da995c5fb97d 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -508,16 +508,6 @@ EXPORT_SYMBOL(profile_pc);
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
  */
 #ifdef CONFIG_PPC64
-static inline unsigned long test_irq_work_pending(void)
-{
-	unsigned long x;
-
-	asm volatile("lbz %0,%1(13)"
-		: "=r" (x)
-		: "i" (offsetof(struct paca_struct, irq_work_pending)));
-	return x;
-}
-
 static inline void set_irq_work_pending_flag(void)
 {
 	asm volatile("stb %0,%1(13)" : :
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 48df339affdf..bdc24e9cb096 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3708,6 +3708,18 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	if (!(vcpu->arch.ctrl & 1))
 		mtspr(SPRN_CTRLT, mfspr(SPRN_CTRLF) & ~1);
 
+	/*
+	 * When setting DEC, we must always deal with irq_work_raise via NMI vs
+	 * setting DEC. The problem occurs right as we switch into guest mode
+	 * if a NMI hits and sets pending work and sets DEC, then that will
+	 * apply to the guest and not bring us back to the host.
+	 *
+	 * irq_work_raise could check a flag (or possibly LPCR[HDICE] for
+	 * example) and set HDEC to 1? That wouldn't solve the nested hv
+	 * case which needs to abort the hcall or zero the time limit.
+	 *
+	 * XXX: Another day's problem.
+	 */
 	mtspr(SPRN_DEC, vcpu->arch.dec_expires - mftb());
 
 	if (kvmhv_on_pseries()) {
@@ -3822,6 +3834,9 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vc->in_guest = 0;
 
 	mtspr(SPRN_DEC, local_paca->kvm_hstate.dec_expires - mftb());
+	/* We may have raced with new irq work */
+	if (test_irq_work_pending())
+		set_dec(1);
 	mtspr(SPRN_SPRG_VDSO_WRITE, local_paca->sprg_vdso);
 
 	kvmhv_load_host_pmu();
-- 
2.23.0

