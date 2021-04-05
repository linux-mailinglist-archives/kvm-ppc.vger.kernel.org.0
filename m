Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2939F353AA0
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhDEBVe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbhDEBVd (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:21:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EA2C061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:21:26 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h20so4927144plr.4
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eg/LONsL/v52XjsVvWJ/gHvuI8LKJE3Kwm8pO3cmUh0=;
        b=d+yzFvdJsE6Udw/oxnGd3ktn5ac7k831rkFpUl8FtxS001A2LxpL5O7ag2EL8uzCX3
         oNP9V76IiCg8Yt/mREBeiXENpwdVugAk1mYOOibYGRzjwfY4z35OqXiOQtQqTlzO6FKE
         SyjYiAygNkZNZNDg8mNnXq6bVYFkWPvmDrRnrp0pyRHGaDY+X2np7tMi+8n2E9Ybjujs
         hIOCTF6iS1bPz3WidEreQ2IbdV5terOn84aWpepT/gHuJF+7tHTPjDSA6XM2crwJwiAb
         KM5wrSLH/b4XtULkAs2qwB1XjUZO87BJ1zfrGzvLV24U11X42SLmEYC7Efj3q0cGu9rg
         CoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eg/LONsL/v52XjsVvWJ/gHvuI8LKJE3Kwm8pO3cmUh0=;
        b=YHQGx38AdWtgfU8q4LeMlBAii59mNRFTRxHZm7rDyXRDWLgkiXcHRgJMe+pFTBCr3n
         Guk+OlAvZvqzSkQk6tULS4wvfIeFV0tQFAHap+e6IdAhu/qH6S5irFrKyCPmONApsNDP
         nmaHwoqFXpFkfwl/GWKtBoZ92XEbKOG7S4XspX8xjEcHreFzK6q2GnG0wL7D7xq695OG
         W8loxI++Q1VfncfUT8zhA/KMwlkoZez11S0T2JW+8ZHaLG9uaj3U3JOKrgbGfOhF2gMU
         rOF83GAFuCThz5QvzgAtI/8I5KDtyTSXGM4+Vy+ek6goNaaBT0kXVsiq1XZEVhsUgIXU
         7lZw==
X-Gm-Message-State: AOAM531QyDr1xu+8aB9uX+WScOZc4E85z6ooxs4Bs2FtsL7C9NrGeMhu
        Z0ophRY0yqm3EUX8j/Ih9+qIftjsaJqMKg==
X-Google-Smtp-Source: ABdhPJwuC5NMjyPrlIoyrCpfwlN5Tc7wQeInmrVcBhfZFtuqGaK5f1sraFyGvnd4fEdyS7KGbpZQpw==
X-Received: by 2002:a17:902:780c:b029:e6:9193:56e2 with SMTP id p12-20020a170902780cb02900e6919356e2mr21811789pll.39.1617585686267;
        Sun, 04 Apr 2021 18:21:26 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:21:26 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 24/48] KVM: PPC: Book3S HV P9: Use large decrementer for HDEC
Date:   Mon,  5 Apr 2021 11:19:24 +1000
Message-Id: <20210405011948.675354-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On processors that don't suppress the HDEC exceptions when LPCR[HDICE]=0,
this could help reduce needless guest exits due to leftover exceptions on
entering the guest.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/time.h | 2 ++
 arch/powerpc/kernel/time.c      | 1 +
 arch/powerpc/kvm/book3s_hv.c    | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 8dd3cdb25338..68d94711811e 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -18,6 +18,8 @@
 #include <asm/vdso/timebase.h>
 
 /* time.c */
+extern u64 decrementer_max;
+
 extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b67d93a609a2..fc42594c8223 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -89,6 +89,7 @@ static struct clocksource clocksource_timebase = {
 
 #define DECREMENTER_DEFAULT_MAX 0x7FFFFFFF
 u64 decrementer_max = DECREMENTER_DEFAULT_MAX;
+EXPORT_SYMBOL_GPL(decrementer_max); /* for KVM HDEC */
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index f2aefd478d8c..3029ffb4b792 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3675,7 +3675,8 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 		vc->tb_offset_applied = 0;
 	}
 
-	mtspr(SPRN_HDEC, 0x7fffffff);
+	/* HDEC must be at least as large as DEC, so decrementer_max fits */
+	mtspr(SPRN_HDEC, decrementer_max);
 
 	switch_mmu_to_host_radix(kvm, host_pidr);
 
-- 
2.23.0

