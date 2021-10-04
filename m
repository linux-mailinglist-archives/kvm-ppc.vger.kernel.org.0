Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A187421381
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbhJDQEe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbhJDQEe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:04:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22254C061746
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:02:45 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b22so217616pls.1
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iyZ5LHFchUzwewehQfyXIN1Gtjf00pJhqWY3AC6un9o=;
        b=RUJnCCc3E/nnL6wYPHxLPvUyXUOvCO5MtKmpet1oulLn3lO2XUdE4E0YHiz1ESLSmo
         jZm90E33B0KQ7Zn8KlzCI+l5wUs+YdNczQQcZL6rilJ94mf5WIm/Fs7ixVZKH6XxapvN
         7DTX/bxqlkyTmXjFbqqwXRfxPBxZVwL7G/5lup1fPPgtsulX+a7+9VbsAtfQ5DNLbpdb
         SozuhhCB9VyW/dmE9QyLxipU8GxQq7UcYwmoPD0YpKjs1g/3Fx7aQOsXJiaD6Mu2fslO
         I9KSq4ON1foXvgDiER8Sx4iA+KwHTQ51v9mDbKtAztBlSFfBNTuV2Pkz0s2GXB81TJTk
         Su4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iyZ5LHFchUzwewehQfyXIN1Gtjf00pJhqWY3AC6un9o=;
        b=imQDzsW604BGkUO6ln/LL54mBcn5IytFNsoHPRViI/CzRhyL1eLrUK2p8ZYT8AQwMm
         e29EXDSsMmIkc0Y1f19+YBxftPPWZZWscSUCsa7D1w8EaL2w+55abBKNIdz5ySG8+0Q7
         rl4ohzZWsuQg17/tlrspwD/PWBm78lPTZ3jO/vbTq4Z1tOMOrrsn0Jt/QuUw0Z0DBbsI
         USgnj9jWeKS7Afvqcxg1fNSjFDgUj371PCksi8EMfHESDZjKktfYw5S1Ru5rkJkaPWYK
         /r0LCYEkIHDRHIGumR9GFH1DN1OZezIyryF0Ds+hy1Z7As351zxXBG3WMoa4d5WijitG
         7nyA==
X-Gm-Message-State: AOAM531HqVmwX0/DWi17ZD4Sc3t6kNdFiYRmVHkAM3hv2XXFDnEHRWCv
        E4CaGmueOhHG0IeXFNukoiNIJCHKIbU=
X-Google-Smtp-Source: ABdhPJx9dS/yuRqgplT1tXygYaE+tzgDGvHd9GbuxXoPKZfj4fTAVaNjWT/6gRQl7sjMg39gLsnGDw==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr38111339pjb.206.1633363364512;
        Mon, 04 Oct 2021 09:02:44 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:02:44 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 43/52] KVM: PPC: Book3S HV Nested: Avoid extra mftb() in nested entry
Date:   Tue,  5 Oct 2021 02:00:40 +1000
Message-Id: <20211004160049.1338837-44-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
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
index d2a9c930f33e..342b4f125d03 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1486,6 +1486,10 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
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
@@ -1814,6 +1818,12 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
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
@@ -3975,6 +3985,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	if (next_timer < time_limit)
 		time_limit = next_timer;
+	else if (*tb >= time_limit) /* nested time limit */
+		return BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER;
 
 	vcpu->arch.ceded = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 7bed0b91245e..e57c08b968c0 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -375,11 +375,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	vcpu->arch.ret = RESUME_GUEST;
 	vcpu->arch.trap = 0;
 	do {
-		if (mftb() >= hdec_exp) {
-			vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
-			r = RESUME_HOST;
-			break;
-		}
 		r = kvmhv_run_single_vcpu(vcpu, hdec_exp, lpcr);
 	} while (is_kvmppc_resume_guest(r));
 
-- 
2.23.0

