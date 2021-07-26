Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25FD3D51DC
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Jul 2021 05:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhGZDME (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 25 Jul 2021 23:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhGZDME (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 25 Jul 2021 23:12:04 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61B5C061757
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c11so9968388plg.11
        for <kvm-ppc@vger.kernel.org>; Sun, 25 Jul 2021 20:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uO2q8xALjPGGI79F4bk9pgeAW2H5oBKaXR5DgIXBdNY=;
        b=BRSoxDopPSvAk2THcmNSXnA1oZeWbmRQD4ntwoyt3nDzlBuPO7FMzbiLuayIFWNVCm
         ChPhBGyfKEX75npSq5K5Qi++FILtw3ri+602fK5u/bEzdHgxAYz5YjcAozn395bbJz0o
         yCQ7+P3kwUKkQsMEF/cOX7nFFe3zBognZ3WOZBdkKMr7Ug0W/ISdrKQewnZu/WQY46sF
         WVpoO0VEySnSeD4XBtxp4q/hUz5s+GfXP/InX4WLupEucB4dzyEl4RcKPLjGblR/laQd
         PWElyCybjbOTkS33XeCwsTYVRlpd8nuiloINVMEka/uWftlKveDSWtDxB+Sj9lcDhl6i
         N2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uO2q8xALjPGGI79F4bk9pgeAW2H5oBKaXR5DgIXBdNY=;
        b=mxCgCC11G6DZzCiFYeP9oc1gYVnyaZ7gnhqcGrSyHglsKAEF0n8+Wm+jjMETrR17FI
         WppjuiDp+cfCvbCKrUV4nSiqIyJKJ+QoC1bkLv0eRmhHfC+EwQSzPyl/rLZnUKufwoCi
         eRd9bT77FYnabe0AMSYOKPuOEJ1N0nV377WygrPF110LoD8jsGxpeT/X8jeGqRruBRtn
         IpmljdY7QPbNSrZyG068udkxjnkNAtQHVOBtV16CC9XqSUmvlJlJgyeDXu5ptZLrfaTE
         yzmYBjaVXXsEfcn3Hbjom0YHYBHKSyKYj4rRu1TU1J1n7cpvmprTpp5xgrelXKFkmYbu
         xVUA==
X-Gm-Message-State: AOAM5313cMy5aamfc55Onf5PKlp3vusgE8kk7d/RMR8nVum6yNDJzUyT
        OA6PmQGnM9j/CCCSGwm0/VjBfGgEd24=
X-Google-Smtp-Source: ABdhPJxPrvxDmXyBJyR9M09fENlyIpZ+o/+PW2SxX4P4b7L7K5IQ+P028QCajZoW+tkGd2ZhAWRGWw==
X-Received: by 2002:a63:1944:: with SMTP id 4mr16115546pgz.306.1627271553272;
        Sun, 25 Jul 2021 20:52:33 -0700 (PDT)
Received: from bobo.ibm.com (220-244-190-123.tpgi.com.au. [220.244.190.123])
        by smtp.gmail.com with ESMTPSA id p33sm41140341pfw.40.2021.07.25.20.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 20:52:33 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v1 47/55] KVM: PPC: Book3S HV Nested: Avoid extra mftb() in nested entry
Date:   Mon, 26 Jul 2021 13:50:28 +1000
Message-Id: <20210726035036.739609-48-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210726035036.739609-1-npiggin@gmail.com>
References: <20210726035036.739609-1-npiggin@gmail.com>
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
index 3e5c6b745394..b95e0c5e5557 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1491,6 +1491,10 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
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
@@ -1821,6 +1825,12 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
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
@@ -3955,6 +3965,8 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 		return BOOK3S_INTERRUPT_HV_DECREMENTER;
 	if (next_timer < time_limit)
 		time_limit = next_timer;
+	else if (*tb >= time_limit) /* nested time limit */
+		return BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER;
 
 	vcpu->arch.ceded = 0;
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index fad7bc8736ea..322064564260 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -397,11 +397,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
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

