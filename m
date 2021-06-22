Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E99B3B021C
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Jun 2021 12:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFVLBv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Jun 2021 07:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhFVLBu (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Jun 2021 07:01:50 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C33AC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t13so4956688pgu.11
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Jun 2021 03:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUzv02m3WyQdws3Qgp4amAHiWiokFDfVHQvCWRmFqHM=;
        b=GTHYUMdCyOF1KQqSl0K5jEm5GzzKLvbO1X/yqE+rBjTWMdlPvvwl3uuRz52Idcf7h4
         a6LpRSQEcw5mzC6xtKvzimEzNRFTzjR3j/3lMz+EHPqIl2W//ykkZZTnw2dh6Xl/XRZH
         pl9rYK2/70slHq9n/cHMhXYXmITBkridNE7/wFTEdJ35zZn2KqS0sIqXy6TYZm9TloGY
         WDmG0yYQfK8lmh+R02KKWOz1P00878mwLcZB74atHbNONKETQAxTtS0iiOjAEEd9Qg1W
         sOyImA0i7gp9tw303kBikAVOpbT8Fm0oDeHZ8I72sGW3Ahxy4UX2nEXSvKc98//vFVb4
         UWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUzv02m3WyQdws3Qgp4amAHiWiokFDfVHQvCWRmFqHM=;
        b=FLu4QmAAG5eILrR4jOJ0gNJPfR4Hl0WBsTBOLRup64Qfer4lf+BlaGOxyLkYicg1iy
         8b2DGu6VFk9pt8F7wrWaw9Rr9rG5weLOqhnD/oHn/eFgR41E9SNyYrb+YHHXPrEfAWd6
         doD42/nULvqUKJZE/1KUK6HlpbvtGXl7jccJllFM/5EdEJ42+l/5mhueMXJ4lZKXBrr4
         FzAWsOtUYi4DqitZt38BY6HUIpEkUng2fmv+o4BLt4fd9/vSC9JNcSS5ht/nGf9qj5rs
         PMDXdCKR8r1My+RE4Rpdm+cfxOaSZsJKAyetlRkmxBG43vnoMaegq+O1KqMItYnY59GN
         07NQ==
X-Gm-Message-State: AOAM531zsuAUJ4wKYoqfezM2CctpykJSyvDo6VvjBCt2/dpu79bGMWrI
        opZulaEAu4OD55NzqGZeakW5fBhBGK8=
X-Google-Smtp-Source: ABdhPJyNHd+Vi+MtEDpSPdqHCS54Wj74xSL4OhiaTOxGBLdAYM8yfNqMf9XAYT9hRkaLejYTFH8oEA==
X-Received: by 2002:a63:530a:: with SMTP id h10mr3254202pgb.98.1624359574955;
        Tue, 22 Jun 2021 03:59:34 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id l6sm5623621pgh.34.2021.06.22.03.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:59:34 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 41/43] KVM: PPC: Book3S HV Nested: Avoid extra mftb() in nested entry
Date:   Tue, 22 Jun 2021 20:57:34 +1000
Message-Id: <20210622105736.633352-42-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210622105736.633352-1-npiggin@gmail.com>
References: <20210622105736.633352-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

mftb() is expensive and one can be avoided on nested guest dispatch.

If the time checking code distinguishes between the L0 timer and the
nested HV timer, then both can be tested in the same place with the
same mftb() value.

This also nicely illustrates the relationship between the L0 and nested
HV timers.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/kvm_asm.h  |  1 +
 arch/powerpc/kvm/book3s_hv.c        | 12 ++++++++++++
 arch/powerpc/kvm/book3s_hv_nested.c |  5 -----
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_asm.h b/arch/powerpc/include/asm/kvm_asm.h
index fbbf3cec92e9..d68d71987d5c 100644
--- a/arch/powerpc/include/asm/kvm_asm.h
+++ b/arch/powerpc/include/asm/kvm_asm.h
@@ -79,6 +79,7 @@
 #define BOOK3S_INTERRUPT_FP_UNAVAIL	0x800
 #define BOOK3S_INTERRUPT_DECREMENTER	0x900
 #define BOOK3S_INTERRUPT_HV_DECREMENTER	0x980
+#define BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER	0x1980
 #define BOOK3S_INTERRUPT_DOORBELL	0xa00
 #define BOOK3S_INTERRUPT_SYSCALL	0xc00
 #define BOOK3S_INTERRUPT_TRACE		0xd00
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9d8277a4c829..7cb9e87b50b7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1410,6 +1410,10 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	run->ready_for_interrupt_injection = 1;
 	switch (vcpu->arch.trap) {
 	/* We're good on these - the host merely wanted to get our attention */
+	case BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER:
+		WARN_ON_ONCE(1); /* Should never happen */
+		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
+		fallthrough;
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
 		vcpu->stat.dec_exits++;
 		r = RESUME_GUEST;
@@ -1737,6 +1741,12 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		vcpu->stat.ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
+	/* These need to go to the nested HV */
+	case BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER:
+		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
+		vcpu->stat.dec_exits++;
+		r = RESUME_HOST;
+		break;
 	/* SR/HMI/PMI are HV interrupts that host has handled. Resume guest.*/
 	case BOOK3S_INTERRUPT_HMI:
 	case BOOK3S_INTERRUPT_PERFMON:
@@ -3855,6 +3865,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	if (next_timer < time_limit)
 		time_limit = next_timer;
+	else if (*tb >= time_limit) /* nested time limit */
+		return BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER;
 
 	vcpu->arch.ceded = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 5a534f7924f2..a92808a927ff 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -361,11 +361,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
 	do {
-		if (mftb() >= hdec_exp) {
-			vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
-			r = RESUME_HOST;
-			break;
-		}
 		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, l2_hv.lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
-- 
2.23.0

