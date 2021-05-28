Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0CF393F73
	for <lists+kvm-ppc@lfdr.de>; Fri, 28 May 2021 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhE1JKY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 28 May 2021 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhE1JKE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 28 May 2021 05:10:04 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C891C061343
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:26 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 6so2055362pgk.5
        for <kvm-ppc@vger.kernel.org>; Fri, 28 May 2021 02:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xa+KTVmTLR+Dc7vNM9tn+PVTc2AsrMj7jOMC0lFNgZo=;
        b=Kzo74kClKFb7Wx6DJEGXOMDvvFzpo9+apJ6PUSW164olFjm6IMUJG8J6fnuxyGd4XQ
         uMXlg+e8tn4CrMH4jrdZsqS5fP6i8wi+qP+kX7XSopZUwI9oTBrYL/54/PqQt1V9A5Kb
         wftMhPs+t1965mHWUWWDQZ2STnhx4FUSUz+r7DLVOmCYNLLkHrYnFKBlntepo3G2xfki
         E9PQ9pJiTWvfkjTHKB0yoT5RQXEpV/Dv0dI5TEIYg+bLGWJuOpGDQy7qdU80s5pDFCdn
         qOKnYnGLt50tvLzRHZen5+t6ZWPLDFCog/si3QbonhQdaLInGWPRJv+0ZwAk4sERP2cl
         BOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xa+KTVmTLR+Dc7vNM9tn+PVTc2AsrMj7jOMC0lFNgZo=;
        b=PGmzaGHZ7V9lp0+gY+pZPAvN4xJqgDSPYweMpzAmrJFDPcOWOjGtr6DFdmOqtx0jw3
         LIVDxCC/sb6vc//FQH10WysDelDlY6Lvm0Jx8cbY6ux29Sn1mg1oXYllcmv5A66Sx+yZ
         5kpW5+T0QEbGjaakIrDHGeSsNHsPxCxvqpOCt3Bcsuwh+r/PLvOFH3gukkE/JtEmAoHF
         hgtRIsmWnhqCCV3u1CU6LLf1nTtYIhMsLNjyUJVauUUEDCameD5ZYgClfuZUjGqhjT98
         2jdS3EwXg4c5eGyN6btl6xx/iC/NOI+zaPoKFgJEg4JxaVg+mXfSxlrfPIl9V7PNr+q+
         tt+A==
X-Gm-Message-State: AOAM533O8hORZku7tNcqesHT8nSzd1mxinPXAhIEQoDkNJW7E0vWSKJH
        aQO0y9dCq3snrkNnMR4HQlCOqUlRjkM=
X-Google-Smtp-Source: ABdhPJxLw3Aew6yQ7faTWyQ992qB3bCtfNkVHHGH6Yn4+Oiy8xO5vh68VX7OLrZIW6Hdkxjg/wpfig==
X-Received: by 2002:a63:1608:: with SMTP id w8mr7855865pgl.259.1622192905473;
        Fri, 28 May 2021 02:08:25 -0700 (PDT)
Received: from bobo.ibm.com (124-169-110-219.tpgi.com.au. [124.169.110.219])
        by smtp.gmail.com with ESMTPSA id a2sm3624183pfv.156.2021.05.28.02.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 02:08:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v7 10/32] KVM: PPC: Book3S HV P9: Reduce irq_work vs guest decrementer races
Date:   Fri, 28 May 2021 19:07:30 +1000
Message-Id: <20210528090752.3542186-11-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210528090752.3542186-1-npiggin@gmail.com>
References: <20210528090752.3542186-1-npiggin@gmail.com>
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
index 466d62b35b6a..d82ff7fe8ac7 100644
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

